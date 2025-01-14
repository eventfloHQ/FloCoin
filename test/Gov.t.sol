// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {FloCoin} from "../src/coin/FloCoin.sol";
import {VmSafe} from "forge-std/src/Vm.sol";
import {Test, console} from "forge-std/src/Test.sol";
import {FloCoinProxy} from "../src/coin/FloCoinProxy.sol";
import {FloCoinGovernor} from "../src/governor/FloCoinGovernor.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Governor} from "@openzeppelin/contracts/governance/Governor.sol";
import {IGovernor} from "@openzeppelin/contracts/governance/IGovernor.sol";
import {GovernorVotesQuorumFraction} from "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";

contract GovTest is Test {
    using Strings for uint256;

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Coin Params                                               •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    uint256 public constant TOKEN_SUPPLY = 15_000_000 * 10 ** 18;

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Gov Params                                                 •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    uint48 public constant VOTE_DELAY = 0;
    uint32 public constant VOTE_PERIOD = 3 minutes;
    uint256 public constant QUORUM_NUMERATOR = 10;
    uint256 public constant VOTE_THRESHOLD = 20_000 * 10 ** 18;
    uint256 public constant PROPOSAL_THRESHOLD = 20_000 * 10 ** 18;

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Vars                                                       •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    FloCoin public token;
    FloCoinProxy public tokenProxy;
    FloCoinGovernor public governor;

    VmSafe.Wallet david = vm.createWallet("david");

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Base Functions                                             •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    function setUp() public {
        vm.deal(david.addr, 10 ether);

        bytes memory data_ = abi.encodeWithSelector(FloCoin.initialize.selector, david.addr, TOKEN_SUPPLY);

        vm.startPrank(david.addr);
        token = new FloCoin();
        tokenProxy = new FloCoinProxy(address(token), data_);
        governor = new FloCoinGovernor(address(tokenProxy), VOTE_DELAY, VOTE_PERIOD, PROPOSAL_THRESHOLD, QUORUM_NUMERATOR, VOTE_THRESHOLD);
        vm.stopPrank();
    }

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Test Functions                                             •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    function test_propose() public {
        // delegate
        vm.startPrank(david.addr);
        FloCoin(address(tokenProxy)).delegate(david.addr);
        vm.stopPrank();

        // propose params
        (address[] memory targets_, uint256[] memory values_, bytes[] memory calldatas_) = _proposeParams();

        // propose
        vm.startPrank(david.addr);
        vm.warp(block.timestamp + 1 days);
        uint256 proposalId = Governor(payable(address(governor))).propose(targets_, values_, calldatas_, "update quorum param");
        console.log("proposalId:", proposalId.toString());
        vm.stopPrank();
    }

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Private Functions                                          •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    function _proposeParams() private view returns (address[] memory targets, uint256[] memory values, bytes[] memory calldatas) {
        // target
        targets = new address[](1);
        targets[0] = address(governor);

        // values
        values = new uint256[](1);
        values[0] = 0;

        // calldata
        calldatas = new bytes[](1);
        calldatas[0] = abi.encodeWithSelector(GovernorVotesQuorumFraction.updateQuorumNumerator.selector, 5);
    }
}
