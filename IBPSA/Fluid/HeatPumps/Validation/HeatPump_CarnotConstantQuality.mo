within IBPSA.Fluid.HeatPumps.Validation;
model HeatPump_CarnotConstantQuality
  extends BaseClasses.PartialHeatPumpValidation(heaPum(
      QUse_flow_nominal=qualityGrade*PEl_nominal*heaPum.TCon_nominal/(heaPum.TCon_nominal
           - heaPum.TEva_nominal),
      mCon_flow_nominal=mCon_flow_nominal,
      tauCon=VCon*heaPum.rhoCon/mCon_flow_nominal,
      redeclare model VapourCompressionCycleInertia =
          IBPSA.Fluid.HeatPumps.BlackBoxData.VapourCompressionInertias.VariableOrderInertia
          (
          refIneFre_constant=refIneFre_constant,
          nthOrder=2,
          initType=Modelica.Blocks.Types.Init.InitialState),
      redeclare model BlackBoxHeatPumpHeating =
          IBPSA.Fluid.HeatPumps.BlackBoxData.ConstantQualityGrade (quaGra=
              qualityGrade)));
  parameter Real qualityGrade=0.4318
    "Constant quality grade" annotation(Evaluate=false);

  parameter Modelica.Units.SI.Power PEl_nominal=1884.218212;
//    annotation (Evaluate=false);

  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal=0.407396
    "Condenser nominal mass flow rate"
    annotation (Evaluate=false);
  parameter Modelica.Units.SI.Volume VCon=0.0015972
    "Condenser volume"
    annotation (Evaluate=false);
  parameter Modelica.Units.SI.Frequency refIneFre_constant=13.2e-3
    "Cut off frequency for inertia of refrigerant cycle"
    annotation (Evaluate=false);

annotation (experiment(Tolerance=1e-6, StopTime=14365),
  __Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Fluid/HeatPumps/Validation/HeatPump_CarnotConstantQuality.mos"
          "Simulate and plot"),
  Documentation(info="<html><p>This example extends from 
<a href=\"modelica://IBPSA.Fluid.HeatPumps.Validation.BaseClasses.PartialHeatPumpValidation\">IBPSA.Fluid.HeatPumps.Validation.BaseClasses.PartialHeatPumpValidation</a>.</p>
<p>It uses a constant quality grade to model the efficiency of the heat pump. </p>
<p>The approach was calibrated as a comparison to table based data in 
the conference paper for the heat pump model: 
<a href=\"https://doi.org/10.3384/ecp21181561\">https://doi.org/10.3384/ecp21181561 </a></p>
</html>",   revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end HeatPump_CarnotConstantQuality;
