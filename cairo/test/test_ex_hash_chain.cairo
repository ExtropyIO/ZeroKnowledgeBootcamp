%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin

from exercises.programs.ex_hash_chain import hash_chain

@external
func test_hash_chain{pedersen_ptr: HashBuiltin*}() {
    alloc_locals;

    let (local array: felt*) = alloc();
    assert array[0] = 1;
    assert array[1] = 4;
    let (result) = hash_chain{hash_ptr=pedersen_ptr}(array, 2);
    assert 1323616023845704258113538348000047149470450086307731200728039607710316625916 = result;

    let (local array: felt*) = alloc();
    assert array[0] = 2; // YES
    assert array[1] = 100;
    assert array[2] = 12;
    assert array[3] = 2; // YES
    assert array[4] = 422; // YES
    assert array[5] = 898;
    assert array[6] = 10;
    assert array[7] = 31;
    assert array[8] = 22;
    assert array[9] = 5;
    let (result) = hash_chain{hash_ptr=pedersen_ptr}(array, 10);
    assert 2185907157710685805186499755291718313025201005027499629005977263373594646427 = result;

    return ();
}
