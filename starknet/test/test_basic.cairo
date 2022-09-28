%lang starknet
from exercises.contracts.basic.basic import total_customers, sales, submit_sale, Sale_Details
from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import assert_not_zero, assert_not_equal

const add_1 = 0x00348f5537be66815eb7de63295fcb5d8b8b2ffe09bb712af4966db7cbb04a95;
const add_2 = 0x3fe90a1958bb8468fb1b62970747d8a00c435ef96cda708ae8de3d07f1bb56b;

@external
func test_basic{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (tc_start) = total_customers.read();
    assert 0 = tc_start;

    // # Init struct
    let sale_ex = Sale_Details(1, 1, 0);

    // # Call submit_sale
    submit_sale(1, 0, 0, add_1, add_2, 2);

    let (tc_end) = total_customers.read();
    assert 1 = tc_end;

    return ();
}
