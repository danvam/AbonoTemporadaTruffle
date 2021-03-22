pragma solidity >=0.4.24 <0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Localidad.sol";

contract TestLocalidad {
 
  function testCreacionLocalidad() public {
    Localidad localidad = new Localidad("Localización localidad", "LL", 0, 1);

    localidad.transferOwnership(tx.origin);
    uint256 tokenid = localidad.mint(tx.origin);
    localidad.setTokenURI( tokenid, "/localidad/ll");

     Assert.equal(localidad.owner(), tx.origin, "Debe ser el propietario de la localidad");
  }
}
