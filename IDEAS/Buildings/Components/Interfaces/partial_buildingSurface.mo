within IDEAS.Buildings.Components.Interfaces;
partial model partial_buildingSurface
  "Partial model for building envelope component"
  parameter Modelica.SIunits.Angle inc
    "Inclination of the wall, i.e. 90deg denotes vertical";
  parameter Modelica.SIunits.Angle azi
    "Azimuth of the wall, i.e. 0deg denotes South";
  outer IDEAS.SimInfoManager sim
    "Simulation information manager for climate data"
    annotation (Placement(transformation(extent={{30,-100},{50,-80}})));
  parameter Modelica.SIunits.Power QTra_design
    "Design heat losses at reference temperature of the boundary space"
    annotation (Dialog(tab="Design power"));

  parameter Modelica.SIunits.Temperature T_start=293.15
    "Start temperature for each of the layers";

  parameter Modelica.SIunits.Temperature TRef_a=291.15
    "Reference temperature of zone on side of propsBus_a, for calculation of design heat loss"
                                                                                               annotation (Dialog(group="Design heat loss"));
  parameter Boolean linearise_a=true
    "= true, if convective heat transfer should be linearised"
    annotation(Dialog(tab="Convection"));
  parameter Modelica.SIunits.TemperatureDifference dT_nominal_a=1
    "Nominal temperature difference used for linearisation, negative temperatures indicate the solid is colder"
    annotation(Dialog(tab="Convection"));

  ZoneBus propsBus_a(numAzi=sim.numAzi, computeConservationOfEnergy=sim.computeConservationOfEnergy) "If inc = floor, propsbus_a should be connected to the zone above.
    If inc = ceiling, propsbus_a should be connected to the zone below.
    If component is an outerWall, porpsBus_a should be connect to the zone."
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={50,40}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={50,40})));

protected
  Modelica.Blocks.Sources.RealExpression QDesign(y=QTra_design);
  BaseClasses.InteriorConvection                            intCon_a(
    linearise=linearise_a,
    dT_nominal=dT_nominal_a,
    final inc=inc)
    "convective surface heat transimission on the interior side of the wall"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

equation
  connect(QDesign.y, propsBus_a.QTra_design);
  connect(propsBus_a.surfCon,intCon_a. port_b) annotation (Line(
      points={{50.1,39.9},{46,39.9},{46,0},{40,0}},
      color={191,0,0},
      smooth=Smooth.None));

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-50,-100},{50,100}}),
        graphics),
    Documentation(revisions="<html>
<ul>
<li>
February 6, 2016 by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end partial_buildingSurface;
