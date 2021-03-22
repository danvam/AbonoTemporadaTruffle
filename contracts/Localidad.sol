pragma solidity ^0.4.24;

import "./Metadata.sol";
 
contract Localidad is Metadata {
    
    uint8 public idLocalidad;
    uint8 public tipoLocalidad;
    
    constructor(string memory name, string memory symbol, uint8 _tipoLocalidad, uint8 _idLocalidad) public Metadata(name, symbol){
        tipoLocalidad = _tipoLocalidad;
        idLocalidad = _idLocalidad;
    }
}