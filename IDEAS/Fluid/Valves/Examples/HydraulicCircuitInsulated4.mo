within IDEAS.Fluid.Valves.Examples;
model HydraulicCircuitInsulated4
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
    Simplified2ZonesOfficeBuilding.BaseClasses.Control.BaseClasses.Ctrl_heatingSystem_in
    cont
    annotation (Placement(transformation(extent={{-110,-148},{-86,-126}})));
  Simplified2ZonesOfficeBuilding.test.BaseClasses.DummyControl dummyControl
    annotation (Placement(transformation(extent={{-180,-148},{-160,-128}})));
  IDEAS.Fluid.FixedResistances.Pipe_Insulated pipRetEmb_nor1(
    redeclare package Medium = Medium,
    m=1,
    m_flow_nominal=1,
    UA=1)
    annotation (Placement(transformation(extent={{10,4},{-10,-4}},
        rotation=270,
        origin={68,-14})));
  IDEAS.Fluid.FixedResistances.Pipe_Insulated pipRetEmb_nor2(
    redeclare package Medium = Medium,
    m=1,
    m_flow_nominal=1,
    UA=1)
    annotation (Placement(transformation(extent={{10,4},{-10,-4}},
        rotation=270,
        origin={28,-70})));
  IDEAS.Fluid.FixedResistances.Pipe_Insulated pipRetEmb_nor3(
    redeclare package Medium = Medium,
    m=1,
    m_flow_nominal=1,
    UA=1)
    annotation (Placement(transformation(extent={{-9,-4},{9,4}},
        rotation=270,
        origin={-100,-51})));
  IDEAS.Fluid.FixedResistances.Pipe_Insulated pipRetEmb_nor4(
    redeclare package Medium = Medium,
    m=1,
    m_flow_nominal=1,
    UA=1)
    annotation (Placement(transformation(extent={{-9,-4},{9,4}},
        rotation=270,
        origin={-102,-217})));
