// I AM NOT DONE

%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_le, uint256_unsigned_div_rem, uint256_sub
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import unsigned_div_rem, assert_le_felt, assert_le
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor

struct Sale_Details{
     price: felt,
     item_index: felt, 
     discount_applied: felt,
}

// Variables which are stored on-chain and persist between invocations are prefaced with @storage_var
@storage_var
func total_customers() -> (idx : felt){
}

// Storage index can be composed of multiple values, they can point to a struct too
@storage_var
func sales(buyer : felt, seller : felt, transaction : felt) -> (sale_details : Sale_Details){
}


// Functions marked a as @view should not modify the state
// (but the compiler does not enforce it for now)
@view
func submit_sale{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(price : felt, item_index : felt, discount_applied : felt, buyer : felt, seller : felt, transaction : felt){

    // Variables must be instantiated with either let/tempvar/local
    sale = Sale_Details(price, item_index, discount_applied);

    // Write sale date
    sales.write(buyer, seller, transaction, sale);

    // Get transaction counter
    let tc = total_customers.read();

    // Increment transaction counter
    total_customers.write(tc);

    // Functions must always return something    
}






