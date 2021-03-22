const Temporada = artifacts.require("Temporada");
const DAbono = artifacts.require("DAbono");
const truffleAssert = require('truffle-assertions');

contract('Temporada', (accounts) => {

  it('El propietario del contrato tendrá el balance inicial', async () => {
    const temporadaInstance = await Temporada.deployed();
    const dabonoAddress = (await temporadaInstance.dineroAbono.call());

    const dabonoInstance = await DAbono.at(dabonoAddress);

    const temporadaOwner = (await temporadaInstance.owner.call());
   
    assert.equal(dabonoInstance.address, dabonoAddress, "No tiene balance ieenicial");

    const ownerBalance = (await dabonoInstance.balanceOf.call(temporadaOwner)).toNumber();
    const balanceDefecto = 1000000;

    assert.equal(balanceDefecto, ownerBalance, "No tiene balance inicial");
  });

  it('Se debería haber creado una localidad', async () => {
    const temporadaInstance = await Temporada.deployed();
    await temporadaInstance.creaLocalidad(1, "Localidad x", "lx","/localidad/lx");
    const numeroLocalidades = (await temporadaInstance.actualIdLocalidad.call()).toNumber();
    const numeroEsperado = 1;
    assert.equal(numeroLocalidades, numeroEsperado, "No coincide la localidad con el numero esperado");
  });
  it('Se debería haber creado segunda localidad', async () => {
    const temporadaInstance = await Temporada.deployed();
    await temporadaInstance.creaLocalidad(0, "Localidad z", "lz","/localidad/lz");
    const numeroLocalidades = (await temporadaInstance.actualIdLocalidad.call()).toNumber();
    const numeroEsperado = 2;
    assert.equal(numeroLocalidades, numeroEsperado, "No coincide la localidad con el numero esperado");
  });
  it('Se debería haber creado un espectáculo', async () => {
    const temporadaInstance = await Temporada.deployed();
    await temporadaInstance.creaEspectaculo(20210303, "Espectaculo y", "ey", "/espectaculos/ey");
    const numeroEspectaculos = (await temporadaInstance.actualIdEspectaculo.call()).toNumber();
    const numeroEsperado = 1;
    assert.equal(numeroEspectaculos, numeroEsperado, "No coincide la Espectaculo con el numero esperado");
  });
  it('Se debería haber creado un espectáculo', async () => {
    const temporadaInstance = await Temporada.deployed();
    await temporadaInstance.creaEspectaculo(20210308, "Espectaculo v", "ev", "/espectaculos/ev");
    const numeroEspectaculos = (await temporadaInstance.actualIdEspectaculo.call()).toNumber();
    const numeroEsperado = 2;
    assert.equal(numeroEspectaculos, numeroEsperado, "No coincide la Espectaculo con el numero esperado");
  });

  it('La temporada ha transitado desde creacion a periodo de abono', async () => {
    const temporadaInstance = await Temporada.deployed();
    await temporadaInstance.iniciaPeriodoAbono();
    const faseTemporada = (await temporadaInstance.faseTemporada.call()).toNumber();
    const faseEsperada  = 1;
    assert.equal(faseTemporada, faseEsperada, "No coincide la fase de Temporada con el periodo de abono");
  });

  it('El propietario del contrato transfiere 1000 dabono a la segunda cuenta', async () => {
    const temporadaInstance = await Temporada.deployed();
    const dabonoAddress = (await temporadaInstance.dineroAbono.call());
    const dabonoInstance = await DAbono.at(dabonoAddress);
    const temporadaOwner = (await temporadaInstance.owner.call());
    const cantidadTransferida = 1000;

    dabonoInstance.approve(temporadaOwner, cantidadTransferida);

    await dabonoInstance.transferFrom(temporadaOwner, accounts[1], cantidadTransferida, {from: temporadaOwner});

    const receiverBalance = (await dabonoInstance.balanceOf.call(accounts[1])).toNumber();
    
    assert.equal(receiverBalance, cantidadTransferida, "Debe tener la cantidad transferida");

    const ownerBalance = (await dabonoInstance.balanceOf.call(temporadaOwner)).toNumber();
    const balanceDefecto = 1000000 -  cantidadTransferida;

    await dabonoInstance.approve(temporadaInstance.address, cantidadTransferida, {from: accounts[1]});

    assert.equal(balanceDefecto, ownerBalance, "No ha cambiado el balance del owner");
  });

  it('El propietario del contrato transfiere 1000 dabono a la tercera cuenta', async () => {
    const temporadaInstance = await Temporada.deployed();
    const dabonoAddress = (await temporadaInstance.dineroAbono.call());
    const dabonoInstance = await DAbono.at(dabonoAddress);
    const temporadaOwner = (await temporadaInstance.owner.call());
    const cantidadTransferida = 1000;

    dabonoInstance.approve(temporadaOwner, cantidadTransferida);

    await dabonoInstance.transferFrom(temporadaOwner, accounts[2], cantidadTransferida, {from: temporadaOwner});

    const receiverBalance = (await dabonoInstance.balanceOf.call(accounts[2])).toNumber();
    
    assert.equal(receiverBalance, cantidadTransferida, "Debe tener la cantidad transferida");

    const ownerBalance = (await dabonoInstance.balanceOf.call(temporadaOwner)).toNumber();
    const balanceDefecto = 1000000 -  cantidadTransferida -  cantidadTransferida;

    await dabonoInstance.approve(temporadaInstance.address, cantidadTransferida, {from: accounts[2]});

    assert.equal(balanceDefecto, ownerBalance, "No ha cambiado el balance del owner");
  });

  it('Un usuario compra un abono', async () => {
    const temporadaInstance = await Temporada.deployed();
    const localidadAbonada = 1;
    const result = await temporadaInstance.compraAbono("Abonado de Test", "12345678H", "/abonados/12345678H", localidadAbonada, {from: accounts[1]});

    truffleAssert.eventEmitted(result, 'AbonoComprado');

    const numeroAbonos = (await temporadaInstance.actualIdAbono.call()).toNumber();
    const numeroAbonosEsperado  = 1;
    assert.equal(numeroAbonos, numeroAbonosEsperado, "Debe haber 1 abono");

  });

  it('La temporada ha transitado desde abono hasta inicio de temporada', async () => {
    const temporadaInstance = await Temporada.deployed();
    await temporadaInstance.iniciaTemporada();
    const faseTemporada = (await temporadaInstance.faseTemporada.call()).toNumber();
    const faseEsperada  = 2;
    assert.equal(faseTemporada, faseEsperada, "No coincide la fase de Temporada con el inicio de temporada");
  });

  it('Un usuario alquila un abono a abonado no alquilable', async () => {
    const temporadaInstance = await Temporada.deployed();
    const localidadAlquilada = 1;
    const espectaculoAlquilado = 1;

    let requiereError = false;
    const requiereErrorEsperado = true;
    try {
      await temporadaInstance.alquilaAbono(localidadAlquilada, espectaculoAlquilado, {from: accounts[2]});
    } catch(err) {
      requiereError = true;
    }

    assert.equal(requiereError, requiereErrorEsperado, "Debe haber dado error porque no tiene fechas de alquiler");

    const numeroAbonos = (await temporadaInstance.actualIdAbono.call()).toNumber();
    const numeroAbonosEsperado  = 1;
    assert.equal(numeroAbonos, numeroAbonosEsperado, "Debe haber 1 abono");

  });

  it('Un usuario pone en alquier el abono durante un intervalo de fechas', async () => {
    const temporadaInstance = await Temporada.deployed();
    const localidadAbonada = 1;
    const result = await temporadaInstance.actualizaFechas(localidadAbonada, 20210307, 20210309, {from: accounts[1]});

    truffleAssert.eventEmitted(result, 'FechaActualizada');

  });

  it('Un usuario alquila un abono a abonado', async () => {
    const temporadaInstance = await Temporada.deployed();
    const localidadAlquilada = 1;
    const espectaculoAlquilado = 2;
    const result = await temporadaInstance.alquilaAbono(localidadAlquilada, espectaculoAlquilado, {from: accounts[2]});

    truffleAssert.eventEmitted(result, 'AbonoAlquilado');

    const numeroAbonos = (await temporadaInstance.actualIdAbono.call()).toNumber();
    const numeroAbonosEsperado  = 1;
    assert.equal(numeroAbonos, numeroAbonosEsperado, "Debe haber 1 abono");

  });

  it('Un usuario intenta alquilar el mismo abono a abonado', async () => {
    const temporadaInstance = await Temporada.deployed();
    const localidadAlquilada = 1;
    const espectaculoAlquilado = 2;
    let requiereError = false;
    const requiereErrorEsperado = true;
    try {
      await temporadaInstance.alquilaAbono(localidadAlquilada, espectaculoAlquilado, {from: accounts[2]});
    } catch(err) {
      requiereError = true;
    }

    assert.equal(requiereError, requiereErrorEsperado, "Debe haber dado error porque no puede alquilarse");

    const numeroAbonos = (await temporadaInstance.actualIdAbono.call()).toNumber();
    const numeroAbonosEsperado  = 1;
    assert.equal(numeroAbonos, numeroAbonosEsperado, "Debe haber 1 abono");

  });

  it('Un usuario alquila un abono a empresa', async () => {
    const temporadaInstance = await Temporada.deployed();
    const localidadAlquilada = 2;
    const espectaculoAlquilado = 1;
    const result = await temporadaInstance.alquilaAbono(localidadAlquilada, espectaculoAlquilado, {from: accounts[2]});

    truffleAssert.eventEmitted(result, 'AbonoAlquilado');

    const numeroAbonos = (await temporadaInstance.actualIdAbono.call()).toNumber();
    const numeroAbonosEsperado  = 2;
    assert.equal(numeroAbonos, numeroAbonosEsperado, "Debe haber 2 abonos");

  });
});
