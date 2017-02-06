within IDEAS.Fluid.Storage.Examples;
model StorageTank_DHW_HP
  "Example of a DHW system composed of HP and storage tank"
  import IDEAS;

  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    annotation (__Dymola_choicesAllMatching=true);

  parameter Integer nbrNodes=10 "Number of nodes in the storage tank";

  Fluid.Storage.StorageTank_OneIntHX storageTank(
    nbrNodes=nbrNodes,
    T_start={273.15 + 60 for i in 1:nbrNodes},
    volumeTank=0.3,
    heightTank=1.6,
    UIns=0.4,
    redeclare package MediumHX = Medium,
    redeclare package Medium = Medium,
    m_flow_nominal_HX=1)
    annotation (Placement(transformation(extent={{-30,-64},{42,10}})));

  IDEAS.Fluid.Taps.BalancedTap_m_flow dHW(TDHWSet=273.15 + 45,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{62,8},{82,20}})));
  IDEAS.Fluid.Production.HP_AirWater_TSet hP_AWMod(
    QNom=10000,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-88,-2},{-68,18}})));

  IDEAS.Fluid.Movers.FlowControlled_m_flow pump(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=30,
    filteredSpeed=false)
    annotation (Placement(transformation(extent={{-38,-62},{-58,-42}})));
  inner IDEAS.BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{-94,-94},{-74,-74}})));
  IDEAS.Controls.ControlHeating.Ctrl_Heating_TES HPControl(
    dTSafetyTop=3,
    dTHPTankSet=2,
    DHW=true,
    TSupNom=313.15,
    TDHWSet=323.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-82,60})));
  Modelica.Blocks.Sources.Pulse pulse(period=3600, width=10)
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Modelica.Blocks.Sources.SawTooth sawTooth(
    period=1000,
    startTime=30000,
    amplitude=0.15)
    annotation (Placement(transformation(extent={{-10,62},{10,82}})));
  IDEAS.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    p=300000,
    nPorts=2) annotation (Placement(transformation(extent={{86,-96},{66,-76}})));

  parameter SI.MassFlowRate m_flow_nominal=0.5 "Nominal mass flow rate";
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{36,48},{46,58}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=294.15)
    annotation (Placement(transformation(extent={{-44,70},{-64,90}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senStoHx_in(redeclare package Medium
      = Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-46,4},{-34,16}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senStoHx_out(redeclare package Medium
      = Medium, m_flow_nominal=m_flow_nominal) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-58,-22})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant
    annotation (Placement(transformation(extent={{170,14},{190,34}})));
  Modelica.Blocks.Math.Gain gain(k=m_flow_nominal) annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=270,
        origin={-48,-8})));
equation

  connect(storageTank.T[10], HPControl.TTankBot) annotation (Line(
      points={{42,-18.4615},{70,-18.4615},{70,-18},{92,-18},{92,96},{-86,96},{
          -86,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(storageTank.T[1], HPControl.TTankTop) annotation (Line(
      points={{42,-18.4615},{92,-18.4615},{92,96},{-82,96},{-82,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bou.ports[1], pump.port_a) annotation (Line(
      points={{66,-84},{-38,-84},{-38,-52}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(product.u2, pulse.y) annotation (Line(
      points={{35,50},{24,50},{24,40},{11,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product.u1, sawTooth.y) annotation (Line(
      points={{35,56},{24,56},{24,72},{11,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(storageTank.port_b, dHW.port_cold) annotation (Line(
      points={{42,-58.3077},{64,-58.3077},{64,-58},{82,-58},{82,14}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(storageTank.port_a, dHW.port_hot) annotation (Line(
      points={{42,4.30769},{42,14},{62,14}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump.port_a, storageTank.portHXLower) annotation (Line(
      points={{-38,-52},{-34,-52},{-34,-58.3077},{-30,-58.3077}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(storageTank.port_b, bou.ports[2]) annotation (Line(
      points={{42,-58.3077},{42,-88},{66,-88}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(HPControl.THeaCur, hP_AWMod.TSet) annotation (Line(
      points={{-78,50},{-78,33.2222},{-84,33.2222},{-84,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, HPControl.TRoo_in1) annotation (Line(
      points={{-65,80},{-78,80},{-78,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hP_AWMod.port_b, senStoHx_in.port_a) annotation (Line(
      points={{-68,14},{-52,14},{-52,10},{-46,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senStoHx_in.port_b, storageTank.portHXUpper) annotation (Line(
      points={{-34,10},{-30,10},{-30,-41.2308}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hP_AWMod.port_a, senStoHx_out.port_b) annotation (Line(
      points={{-68,2},{-66,2},{-66,4},{-58,4},{-58,-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senStoHx_out.port_a, pump.port_b) annotation (Line(
      points={{-58,-28},{-58,-52}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(product.y, dHW.mDHW60C)
    annotation (Line(points={{46.5,53},{74,53},{74,20}}, color={0,0,127}));
  connect(HPControl.onOff, gain.u) annotation (Line(points={{-84,52},{-84,36},{
          -47.8,36},{-48,-3.2}}, color={0,0,127}));
  connect(gain.y, pump.m_flow_in) annotation (Line(points={{-48,-12.4},{-48,
          -26.2},{-47.8,-26.2},{-47.8,-40}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(StopTime=86400),
    __Dymola_experimentSetupOutput,
    Documentation(revisions="<html>
<ul>
<li>March 2014 by Filip Jorissen:<br/> 
Annex60 compatibility
</li>
</ul>
</html>"));
end StorageTank_DHW_HP;
