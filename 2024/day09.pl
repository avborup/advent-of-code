#!/usr/bin/env perl -w
use strict;

use Data::Dumper;

my ($part1, $part2) = (0, 0);

my @input = split //, <>;

my %files;
my $id = 0;
while (@input) {
  $files{$id++} = {blocks => shift @input, free => shift @input // 0};
}

my @disk = ();
for $id (sort { $a <=> $b } keys %files) {
  for my $i (1..$files{$id}->{blocks}) {
    push @disk, $id;
  }
  for my $i (1..$files{$id}->{free}) {
    push @disk, ".";
  }
}

my ($checksum, %seen) = (0);
for (my $i = 0; $i < @disk; $i++) {
  if ($disk[$i] eq ".") {
    pop @disk while $disk[-1] eq ".";
    $disk[$i] = pop @disk;
  }
  $checksum += $i * $disk[$i];
}

print @disk, "\n";

$part1 = $checksum;
print("Part 1: $part1\n");
print("Part 2: $part2\n");
