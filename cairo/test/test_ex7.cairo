%lang starknet
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin

from exercises.programs.ex7 import pattern

@external
func test_patternt{syscall_ptr: felt*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

   // test nice numbers
    //###############################################################################################
    let (nice_pattern) = pattern(n=170, idx=0, exp=0, broken_chain=0);
    assert nice_pattern = 1;

    let (nice_pattern) = pattern(n=10, idx=0, exp=0, broken_chain=0);
    assert nice_pattern = 1;

    let (nice_pattern) = pattern(n=43690, idx=0, exp=0, broken_chain=0);
    assert nice_pattern = 1;

    let (nice_pattern) = pattern(n=1398101, idx=0, exp=0, broken_chain=0);
    assert nice_pattern = 1;

   // test not-nice numbers
    //###############################################################################################
    let (nice_pattern) = pattern(n=17, idx=0, exp=0, broken_chain=0);
    assert nice_pattern = 0;

    let (nice_pattern) = pattern(n=11, idx=0, exp=0, broken_chain=0);
    assert nice_pattern = 0;

    let (nice_pattern) = pattern(n=43390, idx=0, exp=0, broken_chain=0);
    assert nice_pattern = 0;

    %{
        if ids.nice_pattern == 1:
            print(f"has nice pattern") 
        else:
            print(f"doesn't have a nice pattern")
    %}

    return ();
}
