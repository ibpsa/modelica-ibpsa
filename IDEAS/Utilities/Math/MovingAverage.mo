within IDEAS.Utilities.Math;
block MovingAverage "Calculates the moving average of a Real input"

  extends Modelica.Blocks.Interfaces.SISO;

  parameter Modelica.SIunits.Time period=1
    "Period over wich running average is to be computed";

protected
  Real iDelay "delayed integration";
  Real iStop(start=0, fixed=true) "integrator until stop time";

initial algorithm
  iDelay := -u*period;

equation
  der(iStop) = u;
  der(iDelay) = delay(
    u,
    period,
    period);

  if time >= 0.1 and time <= period then
    y = iStop/time;
  elseif time > period then
    y = (iStop - iDelay)/period;
  else
    y = u;
  end if;

end MovingAverage;
