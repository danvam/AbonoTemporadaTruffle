pragma solidity ^0.4.24;

import "./contracts/token/ERC20/ERC20.sol";

contract DAbono is ERC20 {
    
    string public constant name = "DAbono";
    string public constant symbol = "DAB";

    constructor (address _temporadaOwner, uint256 _amount) public {
        _mint(_temporadaOwner, _amount);
    }
}