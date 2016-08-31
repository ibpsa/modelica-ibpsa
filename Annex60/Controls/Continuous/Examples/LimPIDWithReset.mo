within Annex60.Controls.Continuous.Examples;
model LimPIDWithReset
  "Test model for PID controller with optional intgerator reset"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Pulse pulse(period=0.25) "Set point signal"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Annex60.Controls.Continuous.LimPID limPIWithReset(
    Ti=1,
    Td=1,
    yMax=1,
    yMin=-1,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    use_reset=true,
    xi_reset=0,
    controllerType=Modelica.Blocks.Types.SimpleController.PI)
    "PI controller with integrator reset"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Modelica.Blocks.Sources.Constant const(k=0.5) "Measured signal"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Modelica.Blocks.Continuous.LimPID limPIOri(
    Ti=1,
    Td=1,
    yMax=1,
    yMin=-1,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    controllerType=Modelica.Blocks.Types.SimpleController.PI)
    "Pi controller without integrator reset"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(
    width=50,
    startTime=0.1,
    period=0.2) "Boolean pulse to reset integrator"
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
__Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Controls/Continuous/Examples/LimPIDWithReset.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
August 25, 2016, by Michael Wetter:<br/>
Revised documentation and added script for regression test.
</li>    
<li>
August 02, 2016, by Philipp Mehrfeld:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>This model tests the implementation the
<a href=\"Modelica://Annex60.Controls.Continuous.LimPID\">Annex60.Controls.Continuous.LimPID</a>
with integrator reset.
</p>
<p>
The instance <code>limPIOri</code> is the original implementation of the controller
from the Modelica Standard Library.
The instance <code>limPIWithReset</code> is the implementation from this library
with integrator reset enabled. Whenever the boolean pulse input becomes true,
the integrator is reset to <code>y_reset</code>.
</p>
</html>"));
end LimPIDWithReset;
