#!/usr/bin/env perl -w
use strict;

use Data::Dumper;
use List::Util qw(sum);

sub part_1 {
  return sum(map { invalid_score(@$_) } @_);
}

sub part_2 {
  "?"
}

my %pairs = ("(" => ")", "[" => "]", "{" => "}", "<" => ">");
my %scores = (")" => 3, "]" => 57, "}" => 1197, ">" => 25137);

sub invalid_score {
  my @brackets = @_;

  my @stack;
  for my $bracket (@brackets) {
    if (exists $pairs{$bracket}) {
      push(@stack, $bracket);
    } elsif (scalar @stack && $pairs{$stack[-1]} eq $bracket) {
      pop(@stack);
    } else {
      return $scores{$bracket};
    }
  }

  return 0;
}

my @input = map { chomp; [split //] } <>;
print("Part 1: ", part_1(@input), "\n");
print("Part 2: ", part_2(@input), "\n");
