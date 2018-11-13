within IBPSA.Utilities.IO.RESTClient.Examples;
model OverWritten "Overwriting the control signals based on external source"
 extends Modelica.Icons.Example;
  inner IBPSA.Utilities.IO.RESTClient.Configuration config(
      samplePeriod=10, activation=IBPSA.Utilities.IO.RESTClient.Types.GlobalActivation.use_input,
    hosAddress="127.0.0.1",
    tcpPort=8888)
     "Configuration for the overwritten block"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Read_Real oveWri(
    activation=IBPSA.Utilities.IO.RESTClient.Types.LocalActivation.dynamic,
    hosAddress="127.0.0.1",
    tcpPort=8888,
    overVariable="control",
    valueVariable(fixed=true),
    derivativeVariable(fixed=true),
    enableFlag(fixed=true),
    u(fixed=false),
    t0=1) "Overwritten block"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));

  Modelica.Blocks.Sources.Sine sinSig(freqHz=1/30, amplitude=2) "Control signal 2 to be overwritten"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.BooleanExpression oveCon(y=time > -1)
    "Boolean command to enable/disenable the overwritten block"
    annotation (Placement(transformation(extent={{-80,44},{-60,64}})));
equation
  connect(sinSig.y, oveWri.u) annotation (Line(points={{-59,0},{8,0}},                  color={0,0,127}));
  connect(oveCon.y, config.activate) annotation (Line(points={{-59,54},{-32,54},
          {-32,78},{58,78}}, color={255,0,255}));
  connect(oveWri.activate, config.activate) annotation (Line(points={{8,8},{-32,
          8},{-32,54},{-32,78},{58,78}},                color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
   experiment(StopTime=200),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Utilities/IO/RESTClient/Examples/OverWritten.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>This example demonstrates the use of an overwritting block that overwrites control signals in the simulation based on a remoted server. </p>
<p>Please start the socket server IBPSA/Resources/src/SocketServer/Utilities/IO/RESTClient/Examples/Server.py before simulating this model. </p>
</html>", revisions="<html>
<ul>
<li>
Nov 12, 2018 by Sen Huang:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/926\">#926</a>.
</li>
</ul>
</html>"));
end OverWritten;
