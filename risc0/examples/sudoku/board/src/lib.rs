#![no_std] // std support is experimental

const GRID_SIZE: usize = 9;
const SUBGRID_SIZE: usize = 3;

use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
pub struct Sudoku {
    grid: [[u32; GRID_SIZE]; GRID_SIZE],
}

impl Sudoku {
    pub fn new(grid: [[u32; GRID_SIZE]; GRID_SIZE]) -> Self {
        Sudoku { grid }
    }

    pub fn new0() -> Self {
        Sudoku { grid: [[1; 9]; 9] }
    }

    pub fn get(&self, row: usize, col: usize) -> u32 {
        self.grid[row][col]
    }

    pub fn set(&mut self, row: usize, col: usize, value: u32) {
        self.grid[row][col] = value;
    }

    pub fn is_valid(&self) -> bool {
        self.check_rows() && self.check_columns() && self.check_subgrids()
    }

    // Returns true if provided sudoku is a subset of this one
    pub fn is_subset(&self, sub_sudoku: &Sudoku) -> bool {
        // Iterate over a subset
        for r in 0..GRID_SIZE {
            for c in 0..GRID_SIZE {
                if sub_sudoku.grid[r][c] != 0 {
                    if sub_sudoku.grid[r][c] != self.grid[r][c] {
                        return false;
                    }
                }
            }
        }
        true
    }

    fn check_rows(&self) -> bool {
        for row in 0..GRID_SIZE {
            let mut seen = [false; GRID_SIZE];
            for col in 0..GRID_SIZE {
                let value = self.get(row, col) as usize;
                if seen[value - 1] {
                    return false;
                }
                seen[value - 1] = true;
            }
        }
        true
    }

    fn check_columns(&self) -> bool {
        for col in 0..GRID_SIZE {
            let mut seen = [false; GRID_SIZE];
            for row in 0..GRID_SIZE {
                let value = self.get(row, col) as usize;
                if seen[value - 1] {
                    return false;
                }
                seen[value - 1] = true;
            }
        }
        true
    }

    fn check_subgrids(&self) -> bool {
        for row in (0..GRID_SIZE).step_by(SUBGRID_SIZE) {
            for col in (0..GRID_SIZE).step_by(SUBGRID_SIZE) {
                if !self.check_subgrid(row, col) {
                    return false;
                }
            }
        }
        true
    }

    fn check_subgrid(&self, start_row: usize, start_col: usize) -> bool {
        let mut seen = [false; GRID_SIZE];
        for row in start_row..start_row + SUBGRID_SIZE {
            for col in start_col..start_col + SUBGRID_SIZE {
                let value = self.get(row, col) as usize;
                if seen[value - 1] {
                    return false;
                }
                seen[value - 1] = true;
            }
        }
        true
    }
}
