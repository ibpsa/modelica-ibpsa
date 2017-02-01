within IDEAS.Airflow.AHU.Examples;
model Adsolair58 "Adsolair58 example model"
  extends Modelica.Icons.Example;
  inner BoundaryConditions.SimInfoManager sim "Data reader"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  replaceable package Medium = IDEAS.Media.Air;
  replaceable package MediumWater = IDEAS.Media.Water "Heating medium";
  parameter Modelica.SIunits.Pressure dp_nominal=100 "Constant output value";
  parameter SI.MassFlowRate m_flow_nominal=0.3 "Nominal air mass flow rate";
  Adsolair58HeaCoi             adsolair58(
    redeclare package MediumAir = Medium,
    redeclare BaseClasses.Adsolair14200 per,
    use_onOffSignal=false,
    onOff=true,
    dp_fouling_top=0,
    dp_fouling_bot=0,
    redeclare package MediumHeating = MediumWater)
                                          "Adsolair 58 model"
    annotation (Placement(transformation(extent={{-20,30},{-40,50}})));
  IDEAS.Buildings.Validation.BaseClasses.Structure.Bui600 bui600(redeclare
      package
      Medium = Medium) "Case 600 building envelope"
    annotation (Placement(transformation(extent={{-100,-120},{-70,-100}})));
  IDEAS.Fluid.Sources.Boundary_pT env(
    redeclare package Medium = Medium,
    use_T_in=true,
    use_X_in=true,
    nPorts=2) "Environment"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  IDEAS.Buildings.Components.Interfaces.WeaBus weaBus1(numSolBus=sim.numIncAndAziInBus,
      outputAngles=sim.outputAngles)
    annotation (Placement(transformation(extent={{-74,82},{-54,102}})));

  Modelica.Blocks.Routing.RealPassThrough X_w;
  Modelica.Blocks.Sources.RealExpression reaExpXw[2](y={X_w.y,1 - X_w.y})
    "For setting humidity of inlet air"
    annotation (Placement(transformation(extent={{-112,26},{-92,46}})));
  Modelica.Blocks.Sources.Constant dpNom[2](each k=dp_nominal)
    annotation (Placement(transformation(extent={{14,60},{0,74}})));

  Modelica.Blocks.Sources.Constant TSupAir(each k=273.15 + 26)
    "Supply temperature set point for air handling unit"
    annotation (Placement(transformation(extent={{14,80},{0,94}})));
  IDEAS.Buildings.Validation.BaseClasses.Structure.Bui900 bui900(redeclare
      package
      Medium = Medium) "Case 900 building envelope"
    annotation (Placement(transformation(extent={{10,-120},{40,-100}})));
  IDEAS.Buildings.Validation.BaseClasses.Structure.Bui610 bui610(redeclare
      package
      Medium = Medium) "Case 610 building envelope"
    annotation (Placement(transformation(extent={{-50,-120},{-20,-100}})));
  IDEAS.Buildings.Validation.BaseClasses.Structure.Bui930 bui930(redeclare
      package
      Medium = Medium) "Case 930 building envelope"
    annotation (Placement(transformation(extent={{70,-120},{100,-100}})));
  IDEAS.Fluid.Actuators.Valves.TwoWayPressureIndependent vavSup(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=dp_nominal,
    allowFlowReversal=false,
    filteredOpening=false) "Supply VAV" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={90,-50})));

  Fluid.Actuators.Valves.TwoWayPressureIndependent vavRet(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=dp_nominal,
    allowFlowReversal=false,
    filteredOpening=false) "Return VAV" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={70,-50})));
  Fluid.Actuators.Valves.TwoWayPressureIndependent vavRet1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=dp_nominal,
    allowFlowReversal=false,
    filteredOpening=false) "Return VAV" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={18,-70})));
  Fluid.Actuators.Valves.TwoWayPressureIndependent vavSup1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=dp_nominal,
    allowFlowReversal=false,
    filteredOpening=false) "Supply VAV" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={38,-70})));
  Fluid.Actuators.Valves.TwoWayPressureIndependent vavRet2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=dp_nominal,
    allowFlowReversal=false,
    filteredOpening=false) "Return VAV" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-40,-50})));
  Fluid.Actuators.Valves.TwoWayPressureIndependent vavSup2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=dp_nominal,
    allowFlowReversal=false,
    filteredOpening=false) "Supply VAV" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-20,-50})));
  Fluid.Actuators.Valves.TwoWayPressureIndependent vavRet3(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=dp_nominal,
    allowFlowReversal=false,
    filteredOpening=false) "Return VAV" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-90,-70})));
  Fluid.Actuators.Valves.TwoWayPressureIndependent vavSup3(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=dp_nominal,
    allowFlowReversal=false,
    filteredOpening=false) "Supply VAV" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,-70})));
  Controls.Continuous.LimPID conPID1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    Ti=120) "PID controller - example of a simple controller model"
    annotation (Placement(transformation(extent={{102,-100},{112,-90}})));
  Controls.Continuous.LimPID conPID2(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    Ti=120) "PID controller - example of a simple controller model"
    annotation (Placement(transformation(extent={{42,-100},{52,-90}})));
  Controls.Continuous.LimPID conPID3(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    Ti=120) "PID controller - example of a simple controller model"
    annotation (Placement(transformation(extent={{-18,-100},{-8,-90}})));
  Controls.Continuous.LimPID conPID4(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    Ti=120) "PID controller - example of a simple controller model"
    annotation (Placement(transformation(extent={{-68,-100},{-58,-90}})));
  Fluid.HeatExchangers.HeaterCooler_T hea(
    redeclare package Medium = MediumWater,
    dp_nominal=0,
    Q_flow_maxCool=0,
    m_flow_nominal=2,
    Q_flow_maxHeat=3e4)
    annotation (Placement(transformation(extent={{-100,-4},{-80,16}})));
  Fluid.Movers.FlowControlled_dp pum(
    redeclare package Medium = MediumWater,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    filteredSpeed=false,
    constantHead=1e4,
    inputType=IDEAS.Fluid.Types.InputType.Stages,
    m_flow_nominal=2,
    heads={0,1e4}) "Supply pump"
    annotation (Placement(transformation(extent={{-74,-2},{-58,14}})));
  Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear val(
    redeclare package Medium = MediumWater,
    dpValve_nominal=1e4,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=30,
    filteredOpening=false,
    m_flow_nominal=2)      "Valve for controlling flow rate"
    annotation (Placement(transformation(extent={{-52,-2},{-36,14}})));
  Modelica.Blocks.Logical.Hysteresis heaOn(uLow=0.025, uHigh=0.05)
    "Heating system on if heating water is demanded"
    annotation (Placement(transformation(extent={{-44,-20},{-58,-6}})));
  Modelica.Blocks.Math.BooleanToInteger booToInt(integerTrue=2, integerFalse=1)
    "Convert boolean to pump control signal"
    annotation (Placement(transformation(extent={{-64,-20},{-78,-6}})));
  Modelica.Blocks.Sources.Constant TSup(k=273.15 + 50) "Supply temperature"
    annotation (Placement(transformation(extent={{-134,4},{-118,20}})));
  Fluid.Sources.Boundary_pT bouWat(
    nPorts=1,
    redeclare package Medium = MediumWater,
    p=4e5) "Pressure boundary"
    annotation (Placement(transformation(extent={{-114,-4},{-104,6}})));
  Modelica.Blocks.Sources.Constant TSet(each k=273.15 + 22)
    "Temperature set point of the zone"
    annotation (Placement(transformation(extent={{130,-80},{116,-66}})));
