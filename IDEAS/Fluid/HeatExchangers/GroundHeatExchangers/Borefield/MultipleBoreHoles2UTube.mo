within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield;
model MultipleBoreHoles2UTube
  "Calculates the average fluid temperature T_fts of the borefield for a given (time dependent) load Q_flow"

  // Medium in borefield
  extends
    IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.partial_multipleBoreHoles;

  BaseClasses.BoreHoles.BaseClasses.InternalHEX2UTube intHEX(
    redeclare final package Medium = Medium,
    final m1_flow_nominal=bfData.gen.m_flow_nominal_bh/2,
    final m2_flow_nominal=bfData.gen.m_flow_nominal_bh/2,
    final m3_flow_nominal=bfData.gen.m_flow_nominal_bh/2,
    final m4_flow_nominal=bfData.gen.m_flow_nominal_bh/2,
    final from_dp1=from_dp,
    final from_dp2=from_dp,
    final from_dp3=from_dp,
    final from_dp4=from_dp,
    final linearizeFlowResistance1=linearizeFlowResistance,
    final linearizeFlowResistance2=linearizeFlowResistance,
    final linearizeFlowResistance3=linearizeFlowResistance,
    final linearizeFlowResistance4=linearizeFlowResistance,
    final deltaM1=deltaM,
    final deltaM2=deltaM,
    final deltaM3=deltaM,
    final deltaM4=deltaM,
    final m1_flow_small=bfData.gen.m_flow_small/2,
    final m2_flow_small=bfData.gen.m_flow_small/2,
    final m3_flow_small=bfData.gen.m_flow_small/2,
    final m4_flow_small=bfData.gen.m_flow_small/2,
    final soi=bfData.soi,
    final fil=bfData.fil,
    final gen=bfData.gen,
    final allowFlowReversal1=bfData.gen.allowFlowReversal,
    final allowFlowReversal2=bfData.gen.allowFlowReversal,
    final allowFlowReversal3=bfData.gen.allowFlowReversal,
    final allowFlowReversal4=bfData.gen.allowFlowReversal,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final dp1_nominal=1,
    final dp2_nominal=1,
    final dp3_nominal=1,
    final dp4_nominal=1,
    final T_start = T_start,
    final scaSeg=bfData.gen.nbBh*bfData.gen.nVer,
    dynFil=dynFil)
    "Internal part of the borehole including the pipes and the filling material"
    annotation (Placement(transformation(
        extent={{-12,13},{12,-13}},
        rotation=270,
        origin={3,-8})));

  parameter Boolean dynFil=true
    "Set to false to remove the dynamics of the filling material."
    annotation (Dialog(tab="Dynamics"));
equation
  Q_flow = intHEX.port_a1.m_flow*(actualStream(intHEX.port_a1.h_outflow) - actualStream(intHEX.port_b2.h_outflow)) + intHEX.port_a3.m_flow*(actualStream(intHEX.port_a3.h_outflow) - actualStream(intHEX.port_b4.h_outflow));

  connect(port_a, intHEX.port_a1) annotation (Line(
      points={{-100,0},{-52,0},{-52,2.81818},{-6.45455,2.81818}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_a, intHEX.port_a3) annotation (Line(
      points={{-100,0},{-52,0},{-52,14},{6.78182,14},{6.78182,2.81818}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(intHEX.port_b2, port_b) annotation (Line(
      points={{-0.545455,2.81818},{-0.545455,8},{72,8},{72,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(intHEX.port_b4, port_b) annotation (Line(
      points={{13.0455,2.81818},{55.5228,2.81818},{55.5228,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(intHEX.port, TWallBou.port) annotation (Line(
      points={{-8.81818,-9.18182},{-20,-9.18182},{-20,-44},{-24,-44}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intHEX.port_b1, intHEX.port_a2) annotation (Line(
      points={{-6.45455,-21.1818},{-6.45455,-30},{-0.545455,-30},{-0.545455,
          -21.1818}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(intHEX.port_b3, intHEX.port_a4) annotation (Line(
      points={{6.66364,-21.1818},{6.66364,-30},{12.4545,-30},{12.4545,-21.1818}},
      color={0,127,255},
      smooth=Smooth.None));

  annotation (
    experiment(StopTime=70000, __Dymola_NumberOfIntervals=50),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,60},{100,-66}},
          lineColor={0,0,0},
          fillColor={234,210,210},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-88,-6},{-32,-62}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-82,-12},{-38,-56}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-88,54},{-32,-2}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-82,48},{-38,4}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-26,54},{30,-2}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-20,48},{24,4}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-28,-6},{28,-62}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-22,-12},{22,-56}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{36,56},{92,0}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{42,50},{86,6}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{38,-4},{94,-60}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{44,-10},{88,-54}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics),
                    Documentation(info="<html>
  <p>The proposed model is a so-called hybrid step-response
model (HSRM). This type of model uses the
borefield’s temperature response to a step load input.
An arbitrary load can always be approximated by a superposition
of step loads. The borefield’s response to
the load is then calculated by superposition of the step responses
using the linearity property of the heat diffusion
equation. The most famous example of HSRM
for borefields is probably the <i>g-function</i> of Eskilson
(1987). The major challenge of this approach is to obtain a
HSRM which is valid for both minute-based and year-based
simulations. To tackle this problem, a HSRM
has been implemented. A long-term response model
is implemented in order to take into account
the interactions between the boreholes and the
temperature evolution of the surrounding ground. A
short-term response model is implemented to
describe the transient heat flux in the borehole heat exchanger to the surrounding
ground. The step-response of each model is then calculated and merged into one
in order to achieve both short- and long-term
accuracy. Finally an aggregation method is implemented to speed up the calculation.
However, the aggregation method calculates the temperature for discrete time step. In order to avoid
abrut temperature changes, the aggregation method is used to calculate the average borehole wall
temperature instead of the average fluid temperature. The calculated borehole wall temperature is then
connected to the dynamic model of the borehole heat exchanger.</p>
<p>More detailed documentation can be found in 
<a href=\"modelica://IDEAS/Resources/Images/Fluid/HeatExchangers/Borefield/UsersGuide/2014-10thModelicaConference-Picard.pdf\">Picard (2014)</a>.
and in 
<a href=\"modelica://IDEAS.Fluid.HeatExchangers.Borefield.UsersGuide\">IDEAS.Fluid.HeatExchangers.Borefield.UsersGuide</a>.
</p>
<p>
A verification of this model can be found in 
<a href=\"modelica://IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Validation.TrtValidation\">TrtValidation</a>
.
</p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end MultipleBoreHoles2UTube;
