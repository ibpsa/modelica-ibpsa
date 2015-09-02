within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield;
model MultipleBoreHoles2UTube
  "Borefield model using double U-tube borehole heat exchanger configuration."

  // Medium in borefield
  extends
    IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Interfaces.partial_multipleBoreHoles;

  replaceable BaseClasses.BoreHoles.SingleBoreHolesInSerie2UTube
                                               borHolSer(
    redeclare final package Medium = Medium,
    final soi=bfData.soi,
    final fil=bfData.fil,
    final gen=bfData.gen,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final T_start=T_start,
    final dynFil=dynFil,
    final mSenFac=mSenFac,
    final use_TWall=true,
    final m_flow_nominal=m_flow_nominal/bfData.gen.nbBh*bfData.gen.nbSer,
    final dp_nominal=dp_nominal)  constrainedby
    BaseClasses.BoreHoles.Interface.PartialSingleBoreholeSerie(
    redeclare package Medium = Medium,
     soi=bfData.soi,
     fil=bfData.fil,
     gen=bfData.gen,
     energyDynamics=energyDynamics,
     massDynamics=massDynamics,
     T_start=T_start,
     dynFil=dynFil,
     mSenFac=mSenFac,
     use_TWall=true,
     m_flow_nominal=m_flow_nominal/bfData.gen.nbBh*bfData.gen.nbSer,
     dp_nominal=dp_nominal) "NbSer boreholes in series"      annotation (Placement(transformation(
        extent={{12,13},{-12,-13}},
        rotation=180,
        origin={-1,0})));

equation
  connect(massFlowRateMultiplier.port_b, borHolSer.port_a)
    annotation (Line(points={{-60,0},{-13,0}},         color={0,127,255}));
  connect(borHolSer.port_b, massFlowRateMultiplier1.port_a)
    annotation (Line(points={{11,0},{60,0}},        color={0,127,255}));
  connect(TWall_val.y, borHolSer.TWall)
    annotation (Line(points={{-18.9,40},{-1,40},{-1,14.3}}, color={0,0,127}));

  annotation (
    experiment(StopTime=70000, __Dymola_NumberOfIntervals=50),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
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
<a href=\"modelica://IDEAS/Resources/Images/Fluid/HeatExchangers/GrouhdHeatExchangers/Borefield/UsersGuide/2014-10thModelicaConference-Picard.pdf\">Picard (2014)</a>.
and in 
<a href=\"modelica://IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.UsersGuide\">IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.UsersGuide</a>.
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
