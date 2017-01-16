within IDEAS.Examples.TwinHouses.BaseClasses;
model TwinHouseInfoManager
  extends IDEAS.BoundaryConditions.SimInfoManager(
    weaDat(
      pAtmSou=IDEAS.BoundaryConditions.Types.DataSource.Parameter,
      ceiHeiSou=IDEAS.BoundaryConditions.Types.DataSource.Parameter,
      ceiHei=7,
      HSou=IDEAS.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HDifHor,
      totSkyCovSou=IDEAS.BoundaryConditions.Types.DataSource.Parameter,
      opaSkyCovSou=IDEAS.BoundaryConditions.Types.DataSource.Parameter,
      calTSky=IDEAS.BoundaryConditions.Types.SkyTemperatureCalculation.TemperaturesAndSkyCover,
      totSkyCov=0.6,
      opaSkyCov=0.6),
    linIntRad=false,
    linExtRad=false,
    radSol(each rho=0.23),
    lat=0.83555892609977,
    lon=0.20469221467389,
    final filNam=filNam2);
  parameter Integer exp = 1 "Experiment number: 1 or 2";
  parameter Integer bui = 1 "Building number 1 (N2), 2 (O5)";
  final parameter String filNam3 = (if exp == 1 and bui == 1 then "validationdataN2Exp1.txt" elseif exp==2 and bui == 1 then "validationdataExp2.txt" else "validationdataO5Exp1.txt");
  final parameter String dirPath = Modelica.Utilities.Files.loadResource("modelica://IDEAS/Inputs/")    annotation(Evaluate=true);

  Modelica.Blocks.Sources.CombiTimeTable inputSolTTH(
    tableOnFile=true,
    tableName="data",
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative2,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    final fileName=dirPath+filNam3,
    columns= (if exp== 1 then 37:42 else {55,56,58,59,60,61}))
    "input for solGloHor and solDifHor measured at TTH"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  RadiationConvertor radCon(final lat=lat, final lon=lon,
    rho={radSol[1].rho,radSol[1].rho,radSol[1].rho})
    annotation (Placement(transformation(extent={{-30,-82},{-10,-62}})));
protected
  final parameter String filNam2 = (if exp == 1  then "WeatherTwinHouseExp1.txt" else "WeatherTwinHouseExp2.txt")
    annotation(Evaluate=true);
  final parameter String filPat = dirPath+filNam2
    annotation(Evaluate=true);

equation
  connect(weaDat.HDirNor_in, radCon.solDirPer);
  connect(weaDat.HDifHor_in, radCon.solDifHor);

  connect(radCon.solHouAng, hour.y) annotation (Line(points={{-30.4,-78.6},{-44,
          -78.6},{-44,24},{-90,24},{-90,44},{-103,44}},
                                                 color={0,0,127}));
  connect(radCon.angDec, dec.y) annotation (Line(points={{-30.4,-76},{-42,-76},{
          -42,22},{-92,22},{-92,32},{-103,32}}, color={0,0,127}));
  connect(inputSolTTH.y[4], radCon.H_east) annotation (Line(points={{-79,-30},{-36,
          -30},{-36,-64},{-30.4,-64}}, color={0,0,127}));
  connect(inputSolTTH.y[5], radCon.H_south) annotation (Line(points={{-79,-30},{
          -38,-30},{-38,-68},{-30.4,-68}}, color={0,0,127}));
  connect(inputSolTTH.y[6], radCon.H_west) annotation (Line(points={{-79,-30},{-40,
          -30},{-40,-72},{-30.4,-72}}, color={0,0,127}));
  connect(radCon.F2, skyBrightnessCoefficients.F2) annotation (Line(points={{
          -30.4,-57.4},{-30.4,50},{-5,50},{-5,66}}, color={0,0,127}));
  connect(radCon.F1, skyBrightnessCoefficients.F1) annotation (Line(points={{
          -30.4,-60.4},{-28,-60.4},{-28,46},{-2,46},{-2,74},{-5,74}}, color={0,
          0,127}));
  connect(radCon.angZen, zenithAngle.y) annotation (Line(points={{-30.4,-81.2},
          {-46,-81.2},{-46,30},{-84,30},{-84,56},{-103,56}}, color={0,0,127}));
  annotation (
      defaultComponentName="sim",
    defaultComponentPrefixes="inner",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TwinHouseInfoManager;
