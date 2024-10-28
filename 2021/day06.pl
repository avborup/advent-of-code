#!/usr/bin/perl -w
use strict; use warnings;

use Data::Dumper;
use List::Util qw(sum);

sub part_1 {
  return simulate(\@_, 80);
}

sub part_2 {
  return simulate(\@_, 256);
}

sub simulate {
  my ($fish, $days) = @_;

  my @ages = (0) x 9;
  $ages[$_]++ for @$fish;

  for (1 .. $days) {
    my $spawned = shift @ages;
    push @ages, $spawned;
    $ages[6] += $spawned;
  }

  return sum(@ages);
}

my @input = map { /\d+/g } <>;
print("Part 1: ", part_1(@input), "\n");
print("Part 2: ", part_2(@input), "\n");
