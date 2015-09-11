within Annex60.Experimental.ThermalZones;
model ThermalZoneThreeElements
  "Thermal Zone with three elements for thermal masses (two times external and one internal) with variable order"
    extends ThermalZoneTwoElements(ASum=AExtInd+AWinInd+AInt+AGroundInd,
                             thermSplitterIntGains(splitFactor=if not AExtInd > 0 and AWinInd > 0 and not AInt > 0 and not AGroundInd > 0 then {AWinInd/(AExtInd + AWinInd + AInt + AGroundInd)} else if not AWinInd > 0 and AExtInd > 0 and not AInt > 0 and not AGroundInd > 0 then {AExtInd/(AExtInd + AWinInd + AInt + AGroundInd)} else if not AWinInd > 0 and not AExtInd > 0 and AInt > 0 and not AGroundInd > 0 then {AInt/(AExtInd + AWinInd + AInt + AGroundInd)} else if not AExtInd > 0 and not AWinInd > 0 and not AInt > 0 and AGroundInd > 0 then {AGroundInd/(AExtInd + AWinInd + AInt + AGroundInd)} else if not AExtInd > 0 and AWinInd > 0 and AInt > 0 and not AGroundInd > 0 then {
  AWinInd/(AExtInd + AWinInd + AInt + AGroundInd),AInt/(AExtInd + AWinInd + AInt + AGroundInd)} else if AExtInd > 0 and not AWinInd > 0 and AInt > 0 and not AGroundInd > 0 then {
  AExtInd/(AExtInd + AWinInd + AInt + AGroundInd),AInt/(AExtInd + AWinInd + AInt + AGroundInd)} else if AExtInd > 0 and AWinInd > 0 and not AInt > 0 and not AGroundInd > 0 then {
  AExtInd/(AExtInd + AWinInd + AInt + AGroundInd),AWinInd/(AExtInd + AWinInd + AInt + AGroundInd)} else if not AExtInd > 0 and AWinInd > 0 and not AInt > 0 and AGroundInd > 0 then {
  AWinInd/(AExtInd + AWinInd + AInt + AGroundInd),AGroundInd/(AExtInd + AWinInd + AInt + AGroundInd)} else if AExtInd > 0 and not AWinInd > 0 and not AInt > 0 and AGroundInd > 0 then {
  AExtInd/(AExtInd + AWinInd + AInt + AGroundInd),AGroundInd/(AExtInd + AWinInd + AInt + AGroundInd)} else if not AExtInd > 0 and not AWinInd > 0 and AInt > 0 and AGroundInd > 0 then {
  AInt/(AExtInd + AWinInd + AInt + AGroundInd),AGroundInd/(AExtInd + AWinInd + AInt + AGroundInd)} else if not AExtInd > 0 and AWinInd > 0 and AInt > 0 and AGroundInd > 0 then {
  AWinInd/(AExtInd + AWinInd + AInt + AGroundInd),AInt/(AExtInd + AWinInd + AInt + AGroundInd),AGroundInd/(AExtInd + AWinInd + AInt + AGroundInd)} else if AExtInd > 0 and not AWinInd > 0 and AInt > 0 and AGroundInd > 0 then {
  AExtInd/(AExtInd + AWinInd + AInt + AGroundInd),AInt/(AExtInd + AWinInd + AInt + AGroundInd),AGroundInd/(AExtInd + AWinInd + AInt + AGroundInd)} else if AExtInd > 0 and AWinInd > 0 and not AInt > 0 and AGroundInd > 0 then {
  AExtInd/(AExtInd + AWinInd + AInt + AGroundInd),AWinInd/(AExtInd + AWinInd + AInt + AGroundInd),AGroundInd/(AExtInd + AWinInd + AInt + AGroundInd)} else if AExtInd > 0 and AWinInd > 0 and AInt > 0 and not AGroundInd > 0 then {
  AExtInd/(AExtInd + AWinInd + AInt + AGroundInd),AWinInd/(AExtInd + AWinInd + AInt + AGroundInd),AInt/(AExtInd + AWinInd + AInt + AGroundInd)} else {
  AExtInd/(AExtInd + AWinInd + AInt + AGroundInd),AWinInd/(AExtInd + AWinInd + AInt + AGroundInd),AInt/(AExtInd + AWinInd + AInt + AGroundInd),AGroundInd/(AExtInd + AWinInd + AInt + AGroundInd)}, dimension=if not AExtInd > 0 and not AWinInd > 0 and not AInt > 0 and not AGroundInd > 0 then 0 else if not AExtInd > 0 and AWinInd > 0 and not AInt > 0 and not AGroundInd > 0 then 1 else if not AWinInd > 0 and AExtInd > 0 and not AInt > 0 and not AGroundInd > 0 then 1 else if not AExtInd > 0 and not AWinInd > 0 and AInt > 0 and not AGroundInd > 0 then 1 else if not AExtInd > 0 and not AWinInd > 0 and not AInt > 0 and AGroundInd > 0 then 1 else if AExtInd > 0 and AWinInd > 0 and not AInt > 0 and not AGroundInd > 0 then 2 else if not AExtInd > 0 and AWinInd > 0 and AInt > 0 and not AGroundInd > 0 then 2 else if AExtInd > 0 and not AWinInd > 0 and AInt > 0 and not AGroundInd > 0 then 2 else if not AExtInd > 0 and not AWinInd > 0 and AInt > 0 and AGroundInd > 0 then 2 else if not AExtInd > 0 and AWinInd > 0 and not AInt > 0 and AGroundInd > 0 then 2 else if AExtInd > 0 and not AWinInd > 0 and not AInt > 0 and AGroundInd > 0 then 2 else if not AExtInd > 0 and AWinInd > 0 and AInt > 0 and AGroundInd > 0 then 3 else if AExtInd > 0 and not AWinInd > 0 and AInt > 0 and AGroundInd > 0 then 3 else if AExtInd > 0 and AWinInd > 0 and not AInt > 0 and AGroundInd > 0 then 3 else if AExtInd > 0 and AWinInd > 0 and AInt > 0 and not AGroundInd > 0 then 3 else 4),
      thermSplitterSolRad(splitFactor=if not AExtInd > 0 and AWinInd > 0 and not AInt > 0 and not AGroundInd > 0 then {AWinInd/(AExtInd + AWinInd + AInt + AGroundInd)} else if not AWinInd > 0 and AExtInd > 0 and not AInt > 0 and not AGroundInd > 0 then {AExtInd/(AExtInd + AWinInd + AInt + AGroundInd)} else if not AWinInd > 0 and not AExtInd > 0 and AInt > 0 and not AGroundInd > 0 then {AInt/(AExtInd + AWinInd + AInt + AGroundInd)} else if not AExtInd > 0 and not AWinInd > 0 and not AInt > 0 and AGroundInd > 0 then {AGroundInd/(AExtInd + AWinInd + AInt + AGroundInd)} else if not AExtInd > 0 and AWinInd > 0 and AInt > 0 and not AGroundInd > 0 then {
  AWinInd/(AExtInd + AWinInd + AInt + AGroundInd),AInt/(AExtInd + AWinInd + AInt + AGroundInd)} else if AExtInd > 0 and not AWinInd > 0 and AInt > 0 and not AGroundInd > 0 then {
  AExtInd/(AExtInd + AWinInd + AInt + AGroundInd),AInt/(AExtInd + AWinInd + AInt + AGroundInd)} else if AExtInd > 0 and AWinInd > 0 and not AInt > 0 and not AGroundInd > 0 then {
  AExtInd/(AExtInd + AWinInd + AInt + AGroundInd),AWinInd/(AExtInd + AWinInd + AInt + AGroundInd)} else if not AExtInd > 0 and AWinInd > 0 and not AInt > 0 and AGroundInd > 0 then {
  AWinInd/(AExtInd + AWinInd + AInt + AGroundInd),AGroundInd/(AExtInd + AWinInd + AInt + AGroundInd)} else if AExtInd > 0 and not AWinInd > 0 and not AInt > 0 and AGroundInd > 0 then {
  AExtInd/(AExtInd + AWinInd + AInt + AGroundInd),AGroundInd/(AExtInd + AWinInd + AInt + AGroundInd)} else if not AExtInd > 0 and not AWinInd > 0 and AInt > 0 and AGroundInd > 0 then {
  AInt/(AExtInd + AWinInd + AInt + AGroundInd),AGroundInd/(AExtInd + AWinInd + AInt + AGroundInd)} else if not AExtInd > 0 and AWinInd > 0 and AInt > 0 and AGroundInd > 0 then {
  AWinInd/(AExtInd + AWinInd + AInt + AGroundInd),AInt/(AExtInd + AWinInd + AInt + AGroundInd),AGroundInd/(AExtInd + AWinInd + AInt + AGroundInd)} else if AExtInd > 0 and not AWinInd > 0 and AInt > 0 and AGroundInd > 0 then {
  AExtInd/(AExtInd + AWinInd + AInt + AGroundInd),AInt/(AExtInd + AWinInd + AInt + AGroundInd),AGroundInd/(AExtInd + AWinInd + AInt + AGroundInd)} else if AExtInd > 0 and AWinInd > 0 and not AInt > 0 and AGroundInd > 0 then {
  AExtInd/(AExtInd + AWinInd + AInt + AGroundInd),AWinInd/(AExtInd + AWinInd + AInt + AGroundInd),AGroundInd/(AExtInd + AWinInd + AInt + AGroundInd)} else if AExtInd > 0 and AWinInd > 0 and AInt > 0 and not AGroundInd > 0 then {
  AExtInd/(AExtInd + AWinInd + AInt + AGroundInd),AWinInd/(AExtInd + AWinInd + AInt + AGroundInd),AInt/(AExtInd + AWinInd + AInt + AGroundInd)} else {
  AExtInd/(AExtInd + AWinInd + AInt + AGroundInd),AWinInd/(AExtInd + AWinInd + AInt + AGroundInd),AInt/(AExtInd + AWinInd + AInt + AGroundInd),AGroundInd/(AExtInd + AWinInd + AInt + AGroundInd)}, dimension=if not AExtInd > 0 and not AWinInd > 0 and not AInt > 0 and not AGroundInd > 0 then 0 else if not AExtInd > 0 and AWinInd > 0 and not AInt > 0 and not AGroundInd > 0 then 1 else if not AWinInd > 0 and AExtInd > 0 and not AInt > 0 and not AGroundInd > 0 then 1 else if not AExtInd > 0 and not AWinInd > 0 and AInt > 0 and not AGroundInd > 0 then 1 else if not AExtInd > 0 and not AWinInd > 0 and not AInt > 0 and AGroundInd > 0 then 1 else if AExtInd > 0 and AWinInd > 0 and not AInt > 0 and not AGroundInd > 0 then 2 else if not AExtInd > 0 and AWinInd > 0 and AInt > 0 and not AGroundInd > 0 then 2 else if AExtInd > 0 and not AWinInd > 0 and AInt > 0 and not AGroundInd > 0 then 2 else if not AExtInd > 0 and not AWinInd > 0 and AInt > 0 and AGroundInd > 0 then 2 else if not AExtInd > 0 and AWinInd > 0 and not AInt > 0 and AGroundInd > 0 then 2 else if AExtInd > 0 and not AWinInd > 0 and not AInt > 0 and AGroundInd > 0 then 2 else if not AExtInd > 0 and AWinInd > 0 and AInt > 0 and AGroundInd > 0 then 3 else if AExtInd > 0 and not AWinInd > 0 and AInt > 0 and AGroundInd > 0 then 3 else if AExtInd > 0 and AWinInd > 0 and not AInt > 0 and AGroundInd > 0 then 3 else if AExtInd > 0 and AWinInd > 0 and AInt > 0 and not AGroundInd > 0 then 3 else 4));
  parameter Modelica.SIunits.Area AGroundInd = 0.1
    "Indoor surface area of ground thermal mass" annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaGroundInd
    "Coefficient of heat transfer for surface of ground thermal mass" annotation(Dialog(group="Thermal mass"));
  parameter Integer nGround(min = 1) "Number of RC-elements for thermal mass" annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.ThermalResistance RGround[nExt]
    "Vector of resistances for each RC-element fpr ground, from inside to outside"
                                                                                   annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.ThermalResistance RGroundRem
    "Resistance of remaining resistor RGroundRem between capacitance n and outside"
                                                                                    annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.HeatCapacity CGround[nExt]
    "Vector of heat capacity of ground thermal masses for each RC-element, from inside to outside"
                                                                                                   annotation(Dialog(group="Thermal mass"));
  BaseClasses.ExtMassVarRC groundMassVarRC(
    n=nGround,
    RExt=RGround,
    RExtRem=RGroundRem,
    CExt=CGround) if AGroundInd > 0   annotation (Placement(transformation(
        extent={{10,-11},{-10,11}},
        rotation=90,
        origin={-12,-152})));
  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor heatConGround if AGroundInd > 0
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-12,-116})));
  Modelica.Blocks.Sources.Constant alphaGround(k=1/(AGroundInd*alphaGroundInd)) if AGroundInd > 0
    annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={22,-116})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermalResRadExtGround(R=1/(min(
        AExtInd, AGroundInd)*alphaRad)) if AExtInd > 0 and AGroundInd > 0
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-144,-111})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermalResRadIntGround(R=1/(min(
        AGroundInd, AInt)*alphaRad)) if AInt > 0 and AGroundInd > 0
                           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={204,-104})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a portGroundAmb if AGroundInd > 0 annotation (
     Placement(transformation(extent={{-22,-184},{-2,-164}}),iconTransformation(
          extent={{-22,-184},{-2,-164}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermalResRadWinGround(R=1/(min(
        AWinInd, AGroundInd)*alphaRad)) if AWinInd > 0 and AGroundInd > 0 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-82,-112})));
