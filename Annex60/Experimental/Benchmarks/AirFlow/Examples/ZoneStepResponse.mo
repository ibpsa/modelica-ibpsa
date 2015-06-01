within Annex60.Experimental.Benchmarks.AirFlow.Examples;
model ZoneStepResponse
  "Example to test the thermal step response of a SimpleZone"
  extends Modelica.Icons.Example;

  replaceable package Medium = Modelica.Media.Air.SimpleAir;

  output Modelica.SIunits.Temperature TRoom
    "Room temperature at volume's therm port";

  Components.SimpleZone simpleZone(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Fluid.Sources.MassFlowSource_T boundary(nPorts=1, m_flow=0.05,
    redeclare package Medium = Medium,
    use_T_in=true)
    annotation (Placement(transformation(extent={{-60,-2},{-40,18}})));
  Fluid.Sources.FixedBoundary bou(nPorts=2, redeclare package Medium = Medium)
                                            annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,0})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam="modelica://Annex60/Resources/weatherdata/STEP_TMY3.mos")
    annotation (Placement(transformation(extent={{-62,-52},{-42,-32}})));
  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-104,14},{-64,54}}), iconTransformation(extent=
            {{-116,30},{-96,50}})));
equation
  TRoom = simpleZone.volRoom.heatPort.T;

  connect(boundary.ports[1], simpleZone.port_a_vent) annotation (Line(
      points={{-40,8},{-10,8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone.port_b, bou.ports[1]) annotation (Line(
      points={{10,-6},{26,-6},{26,-2},{40,-2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone.port_a, bou.ports[2]) annotation (Line(
      points={{10,6},{26,6},{26,2},{40,2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus, simpleZone.weaBus) annotation (Line(
      points={{-42,-42},{-26,-42},{-26,4},{-11.8,4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(boundary.T_in, weaBus.TDryBul) annotation (Line(
      points={{-62,12},{-70,12},{-70,34},{-84,34}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-42,-42},{-26,-42},{-26,-16},{-84,-16},{-84,34}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=6e+006, __Dymola_NumberOfIntervals=5000),
    __Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Experimental/Benchmarks/AirFlow/Examples/ZoneStepResponse.mos"
        "Simulate and plot"),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>This example tests the step response of the SimpleZone model for the airflow benchmark. It uses the weather file STEP_TMY.mos, that implements a 5 K step at 400 000 s. In the Buildings library, the Room model in BESTEST 600 FF needs around 4-5 hours in order to reach 2/3 of the maximum step response to this weather file. This time constant is approximated with a value of mSenFac = 75 for the Zone&apos;s mixing volume.</p>
<p>The mass flow rate of air to the zone at 0.05 kg/s approximates an air exchange rate of 3 times the air volume per hour.</p>
</html>", revisions="<html>
<ul>
<li>May 28, 2015, Marcus Fuchs:</li>
implemented.
</ul>
</html>"));
end ZoneStepResponse;
