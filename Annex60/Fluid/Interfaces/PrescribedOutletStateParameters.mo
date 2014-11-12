within Annex60.Fluid.Interfaces;
record PrescribedOutletStateParameters
  "Parameters for models with prescribed outlet state"

  parameter Modelica.SIunits.HeatFlowRate Q_flow_maxHeat = Modelica.Constants.inf
    "Maximum heat flow rate for heating (positive)";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_maxCool = -Modelica.Constants.inf
    "Maximum heat flow rate for cooling (negative)";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min=0)
    "Nominal mass flow rate, used for regularization near zero flow"
    annotation(Dialog(group = "Nominal condition"));

  parameter Modelica.SIunits.Time tau(min=0) = 0
    "Time constant at nominal flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature T_start
    "Initial or guess value of set point"
    annotation (Dialog(group="Initialization"));
  parameter Modelica.Blocks.Types.Init initType = Modelica.Blocks.Types.Init.InitialState
    "Type of initialization (InitialState and InitialOutput are identical)"
  annotation(Evaluate=true, Dialog(group="Initialization"));

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
