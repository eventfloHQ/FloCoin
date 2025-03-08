// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {FloCoin} from "../src/coin/FloCoin.sol";

import {FloCoinProxy} from "../src/coin/FloCoinProxy.sol";
import {Script, console} from "forge-std/Script.sol";

contract FloCoinScript is Script {

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Constants                                                  •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    // TODO: change to the actual owner and to
    address public constant OWNER = 0x0000000000000000000000000000000000000000;
    address public constant TO = 0x0000000000000000000000000000000000000000;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        FloCoin flocoin = new FloCoin();
        vm.stopBroadcast();

        vm.startBroadcast();
        bytes memory data_ = abi.encodeWithSelector(FloCoin.initialize.selector, OWNER, TO);
        FloCoinProxy flocoinProxy = new FloCoinProxy(address(flocoin), data_);
        vm.stopBroadcast();

        console.log("flocoinProxy:", address(flocoinProxy));
    }

}
