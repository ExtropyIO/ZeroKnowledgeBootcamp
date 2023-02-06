%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.starknet.common.syscalls import get_caller_address

namespace Roles:
    const Mint = 'm'
    const Burn = 'b'
end

@storage_var
func owns(addy : felt) -> (value : felt):
end

func allow{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    addr : felt, role : felt
):
    owns.write(addr, role)
    return ()
end

func can{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(role : felt) -> (
    bool : felt
):
    let (caller) = get_caller_address()
    let (can_do) = owns.read(caller)
    if can_do == role:
        return (TRUE)
    else:
        return (FALSE)
    end
end