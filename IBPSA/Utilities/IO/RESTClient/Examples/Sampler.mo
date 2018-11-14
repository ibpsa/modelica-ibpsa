within IBPSA.Utilities.IO.RESTClient.Examples;
model Sampler "Sampling the simulation data and sending it to external servers"
 extends Modelica.Icons.Example;
   inner IBPSA.Utilities.IO.RESTClient.Configuration config(
   activation=IBPSA.Utilities.IO.RESTClient.Types.GlobalActivation.use_input, samplePeriod=30,
    hosAddress="127.0.0.1",
    tcpPort=8888)
     "Configuration for the sampler block"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  IBPSA.Utilities.IO.RESTClient.Send_Real sam(
    hosAddress="127.0.0.1",
    tcpPort=8888,
    nameSig="control",
    samplePeriod=5,
    u(start=0),
    activation=IBPSA.Utilities.IO.RESTClient.Types.LocalActivation.global,
    message(start={1}, fixed=true),
    unitSig={"none"},
    t0=1) "Sampler block"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Sources.Sine sinSig(freqHz=1/30)
    "Control signal 2 to be overwritten"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Modelica.Blocks.Sources.BooleanExpression oveCon(y=time > -1)
     "Boolean command to enable/disenable the overwritten block"
    annotation (Placement(transformation(extent={{24,68},{44,88}})));

equation
  connect(oveCon.y, config.activate)
    annotation (Line(points={{45,78},{45,78},{58,78}},  color={255,0,255}));
  connect(sinSig.y, sam.u) annotation (Line(points={{-59,0},{-59,0},{-12,0}},
               color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
   experiment(
      StopTime=200,
      Interval=1,
      Tolerance=1e-006),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Utilities/IO/RESTClient/Examples/Sampler.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>This example demonstrates the use of a sampler that sends time series to a remoted server.</p>
<p>Please start the socket server IBPSA/Resources/src/SocketServer/Utilities/IO/RESTClient/Examples/Server.py before starting this example. </p>
</html>", revisions="<html>
<ul>
<li>
Nov 12, 2018 by Sen Huang:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/926\">#926</a>.
</li>
</ul>
</html>"),
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=false,
      OutputFlatModelica=false));
end Sampler;
