#!/usr/bin/perl -w
use strict; use warnings;

use Data::Dumper;
use List::Util qw(sum);

sub part_1 {
  my @nums = @_;
  scalar grep { $nums[$_ + 1] > $nums[$_] } 0 .. $#nums - 1
}

sub part_2 {
  my @nums = @_;
  my @sums = map { sum(@nums[$_ .. $_ + 2]) } 0 .. $#nums - 2;
  part_1(@sums)
}

my @nums = map { chomp; $_ } <>;

print("Part 1: ", part_1(@nums), "\n");
print("Part 2: ", part_2(@nums), "\n");
