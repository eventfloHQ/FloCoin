// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {ERC20PermitUpgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol";

contract FloCoin is ERC20Upgradeable, ERC20PermitUpgradeable, UUPSUpgradeable, OwnableUpgradeable {
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
     * @param totalSupply_ total supply of flocoin
     */
    function initialize(address to_, uint256 totalSupply_) public initializer {
        __UUPSUpgradeable_init();
        __Ownable_init(msg.sender);

        __ERC20Permit_init("FloCoin");
        __ERC20_init("FloCoin", "FLOCOIN");

        _mint(to_, totalSupply_);
    }

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Internal Functions                                         •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    function _authorizeUpgrade(address implementation_) internal override onlyOwner {}
}
