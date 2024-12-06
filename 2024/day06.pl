#!/usr/bin/env perl -w
use strict;

my $grid = [map { chomp; [split //] } <>];
my ($R, $C) = (scalar(@$grid), scalar(@{$grid->[0]}));

my $start;
for my $r (0..$R-1) {
  for my $c (0..$C-1) {
    if ($grid->[$r][$c] eq "^") {
      $start = [$r, $c];
    }
  }
}

sub in_bounds { my ($r, $c) = @_; return $r >= 0 && $r < $R && $c >= 0 && $c < $C; }

sub walk {
  my ($obs_r, $obs_c) = (shift // -1, shift // -1);

  my ($r, $c) = @$start;
  my ($dr, $dc, %visited) = (-1, 0);
  while (1) {
    return (0, \%visited) if !in_bounds($r, $c);
    return (1, \%visited) if exists $visited{"$r,$c"}{"$dr,$dc"};

    $visited{"$r,$c"}{"$dr,$dc"} = 1;

    my ($nr, $nc) = ($r + $dr, $c + $dc);
    if (in_bounds($nr, $nc) && $grid->[$nr][$nc] eq "#" || ($nr == $obs_r && $nc == $obs_c)) {
      ($dr, $dc) = ($dc, -$dr);
    } else {
      ($r, $c) = ($nr, $nc);
    }
  }
}

my ($looped, $visited) = walk();
print("Part 1: ", scalar keys %$visited, "\n");

my $part2 = 0;
for my $v (grep { $_ ne "$start->[0],$start->[1]" } keys %$visited) {
  my ($r, $c) = split /,/, $v;
  my ($looped) = walk($r, $c);
  $part2++ if $looped;
}
print("Part 2: $part2\n");
