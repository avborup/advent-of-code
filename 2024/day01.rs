use itertools::Itertools;
use std::io::{self};

fn main() {
    let input = io::stdin()
        .lines()
        .map(|l| l.unwrap().parse::<i64>().unwrap())
        .collect::<Vec<_>>();

    println!("Part 1: {}", part1(input.iter().copied()));
    println!("Part 2: {}", part2(&input));
}

fn part1(input: impl Iterator<Item = i64>) -> usize {
    input.tuple_windows().filter(|(a, b)| a < b).count()
}

fn part2(input: &[i64]) -> usize {
    let sums = input.windows(3).map(|w| w.iter().sum::<i64>());
    part1(sums)
}
