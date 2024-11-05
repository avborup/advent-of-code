#!/usr/bin/env perl -w
use strict;

use Data::Dumper;
use POSIX qw(ceil floor);
use List::Util qw(reduce max);
use Algorithm::Permute;

sub part_1 {
  my @snails = @_;
  my $res = reduce { add($a, $b) } @snails;
  return magnitude($res);
}

sub part_2 {
  my @snails = @_;
  my $max = 0;

  my $perms = Algorithm::Permute->new(\@snails, 2);
  while (my @nums = $perms->next) {
    my $res = add(@nums);
    $max = max($max, magnitude($res));
  }

  return $max;
}

sub add {
  my ($a, $b) = @_;

  my $res = [map { [$_->[0], $_->[1] + 1] } (@$a, @$b)];

  my $changed = 1;
  while ($changed) {
    ($res, $changed) = explode_snail($res);
    next if $changed;
    ($res, $changed) = split_snail($res);
  }

  return $res;
}

sub explode_snail {
  my ($snail) = @_;

  for my $i (1..$#$snail) {
    my ($a, $b) = @$snail[$i - 1, $i];
    my ($a_n, $a_depth, $b_n, $b_depth) = (@$a, @$b);

    next if $a_depth <= 4 || $a_depth != $b_depth;

    if ($i - 2 >= 0) {
      my ($l_n, $l_depth) = @{$snail->[$i - 2]};
      $snail->[$i - 2] = [$l_n + $a_n, $l_depth];
    }

    if ($i + 1 <= $#$snail) {
      my ($r_n, $r_depth) = @{$snail->[$i + 1]};
      $snail->[$i + 1] = [$r_n + $b_n, $r_depth];
    }

    my @res = (@$snail[0..$i - 2], [0, $a_depth - 1], @$snail[$i + 1..$#$snail]);

    return (\@res, 1);
  }

  return ($snail, 0);
}

sub split_snail {
  my ($snail) = @_;

  for my $i (0..$#$snail) {
    my ($n, $depth) = @{$snail->[$i]};
    next if $n < 10;
    my ($floored, $ceiled) = (floor($n / 2), ceil($n / 2));
    my @res = (@$snail[0..$i - 1], [$floored, $depth + 1], [$ceiled, $depth + 1], @$snail[$i + 1..$#$snail]);
    return (\@res, 1);
  }

  return ($snail, 0);
}

sub magnitude {
  my ($snail) = @_;

  while (@$snail > 1) {
    for my $i (1..$#$snail) {
      my ($a, $b) = @$snail[$i - 1, $i];
      my ($a_n, $a_depth, $b_n, $b_depth) = (@$a, @$b);
      next if $a_depth != $b_depth;

      my $mag = 3 * $a_n + 2 * $b_n;
      $snail = [(@$snail[0..$i - 2], ([$mag, $a_depth - 1]), @$snail[$i + 1..$#$snail])],
      last;
    }
  }

  return $snail->[0]->[0];
}

sub parse_input {
  my $parse_line = sub {
    my @chars = split //;
    my ($depth, @snail) = 0;
    while (defined ($_ = shift @chars)) {
      $depth++ if $_ eq "[";
      $depth-- if $_ eq "]";
      push @snail, [$_, $depth] if m/\d/;
    }
    return \@snail;
  };

  return map { chomp; $parse_line->() } <>;
}

my @input = parse_input();
print("Part 1: ", part_1(@input), "\n");
print("Part 2: ", part_2(@input), "\n");
