within IDEAS.Examples.TwinHouses.BaseClasses.Ventilation;
model Vent_TTH
  "Ventilation based on measured supply/exhaust rates and temperatures"
  extends IDEAS.Templates.Interfaces.BaseClasses.VentilationSystem(nLoads=0,nZones=7);

  Modelica.Blocks.Tables.CombiTable1Ds   measuredInput(
    tableOnFile=true,
    tableName="data",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=IDEAS.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(Modelica.Utilities.Files.loadResource("modelica://IDEAS") + "/Inputs/"+"bc_TTH_N2.txt"),
    columns={4,5})
    annotation (Placement(transformation(extent={{28,-64},{14,-50}})));

  IDEAS.Fluid.Sources.MassFlowSource_T source[1](
    redeclare package Medium = Medium,
    use_m_flow_in=true,
     each final nPorts=1,
    use_T_in=true)
    annotation (Placement(transformation(extent={{-80,-56},{-100,-36}})));
  IDEAS.Fluid.FixedResistances.SplitterFixedResistanceDpM spl(
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    tau=300,
    from_dp=false,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal={120,-60,-60}*1.204/3600,
    dp_nominal={50,50,50},
    linearized=true,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-144,12},{-124,32}})));
  IDEAS.Fluid.Sources.FixedBoundary bou[5](each final nPorts=1,  redeclare
      package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-120,48},{-142,66}})));
  Modelica.Blocks.Math.Gain massflowInput(k=1.205/3600)
    annotation (Placement(transformation(extent={{-44,-46},{-60,-30}})));
  Modelica.Blocks.Math.UnitConversions.From_degC from_degC
    annotation (Placement(transformation(extent={{-38,-76},{-54,-60}})));
  IDEAS.Fluid.Sources.MassFlowSource_T source1[3](
    redeclare package Medium = Medium,
     each final nPorts=1,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=0)
    annotation (Placement(transformation(extent={{-124,-90},{-144,-70}})));
equation
  P[1:nLoads_min] = zeros(nLoads_min);
  Q[1:nLoads_min] = zeros(nLoads_min);
  connect(flowPort_Out[1], source[1].ports[1]);
if time> 20044800 then
  measuredInput.u= sim.timMan.timCal;
  else
  measuredInput.u = 20044800;
  end if;
  connect(flowPort_In[2], spl.port_1) annotation (Line(points={{-200,14.2857},{
          -172,14.2857},{-172,22},{-144,22}},
                                color={0,0,0}));
  connect(spl.port_3, flowPort_Out[3]) annotation (Line(points={{-134,12},{-134,
          12},{-134,-22.8571},{-200,-22.8571}},
                                      color={0,127,255}));
  connect(spl.port_2, flowPort_Out[4]) annotation (Line(points={{-124,22},{-110,
          22},{-110,-20},{-200,-20}}, color={0,127,255}));
  connect(flowPort_In[3], bou[1].ports[1]) annotation (Line(points={{-200,
          17.1429},{-200,57},{-142,57}},
                                    color={0,0,0}));
  connect(flowPort_In[4], bou[2].ports[1]) annotation (Line(points={{-200,20},{-200,
          57},{-142,57}},           color={0,0,0}));
  connect(measuredInput.y[2], massflowInput.u) annotation (Line(points={{13.3,-57},
          {0,-57},{0,-38},{-22,-38},{-42.4,-38}}, color={0,0,127}));
  connect(source[1].m_flow_in, massflowInput.y) annotation (Line(points={{-80,-38},
          {-70,-38},{-60.8,-38}},             color={0,0,127}));
  connect(measuredInput.y[1], from_degC.u) annotation (Line(points={{13.3,-57},{
          0,-57},{0,-68},{-36.4,-68}}, color={0,0,127}));
  connect(from_degC.y, source[1].T_in) annotation (Line(points={{-54.8,-68},{-70,
          -68},{-70,-42},{-78,-42}}, color={0,0,127}));
  connect(flowPort_In[5:7], bou[3:5].ports[1]) annotation (Line(points={{-200,
          28.5714},{-190,28.5714},{-190,48},{-190,57},{-142,57}},
                                                  color={0,0,0}));
  connect(source1[1:3].ports[1], flowPort_Out[5:7]) annotation (Line(points={{-144,
          -80},{-152,-80},{-152,-82},{-200,-82},{-200,-11.4286}},
                                                             color={0,127,255}));
  connect(flowPort_Out[2], flowPort_In[1]) annotation (Line(points={{-200,
          -25.7143},{-200,11.4286}}, color={0,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Line(points={{-194,
              -20},{-152,-20},{-152,-44},{-100,-44}}, color={28,108,200})}));
end Vent_TTH;
