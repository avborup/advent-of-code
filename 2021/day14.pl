#!/usr/bin/env perl -w
use strict;

use Data::Dumper;

sub part_1 {
  my ($template, $rules) = @_;

  my $polymer = [split //, $template];
  $polymer = polymerize($polymer, $rules) for 1..10;

  my %counts; $counts{$_}++ for @$polymer;
  my @by_freq = sort { $counts{$a} <=> $counts{$b} } keys %counts;

  return $counts{$by_freq[-1]} - $counts{$by_freq[0]};
}

sub part_2 {
  "?"
}

sub polymerize {
  my ($polymer, $rules) = @_;
  my @out = ($polymer->[0]);
  for my $i (1..$#{$polymer}) {
    my ($l, $r) = @$polymer[$i-1..$i];
    push @out, $rules->{"$l$r"} // "", $r;
  }
  return \@out;
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
