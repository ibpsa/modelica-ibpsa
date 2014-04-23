within IDEAS.Fluid.Valves.Examples;
model HydraulicCircuitInsulated2
  import IDEAS;
  extends Modelica.Icons.Example;
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    annotation (__Dymola_choicesAllMatching=true);

protected
  IDEAS.Fluid.Movers.Pump pumpFlow1(
    useInput=true,
    dpFix=0,
    m_flow_nominal=1,
    redeclare package Medium = Medium,
    m=1,
    dynamicBalance=true)
             annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-72,0})));
public
  Modelica.Blocks.Sources.Constant flow_pump(k=1)
        annotation (Placement(transformation(extent={{-98,24},{-78,44}})));
  Modelica.Blocks.Sources.Sine     ctrl(freqHz=0.1,
    amplitude=0.5,
    offset=0.5,
    phase=4.7123889803847)
        annotation (Placement(transformation(extent={{-36,28},{-16,48}})));
  IDEAS.Fluid.Valves.ThreeWayValveMotor threeWayValveMotor(m_flow_nominal=1,
      redeclare package Medium = Medium,
    m=0.1)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}})));
  inner Modelica.Fluid.System system(
    p_ambient=300000,
    T_ambient=313.15)
    annotation (Placement(transformation(extent={{158,20},{178,40}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort temperature(redeclare package
      Medium = Medium, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{-24,-10},{-44,10}})));
  Modelica.Blocks.Sources.Sine sine1(
    amplitude=10,
    offset=293.15,
    startTime=0,
    freqHz=0.1)
    annotation (Placement(transformation(extent={{-152,24},{-132,44}})));
  IDEAS.Fluid.Valves.ThreeWayValveMotor threeWayValveMotor1(
                                                           m_flow_nominal=1,
      redeclare package Medium = Medium,
    m=0.1)
    annotation (Placement(transformation(extent={{46,-10},{26,10}})));
public
  Modelica.Blocks.Sources.Constant flow_pump1(k=273.15 + 60)
        annotation (Placement(transformation(extent={{168,-42},{148,-22}})));
  Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    nPorts=1,
    p=100000,
    T=333.15) annotation (Placement(transformation(extent={{124,-10},{104,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature2
    annotation (Placement(transformation(extent={{130,-112},{110,-92}})));
public
  Modelica.Blocks.Sources.Constant flow_pump2(k=273.15 + 20)
        annotation (Placement(transformation(extent={{170,-112},{150,-92}})));
protected
  IDEAS.Fluid.Movers.Pump pumpFlow2(
    useInput=true,
    dpFix=0,
    m_flow_nominal=1,
    redeclare package Medium = Medium,
    m=1,
    dynamicBalance=true)
             annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-74,-180})));
public
  Modelica.Blocks.Sources.Constant flow_pump3(
                                             k=1)
        annotation (Placement(transformation(extent={{-102,-156},{-82,-136}})));
  Modelica.Blocks.Sources.Sine     ctrl1(
                                        freqHz=0.1,
    amplitude=0.5,
    offset=0.5,
    phase=4.7123889803847)
        annotation (Placement(transformation(extent={{-48,-154},{-28,-134}})));
  IDEAS.Fluid.Valves.ThreeWayValveMotor threeWayValveMotor2(
                                                           m_flow_nominal=1,
      redeclare package Medium = Medium,
    m=0.1)
    annotation (Placement(transformation(extent={{8,-190},{-12,-170}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort temperature1(
                                                        redeclare package
      Medium = Medium, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{-26,-190},{-46,-170}})));
  IDEAS.Fluid.Valves.ThreeWayValveMotor threeWayValveMotor3(
                                                           m_flow_nominal=1,
      redeclare package Medium = Medium,
    m=0.1)
    annotation (Placement(transformation(extent={{44,-190},{24,-170}})));
  Simplified2ZonesOfficeBuilding.test.BaseClasses.heatLossWithCapacity
    heatLossWithCapacity
    annotation (Placement(transformation(extent={{-134,-200},{-114,-180}})));
  Simplified2ZonesOfficeBuilding.BaseClasses.Production.IdealHP heatPump(redeclare
      package Medium =                                                                              Medium,
      m_flow_nominal=1) "ideal heat pump"
    annotation (Placement(transformation(extent={{98,-18},{68,-50}})));
  Simplified2ZonesOfficeBuilding.BaseClasses.Production.IdealChiller chiller(
      redeclare package Medium = Medium, m_flow_nominal=1) "ideal chiller"
    annotation (Placement(transformation(extent={{56,-80},{26,-112}})));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe emb_nor(redeclare package
      Medium = Medium, m_flowMin=0.1,
    dynamicBalance=false,
    m_flow_nominal=1)
    annotation (Placement(transformation(extent={{15,-10},{-15,10}},
        rotation=90,
        origin={-99,-22})));
  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe emb_sou(
    redeclare package Medium = Medium,
    m_flowMin=0.1,
    dynamicBalance=false,
    m_flow_nominal=1)            annotation (Placement(transformation(
        extent={{11,-7},{-11,7}},
        rotation=90,
        origin={-103,-193})));
  Simplified2ZonesOfficeBuilding.test.BaseClasses.heatLossWithCapacity
    heatLossWithCapacity1
    annotation (Placement(transformation(extent={{-134,-32},{-114,-12}})));
equation
  connect(flow_pump.y, pumpFlow1.m_flowSet)
                                         annotation (Line(
      points={{-77,34},{-72,34},{-72,10.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ctrl.y, threeWayValveMotor.ctrl) annotation (Line(
      points={{-15,38},{1,38},{1,9.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumpFlow1.port_a, temperature.port_b) annotation (Line(
      points={{-62,0},{-44,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temperature.port_a, threeWayValveMotor.port_b) annotation (Line(
      points={{-24,0},{-10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(threeWayValveMotor.port_a1, threeWayValveMotor1.port_b) annotation (
      Line(
      points={{10,0},{26,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ctrl.y, threeWayValveMotor1.ctrl) annotation (Line(
      points={{-15,38},{37,38},{37,9.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bou.ports[1], threeWayValveMotor1.port_a1) annotation (Line(
      points={{104,0},{46,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(flow_pump3.y, pumpFlow2.m_flowSet) annotation (Line(
      points={{-81,-146},{-74,-146},{-74,-169.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ctrl1.y, threeWayValveMotor2.ctrl) annotation (Line(
      points={{-27,-144},{-1,-144},{-1,-170.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumpFlow2.port_a, temperature1.port_b) annotation (Line(
      points={{-64,-180},{-46,-180}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temperature1.port_a, threeWayValveMotor2.port_b) annotation (Line(
      points={{-26,-180},{-12,-180}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(threeWayValveMotor2.port_a1, threeWayValveMotor3.port_b) annotation (
      Line(
      points={{8,-180},{24,-180}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ctrl1.y, threeWayValveMotor3.ctrl) annotation (Line(
      points={{-27,-144},{35,-144},{35,-170.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedTemperature2.T, flow_pump2.y) annotation (Line(
      points={{132,-102},{149,-102}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine1.y, heatLossWithCapacity.TAmb) annotation (Line(
      points={{-131,34},{-124,34},{-124,2},{-144,2},{-144,-184},{-134.4,-184}},

      color={0,0,127},
      smooth=Smooth.None));
  connect(heatPump.port_a, threeWayValveMotor1.port_a1) annotation (Line(
      points={{68,-27.6},{68,0},{46,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(flow_pump1.y, heatPump.TSet) annotation (Line(
      points={{147,-32},{110,-32},{110,-64},{84.5,-64},{84.5,-53.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedTemperature2.port, heatPump.heatPort) annotation (Line(
      points={{110,-102},{110,-18},{87.5,-18}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatPump.port_a, threeWayValveMotor3.port_a1) annotation (Line(
      points={{68,-27.6},{64,-27.6},{64,-180},{44,-180}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(chiller.port_a, threeWayValveMotor1.port_a2) annotation (Line(
      points={{26,-88.7273},{28,-88.7273},{28,-26},{36,-26},{36,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(prescribedTemperature2.port, chiller.heatPort) annotation (Line(
      points={{110,-102},{86,-102},{86,-80},{45.5,-80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(chiller.port_a, threeWayValveMotor3.port_a2) annotation (Line(
      points={{26,-88.7273},{18,-88.7273},{18,-88},{14,-88},{14,-130},{48,-130},
          {48,-196},{34,-196},{34,-190}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(flow_pump1.y, chiller.TSet) annotation (Line(
      points={{147,-32},{126,-32},{126,-76},{96,-76},{96,-122},{42.5,-122},{
          42.5,-112}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumpFlow1.port_b, emb_nor.port_a) annotation (Line(
      points={{-82,0},{-99,0},{-99,-7}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(emb_nor.port_b, chiller.port_b) annotation (Line(
      points={{-99,-37},{-99,-100.364},{26,-100.364}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(emb_nor.port_b, heatPump.port_b) annotation (Line(
      points={{-99,-37},{-99,-58},{68,-58},{68,-40.4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatLossWithCapacity.port_b1, emb_sou.heatPortEmb) annotation (Line(
      points={{-114,-190},{-114,-193},{-110,-193}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pumpFlow2.port_b, emb_sou.port_a) annotation (Line(
      points={{-84,-180},{-94,-180},{-94,-182},{-103,-182}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(emb_sou.port_b, threeWayValveMotor2.port_a2) annotation (Line(
      points={{-103,-204},{-102,-204},{-102,-212},{-2,-212},{-2,-190}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(emb_sou.port_b, emb_nor.port_b) annotation (Line(
      points={{-103,-204},{-102,-204},{-102,-212},{-138,-212},{-138,-37},{-99,
          -37}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(emb_nor.port_b, threeWayValveMotor.port_a2) annotation (Line(
      points={{-99,-37},{-99,-46},{0,-46},{0,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatLossWithCapacity1.port_b1, emb_nor.heatPortEmb) annotation (Line(
      points={{-114,-22},{-112,-22},{-112,-22},{-109,-22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sine1.y, heatLossWithCapacity1.TAmb) annotation (Line(
      points={{-131,34},{-134.4,34},{-134.4,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,
            -220},{180,60}}),  graphics), Icon(coordinateSystem(extent={{-160,
            -220},{180,60}})),
    experiment(StopTime=100),
    __Dymola_experimentSetupOutput);
end HydraulicCircuitInsulated2;
