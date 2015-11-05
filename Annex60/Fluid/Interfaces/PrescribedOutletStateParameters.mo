within Annex60.Fluid.Interfaces;
record PrescribedOutletStateParameters
  "Parameters for models with prescribed outlet state"

  parameter SI.HeatFlowRate Q_flow_maxHeat = Modelica.Constants.inf
    "Maximum heat flow rate for heating (positive)";
  parameter SI.HeatFlowRate Q_flow_maxCool = -Modelica.Constants.inf
    "Maximum heat flow rate for cooling (negative)";

  parameter SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate, used for regularization near zero flow"
    annotation(Dialog(group = "Nominal condition"));

  parameter SI.Time tau(min=0) = 10
    "Time constant at nominal flow rate (used if energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState)"
    annotation(Dialog(tab = "Dynamics"));
  parameter SI.Temperature T_start
    "Initial or guess value of set point"
    annotation (Dialog(tab = "Dynamics", group="Initialization"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState
    "Formulation of energy balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

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
