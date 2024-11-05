#!/usr/bin/env perl -w
use strict;

use Data::Dumper;
use List::Util qw(max);

sub part_1 {
  my $paths = find_all_trajectories(@_);
  return max(map { map { $_->[1] } @$_ } @$paths);
}

sub part_2 {
  my $paths = find_all_trajectories(@_);
  return scalar @$paths;
}

sub find_all_trajectories {
  my @target = @_;
  my ($xmin, $xmax, $ymin, $ymax) = @target;

  my @paths;
  for my $vx (sqrt(2 * $xmin)..$xmax) {
    for my $vy ($ymin..abs($ymin)) {
      my $path = fire(\@target, $vx, $vy);
      push @paths, $path if $path;
    }
  }
  return \@paths;
}

sub fire {
  my ($target, $vx, $vy) = @_;
  my ($xmin, $xmax, $ymin, $ymax) = @$target;
  my ($x, $y) = (0, 0);

  my @path = ([$x, $y]);
  while ($x <= $xmax && $y >= $ymin) {
    $x += $vx; $y += $vy;

    $vx-- if $vx > 0;
    $vy--;

    push @path, [$x, $y];
    if ($x >= $xmin && $x <= $xmax && $y >= $ymin && $y <= $ymax) {
      return \@path;
    }
  }

  return undef;
}

my @input = <> =~ /-?\d+/g;
print("Part 1: ", part_1(@input), "\n");
print("Part 2: ", part_2(@input), "\n");
