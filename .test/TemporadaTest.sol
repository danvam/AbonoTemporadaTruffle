pragma solidity >=0.4.24 <0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Temporada.sol";
import "../contracts/DAbono.sol";

contract TestTemporada {
 
  function testInitialBalanceUsingDeployedContract() public {
    Temporada temporada = Temporada(DeployedAddresses.Temporada());

    //uint expected = 1;

  //temporada.creaEspectaculo(20210304, "Espectaculo x", "/espectaculos/x");

  temporada.creaLocalidad(1, "test", "Espectaculo y", "/espectaculos/y");
  
   
  // let instance = await Temporada.deployed()

 //    DAbono dAbono = DAbono(temporada.dineroAbono());

 //   Assert.equal(dAbono.balanceOf(temporada.owner()), expected, "Owner should have 1000000 DAbono initially 1");

    
  }
/*
  function testInitialBalanceWithNewTemporada() public {
    Temporada temporada = new Temporada("Temporada 20/21",1000000,20,4,15,45);

    uint expected = 1000000;

    DAbono dAbono = DAbono(temporada.dineroAbono());

    Assert.equal(dAbono.balanceOf(temporada.owner()), expected, "Owner should have 1000000 DAbono initially 2");
  }
*//*
  function testInitialBalanceWithNewDAbono() public {
    DAbono dabono = new DAbono(tx.origin, 1000000);

    uint expected = 1000000;

    Assert.equal(dabono.balanceOf(tx.origin), expected, "Owner should have 1000000 DAbono initially 3");
  }*/

}
