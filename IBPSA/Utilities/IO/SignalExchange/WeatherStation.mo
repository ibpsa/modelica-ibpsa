within IBPSA.Utilities.IO.SignalExchange;
model WeatherStation
  "Implements typical weather measurements with signal exchange blocks"
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data"
    annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-112,
            -14},{-86,12}})));
  IBPSA.Utilities.IO.SignalExchange.Read reaTDryBul(description="Outside drybulb temperature measurement",
      y(unit="K")) "Outside drybulb temperature measurement"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  IBPSA.Utilities.IO.SignalExchange.Read reaRelHum(description="Outside relative humidity measurement",
      y(unit="1")) "Outside relative humidity measurement"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  IBPSA.Utilities.IO.SignalExchange.Read reaWinSpe(description="Wind speed measurement",
      y(unit="m/s")) "Wind speed measurement"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  IBPSA.Utilities.IO.SignalExchange.Read reaWinDir(description="Wind direction measurement",
      y(unit="rad")) "Wind direction measurement"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  IBPSA.Utilities.IO.SignalExchange.Read reaHGloHor(description="Global horizontal solar irradiation measurement",
      y(unit="W/m2")) "Global horizontal solar irradiation measurement"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  IBPSA.Utilities.IO.SignalExchange.Read reaNTot(description="Sky cover measurement",
      y(unit="1")) "Sky cover measurement"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  IBPSA.Utilities.IO.SignalExchange.Read reaPAtm(description=
        "Atmospheric pressure measurement",
      y(unit="Pa")) "Atmospheric pressure measurement"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Read reaHDifHor(description="Horizontal diffuse solar radiation measurement",
      y(unit="W/m2")) "Horizontal diffuse solar radiation measurement"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Read reaCeiHei(description="Cloud cover ceiling height measurement", y(unit=
          "m")) "Cloud cover ceiling height measurement"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Read reaTWetBul(description="Wet bulb temperature measurement", y(unit="K"))
    "Wet bulb temperature measurement"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Read reaTDewPoi(description="Dew point temperature measurement", y(unit="K"))
    "Dew point temperature measurement"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Read                                   reaTBlaSky(description=
        "Black-body sky temperature measurement", y(unit="K"))
    "Black-body sky temperature measurement"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Read reaHHorIR(description="Horizontal infrared irradiation measurement", y(
        unit="W/m2")) "Horizontal infrared irradiation measurement"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Read                                   reaHDirNor(description=
        "Direct normal radiation measurement", y(unit="W/m2"))
    "Direct normal radiation measurement"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Read reaCloTim(description="Day number with units of seconds", y(unit="s"))
    "Day number with units of seconds"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Read reaSolAlt(description="Solar altitude angle measurement", y(unit="rad"))
    "Solar altitude angle measurement"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Read reaNOpa(description="Opaque sky cover measurement", y(unit="1"))
    "Opaque sky cover measurement"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Read reaLat(description="Latitude of the location", y(unit="rad"))
    "Latitude of the location"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Read reaLon(description="Longitude of the location", y(unit="rad"))
    "Longitude of the location"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Read reaSolDec(description="Solar declination angle measurement", y(unit=
          "rad")) "Solar declination angle measurement"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Read reaSolHouAng(description="Solar hour angle measurement", y(unit="rad"))
    "Solar hour angle measurement"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Read reaSolTim(description="Solar time", y(unit="s")) "Solar time"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Read reaSolZen(description="Solar zenith angle measurement", y(unit="rad"))
    "Solar zenith angle measurement"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
equation
  connect(weaBus.TDryBul, reaTDryBul.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,90},{-42,90}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.relHum, reaRelHum.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,60},{-42,60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.winSpe, reaWinSpe.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,30},{-42,30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.winDir, reaWinDir.u) annotation (Line(
      points={{-100,0},{-42,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.HGloHor, reaHGloHor.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,-30},{-42,-30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.nTot, reaNTot.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,-60},{-42,-60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.pAtm, reaPAtm.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,-90},{-42,-90}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.HDifHor, reaHDifHor.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,76},{-10,76},{-10,90},{-2,90}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.HDirNor, reaHDirNor.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,46},{-10,46},{-10,60},{-2,60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.HHorIR, reaHHorIR.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,16},{-12,16},{-12,30},{-2,30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.TBlaSky, reaTBlaSky.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,-14},{-12,-14},{-12,0},{-2,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.TDewPoi, reaTDewPoi.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,-44},{-10,-44},{-10,-30},{-2,-30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.TWetBul, reaTWetBul.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,-74},{-10,-74},{-10,-60},{-2,-60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.ceiHei, reaCeiHei.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,-100},{-10,-100},{-10,-90},{-2,-90}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.cloTim, reaCloTim.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,76},{30,76},{30,90},{38,90}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.lat, reaLat.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,46},{30,46},{30,60},{38,60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.lon, reaLon.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,16},{30,16},{30,30},{38,30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.nOpa, reaNOpa.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,-14},{30,-14},{30,0},{38,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.solAlt, reaSolAlt.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,-44},{30,-44},{30,-30},{38,-30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.solDec, reaSolDec.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,-74},{30,-74},{30,-60},{38,-60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.solHouAng, reaSolHouAng.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,-100},{30,-100},{30,-90},{38,-90}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.solTim, reaSolTim.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,76},{70,76},{70,90},{78,90}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.solZen, reaSolZen.u) annotation (Line(
      points={{-100,0},{-60,0},{-60,46},{70,46},{70,60},{78,60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Documentation(info="<html>
<p>
This block enables the reading of weather measurements and their meta-data by an external
program without the need to explicitly propogate the signal to a top-level model.
This block utilizes a number of pre-configured instances of
<a href=\"modelica://IBPSA.Utilities.IO.SignalExchange.Read\">
IBPSA.Utilities.IO.SignalExchange.Read</a>
</p>
<h4>Typical use and important parameters</h4>
<p>
This block is typically used by the BOPTEST framework
(see <a href=\"https://github.com/ibpsa/project1-boptest\">BOPTEST</a>)
to identify and read weather measurements by test
controllers. It is used in combination with a dedicated parser to perform
this task (see <a href=\"https://github.com/ibpsa/project1-boptest/tree/master/parsing\">Parser Code</a>).
</p>
</html>",
revisions="<html>
<ul>
<li>
September 29, 2020 by David Blum:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1059\">#1059</a>.
</li>
</ul>
</html>"), Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,159},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-52,28},{-48,-80}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-52,82},{-54,26},{22,20},{40,14},{62,-6},{70,-4},{74,4},{48,
              32},{20,58},{-52,82}},
          lineColor={0,0,0},
          fillColor={255,170,85},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-64,82},{-42,26}},
          lineColor={0,0,0},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end WeatherStation;
