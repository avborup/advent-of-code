#!/usr/bin/env perl -w
use strict;

use Data::Dumper;
use List::Util qw(max);

sub part_1 {
  my ($reconstruction) = @_;
  return scalar @{$reconstruction->{beacons}};
}

sub part_2 {
  my ($reconstruction) = @_;
  my $max_dist = 0;
  for my $a (@{$reconstruction->{scanners}}) {
    $max_dist = max($max_dist, dist($a, $_)) for (@{$reconstruction->{scanners}});
  }
  return $max_dist;
}

sub reconstruct {
  my ($scanners) = @_;
  my @unsolved = @$scanners;
  my $base_scanner = shift @unsolved;
  my @found_scanners = ([0, 0, 0]);

  while (@unsolved) {
    my $next = shift @unsolved;
    if (my $res = find_scanner_transformation($base_scanner, $next)) {
      for my $new_point (@{$res->{points}}) {
        unless (grep { dist($_, $new_point) == 0 } @{$base_scanner->{beacons}}) {
          push @{$base_scanner->{beacons}}, $new_point;
        }
      }
      push @found_scanners, $res->{scanner};
    } else {
      push @unsolved, $next;
    }
  }

  return { scanners => \@found_scanners, beacons => $base_scanner->{beacons} };
}

sub find_scanner_transformation {
  my ($left, $right) = @_;

  for my $axis (0..5) {
    for my $rotation (0..3) {
      my @oriented_right = map { to_rotation(to_axis($_, $axis), $rotation) } @{$right->{beacons}};

      for my $a (@{$left->{beacons}}) {
        for my $b (@oriented_right) {
          my $translation = subtract($a, $b);
          my @right_translated = map { add($_, $translation) } @oriented_right;

          my $num_shared = 0;
          for my $l (@{$left->{beacons}}) {
            for my $r (@right_translated) {
              $num_shared++ if $l->[0] == $r->[0] && $l->[1] == $r->[1] && $l->[2] == $r->[2];
            }
          }

          if ($num_shared >= 12) {
            return { scanner => $translation, points => \@right_translated };
          }
        }
      }
    }
  }

  return undef
}

sub add {
  my ($a, $b) = @_;
  [$a->[0] + $b->[0], $a->[1] + $b->[1], $a->[2] + $b->[2]]
}

sub subtract {
  my ($a, $b) = @_;
  [$a->[0] - $b->[0], $a->[1] - $b->[1], $a->[2] - $b->[2]]
}

sub dist {
  my ($a, $b) = @_;
  abs($a->[0] - $b->[0]) + abs($a->[1] - $b->[1]) + abs($a->[2] - $b->[2])
}

sub to_axis {
  my ($point, $axis) = @_;
  my ($x, $y, $z) = @$point;
  if ($axis == 0) { $point }
  elsif ($axis == 1) { [$x, -$y, -$z] }
  elsif ($axis == 2) { [$x, -$z, $y] }
  elsif ($axis == 3) { [-$y, -$z, $x] }
  elsif ($axis == 4) { [$y, -$z, -$x] }
  elsif ($axis == 5) { [-$x, -$z, -$y] }
  else { die "Invalid axis: $axis" }
}

sub to_rotation {
  my ($point, $rotation) = @_;
  my ($x, $y, $z) = @$point;
  if ($rotation == 0) { $point }
  elsif ($rotation == 1) { [-$y, $x, $z] }
  elsif ($rotation == 2) { [-$x, -$y, $z] }
  elsif ($rotation == 3) { [$y, -$x, $z] }
  else { die "Invalid rotation: $rotation" }
}

sub parse_input {
  my @scanners;
  for my $segment (split /\n\n/, join("", my @input = <>)) {
    my @beacons;
    push @beacons, [$1, $2, $3] while ($segment =~ /(-?\d+),(-?\d+),(-?\d+)/g);
    push @scanners, { beacons => \@beacons, id => scalar @scanners };
  }
  \@scanners
}

my $scanners = parse_input();
my $reconstruction = reconstruct($scanners);
print("Part 1: ", part_1($reconstruction), "\n");
print("Part 2: ", part_2($reconstruction), "\n");
