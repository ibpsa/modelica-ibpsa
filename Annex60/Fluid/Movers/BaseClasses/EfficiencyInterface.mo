within Annex60.Fluid.Movers.BaseClasses;
model EfficiencyInterface
  "Block for efficiency calculations for fans and pumps"
  extends Modelica.Blocks.Interfaces.BlockIcon;

  import cha = Annex60.Fluid.Movers.BaseClasses.Characteristics;

  replaceable parameter Data.FlowControlled per "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{60,-80},{80,-60}})));

 // Normalized speed
  Modelica.Blocks.Interfaces.RealInput y_actual(
    final unit="1",
    min=0) "Global efficiency"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
        iconTransformation(extent={{-140,80},{-100,120}})));

  Modelica.Blocks.Interfaces.RealInput m_flow(
    final quantity="MassFlowRate",
    final unit="kg/s") "Mass flow rate"
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));

  Modelica.Blocks.Interfaces.RealInput dp(
    final quantity="PressureDifference",
    final unit="Pa")
    "Pressure difference (positive if mover is operating as usual)"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));

  Modelica.Blocks.Interfaces.RealInput rho(
    final quantity="Density",
    final unit="kg/m3",
    min=0.0) "Medium density"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));

  Modelica.Blocks.Interfaces.RealOutput V_flow(
    quantity="VolumeFlowRate",
    final unit="m3/s") "Volume flow rate"
    annotation (Placement(transformation(extent={{100,80},{120,100}}),
        iconTransformation(extent={{100,80},{120,100}})));

  Modelica.Blocks.Interfaces.RealOutput WFlo(
    quantity="Power",
    final unit="W") "Flow work"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

  Modelica.Blocks.Interfaces.RealOutput PEle(
    quantity="Power",
    final unit="W") "Electrical power consumed"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));

  Modelica.Blocks.Interfaces.RealOutput eta(
    final quantity="Efficiency",
    final unit="1",
    min=0,
    max=1) "Overall efficiency"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Interfaces.RealOutput etaHyd(
    final quantity="Efficiency",
    final unit="1",
    min=0,
    max=1) "Hydraulic efficiency"
    annotation (Placement(transformation(extent={{100,-52},{120,-32}})));

  Modelica.Blocks.Interfaces.RealOutput etaMot(
    final quantity="Efficiency",
    final unit="1",
    min=0,
    max=1) "Motor efficiency"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));

 // Derivatives for cubic spline
protected
  final parameter Real motDer[size(per.motorEfficiency.V_flow, 1)](each fixed=false)
    "Coefficients for polynomial of motor efficiency vs. volume flow rate";
  final parameter Real hydDer[size(per.hydraulicEfficiency.V_flow,1)](each fixed=false)
    "Coefficients for polynomial of hydraulic efficiency vs. volume flow rate";

initial equation
   // Compute derivatives for cubic spline
 motDer = if (size(per.motorEfficiency.V_flow, 1) == 1)
          then
            {0}
          else
            Annex60.Utilities.Math.Functions.splineDerivatives(
              x=per.motorEfficiency.V_flow,
              y=per.motorEfficiency.eta,
              ensureMonotonicity=Annex60.Utilities.Math.Functions.isMonotonic(
                x=per.motorEfficiency.eta,
                strict=false));

  hydDer = if (size(per.hydraulicEfficiency.V_flow, 1) == 1)
           then
             {0}
           else
             Annex60.Utilities.Math.Functions.splineDerivatives(
               x=per.hydraulicEfficiency.V_flow,
               y=per.hydraulicEfficiency.eta);
