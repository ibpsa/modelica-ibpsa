within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.LoadAggregation;
function timSerMat "Reads and possibly writes a matrix with a time series
  of the g-function"
  extends Modelica.Icons.Function;
  input Integer nbBor "Number of boreholes";
  input Real cooBor[nbBor, 2] "Borehole coordonates";
  input Modelica.SIunits.Height hBor "Borehole length";
  input Modelica.SIunits.Height dBor "Borehole buried depth";
  input Modelica.SIunits.Radius rBor "Borehole radius";
  input Modelica.SIunits.ThermalDiffusivity as
    "Thermal diffusivity of soil";
  input Modelica.SIunits.ThermalConductivity ks
    "Thermal conductivity of soil";
  input Integer nrow "Number of g-function points";
  input String sha "Pseudo-SHA of the g-function arguments";
  input Boolean forceGFunCalc
    "Set to true to force the thermal response to be calculated at the start";
  input Integer nbTimSho = 26 "Number of time steps in short time region";
  input Integer nbTimLon = 50 "Number of time steps in long time region";
  input Real ttsMax = exp(5) "Maximum adimensional time for gfunc calculation";

  output Real matrix[nrow+1, 2] "2D Real array with 2 columns";

protected
  Modelica.SIunits.Time ts;
  String pathSave "Path of the saving folder";
  Real[nrow] gFun;
  Real[nrow] lntts;
  Boolean writegFun = false;

algorithm
  //creation of a folder .BfData in the simulation folder
  Modelica.Utilities.Files.createDirectory(".BfData");
  pathSave := ".BfData/" + sha + "Tstep.mat";

  if forceGFunCalc or not Modelica.Utilities.Files.exist(pathSave) then
    ts := hBor^2/(9*as);

    (lntts,gFun) :=
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ThermalResponseFactors.gFunction(
      nbBor=nbBor,
      cooBor=cooBor,
      hBor=hBor,
      dBor=dBor,
      rBor=rBor,
      alpha=as,
      nbTimSho=nbTimSho,
      nbTimLon=nbTimLon,
      ttsMax=ttsMax);

    matrix[1,1] := 0;
    matrix[1,2] := 0;
    for i in 1:nrow loop
      matrix[i+1,1] := Modelica.Math.exp(lntts[i])*ts;
      matrix[i+1,2] := gFun[i]/(2*Modelica.Constants.pi*hBor*ks);
    end for;

    writegFun := writeMatrix(
      fileName=pathSave,
      matrixName="TStep",
      matrix=matrix,
      append=false);
  end if;

  matrix := readMatrix(
    fileName=pathSave,
    matrixName="TStep",
    rows=nrow+1,
    columns=2);
end timSerMat;
