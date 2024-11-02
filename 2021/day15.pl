#!/usr/bin/env perl -w
use strict;

use Heap::MinMax;
use Data::Dumper;

sub part_1 {
  return dijkstra(@_);
}

sub part_2 {
  my ($risks) = @_;
  my $extended;
  my ($R, $C) = ($#$risks + 1, $#{$risks->[0]} + 1);

  for my $r (0..5*$R-1) {
    for my $c (0..5*$C-1) {
      my $risk = $risks->[$r % $R][$c % $C] + int($r / $R) + int($c / $C);
      $extended->[$r][$c] = ($risk - 1) % 9 + 1;
    }
  }

  return dijkstra($extended);
}

sub dijkstra {
  my ($risks) = @_;
  my ($R, $C) = ($#$risks + 1, $#{$risks->[0]} + 1);
  my @dist = map { [map { 'inf' } @$_] } @$risks;

  my $pq = Heap::MinMax->new(fcompare => sub {
    my ($r1, $c1, $r2, $c2) = map { @$_ } @_;
    return $dist[$r1][$c1] <=> $dist[$r2][$c2];
  });

  $pq->insert([0, 0]);
  $dist[0][0] = 0;

  while (my $v = $pq->pop_min()) {
    for my $neighbour (neighbours(@$v, $R, $C)) {
      my ($r, $c, $nr, $nc) = (@$v, @$neighbour);
      my $new_dist = $dist[$r][$c] + $risks->[$nr][$nc];
      next if $new_dist >= $dist[$nr][$nc];
      $dist[$nr][$nc] = $new_dist;
      $pq->insert([$nr, $nc]);
    }
  }

  return $dist[-1][-1];
}

sub neighbours {
  my ($r, $c, $R, $C) = @_;
  my @neighbours;
  foreach my $dir ([-1, 0], [1, 0], [0, -1], [0, 1]) {
    my ($nr, $nc) = ($r + $dir->[0], $c + $dir->[1]);
    push @neighbours, [$nr, $nc] unless $nr < 0 || $nr >= $R || $nc < 0 || $nc >= $C;
  }
  return @neighbours;
}

my $matrix = [map { chomp; [split //] } <>];
print("Part 1: ", part_1($matrix), "\n");
print("Part 2: ", part_2($matrix), "\n");
