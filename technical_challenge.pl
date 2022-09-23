#! /usr/bin/perl

# open the file which name is passed as arg (unlike Bash, script name is $0 not @ARGV[0])
my ($filename) = @ARGV; # Similar to my $filename = @ARGV[0], becomes nicer when you have multiple arguments
if (not defined $filename) {
    die "ERR >> You must provide the text file name as argument\n";
}
open(FILE, '<', $filename) or die "ERR >> Couldn't open file <$filename> with error => $!\n";

# initialize a <tuple?> to contain the counters
# maybe think about transforming it to an "object" kinda type
my ($lines_count, $words_count, $char_count) = (0, 0, 0);

while(<FILE>) {                                 # read the file line by line
    $lines_count++;
    $char_count += length($_);                  # $_ contains the content of the current line
                                                # Perl will use $_ by default so "length" alone was also correct
    $words_count += scalar(split(/\s+/, $_));   # explain \s+
}

close(FH);

if (defined $lines_count && defined $words_count && defined $char_count) {
    print(".+* The file contains *+.\n\t$lines_count lines\n\t$words_count words\n\t$char_count characters\n");
} else {
    die "ERR >> Couldn't extract file's stats";
}