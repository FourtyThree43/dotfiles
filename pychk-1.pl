#!/usr/bin/env perl

use 5.36.0;
use strict;
use warnings;

my $check_output = `find . -name '*.py' ! -name '*main*' ! -name '*test*' -exec pycodestyle --show-source --statistics {} +`;

my @lines = split(/\n/, $check_output);

foreach my $line (@lines) {
    if ($line =~ m|^./|) {
        my $line2 = shift(@lines);
        my $line3 = shift(@lines);
        chomp($line2, $line3);
        my ($filename, $line_num, $col_num, $error_code, $error_msg) = split(/:/, $line, 5);
        printf ":%s:%s:%s:%s\n%s\n%s\n", $filename, $line_num, $col_num, $error_code, $error_msg, $line2, $line3;
    } else {
        print "$line\n";
    }
}
