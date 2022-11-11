within IBPSA.Fluid.HeatPumps.BaseClasses;
partial model LargeScaleWaterToWaterParameters
  "Model with parameters for large scale water-to-water heat pump"

  //Automatic calculation of mass flow rates and volumes of the evaporator
  // and condenser using linear regressions from data sheets of
  // heat pumps and chillers (water to water)
  parameter Boolean use_autoCalc=false
    "Enable automatic estimation of volumes and mass flows 
    for water-to-water devices in a range of 25 kW to 1 MW"
    annotation(choices(checkBox=true),
    Dialog(group="Water-to-water Parameterization"));
protected
  parameter Modelica.Units.SI.HeatFlowRate QUseErrChe_flow_nominal
    "Nominal heat flow rate at, used for error check and is given by device model"
    annotation (Dialog(group="Nominal Design"));
  parameter Modelica.Units.SI.MassFlowRate autCalMMin_flow=0.3
    "Realistic mass flow minimum for simulation plausibility";
  parameter Modelica.Units.SI.Volume autCalVMin=0.003
    "Realistic volume minimum for simulation plausibility";

  parameter Modelica.Units.SI.MassFlowRate autCalMEva_flow;
  parameter Modelica.Units.SI.MassFlowRate autCalMCon_flow;
  parameter Modelica.Units.SI.Volume autCalVEva;
  parameter Modelica.Units.SI.Volume autCalVCon;

initial equation
  //Control and feedback for the auto-calculation of condenser and evaporator data
  assert(not use_autoCalc or (use_autoCalc and QUseErrChe_flow_nominal>0),
    "Can't auto-calculate evaporator and condenser data 
    without a given nominal power flow (QUse_flow_nominal)!",
  level = AssertionLevel.error);
  assert(
    not use_autoCalc or (autCalMEva_flow > autCalMMin_flow and autCalMEva_flow <
      90),
    "Given nominal power (QUse_flow_nominal) for auto-calculation of 
    evaporator and condenser data is outside the range of data sheets 
    considered. Please control the auto-calculated mass flows!",
    level=AssertionLevel.warning);
  assert(
    not use_autoCalc or (autCalVEva > autCalVMin and autCalVEva < 0.43),
    "Given nominal power (QUse_flow_nominal) for auto-calculation of evaporator 
  and condenser data is outside the range of data sheets considered. 
  Please control the auto-calculated volumes!",
    level=AssertionLevel.warning);


  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p></span><span style=\"font-size: 9.75pt;\">TODO: Add doc and revision</p>
</html>"));
end LargeScaleWaterToWaterParameters;
