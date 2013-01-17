within IDEAS.Buildings.Components.BaseClasses;
model MixedAir "Mixed air capacity of the thermal zone"

  parameter Integer nSurf(min=1) "number of surfaces in contact with the zone";
  parameter Modelica.SIunits.Volume V "air volume of the zone";
  parameter Real corrCV=5 "correction factor on the zone air capacity";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conGain
    "convective internal gains"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b[nSurf] conSurf
    "convective gains on surfaces"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealOutput TCon "convective zone temperature"
    annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,-100})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TiSensor annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-30})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCap(C=1012*1.204*V
        *corrCV, T(start=293.15)) "air capacity"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
equation
  for i in 1:nSurf loop
    connect(heatCap.port, conSurf[i]) annotation (Line(
        points={{0,0},{100,0}},
        color={191,0,0},
        pattern=LinePattern.None,
        smooth=Smooth.None));
  end for;
  connect(conGain, heatCap.port) annotation (Line(
      points={{-100,0},{0,0}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));

  connect(heatCap.port, TiSensor.port) annotation (Line(
      points={{0,0},{0,2},{1.98721e-022,2},{1.98721e-022,-20},{1.83697e-015,-20}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));

  connect(TiSensor.T, TCon) annotation (Line(
      points={{-1.83697e-015,-40},{0,-40},{0,-100}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    Icon(graphics={
        Polygon(
          points={{0,83},{-20,79},{-40,73},{-52,59},{-58,51},{-68,41},{-72,29},
              {-76,15},{-78,1},{-76,-15},{-76,-27},{-76,-37},{-70,-49},{-64,-57},
              {-48,-61},{-30,-67},{-18,-67},{-2,-69},{8,-73},{22,-73},{32,-71},
              {42,-65},{54,-59},{56,-57},{66,-45},{68,-37},{70,-35},{72,-19},{
              76,-5},{78,3},{78,19},{74,31},{66,41},{54,49},{44,57},{36,73},{26,
              81},{0,83}},
          lineColor={160,160,164},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-58,51},{-68,41},{-72,29},{-76,15},{-78,1},{-76,-15},{-76,-27},
              {-76,-37},{-70,-49},{-64,-57},{-48,-61},{-30,-67},{-18,-67},{-2,-69},
              {8,-73},{22,-73},{32,-71},{42,-65},{54,-59},{42,-61},{40,-61},{30,
              -63},{20,-65},{18,-65},{10,-65},{2,-61},{-12,-57},{-22,-57},{-30,
              -55},{-40,-49},{-50,-39},{-56,-27},{-58,-19},{-58,-9},{-60,3},{-60,
              11},{-60,23},{-58,33},{-56,35},{-52,43},{-48,51},{-44,61},{-40,73},
              {-58,51}},
          lineColor={0,0,0},
          fillColor={160,160,164},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-6,15},{6,4}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Text(
          extent={{11,29},{50,-9}},
          lineColor={0,0,0},
          textString="T"),
        Line(points={{0,4},{0,-80}}, color={0,0,127})}),
    Documentation(info="<html>
<p>The air within the zone is modeled based on the assumption that it is well-stirred, i.e. it is characterized by a single uniform air temperature. This is practically accomplished with the mixing caused by the air distribution system. The convective gains and the resulting change in air temperature <img src=\"modelica://IDEAS/Images/equations/equation-ps2Eq199.png\"/> of a single thermal zone can be modeled as a thermal circuit. The resulting heat balance for the air node can be described as</p>
<p align=\"center\"><img src=\"modelica://IDEAS/Images/equations/equation-5E7Q41vV.png\"/></p>
<p>wherefore <img src=\"modelica://IDEAS/Images/equations/equation-jiSQ22c0.png\"/> is the specific air enthalpy and where <img src=\"modelica://IDEAS/Images/equations/equation-WIlQpAg5.png\"/> is the air temperature of the zone, <img src=\"modelica://IDEAS/Images/equations/equation-h7Dz77UJ.png\"/> is the specific heat capacity of air at constant pressure, <img src=\"modelica://IDEAS/Images/equations/equation-x4LHc8Qp.png\"/> is the zone air volume, <img src=\"modelica://IDEAS/Images/equations/equation-7maZgvq7.png\"/> is a convective internal load, <img src=\"modelica://IDEAS/Images/equations/equation-NZR0rJFG.png\"/> is the convective surface resistance of surface <img src=\"modelica://IDEAS/Images/equations/equation-bvc5hZ2Y.png\"/>,<img src=\"modelica://IDEAS/Images/equations/equation-ujUu9oii.png\"/> is the area of surface<img src=\"modelica://IDEAS/Images/equations/equation-PRmDSqgy.png\"/>, <img src=\"modelica://IDEAS/Images/equations/equation-LwXKbxRC.png\"/> the surface temperature of surface <img src=\"modelica://IDEAS/Images/equations/equation-cTp9P38I.png\"/>, <img src=\"modelica://IDEAS/Images/equations/equation-94Yf3BLu.png\"/> is the mass flow rate between zones, <img src=\"modelica://IDEAS/Images/equations/equation-Cwfjkj5R.png\"/> is the mass flow rate between the exterior by natural infiltration,<img src=\"modelica://IDEAS/Images/equations/equation-ZgcYnSGu.png\"/> is the mass flow rate provided by the ventilation system, <img src=\"modelica://IDEAS/Images/equations/equation-pCXdHoAS.png\"/> is the air temperature in degrees Celsius, <img src=\"modelica://IDEAS/Images/equations/equation-QSo9JTGT.png\"/> is the air humidity ratio, <img src=\"modelica://IDEAS/Images/equations/equation-zntTkmwk.png\"/> is specific heat of water vapor at constant pressure and <img src=\"modelica://IDEAS/Images/equations/equation-ZjHIP8wZ.png\"/> is evaporation heat of water at 0 degrees Celsius. </p>
<p>Infiltration and ventilation systems provide air to the zones, undesirably or to meet heating or cooling loads. The thermal energy provided to the zone by this air change rate can be formulated from the difference between the supply air enthalpy and the enthalpy of the air leaving the zone <img src=\"modelica://IDEAS/Images/equations/equation-jiSQ22c0.png\"/>. It is assumed that the zone supply air mass flow rate is exactly equal to the sum of the air flow rates leaving the zone, and all air streams exit the zone at the zone mean air temperature. The moisture dependence of the air enthalpy is neglected.</p>
<p>A multiplier for the zone capacitance <img src=\"modelica://IDEAS/Images/equations/equation-BsmTOKms.png\"/> is included. A <img src=\"modelica://IDEAS/Images/equations/equation-BsmTOKms.png\"/> equaling unity represents just the capacitance of the air volume in the specified zone. This multiplier can be greater than unity if the zone air capacitance needs to be increased for stability of the simulation. This multiplier increases the capacitance of the air volume by increasing the zone volume and can be done for numerical reasons or to account for the additional capacitances in the zone to see the effect on the dynamics of the simulation. This multiplier is constant throughout the simulation and is set to 5.0 if the value is not defined <a href=\"IDEAS.Buildings.UsersGuide.References\">[Masy 2008]</a>.</p>
</html>"));
end MixedAir;
