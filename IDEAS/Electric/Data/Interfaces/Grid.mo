within IDEAS.Electric.Data.Interfaces;
partial record Grid
  "Describes a grid based on a grid layout and the used cable sections"

  extends Modelica.Icons.MaterialProperty;

  parameter Integer nPhases = 3 "number of phases";
  parameter IDEAS.Electric.Data.Interfaces.Layout     layout "Grid layout";

  parameter Modelica.SIunits.Length[layout.nNodes] cableLengths
    "Length of each branch in the network, first value is 0";
  parameter IDEAS.Electric.Data.Interfaces.Cable[layout.nNodes] cableTypes
    "Cable type for each branch in the network, first value should be anything";

  final parameter Modelica.SIunits.Resistance[layout.nNodes] R = cableTypes.RCha.*cableLengths*nPhases/3
    "Electric resistance of the cables between depicted nodes";
  final parameter Modelica.SIunits.Reactance[layout.nNodes] X = cableTypes.XCha.*cableLengths
    "Electric reactances of the cables between depicted nodes";
  final parameter Modelica.SIunits.ComplexImpedance[layout.nNodes] Z(re=R,im=X)
    "Complex impedances of the cables between depicted nodes";

end Grid;
