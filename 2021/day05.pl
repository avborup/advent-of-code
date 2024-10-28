#!/usr/bin/perl -w
use strict; use warnings;

use Data::Dumper;
use List::Util qw(min max sum);

sub part_1 {
  my @input = @_;
  my @horizontal = grep { $_->[0] eq $_->[2] || $_->[1] eq $_->[3] } @input;

  my $w = max(map { max($_->[0], $_->[2]) } @horizontal);
  my $h = max(map { max($_->[1], $_->[3]) } @horizontal);

  my @grid = map { [(0) x ($w + 1)] } (0..$h);

  for my $line (@horizontal) {
    my ($x1, $y1, $x2, $y2) = @$line;

    for my $x (min($x1, $x2)..max($x1, $x2)) {
      for my $y (min($y1, $y2)..max($y1, $y2)) {
        $grid[$y][$x] += 1;
      }
    }
  }

  return sum(map { scalar grep { $_ > 1 } @$_ } @grid);
}

sub part_2 {
  "?"
}

sub read_input {
  return map { [/(-?\d+)/g] } <>;
}

my @input = read_input();
print("Part 1: ", part_1(@input), "\n");
print("Part 2: ", part_2(@input), "\n");
