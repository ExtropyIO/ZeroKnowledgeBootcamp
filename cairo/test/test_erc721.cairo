%lang starknet
from starkware.cairo.common.uint256 import Uint256, uint256_sub
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.math import assert_not_equal

const MINT_ADMIN = 0x00348f5537be66815eb7de63295fcb5d8b8b2ffe09bb712af4966db7cbb04a91;
const TEST_ACC1 = 0x00348f5537be66815eb7de63295fcb5d8b8b2ffe09bb712af4966db7cbb04a95;
const TEST_ACC2 = 0x3fe90a1958bb8468fb1b62970747d8a00c435ef96cda708ae8de3d07f1bb56b;

// Need to import openzellin directory to get the interface (or build it)
from openzeppelin.token.erc721.interfaces.IERC721 import IERC721

@external
func __setup__() {
    // Deploy contract erc721
    %{
        context.contract_address  = deploy_contract("./exercises/contracts/erc721/erc721.cairo", [
               5338434412023108646027945078640, ## name:   CairoWorkshop
               17239,                           ## symbol: CW
               ids.MINT_ADMIN,                     ## owner: 10000000000                
               ]).contract_address
    %}

    return ();
}

@external
func test_mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    tempvar contract_address;
    %{ ids.contract_address = context.contract_address %}

    // Call as admin
    %{ stop_prank_callable = start_prank(ids.MINT_ADMIN, ids.contract_address) %}

    // Transfer even amount as mint owner to TEST_ACC1
    IERC721.mint(contract_address=contract_address, to=TEST_ACC1);
    IERC721.mint(contract_address=contract_address, to=MINT_ADMIN);
    %{ stop_prank_callable() %}

    // Call as admin
    %{ stop_prank_callable = start_prank(ids.TEST_ACC1, ids.contract_address) %}

    // Transfer NFT from TEST_ACC1 to TEST_ACC2
    // IERC721.transferFrom(contract_address=contract_address, from_ = TEST_ACC1, to = TEST_ACC2, tokenId = Uint256(0,0))
    %{ stop_prank_callable() %}

    // Check the counter increases afte two mints
    let (current_counter) = IERC721.getCounter(contract_address=contract_address);
    assert current_counter.low = 2;

    return ();
}

@external
func test_og_owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    tempvar contract_address;
    %{ ids.contract_address = context.contract_address %}

    // Call as admin
    %{ stop_prank_callable = start_prank(ids.MINT_ADMIN, ids.contract_address) %}

    // Transfer even amount as mint owner to TEST_ACC1
    IERC721.mint(contract_address=contract_address, to=MINT_ADMIN);
    IERC721.mint(contract_address=contract_address, to=MINT_ADMIN);

    // Transfer NFT from MINT_ADMIN to TEST_ACC2
    IERC721.transferFrom(
        contract_address=contract_address, from_=MINT_ADMIN, to=TEST_ACC2, tokenId=Uint256(1, 0)
    );
    %{ stop_prank_callable() %}

    let (ow) = IERC721.ownerOf(contract_address=contract_address, tokenId=Uint256(1, 0));

    // Check the OG owner vs current owner of the transfered NFT
    let (original_owner) = IERC721.getOriginalOwner(
        contract_address=contract_address, tokenId=Uint256(1, 0)
    );
    assert_not_equal(original_owner, ow);

    return ();
}
