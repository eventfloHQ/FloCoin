// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {ERC20PermitUpgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol";

contract FloCoin is ERC20Upgradeable, ERC20PermitUpgradeable, UUPSUpgradeable, OwnableUpgradeable {
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Constants                                                  •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    uint256 public constant TOTAL_SUPPLY = 15_000_000 * 10 ** 18;

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Custom Errors                                              •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    error InvalidAddress();
    error TotalSupplyExceeded();

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Base Functions                                             •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    constructor() {
        // make sure initialize is called from proxy
        _disableInitializers();
    }

    /**
     * @dev init metadata
     *
     * @param to_ address to mint
     * @param amount_ amount to mint
     */
    function initialize(address to_, uint256 amount_) public initializer {
        __UUPSUpgradeable_init();
        __Ownable_init(msg.sender);

        __ERC20Permit_init("FloCoin");
        __ERC20_init("FloCoin", "FLOCO");

        _mint(to_, amount_);
    }

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // External Functions                                         •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    function mint(address to_, uint256 amount_) external onlyOwner {
        if (to_ == address(0)) revert InvalidAddress();

        if (totalSupply() + amount_ > TOTAL_SUPPLY) revert TotalSupplyExceeded();

        _mint(to_, amount_);
    }

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Internal Functions                                         •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    function _authorizeUpgrade(address implementation_) internal override onlyOwner {}
}
