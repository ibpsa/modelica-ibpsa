within Annex60.Experimental.Pipe.BaseClasses;
model PDETime_massFlow "Delay time for given normalized velocity"

  Real x(start=0) "Normalized transport distance";
  Modelica.SIunits.Time timeOut_a
    "Time at which the fluid is leaving the pipe at port_a";
  Modelica.SIunits.Time timeOut_b
    "Time at which the fluid is leaving the pipe at port_b";
  parameter Modelica.SIunits.Length len=100 "length";
  parameter Modelica.SIunits.Length diameter=0.05 "diameter of pipe";
  parameter Modelica.SIunits.Density rho=1000 "Standard density of fluid";
  Modelica.SIunits.Time track1;
  Modelica.SIunits.Time track2;
  Modelica.SIunits.Time tau_a;
  Modelica.SIunits.Time tau_b;
  Boolean v_a "Is the fluid flowing from a to b?";
  Boolean v_b "Is the fluid flowing from b to a?";
  Real u=m_flow/(len*rho*diameter^2/4*Modelica.Constants.pi)
    "Normalized fluid velocity";
  Real t=time;

  Modelica.Blocks.Interfaces.RealInput m_flow "Mass flow of fluid" annotation (
      Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.RealOutput tau "Time delay"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  //Speed
  der(x) = u;

  (timeOut_a,timeOut_b) = spatialDistribution(
    time,
    time,
    x,
    u >= 0,
    {0.0,1.0},
    {0.0,0.0});

  tau_a = time - timeOut_a;
  /*Annex60.Utilities.Math.Functions.smoothMax(
    time - TimeOut_a,
    track2 - track1,
    1);*/
  tau_b = time - timeOut_b;

  tau = Annex60.Utilities.Math.Functions.smoothMax(tau_a, tau_b,100);

  v_a = u > 0;
  v_b = u < 0;
  when change(v_a) then
    track1 = pre(time);
  end when;
  when change(v_b) then
    track2 = pre(time);
  end when;
  when time - timeOut_a > (track2 - track1) and v_b then
    reinit(track1, 0);
    reinit(track2, 0);
  end when;

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
<p><span style=\"font-family: MS Shell Dlg 2;\">Calculates time delay as the difference between the current simulation time and the inlet time. The inlet time is propagated with the corresponding fluid parcel using the spatialDistribution function.</span></p>
</html>", revisions="<html>
<ul>
<li>
October 13, 2015 by Marcus Fuchs:<br/>
Use <code>abs()</code> of normalized velocity input in order to avoid negative delay times.
</li>
<li>
2015 by Bram van der Heijde:<br/>
First implementation.
</li>
</ul>
</html>"));
end PDETime_massFlow;
