within IBPSA.Fluid.HeatPumps.Validation;
model HeatPump_CarnotConstantQuality
  extends BaseClasses.PartialHeatPumpValidation(heatPump(
      QUse_flow_nominal=qualityGrade*PEl_nominal*heatPump.TCon_nominal/(
          heatPump.TCon_nominal - heatPump.TEva_nominal),
      redeclare model VapourCompressionCycleInertia =
          IBPSA.Fluid.HeatPumps.BlackBoxData.VapourCompressionInertias.VariableOrderInertia
          (
          refIneFre_constant=refIneFre_constant,
          nthOrder=2,
          initType=Modelica.Blocks.Types.Init.InitialState),
      mCon_flow_nominal=mCon_flow_nominal,
      VCon=VCon,
      redeclare model BlackBoxHeatPumpHeating =
          IBPSA.Fluid.HeatPumps.BlackBoxData.ConstantQualityGrade (qualityGrade=
             qualityGrade)));
  parameter Real qualityGrade=0.4318 "Constant quality grade" annotation(Evaluate=false);

  parameter Modelica.Units.SI.Power PEl_nominal=1884.218212;
//    annotation (Evaluate=false);

  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal=0.407396
    "Manual input of the nominal mass flow rate (if not automatically calculated)"
    annotation (Evaluate=false);
  parameter Modelica.Units.SI.Volume VCon=0.0015972
    "Manual input of the condenser volume (if not automatically calculated)"
    annotation (Evaluate=false);
  parameter Modelica.Units.SI.Frequency refIneFre_constant=13.2e-3
    "Cut off frequency for inertia of refrigerant cycle"
    annotation (Evaluate=false);

  annotation (experiment(Tolerance=1e-6, StopTime=14365),
    __Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Fluid/HeatPumps/Validation/HeatPump_CarnotConstantQuality.mos"
            "Simulate and plot"),
    Documentation(info="<html>
<p>This example extends from <a href=\"modelica://IBPSA.Fluid.HeatPumps.Validation.BaseClasses.PartialHeatPumpValidation\">IBPSA.Fluid.HeatPumps.Validation.BaseClasses.PartialHeatPumpValidation</a> and used a constant quality grade to model the efficiency of the heat pump. The approach was calibrated as a comparison to table based data in the conference paper for the heat pump model: <a href=\"https://doi.org/10.3384/ecp21181561\">https://doi.org/10.3384/ecp21181561 </a></p>
</html>",     revisions="<html>
    <ul>
    <li>
    September 09, 2022, by Fabian Wuellhorst:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end HeatPump_CarnotConstantQuality;
