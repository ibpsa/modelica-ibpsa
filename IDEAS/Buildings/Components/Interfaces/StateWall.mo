within IDEAS.Buildings.Components.Interfaces;
partial model StateWall "Partial model for building envelope components"
  parameter Modelica.SIunits.Angle inc
    "Inclination of the wall, i.e. 90deg denotes vertical";
  parameter Modelica.SIunits.Angle azi
    "Azimuth of the wall, i.e. 0deg denotes South";
  outer IDEAS.SimInfoManager sim
    "Simulation information manager for climate data"
    annotation (Placement(transformation(extent={{30,-100},{50,-80}})));
  parameter Modelica.SIunits.Power QTra_design
    "Design heat losses at reference temperature of the boundary space"
    annotation(Dialog(tab="Design power"));

  ZoneBus propsBus_a(numAzi=sim.numAzi, computeConservationOfEnergy=sim.computeConservationOfEnergy)
    "Inner side (last layer)"
                     annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={50,40}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={50,40})));
  Modelica.Blocks.Sources.RealExpression incExp(y=inc) "Inclination angle"
    annotation (Placement(transformation(extent={{100,78},{80,98}})));
  Modelica.Blocks.Sources.RealExpression aziExp(y=azi)
    "Azimuth angle expression"
    annotation (Placement(transformation(extent={{100,62},{80,82}})));
equation
  connect(incExp.y, propsBus_a.inc) annotation (Line(
      points={{79,88},{50,88},{50,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(aziExp.y, propsBus_a.azi) annotation (Line(
      points={{79,72},{50,72},{50,40}},
      color={0,0,127},
      smooth=Smooth.None));
protected
  Modelica.Blocks.Sources.RealExpression QDesign(y=QTra_design);
equation
  connect(QDesign.y, propsBus_a.QTra_design);
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-50,-100},{50,100}}), graphics),
    Documentation(revisions="<html>
<ul>
<li>
February 10, 2015 by Filip Jorissen:<br/>
Adjusted implementation for grouping of solar calculations.
</li>
</ul>
</html>"));
end StateWall;
