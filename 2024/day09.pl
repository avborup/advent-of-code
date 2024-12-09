#!/usr/bin/env perl -w
use strict;

my @input = split //, <>;
my ($id, %files) = 0;
$files{$id++} = {blocks => shift @input, free => shift @input // 0} while @input;

print("Part 1: ", part_1(), "\n");
print("Part 2: ", part_2(), "\n");

sub part_1 {
  my @disk;
  for my $id (sort { $a <=> $b } keys %files) {
    push @disk, ($id) x $files{$id}->{blocks};
    push @disk, (".") x $files{$id}->{free}
  }

  my $checksum = 0;
  for (my $i = 0; $i < @disk; $i++) {
    pop @disk while $disk[-1] eq ".";
    $disk[$i] = pop @disk if $disk[$i] eq ".";
    $checksum += $i * $disk[$i];
  }
  # print @disk, "\n";

  return $checksum;
}

sub part_2 {
  my ($pos, @alloced, @free) = (0);
  for my $id (sort { $a <=> $b } keys %files) {
    push @alloced, {pos => $pos, id => $id, size => $files{$id}->{blocks}};
    $pos += $files{$id}->{blocks};
    push @free, {pos => $pos, size => $files{$id}->{free}};
    $pos += $files{$id}->{free};
  }

  for (my $b = $#alloced; $b >= 0; $b--) {
    my $block = $alloced[$b];

    for my $f (@free) {
      last if $f->{pos} >= $block->{pos};

      if ($f->{size} >= $block->{size}) {
        $block->{pos} = $f->{pos};
        $f->{pos} += $block->{size};
        $f->{size} -= $block->{size};
        last;
      }
    }
  }

  my $checksum = 0;
  for my $block (@alloced) {
    $checksum += ($block->{pos} + $_) * $block->{id} for 0..$block->{size}-1;
  }

  return $checksum;
}
