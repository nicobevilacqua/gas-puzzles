// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract OptimizedRequire {
    uint256 constant COOLDOWN = 1 minutes;
    uint256 constant VALUE = 0.1 ether;
    uint256 lastPurchaseTime;

    error CannotPurchase();

    function purchaseToken() external payable {
        unchecked {
            if (msg.value != VALUE) {
                revert CannotPurchase();
            }

            // first time
            if (lastPurchaseTime == 0) {
                lastPurchaseTime = block.timestamp;
                return;
            }

            if (block.timestamp < lastPurchaseTime + COOLDOWN) {
                revert CannotPurchase();
            }

            lastPurchaseTime = block.timestamp;
        }
    }
}
