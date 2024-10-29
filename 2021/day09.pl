#!/usr/bin/env perl -w
use strict;

use List::Util qw(all sum);
use Data::Dumper;

sub part_1 {
  my @matrix = map { [split //] } @_;

  my @lows;
  for my $r (0 .. $#matrix) {
    for my $c (0 .. $#{$matrix[$r]}) {
      my $height = $matrix[$r][$c];
      my $adj = neighbours($r, $c, \@matrix);
      push @lows, [$r, $c] if all { $height < $matrix[$_->[0]][$_->[1]] } @$adj;
    }
  }

  return sum(map { 1 + $matrix[$_->[0]][$_->[1]] } @lows);
}

sub part_2 {
  "?"
}

sub neighbours {
  my ($x, $y, $matrix) = @_;
  my ($R, $C, @neigbours) = ($#$matrix, $#{$matrix->[0]});
  foreach my $dir ([-1, 0], [1, 0], [0, -1], [0, 1]) {
    my ($nx, $ny) = ($x + $dir->[0], $y + $dir->[1]);
    push @neigbours, [$nx, $ny] unless $nx < 0 || $nx > $R || $ny < 0 || $ny > $C;
  }
  return \@neigbours;
}

chomp(my @input = <>);
print("Part 1: ", part_1(@input), "\n");
print("Part 2: ", part_2(@input), "\n");
