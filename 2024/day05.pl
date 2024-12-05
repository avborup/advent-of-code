#!/usr/bin/env perl -w
use strict;

use Data::Dumper;

my ($edges, $lists) = split /\n\n/, join("", <>);

$lists = [map { [split /,/] } split /\n/, $lists];

my $part1 = 0;
my $part2 = 0;

my %before;
push @{$before{$2}}, $1 while ($edges =~ /(\d+)\|(\d+)/g);

my %cmp;
$cmp{"$1|$2"} = -1, $cmp{"$2|$1"} = 1 while ($edges =~ /(\d+)\|(\d+)/g);

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
    $part1 += $list->[int(($#$list + 1) / 2)];;
  } else {
    my @ordered = sort { $cmp{"$a|$b"} // $cmp{"$b|$a"} // 0 } @{$list};
    $part2 += $ordered[int(($#ordered + 1) / 2)];;
  }
}

print("Part 1: $part1\n");
print("Part 2: $part2\n");
