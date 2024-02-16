// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.0;

import "./token.sol";

contract MintableToken is Token {
    int256 public totalMinted;
    int256 public totalMintable;

    constructor(int256 totalMintable_) {
        totalMintable = totalMintable_;
    }

    function mint(int256 value) public onlyOwner {
        require(value > 0);
        require(int256(value) + totalMinted < totalMintable);
        totalMinted += int256(value);

        balances[msg.sender] += uint256(value);
    }
}
