# ERC721 contract

This contract imports openzeppelin libraries downlaoded locally and stored in `/openzeppelin` directory.

Once more some additional features are to be added.

Tests will run against any implementations.

## Features to implement

As in other exercises functions declarations are provided, their names and parameters are not to be changed as it would break the tests (further). Likewise, tests are not to be changed, but can be used for reference.

## Mint index

Change minting procedure so that rathar than passing an ID, instead it fetches one from a storage variable named `counter()`. After minting current index of `counter()` is changed to be + 1.

## Original owner

Implement a look-up table (`og_owner(tokenId: Uint256)`) for who the initial buyer was that persists despite transfers.
