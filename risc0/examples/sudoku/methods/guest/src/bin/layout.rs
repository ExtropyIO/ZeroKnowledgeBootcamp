#![no_main]
#![no_std]

use risc0_zkvm::guest::env;
risc0_zkvm::guest::entry!(main);
use board;

pub fn main() {
    let board_solved: board::Sudoku = env::read();
    let board_unsolved: board::Sudoku = env::read();

    // Assert solved one is correct
    assert!(board_solved.is_valid(), "Not solved correctly");

    // Assert unsolved one is a subset of the solved one
    assert!(
        board_solved.is_subset(&board_unsolved),
        "Not part of the subset"
    );
}
