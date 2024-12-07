#!/usr/bin/env perl -w
use strict;

chomp(my @input = <>);

my ($part1, $part2) = (0, 0);
for my $line (@input) {
  my ($goal, @args) = $line =~ /(\d+)/g;
  $part1 += $goal if brute($goal, $args[0], \@args, 1, 0);
  $part2 += $goal if brute($goal, $args[0], \@args, 1, 1);
}

sub brute {
  my ($goal, $acc, $nums, $i, $or) = @_;

  return 1 if $i > $#$nums && $goal == $acc;
  return 0 if $i > $#$nums;

  my $num = $nums->[$i];
  my $valid = brute($goal, $acc + $num, $nums, $i + 1, $or) || brute($goal, $acc * $num, $nums, $i + 1, $or);
  $valid ||= brute($goal, "$acc$num", $nums, $i + 1, $or) if $or;
  return $valid;
}

print("Part 1: $part1\n");
print("Part 2: $part2\n");
