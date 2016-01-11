within Annex60.Experimental.ThermalZones.ReducedOrder.ROM.Star;
model ThermalZoneTwoElements
  "Thermal Zone with two elements for exterior and interior walls"
  extends ROM.Star.ThermalZoneOneElement(
                                AArray={AExt,AWin,AInt});
  parameter Modelica.SIunits.Area AInt "Area of interior walls"    annotation(Dialog(group="Interior walls"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaInt
    "Coefficient of heat transfer of interior walls (indoor)" annotation(Dialog(group="Interior walls"));
  parameter Integer nInt(min = 1) "Number of RC-elements of interior walls" annotation(Dialog(group="Interior walls"));
  parameter Modelica.SIunits.ThermalResistance RInt[nInt]
    "Vector of resistances of interior walls, from port to center"                         annotation(Dialog(group="Interior walls"));
  parameter Modelica.SIunits.HeatCapacity CInt[nInt]
    "Vector of heat capacities of interior walls, from port to center"                       annotation(Dialog(group="Interior walls"));

  BaseClasses.IntMassVarRC intWallRC(
    n=nInt,
    RInt=RInt,
    CInt=CInt,
    T_start=T_start) if
                  AInt > 0 "RC-element for interior walls"
    annotation (Placement(transformation(extent={{182,-48},{202,-26}})));
  Modelica.Thermal.HeatTransfer.Components.Convection         convIntWall if
                                                                            AInt > 0
    "convective heat transfer of interior walls"
    annotation (Placement(transformation(extent={{148,-28},{128,-48}})));
  Modelica.Blocks.Sources.Constant alphaIntWall(k=AInt*alphaInt) if    AInt > 0
    "coefficient of convective heat transfer for interior walls"
    annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=-90,
        origin={138,-59})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor radIntWallStar(G=AInt*
        alphaRad) if              AInt > 0
    "resistor between interior walls and star network"
    annotation (Placement(transformation(extent={{106,10},{86,30}})));
equation
  connect(convIntWall.fluid, intGainsConv) annotation (Line(
      points={{128,-38},{128,0},{64,0},{64,38},{230,38}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(convIntWall.solid, intWallRC.port_a) annotation (Line(
      points={{148,-38},{182.8,-38}},
      color={191,0,0},
      smooth=Smooth.None));
  if not AExt > 0 and not AWin > 0 and AInt > 0 then
    connect(thermSplitterIntGains.signalOutput[1], intWallRC.port_a);
    connect(thermSplitterSolRad.signalOutput[1], intWallRC.port_a);
  elseif AExt > 0 and not AWin > 0 and AInt > 0 or not AExt > 0 and AWin > 0 and AInt > 0 then
    connect(thermSplitterIntGains.signalOutput[2], intWallRC.port_a);
    connect(thermSplitterSolRad.signalOutput[2], intWallRC.port_a);
  elseif AExt > 0 and AWin > 0 and AInt > 0 then
    connect(thermSplitterIntGains.signalOutput[3], intWallRC.port_a)
      annotation (Line(
        points={{190,88},{190,80},{164,80},{164,-38},{182.8,-38}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(thermSplitterSolRad.signalOutput[3], intWallRC.port_a) annotation (
        Line(
        points={{-136,146},{-60,146},{-60,100},{160,100},{160,-38},{182.8,-38}},
        color={191,0,0},
        smooth=Smooth.None));

  end if;
  connect(alphaIntWall.y, convIntWall.Gc) annotation (Line(points={{138,-53.5},
          {138,-51.75},{138,-51.75},{138,-48}}, color={0,0,127}));
  connect(radIntWallStar.port_a, intWallRC.port_a) annotation (Line(points={{106,20},
          {168,20},{168,-38},{182.8,-38}},     color={191,0,0}));
  connect(radIntWallStar.port_b, TRadStar.port) annotation (Line(points={{86,20},
          {76,20},{76,20},{76,44},{16,44},{16,60}},
                                            color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -180},{240,180}}), graphics={
        Polygon(
          points={{116,-16},{230,-16},{230,-78},{140,-78},{138,-78},{116,-78},{
              116,-16}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{173,-63},{224,-80}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Interior Walls")}), Documentation(revisions="<html>
<ul>
<li>April 18, 2015, by Moritz Lauster:<br>First implementation. </li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-240,-180},{240,180}}, preserveAspectRatio=false),
        graphics={Rectangle(
          extent={{-36,40},{32,-38}},
          fillColor={230,230,230},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Text(
          extent={{-62,62},{62,-62}},
          lineColor={0,0,0},
          textString="2")}));
end ThermalZoneTwoElements;
