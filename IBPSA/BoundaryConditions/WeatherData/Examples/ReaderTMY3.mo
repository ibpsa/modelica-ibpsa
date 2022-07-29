within IBPSA.BoundaryConditions.WeatherData.Examples;
model ReaderTMY3 "Test model for reading weather data"
  extends Modelica.Icons.Example;
  IBPSA.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource(
        "D://01_Projekte//03_Mitsubishi_HiL//TRY2015_Jahr_City_Aachen.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  IBPSA.BoundaryConditions.WeatherData.ReaderTMY3 weaDatInpCon(filNam=
        Modelica.Utilities.Files.loadResource("D://01_Projekte//03_Mitsubishi_HiL//TRY2015_Jahr_City_Aachen_savecopy.mos"),
      HSou=IBPSA.BoundaryConditions.Types.RadiationDataSource.File)
    "Weather data reader with radiation data obtained from input connector"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Modelica.Blocks.Sources.Constant HDifHor(k=0) "Diffuse horizontal radiation"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Sources.Constant HGloHor(k=0) "Horizontal global radiation"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  annotation (experiment(Tolerance=1e-6, StartTime=0, StopTime=8640000),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/Examples/ReaderTMY3.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the TMY3 data reader.
The instance <code>weaDat</code> obtains all weather data from the weather file,
whereas the instance <code>weaDatInpCon</code> obtains the global horizontal and
the diffuse horizontal solar radiation from its input connectors.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 25, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReaderTMY3;
