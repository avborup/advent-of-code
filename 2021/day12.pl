#!/usr/bin/env perl -w
use strict;

use Data::Dumper;

sub part_1 {
  return find_num_paths(shift, 1);
}

sub part_2 {
  return find_num_paths(shift, 2);
}

sub find_num_paths {
  my ($edges, $init_max) = @_;
  my @stack = (["start", {}, $init_max]);

  my $num_paths = 0;
  while (@stack) {
    my ($v, $visited, $cur_max) = @{pop @stack};

    ++$num_paths && next if $v eq "end";
    next if $v eq "start" && %$visited;

    foreach my $adj (@{$edges->{$v}}) {
      my $new_num_small = ($visited->{$adj} // 0) + ($adj =~ /[a-z]+/);
      next if $new_num_small > $cur_max;
      my $new_max = $new_num_small == $cur_max ? 1 : $cur_max;
      push @stack, [$adj, {%$visited, $adj => $new_num_small}, $new_max];
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
