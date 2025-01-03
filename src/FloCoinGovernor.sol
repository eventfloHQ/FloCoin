// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IVotes} from "@openzeppelin/contracts/governance/utils/IVotes.sol";
import {Governor} from "@openzeppelin/contracts/governance/Governor.sol";
import {GovernorVotes} from "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import {GovernorSettings} from "@openzeppelin/contracts/governance/extensions/GovernorSettings.sol";
import {GovernorCountingSimple} from "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import {GovernorVotesQuorumFraction} from "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";

contract FloCoinGovernor is Governor, GovernorVotes, GovernorVotesQuorumFraction, GovernorCountingSimple, GovernorSettings {
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Constants                                                  •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    // TODO: update to the actual FLOCOIN token
    IVotes public constant FLOCOIN_TOKEN = IVotes(0x0000000000000000000000000000000000000000);

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
    constructor(uint48 initialVotingDelay_, uint32 initialVotingPeriod_, uint256 initialProposalThreshold_)
        Governor(GOVERNOR_NAME)
        GovernorVotes(FLOCOIN_TOKEN)
        GovernorVotesQuorumFraction(4)
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

    function _castVote(uint256 proposalId, address account, uint8 support, string memory reason, bytes memory params) internal virtual override returns (uint256) {
        uint256 totalWeight = _getVotes(account, proposalSnapshot(proposalId), params);
        if (totalWeight < 5000 * 10 ** 18) {
            revert NotEnoughVotes(account, totalWeight, 5000 * 10 ** 18);
        }

        return super._castVote(proposalId, account, support, reason, params);
    }
}
