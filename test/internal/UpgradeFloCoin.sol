// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {FloCoin} from "../../src/coin/FloCoin.sol";

contract UpgradeFloCoin is FloCoin {
    function upgradeMessage() public pure returns (string memory) {
        return "UpgradeFloCoin";
    }
}
