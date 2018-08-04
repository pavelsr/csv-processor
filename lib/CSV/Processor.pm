package CSV::Processor;

#ABSTRACT: Set of different methods that adds new columns in csv files

=head1 DESCRIPTION

Set of ready-to-use useful csv file processors based on L<Text::AutoCSV> and other third-party modules

Also there is a command line utility, L<csvproces>


=head1 SYNOPSIS

    use CSV::Processor;
    my $bot = CSV::Processor->new( file => 'test.csv', has_column_names => 1 );    
    $bot->add_email(5, 6, %params);            # 5 and 6 are column numbers where input and output data located
    
    $bot->add_email('URL', 'EMAIL');  # 'URL' 'EMAIL' are field names where data will be stored
    
parameters

    C<file>
    C<encoding>
    C<column_names>
    C<human_numbering>
    C<eol>
    C<sep_char>
    C<prefix>
    C<verbose>
    
=head1 AUTHORS

Pavel Serkov <pavelsr@cpan.org>

=cut

use Text::AutoCSV;
use Email::Extractor;
use Regexp::Common;
use Carp;
use CSV::Processor::Utils qw( insert_after_index make_prefix);
use Data::Dumper;
use feature 'say';

sub new {
    my ( $class, %param ) = @_;
    
    my $prefix = $param{prefix} || 'p_' ;
    
    # $param{file} processor
    
    my $csv = Text::AutoCSV->new(
        in_file => $param{file},
        encoding => $param{encoding} || 'UTF-8', # || 'windows1251',
        out_file => make_prefix( $param{file}, $prefix ),
        out_encoding => 'UTF-8',
        verbose => $param{verbose} || 0
    );
    
    $param{auto_csv} = $csv;
    
    bless { %param }, $class;
}

sub auto_csv {
    shift->{auto_csv};
}

=head1 add_email

Try to extract email by website column using L<Email::Extractor/search_until_attempts>

    $bot->add_email(5);
    $bot->add_email(5, 6);
    $bot->add_email('URL');
    $bot->add_email('URL', 'EMAIL');
    $bot->add_email('URL', 'EMAIL', attempts => 5, human_numbering => 1);
    
=cut

sub add_email {
    my ($self, $in_field, $out_field, %params) = @_;
    
    $params{attempts} = 5 if !defined $params{attempts};
    
    my $crawler = Email::Extractor->new;

    if ( $in_field =~ /$RE{num}{int}/ && $out_field =~ /$RE{num}{int}/ ) {
        
        if ( $self->{human_numbering} || $params{human_numbering} ) {
            $in_field++;
            $out_field++;
        }
        say "Human numbering in use, first column index is 1 not 0" if $params{verbose};
        
        $self->auto_csv->set_walker_ar(
            sub {
                # do some stuff with $_[0]->[$in_field];
                my $row_arrayed = $_[0];
                my $emails = $crawler->search_until_attempts($row_arrayed->[$in_field] , $params{attempts});
                my $emails_str = join (',', @$emails);    
                say 'In : '.$row_arrayed->[$in_field].', out : '.$emails_str if $params{verbose};        
                insert_after_index($out_field - 1, $emails_str, $row_arrayed);
                return $row_arrayed;
            }    
        );
        
        $self->auto_csv->read();
        
    } else {
        
        # try to detect field names automatically
        my @fields = $csv->get_fields_names();
        
        say "Auto detected field names : ".join (',', @fields) if $params{verbose};
        
        $out_field = 'EMAIL' if !defined $out_field;
        
        $self->auto_csv->field_add_computed($out_field, sub {
            my $hr = $_[1];
            my $emails = $crawler->search_until_attempts($hr->{$in_field} , 5);
            my $emails_str = join (',', @$emails);
            say 'In : '.$row_arrayed->[$in_field].', out : '.$emails_str if $params{verbose};
            return $hr;
        });
        
    }
    
    $self->auto_csv->write();    
}

1;
