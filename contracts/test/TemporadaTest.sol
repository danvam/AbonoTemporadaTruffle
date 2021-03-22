
pragma solidity ^0.4.24;

import "../Localidad.sol";
import "../DAbono.sol";
import "../Abono.sol";
import "../Espectaculo.sol";
import "../DatosTemporada.sol";

contract TemporadaTest is DatosTemporada{
   
    event LoalidadCreada(address localidad, uint8 id);
    event EspectaculoCreado(address espectaculo, uint8 id);
    event AbonoComprado(address abono, uint8 id);
    event AbonoAlquilado(address abono, uint8 id);
    event FechaActualizada(address abono, uint8 id);
    
    mapping (uint8 => Localidad) private localidades; // registrará las localidades creadas según su id
    mapping (uint8 => Espectaculo) private espectaculos; // registrará los espectáculos creados según su id
    mapping (uint8 => Abono) private localidadAbono; // registrará en cada id de la localidad el abono asociado
    mapping (address => uint8) private abonadoLocalidad; // para una dirección me devuelve la localidad que posee en su abono
    
    constructor(string nameTemporada, uint256 dineroInicial, uint8 _precioBase, uint8 _tiposLocalidad, uint8 _factorIncrementoTipo, uint8 _porcentajeAlquiler) public{
        nombre = nameTemporada;
        precioBase = _precioBase;
        tiposLocalidad = _tiposLocalidad;
        factorIncrementoTipo = _factorIncrementoTipo;
        porcentajeAlquiler = _porcentajeAlquiler;
        dineroAbono = new DAbono(msg.sender, dineroInicial);
    }
     
     function creaLocalidad(uint8 tipoLocalidad, string nameLocalidad, string symbolLocalidad, string uriLocalidad) public onlyOwner {
        require(faseTemporada == Etapa.Creacion, "Sólo se permiten añadir más localidades en fase de creación");
        require(tipoLocalidad >= 0 && tipoLocalidad <= tiposLocalidad, "Sólo se permiten localidades del rango de tipos definidos ");
        Localidad localidad = new Localidad(nameLocalidad, symbolLocalidad, tipoLocalidad, actualIdLocalidad + 1);
        localidades[actualIdLocalidad + 1] = localidad;
        localidad.mint(owner);
        localidad.setTokenURI(1, uriLocalidad);
        localidad.transferOwnership(owner);
        actualIdLocalidad = actualIdLocalidad + 1;
        emit LoalidadCreada(address(localidad), actualIdLocalidad);
    }

    function creaEspectaculo(uint fechaEspectaculo, string nameEspectaculo, string symbolEspectaculo, string uriEspectaculo) public onlyOwner {
        require(faseTemporada == Etapa.Creacion, "Sólo se permiten añadir más espectáculos en fase de creación");
        Espectaculo espectaculo = new Espectaculo(nameEspectaculo, symbolEspectaculo, fechaEspectaculo, actualIdEspectaculo + 1);
        espectaculos[actualIdEspectaculo + 1] = espectaculo;
        espectaculo.mint(owner);
        espectaculo.setTokenURI(1, uriEspectaculo);
         espectaculo.transferOwnership(owner);
        actualIdEspectaculo = actualIdEspectaculo + 1;
        emit EspectaculoCreado(address(espectaculo), actualIdEspectaculo);
    }
    
    function actualizaFechas(uint8 localidadId, uint _fechaDesde, uint _fechaHasta) public{
        localidadAbono[localidadId].actualizaFechas(_fechaDesde, _fechaHasta);
        emit FechaActualizada(address(localidadAbono[localidadId]), localidadAbono[localidadId].idAbono());
    }
}