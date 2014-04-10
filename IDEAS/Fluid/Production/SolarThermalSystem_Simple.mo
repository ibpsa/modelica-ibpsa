within IDEAS.Fluid.Production;
model SolarThermalSystem_Simple
  "Very basic simple solar thermal system, without storage (complete primary circuit + control)"
  import IDEAS;

  parameter Thermal.Data.Interfaces.Medium medium=IDEAS.Thermal.Data.Media.Water();
  parameter Modelica.SIunits.Area ACol
    "Area of one single series-connected collector";
  parameter Integer nCol "Number of collectors in series";
  parameter Real m_flowSp=30 "Specific mass flow rate, in liter/hm2";

  Modelica.SIunits.Power QCol "Net power delivered by the solar collector";
  Modelica.SIunits.Power QSTS "Net power delivered by the primary circuit";

  IDEAS.Fluid.Production.SolarCollector_Glazed collectorG(
    medium=medium,
    h_g=2,
    ACol=ACol,
    nCol=nCol,
    T0=283.15)
    annotation (Placement(transformation(extent={{-84,-28},{-64,-8}})));
  IDEAS.Fluid.FixedResistances.Pipe_HeatPort pipeHot(medium=medium, m=5)
    annotation (Placement(transformation(extent={{-46,-28},{-26,-8}})));
  IDEAS.Fluid.Movers.Pump pump(
    medium=medium,
    m=0,
    useInput=true,
    m_flowNom=m_flowSp*ACol*nCol/3600)
    annotation (Placement(transformation(extent={{-10,-28},{10,-8}})));
  IDEAS.Fluid.FixedResistances.Pipe_HeatPort pipeCold(medium=medium, m=5)
    annotation (Placement(transformation(extent={{-26,-78},{-46,-58}})));

  IDEAS.Thermal.Control.Ctrl_SolarThermal_Simple solarThermalControl_DT(
      TSafetyMax=363.15)
    annotation (Placement(transformation(extent={{54,44},{34,64}})));
  Thermal.Components.Interfaces.FlowPort_a flowPort_a(medium=medium)
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Thermal.Components.Interfaces.FlowPort_b flowPort_b(medium=medium)
    annotation (Placement(transformation(extent={{90,-30},{110,-10}})));
  Modelica.Blocks.Interfaces.RealInput TSafety
    annotation (Placement(transformation(extent={{128,58},{88,98}})));
  Modelica.Blocks.Interfaces.RealInput TLow
    annotation (Placement(transformation(extent={{126,14},{86,54}})));
  outer IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{-92,68},{-72,88}})));
equation
  QCol = collectorG.QNet;
  QSTS = -(flowPort_a.H_flow + flowPort_b.H_flow);
  connect(collectorG.flowPort_b, pipeHot.flowPort_a) annotation (Line(
      points={{-64,-18},{-46,-18}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(pipeHot.flowPort_b, pump.flowPort_a) annotation (Line(
      points={{-26,-18},{-10,-18}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pipeCold.flowPort_b, collectorG.flowPort_a) annotation (Line(
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
  annotation (Diagram(graphics), Documentation(info="<html>
<p><b>Description</b> </p>
<p>Predesigned solar thermal primary circuit, including solar collector, pump, control and supply and return pipes. Connectors are foreseen to link the primary circuit with a storage tank for example. </p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>The <a href=\"modelica://IDEAS.Thermal.Components.Production.SolarCollector_Glazed\">solar thermal collector model</a> is not validated</li>
<li>The pipes have no heat loss in this design. </li>
</ol></p>
<p><h4>Model use</h4></p>
<p><ol>
<li>The model is very easy to use by coupling it&apos;s provided flowPorts to the ports of a storage tank.</li>
<li>Only 3 parameters to be set if the default collector properties are fine: collector surface, number of collectors in series and specific mass flow rate</li>
</ol></p>
<p><h4>Validation</h4></p>
<p>No validation performed.</p>
<p><h4>Example </h4></p>
<p>An example of the use of this model is given in <a href=\"modelica://IDEAS.Thermal.HeatingSystems.Heating_Embedded_DHW_STS\">IDEAS.Thermal.HeatingSystems.Heating_Embedded_DHW_STS</a>.</p>
</html>", revisions="<html>
<p><ul>
<li>2013 May, Roel De Coninck: basic documentation</li>
<li>2011 Roel De Coninck: first version</li>
</ul></p>
</html>"));
end SolarThermalSystem_Simple;
