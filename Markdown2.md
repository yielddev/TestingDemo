# Mutations

```
Mutation testing report:
Number of mutations:    22
Killed:                 17 / 22

Mutations:

[+] Survivors
Mutation:
    File: /Users/mac/Desktop/Projects/nft_one/src/KoalaPoints.sol
    Line nr: 11
    Result: Lived
    Original line:
             function mint(address to, uint256 amount) public onlyOwner {

    Mutated line:
             function mint(address to, uint256 amount) public  {

Mutation:
    File: /Users/mac/Desktop/Projects/nft_one/src/MasterKoala.sol
    Line nr: 51
    Result: Lived
    Original line:
                 if (block.number <= lastRewardBlock) {

    Mutated line:
                 if (block.number < lastRewardBlock) {

[*] Done! 

```