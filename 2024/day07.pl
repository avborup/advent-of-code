#!/usr/bin/env perl -w
use strict;

use Data::Dumper;

sub part_1 {
  my @input = @_;

  my $sum = 0;
  for my $line (@input) {
    my ($goal, $nums) = split /: /, $line;
    my @nums = split / /, $nums;

    my $valid = brute($goal, $nums[0], \@nums, 1);

    print "\n";

    $sum += $goal if $valid;
  }

  return $sum;
}

sub brute {
  my ($goal, $acc, $nums, $i) = @_;

  print "Goal: $goal, Acc: $acc, Nums: @$nums\n";

  if ($i > $#$nums && $goal == $acc) {
    return 1;
  }

  if ($i > $#$nums) {
  return 0;
  }

  my $num = $nums->[$i];

  return brute($goal, $acc + $num, $nums, $i + 1) || brute($goal, $acc * $num, $nums, $i + 1);
}

sub part_2 {
  "?"
}

chomp(my @input = <>);
print("Part 1: ", part_1(@input), "\n");
print("Part 2: ", part_2(@input), "\n");
