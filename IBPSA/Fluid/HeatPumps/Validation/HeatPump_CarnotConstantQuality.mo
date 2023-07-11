within IBPSA.Fluid.HeatPumps.Validation;
model HeatPump_CarnotConstantQuality
  extends BaseClasses.PartialHeatPumpValidation(heaPum(
      QUse_flow_nominal=quaGra*PEle_nominal*heaPum.TCon_nominal/(heaPum.TCon_nominal
           - heaPum.TEva_nominal),
      mCon_flow_nominal=mCon_flow_nominal,
      tauCon=VCon*heaPum.rhoCon/mCon_flow_nominal,
      redeclare model RefrigerantCycleInertia =
          IBPSA.Fluid.HeatPumps.RefrigerantCycle.Inertias.VariableOrder
          (
          refIneFreConst=refIneFreConst,
          nthOrd=2,
          initType=Modelica.Blocks.Types.Init.InitialState),
      redeclare model RefrigerantCycleHeatPumpHeating =
          IBPSA.Fluid.HeatPumps.RefrigerantCycle.ConstantQualityGrade (
          useAirForCon=false,
          useAirForEva=false,
          quaGra=quaGra)));
  parameter Real quaGra=0.4318 "Calibrated constant quality grade";

  parameter Modelica.Units.SI.Power PEle_nominal=1884.218212
    "Calibrated nominal electrical power";

  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal=0.407396
    "Calibrated condenser nominal mass flow rate";
  parameter Modelica.Units.SI.Volume VCon=0.0015972
    "Calibrated condenser volume";
  parameter Modelica.Units.SI.Frequency refIneFreConst=13.2e-3
    "Calibrated cut off frequency for inertia of refrigerant cycle";

annotation (experiment(Tolerance=1e-6, StopTime=14365),
  __Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Fluid/HeatPumps/Validation/HeatPump_CarnotConstantQuality.mos"
          "Simulate and plot"),
  Documentation(info="<html>
<p>
  This validation case uses a constant quality 
  grade to model the efficiency of the heat pump. 
</p>
<p>
  The approach was calibrated as a comparison to table based data in 
  the conference paper for the heat pump model: 
  <a href=\"https://doi.org/10.3384/ecp21181561\">
  https://doi.org/10.3384/ecp21181561 </a>
</p>
</html>",   revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end HeatPump_CarnotConstantQuality;
