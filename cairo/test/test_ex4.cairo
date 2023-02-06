%lang starknet
from exercises.programs.ex4 import calculate_sum

@external
func test_calculate_sum{syscall_ptr: felt*, range_check_ptr}() {
    let (r) = calculate_sum(5);
    assert 15 = r;

    let (r) = calculate_sum(10);
    assert 55 = r;
    return ();
}
