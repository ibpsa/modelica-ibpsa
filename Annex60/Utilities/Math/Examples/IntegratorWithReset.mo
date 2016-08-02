within Annex60.Utilities.Math.Examples;
model IntegratorWithReset "Test model for integrator with reset"
  import Annex60;
  extends Modelica.Icons.Example;
  Annex60.Utilities.Math.IntegratorWithReset integratorWithReset(use_reset=true)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Sources.ExpSine expSine(
    amplitude=100,
    freqHz=2,
    damping=15,
    offset=100)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(width=50, period=0.2)
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation
  connect(integratorWithReset.y, y)
    annotation (Line(points={{11,0},{100,0}}, color={0,0,127}));
  connect(booleanPulse.y, integratorWithReset.reset) annotation (Line(points={{
          -39,-30},{-26,-30},{-26,-6.6},{-12,-6.6}}, color={255,0,255}));
  connect(expSine.y, integratorWithReset.u) annotation (Line(points={{-39,30},{
          -26,30},{-26,0},{-12,0}}, color={0,0,127}));
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
