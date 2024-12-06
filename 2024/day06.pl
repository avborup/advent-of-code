#!/usr/bin/env perl -w
use strict;

use Data::Dumper;

my $matrix = [map { chomp; [split //] } <>];
my ($R, $C) = (scalar(@$matrix), scalar(@{$matrix->[0]}));

my $start;
for my $r (0..$R-1) {
  for my $c (0..$C-1) {
    if ($matrix->[$r][$c] eq "^") {
      $start = [$r, $c];
    }
  }
}

sub walk {
  my ($obs_r, $obs_c) = (shift // -1, shift // -1);

  my (%visited, %states);

  my ($r, $c) = @$start;
  my ($dr, $dc) = (-1, 0);

  while (1) {
    return (0, \%visited) if $r < 0 || $r >= $R || $c < 0 || $c >= $C;
    return (1, \%visited) if exists $states{"$r,$c,$dr,$dc"};

    $visited{"$r,$c"} = 1;
    $states{"$r,$c,$dr,$dc"} = 1;

    my ($nr, $nc) = ($r + $dr, $c + $dc);
    if (
      !($nr < 0 || $nr >= $R || $nc < 0 || $nc >= $C) &&
      $matrix->[$nr][$nc] eq "#" || ($nr == $obs_r && $nc == $obs_c)
    ) {
      ($dr, $dc) = ($dc, -$dr);
    } else {
      ($r, $c) = ($nr, $nc);
    }
  }
}

my ($looped, $visited) = walk();
print("Part 1: ", scalar keys %$visited, "\n");

my $part2 = 0;
for my $v (keys %$visited) {
  my ($r, $c) = split /,/, $v;
  next if $r == $start->[0] && $c == $start->[1];

  my ($looped) = walk($r, $c);
  $part2++ if $looped;
}
print("Part 2: $part2\n");
