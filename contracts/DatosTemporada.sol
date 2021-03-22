pragma solidity ^0.4.24;

import "./Ownable.sol";
import "./DAbono.sol";

contract DatosTemporada is Ownable {

    enum Etapa {Creacion, Abono, Iniciada, Finalizada}
    
    string public nombre;
    Etapa public faseTemporada;
        
    uint8 public actualIdLocalidad; 
    uint8 public actualIdEspectaculo;  
    uint8 public actualIdAbono; 
    uint8 public precioBase; 
    uint8 public tiposLocalidad; // diferentes tipos de localidad que afectan al incremento del predio de cada una
    uint8 public factorIncrementoTipo; // cuanto se incremente el precio de una localidad entre un tipo y el siguiente tipo
    uint8 public porcentajeAlquiler; // pordentaje que irá al abonado en caso de alquilar un abono que haya comprado
    DAbono public dineroAbono; // dinero que se usará en la compra y alquiler de abonos

    
    function iniciaPeriodoAbono() public onlyOwner {
     require(faseTemporada == Etapa.Creacion,"Debe estár en fase de creación para pasar al periodo de abono");
     faseTemporada = Etapa.Abono;
    }
    
    function iniciaTemporada() public onlyOwner {
     require(faseTemporada == Etapa.Abono,"Debe estár en fase de abono");
     faseTemporada = Etapa.Iniciada;
    }
    
    function finalizaTemporada() public onlyOwner {
     require(faseTemporada == Etapa.Iniciada,"Debe estár en fase de inicio");
     faseTemporada = Etapa.Finalizada;
    }
}