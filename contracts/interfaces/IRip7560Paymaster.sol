// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.23;

/**
 * @title UsedGasBreakdown
 * @dev The detailed breakdown of where the gas in the transaction was consumed.
 * @dev This data is provided to the Paymaster contract in the 'postPaymasterTransaction' frame.
 * @notice Gas used during 'postPaymasterTransaction' cannot be known ahead of time and may need to be guesstimated.
 */
struct UsedGasBreakdown {
	uint256 preTransactionGasUsed;
	uint256 accountDeploymentGasUsed;
	uint256 accountValidationGasUsed;
	uint256 paymasterValidationGasUsed;
	uint256 executionGasUsed;
	uint256 executionUnusedPenaltyGas;
}

/**
 * @dev Calculate ETH gas cost of a transaction using the provided gas usage info plus an estimate for 'postOpGasUsed'.
 * @param usedGasBreakdown - the actual gas cost of each completed frame of the transaction.
 * @param postOpGasUsed - the best-effort estimation of the amount of gas consumed by the 'postPaymasterTransaction'.
 * @notice 'postPaymasterTransaction' may be penalized for unused gas and this should be included in 'postOpGasUsed'.
 */
function calculateActualGasCost(
	UsedGasBreakdown calldata usedGasBreakdown,
	uint256 postOpGasUsed
) returns (uint256){
	uint256 actualGas = postOpGasUsed +
					usedGasBreakdown.preTransactionGasUsed +
					usedGasBreakdown.accountDeploymentGasUsed +
					usedGasBreakdown.accountValidationGasUsed +
					usedGasBreakdown.paymasterValidationGasUsed +
					usedGasBreakdown.executionGasUsed +
					usedGasBreakdown.executionUnusedPenaltyGas;
	return actualGas * tx.gasprice;
}

/**
 * @title IRip7560Paymaster
 * @dev Interface for the paymaster contract.
 */
interface IRip7560Paymaster {

	/**
	 * paymaster validation function.
	 * This method must call RIP7560Utils.paymasterAcceptTransaction to accept paying for the transaction.
	 * Any other return value (or revert) will be considered as a rejection of the transaction.
	 * @param version - transaction encoding version RIP7560Utils.VERSION
	 * @param txHash - transaction hash to check the signature against
	 * @param transaction - encoded transaction
	 */
	function validatePaymasterTransaction(
		uint256 version,
		bytes32 txHash,
		bytes calldata transaction)
	external;


	/**
	 * @dev The paymaster's post-transaction callback function.
	 * @dev This method is called after the transaction has been executed if the validation function returned a context.
	 * @dev Revert in this method will cause the account execution function to revert too.
	 * @dev Notice that unlike an invalid transaction, the reverted transaction will still get on-chain and be paid for.
	 * @param success - true if the transaction execution was successful, false otherwise
	 * @param context - context data returned by validatePaymasterTransaction
	 * @param usedGasBreakdown - the actual gas cost of each completed frame of the transaction
	 */
	function postPaymasterTransaction(
		bool success,
		bytes calldata context,
		UsedGasBreakdown calldata usedGasBreakdown
	) external;

}
