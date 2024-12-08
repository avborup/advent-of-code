#!/usr/bin/env perl -w
use strict;

my $grid = [map { chomp; [split //] } <>];
my ($R, $C) = (scalar(@$grid), scalar(@{$grid->[0]}));

my %antennas;
for my $r (0..$R-1) {
  for my $c (0..$C-1) {
    push @{$antennas{$grid->[$r][$c]}}, [$r, $c] if $grid->[$r][$c] ne ".";
  }
}

sub add {
  my ($into, $r, $c) = @_;
  $into->{"$r,$c"} = 1 if $r >= 0 && $r < $R && $c >= 0 && $c < $C;
}

my (%part1, %part2);
for $a (keys %antennas) {
  for my $i (0..$#{$antennas{$a}}) {
    for my $j ($i+1..$#{$antennas{$a}}) {
      my ($r1, $c1, $r2, $c2) = (@{$antennas{$a}[$i]}, @{$antennas{$a}[$j]});
      my ($dr, $dc) = ($r2 - $r1, $c2 - $c1);

      add(\%part1, $r2 + $dr, $c2 + $dc);
      add(\%part1, $r2 - 2*$dr, $c2 - 2*$dc);
      add(\%part2, $r2 + $_*$dr, $c2 + $_*$dc) for -$R..$R;
    }
  }
}

print("Part 1: ", scalar keys %part1, "\n");
print("Part 2: ", scalar keys %part2, "\n");
