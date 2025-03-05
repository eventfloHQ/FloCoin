// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {GovernorSettings} from "@openzeppelin/contracts/governance/extensions/GovernorSettings.sol";

abstract contract FloCoinGovernorSettings is GovernorSettings {

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Vars                                                       •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    uint256 private _voteThreshold;

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Base Functions                                             •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    constructor(uint256 voteThreshold_) {
        _voteThreshold = voteThreshold_;
    }

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Public Functions                                           •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    function setVoteThreshold(uint256 voteThreshold_) public virtual onlyGovernance {
        _voteThreshold = voteThreshold_;
    }

    function voteThreshold() public view virtual returns (uint256) {
        return _voteThreshold;
    }

}
