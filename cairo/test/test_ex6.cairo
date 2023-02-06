%lang starknet
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.alloc import alloc

from exercises.programs.ex6 import sum_even

@external
func test_sum_even{syscall_ptr: felt*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    let (local array: felt*) = alloc();
    assert array[0] = 2;
    assert array[1] = 1;
    let (sum) = sum_even(2, array, 0, 0);
    assert  2 = sum;

    let (local array: felt*) = alloc();
    assert array[0] = 2;
    assert array[1] = 100;
    assert array[2] = 12;
    assert array[3] = 2;
    assert array[4] = 422;
    assert array[5] = 898;
    assert array[6] = 10;
    assert array[7] = 31;
    assert array[8] = 22;
    assert array[9] = 5;

    let (sum) = sum_even(10, array, 0, 0);
    assert 1468 = sum;

    return ();
}
