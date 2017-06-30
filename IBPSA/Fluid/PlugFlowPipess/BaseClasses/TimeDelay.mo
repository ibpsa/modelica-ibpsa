within IBPSA.Fluid.PlugFlowPipess.BaseClasses;
model TimeDelay "Delay time for given normalized velocity"

  Modelica.Blocks.Interfaces.RealInput m_flow "Mass flow of fluid" annotation (
      Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  parameter Modelica.SIunits.Length length "Pipe length";
  parameter Modelica.SIunits.Length diameter=0.05 "diameter of pipe";
  parameter Modelica.SIunits.Density rho=1000 "Standard density of fluid";
  parameter Boolean initDelay=false
    "Initialize delay for a constant mass flow rate if true, otherwise start from 0"
    annotation (Dialog(group="Initialization"));
  parameter Modelica.SIunits.Time time0=0 "Start time of simulation";
  parameter Modelica.SIunits.MassFlowRate m_flowInit=0
    annotation (Dialog(group="Initialization", enable=initDelay));

  final parameter Modelica.SIunits.Time tInStart= if initDelay then min(length/
      m_flowInit*(rho*diameter^2/4*Modelica.Constants.pi),0) else 0
    "Initial value of input time at inlet";
  final parameter Modelica.SIunits.Time tOutStart=if initDelay then min(-length/
      m_flowInit*(rho*diameter^2/4*Modelica.Constants.pi),0) else 0
    "Initial value of input time at outlet";

  Modelica.SIunits.Time time_out_rev "Reverse flow direction output time";
  Modelica.SIunits.Time time_out_des "Design flow direction output time";

  Real x(start=0) "Spatial coordinate for spatialDistribution operator";
  Modelica.SIunits.Frequency u "Normalized fluid velocity (1/s)";
  Modelica.Blocks.Interfaces.RealOutput tau
    "Time delay for design flow direction"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput tauRev "Time delay for reverse flow"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));

  parameter Real epsilon=1e-10;

equation
  u = m_flow/(rho*(diameter^2)/4*Modelica.Constants.pi)/length;

  der(x) = u;
  (time_out_rev,time_out_des) = spatialDistribution(
    time,
    time,
    x,
    u >= 0,
    {0.0,1.0},
    {time + tInStart,time + tOutStart});

  tau = time - time_out_des;
  tauRev = time - time_out_rev;

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-92,0},{-80.7,34.2},{-73.5,53.1},{-67.1,66.4},{-61.4,74.6},{-55.8,
              79.1},{-50.2,79.8},{-44.6,76.6},{-38.9,69.7},{-33.3,59.4},{-26.9,44.1},
              {-18.83,21.2},{-1.9,-30.8},{5.3,-50.2},{11.7,-64.2},{17.3,-73.1},{
              23,-78.4},{28.6,-80},{34.2,-77.6},{39.9,-71.5},{45.5,-61.9},{51.9,
              -47.2},{60,-24.8},{68,0}},
          color={0,0,127},
          smooth=Smooth.Bezier),
        Line(points={{-64,0},{-52.7,34.2},{-45.5,53.1},{-39.1,66.4},{-33.4,74.6},
              {-27.8,79.1},{-22.2,79.8},{-16.6,76.6},{-10.9,69.7},{-5.3,59.4},{1.1,
              44.1},{9.17,21.2},{26.1,-30.8},{33.3,-50.2},{39.7,-64.2},{45.3,-73.1},
              {51,-78.4},{56.6,-80},{62.2,-77.6},{67.9,-71.5},{73.5,-61.9},{79.9,
              -47.2},{88,-24.8},{96,0}}, smooth=Smooth.Bezier),
        Text(
          extent={{20,100},{82,30}},
          lineColor={0,0,255},
          textString="PDE"),
        Text(
          extent={{-82,-30},{-20,-100}},
          lineColor={0,0,255},
          textString="tau"),
        Text(
          extent={{-60,140},{60,100}},
          lineColor={0,0,255},
          textString="%name")}),
    Documentation(info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Calculates time delay as the difference between the current simulation time and the inlet time. The inlet time is propagated with the corresponding fluid parcel using the spatialDistribution function. Calculates time delay as the difference between the current simulation time and the inlet time. The inlet time is propagated with the corresponding fluid parcel using the spatialDistribution function. This components requires the mass flow through (one of) the pipe(s) and the pipe dimensions in order to derive information about the fluid propagation. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This component has a different handling of zero flow periods in order to prevent glitches in the output delay time. </span></p>
</html>", revisions="<html>
<ul>
<li>September 9, 2016 by Bram van der Heijde:</li>
<p>Rename from PDETime_massFlowMod to TimeDelayMod</p>
<li><span style=\"font-family: MS Shell Dlg 2;\">December 2015 by Carles Ribas Tugores:<br>Modification in delay calculation to fix issues.</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">November 6, 2015 by Bram van der Heijde:<br>Adapted flow parameter to mass flow rate instead of velocity. This change should also fix the reverse and zero flow issues.</span></li>
<li>October 13, 2015 by Marcus Fuchs:<br>Use <code>abs()</code> of normalized velocity input in order to avoid negative delay times. </li>
<li>July 2015 by Arnout Aertgeerts:<br>First implementation. </li>
</ul>
</html>"));
end TimeDelay;
