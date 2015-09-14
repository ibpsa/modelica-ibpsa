within Annex60.Experimental.ThermalZones;
model ThermalZoneTwoElements
  "Thermal Zone with two elements for exterior and interior walls"
  extends ThermalZoneOneElement(ASum=AExtInd+AWinInd+AInt,
                             thermSplitterIntGains(splitFactor=if not AExtInd > 0 and AWinInd > 0 and not AInt > 0 then {AWinInd/(AExtInd + AWinInd + AInt)} else if not AWinInd > 0 and AExtInd > 0 and not AInt > 0 then {AExtInd/(AExtInd + AWinInd + AInt)} else if not AWinInd > 0 and not AExtInd > 0 and AInt > 0 then {AInt/(AExtInd + AWinInd + AInt)} else if not AExtInd > 0 and AWinInd > 0 and AInt > 0 then {
  AWinInd/(AExtInd + AWinInd + AInt),AInt/(AExtInd + AWinInd + AInt)} else if AExtInd > 0 and not AWinInd > 0 and AInt > 0 then {
  AExtInd/(AExtInd + AWinInd + AInt),AInt/(AExtInd + AWinInd + AInt)} else if AExtInd > 0 and AWinInd > 0 and not AInt > 0 then {
  AExtInd/(AExtInd + AWinInd + AInt),AWinInd/(AExtInd + AWinInd + AInt)} else {
  AExtInd/(AExtInd + AWinInd + AInt),AWinInd/(AExtInd + AWinInd + AInt),AInt/(AExtInd + AWinInd + AInt)}, dimension=if not AExtInd > 0 and not AWinInd > 0 and not AInt > 0 then 0 else if not AExtInd > 0 and AWinInd > 0 and not AInt > 0 then 1 else if not AWinInd > 0 and AExtInd > 0 and not AInt > 0 then 1 else if not AExtInd > 0 and not AWinInd > 0 and AInt > 0 then 1 else if AExtInd > 0 and AWinInd > 0 and not AInt > 0 then 2 else if not AExtInd > 0 and AWinInd > 0 and AInt > 0 then 2 else if AExtInd > 0 and not AWinInd > 0 and AInt > 0 then 2 else 3),
      thermSplitterSolRad(splitFactor=if not AExtInd > 0 and AWinInd > 0 and not AInt > 0 then {AWinInd/(AExtInd + AWinInd + AInt)} else if not AWinInd > 0 and AExtInd > 0 and not AInt > 0 then {AExtInd/(AExtInd + AWinInd + AInt)} else if not AWinInd > 0 and not AExtInd > 0 and AInt > 0 then {AInt/(AExtInd + AWinInd + AInt)} else if not AExtInd > 0 and AWinInd > 0 and AInt > 0 then {
  AWinInd/(AExtInd + AWinInd + AInt),AInt/(AExtInd + AWinInd + AInt)} else if AExtInd > 0 and not AWinInd > 0 and AInt > 0 then {
  AExtInd/(AExtInd + AWinInd + AInt),AInt/(AExtInd + AWinInd + AInt)} else if AExtInd > 0 and AWinInd > 0 and not AInt > 0 then {
  AExtInd/(AExtInd + AWinInd + AInt),AWinInd/(AExtInd + AWinInd + AInt)} else {
  AExtInd/(AExtInd + AWinInd + AInt),AWinInd/(AExtInd + AWinInd + AInt),AInt/(AExtInd + AWinInd + AInt)}, dimension=if not AExtInd > 0 and not AWinInd > 0 and not AInt > 0 then 0 else if not AExtInd > 0 and AWinInd > 0 and not AInt > 0 then 1 else if not AWinInd > 0 and AExtInd > 0 and not AInt > 0 then 1 else if not AExtInd > 0 and not AWinInd > 0 and AInt > 0 then 1 else if AExtInd > 0 and AWinInd > 0 and not AInt > 0 then 2 else if not AExtInd > 0 and AWinInd > 0 and AInt > 0 then 2 else if AExtInd > 0 and not AWinInd > 0 and AInt > 0 then 2 else 3));
  parameter Modelica.SIunits.Area AInt = 0
    "Surface area of internal thermal mass"                                           annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaIntInd
    "Coefficient of heat transfer for surface of internal thermal mass" annotation(Dialog(group="Thermal mass"));
  parameter Integer nInt(min = 1)
    "Number of RC-elements for internal thermal mass"                               annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.ThermalResistance RInt[nInt]
    "Vector of resistances for each RC-element for internal mass, from port to capacitances"
                                                                                             annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.HeatCapacity CInt[nInt]
    "Vector of heat capacity of thermal masses for each RC-element, from port to central mass"
                                                                                               annotation(Dialog(group="Thermal mass"));

  BaseClasses.IntMassVarRC intWallRC(
    n=nInt,
    RInt=RInt,
    CInt=CInt) if AInt > 0 "RC-element for interior walls"
    annotation (Placement(transformation(extent={{182,-48},{202,-26}})));
  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor convIntWall if
                                                                            AInt > 0
    annotation (Placement(transformation(extent={{148,-28},{128,-48}})));
  Modelica.Blocks.Sources.Constant alphaIntWall(k=1/(AInt*alphaIntInd)) if
                                                                       AInt > 0
    annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=-90,
        origin={138,-59})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor resExtWallIntWall(R=1/(min(
        AExtInd, AInt)*alphaRad)) if AExtInd > 0 and AInt > 0
    "resistor between exterior walls and interior walls"
    annotation (Placement(transformation(extent={{138,-116},{158,-96}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor resIntWallsWin(R=1/(min(
        AWinInd, AInt)*alphaRad)) if AWinInd > 0 and AInt > 0
    "resistor between interior walls and windows"
    annotation (Placement(transformation(extent={{74,-118},{94,-98}})));
equation
  connect(convIntWall.fluid, portIntGainsConv) annotation (Line(
      points={{128,-38},{128,0},{64,0},{64,38},{230,38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(alphaIntWall.y, convIntWall.Rc) annotation (Line(
      points={{138,-53.5},{138,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(resExtWallIntWall.port_a, heatConExt.solid) annotation (Line(
      points={{138,-106},{110,-106},{110,-86},{-144,-86},{-144,-36},{-114,-36}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(convIntWall.solid, intWallRC.port_a) annotation (Line(
      points={{148,-38},{182.8,-38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intWallRC.port_a, resExtWallIntWall.port_b) annotation (Line(
      points={{182.8,-38},{168,-38},{168,-106},{158,-106}},
      color={191,0,0},
      smooth=Smooth.None));
  if not AExtInd > 0 and not AWinInd > 0 and AInt > 0 then
    connect(thermSplitterIntGains.signalOutput[1], intWallRC.port_a);
    connect(thermSplitterSolRad.signalOutput[1], intWallRC.port_a);
  elseif AExtInd > 0 and not AWinInd > 0 and AInt > 0 or not AExtInd > 0 and AWinInd > 0 and AInt > 0 then
    connect(thermSplitterIntGains.signalOutput[2], intWallRC.port_a);
    connect(thermSplitterSolRad.signalOutput[2], intWallRC.port_a);
  elseif AExtInd > 0 and AWinInd > 0 and AInt > 0 then
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
  connect(resIntWallsWin.port_b, intWallRC.port_a) annotation (Line(
      points={{94,-108},{118,-108},{118,-86},{168,-86},{168,-38},{182.8,-38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(resIntWallsWin.port_a, heatConWin.solid) annotation (Line(
      points={{74,-108},{68,-108},{68,-94},{-46,-94},{-46,20},{-146,20},{-146,38},
          {-116,38}},
      color={191,0,0},
      smooth=Smooth.None));
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
