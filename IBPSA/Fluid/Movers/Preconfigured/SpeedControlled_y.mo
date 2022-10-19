within IBPSA.Fluid.Movers.Preconfigured;
model SpeedControlled_y "Fan or pump with ideally controlled normalized speed y as input signal and pre-configured parameters"
  extends IBPSA.Fluid.Movers.SpeedControlled_y(
    final per(
            pressure(
              V_flow=m_flow_nominal/rho_default*{0, 1, 2},
              dp=if rho_default < 500
                   then dp_nominal*{1.12, 1, 0}
                   else dp_nominal*{1.14, 1, 0.42}),
            powerOrEfficiencyIsHydraulic=true,
            etaHydMet=IBPSA.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.EulerNumber,
            etaMotMet=IBPSA.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.GenericCurve),
    final inputType=IBPSA.Fluid.Types.InputType.Continuous,
    final init=Modelica.Blocks.Types.Init.InitialOutput,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial);

  parameter Modelica.Units.SI.PressureDifference dp_nominal
    "Nominal pressure head for preconfiguration"
    annotation(Dialog(group="Nominal condition"));
annotation(Documentation(info="<html>
<p>
This model is the preconfigured version for
<a href=\"Modelica://IBPSA.Fluid.Movers.SpeedControlled_y\">
IBPSA.Fluid.Movers.SpeedControlled_y</a>.
</html>", revisions="<html>
<ul>
<li>
August 17, 2022, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">Buildings, #2668</a>.
</li>
</ul>
</html>"), Icon(graphics={Line(
          points={{-100,60},{-80,40},{-40,80}},
          color={0,140,72},
          thickness=10)}));
end SpeedControlled_y;
