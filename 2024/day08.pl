#!/usr/bin/env perl -w
use strict;

use Math::Complex;

my $grid = [map { chomp; [split //] } <>];
my ($R, $C) = (scalar(@$grid), scalar(@{$grid->[0]}));

my %antennas;
for my $r (0..$R-1) {
  for my $c (0..$C-1) {
    push @{$antennas{$grid->[$r][$c]}}, cplx($r, $c) if $grid->[$r][$c] ne ".";
  }
}

sub add {
  my ($into, $p) = @_;
  $into->{$p} = 1 if Re($p) >= 0 && Re($p) < $R && Im($p) >= 0 && Im($p) < $C;
}

my (%part1, %part2);
for my $antennas (values %antennas) {
  for my $i (0..$#$antennas) {
    for my $j ($i+1..$#$antennas) {
      my ($a, $b) = ($antennas->[$i], $antennas->[$j]);

      my $d = $a - $b;
      add(\%part1, $a + $d);
      add(\%part1, $a - 2*$d);
      add(\%part2, $a + $_*$d) for -$R..$R;
    }
  }
}

print("Part 1: ", scalar keys %part1, "\n");
print("Part 2: ", scalar keys %part2, "\n");
