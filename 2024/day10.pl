#!/usr/bin/env perl -w
use strict;

use Data::Dumper;
use Math::Complex;

my $matrix = [map { [split //] } map { chomp; $_ } <>];

my $part_1 = 0;
my $part_2 = 0;

my @lows = find_low_points($matrix);

my $dfs = sub {
  my %visited;
  my %tops;
  my ($start) = @_;
  my ($sr, $sc) = @$start;

  my @stack = ($start);
  $visited{cplx($sc, $sr)} = 1;

  while (@stack) {
    my $v = pop @stack;
    my ($vr, $vc) = @$v;

    if ($matrix->[$vr][$vc] == 9) {
      $tops{"$vc,$vr"} = 1;
    }

    foreach my $adj (@{neighbours($vr, $vc, $matrix)}) {
      my ($ar, $ac) = @$adj;

      next unless $matrix->[$ar][$ac] - $matrix->[$vr][$vc] == 1;

      next if $visited{"$ar,$ac"};
      $visited{"$ar,$ac"} = 1;

      push @stack, $adj;
    }
  }

  return scalar keys %tops;
};



foreach my $low (@lows) {
  my $res = $dfs->($low);
  print "Low: @$low -> $res\n";
  $part_1 += $res;
}

print("Part 1: ", $part_1, "\n");
print("Part 2: ", $part_2, "\n");

sub find_low_points {
  my ($matrix) = @_;
  my @lows;
  for my $r (0 .. $#$matrix) {
      for my $c (0 .. $#{$matrix->[$r]}) {
      my $height = $matrix->[$r][$c];
      push @lows, [$r, $c] if $height == 0;
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
