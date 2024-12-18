#!/usr/bin/perl -w
use strict; use warnings;

use Data::Dumper;

sub part_1 {
  my @matrix = map { [split //, $_] } @_;
  my @transposed = transpose(@matrix);

  my @gamma_bits = map {
    (scalar grep { $_ eq 1 } @$_) > $#{$_} / 2 ? 1 : 0
  } @transposed;

  my $gamma = oct("0b" . join('', @gamma_bits));
  my $num_bits = scalar @gamma_bits;
  my $epsilon = (~$gamma) & ((2 << $num_bits - 1) - 1);

  return $gamma * $epsilon;
}

sub part_2 {
  my $find_rating = sub {
    my ($bit, $input) = @_;
    my @valid = map { [split //, $_] } @$input;

    for (my $i=0; $i <= $#{$valid[0]}; $i++) {
      my @transposed = transpose(@valid);

      my $ones = scalar grep { $_ eq 1 } @{$transposed[$i]};
      my $zeros = @{$transposed[$i]} - $ones;

      my $to_keep = $ones == $zeros
        ? $bit
        : $ones > $zeros
          ? ($bit ? 1 : 0)
          : ($bit ? 0 : 1);

      @valid = grep { @$_[$i] == $to_keep } @valid;

      last if @valid <= 1;
    }

    return oct("0b" . join('', @{$valid[0]}));
  };

  my @input = @_;
  my $oxygen_rating = $find_rating->(1, \@input);
  my $co2_rating = $find_rating->(0, \@input);

  return $oxygen_rating * $co2_rating;
}

sub transpose {
  my @matrix = @_;

  my @transposed = ();
  for my $i (0 .. $#matrix) {
    for my $j (0 .. $#{$matrix[$i]}) {
      $transposed[$j][$i] = $matrix[$i][$j];
    }
  }

  @transposed
}

my @input = map { chomp; $_ } <>;

print("Part 1: ", part_1(@input), "\n");
print("Part 2: ", part_2(@input), "\n");
