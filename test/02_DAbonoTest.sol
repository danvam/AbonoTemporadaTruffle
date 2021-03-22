pragma solidity >=0.4.24 <0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Temporada.sol";
import "../contracts/DAbono.sol";

contract TestDAbono {

  function testBalanceInicialTemporadaDesplegada() public {
    Temporada temporada = Temporada(DeployedAddresses.Temporada());

    uint expected = 1000000;

    DAbono dAbono = DAbono(temporada.dineroAbono());

    Assert.equal(dAbono.balanceOf(temporada.owner()), expected, "El propietario debe tener 1000000 de incio");
  }

  function testBalanceInicialNuevoDAbono() public {
    DAbono dabono = new DAbono(tx.origin, 1000);

    uint expected = 1000;

    Assert.equal(dabono.balanceOf(tx.origin), expected, "El propietario debe tener 1000 de incio");
  }

}
