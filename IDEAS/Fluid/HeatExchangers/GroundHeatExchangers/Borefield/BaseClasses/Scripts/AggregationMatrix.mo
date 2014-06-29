within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.Scripts;
function AggregationMatrix

  // General parameters of borefield
  input Data.Records.Soil soi=Data.SoilData.example()
    "Thermal properties of the ground";
  input Data.Records.Filling fill=Data.FillingData.example()
    "Thermal properties of the filling material";
  input Data.Records.Geometry geo=Data.GeometricData.example()
    "Geometric charachteristic of the borehole";
  input Data.Records.Advanced adv=Data.Advanced.example() "Advanced parameters";
  input Data.Records.StepResponse steRes=Data.StepResponse.example()
    "generic step load parameter";
  input Data.Records.ShortTermResponse shoTerRes=Data.ShortTermResponse.example(rendering=false); // constrainedby(Data.Records.ShortTermResponse(rendering=true))
  input Data.Records.AggregationMatrix aggMat=Data.AggregationMatrix.example(rendering=true);

  //General parameters of aggregation
  input Integer p_max=5 "maximum number of cells for each aggreagation level";

  input Real lenSim=3600*24*100
    "Simulation length ([s]). By default = 100 days";
  input Integer q_max=
      Borefield.BaseClasses.Aggregation.BaseClasses.nbOfLevelAgg(n_max=integer(
      lenSim/steRes.tStep), p_max=p_max) "number of aggregation levels";
  output Real[q_max,p_max] kappaMat
    "transient thermal resistance of each aggregation cells";

protected
  final parameter Modelica.SIunits.Temperature TSteSta=
      Borefield.BaseClasses.GroundHX.HeatCarrierFluidStepTemperature(
      steRes=steRes,
      geo=geo,
      soi=soi,
      shoTerRes=shoTerRes,
      t_d=steRes.tSteSta_d);
  final parameter Integer[q_max] rArr=Borefield.BaseClasses.Aggregation.BaseClasses.cellWidth(
      q_max=q_max, p_max=p_max) "width of aggregation cell for each level";
  final parameter Integer[q_max,p_max] nuMat=
      Borefield.BaseClasses.Aggregation.BaseClasses.nbPulseAtEndEachLevel(
      q_max=q_max,
      p_max=p_max,
      rArr=rArr);

algorithm
  kappaMat := Borefield.BaseClasses.Aggregation.transientFrac(
    q_max=q_max,
    p_max=p_max,
    steRes=steRes,
    geo=geo,
    soi=soi,
    shoTerRes=shoTerRes,
    nuMat=nuMat,
    TSteSta=TSteSta) "transient thermal resistance of each aggregation cells";

  writeMatrix(fileName=aggMat.savePath, matrixName="kappaMat",matrix=kappaMat,append=false);

end AggregationMatrix;
