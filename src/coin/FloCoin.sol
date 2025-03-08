// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import {VotesUpgradeable} from "@openzeppelin/contracts-upgradeable/governance/utils/VotesUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {ERC20VotesUpgradeable} from
    "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20VotesUpgradeable.sol";
import {ERC20PermitUpgradeable} from "contract-kits/token/ERC20PermitUpgradeable.sol";

contract FloCoin is
    ERC20Upgradeable,
    ERC20PermitUpgradeable,
    ERC20VotesUpgradeable,
    UUPSUpgradeable,
    OwnableUpgradeable
{

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Constants                                                  •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    string public constant NAME = "flocoin";
    string public constant SYMBOL = "FloCo";
    string public constant PERMIT_NAME = "FloCoin";
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
     */
    function initialize(address owner_, address to_) public initializer {
        __UUPSUpgradeable_init();
        __Ownable_init(owner_);

        __ERC20Permit_init(PERMIT_NAME);
        __ERC20_init(NAME, SYMBOL);

        _mint(to_, MAX_SUPPLY);
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
    function _update(address from, address to, uint256 value)
        internal
        virtual
        override(ERC20Upgradeable, ERC20VotesUpgradeable)
    {
        super._update(from, to, value);
    }

    /**
     * @dev override authorizeUpgrade function to only allow owner to upgrade
     *
     * @param implementation_ address of the implementation
     */
    function _authorizeUpgrade(address implementation_) internal override onlyOwner {}

}
