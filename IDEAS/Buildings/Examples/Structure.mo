within IDEAS.Buildings.Examples;
model Structure "Example detailed building structure model"
  extends Modelica.Icons.Example;
  BaseClasses.structure structure
    annotation (Placement(transformation(extent={{-36,-20},{-6,0}})));
  VentilationSystems.None none(
    nLoads=0,
    nZones=structure.nZones,
    VZones=structure.VZones)
    annotation (Placement(transformation(extent={{18,0},{38,20}})));
  inner SimInfoManager       sim
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
equation
  connect(structure.flowPort_Out, none.flowPort_In) annotation (Line(
      points={{-23,0},{-24,0},{-24,12},{18,12}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(structure.flowPort_In, none.flowPort_Out) annotation (Line(
      points={{-19,0},{-20,0},{-20,8},{18,8}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(structure.TSensor, none.TSensor) annotation (Line(
      points={{-5.4,-16},{8,-16},{8,4},{17.6,4}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end Structure;
