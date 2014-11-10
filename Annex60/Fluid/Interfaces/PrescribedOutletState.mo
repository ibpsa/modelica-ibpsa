within Annex60.Fluid.Interfaces;
model PrescribedOutletState
  "Component that assigns the outlet fluid property at port_a based on an input signal"
  extends Annex60.Fluid.Interfaces.PartialTwoPortTransport;
parameter Modelica.SIunits.HeatFlowRate Q_flow_maxHeat
    "Maximum heat flow rate for heating (positive)";
parameter Modelica.SIunits.HeatFlowRate Q_flow_maxCool
    "Maximum heat flow rate for cooling (negative)";
Modelica.Blocks.Interfaces.RealInput TSet(unit="K")
    "Set temperature of the heater"
  annotation (Placement(transformation(origin={-120,80},
              extent={{20,-20},{-20,20}},rotation=180)));
protected
  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(
        Medium.setState_pTX(
          p=Medium.p_default,
          T=Medium.T_default,
          X=Medium.X_default)) "Specific heat capacity at default medium state";

  parameter Boolean restrictHeat = Q_flow_maxHeat <> Modelica.Constants.inf
    "Flag, true if maximum heating power is restricted";
  parameter Boolean restrictCool = Q_flow_maxCool <> -Modelica.Constants.inf
    "Flag, true if maximum cooling power is restricted";
  parameter Modelica.SIunits.Enthalpy dH_maxHeat(fixed=false)
    "Maximum enthalpy change during heating";
  parameter Modelica.SIunits.Enthalpy dH_maxCool(fixed=false)
    "Maximum enthalpy change during cooling";

initial equation
  // Maximum changes in enthalpy flow rates
  dH_maxHeat = if restrictHeat then Q_flow_maxHeat / cp_default else Modelica.Constants.inf;
  dH_maxCool = if restrictCool then Q_flow_maxCool / cp_default else -Modelica.Constants.inf;

equation
  // fixme: Not clear how to handle the state of the volume in reverse flow without using
  // a MixingVolume (and introducing Q_flow which we wanted to avoid).

  // Compute effective outlet enthalpy
  hSet = Medium.specificEnthalpy(
    Medium.setState_pTX(
      p=  port_a.p,
      T=  TSet,
      X=  instream(port_a.Xi_outflow)));
  dHSet = hSet * m_flow;
  // Compute how much dH may need to be reduced.
  if restrictHeat and restrictCool then
    dHSetAct = Annex60.Utilities.Math.Functions.smoothLimit(
      x=dHSet,
      l=dH_maxCool,
      u=dH_maxHeat,
      deltaX=deltaH);
  elseif restrictHeat then
    dHSetAct = Annex60.Utilities.Math.Functions.smoothMax(
      x1=dHSet,
      x2=dH_maxHeat,
      deltaX=deltaH);
  elseif restrictCool then
    dHSetAct = Annex60.Utilities.Math.Functions.smoothMin(
      x1=dHSet,
      x2=dH_maxCool,
      deltaX=deltaH);
  else
    dHSetAct = dHSet;
  end if;

  port_b.h_outflow = inStream(port_a.h_outflow)
    + dHSetAct * Annex60.Utilities.Math.Functions.inverseXRegularized(x=port_a.m_flow, delta=m_flow_small/1E3);
/*  if m_flow > 0 then
    if Q_flow_maxHeat <> Modelica.Constants.inf and  Q_flow_maxCool == - Modelica.Constants.inf then
      port.Q_flow = - Annex60.Utilities.Math.Functions.smoothLimit((Medium.specificEnthalpy(Medium.setState_pTX(p=p, T=TSet, X=Xi)) - h_outflow) * m_flow, - Modelica.Constants.inf, Q_flow_maxHeat, 0.1);
    elseif Q_flow_maxHeat == Modelica.Constants.inf and  Q_flow_maxCool <> - Modelica.Constants.inf then
      port.Q_flow = - Annex60.Utilities.Math.Functions.smoothLimit((Medium.specificEnthalpy(Medium.setState_pTX(p=p, T=TSet, X=Xi)) - h_outflow) * m_flow, Q_flow_maxCool, Q_flow_maxHeat, 0.1);
    else
      port.Q_flow = - (Medium.specificEnthalpy(Medium.setState_pTX(p=p, T=TSet, X=Xi)) - h_outflow) * m_flow;
    end if;
  else
    port.Q_flow = 0.0;
  end if;
*/
    annotation (
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
          100,100}}), graphics={
      Text(
        extent={{-154,138},{146,98}},
        textString="%name",
        lineColor={0,0,255})}),
  Documentation(info="<HTML>
  <p>
  This model allows a specified amount of heat flow rate to be \"injected\"
  into a thermal system at a given port. The amount of heat
  is given by the input signal T_set into the model. The heat flows into the
  component to which the component PrescribedHeatFlow is connected,
  if the input signal is positive.
  </p>
  </html>"),
         Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
          {100,100}}), graphics));
end PrescribedOutletState;
