#!/usr/bin/env perl -w
use strict;

use Data::Dumper;

my ($part1, $part2) = (0, 0);

my @input = split //, <>;

my %files;
my $id = 0;
while (@input) {
  $files{$id++} = {blocks => shift @input, free => shift @input // 0};
}

# my @disk = ();
my (@alloced, @free);
my $pos = 0;
for $id (sort { $a <=> $b } keys %files) {
  # for my $i (1..$files{$id}->{blocks}) {
  #   push @disk, $id;
  # }
  # for my $i (1..$files{$id}->{free}) {
  #   push @disk, ".";
  # }

  push @alloced, {pos => $pos, id => $id, size => $files{$id}->{blocks}};
  $pos += $files{$id}->{blocks};
  push @free, {pos => $pos, size => $files{$id}->{free}};
  $pos += $files{$id}->{free};
}

for (my $b = $#alloced; $b >= 0; $b--) {
  my $block = $alloced[$b];

  # print "Moving file $block->{id} from $block->{pos} to ";

  for my $f (@free) {
    if ($f->{pos} >= $block->{pos}) {
      last;
    }

    if ($f->{size} >= $block->{size}) {
      $block->{pos} = $f->{pos};
      $f->{pos} += $block->{size};
      $f->{size} -= $block->{size};
      last;
    }
  }

  # print "$block->{pos}\n";
}

for my $block (sort { $a->{pos} <=> $b->{pos} } @alloced) {
  my $pos = $block->{pos};
  for my $i (0..$block->{size}-1) {
    # print $pos+$i, " * $block->{id}\n";
    $part2 += ($pos + $i) * $block->{id};
  }
}

# my ($checksum, %seen) = (0);
# for (my $i = 0; $i < @disk; $i++) {
#   if ($disk[$i] eq ".") {
#     pop @disk while $disk[-1] eq ".";
#     $disk[$i] = pop @disk;
#   }
#   $checksum += $i * $disk[$i];
# }
# $part1 = $checksum;
#
#
# print @disk, "\n";

print("Part 1: $part1\n");
print("Part 2: $part2\n");
