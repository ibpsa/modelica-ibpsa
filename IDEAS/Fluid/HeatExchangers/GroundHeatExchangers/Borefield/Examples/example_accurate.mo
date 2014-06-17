within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Examples;
model example_accurate
  "Model of a borefield with axb borefield and a constant heat injection rate"

  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

  parameter Modelica.SIunits.HeatFlowRate q = 30
    "heat flow rate which is injected per meter depth of borehole";

  parameter Data.BorefieldData.example_accurate
    bfData
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  parameter Integer lenSim=3600*24*20 "length of the simulation";

  MultipleBoreHoles multipleBoreholes(lenSim=lenSim, bfData=bfData,
    redeclare package Medium = Medium) "borefield"
    annotation (Placement(transformation(extent={{-20,-60},{20,-20}})));
  Modelica.Blocks.Sources.Step           load(height=1, startTime=36000)
    "load for the borefield"
    annotation (Placement(transformation(extent={{26,-18},{40,-4}})));

  Movers.Pump                           pum(
    redeclare package Medium = Medium,
    useInput=true,
    T_start=bfData.steRes.T_ini,
    m_flow(start=bfData.m_flow_nominal),
    m_flow_nominal=bfData.m_flow_nominal)
    annotation (Placement(transformation(extent={{-8,22},{-28,2}})));
  Modelica.Blocks.Sources.Constant mFlo(k=1)
    annotation (Placement(transformation(extent={{-46,-12},{-34,0}})));
  HeaterCoolerPrescribed                            hea(
    redeclare package Medium = Medium,
    dp_nominal=10000,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    T_start=bfData.steRes.T_ini,
    m_flow_nominal=bfData.m_flow_nominal,
    m_flow(start=bfData.m_flow_nominal),
    p_start=100000,
    Q_flow_nominal=bfData.steRes.q_ste*bfData.geo.nbBh*bfData.geo.hBor)
    annotation (Placement(transformation(extent={{30,22},{10,2}})));
  Modelica.Fluid.Sources.Boundary_pT boundary(nPorts=1, redeclare package
      Medium = Medium)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
equation
  connect(pum.port_a,hea. port_b) annotation (Line(
      points={{-8,12},{10,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mFlo.y,pum. m_flowSet) annotation (Line(
      points={{-33.4,-6},{-18,-6},{-18,1.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(load.y, hea.u) annotation (Line(
      points={{40.7,-11},{52,-11},{52,6},{32,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(boundary.ports[1], pum.port_a) annotation (Line(
      points={{-40,50},{-8,50},{-8,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(multipleBoreholes.port_b, hea.port_a) annotation (Line(
      points={{20,-40},{60,-40},{60,12},{30,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(multipleBoreholes.port_a, pum.port_b) annotation (Line(
      points={{-20,-40},{-60,-40},{-60,12},{-28,12}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    experiment(StopTime=1.7e+006, __Dymola_NumberOfIntervals=100),
    __Dymola_experimentSetupOutput);
end example_accurate;
