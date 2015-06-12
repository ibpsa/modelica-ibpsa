within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield;
model MultipleBoreHolesUTube
  "Calculates the average fluid temperature T_fts of the borefield for a given (time dependent) load Q_flow"

  // Medium in borefield
  extends
    IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.partial_multipleBoreHoles;

  BaseClasses.BoreHoles.BaseClasses.InternalHEXUTube intHEX(
    redeclare final package Medium = Medium,
    final m1_flow_nominal=bfData.gen.m_flow_nominal_bh,
    final m2_flow_nominal=bfData.gen.m_flow_nominal_bh,
    final dp1_nominal=dp_nominal,
    final dp2_nominal=0,
    final from_dp1=from_dp,
    final from_dp2=from_dp,
    final linearizeFlowResistance1=linearizeFlowResistance,
    final linearizeFlowResistance2=linearizeFlowResistance,
    final deltaM1=deltaM,
    final deltaM2=deltaM,
    final m1_flow_small=bfData.gen.m_flow_small,
    final m2_flow_small=bfData.gen.m_flow_small,
    final soi=bfData.soi,
    final fil=bfData.fil,
    final gen=bfData.gen,
    final allowFlowReversal1=bfData.gen.allowFlowReversal,
    final allowFlowReversal2=bfData.gen.allowFlowReversal,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p1_start=p_start,
    final X1_start=X_start,
    final C1_start=C_start,
    final C1_nominal=C_nominal,
    final p2_start=p_start,
    final X2_start=X_start,
    final C2_start=C_start,
    final C2_nominal=C_nominal,
    final scaSeg=bfData.gen.nbBh*bfData.gen.nVer,
    final T1_start=T_start,
    final T2_start=T_start,
    final T_start=T_start,
    dynFil=dynFil)
    "Internal part of the borehole including the pipes and the filling material"
    annotation (Placement(transformation(
        extent={{-12,13},{12,-13}},
        rotation=270,
        origin={3,-10})));

  parameter Boolean dynFil=true
    "Set to false to remove the dynamics of the filling material."
    annotation (Dialog(tab="Dynamics"));
equation
  Q_flow = port_a.m_flow*(actualStream(port_a.h_outflow) - actualStream(port_b.h_outflow));

  connect(TWallBou.port, intHEX.port) annotation (Line(
      points={{-24,-44},{-20,-44},{-20,-12},{-10,-12},{-10,-11.1818},{-8.81818,
          -11.1818}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(intHEX.port_b1, intHEX.port_a2) annotation (Line(
      points={{-4.09091,-23.1818},{-4.09091,-30},{10.0909,-30},{10.0909,
          -23.1818}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(port_a, intHEX.port_a1) annotation (Line(
      points={{-100,0},{-52,0},{-52,0.818182},{-4.09091,0.818182}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_b, intHEX.port_b2) annotation (Line(
      points={{100,0},{54,0},{54,2},{10.0909,2},{10.0909,0.818182}},
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
                    graphics),
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
end MultipleBoreHolesUTube;
