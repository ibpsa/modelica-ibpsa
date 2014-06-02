within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.BaseClasses.GroundHX;
function BoreFieldWallTemperature
  "Return the bh of bf mean temperature @ r from its center and at time = t"
  extends BaseClasses.partialBoreFieldTemperature;
  import SI = Modelica.SIunits;

  input SI.Distance r
    "radial distance from line source (for simulation of single bh. Otherwise = r_b";

protected
  Real lb "lower boundary of integral";
  Real ub = 100
    "upper boundary of integral. Theoritical value = infty. From some tests, the value 100 seems sufficient.";
  Real res "integral value";
  SI.TemperatureDifference deltaT;
algorithm
  assert(t_d >= steRes.t_min_d, "The choosen simulation time is " + String(
    t_d*steRes.tStep) + "s but the minimum resolution time is " + String(
    steRes.t_min_d*steRes.tStep) + "s.");
  lb := 1/sqrt(4*soi.alp*t_d*steRes.tStep);

// Code commented: make it possible to extend model: for single borehole it would be possible to calculate T at any r.
//   if geo.nbBh == 1 then
//     res := Modelica.Math.Nonlinear.quadratureLobatto(
//       function Borefield.GroundHX.BaseClasses.integrandBh_rt(r=r, D=geo.hBor),
//       lb,
//       ub);
//   else
  assert(r == geo.rBor,
    "The simulation of borefield are only possible for r = rBor. Please ensure both parameters have the same value");
  res := Modelica.Math.Nonlinear.quadratureLobatto(
    function BaseClasses.integrandBf_bt(
      D=geo.hBor,
      rBor=geo.rBor,
      nbBh=geo.nbBh,
      cooBh=geo.cooBh),
    lb,
    ub);
//   end if;

  deltaT := steRes.q_ste/(4*Modelica.Constants.pi*soi.k)*res;
  T := steRes.T_ini + deltaT;

  annotation (Documentation(info="<html>
<p>
This function return the mean borehole or borefield temperature. For the <i>borehole</i>, the function returns the mean temperature at any point at distance <i>r</i> from its center and at time <i>t</i>. For The <i>borefield</i>, the function returns the temperature at <i>r=r_b</i> (the wall temperature) and at time <i>t</i>.
</p>

<p> BAD HACK for the borefield:
<ol>
<li> The mean temperature at the wall of the boreholes of the borefield is approximated by the superposition of the temperature at the borehole + temperature of the other boreholes at the center of the first one. </li>
</ol>
</p>
<p> </p>

</html>"));
end BoreFieldWallTemperature;
