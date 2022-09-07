## I AM NOT DONE

from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin

## Implement a function that sums even numbers from the provided array 
func sum_even{bitwise_ptr : BitwiseBuiltin*}(arr_len : felt, arr : felt*, run : felt, idx : felt) -> (sum : felt):
    return(0)
end
