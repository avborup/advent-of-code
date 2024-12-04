#!/usr/bin/env perl -w
use strict;

my $matrix = [map { chomp; [split //] } <>];
my ($R, $C) = (scalar(@$matrix), scalar(@{$matrix->[0]}));

my ($part1, @pattern) = (0, split(//, "XMAS"));
for my $r (0..$R-1) {
  for my $c (0..$C-1) {
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
for my $r (1..$R-2) {
  for my $c (1..$C-2) {
    next if $matrix->[$r][$c] ne "A";

    my $matches = 0;
    foreach my $corner ([-1, -1], [-1, 1], [1, 1], [1, -1]) {
      my $m = $matrix->[$r + $corner->[0]][$c + $corner->[1]];
      my $s = $matrix->[$r - $corner->[0]][$c - $corner->[1]];
      $matches++ if $m eq "M" && $s eq "S";
    }

    $part2++ if $matches >= 2;
  }
}

print("Part 1: $part1\n");
print("Part 2: $part2\n");
