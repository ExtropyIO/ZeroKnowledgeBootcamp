use methods::{LAYOUT_ELF, LAYOUT_ID};
use risc0_zkvm::serde::to_vec;
use risc0_zkvm::Prover;

use board;

fn main() {
    let solved_sudoku_arr = [
        [5, 3, 4, 6, 7, 8, 9, 1, 2],
        [6, 7, 2, 1, 9, 5, 3, 4, 8],
        [1, 9, 8, 3, 4, 2, 5, 6, 7],
        [8, 5, 9, 7, 6, 1, 4, 2, 3],
        [4, 2, 6, 8, 5, 3, 7, 9, 1],
        [7, 1, 3, 9, 2, 4, 8, 5, 6],
        [9, 6, 1, 5, 3, 7, 2, 8, 4],
        [2, 8, 7, 4, 1, 9, 6, 3, 5],
        [3, 4, 5, 2, 8, 6, 1, 7, 9],
    ];

    let partial_sudoku_arr = [
        [5, 3, 4, 0, 7, 0, 9, 0, 2],
        [0, 0, 2, 1, 0, 5, 0, 4, 8],
        [1, 9, 8, 3, 4, 2, 5, 6, 0],
        [8, 5, 0, 7, 0, 1, 0, 2, 3],
        [4, 2, 6, 8, 5, 3, 7, 9, 1],
        [7, 1, 3, 9, 0, 4, 8, 0, 6],
        [0, 0, 1, 5, 3, 7, 2, 8, 0],
        [2, 8, 0, 4, 0, 9, 6, 3, 5],
        [3, 4, 5, 2, 8, 6, 1, 7, 0],
    ];

    let mut solved_sudoku = board::Sudoku::new(solved_sudoku_arr);
    let mut partial_sudoku = board::Sudoku::new(partial_sudoku_arr);

    // Uncommenting will break it
    // partial_sudoku.set(0, 0, 3);

    // Make the prover.
    let mut prover =
        Prover::new(LAYOUT_ELF).expect("Prover should be constructed from valid ELF binary");

    // Communication with the guest

    prover.add_input_u32_slice(&to_vec(&solved_sudoku).unwrap());
    prover.add_input_u32_slice(&to_vec(&partial_sudoku).unwrap());

    // Run prover & generate receipt
    let receipt = prover.run().expect(
        "Code should be provable unless it had an error or exceeded the maximum cycle limit",
    );

    // Verify your receipt
    receipt.verify(&LAYOUT_ID).expect(
        "Code you have proven should successfully verify; did you specify the correct method ID?",
    );

    println!(
        "I know the sudoku combination that solves {:?}",
        partial_sudoku_arr
    );
}
