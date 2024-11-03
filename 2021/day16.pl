#!/usr/bin/env perl -w
use strict;

use Data::Dumper;
use List::Util qw(sum product min max);

sub part_1 {
  my $packet = shift;
  return sum(map { $_->{version} } flatten($packet)); 
}

sub part_2 {
  my $packet = shift;
  return eval_packet($packet);
}

use constant { LITERAL => 4, SUM => 0, PRODUCT => 1, MIN => 2, MAX => 3, GREATER => 5, LESS => 6, EQUAL => 7 };

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
    value => $type == LITERAL ? $consume_literal->() : $consume_operator->(),
  };
}

sub eval_packet {
  my $packet = shift;
  return $packet->{value} if $packet->{type} == LITERAL;

  my $op = $packet->{type};
  my @args = map { eval_packet($_) } @{$packet->{value}};

  return $op == SUM ? sum(@args) :
         $op == PRODUCT ? product(@args) :
         $op == MIN ? min(@args) :
         $op == MAX ? max(@args) :
         $op == GREATER ? $args[0] > $args[1] :
         $op == LESS ? $args[0] < $args[1] :
         $op == EQUAL ? $args[0] == $args[1] :
         die "Unknown operator: $op";
}

sub flatten {
  my $packet = shift;
  return $packet if $packet->{type} == LITERAL;
  my $unvalued = { %$packet }; delete $unvalued->{value};
  return ($unvalued, map { flatten($_) } @{$packet->{value}});
}

sub parse_input {
  chomp(my $input = <>);
  my @bits = map { split(//, sprintf("%04b", hex)) } split(//, $input);
  return consume_packet(\@bits);
}

my $packet = parse_input();
print("Part 1: ", part_1($packet), "\n");
print("Part 2: ", part_2($packet), "\n");
