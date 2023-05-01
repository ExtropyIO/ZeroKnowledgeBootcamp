// Modify the integer types to make the tests pass.
// Learn how to convert between integer types, and felts.

// Type `hint` in watch mode for a hint.

// I AM NOT DONE

use traits::Into;
use traits::TryInto;
use option::OptionTrait;

//TODO modify the types of this function to prevent an overflow when summing big values
fn sum(x: u8, y: u8) -> u8 {
    x + y
}

fn convert_to_felt(x: u16) -> felt252 {
    //TODO return x as a felt252.
}

fn convert_felt_to_u16(x: felt252) -> u16 {
    //TODO return x as a u8.
}

#[test]
fn test_sum() {
    assert(sum(254_u8, 255_u8) == 509_u16, 'Something went wrong');
}

#[test]
fn test_convert_to_felt() {
    assert(convert_to_felt(999_u16) == 999, 'Type conversion went wrong');
}

#[test]
fn test_convert_to_u16() {
    assert(convert_felt_to_u16(1000) == 1000_u16, 'Type conversion went wrong');
}
