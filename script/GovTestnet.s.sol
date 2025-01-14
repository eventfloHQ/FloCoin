// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {FloCoin} from "../src/coin/FloCoin.sol";
import {FloCoinProxy} from "../src/coin/FloCoinProxy.sol";
import {FloCoinGovernor} from "../src/governor/FloCoinGovernor.sol";

import {Script, console} from "forge-std/src/Script.sol";

contract GovTestnetScript is Script {
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Coin Params                                               •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    uint256 public constant TOTAL_SUPPLY = 5_000_000 * 10 ** 18;

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Gov Params                                                 •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    uint48 public constant VOTE_DELAY = 0;
    uint32 public constant VOTE_PERIOD = 3 minutes;
    uint256 public constant QUORUM_NUMERATOR = 10;
    uint256 public constant VOTE_THRESHOLD = 20_000 * 10 ** 18;
    uint256 public constant PROPOSAL_THRESHOLD = 20_000 * 10 ** 18;

    function setUp() public {}

    function run() public {
        // deploy testcoin
        vm.startBroadcast();
        FloCoin testcoin = new FloCoin();
        vm.stopBroadcast();

        vm.startBroadcast();
        bytes memory data_ = abi.encodeWithSelector(FloCoin.initialize.selector, msg.sender, TOTAL_SUPPLY);
        FloCoinProxy testcoinProxy = new FloCoinProxy(address(testcoin), data_);
        vm.stopBroadcast();

        console.log("token address:", address(testcoinProxy));

        // deploy governor
        vm.startBroadcast();
        FloCoinGovernor governor = new FloCoinGovernor(address(testcoinProxy), VOTE_DELAY, VOTE_PERIOD, PROPOSAL_THRESHOLD, QUORUM_NUMERATOR, VOTE_THRESHOLD);
        vm.stopBroadcast();

        console.log("governor address:", address(governor));
    }
}
