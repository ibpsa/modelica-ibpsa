within IDEAS.Examples.Benchmark;
model ScalingWithHvac
  extends Modelica.Icons.Example;
  parameter Integer n = 1 "Number of buildings";
  inner BoundaryConditions.SimInfoManager       sim
    "Simulation information manager for climate data"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  constant Modelica.SIunits.Angle angleOffsets[n]= {2*i*Modelica.Constants.pi/n for i in 1:n};
  IDEAS.Buildings.Validation.Cases.Case900 case900[n](building(aO=angleOffsets))
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=3.15e+06,
      __Dymola_fixedstepsize=30,
      __Dymola_Algorithm="Dassl"));
end ScalingWithHvac;