equation
  connect(groundMassVarRC.port_a, heatConGround.solid) annotation (Line(
      points={{-12,-143.6},{-12,-126}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatConGround.fluid, volAir.heatPort) annotation (Line(
      points={{-12,-106},{-12,-36},{64,-36},{64,0},{38,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(alphaGround.y, heatConGround.Rc) annotation (Line(
      points={{16.5,-116},{-2,-116}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(groundMassVarRC.port_a, thermalResRadExtGround.port_b) annotation (
      Line(
      points={{-12,-143.6},{-12,-132},{-144,-132},{-144,-121}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(groundMassVarRC.port_a, thermalResRadIntGround.port_b) annotation (
      Line(
      points={{-12,-143.6},{-12,-132},{224,-132},{224,-104},{214,-104}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(groundMassVarRC.port_b, portGroundAmb) annotation (Line(
      points={{-12,-162.2},{-12,-174}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalResRadWinGround.port_a, heatConWin.solid) annotation (Line(
      points={{-82,-102},{-82,20},{-146,20},{-146,38},{-116,38}},
      color={191,0,0},
      smooth=Smooth.None));
  if not AExtInd > 0 and not AWinInd > 0 and not AInt > 0 and AGroundInd > 0 then
    connect(thermSplitterIntGains.signalOutput[1], groundMassVarRC.port_a);
    connect(groundMassVarRC.port_a, thermSplitterSolRad.signalOutput[1]);
  elseif AExtInd > 0 and not AWinInd > 0 and not AInt > 0 and AGroundInd > 0 or not AExtInd > 0 and AWinInd > 0 and not AInt > 0 and AGroundInd > 0 or not AExtInd > 0 and not AWinInd > 0 and AInt > 0 and AGroundInd > 0 then
    connect(thermSplitterIntGains.signalOutput[2], groundMassVarRC.port_a);
    connect(groundMassVarRC.port_a, thermSplitterSolRad.signalOutput[2]);
  elseif not AExtInd > 0 and AWinInd > 0 and AInt > 0 and AGroundInd > 0 or AExtInd > 0 and not AWinInd > 0 and AInt > 0 and AGroundInd > 0 or AExtInd > 0 and AWinInd > 0 and not AInt > 0 and AGroundInd > 0 then
    connect(thermSplitterIntGains.signalOutput[3], groundMassVarRC.port_a);
    connect(groundMassVarRC.port_a, thermSplitterSolRad.signalOutput[3]);
  elseif AExtInd > 0 and AWinInd > 0 and AInt > 0 and AGroundInd > 0 then
    connect(thermSplitterIntGains.signalOutput[4], groundMassVarRC.port_a)
      annotation (Line(
        points={{190,88},{190,80},{-38,80},{-38,-136},{-12,-136},{-12,-143.6}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(groundMassVarRC.port_a, thermSplitterSolRad.signalOutput[4])
      annotation (Line(
        points={{-12,-143.6},{-12,-140},{-42,-140},{-42,146},{-136,146}},
        color={191,0,0},
        smooth=Smooth.None));
  end if;
  connect(intMassVarRC.port_a, thermalResRadIntGround.port_a) annotation (Line(
        points={{182.8,-38},{176,-38},{176,-38},{168,-38},{168,-86},{184,-86},{
          184,-104},{194,-104}}, color={191,0,0}));
  connect(thermalResRadWinGround.port_b, thermalResRadExtGround.port_b)
    annotation (Line(points={{-82,-122},{-80,-122},{-80,-132},{-144,-132},{-144,
          -121}}, color={191,0,0}));
  connect(thermalResRadExtGround.port_a, heatConExt.solid) annotation (Line(
        points={{-144,-101},{-144,-36},{-114,-36}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(extent={{-240,-180},{240,180}},
          preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-32,-100},{50,-166}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{1,-150},{48,-166}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Ground Plate")}),          Icon(coordinateSystem(extent={{-240,
            -180},{240,180}}, preserveAspectRatio=false), graphics),
    Documentation(revisions="<html>
<ul>
<li>
July 15, 2015 by Moritz Lauster:<br/>
First Implementation.
</li>
</ul>
</html>"));
end ThermalZoneThreeElements;
