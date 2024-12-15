#!/usr/bin/env perl -w
use strict;

use Data::Dumper;

my @parts = split /\n\n/, join("", <>);

my $orig_grid = [map { chomp; [split //] } split /\n/, $parts[0]];
my $grid = [];

for my $r (0..$#$orig_grid) {
  for my $c (0..$#{$orig_grid->[$r]}) {
    if ($orig_grid->[$r][$c] eq "#") {
      push @{$grid->[$r]}, ("#", "#");
    } elsif ($orig_grid->[$r][$c] eq ".") {
      push @{$grid->[$r]}, (".", ".");
    } elsif ($orig_grid->[$r][$c] eq "@") {
      push @{$grid->[$r]}, ("@", ".");
    } elsif ($orig_grid->[$r][$c] eq "O") {
      push @{$grid->[$r]}, ("[", "]");
    }
  }
}

my ($R, $C) = (scalar(@$grid), scalar(@{$grid->[0]}));

my @moves = $parts[1] =~ /\^|v|<|>/g;

my $pos;
for my $r (0..$R-1) {
  for my $c (0..$C-1) {
    if ($grid->[$r][$c] eq "@") {
      $pos = [$r, $c];
    }
  }
}

# print_grid($grid);
for my $dir (@moves) {
  # print "\n";
  # print("Moving '$dir'\n");

  $pos = [move($pos->[0], $pos->[1], $dir)];

  # print_grid($grid);
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
  my ($dr, $dc) = @{$move_map{$d}};
  my ($nr, $nc) = ($r + $dr, $c + $dc);

  if ($grid->[$nr][$nc] eq ".") {
    swap($r, $c, $nr, $nc);
    return ($nr, $nc);
  }

  if ($grid->[$nr][$nc] eq "#") {
    return ($r, $c);
  }

  my @all_to_move = ([$r, $c]);

  my $to_move = collides($nr, $nc, [$dr, $dc]);

  if ($to_move == -1) {
    return ($r, $c);
  }

  my @sorted = ();
  if ($dr != 0) {
    @sorted = sort { $dr * ($b->[0] <=> $a->[0]) } @$to_move;
  } else {
    @sorted = sort { $dc * ($b->[1] <=> $a->[1]) } @$to_move;
  }

  my %moved;
  for my $coord (@sorted) {
    if ($moved{"$coord->[0],$coord->[1]"}) {
      next;
    }
    $moved{"$coord->[0],$coord->[1]"} = 1;
    my ($tr, $tc) = ($coord->[0] + $dr, $coord->[1] + $dc);
    swap($coord->[0], $coord->[1], $tr, $tc);
  }

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
      if ($grid->[$r][$c] eq "[") {
        $sum += 100 * $r + $c;
      }
    }
  }

  return $sum;
}


sub collides {
  my ($r, $c, $d) = @_;

  if ($grid->[$r][$c] eq "#") {
    return -1;
  }

  if ($grid->[$r][$c] eq ".") {
    return [];
  }

  my @box = $grid->[$r][$c] eq "["
    ? ([$r, $c], [$r, $c+1])
    : ([$r, $c-1], [$r, $c]);

  my @found = @box;
  if ($d->[0] == 0) { # horizontal
    my $nc = $d->[1] == 1 ? $box[1][1] + 1 : $box[0][1] - 1;
    my $rec = collides($r, $nc, $d);
    return -1 if $rec == -1;
    push @found, @$rec;
  } else { # vertical
    for my $i (0..1) {
      my $rec = collides($box[$i][0] + $d->[0], $box[$i][1] + $d->[1], $d);
      return -1 if $rec == -1;
      push @found, @$rec;
    }
  }

  return \@found;
};

print("Part 2: ", calc_dists(), "\n");
