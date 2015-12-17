within Annex60.Experimental.Pipe;
model spatialDist_testBothDirections_andTrack

  parameter Modelica.SIunits.Length length "Pipe length";
  Modelica.SIunits.Time time_out_a "Virtual time after delay at port a";
  Modelica.SIunits.Time time_out_b "Virtual time after delay at port b";
  Modelica.SIunits.Time time_out_a_lim "Virtual time after delay at port a";
  Modelica.SIunits.Time time_out_b_lim "Virtual time after delay at port b";
  Modelica.SIunits.Time tau "Time delay for input time";
  Modelica.SIunits.Time tau_lim "Time delay for input time";
  Modelica.SIunits.Length x(start=0)
    "Spatial coordiante for spatialDistribution operator";
  Modelica.Blocks.Interfaces.RealInput v "Normalized fluid velocity"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
  Modelica.Blocks.Interfaces.RealOutput y=tau "Time delay"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  // - - - track
  Boolean zeroPeriod;
  Boolean NonZeroPeriod;
  Boolean Border_a;
  Boolean Border_b;
  Modelica.SIunits.Time trackBegin;
  Modelica.SIunits.Time trackEnd;
  Modelica.SIunits.Time track;
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
    tau = max(0,time - time_out_b);
  else
    tau = max(0,time - time_out_a);
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

  Border_a = (time-time_out_a) > trackEnd;
  Border_b = (time-time_out_b) > trackEnd;

  when edge(Border_a) or edge(Border_b) then
    reinit(trackEnd,0);
  end when;

  if (time-time_out_a) <= trackEnd then
    (time-time_out_a_lim) = trackEnd;
  else
    time_out_a_lim = time_out_a;
  end if;

  if (time-time_out_b) <= trackEnd then
    (time-time_out_b_lim) = trackEnd;
  else
    time_out_b_lim = time_out_b;
  end if;

  if v>= 0 then
    tau_lim = max(0,time - time_out_b_lim);
  else
    tau_lim = max(0,time - time_out_a_lim);
  end if;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end spatialDist_testBothDirections_andTrack;
