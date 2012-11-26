within IDEAS.Electric.DistributionGrid.Components;
model BranchLenTyp
  "A branch specified by its type of cable (ELECTAPub.GridsLib.LVCable) and its length in meters"
  extends IDEAS.Electric.DistributionGrid.Components.Branch(R=typ.RCha*mulFac*
        len, X=typ.XCha*mulFac*len);

  parameter Real mulFac=1;
  parameter IDEAS.Electric.Data.Interfaces.Cable typ = IDEAS.Electric.Data.Cables.PvcAl16()
    "Cable type";
  parameter Modelica.SIunits.Length len=10 "Cable length";

end BranchLenTyp;
