within IBPSA.Fluid.HeatPumps.Validation;
model HeatPump_EuropeanNormData
  extends BaseClasses.PartialHeatPumpValidation(heaPum(
      mCon_flow_nominal=mCon_flow_nominal,
      tauCon=VCon*heaPum.rhoCon/mCon_flow_nominal,
      redeclare model VapourCompressionCycleInertia =
          IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.RefrigerantCycleInertias.VariableOrderInertia
          (
          refIneFre_constant=refIneFre_constant,
          nthOrder=2,
          initType=Modelica.Blocks.Types.Init.InitialState),
      redeclare model BlackBoxHeatPumpHeating =
          IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2D (datTab=
              IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.HeatPumpBaseDataDefinition(
              tableQCon_flow=[0,0,10; 35,6100,8400; 55,5700,7600],
              tablePel=[0,0,10; 35,1300,1500; 55,1900,2300],
              mCon_flow_nominal=6100/5/4184,
              mEva_flow_nominal=4800/5/4184,
              tableUppBou=[-40,70; 40,70],
              device_id="Vaillaint_VWL101"))));

  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal=0.404317
    "Condenser nominal mass flow rate"
    annotation (Evaluate=false);
  parameter Modelica.Units.SI.Volume VCon=0.004473
    "Condenser volume"
    annotation (Evaluate=false);
  parameter Modelica.Units.SI.Frequency refIneFre_constant=0.011848
    "Cut off frequency for inertia of refrigerant cycle"
    annotation (Evaluate=false);

  annotation (experiment(Tolerance=1e-6, StopTime=14365),
    __Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Fluid/HeatPumps/Validation/HeatPump_EuropeanNormData.mos"
            "Simulate and plot"),
    Documentation(info="<html>
<p>This example extends from <a href=\"modelica://IBPSA.Fluid.HeatPumps.Validation.BaseClasses.PartialHeatPumpValidation\">IBPSA.Fluid.HeatPumps.Validation.BaseClasses.PartialHeatPumpValidation</a> </p>
<p>It uses table based data for the heat pump. </p>
<p>The approach was calibrated as a comparison to constant quality grade 
efficiency in the conference paper for the heat pump model: 
<a href=\"https://doi.org/10.3384/ecp21181561\">https://doi.org/10.3384/ecp21181561</a></p>
</html>",     revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end HeatPump_EuropeanNormData;
