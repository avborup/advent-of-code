#!/usr/bin/env perl -w
use strict;

use Data::Dumper;
use List::Util qw(sum);
use Math::ConvexHull qw/convex_hull/;

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

print Dumper(\@regions);

for my $region (@regions) {
  $part1 += build_fence($region);
}

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

      next if $visited{"$nr,$nc"};

      push @queue, [$nr, $nc] ; #if $grid->[$nr][$nc] eq $kind;
    }
  }

  return {kind=>$kind, perimeter=>\%perimeter, points=>\@region};
}


sub build_fence {
  my ($region) = @_;

  my $area = scalar(@{$region->{points}});

  my $kind = $region->{kind};
  # print Dumper($region->{kind}, $area, scalar keys %$perimeter, $perimeter);

  my $perimeter = sum values %{$region->{perimeter}};

  print "$kind: $area * $perimeter = ", $area * $perimeter, "\n";

  return $area * $perimeter;
}

print("Part 1: $part1\n");
print("Part 2: $part2\n");
