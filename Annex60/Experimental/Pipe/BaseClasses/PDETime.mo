within Annex60.Experimental.Pipe.BaseClasses;
model PDETime "Delay time for given normalized velocity"

  Modelica.SIunits.Time time_out_a "Virtual time after delay at port a";
  Modelica.SIunits.Time time_out_b "Virtual time after delay at port b";

  Real x "Spatial coordinate for spatialDistribution";
  Real tau2= abs(time_out_a-time_out_b);

  Modelica.Blocks.Interfaces.RealInput u "Normalized fluid velocity"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.RealOutput tau "Time delay"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  //Speed
  der(x) = u;

  //Spatial distribution of the time
  (time_out_a,
   time_out_b) = spatialDistribution(time,
                                    time,
                                    x,
                                    u>=0,
                                    {0.0, 1.0},
                                    {0.0, 0.0});

  if u >= 0 then
    tau = time - time_out_b;
  else
    tau = time - time_out_a;
  end if;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
    Line(points={{-92,0},{-80.7,34.2},{-73.5,53.1},{-67.1,66.4},{-61.4,74.6},{-55.8,
              79.1},{-50.2,79.8},{-44.6,76.6},{-38.9,69.7},{-33.3,59.4},{-26.9,44.1},
              {-18.83,21.2},{-1.9,-30.8},{5.3,-50.2},{11.7,-64.2},{17.3,-73.1},{
              23,-78.4},{28.6,-80},{34.2,-77.6},{39.9,-71.5},{45.5,-61.9},{51.9,
              -47.2},{60,-24.8},{68,0}},
      color={0,0,127},
      smooth=Smooth.Bezier),
    Line(points={{-64,0},{-52.7,34.2},{-45.5,53.1},{-39.1,66.4},{-33.4,74.6},{-27.8,
              79.1},{-22.2,79.8},{-16.6,76.6},{-10.9,69.7},{-5.3,59.4},{1.1,44.1},
              {9.17,21.2},{26.1,-30.8},{33.3,-50.2},{39.7,-64.2},{45.3,-73.1},{51,
              -78.4},{56.6,-80},{62.2,-77.6},{67.9,-71.5},{73.5,-61.9},{79.9,-47.2},
              {88,-24.8},{96,0}},
      smooth=Smooth.Bezier),
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
October 15, 2015 by Bram van der Heijde:<br/>
Implementation that allows flow reversal and a correct computation of the delay time.
</li>
<li>
October 13, 2015 by Marcus Fuchs:<br/>
Use <code>abs()</code> of normalized velocity input in order to avoid negative delay times.
</li>
<li>
2015 by Arnout Aertgeerts:<br/>
First implementation.
</li>
</ul>
</html>"));
end PDETime;
