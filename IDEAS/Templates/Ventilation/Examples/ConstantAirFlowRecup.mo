within IDEAS.Templates.Ventilation.Examples;
model ConstantAirFlowRecup
  "Example of ventilation system with constant air flow rate"
  extends Modelica.Icons.Example;
  parameter Boolean standAlone=true;

  replaceable package Medium = IDEAS.Media.Air;

  inner IDEAS.BoundaryConditions.SimInfoManager sim
    "Simulation information manager for climate data"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  IDEAS.Buildings.Examples.BaseClasses.structure structure(redeclare package
      Medium = Medium)
    annotation (Placement(transformation(extent={{-78,-40},{-48,-20}})));
  replaceable
  IDEAS.Templates.Ventilation.ConstantAirFlowRecup constantAirFlowRecup(
    n=2.*structure.VZones)
    constrainedby IDEAS.Templates.Interfaces.BaseClasses.VentilationSystem(
    nZones=3,
    VZones=structure.VZones,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
  IDEAS.Templates.Interfaces.BaseClasses.CausalInhomeFeeder causalInhomeFeeder
    annotation (Placement(transformation(extent={{16,-10},{36,10}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource
    voltageSource(
    f=50,
    V=230,
    phi=0) if standAlone annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={58,-30})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground if
    standAlone
    annotation (Placement(transformation(extent={{48,-80},{68,-60}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin
    plugFeeder(v(re(start=230), im(start=0))) if not standAlone
    "Electricity connection to the district feeder"
    annotation (Placement(transformation(extent={{78,-10},{98,10}})));

equation
  connect(voltageSource.pin_p, ground.pin) annotation (Line(
      points={{58,-40},{58,-60}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(causalInhomeFeeder.pinSingle, plugFeeder) annotation (Line(
      points={{36,0},{88,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(causalInhomeFeeder.pinSingle, voltageSource.pin_n) annotation (Line(
      points={{36,0},{58,0},{58,-20}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(constantAirFlowRecup.plugLoad, causalInhomeFeeder.nodeSingle)
    annotation (Line(
      points={{-8,0},{16,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(structure.port_b, constantAirFlowRecup.port_a) annotation (Line(
      points={{-65,-20},{-66,-20},{-66,2},{-28,2}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(structure.port_a, constantAirFlowRecup.port_b) annotation (Line(
      points={{-61,-20},{-60,-20},{-60,-2},{-28,-2}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(structure.TSensor, constantAirFlowRecup.TSensor) annotation (Line(
      points={{-47.4,-36},{-36,-36},{-36,-6},{-28.2,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics),
    Documentation(info="<html>
<p>
Model demonstrating the use of the ventilation system template.
</p>
</html>",     revisions="<html>
<ul>
<li>
January 23, 2017 by Glenn Reynders:<br/>
Revised implementation
</li>
</ul>
</html>"),
    __Dymola_Commands(file="modelica://IDEAS/Resources/Scripts/Dymola/Templates/Ventilation/Examples/constantAirFlowRecup.mos"
        "Simulate and Plot"));
end ConstantAirFlowRecup;
