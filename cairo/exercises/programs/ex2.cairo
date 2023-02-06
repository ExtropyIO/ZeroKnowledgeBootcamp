from starkware.cairo.common.uint256 import Uint256

// Modify both functions so that they increment
// supplied value and return it
func add_one(y: felt) -> (val: felt) {
    return (y,);
}

func add_one_U256{range_check_ptr}(y: Uint256) -> (val: Uint256) {
    return (y,);
}
