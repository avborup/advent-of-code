#!/usr/bin/perl -w
use strict; use warnings;

use Data::Dumper;
use List::Util qw(min max sum);

sub part_1 {
  my @input = @_;
  my @options = map { /\|(.*)/ } @input;
  my $matches = map { /\b(\w{2,4}|\w{7})\b/g } @options;
  return $matches;
}

sub part_2 {
  "?"
}

chomp(my @input = <>);
print("Part 1: ", part_1(@input), "\n");
print("Part 2: ", part_2(@input), "\n");
