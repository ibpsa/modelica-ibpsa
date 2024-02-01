within IBPSA.Fluid.Sensors;
model HeatMeter "Measures thermal energy provided by a source or delivered to a sink"
  extends BaseClasses.PartialDynamicFlowSensor(tau=0);
  extends Modelica.Icons.RoundSensor;
  Modelica.Blocks.Interfaces.RealInput T_other(final unit="K", displayUnit="degC") "External temperature measurement to calculate temperature difference"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(final quantity="HeatFlowRate", final unit="W") "Heat flow rate"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,110})));
  parameter Modelica.Units.SI.Temperature T_start=Medium.T_default
    "Initial or guess value of temperature"
    annotation (Dialog(group="Initialization"));
  Medium.Temperature T(start=T_start) "Temperature of the passing fluid";
protected
  Medium.Temperature TMed(start=T_start) "Medium temperature to which the sensor is exposed";
  Medium.Temperature T_a_inflow "Temperature of inflowing fluid at port_a";
  Medium.Temperature T_b_inflow "Temperature of inflowing fluid at port_b, or T_a_inflow if uni-directional flow";
initial equation
  if dynamic then
    if initType == Modelica.Blocks.Types.Init.SteadyState then
      der(T) = 0;
    elseif initType == Modelica.Blocks.Types.Init.InitialState or
           initType == Modelica.Blocks.Types.Init.InitialOutput then
      T = T_start;
    end if;
  end if;
equation
  if allowFlowReversal then
     T_a_inflow = Medium.temperature(state=
                    Medium.setState_phX(p=port_b.p, h=port_b.h_outflow, X=port_b.Xi_outflow));
     T_b_inflow = Medium.temperature(state=
                    Medium.setState_phX(p=port_a.p, h=port_a.h_outflow, X=port_a.Xi_outflow));
     TMed = Modelica.Fluid.Utilities.regStep(
              x=port_a.m_flow,
              y1=T_a_inflow,
              y2=T_b_inflow,
              x_small=m_flow_small);
  else
     TMed = Medium.temperature(state=
              Medium.setState_phX(p=port_b.p, h=port_b.h_outflow, X=port_b.Xi_outflow));
     T_a_inflow = TMed;
     T_b_inflow = TMed;
  end if;
  if dynamic then
    der(T) = (TMed-T)*k*tauInv;
  else
    T = TMed;
  end if;
  Q_flow = port_a.m_flow * Medium.cp_const * (T - T_other);
annotation (Documentation(info="<html>
<p>This model measures thermal energy provided by a source or delivered to a sink, by measuring the flow rate of the heat transfer fluid and the change in its temperature compared to an externally attached temperature measurement connected via <code>T_other</code>. The sensor does not influence the fluid.</p>
<p>The rate of heat flow is calculated as <i>Q&#775; = m&#775; c<sub>p</sub> (T - T<sub>other</sub>)</i>.</p>
</html>"));
end HeatMeter;
