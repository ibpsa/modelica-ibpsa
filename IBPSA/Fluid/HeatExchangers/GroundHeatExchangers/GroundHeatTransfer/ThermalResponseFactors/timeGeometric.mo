within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors;
function timeGeometric "Geometric expansion of time steps"
  extends Modelica.Icons.Function;

  input Real dt "Minimum time step";
  input Real t_max "Maximum value of time";
  input Integer nbTim "Number of time values";

  output Real t[nbTim] "Time vector";

protected
  Real r;
  Real dr;

algorithm

  if t_max > nbTim*dt then
    // Determine expansion rate (r)
    dr := 1e99;
    r := 2;
    while abs(dr) > 1e-10 loop
      dr := (1+t_max/dt*(r-1))^(1/nbTim) - r;
      r := r + dr;
    end while;
    // Assign time values
    for i in 1:nbTim-1 loop
      t[i] := dt*(1-r^i)/(1-r);
    end for;
      t[nbTim] := t_max;

  else
    // Number of time values to large for chosen parameters:
    // Use a constant time step
    for i in 1:nbTim loop
      t[i] := i*dt;
    end for;

  end if;

end timeGeometric;
