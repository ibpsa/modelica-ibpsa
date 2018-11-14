within IBPSA.Utilities.IO.RESTClient.Examples;
model PIDTest
  "The example to show how to use the RESTClient to interfere a simple PID controller"
 extends Modelica.Icons.Example;
   inner IBPSA.Utilities.IO.RESTClient.Configuration config(                  samplePeriod=30,
      activation=IBPSA.Utilities.IO.RESTClient.Types.GlobalActivation.always,
    hosAddress="127.0.0.1",
    tcpPort=8888)
     "Configuration"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

   Modelica.Blocks.Sources.Constant TSet(k=1) "Set point"
      annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
   Modelica.Blocks.Continuous.LimPID conPI(
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      yMax=10) "Controller"
      annotation (Placement(transformation(extent={{-26,20},{-6,40}})));
    Modelica.Blocks.Continuous.FirstOrder firOrd(
      T=1,
      initType=Modelica.Blocks.Types.Init.InitialOutput)
      "First order element"
      annotation (Placement(transformation(extent={{50,20},{70,40}})));

  Read_Real oveWriOutPut(
    hosAddress="127.0.0.1",
    tcpPort=8888,
    valueVariable(fixed=true),
    derivativeVariable(fixed=true),
    enableFlag(fixed=true),
    u(fixed=false),
    t0=1,
    activation=IBPSA.Utilities.IO.RESTClient.Types.LocalActivation.always,
    overVariable="control_output") "Overwritting block for control output"
    annotation (Placement(transformation(extent={{12,20},{32,40}})));
  Send_Real samMea(
    hosAddress="127.0.0.1",
    tcpPort=8888,
    samplePeriod=5,
    u(start=0),
    activation=IBPSA.Utilities.IO.RESTClient.Types.LocalActivation.global,
    message(start={1}, fixed=true),
    unitSig={"none"},
    t0=1,
    nameSig="measurement") "Sampler block"
    annotation (Placement(transformation(extent={{12,-30},{-8,-10}})));
  Read_Real oveWriSetPoi(
    hosAddress="127.0.0.1",
    tcpPort=8888,
    valueVariable(fixed=true),
    derivativeVariable(fixed=true),
    enableFlag(fixed=true),
    u(fixed=false),
    t0=1,
    activation=IBPSA.Utilities.IO.RESTClient.Types.LocalActivation.always,
    overVariable="control_setpoint")
                                   "Overwritting block for control setpoint"
    annotation (Placement(transformation(extent={{-64,20},{-44,40}})));
equation
  connect(firOrd.y, conPI.u_m) annotation (Line(points={{71,30},{80,30},{80,0},{
          -16,0},{-16,18}}, color={0,0,127}));
  connect(conPI.y, oveWriOutPut.u)
    annotation (Line(points={{-5,30},{-5,30},{10,30}}, color={0,0,127}));
  connect(oveWriOutPut.y, firOrd.u)
    annotation (Line(points={{33.4,30},{42,30},{48,30}}, color={0,0,127}));
  connect(samMea.u, conPI.u_m) annotation (Line(points={{14,-20},{80,-20},{80,0},
          {-16,0},{-16,18}}, color={0,0,127}));
  connect(TSet.y, oveWriSetPoi.u)
    annotation (Line(points={{-79,30},{-66,30}}, color={0,0,127}));
  connect(oveWriSetPoi.y, conPI.u_s)
    annotation (Line(points={{-42.6,30},{-28,30}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
   experiment(
      StopTime=200,
      Interval=1,
      Tolerance=1e-006),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Utilities/IO/RESTClient/Examples/PIDTest.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>This example demonstrates how to use the RESTClient in interfering with a simple controller. </p>
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
end PIDTest;
