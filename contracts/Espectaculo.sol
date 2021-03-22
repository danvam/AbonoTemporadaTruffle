pragma solidity ^0.4.24;

import "./Metadata.sol";

contract Espectaculo is Metadata {
    
    uint8 public idEspectaculo;
    uint public fechaEspectaculo;
    
    constructor(string memory name, string memory symbol, uint _fechaEspectaculo, uint8 _idEspectaculo) public Metadata(name, symbol) {
      fechaEspectaculo = _fechaEspectaculo;
      idEspectaculo = _idEspectaculo;
    }
    
}