within Annex60.Experimental.ThermalZones.ReducedOrder.ReducedOrderZones;
model ThermalZoneTwoElements
  "Thermal Zone with two elements for exterior and interior walls"
  extends ThermalZoneOneElement(AArray={AExt,AWin,AInt});
  parameter Modelica.SIunits.Area AInt "Area of interior walls"
  annotation(Dialog(group="Interior walls"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaInt
    "Coefficient of heat transfer of interior walls (indoor)"
    annotation(Dialog(group="Interior walls"));
  parameter Integer nInt(min = 1) "Number of RC-elements of interior walls"
  annotation(Dialog(group="Interior walls"));
  parameter Modelica.SIunits.ThermalResistance RInt[nInt](
   each min=Modelica.Constants.small)
    "Vector of resistances of interior walls, from port to center"
     annotation(Dialog(group="Interior walls"));
  parameter Modelica.SIunits.HeatCapacity CInt[nInt](
   each min=Modelica.Constants.small)
    "Vector of heat capacities of interior walls, from port to center"
    annotation(Dialog(group="Interior walls"));
  parameter Boolean indoorPortIntWalls = false
    "Additional heat port at indoor surface of interior walls"
    annotation(Dialog(group="Interior walls"),choices(checkBox = true));
  BaseClasses.InteriorWall intWallRC(
    n=nInt,
    RInt=RInt,
    CInt=CInt,
    T_start=T_start) if
                  AInt > 0 "RC-element for interior walls"
    annotation (Placement(transformation(extent={{182,-46},{202,-24}})));
  Modelica.Thermal.HeatTransfer.Components.Convection convIntWall if AInt > 0
    "convective heat transfer of interior walls"
    annotation (Placement(transformation(extent={{148,-26},{128,-46}})));
  Modelica.Blocks.Sources.Constant alphaIntWall(k=AInt*alphaInt) if AInt > 0
    "coefficient of convective heat transfer for interior walls"
    annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=-90,
        origin={138,-57})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor resExtWallIntWall(
   G=min(AExt, AInt)*alphaRad) if  AExt > 0 and AInt > 0
    "resistor between exterior walls and interior walls"
    annotation (Placement(transformation(extent={{138,-116},{158,-96}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor resIntWallWin(G=min(
        AWin, AInt)*alphaRad) if  AWin > 0 and AInt > 0
    "resistor between interior walls and windows"
    annotation (Placement(transformation(extent={{74,-118},{94,-98}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a intWallIndoorSurface if
     indoorPortIntWalls "auxilliary port at indoor surface of interior walls"
    annotation (Placement(transformation(extent={{-130,-180},{-110,-160}}),
    iconTransformation(extent={{-130,-180},{-110,-160}})));
equation
  connect(resExtWallIntWall.port_a, convExtWall.solid) annotation (Line(
      points={{138,-106},{110,-106},{110,-86},{-144,-86},{-144,-36},{-114,-36}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(convIntWall.solid, intWallRC.port_a) annotation (Line(
      points={{148,-36},{182.4,-36}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intWallRC.port_a, resExtWallIntWall.port_b) annotation (Line(
      points={{182.4,-36},{168,-36},{168,-106},{158,-106}},
      color={191,0,0},
      smooth=Smooth.None));
  if not AExt > 0 and not AWin > 0 and AInt > 0 then
    connect(thermSplitterIntGains.signalOutput[1], intWallRC.port_a);
    connect(thermSplitterSolRad.signalOutput[1], intWallRC.port_a);
  elseif AExt > 0 and not AWin > 0 and AInt > 0 or not AExt > 0 and AWin > 0
    and AInt > 0 then
    connect(thermSplitterIntGains.signalOutput[2], intWallRC.port_a);
    connect(thermSplitterSolRad.signalOutput[2], intWallRC.port_a);
  elseif AExt > 0 and AWin > 0 and AInt > 0 then
    connect(thermSplitterIntGains.signalOutput[3], intWallRC.port_a)
      annotation (Line(
        points={{190,88},{190,82},{164,82},{164,-36},{182.4,-36}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(thermSplitterSolRad.signalOutput[3], intWallRC.port_a) annotation (
        Line(
        points={{-136,146},{-60,146},{-60,102},{160,102},{160,-36},{182.4,-36}},
        color={191,0,0},
        smooth=Smooth.None));

  end if;
  connect(resIntWallWin.port_b, intWallRC.port_a) annotation (Line(
      points={{94,-108},{118,-108},{118,-84},{168,-84},{168,-36},{182.4,-36}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(resIntWallWin.port_a, convWin.solid) annotation (Line(
      points={{74,-108},{68,-108},{68,-94},{-46,-94},{-46,20},{-146,20},{-146,
          38},{-116,38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(alphaIntWall.y, convIntWall.Gc) annotation (Line(points={{138,-51.5},
          {138,-49.75},{138,-46}},              color={0,0,127}));
  connect(intWallRC.port_a, intWallIndoorSurface) annotation (Line(points={{182.4,
          -36},{170,-36},{170,-78},{-120,-78},{-120,-170}},       color={191,0,
          0}));
  connect(convIntWall.fluid, TIndAirSensor.port) annotation (Line(points={{128,
          -36},{66,-36},{66,20},{74,20}}, color={191,0,0}));
  annotation (defaultComponentName="thermZone",Diagram(coordinateSystem(
   preserveAspectRatio=false, extent={{-240,-180},{240,180}}), graphics={
        Polygon(
          points={{116,-14},{230,-14},{230,-76},{140,-76},{138,-76},{116,-76},{
              116,-14}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{173,-61},{224,-78}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Interior Walls")}), Documentation(revisions="<html>
<ul>
<li>April 18, 2015, by Moritz Lauster:<br>First implementation. </li>
</ul>
</html>", info="<html>
<p><code>ThermalZoneTwoElements</code><i> </i>distinguishes between internal 
thermal masses and outer walls. While outer walls contribute to heat transfer to 
the ambient, adiabatic conditions apply to internal masses. Internal wall element 
needs length of RC-chain <code>nInt</code>, vector of capacities 
<code>CInt[nInt]</code> and vector of resistances <code>RInt[nInt].</code> 
This approach allows considering the dynamic behaviour induced by internal heat 
storage.</p>
<p align=\"center\"><img src=\"modelica://Annex60/Resources/Images/Experimental/ThermalZones/ReducedOrder/ROM/ThermalZoneTwoElements/TwoElements.png\" alt=\"image\"/> </p>
</html>"),
    Icon(coordinateSystem(extent={{-240,-180},{240,180}},
    preserveAspectRatio=false),
        graphics={Rectangle(
          extent={{-36,40},{32,-38}},
          fillColor={230,230,230},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Text(
          extent={{-62,62},{62,-62}},
          lineColor={0,0,0},
          textString="2")}));
end ThermalZoneTwoElements;
