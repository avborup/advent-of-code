#!/usr/bin/perl -w
use strict; use warnings;

use Data::Dumper;
use List::Util qw(sum);

sub part_1 {
  my ($draws, $boards) = @_;
  return find_last_winner($draws, $boards, 1);
}

sub part_2 {
  my ($draws, $boards) = @_;
  return find_last_winner($draws, $boards, scalar @$boards);
}

sub find_last_winner {
  my ($draws, $boards, $max_winners) = @_;

  my %seen = ();
  my %winners = ();
  my ($winning_draw, $winning_board) = (undef, undef);

  DRAWS: foreach my $draw (@$draws) {
    last if keys %winners >= $max_winners;
    $seen{$draw} = 1;

    for my $b (0 .. $#$boards) {
      next if $winners{$b};
      my $board = $boards->[$b];

      for (my $i = 0; $i < 5; $i++) {
        my @row = @$board[$i * 5 .. ($i + 1) * 5 - 1];
        my @col = map { $board->[$_ * 5 + $i] } 0 .. 4;

        my $has_win = (grep { exists $seen{$_} } @row) == 5 || (grep { exists $seen{$_} } @col) == 5;

        if ($has_win) {
          ($winning_draw, $winning_board) = ($draw, $board);
          $winners{$b} = 1;
          last;
        }
      }
    }
  }

  return $winning_draw * sum(grep { !exists $seen{$_} } @$winning_board);
}

sub parse {
  chomp(my @lines = <>);

  my @draws = split /,/, $lines[0];
  my @boards = ();

  for (my $i = 1; $i <= $#lines; $i += 6) {
    my $flat = join(' ', @lines[$i .. $i + 5]);
    push @boards, [grep { $_ ne ""} split(/\s+/, $flat)];
  }

  return (\@draws, \@boards);
}

my @input = parse();
print("Part 1: ", part_1(@input), "\n");
print("Part 2: ", part_2(@input), "\n");
