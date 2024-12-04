#!/usr/bin/env perl -w
use strict;

use Data::Dumper;

my $matrix = [map { chomp; [split //] } <>];

my $part1 = 0;
my @pattern = split //, "XMAS";
for my $r (0..$#{$matrix}) {
  for my $c (0..$#{$matrix->[$r]}) {
    if ($matrix->[$r][$c] ne "X") {
      next;
    }

    foreach my $dir ([-1, 0], [1, 0], [0, -1], [0, 1], [-1, -1], [-1, 1], [1, -1], [1, 1]) {
      my ($dr, $dc) = @$dir;
      my ($nr, $nc) = ($r + $dr, $c + $dc);

      my $ok = 1;

      for my $s (1..$#pattern) {
        if ($nr < 0 || $nr > $#$matrix || $nc < 0 || $nc > $#{$matrix->[$r]}) {
          $ok = 0;
          last;
        }

        if ($matrix->[$nr][$nc] ne $pattern[$s]) {
          $ok = 0;
          last;
        }
        ($nr, $nc) = ($nr + $dr, $nc + $dc);
      }

      if ($ok) {
        $part1++;
      }
    }
  }
}

my $part2 = 0;
for my $r (0..$#{$matrix}) {
  for my $c (0..$#{$matrix->[$r]}) {
    if ($matrix->[$r][$c] ne "A") {
      next;
    }

    my @pairs = (
      [[-1, -1], [1, 1]],
      [[-1, 1], [1, -1]],
      [[1, 1], [-1, -1]],
      [[1, -1], [-1, 1]],
    );

    my $matches = 0;
    foreach my $pair (@pairs) {
      my ($dir1, $dir2) = ($pair->[0], $pair->[1]);
      my ($mdr, $mdc) = ($dir1->[0], $dir1->[1]);
      my ($mr, $mc) = ($r + $mdr, $c + $mdc);
      my ($sdr, $sdc) = ($dir2->[0], $dir2->[1]);
      my ($sr, $sc) = ($r + $sdr, $c + $sdc);

      if ($mr < 0 || $mr >= @{$matrix} || $mc < 0 || $mc >= @{$matrix->[$mr]} || $sr < 0 || $sr >= @{$matrix} || $sc < 0 || $sc >= @{$matrix->[$sr]}) {
        next;
      }

      if ($matrix->[$mr][$mc] eq "M" && $matrix->[$sr][$sc] eq "S") {
        $matches++;
      }
    }

    if ($matches > 1) {
      $part2++;
    }
  }
}

print("Part 1: $part1\n");
print("Part 2: $part2\n");
