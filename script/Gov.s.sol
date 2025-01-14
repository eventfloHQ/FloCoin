// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/src/Script.sol";

import {FloCoin} from "../src/coin/FloCoin.sol";
import {FloCoinGovernor} from "../src/governor/FloCoinGovernor.sol";
import {IVotes} from "@openzeppelin/contracts/governance/utils/IVotes.sol";

contract GovScript is Script {
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Coin Address                                               •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    // TODO: set flocoin address
    address public constant FLOCOIN_ADDRESS = 0x0000000000000000000000000000000000000000;

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Gov Params                                                 •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    uint48 public constant VOTE_DELAY = 7 days;
    uint32 public constant VOTE_PERIOD = 7 days;
    uint256 public constant QUORUM_NUMERATOR = 10;
    uint256 public constant VOTE_THRESHOLD = 20_000 * 10 ** 18;
    uint256 public constant PROPOSAL_THRESHOLD = 20_000 * 10 ** 18;

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Vars                                                       •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    FloCoin public token;
    FloCoinGovernor public governor;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        governor = new FloCoinGovernor(FLOCOIN_ADDRESS, VOTE_DELAY, VOTE_PERIOD, PROPOSAL_THRESHOLD, QUORUM_NUMERATOR, VOTE_THRESHOLD);

        console.log("token address:", address(token));
        console.log("governor address:", address(governor));

        vm.stopBroadcast();
    }
}
