within IBPSA.Electrical.Examples;
model PVSystemSingleDiode
  extends Modelica.Icons.Example;
  PVSystem.PVSystemSingleDiode pVSystemSingleDiode(
    til=0.5235987755983,
    azi=0,
    ageing=1) annotation (Placement(transformation(extent={{-8,-4},{28,20}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "D:/05_Offline/modelica-ibpsa/IBPSA/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  BoundaryConditions.WeatherData.Bus weaBus1
             "Weather data bus"
    annotation (Placement(transformation(extent={{-58,40},{-38,60}})));
equation
  connect(weaDat.weaBus, weaBus1) annotation (Line(
      points={{-60,50},{-48,50}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus1.HGloHor, pVSystemSingleDiode.HGloHor) annotation (Line(
      points={{-48,50},{-36,50},{-36,22},{-7.82,22},{-7.82,18.92}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus1.TDryBul, pVSystemSingleDiode.TDryBul) annotation (Line(
      points={{-48,50},{-42,50},{-42,15.56},{-7.82,15.56}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus1.winSpe, pVSystemSingleDiode.vWinSpe) annotation (Line(
      points={{-48,50},{-48,12.44},{-7.82,12.44}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PVSystemSingleDiode;
