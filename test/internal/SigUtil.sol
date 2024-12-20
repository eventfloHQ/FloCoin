// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract SigUtil {
    using MessageHashUtils for bytes32;

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Constants                                                  •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    bytes32 private immutable DOMAIN_SEPARATOR;
    bytes32 private constant TYPE_HASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
    bytes32 private constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // Base Functions                                             •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    constructor(string memory name, string memory version, address verifyingContract) {
        DOMAIN_SEPARATOR = keccak256(abi.encode(TYPE_HASH, keccak256(bytes(name)), keccak256(bytes(version)), block.chainid, verifyingContract));
    }

    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    // External Functions                                         •
    // ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

    function getTypedHash(address owner, address spender, uint256 value, uint256 nonce, uint256 deadline) external view returns (bytes32) {
        bytes32 msgHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonce, deadline));

        return DOMAIN_SEPARATOR.toTypedDataHash(msgHash);
    }
}
