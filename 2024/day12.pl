#!/usr/bin/env perl -w
use strict;

use Data::Dumper;
use List::Util qw(sum min first);

my $grid = [map { chomp; [split //] } <>];
my ($R, $C) = (scalar(@$grid), scalar(@{$grid->[0]}));

my ($part1, $part2) = (0, 0);

my %visited;
my @regions;
for my $r (0..$R-1) {
  for my $c (0..$C-1) {
    push @regions, bfs([$r, $c]) unless $visited{"$r,$c"};
  }
}

for my $region (@regions) {
  my $area = scalar(@{$region->{points}});
  my $perimeter = sum values %{$region->{perimeter}};
  my $sides = count_sides($region);

  $part1 += $area * $perimeter;
  $part2 += $area * $sides;
}

print("Part 1: $part1\n");
print("Part 2: $part2\n");

sub bfs{
  my ($pos) = @_;
  my $kind = $grid->[$pos->[0]][$pos->[1]];

  my @region;

  my @queue = ($pos);
  my %perimeter;
  while (@queue) {
    my ($r, $c) = @{shift @queue};
    next if $visited{"$r,$c"};

    $visited{"$r,$c"} = 1;
    push @region, [$r, $c];

    foreach my $dir ([-1, 0], [1, 0], [0, -1], [0, 1]) {
      my ($nr, $nc) = ($r + $dir->[0], $c + $dir->[1]);

      if ($nr < 0 || $nr >= $R || $nc < 0 || $nc >= $C || $grid->[$nr][$nc] ne $kind) {
        $perimeter{"$nr,$nc"}++;
        next;
      }

      push @queue, [$nr, $nc] unless $visited{"$nr,$nc"};
    }
  }

  return {kind=>$kind, perimeter=>\%perimeter, points=>\@region};
}

sub count_sides {
  my ($region) = @_;
  my $sides = 0;

  foreach my $point (@{$region->{points}}) {
    my ($r, $c) = @$point;

    foreach my $ver ([1, 0], [-1, 0]) {
      foreach my $hor ([0, 1], [0, -1]) {
        my ($vr, $vc) = ($r + $ver->[0], $c + $ver->[1]);
        my ($hr, $hc) = ($r + $hor->[0], $c + $hor->[1]);
        my ($dr, $dc) = ($r + $ver->[0] + $hor->[0], $c + $ver->[1] + $hor->[1]);

        my $ver_diff = !in_bounds($vr, $vc) || $grid->[$vr][$vc] ne $region->{kind};
        my $hor_diff = !in_bounds($hr, $hc) || $grid->[$hr][$hc] ne $region->{kind};
        my $diag_diff = !in_bounds($dr, $dc) || $grid->[$dr][$dc] ne $region->{kind};

        my $is_corner = ($ver_diff && $hor_diff) || (!$ver_diff && !$hor_diff && $diag_diff);
        $sides++ if $is_corner;
      }
    }
  }

  return $sides;
}

sub in_bounds { my ($r, $c) = @_; $r >= 0 && $r < $R && $c >= 0 && $c < $C }
