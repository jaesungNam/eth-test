// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ERC20 {
    /// @return the total amount of tokens in existence
    function totalSupply() external view returns (uint256);

    /// @param account the address to query the balance of
    /// @return the amount owned by `account`
    function balanceOf(address account) external view returns (uint256);

    /// @notice Transfers `amount` tokens to `to`
    /// @return true if the transfer succeeded
    function transfer(address to, uint256 amount) external returns (bool);

    /// @return the remaining number of tokens that `spender` is allowed to spend on behalf of `owner`
    function allowance(address owner, address spender) external view returns (uint256);

    /// @notice Approves `spender` to spend `amount` on behalf of the caller
    /// @return true if the approval succeeded
    function approve(address spender, uint256 amount) external returns (bool);

    /// @notice Moves `amount` tokens from `from` to `to` using the allowance mechanism
    /// @return true if the transfer succeeded
    function transferFrom(address from, address to, uint256 amount) external returns (bool);

    /// @dev Emitted when `value` tokens are moved from one account to another
    event Transfer(address indexed from, address indexed to, uint256 value);

    /// @dev Emitted when the allowance of a `spender` for an `owner` is set by a call to `approve`
    event Approval(address indexed owner, address indexed spender, uint256 value);
}