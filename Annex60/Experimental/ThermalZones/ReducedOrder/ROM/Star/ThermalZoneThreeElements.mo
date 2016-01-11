within Annex60.Experimental.ThermalZones.ReducedOrder.ROM.Star;
model ThermalZoneThreeElements
  "Thermal Zone with three elements for exterior walls, interior walls and floor plate"
    extends ROM.Star.ThermalZoneTwoElements(
                                   AArray={AExt,AWin,AInt,AFloor});
  parameter Modelica.SIunits.Area AFloor "Area of floor plate" annotation(Dialog(group="Floor plate"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaFloor
    "Coefficient of heat transfer of floor plate (indoor)" annotation(Dialog(group="Floor plate"));
  parameter Integer nFloor(min = 1) "Number of RC-elements of floor plate" annotation(Dialog(group="Floor plate"));
  parameter Modelica.SIunits.ThermalResistance RFloor[nExt]
    "Vector of resistances of floor plate, from inside to outside"                 annotation(Dialog(group="Floor plate"));
  parameter Modelica.SIunits.ThermalResistance RFloorRem
    "Resistance of remaining resistor RFloorRem between capacitance n and outside"
                                                                                   annotation(Dialog(group="Floor plate"));
  parameter Modelica.SIunits.HeatCapacity CFloor[nExt]
    "Vector of heat capacities of floor plate, from inside to outside"  annotation(Dialog(group="Floor plate"));
  BaseClasses.ExtMassVarRC floorRC(
    n=nFloor,
    RExt=RFloor,
    RExtRem=RFloorRem,
    CExt=CFloor,
    T_start=T_start) if
                    AFloor > 0 "RC-element for floor plate" annotation (
      Placement(transformation(
        extent={{10,-11},{-10,11}},
        rotation=90,
        origin={-12,-152})));
  Modelica.Thermal.HeatTransfer.Components.Convection         convFloor if     AFloor > 0
    "convective heat transfer of floor"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-12,-116})));
  Modelica.Blocks.Sources.Constant alphaFloorConst(k=AFloor*alphaFloor) if   AFloor > 0
    "coefficient of convective heat transfer for floor"
    annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={22,-116})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor radFloorStar(G=AFloor*
        alphaRad) if                AExt > 0 and AFloor > 0
    "resistor floor and star network" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-66})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a floor if         AFloor > 0
    "ambient port for floor plate" annotation (Placement(transformation(extent=
            {{-22,-180},{-2,-160}}), iconTransformation(extent={{-22,-180},{-2,
            -160}})));
equation
  connect(floorRC.port_a, convFloor.solid) annotation (Line(
      points={{-12,-143.6},{-12,-126}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convFloor.fluid, volAir.heatPort) annotation (Line(
      points={{-12,-106},{-12,-72},{8,-72},{8,-36},{64,-36},{64,0},{38,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(floorRC.port_b, floor) annotation (Line(
      points={{-12,-162.2},{-12,-170}},
      color={191,0,0},
      smooth=Smooth.None));
  if not AExt > 0 and not AWin > 0 and not AInt > 0 and AFloor > 0 then
    connect(thermSplitterIntGains.signalOutput[1], floorRC.port_a);
    connect(floorRC.port_a, thermSplitterSolRad.signalOutput[1]);
  elseif AExt > 0 and not AWin > 0 and not AInt > 0 and AFloor > 0
    or not AExt > 0 and AWin > 0 and not AInt > 0 and AFloor > 0
    or not AExt > 0 and not AWin > 0 and AInt > 0 and AFloor > 0 then
    connect(thermSplitterIntGains.signalOutput[2], floorRC.port_a);
    connect(floorRC.port_a, thermSplitterSolRad.signalOutput[2]);
  elseif not AExt > 0 and AWin > 0 and AInt > 0 and AFloor > 0
    or AExt > 0 and not AWin > 0 and AInt > 0 and AFloor > 0
    or AExt > 0 and AWin > 0 and not AInt > 0 and AFloor > 0 then
    connect(thermSplitterIntGains.signalOutput[3], floorRC.port_a);
    connect(floorRC.port_a, thermSplitterSolRad.signalOutput[3]);
  elseif AExt > 0 and AWin > 0 and AInt > 0 and AFloor > 0 then
    connect(thermSplitterIntGains.signalOutput[4], floorRC.port_a) annotation (
        Line(
        points={{190,88},{190,80},{-54,80},{-54,-136},{-12,-136},{-12,-143.6}},
        color={191,0,0},
        smooth=Smooth.None));

    connect(floorRC.port_a, thermSplitterSolRad.signalOutput[4]) annotation (
        Line(
        points={{-12,-143.6},{-12,-140},{-58,-140},{-58,146},{-136,146}},
        color={191,0,0},
        smooth=Smooth.None));
  end if;
  connect(alphaFloorConst.y, convFloor.Gc) annotation (Line(points={{16.5,-116},
          {-2,-116},{-2,-116}}, color={0,0,127}));
  connect(radFloorStar.port_a, convFloor.solid) annotation (Line(points={{-40,
          -66},{-40,-66},{-50,-66},{-50,-132},{-12,-132},{-12,-126}}, color={
          191,0,0}));
  connect(radFloorStar.port_b, TRadStar.port) annotation (Line(points={{-20,-66},
          {-20,-66},{-10,-66},{-10,56},{16,56},{16,60}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(extent={{-240,-180},{240,180}},
          preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-32,-100},{50,-166}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{6,-152},{48,-166}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Floor Plate")}),           Icon(coordinateSystem(extent={{-240,
            -180},{240,180}}, preserveAspectRatio=false), graphics={Rectangle(
          extent={{-32,40},{34,-40}},
          pattern=LinePattern.None,
          fillColor={230,230,230},
          fillPattern=FillPattern.Solid), Text(
          extent={{-64,60},{60,-64}},
          lineColor={0,0,0},
          textString="3")}),
    Documentation(revisions="<html>
<ul>
<li>
July 15, 2015 by Moritz Lauster:<br/>
First Implementation.
</li>
</ul>
</html>"));
end ThermalZoneThreeElements;
