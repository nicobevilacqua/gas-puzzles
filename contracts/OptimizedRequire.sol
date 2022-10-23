// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract OptimizedRequire {
    uint256 lastPurchaseTime;

    error CannotPurchase();

    function purchaseToken() external payable {
        assembly {
            if or(
                lt(timestamp(), add(sload(lastPurchaseTime.slot), 60)), // 60 seconds
                iszero(eq(callvalue(), 100000000000000000)) // 0.1 ether
            ) {
                let fmp := mload(0x40)
                mstore(fmp, shl(232, 8111739)) // custom error selector + 232 zeros
                revert(fmp, 4)
            }

            sstore(lastPurchaseTime.slot, timestamp())
        }
    }
}
