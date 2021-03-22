const Metadata = artifacts.require("Metadata");

contract('Metadata', (accounts) => {

  it('Creación de un metadata base', async () => {
    const metadata = await Metadata.new("Ejemplo", "EJ");
    
    await metadata.mint(accounts[1]);
    const tokenIdEsperado = 1;
    const uriIndicada = "/test/";
    await metadata.setTokenURI(tokenIdEsperado, uriIndicada);
    const tokenUri = (await metadata.tokenURI.call(tokenIdEsperado));
    assert.equal(tokenUri, uriIndicada, "Es el propietario");
  });

 
});
