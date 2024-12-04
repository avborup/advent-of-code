#!/usr/bin/env perl -w
use strict;

use Data::Dumper;

my $matrix = [map { chomp; [split //] } <>];
my ($R, $C) = (scalar(@$matrix), scalar(@{$matrix->[0]}));

my ($part1, @pattern) = (0, split(//, "XMAS"));
for my $r (0..$#{$matrix}) {
  for my $c (0..$#{$matrix->[$r]}) {
    foreach my $dir ([-1, 0], [1, 0], [0, -1], [0, 1], [-1, -1], [-1, 1], [1, -1], [1, 1]) {
      my $xmas = 1;
      for my $s (0..$#pattern) {
        my ($nr, $nc) = ($r + $s * $dir->[0], $c + $s * $dir->[1]);
        $xmas = 0, last if $nr < 0 || $nr >= $R || $nc < 0 || $nc >= $C;
        $xmas = 0, last if $matrix->[$nr][$nc] ne $pattern[$s];
      }

      $part1++ if $xmas;
    }
  }
}

my $part2 = 0;
for my $r (1..$#{$matrix}-1) {
  for my $c (1..$#{$matrix->[$r]}-1) {
    next if $matrix->[$r][$c] ne "A";

    my @pairs = (
      [[-1, -1], [1, 1]],
      [[-1, 1], [1, -1]],
      [[1, 1], [-1, -1]],
      [[1, -1], [-1, 1]],
    );

    my $matches = 0;
    foreach my $pair (@pairs) {
      my $m = $matrix->[$r + $pair->[0][0]][$c + $pair->[0][1]];
      my $s = $matrix->[$r + $pair->[1][0]][$c + $pair->[1][1]];
      $matches++ if $m eq "M" && $s eq "S";
    }

    $part2++ if $matches >= 2;
  }
}

print("Part 1: $part1\n");
print("Part 2: $part2\n");
