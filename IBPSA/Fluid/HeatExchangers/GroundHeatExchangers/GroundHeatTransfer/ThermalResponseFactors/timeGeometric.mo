within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors;
function timeGeometric "Geometric expansion of time steps"
  extends Modelica.Icons.Function;

  // fixme: check if dt and t_max should have units of s, or are indeed non-dimensional,
  // in which case unit="1" should be declared for clarity.
  input Real dt "Minimum time step";
  input Real t_max "Maximum value of time";
  input Integer nbTim "Number of time values";

  output Real t[nbTim] "Time vector";

  // fixme: comment and units if applicable missing for r and dr
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
annotation (
Documentation(info="<html>
<p>
This function attemps to build a vector of length <code>nbTim</code> with a geometric
expansion of the time variable between <code>dt</code> and <code>t_max</code>.
</p>
<p>
If <code>t_max &gt; nbTim*dt</code>, then a geometrically expanding vector is built as
</p>
<p align=\"center\">
<i>t = [dt, dt*(1-r<sup>2</sup>)/(1-r), ... , dt*(1-r<sup>n</sup>)/(1-r), ... , t<sub>max</sub>],</i>
</p>
<p>
where <i>r</i> is the geometric expansion factor.
</p>
<p>
If <code>t_max &lt; nbTim*dt</code>, then a linearly expanding vector is built as
</p>
<p align=\"center\">
<i>t = [dt, 2*dt, ... , n*dt, ... , <code>nbTim</code>*dt]</i>
</p>
</html>", revisions="<html>
<ul>
<li>
June 28, 2018 by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end timeGeometric;