equation
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
  connect(bou.ports[1], threeWayValveMotor1.port_a1) annotation (Line(
      points={{104,0},{46,0}},
      color={0,127,255},
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
  connect(prescribedTemperature2.T, flow_pump2.y) annotation (Line(
      points={{132,-102},{149,-102}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine1.y, heatLossWithCapacity.TAmb) annotation (Line(
      points={{-131,34},{-124,34},{-124,2},{-144,2},{-144,-184},{-134.4,-184}},
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
  connect(prescribedTemperature2.port, chiller.heatPort) annotation (Line(
      points={{110,-102},{86,-102},{86,-80},{45.5,-80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(chiller.port_a, threeWayValveMotor3.port_a2) annotation (Line(
      points={{26,-88.7273},{18,-88.7273},{18,-88},{14,-88},{14,-130},{48,-130},
          {48,-196},{34,-196},{34,-190}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pumpFlow1.port_b, emb_nor.port_a) annotation (Line(
      points={{-82,0},{-99,0},{-99,-7}},
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

  connect(heatLossWithCapacity1.port_b1, emb_nor.heatPortEmb) annotation (Line(
      points={{-114,-22},{-112,-22},{-112,-22},{-109,-22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sine1.y, heatLossWithCapacity1.TAmb) annotation (Line(
      points={{-131,34},{-134.4,34},{-134.4,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cont.TSetHea, heatPump.TSet) annotation (Line(
      points={{-102.8,-124.9},{-102.8,-70},{84.5,-70},{84.5,-53.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cont.TSetChi, chiller.TSet) annotation (Line(
      points={{-93.2,-124.9},{-93.2,-116},{42.5,-116},{42.5,-112}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cont.m_w_pum_nor, pumpFlow1.m_flowSet) annotation (Line(
      points={{-84.8,-127.1},{-58,-127.1},{-58,18},{-72,18},{-72,10.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cont.m_w_pum_sou, pumpFlow2.m_flowSet) annotation (Line(
      points={{-84.8,-140.3},{-74,-140.3},{-74,-169.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cont.swiBoi_nor, threeWayValveMotor1.ctrl) annotation (Line(
      points={{-84.8,-130.4},{12,-130.4},{12,18},{37,18},{37,9.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cont.thrWayVal_nor, threeWayValveMotor.ctrl) annotation (Line(
      points={{-84.8,-133.7},{-14,-133.7},{-14,16},{1,16},{1,9.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cont.swiBoi_sou, threeWayValveMotor3.ctrl) annotation (Line(
      points={{-84.8,-143.6},{35,-143.6},{35,-170.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cont.thrWayVal_sou, threeWayValveMotor2.ctrl) annotation (Line(
      points={{-84.8,-146.9},{-1,-146.9},{-1,-170.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dummyControl.TSetHea, cont.u[1]) annotation (Line(
      points={{-174,-127},{-174,-118},{-128,-118},{-128,-135.075},{-112.4,
          -135.075}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dummyControl.TSetChi, cont.u[2]) annotation (Line(
      points={{-166,-127},{-166,-122},{-130,-122},{-130,-135.625},{-112.4,
          -135.625}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dummyControl.m_w_pum_nor, cont.u[3]) annotation (Line(
      points={{-159,-129},{-132,-129},{-132,-136.175},{-112.4,-136.175}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dummyControl.swiBoi_nor, cont.u[4]) annotation (Line(
      points={{-159,-132},{-146,-132},{-146,-134},{-112.4,-134},{-112.4,
          -136.725}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dummyControl.thrWayVal_nor, cont.u[5]) annotation (Line(
      points={{-159,-135},{-135.5,-135},{-135.5,-137.275},{-112.4,-137.275}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dummyControl.m_w_pum_sou, cont.u[6]) annotation (Line(
      points={{-159,-141},{-136.5,-141},{-136.5,-137.825},{-112.4,-137.825}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dummyControl.swiBoi_sou, cont.u[7]) annotation (Line(
      points={{-159,-144},{-136,-144},{-136,-138.375},{-112.4,-138.375}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dummyControl.thrWayVal_sou, cont.u[8]) annotation (Line(
      points={{-159,-147},{-135.5,-147},{-135.5,-138.925},{-112.4,-138.925}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heatLossWithCapacity1.T1, dummyControl.T_ctrl_nor) annotation (Line(
      points={{-134.6,-26},{-162,-26},{-162,-30},{-196,-30},{-196,-132.1},{
          -181.5,-132.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heatLossWithCapacity1.T1, dummyControl.T_ctrl_sou) annotation (Line(
      points={{-134.6,-26},{-160,-26},{-160,-28},{-181.5,-28},{-181.5,-143.9}},

      color={0,0,127},
      smooth=Smooth.None));
  connect(heatLossWithCapacity1.T1, dummyControl.heaGai[1]) annotation (Line(
      points={{-134.6,-26},{-164,-26},{-164,-28},{-196,-28},{-196,-138.65},{
          -181.5,-138.65}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heatLossWithCapacity1.T1, dummyControl.heaGai[2]) annotation (Line(
      points={{-134.6,-26},{-166,-26},{-166,-28},{-196,-28},{-196,-137.15},{
          -181.5,-137.15}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heatLossWithCapacity1.T1, dummyControl.TAmb) annotation (Line(
      points={{-134.6,-26},{-170,-26},{-170,-28},{-198,-28},{-198,-149.5},{
          -170.1,-149.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heatPump.port_a, pipRetEmb_nor1.port_a) annotation (Line(
      points={{68,-27.6},{68,-24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipRetEmb_nor1.port_b, threeWayValveMotor1.port_a1) annotation (Line(
      points={{68,-4},{68,0},{46,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipRetEmb_nor1.heatPort, heatPump.heatPort) annotation (Line(
      points={{72,-14},{106,-14},{106,-18},{87.5,-18}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(threeWayValveMotor1.port_a2, pipRetEmb_nor2.port_b) annotation (Line(
      points={{36,-10},{36,-60},{28,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipRetEmb_nor2.port_a, chiller.port_a) annotation (Line(
      points={{28,-80},{28,-88.7273},{26,-88.7273}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipRetEmb_nor2.heatPort, heatPump.heatPort) annotation (Line(
      points={{32,-70},{110,-70},{110,-18},{87.5,-18}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(emb_nor.port_b, pipRetEmb_nor3.port_a) annotation (Line(
      points={{-99,-37},{-99,-39.5},{-100,-39.5},{-100,-42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipRetEmb_nor3.port_b, chiller.port_b) annotation (Line(
      points={{-100,-60},{-100,-100.364},{26,-100.364}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipRetEmb_nor3.port_b, heatPump.port_b) annotation (Line(
      points={{-100,-60},{-16,-60},{-16,-52},{68,-52},{68,-40.4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipRetEmb_nor3.port_b, threeWayValveMotor.port_a2) annotation (Line(
      points={{-100,-60},{0,-60},{0,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipRetEmb_nor3.heatPort, heatPump.heatPort) annotation (Line(
      points={{-104,-51},{-110,-51},{-110,-58},{-108,-58},{-108,-62},{110,-62},
          {110,-18},{87.5,-18}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(emb_sou.port_b, pipRetEmb_nor4.port_a) annotation (Line(
      points={{-103,-204},{-102,-204},{-102,-208}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipRetEmb_nor4.port_b, threeWayValveMotor2.port_a2) annotation (Line(
      points={{-102,-226},{-102,-228},{-2,-228},{-2,-190}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipRetEmb_nor4.port_b, pipRetEmb_nor3.port_b) annotation (Line(
      points={{-102,-226},{-122,-226},{-122,-60},{-100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,
            -220},{180,60}}),  graphics), Icon(coordinateSystem(extent={{-160,-220},
            {180,60}})),
    experiment(StopTime=100),
    __Dymola_experimentSetupOutput);
end HydraulicCircuitInsulated4;
