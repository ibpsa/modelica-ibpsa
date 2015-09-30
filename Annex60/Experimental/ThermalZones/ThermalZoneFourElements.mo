within Annex60.Experimental.ThermalZones;
model ThermalZoneFourElements
  "Thermal Zone with four elements for exterior walls, interior walls, floor plate and roof"
  extends ThermalZoneThreeElements(AArray = {AExt, AWin, AInt, AFloor, ARoof});
  parameter Modelica.SIunits.Area ARoof = 0.1 "Area of roof" annotation(Dialog(group="Roof"));
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
    n=nRoof) if      ARoof > 0 annotation (Placement(transformation(
        extent={{10,-11},{-10,11}},
        rotation=90,
        origin={-12,155})));
  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor convRoof if      ARoof > 0
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-12,120})));
  Modelica.Blocks.Sources.Constant alphaRoofConst(k=1/(ARoof*alphaRoof)) if        ARoof > 0
    annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={22,120})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a roof if        ARoof > 0
    "ambient port for roof" annotation (Placement(transformation(extent={{-22,
            160},{-2,180}}), iconTransformation(extent={{-22,160},{-2,180}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor resIntRoof(R=1/(min(
        AInt, ARoof)*alphaRad)) if   AInt > 0 and ARoof > 0
    "resistor between interior walls and roof" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={186,10})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor resRoofWin(R=1/(min(
        ARoof, AWin)*alphaRad)) if   ARoof > 0 and AWin > 0
    "resistor between roof and windows" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-154,100})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor resRoofFloor(R=1/(min(
        ARoof, AFloor)*alphaRad)) if   ARoof > 0 and AFloor > 0
    "resistor between floor plate and roof" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-56,-112})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor resExtWallRoof(R=1/(min(
        AExt, ARoof)*alphaRad)) if   AExt > 0 and ARoof > 0
    "resistor between exterior walls and roof" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-108,6})));
equation
  connect(convRoof.Rc, alphaRoofConst.y)
    annotation (Line(points={{-2,120},{8,120},{16.5,120}}, color={0,0,127}));
  connect(convRoof.solid, roofRC.port_b)
    annotation (Line(points={{-12,130},{-12,144.8}}, color={191,0,0}));
  connect(roofRC.port_a, roof)
    annotation (Line(points={{-12,163.4},{-12,170}}, color={191,0,0}));
  connect(convRoof.fluid, volAir.heatPort) annotation (Line(points={{-12,110},{
          -12,94},{64,94},{64,0},{38,0}}, color={191,0,0}));

  connect(resRoofWin.port_a, convWin.solid) annotation (Line(points={{-164,
          100},{-174,100},{-174,82},{-146,82},{-146,38},{-116,38}}, color={191,
          0,0}));
  connect(resRoofWin.port_b, convRoof.solid) annotation (Line(points={{-144,100},
          {-114,100},{-82,100},{-82,132},{-12,132},{-12,130}}, color={191,0,0}));
  connect(resRoofFloor.port_a, convRoof.solid) annotation (Line(points={{-56,-102},
          {-54,-102},{-54,132},{-12,132},{-12,130}}, color={191,0,0}));
  connect(resRoofFloor.port_b, resExtWallFloor.port_b) annotation (Line(
        points={{-56,-122},{-56,-132},{-144,-132},{-144,-121}}, color={191,0,0}));
  connect(resIntRoof.port_b, intWallRC.port_a) annotation (Line(points={{186,
          0},{186,-10},{168,-10},{168,-38},{182.8,-38}}, color={191,0,0}));
  connect(resIntRoof.port_a, convRoof.solid) annotation (Line(points={{186,20},
          {186,20},{186,132},{-12,132},{-12,130}}, color={191,0,0}));
  connect(resExtWallRoof.port_a, convExtWall.solid) annotation (Line(points={{-118,
          6},{-130,6},{-130,-12},{-144,-12},{-144,-36},{-114,-36}}, color={191,
          0,0}));
  connect(resExtWallRoof.port_b, convRoof.solid) annotation (Line(points={{-98,
          6},{-54,6},{-54,132},{-12,132},{-12,130}}, color={191,0,0}));
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
