// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts for Cairo v0.2.1 (token/erc721/interfaces/IERC721_Metadata.cairo)

%lang starknet

from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace IERC721_Metadata {
    func name() -> (name: felt) {
    }

    func symbol() -> (symbol: felt) {
    }

    func tokenURI(tokenId: Uint256) -> (tokenURI: felt) {
    }
}
