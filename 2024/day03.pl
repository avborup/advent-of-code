#!/usr/bin/env perl -w
use strict;

my $input = join("", <>);

my ($part1, $part2) = (0, 0);
my $do = 1;
while ($input =~ /(do\(\)|don't\(\)|mul\((\d+),(\d+)\))/g) {
  if    ($1 eq "do()")    { $do = 1; }
  elsif ($1 eq "don't()") { $do = 0; }
  else {
    $part1 += $2 * $3;
    $part2 += $2 * $3 if $do;
  }
}

print("Part 1: $part1\n");
print("Part 2: $part2\n");
