within Annex60.Fluid.Movers.BaseClasses;
partial model SpeedControlled
  "Partial model for fan or pump with speed (y or Nrpm) as input signal"
 extends Annex60.Fluid.Movers.BaseClasses.PartialFlowMachine(
     final m_flow_nominal = max(per.pressure.V_flow)*rho_default,
     heaDis(final delta_V_flow=1E-3*V_flow_max,
            final motorCooledByFluid = per.motorCooledByFluid),
     preSou(final control_m_flow=false),
    eff(preVar=Annex60.Fluid.Types.PrescribedVariable.Speed, powComTyp=Annex60.Fluid.Types.PowerComputationType.SimilarityLaws));

  // Normalized speed

  Modelica.SIunits.VolumeFlowRate VMachine_flow = eff.V_flow "Volume flow rate";
  Modelica.SIunits.PressureDifference dpMachine(displayUnit="Pa")=
      -dpMac.y "Pressure difference";

  Modelica.SIunits.Efficiency eta =    eff.eta "Global efficiency";
  Modelica.SIunits.Efficiency etaHyd = eff.etaHyd "Hydraulic efficiency";
  Modelica.SIunits.Efficiency etaMot = eff.etaMot "Motor efficiency";

  Modelica.Blocks.Continuous.Filter filter(
     order=2,
     f_cut=5/(2*Modelica.Constants.pi*riseTime),
     final init=init,
     final y_start=y_start,
     x(each stateSelect=StateSelect.always),
     u_nominal=1,
     u(final unit="1"),
     y(final unit="1"),
     final analogFilter=Modelica.Blocks.Types.AnalogFilter.CriticalDamping,
     final filterType=Modelica.Blocks.Types.FilterType.LowPass) if
        filteredSpeed
    "Second order filter to approximate valve opening time, and to improve numerics"
    annotation (Placement(transformation(extent={{20,81},{34,95}})));

  Modelica.Blocks.Math.Gain gaiSpe(y(final unit="1")) if
       inputType == Annex60.Fluid.Types.InputType.Continuous
    "Gain to normalized speed using speed_nominal or speed_rpm_nominal"
    annotation (Placement(transformation(extent={{-4,74},{-16,86}})));

  Modelica.Blocks.Math.Gain dpMac(final k=-1)
    "Pressure drop of the pump or fan"
   annotation (Placement(transformation(extent={{18,18},{38,38}})));

equation
  if filteredSpeed then
    connect(filter.y, y_actual) annotation (Line(points={{34.7,88},{40.7,88},{40.7,
            50},{108,50}},            color={0,0,127}));
  else
    connect(inputSwitch.y, y_actual)
      annotation (Line(points={{1,50},{60,50},{60,50},{108,50}},
                                                 color={0,0,127}));
  end if;

 connect(preSou.dp_in, dpMac.y) annotation (Line(
     points={{56,8},{56,28},{39,28}},
     color={0,0,127}));
  connect(inputSwitch.y, filter.u) annotation (Line(points={{1,50},{10,50},{10,
          88},{18.6,88}}, color={0,0,127}));
  connect(eff.dp, dpMac.u) annotation (Line(points={{-11,-34},{8,-34},{8,28},{16,
          28}}, color={0,0,127}));
  connect(eff.y_actual, y_actual) annotation (Line(points={{-34,-38},{-38,-38},
          {-38,-24},{108,-24},{108,50}},         color={0,0,127}));
 annotation (
   Documentation(info="<html>
<p>
Partial model for fans and pumps that take as
input a control signal in the form of the pump speed <code>Nrpm</code>
or the normalized pump speed.
</p>
</html>",
     revisions="<html>
<ul>
<li>
February 19, 2016, by Michael Wetter:<br/>
Refactored model to make implementation clearer.
This is for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/417\">#417</a>.
</li>
<li>
November 19, 2015, by Michael Wetter:<br/>
Switched the two <code>extends</code> statements to get the
inherited graphic objects on the correct layer.
</li>      
<li>
October 8, 2013, by Michael Wetter:<br/>
Removed parameter <code>show_V_flow</code>.
</li>
<li>
May 25, 2011, by Michael Wetter:<br/>
Revised implementation of energy balance to avoid having to use conditionally removed models.
</li>
<li>
July 27, 2010, by Michael Wetter:<br/>
Redesigned model to fix bug in medium balance.
</li>
<li>March 24 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})));
end SpeedControlled;
