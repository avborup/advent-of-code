#!/usr/bin/env perl -w
use strict;

my ($rules, $updates, %cmp) = split /\n\n/, join("", <>);
$cmp{"$1|$2"} = 1 while $rules =~ /(\d+)\|(\d+)/g;

my @parts; push @parts, ".*$2,.*$1" while $rules =~ /(\d+)\|(\d+)/g;
my $conds = join "|", @parts;
my $regex = qr/^(?:$conds)/;

my ($part1, $part2) = (0, 0);
for my $line (split /\n/, $updates) {
  my @l = split(/,/, $line);
  if ($line !~ $regex) {
    $part1 += $l[$#l / 2];
  } else {
    $part2 += (sort { $cmp{"$a|$b"} ? -1 : $cmp{"$b|$a"} ? 1 : 0 } @l)[$#l / 2];
  }
}

print("Part 1: $part1\n");
print("Part 2: $part2\n");
