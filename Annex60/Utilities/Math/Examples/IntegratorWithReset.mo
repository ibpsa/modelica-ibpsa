within Annex60.Utilities.Math.Examples;
model IntegratorWithReset "Test model for integrator with reset"
  import Annex60;
  extends Modelica.Icons.Example;
  Annex60.Utilities.Math.IntegratorWithReset intWitRes1(use_reset=true,
      yResetSou=Annex60.BoundaryConditions.Types.DataSource.Input)
    "Integrator with reset"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  Modelica.Blocks.Sources.ExpSine expSine(
    amplitude=100,
    offset=100,
    freqHz=2,
    damping=4) "Exponential sine as source term"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(width=50, period=0.2)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-60,-14},{-40,6}})));
  Modelica.Blocks.Sources.ExpSine expSineRes(
    amplitude=100,
    offset=100,
    freqHz=3,
    damping=1) "Exponential sine for reset"
    annotation (Placement(transformation(extent={{-60,-48},{-40,-28}})));
  Annex60.Utilities.Math.IntegratorWithReset intWitRes2(
    use_reset=true,
    y_start=-5,
    yResetSou=Annex60.BoundaryConditions.Types.DataSource.Parameter,
    yReset=1) "Integrator with reset parameter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Annex60.Utilities.Math.IntegratorWithReset intNoRes(yResetSou=Annex60.BoundaryConditions.Types.DataSource.Input,
      use_reset=false) "Integrator without reset"
    annotation (Placement(transformation(extent={{-12,-60},{8,-40}})));
equation
  connect(booleanPulse.y, intWitRes1.reset) annotation (Line(points={{-39,-4},{
          -26,-4},{-26,57},{-12,57}}, color={255,0,255}));
  connect(expSine.y, intWitRes1.u) annotation (Line(points={{-39,30},{-26,30},{
          -26,50},{-12,50}}, color={0,0,127}));
  connect(expSineRes.y, intWitRes1.yReset_in) annotation (Line(points={{-39,-38},
          {-26,-38},{-26,43},{-12,43}}, color={0,0,127}));
  connect(booleanPulse.y, intWitRes2.reset) annotation (Line(points={{-39,-4},{
          -26,-4},{-26,7},{-12,7}}, color={255,0,255}));
  connect(expSine.y, intWitRes2.u) annotation (Line(points={{-39,30},{-26,30},{
          -26,0},{-12,0}}, color={0,0,127}));
  connect(expSine.y, intNoRes.u) annotation (Line(points={{-39,30},{-26,30},{
          -26,-50},{-14,-50}}, color={0,0,127}));
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
<li>September 27, 2016, by Philipp Mehrfeld:<br>Adapted example to newer version of model. </li>
<li>August 23, 2016, by Michael Wetter:<br>Extended example to test initialization. </li>
<li>August 02, 2016, by Philipp Mehrfeld:<br>First implementation. </li>
</ul>
</html>"),
    __Dymola_experimentSetupOutput);
end IntegratorWithReset;
