// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.23;

interface IRip7560EntryPoint {
    function acceptAccount(uint256 validAfter, uint256 validUntil) external;
    function sigFailAccount(uint256 validAfter, uint256 validUntil) external;
    function acceptPaymaster(uint256 validAfter, uint256 validUntil, bytes calldata context) external;
    function sigFailPaymaster(uint256 validAfter, uint256 validUntil, bytes calldata context) external;


    /***
     * An event emitted after each successful request.
     * @param sender        - The account that generates this request.
     * @param paymaster     - If non-null, the paymaster that pays for this request.
     * @param deployer      - If non-null, the deployer that creates the sender contract.
     * @param nonceKey      - The nonce key value from the request.
     * @param nonceSequence - The nonce sequence value from the request.
     * @param success       - True if the sender transaction succeeded, false if reverted.
     * @param actualGasCost - Actual amount paid (by account or paymaster) for this UserOperation.
     * @param actualGasUsed - Total gas used by this UserOperation (including preVerification, creation,
     *                        validation and execution).
     */
    event RIP7560TransactionEvent(
        address indexed sender,
        address indexed paymaster,
        address indexed deployer,
        uint256 nonceKey,
        uint256 nonceSequence,
        uint256 executionStatus
    );

    /**
     * An event emitted if the RIP-7560 transaction "executionData" reverted with non-zero length.
     * @param sender       - The sender of this request.
     * @param nonceKey      - The nonce key value from the request.
     * @param nonceSequence - The nonce sequence value from the request.
     * @param revertReason - The return bytes from the reverted "executionData" call.
     */
    event RIP7560TransactionRevertReason(
        address indexed sender,
        uint256 nonceKey,
        uint256 nonceSequence,
        bytes revertReason
    );

    /**
     * An event emitted if the RIP-7560 transaction Paymaster's "postOp" call reverted with non-zero length.
     * @param sender       - The sender of this request.
     * @param paymaster    - The paymaster that pays for this request.
     * @param nonceKey      - The nonce key value from the request.
     * @param nonceSequence - The nonce sequence value from the request.
     * @param revertReason - The return bytes from the reverted call to "postOp".
     */
    event RIP7560TransactionPostOpRevertReason(
        address indexed sender,
        address indexed paymaster,
        uint256 nonceKey,
        uint256 nonceSequence,
        bytes revertReason
    );
}
