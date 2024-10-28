#!/usr/bin/perl -w
use strict; use warnings;

use Data::Dumper;
use List::Util qw(min max sum);

sub part_1 {
  my @crabs = @_;

  my $min_fuel = "inf";
  for my $target (min(@crabs) .. max(@crabs)) {
    my $fuel = sum(map { abs($_ - $target) } @crabs);
    $min_fuel = min($min_fuel, $fuel);
  }

  return $min_fuel;
}

sub part_2 {
  "?"
}

my @input = map { /\d+/g } <>;
print("Part 1: ", part_1(@input), "\n");
print("Part 2: ", part_2(@input), "\n");
