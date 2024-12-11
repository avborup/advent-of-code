#!/usr/bin/env perl -w
use strict;

use Data::Dumper;
use List::Util qw(sum);

my @stones = <> =~ /(\d+)/g;
print("Part 1: ", solve(25), "\n");
print("Part 2: ", solve(75), "\n");

sub solve {
  my %counts;
  $counts{$_}++ for @stones;

  my $iters = shift;
  for my $i (1..$iters) {
    my %new_counts;
    foreach my $stone (keys %counts) {
      $new_counts{$_} += $counts{$stone} for new_stones($stone);
    }
    %counts = %new_counts;
  }

  return sum values %counts;
}

sub new_stones {
  my $stone = shift;
  return 1 if ($stone == 0);
  return split_half($stone) if digits($stone) % 2 == 0;
  return $stone * 2024;
}

sub split_half {
  my $n = shift;
  my $half_digits = digits($n) / 2;
  my $left = int($n / 10 ** $half_digits);
  my $right = $n % 10 ** $half_digits;
  return ($left, $right);
}

sub digits  { int(log(shift) / log(10)) + 1 }
