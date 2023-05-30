within IBPSA.Fluid.Geothermal.Aquifer.Examples;
model CoolingOffice
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.HeatFlowRate Qcoo=30000 "Cooling power";
  parameter Modelica.Units.SI.TemperatureDifference deltaT=4 "Temperature difference at heat exchanger";
  parameter Modelica.Units.SI.SpecificHeatCapacity cpWat=4186 "Heat capacity of water";
  parameter Modelica.Units.SI.MassFlowRate mWat=Qcoo/(deltaT*cpWat) "Nominal water mass flow rate";

  SingleWell cooWel(
    redeclare package Medium = IBPSA.Media.Water,
    nVol=80,
    h=20,
    r_max=500,
    T_ini=285.15,
    TGro=283.15,
    aquDat=IBPSA.Fluid.Geothermal.Aquifer.Data.Rock(),
    m_flow_nominal=mWat,
    dp_nominal(displayUnit="Pa") = 10) "Cold well"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  SingleWell heaWel(
    redeclare package Medium = IBPSA.Media.Water,
    nVol=80,
    h=20,
    r_max=500,
    T_ini=285.15,
    TGro=283.15,
    aquDat=IBPSA.Fluid.Geothermal.Aquifer.Data.Rock(),
    m_flow_nominal=mWat,
    dp_nominal(displayUnit="Pa") = 10) "Warm well"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Movers.FlowControlled_m_flow mov(
    redeclare package Medium = IBPSA.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=mWat,
    dp_nominal=10) "Circulation pump"
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
  HeatExchangers.HeaterCooler_u hea(
    redeclare package Medium = IBPSA.Media.Water,
    m_flow_nominal=mWat,
    dp_nominal=10,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=Qcoo) "Heat exchanger"
    annotation (Placement(transformation(extent={{30,10},{50,30}})));
  Modelica.Blocks.Sources.Constant watMas(k=mWat) "Water mass flow rate"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Constant heaFlo(k=1) "Cooling load"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
equation
  connect(cooWel.port_a, mov.port_a)
    annotation (Line(points={{-70,-20},{-70,20},{-50,20}}, color={0,127,255}));
  connect(watMas.y, mov.m_flow_in)
    annotation (Line(points={{-59,70},{-40,70},{-40,32}}, color={0,0,127}));
  connect(heaFlo.y, hea.u) annotation (Line(points={{1,70},{20,70},{20,26},{28,26}},
        color={0,0,127}));
  connect(mov.port_b, hea.port_a)
    annotation (Line(points={{-30,20},{30,20}}, color={0,127,255}));
  connect(hea.port_b, heaWel.port_a)
    annotation (Line(points={{50,20},{70,20},{70,-20}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=7776000,Tolerance=1e-6),
    __Dymola_Commands(file=
  "modelica://IBPSA/Resources/Scripts/Dymola/Fluid/Geothermal/Aquifer/Examples/CoolingOffice.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example shows the application of the model
<a href=\"modelica://IBPSA.Fluid.Geothermal.Aquifer.SingleWell\">IBPSA.Fluid.Geothermal.Aquifer.SingleWell</a>.
</p>
<p>
The system consists of two wells, a warm well and a cold well. Water is extracted from the cold well at 12C and 
after passing through a heat exchanger it is injected in the warm well at 16C. This may represent the operation of an
aquifer thermal energy storage system that cools an office building with a constant load of 30 kW.
</p>

</html>", revisions="<html>
<ul>
<li>
May 2023, by Alessandro Maccarini:<br/>
First Implementation.
</li>
</ul>
</html>"));
end CoolingOffice;
