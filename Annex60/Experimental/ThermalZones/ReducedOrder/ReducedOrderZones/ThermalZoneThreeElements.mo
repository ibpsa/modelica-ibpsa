within Annex60.Experimental.ThermalZones.ReducedOrder.ReducedOrderZones;
model ThermalZoneThreeElements "Thermal Zone with three elements for exterior walls, 
  interior walls and floor plate"
    extends ThermalZoneTwoElements(AArray={AExt,AWin,AInt,AFloor});
  parameter Modelica.SIunits.Area AFloor "Area of floor plate"
  annotation(Dialog(group="Floor plate"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaFloor
    "Coefficient of heat transfer of floor plate (indoor)"
    annotation(Dialog(group="Floor plate"));
  parameter Integer nFloor(min = 1) "Number of RC-elements of floor plate"
  annotation(Dialog(group="Floor plate"));
  parameter Modelica.SIunits.ThermalResistance RFloor[nExt](
   each min=Modelica.Constants.small)
    "Vector of resistances of floor plate, from inside to outside"
    annotation(Dialog(group="Floor plate"));
  parameter Modelica.SIunits.ThermalResistance RFloorRem(
   min=Modelica.Constants.small)
    "Resistance of remaining resistor RFloorRem between capacitance n and outside"
    annotation(Dialog(group="Floor plate"));
  parameter Modelica.SIunits.HeatCapacity CFloor[nExt](
   each min=Modelica.Constants.small)
    "Vector of heat capacities of floor plate, from inside to outside"
    annotation(Dialog(group="Floor plate"));
  parameter Boolean indoorPortFloor = false
    "Additional heat port at indoor surface of floor plate"
    annotation(Dialog(group="Floor plate"),choices(checkBox = true));
  BaseClasses.ExteriorWall floorRC(
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
  Modelica.Thermal.HeatTransfer.Components.Convection convFloor if AFloor > 0
    "convective heat transfer of floor"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-12,-116})));
  Modelica.Blocks.Sources.Constant alphaFloorConst(k=AFloor*alphaFloor) if
     AFloor > 0 "coefficient of convective heat transfer for floor"
    annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={22,-116})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor resExtWallFloor(
   G=min(AExt, AFloor)*alphaRad) if  AExt > 0 and AFloor > 0
    "resistor between exterior walls and floor" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-144,-111})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor resIntWallFloor(
   G=min(AFloor, AInt)*alphaRad) if  AInt > 0 and AFloor > 0
    "resistor between interior walls and floor" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={204,-104})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a floor if  AFloor > 0
    "ambient port for floor plate" annotation (Placement(transformation(extent=
            {{-22,-180},{-2,-160}}), iconTransformation(extent={{-22,-180},{-2,
            -160}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor resFloorWin(G=min(
        AWin, AFloor)*alphaRad) if  AWin > 0 and AFloor > 0
    "resistor between floor plate and windows" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-82,-112})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a floorIndoorSurface if
     indoorPortFloor "auxilliary port at indoor surface of floor plate"
                                                       annotation (Placement(
        transformation(extent={{-92,-180},{-72,-160}}), iconTransformation(
          extent={{-92,-180},{-72,-160}})));
equation
  connect(floorRC.port_a, convFloor.solid) annotation (Line(
      points={{-12,-143.4},{-12,-126}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(floorRC.port_a, resExtWallFloor.port_b) annotation (Line(
      points={{-12,-143.4},{-12,-132},{-144,-132},{-144,-121}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(floorRC.port_a, resIntWallFloor.port_b) annotation (Line(
      points={{-12,-143.4},{-12,-132},{224,-132},{224,-104},{214,-104}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(floorRC.port_b, floor) annotation (Line(
      points={{-12,-162.6},{-12,-170}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(resFloorWin.port_a, convWin.solid) annotation (Line(
      points={{-82,-102},{-82,20},{-146,20},{-146,38},{-116,38}},
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
        points={{190,88},{190,80},{-38,80},{-38,-136},{-12,-136},{-12,-143.4}},
        color={191,0,0},
        smooth=Smooth.None));

    connect(floorRC.port_a, thermSplitterSolRad.signalOutput[4]) annotation (
        Line(
        points={{-12,-143.4},{-12,-140},{-42,-140},{-42,146},{-136,146}},
        color={191,0,0},
        smooth=Smooth.None));
  end if;
  connect(intWallRC.port_a, resIntWallFloor.port_a) annotation (Line(points=
         {{182.4, -36},{182.4,-36},{168,-36},{168,-86},{184,-86},{184,-104},
         {194,-104}},color={191,0,0}));
  connect(resFloorWin.port_b, resExtWallFloor.port_b) annotation (Line(points={{
          -82,-122},{-80,-122},{-80,-132},{-144,-132},{-144,-121}}, color={191,0,
          0}));
  connect(resExtWallFloor.port_a, convExtWall.solid) annotation (Line(
          points={{-144,-101},{-144,-36},{-114,-36}}, color={191,0,0}));
  connect(alphaFloorConst.y, convFloor.Gc) annotation (Line(points={{16.5,-116},
          {-2,-116},{-2,-116}}, color={0,0,127}));
  connect(convFloor.fluid, TIndAirSensor.port) annotation (Line(points={{-12,
          -106},{-12,-36},{66,-36},{66,20},{74,20}}, color={191,0,0}));
  connect(floorRC.port_a, floorIndoorSurface) annotation (Line(points={{-12,
          -143.4},{-46,-143.4},{-46,-144},{-82,-144},{-82,-170}},
                                                          color={191,0,0}));
  annotation (defaultComponentName="thermZone",Diagram(coordinateSystem(
          extent={{-240,-180},{240,180}},
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
          textString="Floor Plate")}), Icon(coordinateSystem(extent={{-240,
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
</html>", info="<html>
<p><code>ThermalZoneThree Elements</code><i> </i>adds one further element for 
the floor plate. Long-term effects dominate the excitation of the floor plate 
and thus the excitation fundamentally differs from excitation of outer walls. 
Adding an extra element for the floor plate leads to a finer resolution of the 
dynamic behaviour but implicates higher calculation times. Floor plate is 
parameterized via length of RC-chain <code>nFloor</code>, vector of capacities 
<code>CFloor[nFloor]</code>, vector of resistances <code>RFloor[nFloor]</code> 
and remaining resistance <code>RFloorRem</code>.</p>
<p align=\"center\"><img src=\"modelica://Annex60/Resources/Images/Experimental/ThermalZones/ReducedOrder/ROM/ThermalZoneThreeElements/ThreeElements.png\" alt=\"image\"/> </p>
</html>"));
end ThermalZoneThreeElements;
