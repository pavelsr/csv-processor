# NAME

CSV::Processor - Set of different methods that adds new columns in csv files

# VERSION

version 1.00

# SYNOPSIS

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

# DESCRIPTION

Set of ready-to-use useful csv file processors based on [Text::AutoCSV](https://metacpan.org/pod/Text::AutoCSV) and other third-party modules

Also there is a command line utility, [csvproces](https://metacpan.org/pod/csvproces)

# AUTHORS

Pavel Serkov <pavelsr@cpan.org>

# add\_email

Try to extract email by website column using ["search\_until\_attempts" in Email::Extractor](https://metacpan.org/pod/Email::Extractor#search_until_attempts) (wrapper for this method)

    $bot->add_email(5);
    $bot->add_email(5, 6);
    $bot->add_email('URL');
    $bot->add_email('URL', 'EMAIL');
    $bot->add_email('URL', 'EMAIL', attempts => 5, human_numbering => 1);

# AUTHOR

Pavel Serikov <pavelsr@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2018 by Pavel Serikov.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
