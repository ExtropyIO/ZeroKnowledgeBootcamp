from starkware.cairo.common.hash_state import hash_init, hash_update
from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.alloc import alloc

func hash_felt{pedersen_ptr: HashBuiltin*}(numb: felt) -> (hash: felt) {
    alloc_locals;
    let (local array: felt*) = alloc();
    assert array[0] = numb;
    assert array[1] = 1;
    let (hash_state_ptr) = hash_init();
    let (hash_state_ptr) = hash_update{hash_ptr=pedersen_ptr}(hash_state_ptr, array, 2);
    tempvar pedersen_ptr: HashBuiltin* = pedersen_ptr;
    return (hash_state_ptr.current_hash,);
}
