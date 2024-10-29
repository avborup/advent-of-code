#!/usr/bin/env perl -w
use strict;

use Data::Dumper;
use List::Util qw(sum);

sub part_1 {
  return sum(map { invalid_score(@$_) } @_);
}

sub part_2 {
  my @incomplete = grep { invalid_score(@$_) == 0 } @_;
  my @scores = map { completion_score(@$_) } @incomplete;
  return (sort { $a <=> $b } @scores)[@scores / 2];
}

my %pairs = ("(" => ")", "[" => "]", "{" => "}", "<" => ">");

sub eval_brackets {
  my @stack;
  for my $bracket (@_) {
    if (exists $pairs{$bracket}) {
      push(@stack, $bracket);
    } elsif (scalar @stack && $pairs{$stack[-1]} eq $bracket) {
      pop(@stack);
    } else {
      return (\@stack, $bracket);
    }
  }

  return (\@stack, undef);
}

sub invalid_score {
  my @brackets = @_;
  my %scores = (")" => 3, "]" => 57, "}" => 1197, ">" => 25137);
  my ($stack, $fail) = eval_brackets(@brackets);
  return defined $fail ? $scores{$fail} : 0;
}

sub completion_score {
  my @brackets = @_;
  my ($stack) = eval_brackets(@brackets);

  my $score = 0;
  my %scores = (")" => 1, "]" => 2, "}" => 3, ">" => 4);
  while (my $bracket = pop(@$stack)) {
    $score *= 5;
    $score += $scores{$pairs{$bracket}};
  }

  return $score;
}

my @input = map { chomp; [split //] } <>;
print("Part 1: ", part_1(@input), "\n");
print("Part 2: ", part_2(@input), "\n");
