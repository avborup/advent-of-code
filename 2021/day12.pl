#!/usr/bin/env perl -w
use strict;

use Data::Dumper;

sub part_1 {
  my ($edges) = @_;
  return find_num_paths($edges);
}

sub part_2 {
  "?"
}

sub find_num_paths {
  my ($edges) = @_;
  my @stack = (["start", {}]);

  my $num_paths = 0;
  while (@stack) {
    my ($v, $visited) = @{pop @stack};

    ($num_paths++ && next) if $v eq "end";
    next if ($v eq "start" && keys %$visited > 0);

    foreach my $adj (@{$edges->{$v}}) {
      my $new_num_small = ($visited->{$adj} || 0) + ($adj =~ /[a-z]+/);
      next if $new_num_small > 1;
      push @stack, [$adj, {%$visited, $adj => $new_num_small}];
    }
  }

  return $num_paths;
}

sub parse_input {
  my ($input, %edges) = do { local $/; <> };
  while ($input =~ /([a-z]+)-([a-z]+)/gi) {
    push @{$edges{$1}}, $2;
    push @{$edges{$2}}, $1;
  }
  return \%edges;
}

my $edges = parse_input();
print("Part 1: ", part_1($edges), "\n");
print("Part 2: ", part_2($edges), "\n");
