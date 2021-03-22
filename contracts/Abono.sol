pragma solidity ^0.4.24;

import "./Metadata.sol";

contract Abono is Metadata {

    uint8 public idAbono;
    Disponibilidad public disponibilidad;
    mapping(uint256 => address) public espectaculosAlquileres;
    address public temporada;

    struct Disponibilidad {
        uint fechaAlquilerDesde;
        uint fechaAlquilerHasta;
    }

    modifier soloAbonadoYTemporada() {
        if (msg.sender == temporada || msg.sender == owner)
            _;
    }
    
    modifier soloTemporada() {
        if (msg.sender == temporada)
            _;
    }
    
    constructor(string memory name, string memory symbol, uint8 _idAbono) public Metadata(name, symbol) {
     temporada = msg.sender;
     idAbono = _idAbono;
    }
    
    function actualizaFechas(uint _fechaDesde, uint _fechaHasta) public soloAbonadoYTemporada {
        disponibilidad.fechaAlquilerDesde = _fechaDesde;
        disponibilidad.fechaAlquilerHasta = _fechaHasta;
    }

    function estaDisponibleAlquiler(uint _fecha, uint256 espectaculoId) public view returns(bool) {
        if(espectaculosAlquileres[espectaculoId] != address(0)){
         return false;
        }else if(disponibilidad.fechaAlquilerDesde == 0 && disponibilidad.fechaAlquilerHasta != 0){
         return _fecha <= disponibilidad.fechaAlquilerHasta;
        }else if(disponibilidad.fechaAlquilerDesde != 0 && disponibilidad.fechaAlquilerHasta == 0){
         return _fecha >= disponibilidad.fechaAlquilerDesde;
        }else if(disponibilidad.fechaAlquilerDesde != 0 && disponibilidad.fechaAlquilerHasta != 0){
         return _fecha <= disponibilidad.fechaAlquilerHasta && _fecha >= disponibilidad.fechaAlquilerDesde;
        }
       return false;
    }
    
    function estableceAlquier(uint256 espectaculoId, address _arrendatario) public soloTemporada {
     espectaculosAlquileres[espectaculoId] = _arrendatario;
    }

}