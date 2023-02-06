%lang starknet
from exercises.programs.ex5 import abs_eq

@external
func test_abs_eq{syscall_ptr: felt*, range_check_ptr}() {
   // test same sign, same magnitudes
    let (r) = abs_eq(5, 5);
    assert 1 = r;

    let (r) = abs_eq(-2, -2);
    assert 1 = r;

   // test opposite sign, same magnitudes
    let (r) = abs_eq(-4, 4);
    assert 1 = r;

   // test same sign, different magnitudes
    let (r) = abs_eq(3, 40);
    assert 0 = r;

   // test different sign, different magnitudes
    let (r) = abs_eq(-3, 89);
    assert 0 = r;

    return ();
}
