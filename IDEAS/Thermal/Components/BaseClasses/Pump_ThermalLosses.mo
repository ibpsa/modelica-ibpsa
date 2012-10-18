within IDEAS.Thermal.Components.BaseClasses;
model Pump_ThermalLosses

  parameter Thermal.Data.Interfaces.Medium medium=Data.Interfaces.Medium()
    "Medium in the component"
    annotation(choicesAllMatching=true);
  parameter Boolean useInput = false "Enable / disable MassFlowRate input"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.MassFlowRate m_flowNom(min=0, start=1)
    "Nominal mass flowrate"
    annotation(Dialog(enable=not useVolumeFlowInput));
  parameter Modelica.SIunits.Pressure dpFix=50000
    "Fixed pressure drop, used for determining the electricity consumption";
  parameter Real etaTot = 0.8 "Fixed total pump efficiency";
  Modelica.SIunits.Power PEl "Electricity consumption";
  Modelica.Blocks.Interfaces.RealInput m_flowSet(start = 0, min = 0, max = 1) = m_flow/m_flowNom if useInput
    annotation (Placement(transformation(
        origin={0,100},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  parameter SI.ThermalConductance UA "Thermal conductance of the insulation";

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
        origin={0,-34})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation (
      Placement(transformation(extent={{-10,-78},{10,-58}}), iconTransformation(
          extent={{-10,-60},{10,-40}})));
  Interfaces.FlowPort_a flowPort_a
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Interfaces.FlowPort_b flowPort_b
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation
  connect(m_flowSet, pump_HeatPort.m_flowSet);
  connect(thermalConductor.port_a, heatPort) annotation (Line(
      points={{-6.12323e-016,-44},{0,-44},{0,-68}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, pump_HeatPort.heatPort) annotation (Line(
      points={{6.12323e-016,-24},{0,-24},{0,-10}},
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
  annotation (Diagram(graphics));
end Pump_ThermalLosses;
