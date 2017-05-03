within IBPSA.Fluid.Interfaces;
record PrescribedOutletStateParameters
  "Parameters for models with prescribed outlet state"

  replaceable package _Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  parameter Modelica.SIunits.HeatFlowRate Q_flow_maxHeat(min=0) = Modelica.Constants.inf
    "Maximum heat flow rate for heating (positive)"
    annotation (Evaluate=true, Dialog(enable=use_TSet));
  parameter Modelica.SIunits.HeatFlowRate Q_flow_maxCool(max=0) = -Modelica.Constants.inf
    "Maximum heat flow rate for cooling (negative)"
    annotation (Evaluate=true, Dialog(enable=use_TSet));
  parameter Modelica.SIunits.HeatFlowRate m_flow_maxHumidification(min=0) = Modelica.Constants.inf
    "Maximum heat flow rate for heating (positive)"
    annotation (Evaluate=true, Dialog(enable=use_XiSet));

  parameter Modelica.SIunits.HeatFlowRate m_flow_maxDehumidification(max=0) = -Modelica.Constants.inf
    "Maximum heat flow rate for cooling (negative)"
    annotation (Evaluate=true, Dialog(enable=use_XiSet));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate, used for regularization near zero flow"
    annotation(Dialog(group = "Nominal condition"));

  parameter Modelica.SIunits.Time tau(min=0) = 10
    "Time constant at nominal flow rate (used if energyDynamics or massDynamics not equal Modelica.Fluid.Types.Dynamics.SteadyState)"
    annotation(Dialog(tab = "Dynamics"));
  parameter _Medium.Temperature T_start=_Medium.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", enable=use_TSet));
  parameter _Medium.MassFraction X_start[_Medium.nX](
       quantity=_Medium.substanceNames) = _Medium.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=use_XiSet and _Medium.nXi > 0));

  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations", enable=use_TSet));

  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations", enable=use_XiSet));

  parameter Boolean use_TSet = true
    "Set to false to disable temperature set point"
    annotation(Evaluate=true);

  parameter Boolean use_XiSet = true
    "Set to false to disable water vapor set point"
    annotation(Evaluate=true);

  annotation (Documentation(info="<html>
<p>
This record declares parameters that are used by models with
prescribed outlet temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
November 10, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PrescribedOutletStateParameters;
