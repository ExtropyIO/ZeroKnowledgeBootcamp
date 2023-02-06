%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import assert_le

struct Token:
    member name : felt
    member symbol : felt
    member decimals : felt
end

@event
func info(token : Token):
end

@storage_var
func info() -> (token : Token):
end

@storage_var
func total() -> (supply : felt):
end

@storage_var
func owns(addy : felt) -> (value : felt):
end

@storage_var
func allowance(owner : felt, spender : felt) -> (allowance : felt):
end

func token_init{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(token : Token):
    info.write(token)
    return ()
end

func token_info{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    token : Token
):
    let (token) = info.read()
    return (token)
end

func token_total{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    supply : felt
):
    let (supply) = total.read()
    return (supply)
end

func token_owns{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(who : felt) -> (
    has : felt
):
    let (supply) = owns.read(who)
    return (supply)
end

func token_allowance{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    owner : felt, spender : felt
) -> (left : felt):
    let (left) = allowance.read(owner, spender)
    return (left)
end

func token_approve{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    to : felt, amount : felt
):
    let (caller) = get_caller_address()
    allowance.write(caller, to, amount)
    return ()
end

func token_transfer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    _from : felt, to : felt, amount : felt
):
    alloc_locals
    let (caller) = get_caller_address()
    if _from != caller:
        let (dough) = allowance.read(_from, to)
        assert_le(amount, dough)
        allowance.write(_from, to, dough - amount)
        tempvar syscall_ptr = syscall_ptr
        tempvar pedersen_ptr = pedersen_ptr
        tempvar range_check_ptr = range_check_ptr
    else:
        tempvar syscall_ptr = syscall_ptr
        tempvar pedersen_ptr = pedersen_ptr
        tempvar range_check_ptr = range_check_ptr
    end
    let (from_owns) = owns.read(_from)
    assert_le(amount, from_owns)
    owns.write(_from, from_owns - amount)
    let (to_owns) = owns.read(to)
    owns.write(to, to_owns + amount)
    return ()
end

func token_mint{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    to : felt, amount : felt
):
    let (has) = owns.read(to)
    owns.write(to, has + amount)
    let (tot) = total.read()
    total.write(tot + amount)
    return ()
end

func token_burn{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    _from : felt, amount : felt
):
    let (has) = owns.read(_from)
    assert_le(amount, has)
    owns.write(_from, has - amount)
    let (tot) = total.read()
    total.write(tot - amount)
    return ()
end