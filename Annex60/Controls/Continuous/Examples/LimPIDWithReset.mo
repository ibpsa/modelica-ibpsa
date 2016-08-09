within Annex60.Controls.Continuous.Examples;
model LimPIDWithReset
  "Test model for PID controller with optional intgerator reset"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Pulse pulse(period=0.25)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Annex60.Controls.Continuous.LimPID limPIWithReset(
    Ti=1,
    Td=1,
    yMax=1,
    yMin=-1,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    use_reset=true,
    intResetValue=0,
    controllerType=Modelica.Blocks.Types.SimpleController.PI)
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Modelica.Blocks.Sources.Constant const(k=0.5)
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Modelica.Blocks.Continuous.LimPID limPIOri(
    Ti=1,
    Td=1,
    yMax=1,
    yMin=-1,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    controllerType=Modelica.Blocks.Types.SimpleController.PI)
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(
    width=50,
    startTime=0.1,
    period=0.2)
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
equation
  connect(pulse.y, limPIWithReset.u_s)
    annotation (Line(points={{-19,10},{18,10}}, color={0,0,127}));
  connect(const.y, limPIWithReset.u_m)
    annotation (Line(points={{-19,-20},{30,-20},{30,-2}}, color={0,0,127}));
  connect(pulse.y, limPIOri.u_s) annotation (Line(points={{-19,10},{-5.5,10},{
          -5.5,50},{18,50}}, color={0,0,127}));
  connect(const.y, limPIOri.u_m) annotation (Line(points={{-19,-20},{-12,-20},{
          -12,30},{30,30},{30,38}}, color={0,0,127}));
  connect(booleanPulse.y, limPIWithReset.reset) annotation (Line(points={{-19,
          40},{4,40},{4,3.4},{18,3.4}}, color={255,0,255}));
 annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Controls/Continuous/Examples/LimPID.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
August 02, 2016, by Philipp Mehrfeld:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>This model tests the implementation of the <code><a href=\"Modelica://Annex60.Controls.Continuous.LimPID\">LimPID</a></code> model with integrator reset, when the boolean input becomes true. The model <code>limPIOri</code> is the original implementation of the controller from the Modelica Standard Library. To understand the functionality please have a look at the following variables:</p>
<ul>
<li><pre>booleanPulse.y</pre></li>
<li><pre>limPIOri.I.y</pre></li>
<li><pre>limPIWithReset.I.y</pre></li>
<li><pre>limPIOri.y</pre></li>
<li><pre>limPIWithReset.y</pre></li>
</ul>
<p><br>E. g. use the following plotting commands to investigate the simulation results (just copy&AMP;paste):</p>
<pre>createPlot(id=1, y={&QUOT;booleanPulse.y&QUOT;}, range={0.0, 1.0, -0.2, 1.2}, grid=true, subPlot=1, filename=&QUOT;LimPIDWithReset.mat&QUOT;, colors={{28,108,200}});
createPlot(id=1, y={&QUOT;limPIOri.I.y&QUOT;, &QUOT;limPIWithReset.I.y&QUOT;}, range={0.0, 1.0, -0.06, 0.08}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}});
createPlot(id=1, y={&QUOT;limPIOri.y&QUOT;, &QUOT;limPIWithReset.y&QUOT;}, range={0.0, 1.0, -0.6, 0.6}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}});</pre>
</html>"));
end LimPIDWithReset;
