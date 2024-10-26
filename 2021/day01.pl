#!/usr/bin/perl -w
use strict; use warnings;

use Data::Dumper;
use List::Util qw(sum);

sub part_1 {
  my @nums = @_;
  my $count = 0;

  for (my $i = 0; $i < @nums - 1; $i++) {
    my ($first, $second) = @nums[$i, $i + 1];

    if ($second > $first) {
      $count++;
    }
  }

  return $count;
}

sub part_2 {
  my @nums = @_;

  my @sums = ();
  for (my $i = 0; $i < @nums - 2; $i++) {
    push(@sums, sum(@nums[$i .. $i + 2]));
  }

  return part_1(@sums);
}

my @nums = map { chomp; $_ } <>;

print("Part 1: ", part_1(@nums), "\n");
print("Part 2: ", part_2(@nums), "\n");
