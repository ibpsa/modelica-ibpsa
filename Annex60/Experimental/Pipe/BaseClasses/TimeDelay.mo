within Annex60.Experimental.Pipe.BaseClasses;
model TimeDelay "Delay time for given normalized velocity"

  Real x(start=0) "Normalized transport distance";
  Modelica.SIunits.Time timeOut_a
    "Time at which the fluid is leaving the pipe at port_a";
  Modelica.SIunits.Time timeOut_b
    "Time at which the fluid is leaving the pipe at port_b";
  parameter Modelica.SIunits.Length len=100 "length";
  parameter Modelica.SIunits.Length diameter=0.05 "diameter of pipe";
  parameter Modelica.SIunits.Density rho=1000 "Standard density of fluid";
  Modelica.SIunits.Time track_a(start=0);
  Modelica.SIunits.Time track_b(start=0);
  Modelica.SIunits.Time tau_a;
  Modelica.SIunits.Time tau_b;
  Modelica.SIunits.Time inp_a(start=0);
  Modelica.SIunits.Time inp_b(start=0);
  Boolean v_a "Is the fluid flowing from a to b?";
  Boolean v_b "Is the fluid flowing from b to a?";
  Boolean v_0 "Is the fluid standing still?";
  //Boolean fr "Did flow reversal occur?";
  //Boolean ff "Memory for positive (t) or negative flow (f)";
  Real u=m_flow/(len*rho*diameter^2/4*Modelica.Constants.pi)
    "Normalized fluid velocity";
  Real t=time;
  parameter Real eps=1e-10 "Dead band for zero flow criterium";
  parameter Boolean initDelay=false
    "Initialize delay for a constant mass flow rate if true, otherwise start from 0"
    annotation (Dialog(group="Initialization"));

  final parameter Modelica.SIunits.Time tInStart= if initDelay then min(len/
      m_flowInit*(rho*diameter^2/4*Modelica.Constants.pi),0) else 0
    "Initial value of input time at inlet";
  final parameter Modelica.SIunits.Time tOutStart=if initDelay then min(-len/
      m_flowInit*(rho*diameter^2/4*Modelica.Constants.pi),0) else 0
    "Initial value of input time at outlet";

  Modelica.Blocks.Interfaces.RealInput m_flow "Mass flow of fluid" annotation (
      Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.RealOutput tau "Time delay"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  //initial equation
  //fr = false;
  //ff = true;

  parameter Modelica.SIunits.MassFlowRate m_flowInit = 0
    annotation (Dialog(group="Initialization", enable=initDelay));

initial equation
  if initDelay then
    tau=abs(len/m_flowInit*(rho*diameter^2/4*Modelica.Constants.pi));
  else
    tau=0;
  end if;
equation
  //Speed
  der(x) = u;
  (timeOut_a,timeOut_b) = spatialDistribution(
    inp_a,
    inp_b,
    x,
    u >= 0,
    {0.0,1.0},
    {tInStart,tOutStart});

  /*Annex60.Utilities.Math.Functions.smoothMax(
    time - TimeOut_a,
    track2 - track1,
    1);*/

  v_a = u > eps;
  v_b = u < -eps;
  v_0 = abs(u) < eps;
  //not (v_a or v_b);

  when edge(v_0) then
    track_a = pre(timeOut_a);
    track_b = pre(timeOut_b);
  end when;
  when v_a then
    reinit(inp_b, pre(track_b));
    /*ff = true;
    fr = (ff and not pre(ff)) or (not ff and pre(ff));*/
  end when;
  when v_b then
    reinit(inp_a, pre(track_a));
    /*ff = false;
    fr = (ff and not pre(ff)) or (not ff and pre(ff));*/
  end when;

  if v_0 then
    inp_a = track_a;
    inp_b = track_b;
    tau_a = time - track_a;
    tau_b = time - track_b;
  else
    inp_a = time;
    inp_b = time;
    tau_a = time - timeOut_a;
    tau_b = time - timeOut_b;
  end if;

  tau = max(tau_a, tau_b);

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics),
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Calculates time delay as the difference between the current simulation time and the inlet time. The inlet time is propagated with the corresponding fluid parcel using the spatialDistribution function. This components requires the mass flow through (one of) the pipe(s) and the pipe dimensions in order to derive information about the fluid propagation. </span></p>
</html>", revisions="<html>
<ul>
<li>September 9, 2016 by Bram van der Heijde:<br>Rename from PDETime_massFlow to TimeDelay</li>
<li>November 6, 2015 by Bram van der Heijde:<br>Adapted flow parameter to mass flow rate instead of velocity. This change should also fix the reverse and zero flow issues.</li>
<li>October 13, 2015 by Marcus Fuchs:<br>Use <code>abs()</code> of normalized velocity input in order to avoid negative delay times. </li>
<li>July 2015 by Arnout Aertgeerts:<br>First implementation. </li>
</ul>
</html>"));
end TimeDelay;
