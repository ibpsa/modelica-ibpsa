within IDEAS.Electric.Data.Cables;
package DirectCurrent "Just some example cable"
extends Modelica.Icons.MaterialPropertiesPackage;
  record PvcAl35=Electric.Data.Interfaces.DirectCurrent.Cable (
   RCha=0.923e-003,
   In=220) "Aluminum cable 35mm^2!";
end DirectCurrent;
