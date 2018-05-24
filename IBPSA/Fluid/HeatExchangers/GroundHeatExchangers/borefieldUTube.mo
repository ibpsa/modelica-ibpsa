within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers;
model borefieldUTube
  "Borefield model using single U-tube borehole heat exchanger configuration.Calculates the average fluid temperature T_fts of the borefield for a given (time dependent) load Q_flow"

  //FIXME: add assert to check configurations:
   // assert(gen.rBor > gen.xC + gen.rTub + gen.eTub and
   //       0 < gen.xC - gen.rTub - gen.eTub,
   //       "The borehole geometry is not physical. Check rBor, rTub and xC to make sure that the tube is placed inside the halve of the borehole.");

  extends IBPSA.Fluid.Interfaces.PartialTwoPortInterface(
    m_flow_nominal=borFieDat.conDat.m_flow_nominal);

  extends IBPSA.Fluid.Interfaces.LumpedVolumeDeclarations(T_start = borFieDat.conDat.T_start);
  extends IBPSA.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    dp_nominal=borFieDat.conDat.dp_nominal);

  // General parameters of borefield
  parameter Data.BorefieldData.Template borFieDat "Borefield data"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  parameter Boolean dynFil=true
    "Set to false to remove the dynamics of the filling material."
    annotation (Dialog(tab="Dynamics"));

  BaseClasses.MassFlowRateMultiplier masFloDiv(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    k=borFieDat.conDat.nbBh) "Division of flow rate"
    annotation (Placement(transformation(extent={{-60,-10},{-80,10}})));
  BaseClasses.MassFlowRateMultiplier masFloMul(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    k=borFieDat.conDat.nbBh) "Mass flow multiplier"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  BaseClasses.GroundTemperatureResponse groTemRes(
    p_max=borFieDat.conDat.p_max,
    forceGFunCalc=forceGFunCalc,
    borFieDat=borFieDat) "Ground temperature response"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theCol(m=borFieDat.conDat.nVer)
    "Thermal collector to connect the unique ground temperature to each borehole wall temperature of each segment"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,50})));
  replaceable BaseClasses.BoreHoles.SingleBoreHoleUTube borHol(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    borFieDat=borFieDat,
    allowFlowReversal=allowFlowReversal,
    m_flow_small=m_flow_small,
    show_T=show_T,
    computeFlowResistance=computeFlowResistance,
    from_dp=from_dp,
    linearizeFlowResistance=linearizeFlowResistance,
    deltaM=deltaM,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    p_start=p_start,
    T_start=T_start,
    X_start=X_start,
    C_start=C_start,
    C_nominal=C_nominal,
    mSenFac=mSenFac,
    dynFil=dynFil) "Borehole"
    annotation (Placement(transformation(extent={{-24,-24},{24,24}})));
  Modelica.Blocks.Sources.Constant const(k=borFieDat.conDat.T_start) "Undisturbed ground temperature"
    annotation (Placement(transformation(extent={{-60,70},{-80,90}})));
  parameter Boolean forceGFunCalc=false
    "Set to true to force the thermal response to be calculated at the start";

equation
  connect(masFloMul.port_b, port_b)
    annotation (Line(points={{80,0},{86,0},{100,0}}, color={0,127,255}));
  connect(groTemRes.Tb, theCol.port_b)
    annotation (Line(points={{-60,50},{-50,50},{-40,50}}, color={191,0,0}));
  connect(borHol.port_b, masFloMul.port_a)
    annotation (Line(points={{24,0},{42,0},{60,0}}, color={0,127,255}));
  connect(theCol.port_a, borHol.port_wall)
    annotation (Line(points={{-20,50},{0,50},{0,24}}, color={191,0,0}));
  connect(const.y, groTemRes.Tg) annotation (Line(points={{-81,80},{-88,80},{-94,
          80},{-94,50},{-82,50}}, color={0,0,127}));
  connect(masFloDiv.port_b, port_a)
    annotation (Line(points={{-80,0},{-100,0}}, color={0,127,255}));
  connect(masFloDiv.port_a, borHol.port_a)
    annotation (Line(points={{-60,0},{-24,0}}, color={0,127,255}));
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
            100}})),Documentation(info="<html>
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
<a href=\"modelica://IDEAS/Resources/Images/Fluid/HeatExchangers/BroundHeatExchangers/Borefield/UsersGuide/2014-10thModelicaConference-Picard.pdf\">Picard (2014)</a>.
and in 
<a href=\"modelica://IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Borefield2.UsersGuide\">IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Borefield2.UsersGuide</a>.
</p>
<p>
A verification of this model can be found in 
<a href=\"modelica://IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Borefield2.Validation.TrtValidation\">TrtValidation</a>
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
end borefieldUTube;
