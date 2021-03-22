const Temporada = artifacts.require("Temporada");

contract('Temporada', (accounts) => {
  it('Se debería haber creado una localidad', async () => {
    const temporadaInstance = await Temporada.deployed();
    await temporadaInstance.creaLocalidad(1, "Localidad x", "lx","/localidad/lx");
    const numeroLocalidades = (await temporadaInstance.actualIdLocalidad.call()).toNumber();
    const numeroEsperado = 1;
    assert.equal(numeroLocalidades, numeroEsperado, "No coincide la localidad con el numero esperado");
  });
  it('Se debería haber creado un espectáculo', async () => {
    const temporadaInstance = await Temporada.deployed();
    await temporadaInstance.creaEspectaculo(20210303, "Espectaculo y", "ey", "/espectaculos/ey");
    const numeroEspectaculos = (await temporadaInstance.actualIdEspectaculo.call()).toNumber();
    const numeroEsperado = 1;
    assert.equal(numeroEspectaculos, numeroEsperado, "No coincide la localidad con el numero esperado");
  });
  it('La temporada ha de estar en fase de creación', async () => {
    const temporadaInstance = await Temporada.deployed();
    const faseTemporada = (await temporadaInstance.faseTemporada.call()).toNumber();
    const faseEsperada  = 0;
    assert.equal(faseTemporada, faseEsperada, "No coincide la fase de Temporada con la creacións");
  });
  it('La temporada ha transitado desde creacion hasta finalizacion de temporada', async () => {
    const temporadaInstance = await Temporada.deployed();

    try {
      await temporadaInstance.finalizaTemporada();
    } catch(err) {
      assert(true);
    }

    const faseTemporada = (await temporadaInstance.faseTemporada.call()).toNumber();
    const faseEsperada  = 0;
    assert.equal(faseTemporada, faseEsperada, "No se puede llegar a la finalizacion de temporada sin pasar por todos los estados intermedios");
  });
  it('La temporada ha transitado desde creacion a periodo de abono', async () => {
    const temporadaInstance = await Temporada.deployed();
    await temporadaInstance.iniciaPeriodoAbono();
    const faseTemporada = (await temporadaInstance.faseTemporada.call()).toNumber();
    const faseEsperada  = 1;
    assert.equal(faseTemporada, faseEsperada, "No coincide la fase de Temporada con el periodo de abono");
  });
  it('La temporada ha transitado desde abono hasta inicio de temporada', async () => {
    const temporadaInstance = await Temporada.deployed();
    await temporadaInstance.iniciaTemporada();
    const faseTemporada = (await temporadaInstance.faseTemporada.call()).toNumber();
    const faseEsperada  = 2;
    assert.equal(faseTemporada, faseEsperada, "No coincide la fase de Temporada con el inicio de temporada");
  });
  it('La temporada ha transitado desde creacion hasta finalizacion de temporada', async () => {
    const temporadaInstance = await Temporada.deployed();
    await temporadaInstance.finalizaTemporada();
    const faseTemporada = (await temporadaInstance.faseTemporada.call()).toNumber();
    const faseEsperada  = 3;
    assert.equal(faseTemporada, faseEsperada, "No coincide la fase de Temporada con el fin de temporada");
  });

});
