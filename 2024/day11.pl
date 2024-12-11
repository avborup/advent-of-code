#!/usr/bin/env perl -w
use strict;

use Data::Dumper;
use List::Util qw(sum);

my @stones = <> =~ /(\d+)/g;

print("Part 1: ", solve(25), "\n");
print("Part 2: ", solve(75), "\n");

sub solve {
  my %nums;
  $nums{$_}++ for @stones;

  my $iters = shift;
  for my $i (1..$iters) {
    my %new_nums;

    for my $stone (keys %nums) {
      for my $new_stone (new_stones($stone)) {
        $new_nums{$new_stone} += $nums{$stone};
      }
    }

    %nums = %new_nums;
  }

  return sum values %nums;
}

sub new_stones {
  my $stone = shift;

  if ($stone == 0) {
    return (1);
  }
  elsif (digits($stone) % 2 == 0) {
    my @l = split("", $stone);
    my $lefthalf = int(join("", @l[0..(scalar(@l)/2)-1]));
    my $righthalf = int(join("", @l[scalar(@l)/2..$#l]));
    return ($lefthalf, $righthalf);
  }
  else {
    return ($stone * 2024);
  }
}

sub digits  { 
    my $n = shift; 
    my $l = log($n) / log(10); 
    return int($l) + 1;
}
