// SPDX-License-Identifier: MIT
pragma solidity >0.5.0;

import "./ERC20Interface.sol";


contract ERC20Token is ERC20Interface {
    uint256 private constant MAX_UINT256 = 2**256 - 1;
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowed;
    uint256 public totSupply; // Total number of tokens
    string public name; // Descriptive name (i.e. For SupplyChainApp Token)
    uint8 public decimals; // How many decimals to use when displaying amounts
    string public symbol; // Short identifier for token (i.e. FDT)

    // Create the new token and assign initial values, including initial amount
    constructor (
        uint256 _initialAmount,
        string memory _tokenName,
        uint8 _decimalUnits,
        string memory _tokenSymbol
    ) public {
        balances[msg.sender] = _initialAmount; // The creator owns all initial tokens
        totSupply = _initialAmount; // Update total token supply
        name = _tokenName; // Store the token name (used for display only)
        decimals = _decimalUnits; // Store the number of decimals (used for display only)
        symbol = _tokenSymbol; // Store the token symbol (used for display only)
    }

    // Transfer tokens from msg.sender to a specified address
    function transfer(address _to, uint256 _value)
        public
        override
        returns (bool success)
    {
        require(
            balances[msg.sender] >= _value,
            "Insufficient funds for transfer source."
        );
        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value); //solhint‐disable‐line indent, no‐unused‐vars
        return true;
    }

    // Transfer tokens from one specified address to another specified address
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public override returns (bool success) {
        uint256 allowance = allowed[_from][msg.sender];
        require(
            balances[_from] >= _value && allowance >= _value,
            "Insufficient allowed funds for transfer source."
        );
        balances[_to] += _value;
        balances[_from] = balances[_from] - _value;
        if (allowance < MAX_UINT256) {
            allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
        }
        emit Transfer(_from, _to, _value); //solhint‐disable‐line indent, no‐unused‐vars
        return true;
    }

    // Return the current balance (in tokens) of a specified address
    function balanceOf(address _owner)
        public
        override
        view
        returns (uint256 balance)
    {
        return balances[_owner];
    }

    // Set
    function approve(address _spender, uint256 _value)
        public
        override
        returns (bool success)
    {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value); //solhint‐disable‐line indent, nounused‐vars
        return true;
    }

    // Return the
    function allowance(address _owner, address _spender)
        public
        override
        view
        returns (uint256 remaining)
    {
        return allowed[_owner][_spender];
    }

    // Return the total number of tokens in circulation
    function totalSupply() public override view returns (uint256 totSupp) {
        return totSupply;
    }
}



