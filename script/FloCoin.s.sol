// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {FloCoin} from "../src/coin/FloCoin.sol";
import {Script, console} from "forge-std/Script.sol";
import {FloCoinProxy} from "../src/coin/FloCoinProxy.sol";

contract FloCoinScript is Script {
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Constants                                                  •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    uint256 public constant TOTAL_SUPPLY = 15_000_000 * 10 ** 18;

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Vars                                                       •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    address[] public to;
    uint256[] public amount;

    function setUp() public {}

    function run() public {
        to.push(msg.sender);
        amount.push(TOTAL_SUPPLY);

        vm.startBroadcast();
        FloCoin flocoin = new FloCoin();
        vm.stopBroadcast();

        vm.startBroadcast();
        bytes memory data_ = abi.encodeWithSelector(FloCoin.initialize.selector, msg.sender, to, amount);
        FloCoinProxy flocoinProxy = new FloCoinProxy(address(flocoin), data_);
        vm.stopBroadcast();

        console.log("flocoinProxy:", address(flocoinProxy));
    }
}
