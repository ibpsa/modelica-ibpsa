within IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data;
record Generic "Generic record definition for safety control blocks"
  extends Modelica.Icons.Record;
  parameter Boolean use_minRunTime
    "=false to ignore minimum runtime constraint"
  annotation (Dialog(group="OnOffControl"), choices(checkBox=true));
  parameter Modelica.Units.SI.Time minRunTime
    "Mimimum runtime" annotation (Dialog(group=
          "OnOffControl", enable=use_minRunTime));
  parameter Boolean use_minLocTime
    "=false to ignore minimum lock time"
    annotation (Dialog(group="OnOffControl"),
    choices(checkBox=true));
  parameter Modelica.Units.SI.Time minLocTime
    "Minimum lock time" annotation (Dialog(group=
          "OnOffControl", enable=use_minLocTime));
  parameter Boolean use_runPerHou
    "=false to ignore maximum runs per hour constraint"
    annotation (Dialog(group="OnOffControl"),
    choices(checkBox=true));
  parameter Integer maxRunPerHou
    "Maximum number of on/off cycles in one hour"
    annotation (Dialog(group="OnOffControl",
    enable=use_runPerHou));
  parameter Real ySetMin
    "Minimum relative compressor speed to be used if device needs to run longer"
        annotation (
          Dialog(group="OnOffControl",
          enable=use_minRunTime));
  parameter Boolean preYSet_start "Start value of pre(n) at initial time"
    annotation (
      Dialog(group="OnOffControl"),
      choices(checkBox=true));

  parameter Boolean use_opeEnv
    "=true to use a the operational envelope"
    annotation (
      Dialog(group="Operational Envelope"),
      choices(checkBox=true));
  parameter Real tabUppHea[:,2] "Upper envelope boundary for heating"
    annotation (
      Dialog(group="Operational Envelope",
      enable=use_opeEnv));
  parameter Real tabLowCoo[:,2] "Lower envelope boundary for cooling"
    annotation (
      Dialog(group="Operational Envelope",
      enable=use_opeEnv));
  parameter Modelica.Units.SI.TemperatureDifference dTHysOpeEnv=5
    "Hysteresis for operational envelopes of both upper and lower boundaries"
    annotation (Dialog(group="Operational Envelope", enable=use_opeEnv));

  parameter Boolean use_TUseOut=false
    "=true to use useful side outlet temperature for envelope, false for inlet"
    annotation (Dialog(group="Operational Envelope", enable=use_opeEnv));
  parameter Boolean use_TNotUseOut=true
    "=true to use not useful sides outlet temperature for envelope, false for inlet"
    annotation (Dialog(group="Operational Envelope", enable=use_opeEnv));
  parameter Boolean use_antFre
    "=true to enable antifreeze control"
    annotation (Dialog(group="Anti Freeze Control"), choices(checkBox=true));
  parameter Modelica.Units.SI.ThermodynamicTemperature TAntFre
    "Limit temperature for antifreeze control"
    annotation (Dialog(group="Anti Freeze Control", enable=use_antFre));
  parameter Real dTHysAntFre
    "Hysteresis interval width for antifreeze control"
    annotation (Dialog(group="Anti Freeze Control", enable=use_antFre));
  parameter Boolean use_minFlowCtr
    "=false to disable minimum mass flow rate requirements"
    annotation (choices(checkBox=true), Dialog(group="Mass flow rates"));
  parameter Real m_flowEvaMinPer
    "Percentage of mass flow rate in evaporator required to operate the device"
    annotation (Dialog(group="Mass flow rates", enable=use_minFlowCtr));
  parameter Real m_flowConMinPer
    "Percentage of mass flow rate in condenser required to operate the device"
    annotation (Dialog(group="Mass flow rates", enable=use_minFlowCtr));
    annotation (Icon(graphics, coordinateSystem(preserveAspectRatio=false)),
     Diagram(graphics, coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
  Base data definitions with parameters relevant
  to safety control of refrigerant machines.
</p>
<p>
  Typically, datasheets of manufacturers provide
  specific values for these assumptions. Some values are
  harder to get, e.g. the minimum and maximum for runtime or lock time.
</p>
</html>", revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>
"));
end Generic;
