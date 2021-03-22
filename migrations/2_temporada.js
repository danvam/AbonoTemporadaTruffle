const Temporada = artifacts.require("Temporada");

module.exports = function (deployer) {
  deployer.deploy(Temporada, "Temporada 20/21","1000000","20","4","15","45");
};
