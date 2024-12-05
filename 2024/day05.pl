#!/usr/bin/env perl -w
use strict;

use Data::Dumper;

use List::Util qw(first);

my ($edges, $lists) = split /\n\n/, join("", <>);
$lists = [map { [split /,/] } split /\n/, $lists];

my $part1 = 0;
my $part2 = 0;

my %before;
push @{$before{$2}}, $1 while ($edges =~ /(\d+)\|(\d+)/g);

for my $list (@$lists) {
  my $valid = 1;

  for my $i (0..$#$list) {
    for my $j ($i+1..$#$list) {
      my $a = $list->[$i];
      my $b = $list->[$j];

      if (grep { $_ eq $b } @{$before{$a}}) {
        $valid = 0;
        last;
      }
    }

    last if !$valid;
  }

  if ($valid) {
    my $mid = $list->[int(($#$list + 1) / 2)];
    $part1 += $mid;
  }
}

print("Part 1: $part1\n");
print("Part 2: $part2\n");
