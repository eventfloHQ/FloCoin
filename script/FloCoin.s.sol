// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {FloCoin} from "../src/FloCoin.sol";
import {FloCoinProxy} from "../src/FloCoinProxy.sol";
import {Script, console} from "forge-std/src/Script.sol";

contract FloCoinScript is Script {
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Constants                                                  •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    address public constant TO = 0x0000000000000000000000000000000000000000;
    uint256 public constant TOTAL_SUPPLY = 15_000_000 * 10 ** 18;

    function setUp() public {}

    function run() public {
        FloCoin flocoin = new FloCoin();

        bytes memory data_ = abi.encodeWithSelector(FloCoin.initialize.selector, TO, TOTAL_SUPPLY);
        FloCoinProxy flocoinProxy = new FloCoinProxy(address(flocoin), data_);

        console.log("flocoinProxy:", address(flocoinProxy));
    }
}
