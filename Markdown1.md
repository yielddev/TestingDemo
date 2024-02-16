## False Positives 

UniswapV2Pair._update(uint256,uint256,uint112,uint112) (src/UniswapV2Pair.sol#75-89) uses a weak PRNG: "blockTimestamp = uint32(block.timestamp % 2 ** 32) (src/UniswapV2Pair.sol#76)"

* Not relevent this line is not used as a PRNG but to convert a uint256 to uint32

Math.mulDiv(uint256,uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#123-202) has bitwise-xor operator ^ instead of the exponentiation operator **: 
         - inverse = (3 * denominator) ^ 2 (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#184)

* mulDiv not implemented

2: UniswapV2Pair.burn(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#159-199) ignores return value by IERC20(address(this)).transferFrom(msg.sender,address(this),liquidity) (src/UniswapV2Pair.sol#170)
    * Trusted token, will revert on failure


8: UniswapV2Pair.mint(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#111-158) performs a multiplication on the result of a division:
        - amount0Optimal = (amount1Desired * _reserve0) / _reserve1 (src/UniswapV2Pair.sol#129)
        - (amount0,amount1) = (amount0Optimal,amount1Desired) (src/UniswapV2Pair.sol#133)
        - liquidity = Math.min((amount0 * _totalSupply) / _reserve0,(amount1 * _totalSupply) / _reserve1) (src/UniswapV2Pair.sol#151)
9: UniswapV2Pair.mint(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#111-158) performs a multiplication on the result of a division:
        - amount0Optimal = (amount1Desired * _reserve0) / _reserve1 (src/UniswapV2Pair.sol#129)
        - (amount0,amount1) = (amount0Optimal,amount1Desired) (src/UniswapV2Pair.sol#133)
        - liquidity = Math.sqrt(amount0 * amount1) - MINIMUM_LIQUIDITY (src/UniswapV2Pair.sol#148)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#divide-before-multiply

    * Fix unclear multiplication is before division

0: UniswapV2Pair._safeTransfer(address,address,uint256) (src/UniswapV2Pair.sol#57-60) uses a dangerous strict equality:
        - require(bool,string)(success && (data.length == 0 || abi.decode(data,(bool))),UniswapV2: TRANSFER_FAILED) (src/UniswapV2Pair.sol#59)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#dangerous-strict-equalities

    * Not relevant, other checks used

0: Reentrancy in UniswapV2Factory.createPair(address,address) (src/UniswapV2Factory.sol#27-42):
        External calls:
        - IUniswapV2Pair(pair).initialize(token0,token1) (src/UniswapV2Factory.sol#37)
        Event emitted after the call(s):
        - PairCreated(token0,token1,pair,allPairs.length) (src/UniswapV2Factory.sol#41)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-3

    * External contract is trusted
## True Positives

UniswapV2Pair.mint(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#111-158) performs a multiplication on the result of a division:
        - amount0Optimal = amount1Desired * _reserve0 / _reserve1 (src/UniswapV2Pair.sol#129)
        - (amount0,amount1) = (amount0Optimal,amount1Desired) (src/UniswapV2Pair.sol#133)
        - liquidity = Math.min(amount0 * _totalSupply / _reserve0,amount1 * _totalSupply / _reserve1) (src/UniswapV2Pair.sol#151)
UniswapV2Pair.mint(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#111-158) performs a multiplication on the result of a division:
        - amount0Optimal = amount1Desired * _reserve0 / _reserve1 (src/UniswapV2Pair.sol#129)
        - (amount0,amount1) = (amount0Optimal,amount1Desired) (src/UniswapV2Pair.sol#133)
        - liquidity = Math.sqrt(amount0 * amount1) - MINIMUM_LIQUIDITY (src/UniswapV2Pair.sol#148)

0: UniswapV2Pair.mint(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#111-158) ignores return value by ERC20(token0).transferFrom(msg.sender,address(this),amount0) (src/UniswapV2Pair.sol#137)
1: UniswapV2Pair.mint(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#111-158) ignores return value by ERC20(token1).transferFrom(msg.sender,address(this),amount1) (src/UniswapV2Pair.sol#138)

3: UniswapV2Pair.burn(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#159-199) ignores return value by ERC20(token0).transfer(to,amount0) (src/UniswapV2Pair.sol#191)
4: UniswapV2Pair.burn(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#159-199) ignores return value by ERC20(token1).transfer(to,amount1) (src/UniswapV2Pair.sol#192)
5: UniswapV2Pair.swapExactTokensForTokens(uint256,uint256,address,address,uint256) (src/UniswapV2Pair.sol#201-221) ignores return value by IERC20(tokenIn).transferFrom(msg.sender,address(this),amountIn) (src/UniswapV2Pair.sol#216)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#unchecked-transfer

    * Need to check if arbitrary tokens transfer fails

8: UniswapV2Pair.mint(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#111-158) performs a multiplication on the result of a division:
        - amount0Optimal = (amount1Desired * _reserve0) / _reserve1 (src/UniswapV2Pair.sol#129)
        - (amount0,amount1) = (amount0Optimal,amount1Desired) (src/UniswapV2Pair.sol#133)
        - liquidity = Math.min((amount0 * _totalSupply) / _reserve0,(amount1 * _totalSupply) / _reserve1) (src/UniswapV2Pair.sol#151)
9: UniswapV2Pair.mint(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#111-158) performs a multiplication on the result of a division:
        - amount0Optimal = (amount1Desired * _reserve0) / _reserve1 (src/UniswapV2Pair.sol#129)
        - (amount0,amount1) = (amount0Optimal,amount1Desired) (src/UniswapV2Pair.sol#133)
        - liquidity = Math.sqrt(amount0 * amount1) - MINIMUM_LIQUIDITY (src/UniswapV2Pair.sol#148)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#divide-before-multiply

    * Fix unclear multiplication is before division

    0: Reentrancy in UniswapV2Pair.burn(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#159-199):
        External calls:
        - IERC20(address(this)).transferFrom(msg.sender,address(this),liquidity) (src/UniswapV2Pair.sol#170)
        - ERC20(token0).transfer(to,amount0) (src/UniswapV2Pair.sol#191)
        - ERC20(token1).transfer(to,amount1) (src/UniswapV2Pair.sol#192)
        State variables written after the call(s):
        - _update(balance0,balance1,_reserve0,_reserve1) (src/UniswapV2Pair.sol#196)
                - blockTimestampLast = blockTimestamp (src/UniswapV2Pair.sol#87)
        UniswapV2Pair.blockTimestampLast (src/UniswapV2Pair.sol#38) can be used in cross function reentrancies:
        - UniswapV2Pair._update(uint256,uint256,uint112,uint112) (src/UniswapV2Pair.sol#75-89)
        - UniswapV2Pair.getReserves() (src/UniswapV2Pair.sol#52-56)
        - kLast = uint256(reserve0) * (reserve1) (src/UniswapV2Pair.sol#197)
        UniswapV2Pair.kLast (src/UniswapV2Pair.sol#42) can be used in cross function reentrancies:
        - UniswapV2Pair._mintFee(uint112,uint112) (src/UniswapV2Pair.sol#91-109)
        - UniswapV2Pair.burn(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#159-199)
        - UniswapV2Pair.kLast (src/UniswapV2Pair.sol#42)
        - UniswapV2Pair.mint(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#111-158)
        - _update(balance0,balance1,_reserve0,_reserve1) (src/UniswapV2Pair.sol#196)
                - reserve0 = uint112(balance0) (src/UniswapV2Pair.sol#85)
        UniswapV2Pair.reserve0 (src/UniswapV2Pair.sol#36) can be used in cross function reentrancies:
        - UniswapV2Pair._update(uint256,uint256,uint112,uint112) (src/UniswapV2Pair.sol#75-89)
        - UniswapV2Pair.burn(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#159-199)
        - UniswapV2Pair.getReserves() (src/UniswapV2Pair.sol#52-56)
        - UniswapV2Pair.mint(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#111-158)
        - UniswapV2Pair.skim(address) (src/UniswapV2Pair.sol#266-273)
        - UniswapV2Pair.swapExactTokensForTokens(uint256,uint256,address,address,uint256) (src/UniswapV2Pair.sol#201-221)
        - UniswapV2Pair.sync() (src/UniswapV2Pair.sol#275-277)
        - _update(balance0,balance1,_reserve0,_reserve1) (src/UniswapV2Pair.sol#196)
                - reserve1 = uint112(balance1) (src/UniswapV2Pair.sol#86)
        UniswapV2Pair.reserve1 (src/UniswapV2Pair.sol#37) can be used in cross function reentrancies:
        - UniswapV2Pair._update(uint256,uint256,uint112,uint112) (src/UniswapV2Pair.sol#75-89)
        - UniswapV2Pair.burn(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#159-199)
        - UniswapV2Pair.getReserves() (src/UniswapV2Pair.sol#52-56)
        - UniswapV2Pair.mint(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#111-158)
        - UniswapV2Pair.skim(address) (src/UniswapV2Pair.sol#266-273)
        - UniswapV2Pair.swapExactTokensForTokens(uint256,uint256,address,address,uint256) (src/UniswapV2Pair.sol#201-221)
        - UniswapV2Pair.sync() (src/UniswapV2Pair.sol#275-277)
1: Reentrancy in UniswapV2Factory.createPair(address,address) (src/UniswapV2Factory.sol#27-42):
        External calls:
        - IUniswapV2Pair(pair).initialize(token0,token1) (src/UniswapV2Factory.sol#37)
        State variables written after the call(s):
        - getPair[token0][token1] = pair (src/UniswapV2Factory.sol#38)
        UniswapV2Factory.getPair (src/UniswapV2Factory.sol#15) can be used in cross function reentrancies:
        - UniswapV2Factory.createPair(address,address) (src/UniswapV2Factory.sol#27-42)
        - UniswapV2Factory.getPair (src/UniswapV2Factory.sol#15)
        - getPair[token1][token0] = pair (src/UniswapV2Factory.sol#39)
        UniswapV2Factory.getPair (src/UniswapV2Factory.sol#15) can be used in cross function reentrancies:
        - UniswapV2Factory.createPair(address,address) (src/UniswapV2Factory.sol#27-42)
        - UniswapV2Factory.getPair (src/UniswapV2Factory.sol#15)
2: Reentrancy in UniswapV2Pair.mint(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#111-158):
        External calls:
        - ERC20(token0).transferFrom(msg.sender,address(this),amount0) (src/UniswapV2Pair.sol#137)
        - ERC20(token1).transferFrom(msg.sender,address(this),amount1) (src/UniswapV2Pair.sol#138)
        State variables written after the call(s):
        - _update(balance0,balance1,_reserve0,_reserve1) (src/UniswapV2Pair.sol#155)
                - blockTimestampLast = blockTimestamp (src/UniswapV2Pair.sol#87)
        UniswapV2Pair.blockTimestampLast (src/UniswapV2Pair.sol#38) can be used in cross function reentrancies:
        - UniswapV2Pair._update(uint256,uint256,uint112,uint112) (src/UniswapV2Pair.sol#75-89)
        - UniswapV2Pair.getReserves() (src/UniswapV2Pair.sol#52-56)
        - _update(balance0,balance1,_reserve0,_reserve1) (src/UniswapV2Pair.sol#155)
                - reserve0 = uint112(balance0) (src/UniswapV2Pair.sol#85)
        UniswapV2Pair.reserve0 (src/UniswapV2Pair.sol#36) can be used in cross function reentrancies:
        - UniswapV2Pair._update(uint256,uint256,uint112,uint112) (src/UniswapV2Pair.sol#75-89)
        - UniswapV2Pair.burn(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#159-199)
        - UniswapV2Pair.getReserves() (src/UniswapV2Pair.sol#52-56)
        - UniswapV2Pair.mint(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#111-158)
        - UniswapV2Pair.skim(address) (src/UniswapV2Pair.sol#266-273)
        - UniswapV2Pair.swapExactTokensForTokens(uint256,uint256,address,address,uint256) (src/UniswapV2Pair.sol#201-221)
        - UniswapV2Pair.sync() (src/UniswapV2Pair.sol#275-277)
        - _update(balance0,balance1,_reserve0,_reserve1) (src/UniswapV2Pair.sol#155)
                - reserve1 = uint112(balance1) (src/UniswapV2Pair.sol#86)
        UniswapV2Pair.reserve1 (src/UniswapV2Pair.sol#37) can be used in cross function reentrancies:
        - UniswapV2Pair._update(uint256,uint256,uint112,uint112) (src/UniswapV2Pair.sol#75-89)
        - UniswapV2Pair.burn(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#159-199)
        - UniswapV2Pair.getReserves() (src/UniswapV2Pair.sol#52-56)
        - UniswapV2Pair.mint(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#111-158)
        - UniswapV2Pair.skim(address) (src/UniswapV2Pair.sol#266-273)
        - UniswapV2Pair.swapExactTokensForTokens(uint256,uint256,address,address,uint256) (src/UniswapV2Pair.sol#201-221)
        - UniswapV2Pair.sync() (src/UniswapV2Pair.sol#275-277)
3: Reentrancy in UniswapV2Pair.swap(uint256,uint256,address) (src/UniswapV2Pair.sol#223-264):
        External calls:
        - _safeTransfer(_token0,to,amount0Out) (src/UniswapV2Pair.sol#242)
                - (success,data) = token.call(abi.encodeWithSelector(SELECTOR,to,value)) (src/UniswapV2Pair.sol#58)
        - _safeTransfer(_token1,to,amount1Out) (src/UniswapV2Pair.sol#243)
                - (success,data) = token.call(abi.encodeWithSelector(SELECTOR,to,value)) (src/UniswapV2Pair.sol#58)
        State variables written after the call(s):
        - _update(balance0,balance1,_reserve0,_reserve1) (src/UniswapV2Pair.sol#261)
                - blockTimestampLast = blockTimestamp (src/UniswapV2Pair.sol#87)
        UniswapV2Pair.blockTimestampLast (src/UniswapV2Pair.sol#38) can be used in cross function reentrancies:
        - UniswapV2Pair._update(uint256,uint256,uint112,uint112) (src/UniswapV2Pair.sol#75-89)
        - UniswapV2Pair.getReserves() (src/UniswapV2Pair.sol#52-56)
        - _update(balance0,balance1,_reserve0,_reserve1) (src/UniswapV2Pair.sol#261)
                - reserve0 = uint112(balance0) (src/UniswapV2Pair.sol#85)
        UniswapV2Pair.reserve0 (src/UniswapV2Pair.sol#36) can be used in cross function reentrancies:
        - UniswapV2Pair._update(uint256,uint256,uint112,uint112) (src/UniswapV2Pair.sol#75-89)
        - UniswapV2Pair.burn(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#159-199)
        - UniswapV2Pair.getReserves() (src/UniswapV2Pair.sol#52-56)
        - UniswapV2Pair.mint(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#111-158)
        - UniswapV2Pair.skim(address) (src/UniswapV2Pair.sol#266-273)
        - UniswapV2Pair.swapExactTokensForTokens(uint256,uint256,address,address,uint256) (src/UniswapV2Pair.sol#201-221)
        - UniswapV2Pair.sync() (src/UniswapV2Pair.sol#275-277)
        - _update(balance0,balance1,_reserve0,_reserve1) (src/UniswapV2Pair.sol#261)
                - reserve1 = uint112(balance1) (src/UniswapV2Pair.sol#86)
        UniswapV2Pair.reserve1 (src/UniswapV2Pair.sol#37) can be used in cross function reentrancies:
        - UniswapV2Pair._update(uint256,uint256,uint112,uint112) (src/UniswapV2Pair.sol#75-89)
        - UniswapV2Pair.burn(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#159-199)
        - UniswapV2Pair.getReserves() (src/UniswapV2Pair.sol#52-56)
        - UniswapV2Pair.mint(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#111-158)
        - UniswapV2Pair.skim(address) (src/UniswapV2Pair.sol#266-273)
        - UniswapV2Pair.swapExactTokensForTokens(uint256,uint256,address,address,uint256) (src/UniswapV2Pair.sol#201-221)
        - UniswapV2Pair.sync() (src/UniswapV2Pair.sol#275-277)
4: Reentrancy in UniswapV2Pair.swapExactTokensForTokens(uint256,uint256,address,address,uint256) (src/UniswapV2Pair.sol#201-221):
        External calls:
        - IERC20(tokenIn).transferFrom(msg.sender,address(this),amountIn) (src/UniswapV2Pair.sol#216)
        - swap(amount0Out,amount1Out,to) (src/UniswapV2Pair.sol#218)
                - (success,data) = token.call(abi.encodeWithSelector(SELECTOR,to,value)) (src/UniswapV2Pair.sol#58)
        State variables written after the call(s):
        - swap(amount0Out,amount1Out,to) (src/UniswapV2Pair.sol#218)
                - reserve0 = uint112(balance0) (src/UniswapV2Pair.sol#85)
        UniswapV2Pair.reserve0 (src/UniswapV2Pair.sol#36) can be used in cross function reentrancies:
        - UniswapV2Pair._update(uint256,uint256,uint112,uint112) (src/UniswapV2Pair.sol#75-89)
        - UniswapV2Pair.burn(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#159-199)
        - UniswapV2Pair.getReserves() (src/UniswapV2Pair.sol#52-56)
        - UniswapV2Pair.mint(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#111-158)
        - UniswapV2Pair.skim(address) (src/UniswapV2Pair.sol#266-273)
        - UniswapV2Pair.swapExactTokensForTokens(uint256,uint256,address,address,uint256) (src/UniswapV2Pair.sol#201-221)
        - UniswapV2Pair.sync() (src/UniswapV2Pair.sol#275-277)
        - swap(amount0Out,amount1Out,to) (src/UniswapV2Pair.sol#218)
                - reserve1 = uint112(balance1) (src/UniswapV2Pair.sol#86)
        UniswapV2Pair.reserve1 (src/UniswapV2Pair.sol#37) can be used in cross function reentrancies:
        - UniswapV2Pair._update(uint256,uint256,uint112,uint112) (src/UniswapV2Pair.sol#75-89)
        - UniswapV2Pair.burn(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#159-199)
        - UniswapV2Pair.getReserves() (src/UniswapV2Pair.sol#52-56)
        - UniswapV2Pair.mint(address,uint256,uint256,uint256,uint256) (src/UniswapV2Pair.sol#111-158)
        - UniswapV2Pair.skim(address) (src/UniswapV2Pair.sol#266-273)
        - UniswapV2Pair.swapExactTokensForTokens(uint256,uint256,address,address,uint256) (src/UniswapV2Pair.sol#201-221)
        - UniswapV2Pair.sync() (src/UniswapV2Pair.sol#275-277)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-1


    * Reentrancy gaurd missing