within Annex60.Fluid.Movers.BaseClasses;
partial model SpeedControlled
  "Partial model for fan or pump with speed (y or Nrpm) as input signal"
 extends Annex60.Fluid.Movers.BaseClasses.PartialFlowMachine(
     final m_flow_nominal = max(_per_y.pressure.V_flow)*rho_default,
     heaDis(final delta_V_flow=1E-3*V_flow_max,
            final motorCooledByFluid = _per_y.motorCooledByFluid),
     preSou(final control_m_flow=false));

  // Normalized speed
  Modelica.Blocks.Interfaces.RealOutput y_actual(min=0,
                                                 final unit="1")
    annotation (Placement(transformation(extent={{100,40},{120,60}}),
        iconTransformation(extent={{100,40},{120,60}})));

  Modelica.SIunits.VolumeFlowRate VMachine_flow = floMac.V_flow
    "Volume flow rate";
  Modelica.SIunits.PressureDifference dpMachine(displayUnit="Pa")=
      -dpMac.y "Pressure difference";

protected
  replaceable parameter Data.SpeedControlled_y _per_y
    constrainedby Data.SpeedControlled_y "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{62,70},{82,90}})));

  final parameter Integer nOri = size(_per_y.pressure.V_flow, 1)
    "Number of data points for pressure curve"
    annotation(Evaluate=true);

  final parameter Boolean haveVMax = (abs(_per_y.pressure.dp[nOri]) < Modelica.Constants.eps)
    "Flag, true if user specified data that contain V_flow_max";

  final parameter Modelica.SIunits.VolumeFlowRate V_flow_max=
    if haveVMax then
      _per_y.pressure.V_flow[nOri]
     else
      _per_y.pressure.V_flow[nOri] - (_per_y.pressure.V_flow[nOri] - _per_y.pressure.V_flow[
      nOri - 1])/((_per_y.pressure.dp[nOri] - _per_y.pressure.dp[nOri - 1]))*_per_y.pressure.dp[nOri]
    "Maximum volume flow rate, used for smoothing";
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

  FlowMachineInterface floMac(
    redeclare final parameter Data.SpeedControlled_y per = _per_y,
    final nOri = nOri,
    final rho_default=rho_default,
    final haveVMax=haveVMax,
    final V_flow_max=V_flow_max,
    r_N(start=y_start),
    r_V(start=m_flow_nominal/rho_default)) "Flow machine"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));

  Modelica.Blocks.Math.Gain dpMac(final k=-1)
    "Pressure drop of the pump or fan"
   annotation (Placement(transformation(extent={{20,20},{40,40}})));

equation
  if filteredSpeed then
    connect(filter.y, y_actual) annotation (Line(points={{34.7,88},{40.7,88},{
            40.7,50},{110,50}},       color={0,0,127}));
  else
    connect(inputSwitch.y, y_actual)
      annotation (Line(points={{1,50},{110,50}}, color={0,0,127}));
  end if;

 connect(preSou.dp_in, dpMac.y) annotation (Line(
     points={{56,8},{56,30},{41,30}},
     color={0,0,127}));
  connect(inputSwitch.y, filter.u) annotation (Line(points={{1,50},{10,50},{10,
          88},{18.6,88}}, color={0,0,127}));
  connect(y_actual, floMac.y_actual) annotation (Line(points={{110,50},{60,50},
          {60,-30},{-32,-30},{-32,-44},{-22,-44}},color={0,0,127}));
  connect(heaDis.eta, floMac.eta) annotation (Line(points={{38,-40},{8,-40},{8,-50},
          {1,-50}}, color={0,0,127}));
  connect(heaDis.etaHyd, floMac.etaHyd) annotation (Line(points={{38,-43},{24,
          -43},{10,-43},{10,-44},{10,-44},{10,-44},{10,-44},{10,-44},{10,-54.2},
          {1,-54.2}},                              color={0,0,127}));
  connect(heaDis.etaMot, floMac.etaMot) annotation (Line(points={{38,-46},{12,
          -46},{12,-58},{1,-58}},
                             color={0,0,127}));
  connect(heaDis.V_flow, floMac.V_flow) annotation (Line(points={{38,-52},{16,-52},
          {16,-38},{1,-38},{1,-40}}, color={0,0,127}));
  connect(floMac.PEle, heaDis.PEle) annotation (Line(points={{1,-47},{4,-47},{4,
          -60},{38,-60}}, color={0,0,127}));
  connect(floMac.WFlo, heaDis.WFlo) annotation (Line(points={{1,-44},{6,-44},{6,
          -56},{38,-56}}, color={0,0,127}));
  connect(floMac.dp, dpMac.u) annotation (Line(points={{1,-42},{12,-42},{12,-20},
          {12,-20},{12,30},{18,30}},              color={0,0,127}));
  connect(rho_inlet.y, floMac.rho) annotation (Line(points={{-49,-40},{-50,-40},
          {-36,-40},{-36,-50},{-22,-50}}, color={0,0,127}));
  connect(floMac.WFlo, PToMedium_flow.u2) annotation (Line(points={{1,-44},{6,
          -44},{6,-88},{38,-88}},
                             color={0,0,127}));
  connect(floMac.m_flow, senMasFlo.m_flow) annotation (Line(points={{-22,-56},{
          -40,-56},{-40,-18},{-60,-18},{-60,-11}}, color={0,0,127}));
 annotation (
   Documentation(info="<html>
<p>This is the base model for fans and pumps that take as
input a control signal in the form of the pump speed <code>Nrpm</code>
or the normalized pump speed <code>y=Nrpm/per.N_nominal</code>.
</p>
</html>",
     revisions="<html>
<ul>
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
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end SpeedControlled;
