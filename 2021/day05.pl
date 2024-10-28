#!/usr/bin/perl -w
use strict; use warnings;

use Data::Dumper;
use List::Util qw(min max sum);

sub part_1 {
  my @horizontal_vertical = grep { $_->[0] eq $_->[2] || $_->[1] eq $_->[3] } @_;
  return count_intersections(@horizontal_vertical);
}

sub part_2 {
  return count_intersections(@_);
}

sub count_intersections {
  my @lines = @_;

  my $w = max(map { max($_->[0], $_->[2]) } @lines);
  my $h = max(map { max($_->[1], $_->[3]) } @lines);

  my @grid = map { [(0) x ($w + 1)] } (0..$h);

  for my $line (@lines) {
    my ($x1, $y1, $x2, $y2) = @$line;

    my ($xd, $yd) = ($x2 - $x1, $y2 - $y1);
    for my $i (0..max(abs($xd), abs($yd))) {
      my $x = $x1 + (($xd <=> 0) * $i);
      my $y = $y1 + (($yd <=> 0) * $i);
      $grid[$y][$x] += 1;
    }
  }

  return sum(map { scalar grep { $_ > 1 } @$_ } @grid);
}

sub read_input {
  return map { [/(-?\d+)/g] } <>;
}

my @input = read_input();
print("Part 1: ", part_1(@input), "\n");
print("Part 2: ", part_2(@input), "\n");
