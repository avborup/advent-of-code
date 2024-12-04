#!/usr/bin/env perl -w
use strict;

use Data::Dumper;


my $matrix = [map { chomp; [split //] } <>];

my ($part1, $part2) = (0, 0);


print Dumper($matrix);

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

        print("nr: $nr, nc: $nc ", $matrix->[$nr][$nc], " ", $pattern[$s], "\n");
        if ($matrix->[$nr][$nc] ne $pattern[$s]) {
          $ok = 0;
          last;
        }
        ($nr, $nc) = ($nr + $dr, $nc + $dc);
      }
      print "ok: $ok";

      if ($ok) {
        $part1++;
      }
      print "\n"
    }
  }
}

print("Part 1: $part1\n");
print("Part 2: $part2\n");
