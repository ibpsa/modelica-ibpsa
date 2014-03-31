within IDEAS.Controls.Control_fixme;
block Timer_NoEvents "Min-on OR min-off timer that does not generate events"

  /*
  
  Best version so far but still not working
  
  
  This model is a timer, based on a thermal capacity that recieves a fixed heat flow
  when the timer is activated until a certain temperature (depending on the duration and 
  capacity) is reached.  
  
  The model can be used to set a minimum-on time or a minimum off-time (parameter to set the type)
    
  The INPUT is the signal from the process that has to be timed (Real): 
  - < 0.5 if the process is OFF
  - > 0.5 if the process is ON
  
  The OUTPUT (Real) is different for on or off-timing :
  ON-timing:
  - > 0.5 when the timer is running
  - < 0.5 when the duration has passed
  OFF-timing:
  - < 0.5 when the timer is running
  - > 0.5 when the duration has passed
  
  To reset the timer, the capacity has to be cooled down again because it has to start from the same temperature
  always in order to keep the code eventless.  This is NOT instantaneous and the time constant of cooling down is set to 
  be 100 times smaller than for timing. 
  
  
  First implementation: RDC based on an idea of Ruben Baetens, 20110801
  */

  import IDEAS.Climate.Time.BaseClasses.TimerType;
  parameter TimerType timerType(start=TimerType.off) "Type of the timer";
  parameter Modelica.SIunits.Time duration "Duration of the timer";

  //protected
  constant Modelica.SIunits.Temperature TStart=300;
  constant Modelica.SIunits.Temperature TStep=100;
  // the G-value is chosen in order to make sure that RC = duration, meaning that the time
  // constant of the RC-component is equal to the duration of the timer.
  parameter Modelica.SIunits.ThermalConductance GLow=C/duration;
  parameter Modelica.SIunits.HeatCapacity C=1e6;
  parameter Modelica.SIunits.Temperature TEnd=TStart + TStep*(1 - exp(-1));

  IDEAS.Thermal.Components.BaseClasses.VariableThermalConductor RVar
    annotation (Placement(transformation(extent={{-36,18},{-16,38}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TAmb
    annotation (Placement(transformation(extent={{-84,18},{-64,38}})));
public
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor cap(
    C=C,
    der_T(fixed=false),
    T(fixed=true, start=TStart))
    annotation (Placement(transformation(extent={{4,46},{24,66}})));

public
  Modelica.Blocks.Interfaces.RealInput u
    annotation (Placement(transformation(extent={{-126,-20},{-86,20}})));
  Modelica.Blocks.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{96,-10},{116,10}})));
algorithm
  if timerType == TimerType.off then
    if noEvent(u < 0.5 or y < 0.5) then
      RVar.G := GLow;
      TAmb.T := TStart + TStep;
    else
      RVar.G := 1e2*GLow;
      TAmb.T := TStart;
    end if;

  else
    if noEvent(u > 0.5 or y > 0.5) then
      RVar.G := GLow;
      TAmb.T := TStart + TStep;
    else
      RVar.G := 1e2*GLow;
      TAmb.T := TStart;
    end if;

  end if;

equation
  if timerType == TimerType.off then
    y = if noEvent(IDEAS.Controls.Control_fixme.Hysteresis_NoEvent(
      cap.T,
      y,
      TStart + TStep/2,
      TEnd) > 0.5 or der(cap.T) <= 0 or cap.T < (TStart + Modelica.Constants.small))
       then 1 else 0;
  else
    y = if noEvent(IDEAS.Controls.Control_fixme.Hysteresis_NoEvent(
      cap.T,
      1 - y,
      TStart + TStep/2,
      TEnd) > 0.5 or der(cap.T) <= 0 or cap.T < (TStart + Modelica.Constants.small))
       then 0 else 1;
  end if;

  connect(RVar.port_b, cap.port) annotation (Line(
      points={{-16,28},{14,28},{14,46}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TAmb.port, RVar.port_a) annotation (Line(
      points={{-64,28},{-36,28}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics={Ellipse(extent={{-54,56},{60,-62}},
          lineColor={0,0,255}),Rectangle(
          extent={{-2,56},{8,66}},
          lineColor={0,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),Line(
          points={{4,-2},{32,46},{32,38},{26,42},{32,46}},
          color={0,0,255},
          smooth=Smooth.None,
          thickness=0.5)}));
end Timer_NoEvents;
