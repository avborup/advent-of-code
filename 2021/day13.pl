#!/usr/bin/env perl -w
use strict;

use Math::Complex;
use List::Util qw(max);
use List::MoreUtils qw(uniq);

sub part_1 {
  my ($coords, $folds) = @_;
  $coords = fold($coords, @{@$folds[0]});
  return scalar uniq @$coords;
}

sub part_2 {
  my ($coords, $folds) = @_;
  $coords = fold($coords, @$_) for @$folds;
  return print_paper($coords);
}

sub fold {
  my ($coords, $axis, $val) = @_;
  my @folded = @$coords;
  for my $i (0..$#$coords) {
    my $c = $coords->[$i];
    if ($axis eq "x" && Re($c) > $val) {
      $folded[$i] = $c + cplx(-2 * (Re($c) - $val), 0);
    } elsif ($axis eq "y" && Im($c) > $val) {
      $folded[$i] = $c + cplx(0, -2 * (Im($c) - $val));
    }
  }
  return \@folded;
}

sub print_paper {
  my ($coords) = @_;
  my ($R, $C) = (max(map { Im($_) } @$coords), max(map { Re($_) } @$coords));
  my @matrix = map { [(" ") x ($C + 1)] } 0..$R;
  $matrix[Im($_)][Re($_)] = "#" for @$coords;
  return join "\n", map { my $r = $_; join("", map { $matrix[$r][$_] } 0..$C) } 0..$R;
}

sub parse_input {
  my $input = join "", <>;
  my @coords;
  push @coords, cplx($1, $2) while ($input =~ /(\d+),(\d+)/g);
  my @folds;
  push @folds, [$1, $2] while ($input =~ /fold along (x|y)=(\d+)/g);
  return (\@coords, \@folds);
}

my @input = parse_input();
print("Part 1: ", part_1(@input), "\n");
print("Part 2:\n", part_2(@input));
