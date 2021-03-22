pragma solidity >=0.4.24 <0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/test/TemporadaTest.sol";

contract TestTemporadaBasico {

  function testCreaUnaNuevaLocalidad() public {
    TemporadaTest temporada = new TemporadaTest("Temporada 20/21",1000000,20,4,15,45);

    uint expected = 0;
    Assert.equal(temporada.actualIdEspectaculo(), expected, "debe haber 0 localidades");

    temporada.creaLocalidad(1, "Localidad y", "ly", "/localidad/ly");
    expected = 1;
  
    Assert.equal(temporada.actualIdLocalidad(), expected, "Se debe haber incrementado el número de localidades");
  }

  function testCreaUnaNuevoEspectaculo() public {
    TemporadaTest temporada = new TemporadaTest("Temporada 20/21",1000000,20,4,15,45);

    uint expected = 0;
    Assert.equal(temporada.actualIdEspectaculo(), expected, "debe haber 0 espectaculos");

    temporada.creaEspectaculo(20210324, "Nombre Espectáculo", "E1", "/espectaculos/e1");
    expected = 1;
  
    Assert.equal(temporada.actualIdEspectaculo(), expected, "Se debe haber incrementado el número de espectaculos");
  }

  function testTransicionFase() public {
    TemporadaTest temporada = new TemporadaTest("Temporada 20/21",1000000,20,4,15,45);

    temporada.iniciaPeriodoAbono();
    DatosTemporada.Etapa expected = DatosTemporada.Etapa.Abono;
    DatosTemporada.Etapa fase = temporada.faseTemporada();

    Assert.isTrue(fase == expected, "Debe estar en periodo de abonos");

    temporada.iniciaTemporada();
    expected = DatosTemporada.Etapa.Iniciada;
    fase = temporada.faseTemporada();

    Assert.isTrue(fase == expected, "Debe estar en iniciada");

    temporada.finalizaTemporada();
    expected = DatosTemporada.Etapa.Finalizada;
    fase = temporada.faseTemporada();

    Assert.isTrue(fase == expected, "Debe estar en finalizada");
  }
}