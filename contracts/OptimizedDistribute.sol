// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract OptimizedDistribute {
    address immutable contributor1;
    address immutable contributor2;
    address immutable contributor3;
    address immutable contributor4;
    uint256 public createTime;

    error CannotDistribute();

    constructor(address[4] memory _contributors) payable {
        contributor1 = _contributors[0];
        contributor2 = _contributors[1];
        contributor3 = _contributors[2];
        contributor4 = _contributors[3];
        createTime = block.timestamp;
    }

    function distribute() external payable {
        if (block.timestamp <= createTime + 1 weeks) {
            revert CannotDistribute();
        }
        unchecked {
            uint256 amount = address(this).balance / 4;
            contributor1.call{value: amount}("");
            contributor2.call{value: amount}("");
            contributor3.call{value: amount}("");
            selfdestruct(payable(contributor3));
        }
    }

    function send(address beneficiary, uint256 amount) private {
        assembly {
            let x := mload(0x40) // get empty storage location
            mstore(x, 0xffff) // 4 bytes - place signature in empty storage
            pop(
                call(
                    2100,
                    beneficiary,
                    amount,
                    x, // input
                    0x04, // input size = 4 bytes
                    x, // output stored at input location, save space
                    0x0 // output size = 0 bytes
                )
            )
        }
    }
}
