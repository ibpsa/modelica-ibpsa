within IDEAS.Electric.Data.Interfaces;
partial record Cable

extends Modelica.Icons.MaterialProperty;

parameter ELECTAPub.General.Units.CharacteristicResistance RCha
    "Characteristic resistance of the cable";
parameter ELECTAPub.General.Units.CharacteristicReactance XCha
    "Characteristic reactance of the cable";
parameter ELECTAPub.General.Units.ComplexCharacteristicImpedance ZCha(re=RCha,im=XCha)
    "Characteristic impedance of the cable";
parameter Modelica.SIunits.ElectricCurrent INom
    "Nominal electrical current fused";
end Cable;
