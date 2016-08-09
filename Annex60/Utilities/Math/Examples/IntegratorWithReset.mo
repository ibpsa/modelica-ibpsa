within Annex60.Utilities.Math.Examples;
model IntegratorWithReset "Test model for integrator with reset"
  import Annex60;
  extends Modelica.Icons.Example;
  Annex60.Utilities.Math.IntegratorWithReset intWitRes1(use_reset=true)
    "Integrator with reset"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Modelica.Blocks.Sources.ExpSine expSine(
    amplitude=100,
    freqHz=2,
    damping=15,
    offset=100)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(width=50, period=0.2)
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Annex60.Utilities.Math.IntegratorWithReset intNoReset(use_reset=false)
    "Integrator without reset"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  Annex60.Utilities.Math.IntegratorWithReset intWitRes2(use_reset=true, y_reset
      =2) "Integrator with reset"
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
equation
  connect(booleanPulse.y, intWitRes1.reset) annotation (Line(points={{-39,-30},
          {-32,-30},{-32,22},{-12,22}}, color={255,0,255}));
  connect(expSine.y, intWitRes1.u)
    annotation (Line(points={{-39,30},{-12,30}}, color={0,0,127}));
  connect(intNoReset.u, expSine.y) annotation (Line(points={{-12,-50},{-12,-50},
          {-26,-50},{-26,30},{-39,30}}, color={0,0,127}));
  connect(booleanPulse.y, intWitRes2.reset) annotation (Line(points={{-39,-30},
          {-32,-30},{-32,-18},{-12,-18}}, color={255,0,255}));
  connect(expSine.y, intWitRes2.u) annotation (Line(points={{-39,30},{-40,30},{
          -40,30},{-40,30},{-26,30},{-26,-10},{-12,-10}}, color={0,0,127}));
annotation (experiment,
    Documentation(info="<html>
<p>
This model tests the implementation of
<a href=\"modelica://Annex60.Utilities.Math.IntegratorWithReset\">
Annex60.Utilities.Math.IntegratorWithReset</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 02, 2016, by Philipp Mehrfeld:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_experimentSetupOutput);
end IntegratorWithReset;
