#!/usr/bin/env perl -w
use strict;

use Data::Dumper;

my @reports = map { chomp; [split / /] } <>;

my $num_safe = 0;

sub is_safe {
  my ($report) = @_;

  my ($all_increasing, $all_decreasing, $all_good_diff) = (1, 1, 1);

  for my $n (0..$#{$report}-1) {
    my ($a, $b) = @{$report}[$n, $n + 1];
    $all_increasing = 0 if $a >= $b;
    $all_decreasing = 0 if $a <= $b;
    $all_good_diff = 0 if abs($a - $b) > 3 || abs($a - $b) < 1;
  }

  return ($all_increasing || $all_decreasing) && $all_good_diff;
}

my $part1 = 0;
for my $report (@reports) {
  $part1++ if is_safe($report);
}

my $part2 = 0;
for my $report (@reports) {
  $part2++, next if is_safe($report);

  for my $i (0..$#{$report}) {
    my @copy = @{$report};
    splice(@copy, $i, 1);

    $part2++, last if is_safe(\@copy);
  }
}

print("Part 1: ", $part1, "\n");
print("Part 2: ", $part2, "\n");
