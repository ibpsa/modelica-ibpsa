within IBPSA.Electrical.DC.Sources.Validation;
model PVSystemSingleDiodeNISTValidation
  "Validation with empirical data from NIST for the date of 14.06.2016"
   extends Modelica.Icons.Example;
  PVSystem.PVSystemSingleDiode pVSystemSingleDiode(
    til=0.17453292519943,
    azi=0,
    redeclare
      IBPSA.Electrical.DC.Sources.BaseClasses.PVSystem.PVThermalEmpMountOpenRack
      partialPVThermal,
  n_mod=312,
  redeclare IBPSA.Electrical.DataBase.PV1DiodeSharpNUU235F2 data,
    groRef=0.2,
    lat=0.68304158408499,
    lon=-1.3476664539029,
    alt=0.08,
    timZon=-18000)
    annotation (Placement(transformation(extent={{2,0},{22,20}})));
  Modelica.Blocks.Sources.CombiTimeTable NISTdata(
    tableOnFile=true,
    tableName="Roof2016",
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://IBPSA/Resources/weatherdata/NIST_onemin_Roof_2016.txt"),
    columns={3,5,2,4},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    "The PVSystem model is validaded with measurement data from: https://pvdata.nist.gov/ "
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  Modelica.Blocks.Math.UnitConversions.From_degC from_degC
    annotation (Placement(transformation(extent={{-34,6},{-26,14}})));
  Modelica.Blocks.Interfaces.RealOutput PSim "Simulated DC output power"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  Modelica.Blocks.Math.Gain kiloWattToWatt(k=1000)
    annotation (Placement(transformation(extent={{6,-36},{18,-24}})));
  Modelica.Blocks.Interfaces.RealOutput PMea "Measured DC power"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
equation
  connect(NISTdata.y[1], from_degC.u)
    annotation (Line(points={{-59,10},{-34.8,10}}, color={0,0,127}));
  connect(from_degC.y, pVSystemSingleDiode.TDryBul) annotation (Line(points={{-25.6,
          10},{-6,10},{-6,16.3},{2.1,16.3}}, color={0,0,127}));
  connect(NISTdata.y[3], pVSystemSingleDiode.HGloHor) annotation (Line(points={{
          -59,10},{-46,10},{-46,19.1},{2.1,19.1}}, color={0,0,127}));
  connect(NISTdata.y[2], pVSystemSingleDiode.vWinSpe) annotation (Line(points={{
          -59,10},{-46,10},{-46,-12},{-6,-12},{-6,13.7},{2.1,13.7}}, color={0,0,
          127}));
  connect(pVSystemSingleDiode.P, PSim)
    annotation (Line(points={{22.4,10},{110,10}}, color={0,0,127}));
  connect(NISTdata.y[4], kiloWattToWatt.u) annotation (Line(points={{-59,10},{-46,
          10},{-46,-30},{4.8,-30}}, color={0,0,127}));
  connect(kiloWattToWatt.y, PMea)
    annotation (Line(points={{18.6,-30},{110,-30}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false), graphics={
                                                               Text(
          extent={{-84,68},{-26,34}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="1 - Air temperature in °C
2 - Wind speed in m/s
3 - Global horizontal irradiance in W/m2
4 - Ouput power in kW")}),
    Documentation(info="<html><p>
  The PVSystem model is validaded with empirical data from: <a href=
  \"https://pvdata.nist.gov/\">https://pvdata.nist.gov/</a>
</p>
<p>
  The date 14.06.2016 was chosen as an example for the PVSystem model.
</p>
<p>
  The PV mounting is an open rack system based on the ground.
</p>
</html>"),
    experiment(
      StartTime=28684800,
      StopTime=28771200,
      Interval=10,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end PVSystemSingleDiodeNISTValidation;
