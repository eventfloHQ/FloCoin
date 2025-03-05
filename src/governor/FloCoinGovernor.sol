// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {FloCoinGovernorSettings} from "../extensions/FloCoinGovernorSettings.sol";
import {Governor} from "@openzeppelin/contracts/governance/Governor.sol";

import {GovernorCountingSimple} from "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import {GovernorSettings} from "@openzeppelin/contracts/governance/extensions/GovernorSettings.sol";
import {GovernorVotes} from "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";

import {GovernorVotesQuorumFraction} from "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import {IVotes} from "@openzeppelin/contracts/governance/utils/IVotes.sol";

contract FloCoinGovernor is Governor, GovernorVotes, GovernorVotesQuorumFraction, GovernorCountingSimple, FloCoinGovernorSettings {

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Constants                                                  •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    string public constant GOVERNOR_NAME = "FloCoin Governor";

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Custom Errors                                              •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    error NotEnoughVotes(address account, uint256 totalWeight, uint256 requiredWeight);

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Base Functions                                             •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    /**
     * @dev init governor
     *
     * @param initialVotingDelay_ the delay before voting starts
     * @param initialVotingPeriod_ the duration of the voting period
     * @param initialProposalThreshold_ the minimum number of FLOCOIN tokens required to create a proposal
     */
    constructor(
        address flocoin_,
        uint48 initialVotingDelay_,
        uint32 initialVotingPeriod_,
        uint256 initialProposalThreshold_,
        uint256 quorum_,
        uint256 voteThreshold_
    )
        Governor(GOVERNOR_NAME)
        GovernorVotes(IVotes(flocoin_))
        FloCoinGovernorSettings(voteThreshold_)
        GovernorVotesQuorumFraction(quorum_)
        GovernorSettings(initialVotingDelay_, initialVotingPeriod_, initialProposalThreshold_)
    {}

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Governor Settings                                          •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    /**
     * @inheritdoc GovernorSettings
     */
    function proposalThreshold() public view virtual override(Governor, GovernorSettings) returns (uint256) {
        return GovernorSettings.proposalThreshold();
    }

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Internal Functions                                         •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    function _castVote(uint256 proposalId, address account, uint8 support, string memory reason, bytes memory params)
        internal
        virtual
        override
        returns (uint256)
    {
        uint256 voteThreshold_ = voteThreshold();
        uint256 totalWeight = _getVotes(account, proposalSnapshot(proposalId), params);
        if (totalWeight < voteThreshold_) revert NotEnoughVotes(account, totalWeight, voteThreshold_);

        return super._castVote(proposalId, account, support, reason, params);
    }

}
