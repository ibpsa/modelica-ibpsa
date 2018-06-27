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
  parameter Integer nbSeg = 12 "Number of line source segments per borehole";
  parameter Integer nbTimSho = 26 "Number of time steps in short time region";
  parameter Integer nbTimLon = 50 "Number of time steps in long time region";
  parameter Real ttsMax = exp(5) "Maximum adimensional time for gfunc calculation";

  Real gFun_int;
  Real lntts_int;
  final parameter Integer nbTimTot=nbTimSho+nbTimLon;
  final parameter Real[nbTimTot] gFun(fixed=false);
  final parameter Real[nbTimTot] lntts(fixed=false);
  final parameter Modelica.SIunits.Time[nbTimTot] tGFun(fixed=false);
  final parameter Real[nbTimTot] dspline(fixed=false);
  discrete Integer k;
  discrete Modelica.SIunits.Time t1;
  discrete Modelica.SIunits.Time t2;
  discrete Real gFun1;
  discrete Real gFun2;
  parameter Modelica.SIunits.Time ts = hBor^2/(9*alpha);

initial equation

  // Evaluate g-function for the specified bore field configuration
  (tGFun,gFun) =
    IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.gFunction(
      nbBor, cooBor, hBor, dBor, rBor, alpha, nbSeg, nbTimSho, nbTimLon, ttsMax);
  lntts = log(tGFun/ts .+ Modelica.Constants.small);
  // Initialize parameters for interpolation
  dspline = IBPSA.Utilities.Math.Functions.splineDerivatives(tGFun, gFun);
  k = 1;
  t1 = tGFun[1];
  t2 = tGFun[2];
  gFun1 = gFun[1];
  gFun2 = gFun[2];

equation

  // Dimensionless logarithmic time
  lntts_int = log(IBPSA.Utilities.Math.Functions.smoothMax(time, 1e-6, 2e-6)/ts);
  // Interpolate g-function
  gFun_int = IBPSA.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
    time, t1, t2, gFun1, gFun2, dspline[pre(k)], dspline[pre(k)+1]);
  // Update interpolation parameters, when needed
  when time >= pre(t2) then
    k = min(pre(k) + 1, nbTimTot);
    t1 = tGFun[k];
    t2 = tGFun[k+1];
    gFun1 = gFun[k];
    gFun2 = gFun[k+1];
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
