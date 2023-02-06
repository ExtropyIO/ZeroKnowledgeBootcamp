%lang starknet
from exercises.programs.ex2 import add_one, add_one_U256
from starkware.cairo.common.uint256 import Uint256, uint256_add

@external
func test_add_one{syscall_ptr: felt*, range_check_ptr}() {
    let (r) = add_one(4);
    assert r = 5;

    let (r) = add_one(88);
    assert r = 89;
    return ();
}

@external
func test_add_one_U256{syscall_ptr: felt*, range_check_ptr}() {
    let (r) = add_one_U256(Uint256(4, 0));
    assert r.low = 5;

    let (r) = add_one_U256(Uint256(88, 0));
    assert r.low = 89;
    return ();
}
