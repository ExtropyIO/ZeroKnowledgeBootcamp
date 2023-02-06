%lang starknet
from exercises.contracts.storage.storage import get_balance, set_balance
from starkware.cairo.common.cairo_builtins import HashBuiltin

@external
func test_get_balance{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (balance) = get_balance();
    assert 0 = balance;

    return ();
}

@external
func test_set_balance{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    set_balance(42);
    let (balance) = get_balance();
    assert 42 = balance;

    set_balance(-8);
    let (balance) = get_balance();
    assert -8 = balance;

    return ();
}
