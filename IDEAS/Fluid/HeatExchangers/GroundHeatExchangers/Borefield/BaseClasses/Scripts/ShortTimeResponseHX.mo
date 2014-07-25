within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.Scripts;
function ShortTimeResponseHX
  /* Remark: by calling the function, 3 "true" should appear for: \
      1) translation of model \
      2) simulation of model \
      3) writing the data \
      If you get a false, look for the error!
    */

  import SI = Modelica.SIunits;
  input Data.Records.Soil soi=Data.SoilData.example()
    "Thermal properties of the ground";
  input Data.Records.Filling fil=Data.FillingData.example()
    "Thermal properties of the filling material";
  input Data.Records.Geometry geo=Data.GeometricData.example()
    "Geometric charachteristic of the borehole";
  input Data.Records.Advanced adv=Data.Advanced.example() "Advanced parameters";
  input Data.Records.StepResponse steRes=Data.StepResponse.example()
    "generic step load parameter";

  input String pathSave "save path for the result file";

  output Real[1,steRes.tBre_d + 1] TResSho;
  output Real[3,steRes.tBre_d + 1] readData;

protected
  final parameter String modelToSimulate="IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.Examples.SingleBoreHoleSerStepLoadScript"
    "model to simulate";

  String[1] varToStore={"borHolSer.TWallAve"}
    "variables to store in result file";
  SI.Time[1,steRes.tBre_d + 1] timVec={0:steRes.tStep:steRes.tBre_d*steRes.tStep}
    "time vector for which the data are saved";
  String[2] saveName={"Time",varToStore[1]};

algorithm
  //To ensure that the same number of data points is written in all result files
  //equidistant time grid is enabled and store variables at events is disabled.
  experimentSetupOutput(equdistant=true, events=false);

  simulateModel(
    modelToSimulate +
     "( soi=" + soi.path + "(), " +
     "fil=" + fil.path + "()," +
     "geo=" + geo.path + "()," +
     "steRes=" + steRes.path + "()," +
     "adv=" + adv.path + "())",
    stopTime=steRes.tBre_d*steRes.tStep,
    numberOfIntervals=steRes.tBre_d + 1,
    method="dassl",
   resultFile=pathSave + "_sim");

  // First columns are shorttime, last column is steady state
  readData := cat(
    1,
    timVec,
    interpolateTrajectory(
      pathSave + "_sim.mat",
      varToStore,
      timVec[1, :]));

  TResSho[1,:] :=readData[2, 1:end];

  writeMatrix(
      fileName=pathSave + "ShoTermData.mat", matrixName="TResSho", matrix=TResSho, append=false);

  annotation ();
end ShortTimeResponseHX;
