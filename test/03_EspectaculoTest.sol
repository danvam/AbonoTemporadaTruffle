pragma solidity >=0.4.24 <0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Espectaculo.sol";

contract TestEspectaculo {
 
  function testCreacionEspectaculo() public {
    Espectaculo espectaculo = new Espectaculo("Nombre Espectáculo", "E1", 20210304, 1);

    espectaculo.transferOwnership(tx.origin);
    uint256 tokenid = espectaculo.mint(tx.origin);
    espectaculo.setTokenURI( tokenid, "/espectaculo/E1");

     Assert.equal(espectaculo.owner(), tx.origin, "No es el propietario del espectáculo");
  }
}
