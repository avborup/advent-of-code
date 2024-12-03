#!/usr/bin/env perl -w
use strict;

my $input = join("", <>);

my ($part1, $part2) = (0, 0);
my $do = 1;
while ($input =~ /(mul|do|don't)\((?:(\d+),(\d+))?\)/g) {
  $do = 1 if $1 eq "do";
  $do = 0 if $1 eq "don't";

  if ($1 eq "mul") {
    $part1 += $2 * $3;
    $part2 += $2 * $3 if $do;
  }
}

print("Part 1: $part1\n");
print("Part 2: $part2\n");
