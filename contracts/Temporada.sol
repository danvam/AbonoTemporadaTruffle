pragma solidity ^0.4.24;

import "./Localidad.sol";
import "./DAbono.sol";
import "./Abono.sol";
import "./Espectaculo.sol";
import "./DatosTemporada.sol";

contract Temporada is DatosTemporada{
   
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

    function compraAbono(string nameAbono, string symbolAbono, string uriAbonado, uint8 localidadId) public {
        require(faseTemporada == Etapa.Abono, "Sólo se permite contratar un abono en fase de abono");
        require(address(localidades[localidadId]) != address(0), "No existe la localidad");
        require(address(localidadAbono[localidadId]) == address(0), "La localidad solicitada ya ha sido comprada");
        
        uint8 precioCalculado = (precioBase + (localidades[localidadId].tipoLocalidad() * factorIncrementoTipo )) * actualIdEspectaculo;
        
        if(dineroAbono.transferFrom(msg.sender, owner, precioCalculado)){  
            Abono abono = creaAbono(msg.sender,nameAbono, symbolAbono, uriAbonado,  localidadId, 0);
            abonadoLocalidad[msg.sender]=localidadId;
            emit AbonoComprado(address(abono), actualIdAbono);
        }
    }

    function alquilaAbono(uint8 localidadId, uint8 espectaculoId) public {
        require(faseTemporada == Etapa.Iniciada, "Sólo se permite alquilar un abono cuando la temporada está en curso");
        require(address(localidades[localidadId]) != address(0), "No existe la localidad");

        Abono abono = localidadAbono[localidadId];
         
        require(address(abono) == address(0) || abono.estaDisponibleAlquiler(espectaculos[espectaculoId].fechaEspectaculo(), espectaculoId), "No está disponible la localidad para el espectáculo seleccionado");
        uint256 precioCalculado = (precioBase + (localidades[localidadId].tipoLocalidad() * factorIncrementoTipo));
        
        // El usuario ha de permitir transferir el coste del alquiler de abono al contrato temporada
        if(dineroAbono.balanceOf(msg.sender) >= precioCalculado){

            uint256 dineroAbonado = 0;
            if(address(abono) != address(0) && abono.owner() != owner){ // existe y no es abono creado por la empresa
                require(abono.owner() != msg.sender, "El abonado no puede alquiar su propio abono");
                dineroAbonado = precioCalculado * porcentajeAlquiler / 100;
                dineroAbono.transferFrom(msg.sender, abono.owner(), dineroAbonado);
            }else if(address(abono) == address(0)){
                abono = creaAbono(owner,"Alquiler", "A", "datosTemporada", localidadId, 1); // Inicializa fechaDesde para permitir cualquier alquiler
            }
            uint256 dineroEmpresa = precioCalculado - dineroAbonado;
            dineroAbono.transferFrom(msg.sender, owner, dineroEmpresa);
            abono.estableceAlquier(espectaculoId, msg.sender);
            
            emit AbonoAlquilado(address(abono), actualIdAbono);
        }
    }
    
    function creaAbono(address _owner,string _name, string _symbol, string _uri, uint8 _localidadId, uint _fecha) private returns (Abono){
        Abono abono = new Abono(_name, _symbol, actualIdAbono + 1);
        abono.actualizaFechas(_fecha, 0);
        localidadAbono[_localidadId] = abono;
        abono.mint(_owner);
        abono.setTokenURI(1, _uri);
        abono.transferOwnership(_owner);
        actualIdAbono = actualIdAbono + 1;
        
        return abono;
    }
    
    function actualizaFechas(uint8 localidadId, uint _fechaDesde, uint _fechaHasta) public{
        localidadAbono[localidadId].actualizaFechas(_fechaDesde, _fechaHasta);
        emit FechaActualizada(address(localidadAbono[localidadId]), localidadAbono[localidadId].idAbono());
    }
}