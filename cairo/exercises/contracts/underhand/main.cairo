%lang starknet

from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero, assert_not_equal, split_felt
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address
from own import Roles, allow, can
from tkn import (
    Token,
    token_info,
    token_init,
    token_total,
    token_owns,
    token_mint,
    token_burn,
    token_allowance,
    token_approve,
    token_transfer,
)


#
# Constructor
#

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    name : felt,
    symbol : felt,
    decimals : felt,
    minter : felt,
    burner : felt,
    treasury_addr : felt,
    treasury_amount : felt,
):
    assert_not_zero(minter)
    assert_not_zero(burner)
    assert_not_zero(treasury_addr)
    assert_not_equal(minter, burner)
    let token = Token(name=name, symbol=symbol, decimals=decimals)
    token_init(token)
    allow(minter, Roles.Mint)
    allow(burner, Roles.Burn)
    token_mint(treasury_addr, treasury_amount)
    return ()
end

#
# Getters
#

@view
func name{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (name : felt):
    let (token) = token_info()
    return (token.name)
end

@view
func symbol{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (symbol : felt):
    let (token) = token_info()
    return (token.symbol)
end

@view
func decimals{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    decimals : felt
):
    let (token) = token_info()
    return (token.decimals)
end

@view
func totalSupply{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    totalSupply : Uint256
):
    alloc_locals
    let (supply) = token_total()
    let (as_uint) = to_uint(supply)
    return (as_uint)
end

@view
func balanceOf{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(who : felt) -> (
    balanceOf : Uint256
):
    alloc_locals
    let (supply) = token_owns(who)
    let (as_uint) = to_uint(supply)
    return (as_uint)
end

@view
func allowance{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    owner : felt, spender : felt
) -> (left : felt):
    let (left) = token_allowance(owner, spender)
    return (left)
end

#
# Externals
#

@external
func approve{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    spender : felt, amount : felt
) -> (success : felt):
    assert_not_zero(spender)
    assert_not_zero(amount)
    token_approve(spender, amount)
    return (TRUE)
end

@external
func transfer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    recipient : felt, amount : felt
) -> (success : felt):
    assert_not_zero(recipient)
    let (caller) = get_caller_address()
    token_transfer(caller, recipient, amount)
    return (TRUE)
end

@external
func transferFrom{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    sender : felt, recipient : felt, amount : felt
) -> (success : felt):
    assert_not_zero(sender)
    assert_not_zero(recipient)
    token_transfer(sender, recipient, amount)
    return (TRUE)
end

@external
func mint{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    to : felt, amount : felt
):
    assert_not_zero(to)
    let (check) = can(Roles.Mint)
    assert check = TRUE
    token_mint(to, amount)
    return ()
end

@external
func burn{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    _from : felt, amount : felt
):
    assert_not_zero(_from)
    let (check) = can(Roles.Burn)
    assert check = TRUE
    token_burn(_from, amount)
    return ()
end

func to_uint{range_check_ptr}(value : felt) -> (value : Uint256):
    let (low, high) = split_felt(value)
    return (Uint256(low, high))
end