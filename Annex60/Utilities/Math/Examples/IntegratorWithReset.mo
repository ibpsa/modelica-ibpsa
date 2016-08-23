within Annex60.Utilities.Math.Examples;
model IntegratorWithReset "Test model for integrator with reset"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.ExpSine expSine(
    amplitude=100,
    freqHz=2,
    damping=15,
    offset=100) "Exponential sine as source term"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

  Annex60.Utilities.Math.IntegratorWithReset intWitRes1(
    use_reset=true, y_start=5)
                    "Integrator with reset"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Annex60.Utilities.Math.IntegratorWithReset intWitRes2(
    use_reset=true, y_reset=10,
    y_start=-5)
               "Integrator with reset and y_reset = 2"
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(width=50, period=0.2)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-60,-28},{-40,-8}})));
  Annex60.Utilities.Math.IntegratorWithReset intNoReset(use_reset=false)
    "Integrator without reset"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  Modelica.Blocks.Sources.SampleTrigger sampleTrigger(period=0.2)
    annotation (Placement(transformation(extent={{-60,12},{-40,32}})));
equation
  connect(expSine.y, intWitRes1.u)
    annotation (Line(points={{-39,70},{-26,70},{-26,30},{-12,30}},
                                                 color={0,0,127}));
  connect(intNoReset.u, expSine.y) annotation (Line(points={{-12,-50},{-12,-50},
          {-26,-50},{-26,70},{-39,70}}, color={0,0,127}));
  connect(expSine.y, intWitRes2.u) annotation (Line(points={{-39,70},{-39,70},{-26,
          70},{-26,-10},{-12,-10}},                       color={0,0,127}));
  connect(sampleTrigger.y, intWitRes1.reset)
    annotation (Line(points={{-39,22},{-12,22}}, color={255,0,255}));
  connect(booleanPulse.y, intWitRes2.reset) annotation (Line(points={{-39,-18},{
          -26,-18},{-12,-18}}, color={255,0,255}));
annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Utilities/Math/Examples/IntegratorWithReset.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the implementation of
<a href=\"modelica://Annex60.Utilities.Math.IntegratorWithReset\">
Annex60.Utilities.Math.IntegratorWithReset</a>
with and without reset, and with different values for the integrator reset.
</p>
<p>
The integrator <code>intWitRes1</code> is triggered by a sample trigger
which becomes true at <i>t=0</i>, while <code>intWitRes2</code> is triggered
by a boolean pulse with is true at <i>t=0</i>.
Hence, <code>intWitRes1</code> starts with <code>y(0)=y_reset</code> while
<code>intWitRes2</code> starts with <code>y(0)=y_start</code>.
</html>", revisions="<html>
<ul>
<li>
August 23, 2016, by Michael Wetter:<br/>
Extended example to test initialization.
</li>
<li>
August 02, 2016, by Philipp Mehrfeld:<br/>
First implementation.
</li>
</ul>
</html>"));
end IntegratorWithReset;
