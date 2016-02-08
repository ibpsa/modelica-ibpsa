within IDEAS.Buildings.Components.Interfaces;
partial model partial_lucentBuildingSurface
  "Partial component for the transparent surfaces of the building envelope"
  extends partial_buildingSurface(intCon_a(final A=
         A*(1 - frac),
     linearise=linearise_a,
     dT_nominal=dT_nominal_a));

   parameter Modelica.SIunits.Area A "Total window and windowframe area";
   parameter Real frac(
    min=0,
    max=1) = 0.15 "Area fraction of the window frame";
  replaceable IDEAS.Buildings.Data.Glazing.Ins2 glazing
    constrainedby IDEAS.Buildings.Data.Interfaces.Glazing "Glazing type"
    annotation (__Dymola_choicesAllMatching=true, Dialog(group=
          "Construction details"));
  replaceable IDEAS.Buildings.Data.Frames.None fraType
    constrainedby IDEAS.Buildings.Data.Interfaces.Frame "Window frame type"
    annotation (__Dymola_choicesAllMatching=true, Dialog(group=
          "Construction details"));
protected
   IDEAS.Buildings.Components.BaseClasses.MultiLayerLucent   layMul(    final A=A*(1 - frac),
     final nLay=glazing.nLay,
     final mats=glazing.mats,
    final inc=inc)
    "declaration of array of resistances and capacitances for window simulation"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}})));

equation
      connect(layMul.port_a, propsBus_a.surfRad) annotation (Line(
      points={{10,0},{14,0},{14,39.9},{50.1,39.9}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(layMul.port_a,intCon_a. port_a) annotation (Line(
      points={{10,0},{20,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_a, propsBus_a.epsSw) annotation (Line(
      points={{10,4},{18,4},{18,39.9},{50.1,39.9}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(layMul.iEpsLw_a, propsBus_a.epsLw) annotation (Line(
      points={{10,8},{14,8},{14,39.9},{50.1,39.9}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(layMul.area, propsBus_a.area) annotation (Line(
      points={{0,10},{0,39.9},{50.1,39.9}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
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
end partial_lucentBuildingSurface;
