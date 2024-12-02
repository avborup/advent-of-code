#!/usr/bin/env perl -w
use strict;

my @reports = map { chomp; [split / /] } <>;

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

my $part1 = grep { is_safe($_) } @reports;

my $part2 = grep {
  my $r = $_;
  is_safe($r) || grep { is_safe([@{$r}[0..$_-1, $_+1..$#$r]]) } 0..$#$r;
} @reports;

print("Part 1: $part1\n");
print("Part 2: $part2\n");
