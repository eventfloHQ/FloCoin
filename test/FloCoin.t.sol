// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {VmSafe} from "forge-std/Vm.sol";
import {SigUtil} from "./internal/SigUtil.sol";
import {FloCoin} from "../src/coin/FloCoin.sol";
import {Test, console} from "forge-std/Test.sol";
import {FloCoinProxy} from "../src/coin/FloCoinProxy.sol";
import {UpgradeFloCoin} from "./internal/UpgradeFloCoin.sol";
import {IERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol";

contract FloCoinTest is Test {
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Constants                                                  •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    uint256 public constant PREMIT_VALUE = 1000 * 10 ** 18;
    uint256 public constant TOTAL_SUPPLY = 15_000_000 * 10 ** 18;

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Vars                                                       •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    address[] public to;
    uint256[] public amount;
    FloCoin public flocoin;
    SigUtil public sigUtil;
    FloCoinProxy public flocoinProxy;
    VmSafe.Wallet david = vm.createWallet("david");
    VmSafe.Wallet alice = vm.createWallet("alice");

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Base Functions                                             •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    function setUp() public {
        vm.deal(david.addr, 1 ether);
        vm.deal(alice.addr, 1 ether);

        to.push(david.addr);
        to.push(alice.addr);
        amount.push(500_000 * 10 ** 18);
        amount.push(10_000_000 * 10 ** 18);

        bytes memory data_ = abi.encodeWithSelector(FloCoin.initialize.selector, david.addr, to, amount);

        vm.startPrank(david.addr);

        flocoin = new FloCoin();
        flocoinProxy = new FloCoinProxy(address(flocoin), data_);
        sigUtil = new SigUtil("FloCoin", "1", address(flocoinProxy));

        vm.stopPrank();
    }

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Test Functions                                             •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    function test_initialize() public view {
        assertEq(FloCoin(address(flocoinProxy)).balanceOf(david.addr), 500_000 * 10 ** 18);
    }

    function test_permit() public {
        uint256 nonce = block.timestamp;
        uint256 deadline_ = block.timestamp + 1 days;

        bytes32 typedHash = sigUtil.getTypedHash(david.addr, alice.addr, PREMIT_VALUE, nonce, deadline_);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(david, typedHash);

        vm.startPrank(alice.addr);

        FloCoin(address(flocoinProxy)).permit(david.addr, alice.addr, PREMIT_VALUE, nonce, deadline_, v, r, s);

        assertEq(FloCoin(address(flocoinProxy)).allowance(david.addr, alice.addr), PREMIT_VALUE);

        vm.stopPrank();
    }

    function test_upgrade() public {
        vm.startPrank(david.addr);

        UpgradeFloCoin upgradeFloCoin = new UpgradeFloCoin();

        FloCoin(address(flocoinProxy)).upgradeToAndCall(address(upgradeFloCoin), "");

        assertEq(upgradeFloCoin.upgradeMessage(), "UpgradeFloCoin");

        vm.stopPrank();
    }
}
