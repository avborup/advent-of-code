#!/usr/bin/env perl -w
use strict;

use List::Util qw(sum);

my @nums = join("", <>) =~ /-?\d+/g;
my (@l1, @l2) = ();
while (@nums) {
  push(@l1, shift @nums);
  push(@l2, shift @nums);
}

@l1 = sort { $a <=> $b } @l1;
@l2 = sort { $a <=> $b } @l2;

my $part1 = sum(map { abs($l2[$_] - $l1[$_]) } 0..$#l1);
print("Part 1: $part1\n");

my %scores = map { $_ => 0 } @l2;
$scores{$_}++ for @l2;

my $part2 = sum(map { $_ * ($scores{$_} // 0) } @l1);
print("Part 2: $part2\n");
