#!/usr/bin/env perl -w
use strict;

use List::Util qw(min max);

sub part_1 {
  my ($template, $rules) = @_;
  return solve($template, $rules, 10);
}

sub part_2 {
  my ($template, $rules) = @_;
  return solve($template, $rules, 40);
}

sub solve {
  my ($template, $rules, $steps) = @_;
  my @template = split //, $template;
  my ($pairs, $counts);

  $pairs->{"$template[$_-1]$template[$_]"}++ for 1..$#template;
  $counts->{$_}++ for @template;

  ($pairs, $counts) = polymerize($pairs, $counts, $rules) for 1..$steps;

  return max(values %$counts) - min(values %$counts);
}

sub polymerize {
  my ($pairs, $counts, $rules) = @_;
  my %new_pairs;
  for my $pair (keys %$pairs) {
    my ($l, $r) = split //, $pair;
    my $new = $rules->{"$l$r"};
    $new_pairs{"$l$new"} += $pairs->{$pair};
    $new_pairs{"$new$r"} += $pairs->{$pair};
    $counts->{$new} += $pairs->{$pair};
  }
  return (\%new_pairs, $counts);
}

sub parse_input {
  my $input = join "", <>;
  my ($template) = ($input =~ /^(\w+)$/m);
  my %rules; $rules{$1} = $2 while ($input =~ /(\w+) -> (\w+)/g);
  return ($template, \%rules);
}

my @input = parse_input();
print("Part 1: ", part_1(@input), "\n");
print("Part 2: ", part_2(@input), "\n");
