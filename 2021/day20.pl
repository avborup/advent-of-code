#!/usr/bin/env perl -w
use strict;

use Data::Dumper;
use List::Util qw(sum);

sub part_1 {
  return solve_with_n(2, @_);
}

sub part_2 {
  return solve_with_n(50, @_);
}

sub solve_with_n {
  my ($n, $state) = @_;
  $state = enhance($state) for (1..$n);
  my $count = sum(map { sum(@$_) } @{$state->{image}});
  return $count;
}

sub print_image {
  my ($image) = @_;
  for my $row (@$image) {
    print(join("", map { $_ ? '#' : '.' } @$row), "\n");
  }
}

sub enhance {
  my ($state) = @_;

  my $padding = 1;
  my $alg = $state->{algorithm};
  my $default = $alg->[0] && !$alg->[-1] && $state->{step} % 2 == 1 ? 1 : 0;

  my ($NR, $NC) = ($state->{R} + $padding * 2, $state->{C} + $padding * 2);
  my $image = [map { [($default) x $NC] } 1..$NR];
  my $output = [map { [($default) x $NC] } 1..$NR];

  for my $r (0..$state->{R} - 1) {
    for my $c (0..$state->{C} - 1) {
      $image->[$r + $padding][$c + $padding] = $state->{image}[$r][$c];
    }
  }

  for my $r ($padding-1..$state->{R} + $padding) {
    for my $c ($padding-1..$state->{C} + $padding) {
      my $index = 0;
      for my $dr (-1..1) {
        for my $dc (-1..1) {
          my ($tr, $tc) = ($r + $dr, $c + $dc);
          $index <<= 1;
          unless ($tr < 0 || $tr >= $NR || $tc < 0 || $tc >= $NC) {
            $index |= $image->[$tr][$tc];
          } else {
            $index |= $default;
          }
        }
      }

      $output->[$r][$c] = $state->{algorithm}[$index];
    }
  }

  return {
    algorithm => $state->{algorithm},
    image => $output,
    R => $NR,
    C => $NC,
    step => $state->{step} + 1,
  }
}

sub parse_input {
  chomp(my $algorithm = <>);
  <>; chomp(my @lines = <>);
  return {
    algorithm => [map { $_ eq '#' } split //, $algorithm],
    image => [map { [map { $_ eq '#' } split //] } @lines],
    R => scalar @lines,
    C => length($lines[0]),
    step => 0,
  }
}

my $input = parse_input();
print("Part 1: ", part_1($input), "\n");
print("Part 2: ", part_2($input), "\n");
