// Execute `starklings hint const` or use the `hint` watch subcommand for a hint.

use debug::PrintTrait;

const TOO_HARD = false;
const NUMBER = 3_u8;
fn main() {
    TOO_HARD.print();
    NUMBER.print();
}
