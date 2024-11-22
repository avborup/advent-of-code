#!/usr/bin/env perl -w
use strict;

use Data::Dumper;
use List::Util qw(sum min);

sub part_1 {
  my ($p1_pos, $p2_pos) = @_;
  my ($p1_score, $p2_score) = (0, 0);
  my ($die, $num_rolls) = (0, 0);

  my $roll = sub {
    $num_rolls += 3;
    sum(map { $die %= 100; ++$die } 1..3)
  };

  while (1) {
    $p1_pos = ($p1_pos - 1 + $roll->()) % 10 + 1;
    $p1_score += $p1_pos;
    last if $p1_score >= 1000;

    $p2_pos = ($p2_pos - 1 + $roll->()) % 10 + 1;
    $p2_score += $p2_pos;
    last if $p2_score >= 1000;
  }

  return $num_rolls * min($p1_score, $p2_score);
}

sub part_2 {
  "?"
}

my ($p1, $p2) = (join "", <>) =~ /: (\d+)/g;
print("Part 1: ", part_1($p1, $p2), "\n");
print("Part 2: ", part_2($p1, $p2), "\n");
