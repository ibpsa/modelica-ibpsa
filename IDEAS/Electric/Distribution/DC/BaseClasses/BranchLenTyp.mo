within IDEAS.Electric.Distribution.DC.BaseClasses;
model BranchLenTyp
  "A cable between two nodes specified by its type of cable and its length in meters"
  extends Electric.Distribution.DC.BaseClasses.Branch(         R=typ.RCha*mulFac*
        len);
  parameter Real mulFac=1;
  parameter Electric.Data.Interfaces.DirectCurrent.Cable
                               typ=Electric.Data.Cables.DirectCurrent.PvcAl35();
  parameter Modelica.SIunits.Length len=10;
end BranchLenTyp;
