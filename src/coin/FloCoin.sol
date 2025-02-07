// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {ERC20PermitUpgradeable} from "contract-kits/token/ERC20PermitUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {VotesUpgradeable} from "@openzeppelin/contracts-upgradeable/governance/utils/VotesUpgradeable.sol";
import {ERC20VotesUpgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20VotesUpgradeable.sol";

contract FloCoin is ERC20Upgradeable, ERC20PermitUpgradeable, ERC20VotesUpgradeable, UUPSUpgradeable, OwnableUpgradeable {
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Constants                                                  •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    uint256 public constant MAX_SUPPLY = 15_000_000 * 10 ** 18;

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
     * @param owner_ owner of the contract
     * @param to_ address to mint the tokens to
     * @param amount_ amount of tokens to mint
     */
    function initialize(address owner_, address[] calldata to_, uint256[] calldata amount_) public initializer {
        __UUPSUpgradeable_init();
        __Ownable_init(owner_);

        __ERC20Permit_init("FloCoin");
        __ERC20_init("FloCoin", "FLOCO");

        for (uint256 i = 0; i < to_.length; i++) {
            _mint(to_[i], amount_[i]);
        }
    }

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // External Functions                                         •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    function mint(address to_, uint256 amount_) external onlyOwner {
        if (to_ == address(0)) revert InvalidAddress();

        if (totalSupply() + amount_ > MAX_SUPPLY) revert TotalSupplyExceeded();

        _mint(to_, amount_);
    }

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Vote Override Functions                                    •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    function clock() public view virtual override(VotesUpgradeable) returns (uint48) {
        return uint48(block.timestamp);
    }

    // slither-disable-next-line naming-convention
    function CLOCK_MODE() public view virtual override(VotesUpgradeable) returns (string memory) {
        return "mode=timestamp";
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