equation
  V_flow = m_flow/rho;

  etaHyd = cha.efficiency(
    per=per.hydraulicEfficiency,
    V_flow=V_flow,
    d=hydDer,
    r_N=1,
    delta=1E-4);

  etaMot = cha.efficiency(
    per=per.motorEfficiency,
    V_flow=V_flow,
    d=motDer,
    r_N=1,
    delta=1E-4);

  eta = etaHyd * etaMot;

  // Flow work
  WFlo = dp*V_flow;

  PEle = WFlo / Annex60.Utilities.Math.Functions.smoothMax(x1=eta, x2=1E-5, deltaX=1E-6);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Text(extent={{36,98},{86,84}},
          lineColor={0,0,127},
          textString="V_flow"),
        Text(extent={{38,34},{88,20}},
          lineColor={0,0,127},
          textString="PEle"),
        Text(extent={{32,6},{82,-8}},
          lineColor={0,0,127},
          textString="eta"),
        Text(extent={{32,-32},{82,-46}},
          lineColor={0,0,127},
          textString="etaHyd"),
        Text(extent={{34,-72},{84,-86}},
          lineColor={0,0,127},
          textString="etaMot"),
        Text(extent={{38,68},{88,54}},
          lineColor={0,0,127},
          textString="WFlo")}),
    Documentation(info="<html>
<p>
This is an interface that implements the functions to compute the head, power draw
and efficiency of fans and pumps. It is used by the model
<a href=\"modelica://Annex60.Fluids.Movers.BaseClasses.FlowControlledMachine\">FlowControlledMachine</a>.
</p>
<p>
The nominal hydraulic characteristic (volume flow rate versus total pressure) is given by a set of data points
using the data record <code>data</code>, which is an instance of
<a href=\"modelica://Annex60.Fluid.Movers.Data.Generic\">
Annex60.Fluid.Movers.Data.Generic</a>.
A cubic hermite spline with linear extrapolation is used to compute the performance at other
operating points.
</p>
<p>The fan or pump energy balance can be specified in two alternative ways: </p>

<ul>
<li>
If <code>per.use_powerCharacteristic = false</code>, then the data points for
normalized volume flow rate versus efficiency is used to determine the efficiency,
and then the power consumption. The default is a constant efficiency of <i>0.7</i>.
</li>
<li>
If <code>per.use_powerCharacteristic = true</code>, then the data points for
normalized volume flow rate versus power consumption
is used to determine the power consumption, and then the efficiency
is computed based on the actual power consumption and the flow work.
</li>
</ul>

<h4>Implementation</h4>
<p>
For numerical reasons, the user-provided data points for volume flow rate
versus pressure rise are modified to add a fan internal flow resistance.
Because this flow resistance is subtracted during the simulation when
computing the fan pressure rise, the model reproduces the exact points
that were provided by the user.
</p>
<p>
Also for numerical reasons, the pressure rise at zero flow rate and
the flow rate at zero pressure rise is added to the user-provided data,
unless the user already provides these data points.
Since Modelica 3.2 does not allow dynamic memory allocation, this
implementation required the use of three different arrays for the
situation where no additional point is added, where one additional
point is added and where two additional points are added.
The parameter <code>curve</code> causes the correct data record
to be used during the simulation.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference and reformatted code.
This is
for <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/404\">#404</a>.
</li>
<li>
September 2, 2015, by Michael Wetter:<br/>
Corrected computation of
<code>etaMot = cha.efficiency(per=per.motorEfficiency, V_flow=V_flow, d=motDer, r_N=r_N, delta=1E-4)</code>
which previously used <code>V_flow_max</code> instead of <code>V_flow</code>.
</li>
<li>
January 6, 2015, by Michael Wetter:<br/>
Revised model for OpenModelica.
</li>
<li>
November 22, 2014, by Michael Wetter:<br/>
Removed in <code>N_actual</code> and <code>N_filtered</code>
the <code>max</code> attribute to
avoid a translation warning.
</li>
<li>
April 21, 2014, by Filip Jorisson and Michael Wetter:<br/>
Changed model to use
<a href=\"modelica://Annex60.Fluid.Movers.Data.Generic\">
Annex60.Fluid.Movers.Data.Generic</a>.
April 19, 2014, by Filip Jorissen:<br/>
Passed extra parameters to power() and efficiency()
to be able to properly evaluate the
scaling law. See
<a href=\"https://github.com/lbl-srg/modelica-buildings/pull/202\">#202</a>
for a discussion and validation.
</li>
<li>
September 27, 2013, by Michael Wetter:<br/>
Reformulated <code>per=if (curve == 1) then pCur1 elseif (curve == 2) then pCur2 else pCur3</code>
by moving the computation into the idividual logical branches because OpenModelica generates an
error when assign the statement to <code>data</code>
as <code>pCur1</code>, <code>pCur2</code> and <code>pCur3</code> have different dimensions.
</li>
<li>
September 17, 2013, by Michael Wetter:<br/>
Added missing <code>each</code> keyword in declaration of parameters
that are an array.
</li>
<li>
March 20, 2013, by Michael Wetter:<br/>
Removed assignment in declaration of <code>pCur?.V_flow</code> as
these parameters have the attribute <code>fixed=false</code> set.
</li>
<li>
October 11, 2012, by Michael Wetter:<br/>
Added implementation of <code>WFlo = eta * P</code> with
guard against division by zero.
Changed implementation of <code>etaMot=sqrt(eta)</code> to
<code>etaHyd = 1</code> to avoid infinite derivative as <code>eta</code>
converges to zero.
</li>
<li>
February 20, 2012, by Michael Wetter:<br/>
Assigned value to nominal attribute of <code>V_flow</code>.
</li>
<li>
February 14, 2012, by Michael Wetter:<br/>
Added filter for start-up and shut-down transient.
</li>
<li>
October 4 2011, by Michael Wetter:<br/>
Revised the implementation of the pressure drop computation as a function
of speed and volume flow rate.
The new implementation avoids a singularity near zero volume flow rate and zero speed.
</li>
<li>
March 28 2011, by Michael Wetter:<br/>
Added <code>homotopy</code> operator.
</li>
<li>
March 23 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end EfficiencyInterface;
