within Annex60.Experimental.ThermalZones.ReducedOrder.ROM.Star;
model ThermalZoneFourElements
  "Thermal Zone with four elements for exterior walls, interior walls, floor plate and roof"
  extends ROM.Star.ThermalZoneThreeElements(
                                   AArray={AExt,AWin,AInt,AFloor,ARoof});
  parameter Modelica.SIunits.Area ARoof "Area of roof" annotation(Dialog(group="Roof"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaRoof
    "Coefficient of heat transfer of roof (indoor)" annotation(Dialog(group="Roof"));
  parameter Integer nRoof(min = 1) "Number of RC-elements of roof" annotation(Dialog(group="Roof"));
  parameter Modelica.SIunits.ThermalResistance RRoof[nExt]
    "Vector of resistances of roof, from inside to outside" annotation(Dialog(group="Roof"));
  parameter Modelica.SIunits.ThermalResistance RRoofRem
    "Resistance of remaining resistor RRoofRem between capacitance n and outside"
                                                                                  annotation(Dialog(group="Roof"));
  parameter Modelica.SIunits.HeatCapacity CRoof[nExt]
    "Vector of heat capacities of roof, from inside to outside" annotation(Dialog(group="Roof"));
  BaseClasses.ExtMassVarRC roofRC(
    RExt=RRoof,
    RExtRem=RRoofRem,
    CExt=CRoof,
    n=nRoof,
    T_start=T_start) if
                     ARoof > 0 "RC-element for roof" annotation (Placement(
        transformation(
        extent={{10,-11},{-10,11}},
        rotation=90,
        origin={-12,155})));
  Modelica.Thermal.HeatTransfer.Components.Convection         convRoof if      ARoof > 0
    "convective heat transfer of roof"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-12,120})));
  Modelica.Blocks.Sources.Constant alphaRoofConst(k=ARoof*alphaRoof) if            ARoof > 0
    "coefficient of convective heat transfer for roof"
    annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={22,120})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a roof if        ARoof > 0
    "ambient port for roof" annotation (Placement(transformation(extent={{-22,
            160},{-2,180}}), iconTransformation(extent={{-22,160},{-2,180}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor radRoofStar(G=ARoof*
        alphaRad) if                 AInt > 0 and ARoof > 0
    "resistor between roof and star network" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={96,64})));
equation
  connect(convRoof.solid, roofRC.port_b)
    annotation (Line(points={{-12,130},{-12,144.8}}, color={191,0,0}));
  connect(roofRC.port_a, roof)
    annotation (Line(points={{-12,163.4},{-12,170}}, color={191,0,0}));
  connect(convRoof.fluid, volAir.heatPort) annotation (Line(points={{-12,110},{
          -12,94},{64,94},{64,0},{38,0}}, color={191,0,0}));

  connect(radRoofStar.port_a, convRoof.solid) annotation (Line(points={{106,64},
          {112,64},{112,132},{-12,132},{-12,130}}, color={191,0,0}));
  if not AExt > 0 and not AWin > 0 and not AInt > 0 and not AFloor > 0 and ARoof > 0 then
    connect(thermSplitterIntGains.signalOutput[1], roofRC.port_a);
    connect(roofRC.port_a, thermSplitterSolRad.signalOutput[1]);
  elseif AExt > 0 and not AWin > 0 and not AInt > 0 and not AFloor > 0 and ARoof > 0
     or not AExt > 0 and AWin > 0 and not AInt > 0 and not AFloor > 0 and ARoof > 0
     or not AExt > 0 and not AWin > 0 and AInt > 0 and not AFloor > 0 and ARoof > 0
     or not AExt > 0 and not AWin > 0 and not AInt > 0 and AFloor > 0 and ARoof > 0 then
    connect(thermSplitterIntGains.signalOutput[2], roofRC.port_a);
    connect(roofRC.port_a, thermSplitterSolRad.signalOutput[2]);
  elseif AExt > 0 and AWin > 0 and not AInt > 0 and not AFloor > 0 and ARoof > 0
     or AExt > 0 and not AWin > 0 and AInt > 0 and not AFloor > 0 and ARoof > 0
     or AExt > 0 and not AWin > 0 and not AInt > 0 and AFloor > 0 and ARoof > 0
     or not AExt > 0 and AWin > 0 and AInt > 0 and not AFloor > 0 and ARoof > 0
     or not AExt > 0 and AWin > 0 and not AInt > 0 and AFloor > 0 and ARoof > 0
     or not AExt > 0 and not AWin > 0 and AInt > 0 and AFloor > 0 and ARoof > 0 then
    connect(thermSplitterIntGains.signalOutput[3], roofRC.port_a);
    connect(roofRC.port_a, thermSplitterSolRad.signalOutput[3]);
  elseif not AExt > 0 and AWin > 0 and AInt > 0 and AFloor > 0 and ARoof > 0
     or AExt > 0 and not AWin > 0 and AInt > 0 and AFloor > 0 and ARoof > 0
     or AExt > 0 and AWin > 0 and not AInt > 0 and AFloor > 0 and ARoof > 0
     or AExt > 0 and AWin > 0 and AInt > 0 and not AFloor > 0 and ARoof > 0 then
    connect(thermSplitterIntGains.signalOutput[4], roofRC.port_a);
    connect(roofRC.port_a, thermSplitterSolRad.signalOutput[4]);
  elseif AExt > 0 and AWin > 0 and AInt > 0 and AFloor > 0 and ARoof > 0 then
    connect(thermSplitterSolRad.signalOutput[5], roofRC.port_b) annotation (Line(
      points={{-136,146},{-88,146},{-38,146},{-38,142},{-12,142},{-12,144.8}},
      color={191,0,0}));
    connect(thermSplitterIntGains.signalOutput[5], roofRC.port_b) annotation (Line(
      points={{190,88},{190,88},{190,138},{-12,138},{-12,144.8}},
      color={191,0,0}));
  end if;
  connect(alphaRoofConst.y, convRoof.Gc) annotation (Line(points={{16.5,120},{
          7.25,120},{-2,120}}, color={0,0,127}));
  connect(radRoofStar.port_b, TRadStar.port) annotation (Line(points={{86,64},{
          44,64},{44,46},{16,46},{16,60}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -180},{240,180}}), graphics={
        Rectangle(
          extent={{-36,170},{46,104}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{16,168},{46,156}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Roof")}),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-240,-180},{240,
            180}}), graphics={Rectangle(
          extent={{-38,42},{28,-44}},
          pattern=LinePattern.None,
          fillColor={230,230,230},
          fillPattern=FillPattern.Solid), Text(
          extent={{-64,60},{60,-64}},
          lineColor={0,0,0},
          textString="4")}),
    Documentation(revisions="<html>
<ul>
<li>
September 11, 2015 by Moritz Lauster:<br/>
First Implementation.
</li>
</ul>
</html>"));
end ThermalZoneFourElements;
