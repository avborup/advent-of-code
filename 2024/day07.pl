#!/usr/bin/env perl -w
use strict;

my ($part1, $part2) = (0, 0);
for my $line (<>) {
  my ($goal, @args) = $line =~ /(\d+)/g;
  $part1 += $goal if brute($goal, $args[0], \@args, 1, 0);
  $part2 += $goal if brute($goal, $args[0], \@args, 1, 1);
}

sub brute {
  my ($goal, $acc, $nums, $i, $conc) = @_;

  return $goal == $acc if $i > $#$nums;
  my $num = $nums->[$i];

  my $found = brute($goal, $acc + $num, $nums, $i+1, $conc) || brute($goal, $acc * $num, $nums, $i+1, $conc);
  $found ||= brute($goal, "$acc$num", $nums, $i+1, $conc) if $conc;

  return $found;
}

print("Part 1: $part1\n");
print("Part 2: $part2\n");
