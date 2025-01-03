// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {NoncesUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/NoncesUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {ERC20VotesUpgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20VotesUpgradeable.sol";
import {ERC20PermitUpgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol";

contract FloCoin is ERC20Upgradeable, ERC20PermitUpgradeable, ERC20VotesUpgradeable, UUPSUpgradeable, OwnableUpgradeable {
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
    // Public Functions                                           •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    /**
     * @dev override nonces function to use nonces from NoncesUpgradeable
     *
     * @param owner address of the owner
     */
    function nonces(address owner) public view virtual override(ERC20PermitUpgradeable, NoncesUpgradeable) returns (uint256) {
        return super.nonces(owner);
    }

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Internal Functions                                         •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    /**
     * @dev override update function to use update from ERC20VotesUpgradeable
     *
     * @param from address of the from
     * @param to address of the to
     * @param value value of the transfer
     */
    function _update(address from, address to, uint256 value) internal virtual override(ERC20Upgradeable, ERC20VotesUpgradeable) {
        super._update(from, to, value);
    }

    /**
     * @dev override authorizeUpgrade function to only allow owner to upgrade
     *
     * @param implementation_ address of the implementation
     */
    function _authorizeUpgrade(address implementation_) internal override onlyOwner {}
}
