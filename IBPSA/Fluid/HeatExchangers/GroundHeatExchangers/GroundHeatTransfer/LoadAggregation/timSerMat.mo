within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.LoadAggregation;
function timSerMat "Reads and possibly writes a matrix with a time series
  of the borefield's thermal response"
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
  input Integer nbSeg "Number of line source segments per borehole";
  input Integer nbTimSho "Number of time steps in short time region";
  input Integer nbTimLon "Number of time steps in long time region";
  input Integer nbTimTot "Number of g-function points";
  input Real ttsMax "Maximum adimensional time for gfunc calculation";
  input String sha "Pseudo-SHA of the g-function arguments";
  input Boolean forceGFunCalc
    "Set to true to force the thermal response to be calculated at the start";

  output Real matrix[nbTimTot+1, 2] "2D Real array with 2 columns";

protected
  Modelica.SIunits.Time ts;
  String pathSave "Path of the saving folder";
  Real[nbTimTot] gFun;
  Real[nbTimTot] lntts;
  Boolean writegFun = false;

algorithm
  //creation of a folder .BfData in the simulation folder
  Modelica.Utilities.Files.createDirectory(".BfData");
  pathSave := ".BfData/" + sha + "Tstep.mat";

  if forceGFunCalc or not Modelica.Utilities.Files.exist(pathSave) then
    ts := hBor^2/(9*as);

    (lntts,gFun) :=
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.gFunction(
      nbBor=nbBor,
      cooBor=cooBor,
      hBor=hBor,
      dBor=dBor,
      rBor=rBor,
      alpha=as,
      nbSeg=nbSeg,
      nbTimSho=nbTimSho,
      nbTimLon=nbTimLon,
      ttsMax=ttsMax);

    matrix[1,1] := 0;
    matrix[1,2] := 0;
    for i in 1:nbTimTot loop
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
    rows=nbTimTot+1,
    columns=2);

  annotation (Documentation(info="<html>
<p>
This function uses the parameters required to calculate the borefield's thermal
response to build a SHA1-encrypted string unique to the borefield in question. Then, if the
<code>forceGFunCalc</code> parameter has been set to <code>True</code> or if
there is no .mat file with the SHA1 hash as its filename in the .BfData folder,
the thermal response will be calculated and written as a .mat file. Otherwise, the
thermal response will simply be read from the .mat file. In the .mat file, the data
is saved in a matrix entitled TStep, where the first column is the time (in
seconds) and the second column is the temperature step response, which is the
g-function divided by <code>2*&pi;*H*ks</code>, with H being the borehole length
and ks being the thermal conductivity of the soil.
</p>
</html>", revisions="<html>
<ul>
<li>
March 5, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end timSerMat;
