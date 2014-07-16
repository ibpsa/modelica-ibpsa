within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.BaseClasses.BoreHoles.Verification.Verification_Spitler_WetterDaP;
model TRNSYS_Spitler "Spitler experiment with constant load"
  extends Icons.VerificationModel;

  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
    tableOnFile=true,
    tableName="data",
    fileName=
        "E:/work/modelica/VerificationData/Spitler/SpitlerTRNSYS_TinTout_modelica.txt",
    offset={0,0},
    columns={2,3})
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

  Modelica.SIunits.Temperature T_sup "water supply temperature";
  Modelica.SIunits.Temperature T_ret "water return temperature";
  Modelica.SIunits.Temperature T_f "average fluid temperature";

equation
  T_sup = combiTimeTable.y[1] + 273.15;
  T_ret = combiTimeTable.y[2] + 273.15;

  T_f = (T_sup + T_ret)/2;

  annotation (
    experiment(StopTime=186350),
    __Dymola_experimentSetupOutput,
    Commands(file="../Scripts/SpitlerValidation_plot.mos" "plot"));
end TRNSYS_Spitler;
