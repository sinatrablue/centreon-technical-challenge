#! /usr/bin/perl
# Help against typos and help finding the cause in case of errors
# (from what I read)
use warnings;
use strict;
use JSON; # Installed with cpan

# <my> restricts the variable to the current scope
# open the file which name is passed as arg (unlike Bash, script name is $0 not @ARGV[0])
my ($in_file, $out_file) = @ARGV; # Similar to in_file = @ARGV[0], out_file = @ARGV[1] ; would've been the same with <shift>
if (not defined $in_file) {
    die "ERR :::> You must provide a file name to read from as argument\n";
}
open(IN_F, '<', $in_file) or die "ERR :::> Couldn't open IN file <$in_file> with error => $!\n";
print("LOG :::> Opened IN file correctly\n");

# initialize a variables to contain the counters
my ($lines_count, $words_count, $char_count) = (0, 0, 0);

while(<IN_F>) {                                 # read the file line by line
    $lines_count++;
    $char_count += length($_);                  # $_ contains the content of the current line
                                                # Perl will use $_ by default so "length" alone was also correct
    $words_count += scalar(split(/\W+/, $_));   # Split the current line based on non "non-words" characters
}

close(IN_F);
print("LOG :::> Closed IN file\n");

if (defined $lines_count && defined $words_count && defined $char_count) {
    my $results = {
        Lines => $lines_count,
        Words => $words_count,
        Chars => $char_count
    };
    my $results_json = encode_json $results;

    # At this point "say $results_json" would've been enough but just for JSON manipulation
    $results = decode_json $results_json;
    my $output_string = ".+* The file contains *+.\n\t$results->{Lines} lines\n\t$results->{Words} words\n\t$results->{Chars} characters\n";

    if (defined $out_file) {
        open(OUT_F, '>', $out_file) or die "ERR :::> Couldn't open OUT file <$out_file> with error => $!\n";
        print OUT_F $output_string;
        close(OUT_F);
        print("LOG :::> Output file written correctly !\n");
    } else {
        print("LOG :::> No output file provided, printing file's stats directly :\n##############################\n");
        print($output_string);
    }
    
} else {
    die "ERR :::> Couldn't extract file's stats";
}