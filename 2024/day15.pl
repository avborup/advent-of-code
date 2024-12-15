#!/usr/bin/env perl -w
use strict;

use Data::Dumper;

my @parts = split /\n\n/, join("", <>);

my $grid = [map { chomp; [split //] } split /\n/, $parts[0]];
my ($R, $C) = (scalar(@$grid), scalar(@{$grid->[0]}));

my @moves = $parts[1] =~ /\^|v|<|>/g;

print Dumper($grid);
print Dumper(\@moves);

my $pos;
for my $r (0..$R-1) {
  for my $c (0..$C-1) {
    if ($grid->[$r][$c] eq "@") {
      $pos = [$r, $c];
    }
  }
}

print_grid($grid);
for my $dir (@moves) {
  print "\n";
  print("Moving '$dir'\n");

  $pos = [move($pos->[0], $pos->[1], $dir)];

  print_grid($grid);
}

sub print_grid {
  my ($grid) = @_;
  for my $row (@$grid) {
    print(join("", @$row), "\n");
  }
}

sub move {
  my %move_map = (
    "^" => [-1, 0],
    "v" => [1, 0],
    "<" => [0, -1],
    ">" => [0, 1],
  );

  my ($r, $c, $d) = @_;
  print "Args: $r, $c, $d\n";
  print Dumper($d, $move_map{$d});
  my ($dr, $dc) = @{$move_map{$d}};
  my ($nr, $nc) = ($r + $dr, $c + $dc);

  if ($grid->[$nr][$nc] eq ".") {
    swap($r, $c, $nr, $nc);
    return ($nr, $nc);
  }

  if ($grid->[$nr][$nc] eq "#") {
    return ($r, $c);
  }

  my ($or, $oc) = ($nr, $nc);
  my $steps = 0;
  while ($grid->[$or][$oc] eq "O") {
    ($or, $oc) = ($or + $dr, $oc + $dc);
    $steps++;
  }

  if ($grid->[$or][$oc] eq "#") {
    return ($r, $c);
  }

  swap($or, $oc, $nr, $nc);
  swap($r, $c, $nr, $nc);

  return ($nr, $nc);
}

sub swap {
  my ($r, $c, $nr, $nc) = @_;
  my $tmp = $grid->[$r][$c];
  $grid->[$r][$c] = $grid->[$nr][$nc];
  $grid->[$nr][$nc] = $tmp;
}

sub calc_dists {
  my $sum = 0;

  for my $r (0..$R-1) {
    for my $c (0..$C-1) {
      if ($grid->[$r][$c] eq "O") {
        $sum += 100 * $r + $c;
      }
    }
  }

  return $sum;
}

my ($part1, $part2) = (0, 0);

print("Part 1: ", calc_dists(), "\n");
print("Part 2: ", $part2, "\n");
