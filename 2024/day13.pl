#!/usr/bin/env perl -w
use strict;

my @machines = map { [$_ =~ /(\d+)/g] } split /\n\n/, join("", <>);

sub solve {
  my ($res, $offset) = (0, shift // 0);
  for my $machine (@machines) {
    my ($ax, $ay, $bx, $by, $px, $py) = @$machine;
    ($px, $py) = ($px + $offset, $py + $offset);

    my $det = $ax*$by - $ay*$bx;
    my $as = int(($by*$px - $bx*$py) / $det);
    my $bs = int((-$ay*$px + $ax*$py) / $det);

    my ($ex, $ey) = ($ax*$as + $bx*$bs, $ay*$as + $by*$bs);
    $res += 3 * $as + $bs if $ex == $px && $ey == $py;
  }
  return $res;
}

print("Part 1: ", solve(), "\n");
print("Part 2: ", solve(10000000000000), "\n");

=begin comment
Equations:
  1) px = ax*as + bx*bs
  2) py = ay*as + by*bs

Written as Ax = b:
  [ ax, bx ] [ as ] = [ px ]
  [ ay, by ] [ bs ]   [ py ]

To solve, find the inverse (easy for 2x2 matrix):
  A^-1 = 1/det(A) [ by, -bx ]
                  [ -ay, ax ]

  det(A) = ax*by - ay*bx

So:
  A^-1 * b = [ as ] = [ ( by*px - bx*py) / det(A) ]
             [ bs ]   [ (-ay*px + ax*py) / det(A) ]
=end comment
=cut
