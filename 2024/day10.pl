#!/usr/bin/env perl -w
use strict;

use List::Util qw(sum);

my $matrix = [map { [split //] } map { chomp; $_ } <>];

my ($part1, $part2) = 0;
for my $bottom (find_bottom_points()) {
  my $tops = dfs($bottom);
  $part1 += scalar keys %$tops;
  $part2 += sum values %$tops;
}

print("Part 1: $part1\n");
print("Part 2: $part2\n");

sub dfs {
  my %tops;
  my @stack = @_;
  while (@stack) {
    my ($vr, $vc) = @{pop @stack};

    $tops{"$vr,$vc"} += 1 if $matrix->[$vr][$vc] == 9;

    for my $adj (@{neighbours($vr, $vc, $matrix)}) {
      my ($ar, $ac) = @$adj;
      next unless $matrix->[$ar][$ac] - $matrix->[$vr][$vc] == 1;
      push @stack, $adj;
    }
  }

  return \%tops;
}

sub find_bottom_points {
  my @lows;
  for my $r (0 .. $#$matrix) {
    for my $c (0 .. $#{$matrix->[$r]}) {
      push @lows, [$r, $c] if $matrix->[$r][$c] == 0;
    }
  }
  return @lows;
}

sub neighbours {
  my ($x, $y) = @_;
  my ($R, $C, @neigbours) = ($#$matrix, $#{$matrix->[0]});
  for my $dir ([-1, 0], [1, 0], [0, -1], [0, 1]) {
    my ($nx, $ny) = ($x + $dir->[0], $y + $dir->[1]);
    push @neigbours, [$nx, $ny] unless $nx < 0 || $nx > $R || $ny < 0 || $ny > $C;
  }
  return \@neigbours;
}
