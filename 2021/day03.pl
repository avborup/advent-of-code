#!/usr/bin/perl -w
use strict; use warnings;

use Data::Dumper;

sub part_1 {
  my @matrix = map { [split //, $_] } @_;

  my @transposed = ();
  for my $i (0 .. $#matrix) {
    for my $j (0 .. $#{$matrix[$i]}) {
      $transposed[$j][$i] = $matrix[$i][$j];
    }
  }

  my @gamma_bits = map {
    (scalar grep { $_ eq 1 } @$_) > $#_ / 2 ? 1 : 0
  } @transposed;

  my $gamma = oct("0b" . join('', @gamma_bits));
  my $num_bits = scalar @gamma_bits;
  my $epsilon = (~$gamma) & ((2 << $num_bits - 1) - 1);

  $gamma * $epsilon
}

sub part_2 {
  "?"
}

my @input = map { chomp; $_ } <>;

print("Part 1: ", part_1(@input), "\n");
print("Part 2: ", part_2(@input), "\n");
