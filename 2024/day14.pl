#!/usr/bin/env perl -w
use strict;

use Data::Dumper;
use List::Util qw(product);

# my ($W, $H) = (11, 7);
my ($W, $H) = (101, 103);

my @robots;
push @robots, [$_ =~ /(-?\d+)/g] while <>;

print Dumper(\@robots);

draw_robots();
print "\n";

for my $r (1..100) {
  for my $robot (@robots) {
    my ($x, $y, $vx, $vy) = @$robot;
    $robot->[0] = ($x + $vx) % $W;
    $robot->[1] = ($y + $vy) % $H;
  }

  draw_robots();
  print "\n\n";
}

my @quads = (0, 0, 0, 0);
for my $robot (@robots) {
  my ($x, $y) = @$robot;

  my ($midX, $midY) = (int($W/2), int($H/2));
  $quads[0]++ if $x < $midX && $y < $midY;
  $quads[1]++ if $x < $midX && $y > $midY;
  $quads[2]++ if $x > $midX && $y < $midY;
  $quads[3]++ if $x > $midX && $y > $midY;
}

print Dumper(\@quads);

my $part1 = product(@quads);

sub draw_robots {
  my @grid = map { [(0) x $W] } 0..$H;
  for my $robot (@robots) {
    $grid[$robot->[1]][$robot->[0]]++;
  }

  for my $r (0..$H-1) {
    for my $c (0..$W-1) {
      print(" "), next if $c eq int($W/2) || $r eq int($H/2);
      print $grid[$r][$c] ? ($grid[$r][$c] > 9 ? "#" : $grid[$r][$c]) : ".";
    }
    print "\n";
  }
}

# chomp(my @input = <>);
print("Part 1: ", $part1, "\n");
# print("Part 2: ", part_2(@input), "\n");
