#!/usr/bin/env perl -w
use strict;

use Data::Dumper;
use List::Util qw(sum);

sub part_1 {
  my ($l1, $l2) = @_;

  @$l1 = sort { $a <=> $b } @$l1;
  @$l2 = sort { $a <=> $b } @$l2;

  return sum(map { abs($l2->[$_] - $l1->[$_]) } 0..$#$l1);
}

sub part_2 {
  my ($l1, $l2) = @_;

  my %scores;
  for my $b (@$l2) {
    $scores{$b} = 0 if !exists $scores{$b};
    $scores{$b}++;
  }

  return sum(map { $_ * ($scores{$_} // 0) } @$l1);
}

sub read_input {
  my @nums = join("", <>) =~ /-?\d+/g;
  my (@l1, @l2) = ();
  while (@nums) {
    push(@l1, shift @nums);
    push(@l2, shift @nums);
  }
  return (\@l1, \@l2);
}

my @input = read_input();
print("Part 1: ", part_1(@input), "\n");
print("Part 2: ", part_2(@input), "\n");
