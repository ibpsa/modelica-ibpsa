within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Verification.Verification_bertagnolio;
model ver_multipleBoreholes_bertagnolio_MB_C8x8
  extends Icons.VerificationModel;
  parameter Data.BorefieldStepResponse.Validation_bertagnolio_MB_A8x8
    bfSteRes
    annotation (Placement(transformation(extent={{-92,72},{-72,92}})));
  parameter Integer lenSim=3600*24*365;

  MultipleBoreHoles_Buildings multipleBoreholes(lenSim=lenSim, redeclare
      Borefield.Data.BorefieldStepResponse.Validation_bertagnolio_MB_A8x8
      bfSteRes)
    annotation (Placement(transformation(extent={{-34,-68},{36,2}})));
  Modelica.Blocks.Interfaces.RealOutput T_fts
    annotation (Placement(transformation(extent={{92,-10},{112,10}})));

  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
    tableOnFile=true,
    tableName="data",
    fileName=
        "E:/work/modelica/VerificationData/Bertagnolio/DataBertagnolio/q30asym_time.txt",
    offset={0},
    columns={2})
    annotation (Placement(transformation(extent={{-86,-44},{-66,-24}})));

equation
  multipleBoreholes.Q_flow = combiTimeTable.y[1]/100*bfSteRes.bfGeo.hBor*bfSteRes.bfGeo.nbBh;
  connect(multipleBoreholes.T_fts, T_fts)  annotation (Line(
      points={{1.5,-57.5},{62,-57.5},{62,0},{102,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    experiment(StopTime=3.1535e+007, __Dymola_NumberOfIntervals=100),
    __Dymola_experimentSetupOutput);
end ver_multipleBoreholes_bertagnolio_MB_C8x8;
