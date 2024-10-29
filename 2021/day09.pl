#!/usr/bin/env perl -w
use strict;

use List::Util qw(all sum product);
use Math::Complex;
use Data::Dumper;

sub part_1 {
  my ($matrix) = @_;
  my @lows = find_low_points($matrix);
  return sum(map { 1 + $matrix->[$_->[0]][$_->[1]] } @lows);
}

sub part_2 {
  my ($matrix) = @_;
  my @lows = find_low_points($matrix);

  my %visited;

  my $dfs = sub {
    my ($start) = @_;
    my ($sr, $sc) = @$start;

    my @stack = ($start);
    $visited{cplx($sc, $sr)} = 1;
    my $size = 1;

    while (@stack) {
      my $v = pop @stack;
      my ($vr, $vc) = @$v;

      foreach my $adj (@{neighbours($vr, $vc, $matrix)}) {
        my ($ar, $ac) = @$adj;

        next if $visited{cplx($ac, $ar)};
        $visited{cplx($ac, $ar)} = 1;

        next unless $matrix->[$ar][$ac] < 9;

        $size++;
        push @stack, $adj;
      }
    }

    return $size;
  };

  my @sizes = map { $dfs->($_) } @lows;

  return product((sort { $b <=> $a } @sizes)[0..2]);
}

sub find_low_points {
  my ($matrix) = @_;
  my @lows;
  for my $r (0 .. $#$matrix) {
      for my $c (0 .. $#{$matrix->[$r]}) {
      my $height = $matrix->[$r][$c];
      my $adj = neighbours($r, $c, $matrix);
      push @lows, [$r, $c] if all { $height < $matrix->[$_->[0]][$_->[1]] } @$adj;
    }
  }
  return @lows;
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

my @matrix = map { [split //] } map { chomp; $_ } <>;
print("Part 1: ", part_1(\@matrix), "\n");
print("Part 2: ", part_2(\@matrix), "\n");
