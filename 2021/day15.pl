#!/usr/bin/env perl -w
use strict;

use Heap::MinMax;
use Data::Dumper;

sub part_1 {
  my ($risks) = @_;
  my ($R, $C) = ($#$risks, $#{$risks->[0]});
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

  return $dist[$R][$C];
}

sub neighbours {
  my ($r, $c, $R, $C) = @_;
  my @neighbours;
  foreach my $dir ([-1, 0], [1, 0], [0, -1], [0, 1]) {
    my ($nr, $nc) = ($r + $dir->[0], $c + $dir->[1]);
    push @neighbours, [$nr, $nc] unless $nr < 0 || $nr > $R || $nc < 0 || $nc > $C;
  }
  return @neighbours;
}

sub part_2 {
  "?"
}

my $matrix = [map { chomp; [split //] } <>];
print("Part 1: ", part_1($matrix), "\n");
print("Part 2: ", part_2($matrix), "\n");
