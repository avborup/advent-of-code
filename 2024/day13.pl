#!/usr/bin/env perl -w
use strict;

use Data::Dumper;

use Data::Dumper;
use List::Util qw(sum min first);


my @machines;
my @blocks = split /\n\n/, join("", <>);
for my $block (@blocks) {
  my ($ax, $ay) = $block =~ /Button A: X\+(\d+), Y\+(\d+)/;
  my ($bx, $by) = $block =~ /Button B: X\+(\d+), Y\+(\d+)/;
  my ($px, $py) = $block =~ /Prize: X=(\d+), Y=(\d+)/;
  push @machines, {a=>[$ax, $ay], b=>[$bx, $by], prize=>[$px, $py]};
}

print Dumper(scalar @machines);

my ($part1, $part2) = (0, 0);

for my $machine (@machines) {
  my ($as, $bs) = (undef, undef);
  for my $a (0..100) {
    for my $b (0..100) {
      my ($px) = ($a * $machine->{a}[0] + $b * $machine->{b}[0]);
      my ($py) = ($a * $machine->{a}[1] + $b * $machine->{b}[1]);

      if ($px == $machine->{prize}[0] && $py == $machine->{prize}[1]) {
        $as = min($a, $as // $a);
        $bs = min($b, $bs // $b);
        last;
      }
    }
  }

  if (defined $as && defined $bs) {
    $part1 += 3 * $as + $bs;
  }
}


print("Part 1: $part1\n");
print("Part 2: $part2\n");
