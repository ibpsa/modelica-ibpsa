within Annex60.Fluid.Movers.BaseClasses;
partial model FlowControlled
  "Partial model for fan or pump with ideally controlled mass flow rate or head as input signal"
  parameter Boolean use_record = false
    "= true to specify pump properties using a record"
    annotation(Dialog(group="Mover properties"));
  parameter Real eta = 0.49 "Mover efficiency"
    annotation(Dialog(group="Mover properties",enable=not use_record));

  parameter Boolean motorCooledByFluid = true
    "= true if motor heat is dissipated into fluid"
    annotation(Dialog(group="Mover properties", enable=not use_record));

  extends Annex60.Fluid.Movers.BaseClasses.PartialFlowMachine(
    eff(per(
      final hydraulicEfficiency =     if use_record
                                      then per.hydraulicEfficiency
                                      else Annex60.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters(
                                                        V_flow={V_flow_max},
                                                        eta={eta}),
      final motorEfficiency =         if use_record
                                      then per.motorEfficiency
                                      else Annex60.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters(
                                                        V_flow={V_flow_max},
                                                        eta={1}),
      final motorCooledByFluid =      if use_record then per.motorCooledByFluid else motorCooledByFluid),
      powComTyp=if use_record then Annex60.Fluid.Types.PowerComputationType.SimilarityLaws else Annex60.Fluid.Types.PowerComputationType.Simplified),
   heaDis(final motorCooledByFluid = if use_record then per.motorCooledByFluid else motorCooledByFluid,
          final delta_V_flow = 1E-3*V_flow_max),
   preSou(final control_m_flow=control_m_flow));

  import cha = Annex60.Fluid.Movers.BaseClasses.Characteristics;

  // Quantity to control
  constant Boolean control_m_flow "= false to control head instead of m_flow";

  Modelica.SIunits.VolumeFlowRate VMachine_flow = eff.V_flow "Volume flow rate";
  Modelica.SIunits.PressureDifference dpMachine(displayUnit="Pa")=
      -senRelPre.p_rel "Pressure difference";

protected
  final parameter Medium.AbsolutePressure p_a_default(displayUnit="Pa") = Medium.p_default
    "Nominal inlet pressure for predefined fan or pump characteristics";

  parameter Medium.ThermodynamicState sta_default = Medium.setState_pTX(
     T=Medium.T_default,
     p=Medium.p_default,
     X=Medium.X_default[1:Medium.nXi]) "Default medium state";

  Modelica.Blocks.Continuous.Filter filter(
     order=2,
     f_cut=5/(2*Modelica.Constants.pi*riseTime),
     final init=init,
     x(each stateSelect=StateSelect.always),
     final analogFilter=Modelica.Blocks.Types.AnalogFilter.CriticalDamping,
     final filterType=Modelica.Blocks.Types.FilterType.LowPass) if
        filteredSpeed
    "Second order filter to approximate valve opening time, and to improve numerics"
    annotation (Placement(transformation(extent={{20,81},{34,95}})));

public
  Modelica.Blocks.Math.Gain gaiPreSou(final k=-1) "Gain for pressure source"
    annotation (Placement(transformation(extent={{12,-30},{0,-18}})));
equation
  connect(eff.y_out, y_actual) annotation (Line(points={{-15,-30},{84,-30},{84,50},
          {110,50}},         color={0,0,127}));
  connect(senRelPre.p_rel, gaiPreSou.u) annotation (Line(points={{50,-24.5},{32,
          -24.5},{32,-24},{13.2,-24}}, color={0,0,127}));
  connect(gaiPreSou.y, eff.dp_in) annotation (Line(points={{-0.6,-24},{-34,-24},
          {-34,-32}}, color={0,0,127}));
  annotation (defaultComponentName="fan",
    Documentation(info="<html>
<p>
Partial model for a fan or pump that takes as an input
the head or the mass flow rate.
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
September 2, 2015, by Michael Wetter:<br/>
Changed assignments of parameters of record <code>_perPow</code> to be <code>final</code>
as we want users to change the performance record and not the low level declaration.
</li>      
<li>
January 6, 2015, by Michael Wetter:<br/>
Revised model for OpenModelica.
</li>
<li>
April 19, 2014, by Filip Jorissen:<br/>
Set default values for new parameters in <code>efficiency()</code>.
</li>
<li>
October 8, 2013, by Michael Wetter:<br/>
Removed parameter <code>show_V_flow</code>.
</li>
<li>
September 13, 2013 by Michael Wetter:<br/>
Corrected computation of <code>sta_default</code> to use medium default
values instead of medium start values.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li>
October 11, 2012, by Michael Wetter:<br/>
Added implementation of <code>WFlo = eta * P</code> with
guard against division by zero.
</li>
<li>
May 25, 2011, by Michael Wetter:<br/>
Revised implementation of energy balance to avoid having to use conditionally removed models.
</li>
<li>
November 11, 2010, by Michael Wetter:<br/>
Changed <code>V_flow_max=m_flow_nominal/rho_nominal;</code> to <code>V_flow_max=m_flow_max/rho_nominal;</code>
</li>
<li>
July 27, 2010, by Michael Wetter:<br/>
Redesigned model to fix bug in medium balance.
</li>
<li>
March 24, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end FlowControlled;
