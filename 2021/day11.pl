#!/usr/bin/env perl -w
use strict;

use Data::Dumper;
use List::Util qw(sum);

sub part_1 {
  my @matrix = map { [split //] } @_;
  return sum(map { simulate_step(\@matrix) } 1..100);
}

sub part_2 {
  my @matrix = map { [split //] } @_;
  my $step = 1;
  $step++ while simulate_step(\@matrix) != 100;
  return $step;
}

sub simulate_step {
  my ($matrix) = @_;
  my ($R, $C) = ($#{$matrix}, $#{$matrix->[0]});

  for my $r (0..$R) { for my $c (0..$C) { $matrix->[$r][$c]++; } }

  my @flash_queue = map { my $r = $_; map { [$r, $_] } grep { $matrix->[$r][$_] > 9 } 0..$C } 0..$R;
  my @flashed = map { [(0) x $C] } 0..$R;

  my $num_flashed = 0;
  while (@flash_queue) {
    my ($r, $c) = @{shift @flash_queue};
    next if $flashed[$r][$c];

    $matrix->[$r][$c] = 0;
    $flashed[$r][$c] = 1;
    $num_flashed++;

    foreach my $dir ([-1, 0], [1, 0], [0, -1], [0, 1], [-1, -1], [-1, 1], [1, -1], [1, 1]) {
      my ($nr, $nc) = ($r + $dir->[0], $c + $dir->[1]);
      next if $nr < 0 || $nr > $R || $nc < 0 || $nc > $C;
      next if $flashed[$nr][$nc];

      $matrix->[$nr][$nc]++;
      push @flash_queue, [$nr, $nc] if $matrix->[$nr][$nc] > 9;
    }
  }

  return $num_flashed;
}

chomp(my @input = <>);
print("Part 1: ", part_1(@input), "\n");
print("Part 2: ", part_2(@input), "\n");
