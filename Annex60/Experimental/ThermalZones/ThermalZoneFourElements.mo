within Annex60.Experimental.ThermalZones;
model ThermalZoneFourElements
  extends ThermalZoneThreeElements;
  BaseClasses.ExtMassVarRC roofMassVarRC(
    RExt=RRoof,
    RExtRem=RRoofRem,
    CExt=CRoof,
    n=nRoof) if      AGroundInd > 0 annotation (Placement(transformation(
        extent={{10,-11},{-10,11}},
        rotation=90,
        origin={-12,155})));
  parameter Modelica.SIunits.Area ARoofInd = 0.1
    "Indoor surface area of ground thermal mass" annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaRoofInd
    "Coefficient of heat transfer for surface of ground thermal mass" annotation(Dialog(group="Thermal mass"));
  parameter Integer nRoof(min = 1) "Number of RC-elements for thermal mass" annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.ThermalResistance RRoof[nExt]
    "Vector of resistances for each RC-element fpr ground, from inside to outside"
                                                                                   annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.ThermalResistance RRoofRem
    "Resistance of remaining resistor RGroundRem between capacitance n and outside"
                                                                                    annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.HeatCapacity CRoof[nExt]
    "Vector of heat capacity of ground thermal masses for each RC-element, from inside to outside"
                                                                                                   annotation(Dialog(group="Thermal mass"));
  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor heatConRoof if   AGroundInd > 0
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-12,120})));
  Modelica.Blocks.Sources.Constant alphaRoof(k=1/(ARoofInd*alphaRoofInd)) if       AGroundInd > 0
    annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={22,120})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a portRoofAmb
    annotation (Placement(transformation(extent={{-22,160},{-2,180}}),
        iconTransformation(extent={{-22,160},{-2,180}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermalResRadIntRoof(R=1/(min(
        AInt, ARoofInd)*alphaRad)) if   AInt > 0 and AGroundInd > 0 annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={186,10})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermalResRadWinRoof(R=1/(min(
        ARoofInd, AWinInd)*alphaRad)) if
                                     AExtInd > 0 and AWinInd > 0
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-154,100})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermalResRadGroundRoof(R=1/(min(
        ARoofInd, AGroundInd)*alphaRad)) if
                                           AWinInd > 0 and AGroundInd > 0
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-56,-112})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermalResRadExtRoof(R=1/(min(
        AExtInd, ARoofInd)*alphaRad)) if
                                     AExtInd > 0 and AWinInd > 0
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-108,6})));
equation
  connect(heatConRoof.Rc, alphaRoof.y)
    annotation (Line(points={{-2,120},{8,120},{16.5,120}}, color={0,0,127}));
  connect(heatConRoof.solid, roofMassVarRC.port_b)
    annotation (Line(points={{-12,130},{-12,144.8}}, color={191,0,0}));
  connect(roofMassVarRC.port_a, portRoofAmb)
    annotation (Line(points={{-12,163.4},{-12,170}}, color={191,0,0}));
  connect(heatConRoof.fluid, volAir.heatPort) annotation (Line(points={{-12,110},
          {-12,94},{64,94},{64,0},{38,0}}, color={191,0,0}));
  connect(thermSplitterSolRad.signalOutput[5], roofMassVarRC.port_b)
    annotation (Line(points={{-136,146},{-88,146},{-38,146},{-38,142},{-12,142},
          {-12,144.8}}, color={191,0,0}));
  connect(thermSplitterIntGains.signalOutput[5], roofMassVarRC.port_b)
    annotation (Line(points={{190,88},{190,88},{190,138},{-12,138},{-12,144.8}},
        color={191,0,0}));
  connect(thermalResRadWinRoof.port_a, heatConWin.solid) annotation (Line(
        points={{-164,100},{-174,100},{-174,82},{-146,82},{-146,38},{-116,38}},
        color={191,0,0}));
  connect(thermalResRadWinRoof.port_b, heatConRoof.solid) annotation (Line(
        points={{-144,100},{-114,100},{-82,100},{-82,132},{-12,132},{-12,130}},
        color={191,0,0}));
  connect(thermalResRadGroundRoof.port_a, heatConRoof.solid) annotation (Line(
        points={{-56,-102},{-54,-102},{-54,132},{-12,132},{-12,130}}, color={191,
          0,0}));
  connect(thermalResRadGroundRoof.port_b, thermalResRadExtGround.port_b)
    annotation (Line(points={{-56,-122},{-56,-132},{-144,-132},{-144,-121}},
        color={191,0,0}));
  connect(thermalResRadIntRoof.port_b, intMassVarRC.port_a) annotation (Line(
        points={{186,0},{186,-10},{168,-10},{168,-38},{182.8,-38}}, color={191,0,
          0}));
  connect(thermalResRadIntRoof.port_a, heatConRoof.solid) annotation (Line(
        points={{186,20},{186,20},{186,132},{-12,132},{-12,130},{-12,130}},
        color={191,0,0}));
  connect(thermalResRadExtRoof.port_a, heatConExt.solid) annotation (Line(
        points={{-118,6},{-130,6},{-130,-12},{-144,-12},{-144,-36},{-114,-36}},
        color={191,0,0}));
  connect(thermalResRadExtRoof.port_b, heatConRoof.solid) annotation (Line(
        points={{-98,6},{-54,6},{-54,132},{-12,132},{-12,130}}, color={191,0,0}));
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
