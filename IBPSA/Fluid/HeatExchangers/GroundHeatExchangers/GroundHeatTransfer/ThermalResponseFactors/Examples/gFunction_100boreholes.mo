within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.Examples;
model gFunction_100boreholes
  "gFunction calculation for a field of 10 by 10 boreholes"
  extends Modelica.Icons.Example;

  parameter Integer nbBor = 100 "Number of boreholes";
  parameter Real cooBor[nbBor, 2] = {{7.5*mod(i-1,10), 7.5*floor((i-1)/10)} for i in 1:nbBor} "Coordinates of boreholes";
  parameter Real hBor = 150 "Borehole length";
  parameter Real dBor = 4 "Borehole buried depth";
  parameter Real rBor = 0.075 "Borehole radius";
  parameter Real alpha = 1e-6 "Ground thermal diffusivity used in g-function evaluation";

  Real gFun_int;
  Real lntts_int;
  final parameter Integer nt=75;
  final parameter Real[nt] gFun(fixed=false);
  final parameter Real[nt] lntts(fixed=false);
  final parameter Modelica.SIunits.Time[nt] t_gFun(fixed=false);
  final parameter Real[nt+1] dspline(fixed=false);
  discrete Integer k;
  discrete Modelica.SIunits.Time t1;
  discrete Modelica.SIunits.Time t2;
  discrete Real gFun1;
  discrete Real gFun2;
  parameter Modelica.SIunits.Time ts = hBor^2/(9*alpha);

initial equation

  // Evaluate g-function for the specified bore field configuration
  (lntts,gFun) =
    IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.gFunction(
    nbBor,
    cooBor,
    hBor,
    dBor,
    rBor);
    t_gFun = ts*exp(lntts);
  // Initialize parameters for interpolation
    dspline = IBPSA.Utilities.Math.Functions.splineDerivatives(cat(1, {0}, t_gFun), cat(1, {0}, gFun));
  k = 1;
  t1 = 0;
  t2 = t_gFun[1];
  gFun1 = 0;
  gFun2 = gFun[1];

equation

  // Dimensionless logarithmic time
  lntts_int = log(IBPSA.Utilities.Math.Functions.smoothMax(time, 1e-6, 2e-6)/ts);
  // Interpolate g-function
  gFun_int = IBPSA.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(time, t1, t2, gFun1, gFun2, dspline[pre(k)], dspline[pre(k)+1]);
  // Update interpolation parameters, when needed
  when time >= pre(t2) then
    k = min(pre(k) + 1, nt);
    t1 = t_gFun[k-1];
    t2 = t_gFun[k];
    gFun1 = gFun[k-1];
    gFun2 = gFun[k];
  end when;

   annotation(experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Fluid/HeatExchangers/GroundHeatExchangers/GroundHeatTransfer/ThermalResponseFactors/Examples/gFunction_100boreholes.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This example checks the implementation of functions that evaluate the
g-function of a borefield of 100 boreholes in a 10 by 10 configuration.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 20, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end gFunction_100boreholes;
