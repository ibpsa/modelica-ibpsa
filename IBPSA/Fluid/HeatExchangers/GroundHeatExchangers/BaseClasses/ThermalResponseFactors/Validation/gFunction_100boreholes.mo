within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ThermalResponseFactors.Validation;
model gFunction_100boreholes
  "gFunction calculation for a field of 3 by 2 boreholes"
  extends Modelica.Icons.Example;

//   parameter Integer nbBor = 6 "Number of boreholes";
//   parameter Real cooBor[nbBor, 2] = {{0, 0}, {7.5,0}, {15.0,0}, {0, 7.5}, {7.5,7.5}, {15.0,7.5}} "Coordinates of boreholes";
//   parameter Integer nbBor = 24 "Number of boreholes";
//   parameter Real cooBor[nbBor, 2] = {{0, 0}, {7.5,0}, {15.0,0}, {22.5,0}, {30,0}, {37.5,0}, {0, 7.5}, {7.5,7.5}, {15.0,7.5}, {22.5,7.5}, {30,7.5}, {37.5,7.5}, {0, 15}, {7.5,15}, {15.0,15}, {22.5,15}, {30,15}, {37.5,15}, {0, 22.5}, {7.5,22.5}, {15.0,22.5}, {22.5,22.5}, {30,22.5}, {37.5,22.5}} "Coordinates of boreholes";
  parameter Integer nbBor = 100 "Number of boreholes";
  parameter Real cooBor[nbBor, 2] = {{0.0,0.0},
{7.5,0.0},
{15.0,0.0},
{22.5,0.0},
{30.0,0.0},
{37.5,0.0},
{45.0,0.0},
{52.5,0.0},
{60.0,0.0},
{67.5,0.0},
{0.0,7.5},
{7.5,7.5},
{15.0,7.5},
{22.5,7.5},
{30.0,7.5},
{37.5,7.5},
{45.0,7.5},
{52.5,7.5},
{60.0,7.5},
{67.5,7.5},
{0.0,15.0},
{7.5,15.0},
{15.0,15.0},
{22.5,15.0},
{30.0,15.0},
{37.5,15.0},
{45.0,15.0},
{52.5,15.0},
{60.0,15.0},
{67.5,15.0},
{0.0,22.5},
{7.5,22.5},
{15.0,22.5},
{22.5,22.5},
{30.0,22.5},
{37.5,22.5},
{45.0,22.5},
{52.5,22.5},
{60.0,22.5},
{67.5,22.5},
{0.0,30.0},
{7.5,30.0},
{15.0,30.0},
{22.5,30.0},
{30.0,30.0},
{37.5,30.0},
{45.0,30.0},
{52.5,30.0},
{60.0,30.0},
{67.5,30.0},
{0.0,37.5},
{7.5,37.5},
{15.0,37.5},
{22.5,37.5},
{30.0,37.5},
{37.5,37.5},
{45.0,37.5},
{52.5,37.5},
{60.0,37.5},
{67.5,37.5},
{0.0,45.0},
{7.5,45.0},
{15.0,45.0},
{22.5,45.0},
{30.0,45.0},
{37.5,45.0},
{45.0,45.0},
{52.5,45.0},
{60.0,45.0},
{67.5,45.0},
{0.0,52.5},
{7.5,52.5},
{15.0,52.5},
{22.5,52.5},
{30.0,52.5},
{37.5,52.5},
{45.0,52.5},
{52.5,52.5},
{60.0,52.5},
{67.5,52.5},
{0.0,60.0},
{7.5,60.0},
{15.0,60.0},
{22.5,60.0},
{30.0,60.0},
{37.5,60.0},
{45.0,60.0},
{52.5,60.0},
{60.0,60.0},
{67.5,60.0},
{0.0,67.5},
{7.5,67.5},
{15.0,67.5},
{22.5,67.5},
{30.0,67.5},
{37.5,67.5},
{45.0,67.5},
{52.5,67.5},
{60.0,67.5},
{67.5,67.5}} "Coordinates of boreholes";
  parameter Real hBor = 150 "Borehole length";
  parameter Real dBor = 4 "Borehole buried depth";
  parameter Real rBor = 0.075 "Borehole radius";
  parameter Real alpha = 1e-6 "Ground thermal diffusivity used in g-function evaluation";

  Real gFunc_int;
  Real lntts_int;
  final parameter Real[50] gFun(fixed=false);
  final parameter Real[50] lntts(fixed=false);
  final parameter Real[50] t_gFun(fixed=false);
  Integer k;
  parameter Real ts = hBor^2/(9*alpha);

initial equation

  (lntts,gFun) =
    IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ThermalResponseFactors.gFunction(
    nbBor,
    cooBor,
    hBor,
    dBor,
    rBor);
    t_gFun = ts*exp(lntts);

equation

  lntts_int = log(IBPSA.Utilities.Math.Functions.smoothMax(time, 1e-6, 2e-6)/ts);
  (gFunc_int,k) = Modelica.Math.Vectors.interpolate(cat(1, {-1e99}, lntts), cat(1, {0}, gFun), lntts_int);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end gFunction_100boreholes;
