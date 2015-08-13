within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.Validation;
model SandBoxExperiment
  "Comparison of the borehole model with the sandbox experiment. Notice, the temperature difference is due to the fin-effect present in the experiment."
  extends Examples.SingleBoreHoleUTubeSerStepLoad(
    redeclare Data.SoilData.WetSand_validation soi,
    redeclare Data.FillingData.Bentonite_validation fil,
    redeclare Data.GeneralData.SandBox_validation gen);
  Modelica.Blocks.Sources.CombiTimeTable sandBoxMea(
    tableOnFile=true,
    tableName="data",
    fileName=
        Modelica.Utilities.Files.loadResource(
      "modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/BaseClasses/BoreHoles/Validation/SpitlerCstLoad_Time_Tsup_Tret_deltaT.txt"),
    offset={0,0,0},
    columns={2,3,4})
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));

  Modelica.SIunits.Temperature TSup_sandBox = sandBoxMea.y[1] + 273.15;
  Modelica.SIunits.Temperature TRet_sandBox = sandBoxMea.y[2] + 273.15;
    annotation (Placement(transformation(extent={{-20,30},{0,50}})),
    experiment(StopTime=186350, __Dymola_NumberOfIntervals=5000),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>
The model is compared with the sandbox experiment done by Beier et al (2011). As described by Picard and Helsen (2014), the computed temperatures differs from the measurements due to the aluminium casting that Beier et al used in the experiment. This cast around the grout works as a fine and therefore decreases the borehole resistance.
</p>
<p>
Beier, R., Smith, M, Spitler, J, Reference data sets for vertical borehole ground heat exchanger models and thermal response test analysis, Geothermics 40 (2011).</a>.
</p>
</html>", revisions="<html>
<ul>
<li>January 2015, Damien Picard: first implementation.</li>
</ul>
</html>"),
    __Dymola_Commands(file="modelica://IDEAS/Resources/Scripts/Dymola/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/BaseClasses/BoreHoles/Validation/SandBoxExperiment.mos"
        "Simulate and Plot"));
end SandBoxExperiment;
