within Annex60.Utilities.Math.Examples;
model IntegratorWithReset "Test model for integrator with reset"
  import Annex60;
  extends Modelica.Icons.Example;
  Annex60.Utilities.Math.IntegratorWithReset integratorWithReset(use_reset=true,
      yResetSou=Annex60.BoundaryConditions.Types.DataSource.Input)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Sources.ExpSine expSine(
    amplitude=100,
    offset=100,
    freqHz=2,
    damping=4)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(width=50, period=0.2)
    annotation (Placement(transformation(extent={{-60,-14},{-40,6}})));
  Modelica.Blocks.Sources.ExpSine expSine1(
    amplitude=100,
    offset=100,
    freqHz=3,
    damping=1)
    annotation (Placement(transformation(extent={{-60,-48},{-40,-28}})));
equation
  connect(integratorWithReset.y, y)
    annotation (Line(points={{11,0},{100,0}}, color={0,0,127}));
  connect(booleanPulse.y, integratorWithReset.reset) annotation (Line(points={{-39,-4},
          {-26,-4},{-26,7},{-12,7}},                 color={255,0,255}));
  connect(expSine.y, integratorWithReset.u) annotation (Line(points={{-39,30},{
          -26,30},{-26,0},{-12,0}}, color={0,0,127}));
  connect(expSine1.y, integratorWithReset.yReset_in) annotation (Line(points={{-39,
          -38},{-26,-38},{-26,-7},{-12,-7}}, color={0,0,127}));
annotation (experiment,
          __Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Utilities/Math/Examples/IntegratorWithReset.mos"
        "Simulate and plot"),
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
