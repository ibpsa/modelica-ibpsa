within IDEAS.Fluid.HeatExchangers.Examples;
model Radiator_CoolingDown "Test the cooling down of radiators"
  import IDEAS;
  extends Modelica.Icons.Example;

   package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    annotation (__Dymola_choicesAllMatching=true);

  Fluid.HeatExchangers.Radiators.Radiator radiator_new(
    QNom=1000,
    redeclare package Medium = Medium,
    T_start=333.15,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-64,76},{-44,56}})));
  IDEAS.Fluid.HeatExchangers.Radiators.Radiator radiator_new1(
    QNom=2000,
    redeclare package Medium = Medium,
    T_start=333.15,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-64,-10},{-44,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=294.15)
    annotation (Placement(transformation(extent={{-14,20},{-34,40}})));
  Fluid.Movers.Pump pump(
    m_flow_nominal=0.05,
    m=1,
    useInput=true,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-20,56},{0,76}})));
  Fluid.Movers.Pump pump1(
    m=1,
    m_flow_nominal=0.05,
    useInput=true,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-18,-10},{2,10}})));
  IDEAS.Fluid.HeatExchangers.Radiators.Radiator radiator_new2(
    QNom=1000,
    powerFactor=3.37,
    redeclare package Medium = Medium,
    T_start=333.15,
    TInNom=318.15,
    TOutNom=308.15,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Fluid.Movers.Pump pump2(
    m=1,
    m_flow_nominal=0.05,
    useInput=true,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-14,-50},{6,-30}})));
  IDEAS.Fluid.Sources.Boundary_pT
                      bou(redeclare package Medium = Medium, nPorts=3,
    p=200000,
    T=283.15)                                                annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={80,2})));
  IDEAS.Fluid.Sources.Boundary_pT
                      bou1(
                          redeclare package Medium = Medium, nPorts=1,
    p=200000,
    T=333.15)                                                annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-70,24})));
equation
  pump.m_flowSet = if time > 1 then 0 else 1;
  pump1.m_flowSet = if time > 1 then 0 else 1;
  pump2.m_flowSet = if time > 1 then 0 else 1;
  connect(fixedTemperature.port, radiator_new.heatPortRad) annotation (Line(
      points={{-34,30},{-45,30},{-45,56}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, radiator_new1.heatPortCon) annotation (Line(
      points={{-34,30},{-49,30},{-49,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, radiator_new1.heatPortRad) annotation (Line(
      points={{-34,30},{-50,30},{-50,10},{-45,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radiator_new1.port_b, pump1.port_a) annotation (Line(
      points={{-44,0},{-18,0}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(radiator_new.port_b, pump.port_a) annotation (Line(
      points={{-44,66},{-20,66}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(radiator_new2.port_b, pump2.port_a) annotation (Line(
      points={{-40,-40},{-14,-40}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, radiator_new2.heatPortCon) annotation (Line(
      points={{-34,30},{-36,30},{-36,-16},{-45,-16},{-45,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, radiator_new2.heatPortRad) annotation (Line(
      points={{-34,30},{-36,30},{-36,-20},{-41,-20},{-41,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radiator_new.heatPortCon, radiator_new1.heatPortCon) annotation (Line(
      points={{-49,56},{-52,56},{-52,10},{-49,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(bou.ports[1], pump1.port_b) annotation (Line(
      points={{70,-0.666667},{70,0},{2,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump2.port_b, bou.ports[2]) annotation (Line(
      points={{6,-40},{70,-40},{70,2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump.port_b, bou.ports[3]) annotation (Line(
      points={{0,66},{70,66},{70,4.66667}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou1.ports[1], radiator_new1.port_a) annotation (Line(
      points={{-80,24},{-92,24},{-92,0},{-64,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(radiator_new.port_a, radiator_new1.port_a) annotation (Line(
      points={{-64,66},{-92,66},{-92,0},{-64,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(radiator_new2.port_a, radiator_new1.port_a) annotation (Line(
      points={{-60,-40},{-92,-40},{-92,0},{-64,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),     graphics),
    experiment(StopTime=25000),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>These three radiators are supposed to show the same cooling down behaviour.</p>
</html>", revisions="<html>
<ul>
<li>March 2014 by Filip Jorissen:<br/> 
Annex60 compatibility
</li>
</ul>
</html>"));
end Radiator_CoolingDown;
