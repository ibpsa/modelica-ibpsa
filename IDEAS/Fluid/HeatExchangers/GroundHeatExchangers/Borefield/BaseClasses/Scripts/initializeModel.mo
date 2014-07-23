within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.Scripts;
function initializeModel
  input String pathRec=Modelica.Utilities.Files.loadResource("modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/BorefieldData/example_accurate.mo");

  input Data.Records.Soil soi=Data.SoilData.example()
    "Thermal properties of the ground";
  input Data.Records.Filling fill=Data.FillingData.example()
    "Thermal properties of the filling material";
  input Data.Records.Geometry geo=Data.GeometricData.example()
    "Geometric charachteristic of the borehole";
  input Data.Records.Advanced adv=Data.Advanced.example() "Advanced parameters";
  input Data.Records.StepResponse steRes=Data.StepResponse.example()
    "generic step load parameter";

  input Integer lenSim "Simulation length ([s]). By default = 100 days";

  final parameter Integer p_max=5
    "maximum number of cells for each aggreagation level";

  final parameter Integer q_max=
      Borefield.BaseClasses.Aggregation.BaseClasses.nbOfLevelAgg(n_max=integer(
      lenSim/steRes.tStep), p_max=p_max) "number of aggregation levels";

  output String sha;
  output Real[1,steRes.tBre_d + 1] TResSho;
  output Boolean existShoTerRes;

  output Real[q_max,p_max] kappaMat "transient resistance for each cell";

  output Boolean existAgg;
  output Boolean writeTSteSta;
  output Boolean writeAgg;

protected
  String pathSave;

  final parameter Integer[q_max] rArr=
      Borefield.BaseClasses.Aggregation.BaseClasses.cellWidth(q_max=q_max,
      p_max=p_max) "width of aggregation cell for each level";
  final parameter Integer[q_max,p_max] nuMat=
      Borefield.BaseClasses.Aggregation.BaseClasses.nbPulseAtEndEachLevel(
      q_max=q_max,
      p_max=p_max,
      rArr=rArr) "nb of aggregated pulse at end of each aggregation cells";
  Modelica.SIunits.Temperature TSteSta "Quasi steady state temperature";

  Real[1,1] mat;
algorithm
  // --------------- Generate SHA-code and path
  sha := IDEAS.Utilities.Cryptographics.sha_hash(pathRec);

  Modelica.Utilities.Files.createDirectory("C:\.BfData");

  pathSave := "C://.BfData/" + sha;

  // --------------- Check if the short term response (TResSho) needs to be calculated or loaded
  if not Modelica.Utilities.Files.exist(pathSave + "ShoTermData.mat") then

    IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.Scripts.ShortTimeResponseHX(
      soi=soi,
      fill=fill,
      geo=geo,
      steRes=steRes,
      adv=adv,
      pathSave=pathSave);

    existShoTerRes := false;
  else
    existShoTerRes := true;
  end if;

  TResSho := readMatrix(
    fileName=pathSave + "ShoTermData.mat",
    matrixName="TResSho",
    rows=1,
    columns=steRes.tBre_d + 1);

  // --------------- Check if the aggregation matrix kappaMat and the steady state temperature (TSteSta) need to be calculated or loaded
  if not existShoTerRes or not Modelica.Utilities.Files.exist(pathSave + "Agg" + String(lenSim) + ".mat") then
    existAgg := false;

    TSteSta := Borefield.BaseClasses.GroundHX.HeatCarrierFluidStepTemperature(
      steRes=steRes,
      geo=geo,
      soi=soi,
      TResSho=TResSho[1, :],
      t_d=steRes.tSteSta_d);

    kappaMat := Borefield.BaseClasses.Aggregation.transientFrac(
      q_max=q_max,
      p_max=p_max,
      steRes=steRes,
      geo=geo,
      soi=soi,
      TResSho=TResSho[1, :],
      nuMat=nuMat,
      TSteSta=TSteSta);

    writeTSteSta := writeMatrix(
      fileName=pathSave + "TSteSta.mat",
      matrixName="TSteSta",
      matrix={{TSteSta}},
      append=false);
    writeAgg := writeMatrix(
      fileName=pathSave + "Agg" + String(lenSim) + ".mat",
      matrixName="kappaMat",
      matrix=kappaMat,
      append=false);
      mat :={{1}};
  else
    existAgg := true;
    writeAgg := false;

    mat := readMatrix(
      fileName=pathSave + "TSteSta.mat",
      matrixName="TSteSta",
      rows=1,
      columns=1);
    TSteSta:=mat[1, 1];

    kappaMat := readMatrix(
      fileName=pathSave + "Agg" + String(lenSim) + ".mat",
      matrixName="kappaMat",
      rows=q_max,
      columns=p_max);
  end if;

end initializeModel;
