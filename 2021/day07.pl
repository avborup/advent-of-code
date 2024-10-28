#!/usr/bin/perl -w
use strict; use warnings;

use Data::Dumper;
use List::Util qw(min max sum);

sub part_1 {
  my $cost_function = sub {
    my ($crab, $target) = @_;
    return abs($crab - $target);
  };

  return find_min_cost(\@_, $cost_function);
}

sub part_2 {
  my $cost_function = sub {
    my ($crab, $target) = @_;
    my $steps = abs($crab - $target);
    return $steps * ($steps + 1) / 2
  };

  return find_min_cost(\@_, $cost_function);
}

sub find_min_cost {
  my ($crabs, $cost_function) = @_;

  my $min_fuel = "inf";
  for my $target (min(@$crabs) .. max(@$crabs)) {
    my $fuel = sum(map { $cost_function->($_, $target) } @$crabs);
    $min_fuel = min($min_fuel, $fuel);
  }

  return $min_fuel;
}

my @input = map { /\d+/g } <>;
print("Part 1: ", part_1(@input), "\n");
print("Part 2: ", part_2(@input), "\n");
