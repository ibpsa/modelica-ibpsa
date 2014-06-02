within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.BaseClasses.BoreHoles.Verification.Verification_Spitler_WetterDaP;
model UTubeStepLoadExperiement_Spitler "Spitler experiment with constant load"
  extends Icons.VerificationModel;

  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
    tableOnFile=true,
    tableName="data",
    fileName=
        "E:/work/modelica/VerificationData/Spitler/SpitlerCstLoad_Time_Tsup_Tret_deltaT.txt",
    offset={0,0,0},
    columns={2,3,4})
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable2(
    tableOnFile=true,
    tableName="data",
    fileName=
        "E:/work/modelica/VerificationData/Spitler/SpitlerCstLoad_Time_Tb_Tb24_Tb44_Tb65_Tb85.txt",
    offset={0,0,0,0,0},
    columns={2,3,4,5,6})
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));

  Modelica.SIunits.Temperature T_sup "water supply temperature";
  Modelica.SIunits.Temperature T_ret "water return temperature";
  Modelica.SIunits.Temperature T_f "average fluid temperature";
  Modelica.SIunits.TemperatureDifference deltaT_fb
    "temperature difference between T_f and T_b";

  Modelica.SIunits.Temperature T_b "borehole wall temperature";
  Modelica.SIunits.Temperature T_b24 "sand temperature at 24cm";
  Modelica.SIunits.Temperature T_b44 "sand temperature at 44cm";
  Modelica.SIunits.Temperature T_b65 "sand temperature at 65cm";
  Modelica.SIunits.Temperature T_b85 "sand temperature at 85cm";

  Modelica.SIunits.TemperatureDifference T_delta24;
  Modelica.SIunits.TemperatureDifference T_delta44;
  Modelica.SIunits.TemperatureDifference T_delta65;
  Modelica.SIunits.TemperatureDifference T_delta85;

equation
  T_sup = combiTimeTable.y[1] + 273.15;
  T_ret = combiTimeTable.y[2] + 273.15;

  T_b = combiTimeTable2.y[1] + 273.15;
  T_b24 = combiTimeTable2.y[2] + 273.15;
  T_b44 = combiTimeTable2.y[3] + 273.15;
  T_b65 = combiTimeTable2.y[4] + 273.15;
  T_b85 = combiTimeTable2.y[5] + 273.15;

  T_delta24 = T_b24 - T_b;
  T_delta44 = T_b44 - T_b24;
  T_delta65 = T_b65 - T_b44;
  T_delta85 = T_b85 - T_b65;

  T_f = (T_sup + T_ret)/2;
  deltaT_fb = T_f - T_b;

  annotation (experiment(StopTime=186350), __Dymola_experimentSetupOutput);
end UTubeStepLoadExperiement_Spitler;
