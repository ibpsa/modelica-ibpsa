within IBPSA.Fluid.HeatPumps.BaseClasses;
partial model LargeScaleWaterToWaterParameters
  "Model with parameters for large scale water-to-water heat pump"

  //Automatic calculation of mass flow rates and volumes of the evaporator
  // and condenser using linear regressions from data sheets of
  // heat pumps and chillers (water to water)

protected
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
  assert(
    autCalMEva_flow > autCalMMin_flow and autCalMEva_flow <90,
    "Given nominal power (QUse_flow_nominal) for auto-calculation of 
    evaporator and condenser data is outside the range of data sheets 
    considered. Please control the auto-calculated mass flows!",
    level=AssertionLevel.warning);
  assert(
    autCalVEva > autCalVMin and autCalVEva < 0.43,
  "Given nominal power (QUse_flow_nominal) for auto-calculation of evaporator 
  and condenser data is outside the range of data sheets considered. 
  Please control the auto-calculated volumes!",
    level=AssertionLevel.warning);


  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>To simplify the parametrization of the evaporator and condenser volumes and nominal mass flows there exists an option of automatic estimation based on the nominal usable power of the refrigerant machine. This function uses a linear correlation of these parameters, which was established from the linear regression of more than 20 data sets of water-to-water heat pumps from different manufacturers (e.g. Carrier, Trane, Lennox) ranging from about 25kW to 1MW nominal power. The linear regressions with coefficients of determination above 91&percnt; give a good approximation of these parameters. Nevertheless, estimates for machines outside the given range should be checked for plausibility during simulation. </p>
</html>", revisions="<html><ul>
  <li>
    <i>Novemeber 11, 2022</i> by Fabian Wuellhorst:<br/>
    Moved from PartialReversibleRefrigerantMachine based on the discussion in this issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end LargeScaleWaterToWaterParameters;
