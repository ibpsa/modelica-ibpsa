within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.LoadAggregation;
function temperatureResponseMatrix
  "Reads and possibly writes a matrix with a time series of the borefield's temperature response"
  extends Modelica.Icons.Function;

  input Integer nbBor "Number of boreholes";
  input Real cooBor[nbBor, 2] "Borehole coordonates";
  input Modelica.SIunits.Height hBor "Borehole length";
  input Modelica.SIunits.Height dBor "Borehole buried depth";
  input Modelica.SIunits.Radius rBor "Borehole radius";
  input Modelica.SIunits.ThermalDiffusivity aSoi
    "Thermal diffusivity of soil";
  input Modelica.SIunits.ThermalConductivity kSoi
    "Thermal conductivity of soil";
  input Integer nbSeg "Number of line source segments per borehole";
  input Integer nbTimSho "Number of time steps in short time region";
  input Integer nbTimLon "Number of time steps in long time region";
  input Integer nbTimTot "Number of g-function points";
  input Real ttsMax "Maximum adimensional time for g-function calculation";
  input String sha "Pseudo-SHA of the g-function arguments";
  input Boolean forceGFunCalc
    "Set to true to force the thermal response to be calculated at the start";

  output Real matrix[nbTimTot, 2] "Temperature response time series";

protected
  String pathSave "Path of the saving folder";
  Modelica.SIunits.Time[nbTimTot] tGFun;
  Real[nbTimTot] gFun;
  Boolean writegFun = false;

algorithm
  //creation of a folder .BfData in the simulation folder
  Modelica.Utilities.Files.createDirectory(".BfData");
  pathSave := ".BfData/" + sha + "Tstep.mat";

  if forceGFunCalc or not Modelica.Utilities.Files.exist(pathSave) then
    (tGFun,gFun) :=
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.gFunction(
      nbBor=nbBor,
      cooBor=cooBor,
      hBor=hBor,
      dBor=dBor,
      rBor=rBor,
      aSoi=aSoi,
      nbSeg=nbSeg,
      nbTimSho=nbTimSho,
      nbTimLon=nbTimLon,
      ttsMax=ttsMax);

    for i in 1:nbTimTot loop
      matrix[i,1] := tGFun[i];
      matrix[i,2] := gFun[i]/(2*Modelica.Constants.pi*hBor*kSoi);
    end for;

    writegFun := Modelica.Utilities.Streams.writeRealMatrix(
      fileName=pathSave,
      matrixName="TStep",
      matrix=matrix,
      append=false);
  end if;

  matrix := Modelica.Utilities.Streams.readRealMatrix(
    fileName=pathSave,
    matrixName="TStep",
    nrow=nbTimTot,
    ncol=2);

  annotation (Documentation(info="<html>
<p>
This function uses the parameters required to calculate the borefield's thermal
response to build a SHA1-encrypted string unique to the borefield in question. Then, if the
<code>forceGFunCalc</code> input is <code>True</code> or if
there is no <code>.mat</code> file with the SHA1 hash as its filename in the
<code>.BfData</code> folder,
the thermal response will be calculated and written as a 
<code>.mat</code> file. Otherwise, the
thermal response will simply be read from the 
<code>.mat</code> file. In the <code>.mat</code> file, the data
is saved in a matrix with name <code>TStep</code>, where the first column is the time (in
seconds) and the second column is the temperature step response, which is the
g-function divided by <code>2*&pi;*H*ks</code>, with <code>H</code> being the borehole length
and <code>ks</code> being the thermal conductivity of the soil.
</p>
</html>", revisions="<html>
<ul>
<li>
July 15, 2018, by Michael Wetter:<br/>
Changed implementation to use matrix read and write from
the Modelica Standard Library.
</li>
<li>
March 5, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end temperatureResponseMatrix;
