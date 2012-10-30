within IDEAS.Thermal.Components.BaseClasses;
model Pump_Insulated "Pump with UA for thermal losses"

  parameter Thermal.Data.Interfaces.Medium medium=Data.Interfaces.Medium()
    "Medium in the component"
    annotation(choicesAllMatching=true);
  parameter Modelica.SIunits.Mass m(start=1) "Mass of medium";
  parameter Modelica.SIunits.Temperature TInitial=293.15
    "Initial temperature of all Temperature states";

  parameter Boolean useInput = false "Enable / disable MassFlowRate input"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.MassFlowRate m_flowNom(min=0, start=1)
    "Nominal mass flowrate"
    annotation(Dialog(enable=not useVolumeFlowInput));
  parameter Modelica.SIunits.Pressure dpFix=50000
    "Fixed pressure drop, used for determining the electricity consumption";
  parameter Real etaTot = 0.8 "Fixed total pump efficiency";
  SI.Power PEl=pump_HeatPort.PEl "Electricity consumption";
  SI.Temperature T=pump_HeatPort.T "Temperature of the fluid";
  Modelica.Blocks.Interfaces.RealInput m_flowSet(start = 0, min = 0, max = 1) = m_flow/m_flowNom if useInput
    annotation (Placement(transformation(
        origin={0,100},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  parameter SI.ThermalConductance UA "Thermal conductance of the insulation";

protected
  Modelica.SIunits.MassFlowRate m_flow;

  Pump_HeatPort pump_HeatPort(
    medium=medium,
    useInput=useInput,
    m_flowNom=m_flowNom,
    dpFix=dpFix,
    etaTot=etaTot)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=
        UA) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-44})));

public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation (
      Placement(transformation(extent={{-10,-96},{10,-76}}), iconTransformation(
          extent={{-10,-96},{10,-76}})));
  Interfaces.FlowPort_a flowPort_a(medium=medium)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Interfaces.FlowPort_b flowPort_b(medium=medium)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation
  if not useInput then
    m_flow = m_flowNom;
  end if;
  connect(m_flowSet, pump_HeatPort.m_flowSet);
  connect(thermalConductor.port_a, heatPort) annotation (Line(
      points={{-6.12323e-016,-54},{0,-54},{0,-86}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, pump_HeatPort.heatPort) annotation (Line(
      points={{6.12323e-016,-34},{0,-34},{0,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pump_HeatPort.flowPort_a, flowPort_a) annotation (Line(
      points={{-10,0},{-100,0}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(pump_HeatPort.flowPort_b, flowPort_b) annotation (Line(
      points={{10,0},{100,0}},
      color={0,128,255},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics={
        Ellipse(
          extent={{-78,76},{78,-76}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.CrossDiag),
        Text(
          extent={{-40,20},{0,-20}},
          lineColor={0,0,0},
          textString="V"),
        Ellipse(
          extent={{-60,60},{60,-60}},
          lineColor={135,135,135},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-40,20},{0,-20}},
          lineColor={0,0,0},
          textString="V"),
        Line(
          points={{-100,0},{-60,0}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{100,0},{60,0}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{0,0},{0,80}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-40,80},{40,80}},
          color={0,0,127},
          smooth=Smooth.None),
        Polygon(
          points={{-38,46},{60,0},{60,0},{-38,-46},{-38,46}},
          lineColor={135,135,135},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid)}));
end Pump_Insulated;
