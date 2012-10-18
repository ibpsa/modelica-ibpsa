within IDEAS.Thermal.Components.Production;
model SolarThermalSystem_Simple
  "Very basic simple solar thermal system, without storage (complete primary circuit + control)"

  parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water();
  parameter Modelica.SIunits.Area ACol
    "Area of one single series-connected collector";
  parameter Integer nCol "Number of collectors in series";
  parameter Real m_flowSp = 30 "Specific mass flow rate, in liter/hm2";

  Modelica.SIunits.Power QCol "Net power delivered by the solar collector";
  Modelica.SIunits.Power QSTS "Net power delivered by the primary circuit";

  IDEAS.Thermal.Components.Production.CollectorG
                                           collectorG(
    medium=medium,
    h_g=2,
    ACol=ACol,
    nCol=nCol,
    T0=283.15)
    annotation (Placement(transformation(extent={{-84,-28},{-64,-8}})));
  Thermal.Components.BaseClasses.HeatedPipe pipeHot(medium=medium, m=5)
    annotation (Placement(transformation(extent={{-46,-28},{-26,-8}})));
  Thermal.Components.BaseClasses.Pump pump(
    medium=medium,
    m=0,
    useInput=true,
    m_flowNom=m_flowSp*ACol*nCol/3600)
    annotation (Placement(transformation(extent={{-10,-28},{10,-8}})));
  Thermal.Components.BaseClasses.HeatedPipe pipeCold(medium=medium, m=5)
    annotation (Placement(transformation(extent={{-26,-78},{-46,-58}})));

  Thermal.Control.SolarThermalControl_DT solarThermalControl_DT(TSafetyMax=
        363.15)
    annotation (Placement(transformation(extent={{54,44},{34,64}})));
  Thermal.Components.Interfaces.FlowPort_a flowPort_a(medium=medium)
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Thermal.Components.Interfaces.FlowPort_b flowPort_b(medium=medium)
    annotation (Placement(transformation(extent={{90,-30},{110,-10}})));
  Modelica.Blocks.Interfaces.RealInput TSafety
    annotation (Placement(transformation(extent={{128,58},{88,98}})));
  Modelica.Blocks.Interfaces.RealInput TLow
    annotation (Placement(transformation(extent={{126,14},{86,54}})));
  outer IDEAS.SimInfoManager         sim
    annotation (Placement(transformation(extent={{-92,68},{-72,88}})));
equation
  QCol = collectorG.QNet;
  QSTS = - (flowPort_a.H_flow + flowPort_b.H_flow);
  connect(collectorG.flowPort_b, pipeHot.flowPort_a)    annotation (Line(
      points={{-64,-18},{-46,-18}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(pipeHot.flowPort_b, pump.flowPort_a)    annotation (Line(
      points={{-26,-18},{-10,-18}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pipeCold.flowPort_b, collectorG.flowPort_a)    annotation (Line(
      points={{-46,-68},{-92,-68},{-92,-18},{-84,-18}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(solarThermalControl_DT.onOff, pump.m_flowSet) annotation (Line(
      points={{33.4,56},{0,56},{0,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(collectorG.TCol, solarThermalControl_DT.TCollector) annotation (Line(
      points={{-63.6,-24},{-54,-24},{-54,40},{82,40},{82,54},{54.6,54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(flowPort_a, pipeCold.flowPort_a) annotation (Line(
      points={{100,-60},{38,-60},{38,-68},{-26,-68}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(flowPort_b, pump.flowPort_b) annotation (Line(
      points={{100,-20},{64,-20},{64,-18},{10,-18}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(TSafety, solarThermalControl_DT.TSafety) annotation (Line(
      points={{108,78},{70,78},{70,60},{54.6,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TLow, solarThermalControl_DT.TTankBot) annotation (Line(
      points={{106,34},{70,34},{70,48},{54.6,48}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end SolarThermalSystem_Simple;
