#!/usr/bin/env perl -w
use strict;

use List::Util qw(all sum product);
use Math::Complex;
use Data::Dumper;

sub part_1 {
  my ($matrix) = @_;
  my @lows = find_low_points($matrix);
  return sum(map { 1 + $matrix->{$_} } @lows);
}

sub part_2 {
  my ($matrix) = @_;
  my @lows = find_low_points($matrix);

  my %visited;
  my $dfs = sub {
    my ($start) = @_;
    my @stack = ($start);
    $visited{$start} = 1;

    my $size = 1;
    while (@stack) {
      my $v = pop @stack;

      foreach my $adj (@{neighbours($v, $matrix)}) {
        next if $visited{$adj} || $matrix->{$adj} >= 9;
        $visited{$adj} = 1;

        $size++;
        push @stack, $adj;
      }
    }

    return $size;
  };

  my @sizes = map { $dfs->($_) } @lows;

  return product((sort { $b <=> $a } @sizes)[0..2]);
}

sub find_low_points {
  my ($matrix) = @_;
  my @lows;
  for my $v (map { cp($_) } keys %$matrix) {
    push @lows, $v if all { $matrix->{$v} < $matrix->{$_} } @{neighbours($v, $matrix)};
  }
  return @lows;
}

sub neighbours {
  my ($v, $matrix) = @_;
  my @neighbours;
  foreach my $dir (cplx(-1, 0), cplx(1, 0), cplx(0, -1), cplx(0, 1)) {
    my $n = $v + $dir;
    push @neighbours, $n if exists $matrix->{$n};
  }
  return \@neighbours;
}

# Bug in Perl? I've reported it here: https://github.com/Perl/perl5/issues/22711
# DB<1> p cplx(2, 1)
#   2+i
# DB<2> p cplx("2+i")
#   0   <- wrong!
# DB<3> p cplx("2+1i") <- but this works
#   2+i  
sub cp {
  my ($str) = @_;
  $str =~ /^(-?\d+)?([+-]?)(\d*)(i?)$/;

  my ($re, $im);
  if ($4 && not $3) {
    $re = 0;
    $im = $1 || 0;
  } else {
    $re = $1 || 0;
    $im = $4 ? ($3 || 1) : 0;
  }
  $im *= -1 if $2 eq '-';

  return cplx($re, $im);
}

sub parse_input {
  my @matrix = map { [split //] } map { chomp; $_ } <>;
  my ($R, $C) = ($#matrix, $#{$matrix[0]});

  my %coords;
  for my $r (0 .. $R) {
    for my $c (0 .. $C) {
      $coords{cplx($r, $c)} = $matrix[$r][$c];
    }
  }

  return (\%coords, $R, $C);
}

my ($matrix) = parse_input();
print("Part 1: ", part_1($matrix), "\n");
print("Part 2: ", part_2($matrix), "\n");
