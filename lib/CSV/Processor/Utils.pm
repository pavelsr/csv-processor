package CSV::Processor::Utils;

=head1 SYNOPSIS

  use CSV::Processor::Utils qw( insert_after_index )
  # or CSV::Processor::Utils qw[:ALL];
  
  my $text = insert_after_index($index, $val_to_insert, $list)

=cut

use File::Basename;
use File::Spec;

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
    insert_after_index
    make_prefix
);
our %EXPORT_TAGS = ( 'ALL' => [ @EXPORT_OK ] );

=head2 insert_after_index

Insert element after particular index

Someone please add this function to L<List::MoreUtils>

    insert_after_index($index, $val_to_insert, $list)

=cut

sub make_prefix {
    my ($path, $prefix) = @_;
    my ($name,$path,$suffix) = fileparse($path, qw/csv CSV/);
    my $new_name =  $prefix.''.$name.''.$suffix;
    File::Spec->catfile($path, $new_name);
}

# sub insert_after_index ($$\@)
sub insert_after_index {
    my ($index, $val_to_insert, $list) = @_;
    return 0 if $#$list < $index;
    my @part1 = splice @$list, $index + 1;
    my @part2 = splice @$list;
    @$list = ( @part2, $val_to_insert, @part1 );
    return 1;
}

sub leave_only_digits {
    my $number = shift;
    $number =~ s/\D//g;
}


1;