within IDEAS.Electric.Data;
package TransformerImp
extends Modelica.Icons.MaterialPropertiesPackage;
  record Transfo_100kVA =
                  IDEAS.Electric.Data.Interfaces.TransformerImp (
   Sn=100e3,
   P0=190,
   Zd=0.0333+0.106*Modelica.ComplexMath.j) "100 kVA transformer";
  record Transfo_160kVA =
                  IDEAS.Electric.Data.Interfaces.TransformerImp (
   Sn=160e3,
   P0=260,
   Zd=0.0204+0.0675*Modelica.ComplexMath.j) "160 kVA transformer";
  record Transfo_250kVA =
                  IDEAS.Electric.Data.Interfaces.TransformerImp (
   Sn=250e3,
   P0=365,
   Zd=0.0126+0.0445*Modelica.ComplexMath.j) "250 kVA transformer";
  record Transfo_400kVA =
                  IDEAS.Electric.Data.Interfaces.TransformerImp (
   Sn=400e3,
   P0=515,
   Zd=0.00740+0.0291*Modelica.ComplexMath.j) "400 kVA transformer";
  record Transfo_630kVA =
                  IDEAS.Electric.Data.Interfaces.TransformerImp (
   Sn=630e3,
   P0=745,
   Zd=0.00416+0.0198*Modelica.ComplexMath.j) "630 kVA transformer";
end TransformerImp;
