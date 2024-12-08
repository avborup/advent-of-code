#!/usr/bin/env perl -w
use strict;

use Data::Dumper;

my ($part1, $part2) = (0, 0);

my $grid = [map { chomp; [split //] } <>];
my ($R, $C) = (scalar(@$grid), scalar(@{$grid->[0]}));

my %antennas;
for my $r (0..$R-1) {
  for my $c (0..$C-1) {
    if ($grid->[$r][$c] ne "." && $grid->[$r][$c] ne "#") {
      push @{$antennas{$grid->[$r][$c]}}, [$r, $c];
    }
  }
}

my %antinodes;
for $a (keys %antennas) {
  for my $i (0..$#{$antennas{$a}}) {
    for my $j (0..$#{$antennas{$a}}) {
      next if $i == $j;
      my ($r1, $c1) = @{$antennas{$a}[$i]};
      my ($r2, $c2) = @{$antennas{$a}[$j]};

      my ($dr, $dc) = ($r2 - $r1, $c2 - $c1);
      my ($nr, $nc) = ($r2 + $dr, $c2 + $dc);

      my $s = 1;
      for ($s = -200; $s <= 200; $s++) {
        my ($nr, $nc) = ($r2 + $s * $dr, $c2 + $s * $dc);
        next if $nr < 0 || $nr >= $R || $nc < 0 || $nc >= $C;
        $antinodes{"$nr,$nc"} = 1;
      }
    }
  }
}


for my $r (0..$R-1) {
  for my $c (0..$C-1) {
    if ($grid->[$r][$c] ne ".") {
      print $grid->[$r][$c];
    } elsif (exists $antinodes{"$r,$c"}) {
      print "#";
    } else {
      print ".";
    }
  }
  print "\n";
}


$part1 = scalar(keys %antinodes);
print("Part 1: $part1\n");
print("Part 2: $part2\n");
