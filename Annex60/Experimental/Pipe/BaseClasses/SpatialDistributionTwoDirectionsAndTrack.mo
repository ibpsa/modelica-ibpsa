within Annex60.Experimental.Pipe.BaseClasses;
model SpatialDistributionTwoDirectionsAndTrack

  parameter Modelica.SIunits.Length length "Pipe length";
  Modelica.SIunits.Time time_out_a "Virtual time after delay at port a";
  Modelica.SIunits.Time time_out_b "Virtual time after delay at port b";
  Modelica.SIunits.Time tau "Time delay for input time";
  Modelica.SIunits.Time tau_a "Time delay for input time";
  Modelica.SIunits.Time tau_b "Time delay for input time";
  Modelica.SIunits.Time tau_a_lim "Limited time delay for input time";
  Modelica.SIunits.Time tau_b_lim "Limited time delay for input time";
  Modelica.SIunits.Length x(start=0)
    "Spatial coordiante for spatialDistribution operator";
  Modelica.Blocks.Interfaces.RealInput v "Normalized fluid velocity"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
  Modelica.Blocks.Interfaces.RealOutput y=tau "Time delay"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

// -----
  Boolean zeroPeriod "true if the mass flow rate is quasi 0";
  Boolean NonZeroPeriod "true if the flow velocity is >epsilon or <-epsilon";
  Boolean track_a_evaluate "used to reinit trackEnd ";
  Boolean track_b_evaluate "used to reinit trackEnd ";
  Boolean v_a "fluid is flowing from a to b";
  Boolean v_b "flud is flowing from b to a";
  Boolean trackEnd_NotNeeded "check if this value is needed";
  Modelica.SIunits.Time trackBegin "start time of a zero mass flow rate period";
  Modelica.SIunits.Time trackEnd
    "Delay time of a mass flow rate period is stored";
  Modelica.SIunits.Time track "time delay during zero mass flow rate periods";
  Real epsilon = 0.000001;

equation
  der(x) = v;
  (time_out_a,time_out_b) = spatialDistribution(time,
                                       time,
                                       x/length,
                                       v>=0,
                                       {0.0, 1.0},
                                       {0.0, 0.0});

  if v>= 0 then
    tau = tau_b_lim;
  else
    tau = tau_a_lim;
  end if;

  if v >= epsilon then
    v_a = true;
  else
    v_a = false;
  end if;
  if v <= -epsilon then
    v_b = true;
  else
    v_b = false;
  end if;

  if abs(v) >= epsilon then
    zeroPeriod = false;
    NonZeroPeriod = true;
    track = 0;
  else
    zeroPeriod = true;
    NonZeroPeriod = false;
    track = time - trackBegin;
  end if;

  when edge(zeroPeriod) then
    trackBegin = pre(time);
  end when;
  when edge(NonZeroPeriod) then
    reinit(trackBegin,0);
    trackEnd = pre(track);
  end when;

  tau_a_lim = max(trackEnd,max(track,tau_a));
  tau_b_lim = max(trackEnd,max(track,tau_b));
  tau_a = time-time_out_a;
  tau_b = time-time_out_b;

  trackEnd_NotNeeded = track_b_evaluate <> track_a_evaluate;
  track_b_evaluate = trackEnd <= tau_b;
  track_a_evaluate = trackEnd <= tau_a;

  when (edge(track_a_evaluate) or edge(track_b_evaluate)) or edge(trackEnd_NotNeeded) then
    reinit(trackEnd,0);
  end when;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(info="<html>
<p>
Model to test the <code>spatialDistribution</code> operator in two directions together with different <code>when</code> and <code>if</code> clauses to first, calculate duration time of the zero mass flow rate periods and second, use this information to lower limit the values of the delay <code>tau</code>.
</p>
</html>"));
end SpatialDistributionTwoDirectionsAndTrack;
