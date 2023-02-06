## ERC20 contract

This is a contract that inherits from the base ERC20 implementation.

Several features need to be added to improve existing functionality.

Tests will run against any implementations.

You should modify **ONLY** the file `erc20.cairo` in `exercises/contracts/`.

If a feature is complete, run again to see the test output:

### Features to implement

#### Even transfer

Already implemented `transfer()` is a bit boring so modify such that it only allows for transfers of even amounts of Erc20.

#### Faucet

Users may require some of the test tokens for development.

Implement function `faucet()` that will mint specified amount to the caller.

As tokens are (potentially) valuable, cap the maximum amount to be minted and transfered per invocation to 10,000.

#### Burn haircut

Sometimes tokens need to be burned, but there is no reason not to keep some as the contract deployer.

Implement a funcion `burn()` that will:

- take 10% of the amount to be burned and send it to the address of the deployer/admin
- burn the rest

#### Exclusive faucet

Implement a faucet that will allow to mint any amount of tokens, but only to an exclusive list.

To do that three functions are needed:

##### `request_whitelist()`

This function will set in the mapping (which needs to be implemented using the `@storage_var` decorator) value of 1 for any address that requests whitelisting.

##### `check_whitelist()`

This function will check whether the provided address has been whitelisted and will return:

- 1 if the caller has been whitelisted
- 0 if the caller has not been whitelisted

##### `exclusive_faucet()`

This function will accept an amount to be minted, it will then check if the caller has been whitelisted using `check_whitelist()`. If the caller has been whitelisted it will mint any amount that the caller asks for.
