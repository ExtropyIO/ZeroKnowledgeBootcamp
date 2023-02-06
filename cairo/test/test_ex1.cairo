%lang starknet
from exercises.programs.ex1 import log_value
@external
func test_log_value{syscall_ptr: felt*, range_check_ptr}() {
   // value to pass
    let p = 42;

    %{ print(f"passing value: {ids.p}") %}

    log_value(p);

    return ();
}
