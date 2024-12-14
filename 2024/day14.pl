#!/usr/bin/env perl -w
use strict;

use Data::Dumper;
use List::Util qw(product);

# my ($W, $H) = (11, 7);
my ($W, $H) = (101, 103);

my @robots;
push @robots, [$_ =~ /(-?\d+)/g] while <>;

# part1();
part2();

sub part1 {
  for my $r (1..100) {
    move($_) for @robots;
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

  print "Part 1: ", product(@quads), "\n";
}

sub part2 {
  my $i = 0;
  while (1) {
    $i++;
    move($_) for @robots;

    if (calc_density() > 1500) { # found by trial and error
      draw_robots();
      print "Density: ", calc_density(), "\n";
      last;
    }
  }

  print "Part 2: $i\n";
}

sub move {
  my ($robot) = @_;
  my ($x, $y, $vx, $vy) = @$robot;
  $robot->[0] = ($x + $vx) % $W;
  $robot->[1] = ($y + $vy) % $H;
}

sub calc_density {
  my @grid = map { [(0) x $W] } 0..$H;
  $grid[$_->[1]][$_->[0]]++ for @robots;

  my $density = 0;
  for my $i (0..$H-1) {
    for my $j (0..$W-1) {
      next if $grid[$i][$j] == 0;

      my $adjs = 0;
      for my $di (-1..1) {
        for my $dj (-1..1) {
          next if $di == 0 && $dj == 0;
          my ($ni, $nj) = ($i + $di, $j + $dj);
          $adjs++ if $ni >= 0 && $ni < $H && $nj >= 0 && $nj < $W && $grid[$ni][$nj] > 0;
        }
      }

      $density += $adjs;
    }
  }

  $density
}

sub draw_robots {
  my @grid = map { [(0) x $W] } 0..$H;
  $grid[$_->[1]][$_->[0]]++ for @robots;

  for my $r (0..$H-1) {
    for my $c (0..$W-1) {
      # print(" "), next if $c eq int($W/2) || $r eq int($H/2);
      print $grid[$r][$c] ? ($grid[$r][$c] > 9 ? "#" : $grid[$r][$c]) : " ";
    }
    print "\n";
  }
}
