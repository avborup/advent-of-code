#!/usr/bin/env perl -w
use strict;

use Data::Dumper;
use List::Util qw(sum);

sub part_1 {
  my $input = shift;
  my @bits = map { split(//, sprintf("%04b", hex)) } split(//, $input);
  my $packet = consume_packet(\@bits);

  return sum(map { $_->{version} } flatten($packet)); 
}

sub part_2 {
  "?"
}

sub consume_packet {
  my ($bits) = @_;

  my $take = sub {
    my ($n, $out) = (shift, 0);
    $out <<= 1, $out |= shift @$bits for 1..$n;
    return $out;
  };

  my $version = $take->(3);
  my $type = $take->(3);

  my $consume_literal = sub {
    my ($has_more, $total) = (1, 0);
    do {
      $has_more = $take->(1);
      $total <<= 4, $total |= $take->(4);
    } while ($has_more);
    return $total;
  };

  my $consume_operator = sub {
    my $length_type_id = $take->(1);

    if ($length_type_id == 0) {
      my $num_bits = $take->(15);
      my $initial_size = scalar @$bits;
      my $target_size = $initial_size - $num_bits;

      my @packets;
      push @packets, consume_packet($bits) while (scalar @$bits > $target_size);
      return \@packets;
    } else {
      my $length = $take->(11);
      return [map { consume_packet($bits) } 1..$length];
    }
  };

  return {
    version => $version,
    type => $type,
    value => $type == 4 ? $consume_literal->() : $consume_operator->(),
  };
}

sub flatten {
  my $packet = shift;
  return $packet if $packet->{type} == 4;
  my $unvalued = { %$packet }; delete $unvalued->{value};
  return ($unvalued, map { flatten($_) } @{$packet->{value}});
}

chomp(my $input = <>);
print("Part 1: ", part_1($input), "\n");
print("Part 2: ", part_2($input), "\n");
