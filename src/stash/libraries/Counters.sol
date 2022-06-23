// SPDX-License-Identifier: Unlicencd
pragma solidity ^0.8.0;

import './SafeMath.sol';

library Counters {
    using SafeMath for uint256;

    struct Counter {
        uint256 _value;
    }

    // 現在のValueを返す
    function current(Counter storage counter) internal view returns(uint256){
        return counter._value;
    }

    // Valueを１増やす関数
    function increment(Counter storage counter) internal {
        counter._value += 1;
    }

    // Valueを１減らすように関数
    function decrement(Counter storage counter) internal {
        counter._value = counter._value.sub(1);
    }
}