pragma solidity >=0.4.24 <0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Metadata.sol";

contract TestMetadata {
 
  function testCreacionMetadata() public {
    Metadata metadata = new Metadata("Ejemplo", "EJ");

    metadata.transferOwnership(tx.origin);
    uint256 tokenid = metadata.mint(tx.origin);
    metadata.setTokenURI( tokenid, "/test/");

     Assert.equal(metadata.owner(), tx.origin, "Es el propietario");
  }
}
