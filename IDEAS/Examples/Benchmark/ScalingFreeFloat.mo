within IDEAS.Examples.Benchmark;
model ScalingFreeFloat
  extends Modelica.Icons.Example;
  parameter Integer n = 1 "Number of buildings";
  inner BoundaryConditions.SimInfoManager       sim
    "Simulation information manager for climate data"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));


  IDEAS.Buildings.Validation.BaseClasses.Structure.Bui900 bui[n]
    annotation (Placement(transformation(extent={{-20,0},{8,20}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=3.15e+06,
      __Dymola_fixedstepsize=30,
      __Dymola_Algorithm="Euler"));
end ScalingFreeFloat;
