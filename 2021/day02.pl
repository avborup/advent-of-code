#!/usr/bin/perl -w
use strict; use warnings;

sub part_1 {
  my @input = @_;
  my ($x, $y) = (0, 0);

  foreach my $line (@input) {
    my ($dir, $dist) = $line =~ /(\w+) (\d+)/;

    if ($dir eq 'forward') { $x += $dist; }
    elsif ($dir eq 'down') { $y += $dist; }
    elsif ($dir eq 'up')   { $y -= $dist; }
  }

  $x * $y
}

sub part_2 {
  my @input = @_;
  my ($x, $y, $aim) = (0, 0, 0);

  foreach my $line (@input) {
    my ($dir, $dist) = $line =~ /(\w+) (\d+)/;

    if ($dir eq 'down')  { $aim += $dist; }
    elsif ($dir eq 'up') { $aim -= $dist; }
    elsif ($dir eq 'forward') {
      $x += $dist;
      $y += $aim * $dist;
    }
  }

  $x * $y
}

my @input = map { chomp; $_ } <>;

print("Part 1: ", part_1(@input), "\n");
print("Part 2: ", part_2(@input), "\n");
