#!/usr/bin/env perl -w
use strict;

my ($rules, $updates, %cmp) = split /\n\n/, join("", <>);

my @lists = map { [split /,/] } split /\n/, $updates;
$cmp{"$1|$2"} = 1 while $rules =~ /(\d+)\|(\d+)/g;

my ($part1, $part2) = (0, 0);
for my $list (@lists) {
  my $valid = 1;
  for my $i (0..$#$list) {
    for my $j ($i+1..$#$list) {
      my ($a, $b) = ($list->[$i], $list->[$j]);
      $valid = 0, last if $cmp{"$b|$a"};
    }
  }

  if ($valid) {
    $part1 += $list->[$#$list / 2];
  } else {
    my @ordered = sort { $cmp{"$a|$b"} ? -1 : $cmp{"$b|$a"} ? 1 : 0 } @$list;
    $part2 += $ordered[$#ordered / 2];
  }
}

print("Part 1: $part1\n");
print("Part 2: $part2\n");