equation
  connect(sim.weaBus, weaBus1) annotation (Line(
      points={{-84,92.8},{-74,92.8},{-74,96},{-64,96},{-64,92}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(env.T_in, weaBus1.Te) annotation (Line(points={{-82,44},{-96,44},{-96,
          72},{-63.95,72},{-63.95,92.05}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(X_w.u, weaBus1.X_wEnv);
  connect(reaExpXw.y, env.X_in)
    annotation (Line(points={{-91,36},{-86.5,36},{-82,36}}, color={0,0,127}));
  connect(env.ports[1], adsolair58.port_b1) annotation (Line(points={{-60,42},{-56,
          42},{-52,42},{-52,46},{-40,46}}, color={0,127,255}));
  connect(env.ports[2], adsolair58.port_a2) annotation (Line(points={{-60,38},{-52,
          38},{-52,34},{-40,34}}, color={0,127,255}));
  connect(dpNom.y, adsolair58.dpSet)
    annotation (Line(points={{-0.7,67},{-32,67},{-32,50.2}},
                                                           color={0,0,127}));
  connect(TSupAir.y, adsolair58.Tset)
    annotation (Line(points={{-0.7,87},{-36,87},{-36,50.2}}, color={0,0,127}));
  connect(vavSup.port_b, bui930.port_a[1])
    annotation (Line(points={{90,-60},{87,-60},{87,-100}},color={0,127,255}));
  connect(vavRet.port_a, bui930.port_b[1]) annotation (Line(points={{70,-60},{78,
          -60},{78,-100},{83,-100}},
                                   color={0,127,255}));
  connect(vavRet3.port_a, bui600.port_b[1]) annotation (Line(points={{-90,-80},{
          -88,-80},{-88,-100},{-87,-100}},
                                         color={0,127,255}));
  connect(vavSup3.port_b, bui600.port_a[1]) annotation (Line(points={{-70,-80},{
          -76,-80},{-76,-100},{-83,-100}},
                                         color={0,127,255}));
  connect(vavRet2.port_a, bui610.port_b[1]) annotation (Line(points={{-40,-60},{
          -40,-60},{-40,-100},{-37,-100}},
                                         color={0,127,255}));
  connect(vavSup2.port_b, bui610.port_a[1]) annotation (Line(points={{-20,-60},{
          -26,-60},{-26,-100},{-33,-100}},
                                         color={0,127,255}));
  connect(vavRet1.port_a, bui900.port_b[1]) annotation (Line(points={{18,-80},{22,
          -80},{22,-100},{23,-100}},
                                   color={0,127,255}));
  connect(vavSup1.port_b, bui900.port_a[1]) annotation (Line(points={{38,-80},{34,
          -80},{34,-100},{27,-100}},
                                   color={0,127,255}));
  connect(vavRet3.port_b, adsolair58.port_a1) annotation (Line(points={{-90,-60},
          {-90,-26},{16,-26},{16,46},{-20,46}}, color={0,127,255}));
  connect(vavRet2.port_b, adsolair58.port_a1) annotation (Line(points={{-40,-40},
          {-40,-26},{16,-26},{16,46},{-20,46}},color={0,127,255}));
  connect(vavRet1.port_b, adsolair58.port_a1) annotation (Line(points={{18,-60},
          {16,-60},{16,-16},{16,46},{-20,46}},        color={0,127,255}));
  connect(vavRet.port_b, adsolair58.port_a1) annotation (Line(points={{70,-40},{
          70,-40},{70,-26},{16,-26},{16,46},{-20,46}},
                                color={0,127,255}));
  connect(vavSup.port_a, adsolair58.port_b2)
    annotation (Line(points={{90,-40},{90,-28},{38,-28},{38,24},{-20,24},{-20,34}},
                                                       color={0,127,255}));
  connect(vavSup1.port_a, adsolair58.port_b2)
    annotation (Line(points={{38,-60},{38,34},{-20,34}}, color={0,127,255}));
  connect(vavSup2.port_a, adsolair58.port_b2) annotation (Line(points={{-20,-40},
          {-20,-28},{38,-28},{38,34},{-20,34}},color={0,127,255}));
  connect(vavSup3.port_a, adsolair58.port_b2) annotation (Line(points={{-70,-60},
          {-70,-28},{38,-28},{38,34},{-20,34}}, color={0,127,255}));
  connect(vavRet3.y, vavSup3.y)
    annotation (Line(points={{-78,-70},{-58,-70}},           color={0,0,127}));
  connect(vavRet2.y, vavSup2.y)
    annotation (Line(points={{-28,-50},{-24,-50},{-8,-50}},
                                                  color={0,0,127}));
  connect(vavRet1.y, vavSup1.y)
    annotation (Line(points={{30,-70},{50,-70}},          color={0,0,127}));
  connect(vavRet.y, vavSup.y)
    annotation (Line(points={{82,-50},{88,-50},{102,-50}},  color={0,0,127}));
  connect(conPID4.y, vavSup3.y) annotation (Line(points={{-57.5,-95},{-56,-95},{
          -56,-90},{-56,-70},{-58,-70}}, color={0,0,127}));
  connect(conPID4.u_m, bui600.TSensor[1]) annotation (Line(points={{-63,-101},{-63,
          -116},{-69.4,-116}},
                             color={0,0,127}));
  connect(conPID3.u_m, bui610.TSensor[1]) annotation (Line(points={{-13,-101},{-13,
          -116},{-19.4,-116}},
                             color={0,0,127}));
  connect(conPID2.u_m, bui900.TSensor[1])
    annotation (Line(points={{47,-101},{47,-116},{40.6,-116}},
                                                            color={0,0,127}));
  connect(conPID1.u_m, bui930.TSensor[1]) annotation (Line(points={{107,-101},{107,
          -116},{100.6,-116}},
                             color={0,0,127}));
  connect(conPID1.y, vavSup.y) annotation (Line(points={{112.5,-95},{112.5,-50},
          {102,-50}}, color={0,0,127}));
  connect(conPID2.y, vavSup1.y) annotation (Line(points={{52.5,-95},{52.5,-70},{
          50,-70}}, color={0,0,127}));
  connect(conPID3.y, vavSup2.y) annotation (Line(points={{-7.5,-95},{-7.5,-93.5},
          {-8,-93.5},{-8,-50}}, color={0,0,127}));
  connect(conPID4.u_s, conPID1.u_s) annotation (Line(points={{-69,-95},{-69,-138},
          {101,-138},{101,-95}},color={0,0,127}));
  connect(conPID2.u_s, conPID1.u_s) annotation (Line(points={{41,-95},{41,-138},
          {101,-138},{101,-95}},
                               color={0,0,127}));
  connect(conPID3.u_s, conPID1.u_s) annotation (Line(points={{-19,-95},{-19,-138},
          {101,-138},{101,-95}},color={0,0,127}));
  connect(pum.port_a, hea.port_b)
    annotation (Line(points={{-74,6},{-77,6},{-80,6}}, color={0,127,255}));
  connect(pum.port_b, val.port_1)
    annotation (Line(points={{-58,6},{-56,6},{-52,6}}, color={0,127,255}));
  connect(val.port_2, adsolair58.port_a)
    annotation (Line(points={{-36,6},{-22,6},{-22,30}}, color={0,127,255}));
  connect(adsolair58.port_b, val.port_3)
    annotation (Line(points={{-28,30},{-28,-2},{-44,-2}}, color={0,127,255}));
  connect(val.port_3, hea.port_a) annotation (Line(points={{-44,-2},{-100,-2},{-100,
          0},{-100,6}}, color={0,127,255}));
  connect(heaOn.u, adsolair58.yHea) annotation (Line(points={{-42.6,-13},{-40.6,
          -13},{-40.6,40}}, color={0,0,127}));
  connect(booToInt.u, heaOn.y)
    annotation (Line(points={{-62.6,-13},{-58.7,-13}}, color={255,0,255}));
  connect(booToInt.y, pum.stage) annotation (Line(points={{-78.7,-13},{-78.7,15.6},
          {-66,15.6}}, color={255,127,0}));
  connect(val.y, adsolair58.yHea) annotation (Line(points={{-44,15.6},{-44,40},{
          -40.6,40}}, color={0,0,127}));
  connect(TSup.y, hea.TSet) annotation (Line(points={{-117.2,12},{-110,12},{-102,
          12}}, color={0,0,127}));
  connect(bouWat.ports[1], hea.port_a) annotation (Line(points={{-104,1},{-102,1},
          {-102,6},{-100,6}}, color={0,127,255}));
  connect(conPID1.u_s, TSet.y) annotation (Line(points={{101,-95},{101,-73},{115.3,
          -73}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,100}})),
    Documentation(info="<html>
<p>
This example demonstrates the use of 
<a href=modelica://IDEAS.Airflow.AHU.Adsolair58HeaCoi>IDEAS.Airflow.AHU.Adsolair58HeaCoi</a>
in a bigger system.
Four buildings are heated using warm air from an Adsolair ventilation unit 
with a heating coil. Heat is provided by a furance. An external pump and three way valve
control the supply mass flow rate towards the heating coil in the ventilation unit. 
The air flow rate of the individual buildings is controlled using VAVs.
A PI controller is used to track the set point temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
February 1, 2017, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Airflow/AHU/Examples/Adsolair58.mos"
        "Siimulate and plot"));
end Adsolair58;
