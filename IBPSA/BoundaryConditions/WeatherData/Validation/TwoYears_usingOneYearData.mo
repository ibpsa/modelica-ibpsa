within IBPSA.BoundaryConditions.WeatherData.Validation;
model TwoYears_usingOneYearData
  "Validation model for a data reader that has data spanning only some hours in December to January"
  extends Modelica.Icons.Example;
  IBPSA.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    computeWetBulbTemperature=false,
    TDewPoiSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
    HInfHorSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
    HInfHor=100,
    calTSky=IBPSA.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation,
    filNam=Modelica.Utilities.Files.loadResource(
        "modelica://IBPSA/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data reader with data file going from December to January"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  annotation (experiment(
      StartTime=30992400,
      StopTime=31860000,
      Interval=3600,
      Tolerance=1e-006),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/Validation/DecemberToJanuary.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>This is a validation case for a a simulation extending with two montgs over one year but using data for only one year.</p>
</html>", revisions="<html>
<ul>
<li>September 3, 2018 by Ana Constantin:<br>First implementation for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/842\">issue 842</a>. </li>
</ul>
</html>"));

end TwoYears_usingOneYearData;
