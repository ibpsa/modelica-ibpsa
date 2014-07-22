within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.Scripts;
function initializeModel
  input String pathRec=Modelica.Utilities.Files.loadResource("modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/BorefieldData/example.mo");

  input Integer q_max "number of levels";
  input Integer p_max "number of cells by level";

  input Data.Records.Soil soi "Thermal properties of the ground";
  input Data.Records.Filling fill "Thermal properties of the filling material";
  input Data.Records.Geometry geo "Geometric charachteristic of the borehole";
  input Data.Records.Advanced adv "Advanced parameters";
  input Data.Records.StepResponse steRes "generic step load parameter";

  input Integer[q_max,p_max] nuMat "number of pulse at the end of each cells";

  input Modelica.SIunits.Temperature TSteSta "steady state temperature";

  input Integer lenSim "Simulation length ([s]). By default = 100 days";

  output Real[q_max,p_max] kappaMat "transient resistance for each cell";

  output String sha;
  output Real[steRes.tBre_d + 1] TResSho;
  output Boolean existShoTerRes;
  output Boolean existAgg;
  output Boolean writeAgg;
protected
  Real[2,2] matrix={{1,1},{2,2}};
  String pathSave;
algorithm
  sha := IDEAS.Utilities.Cryptographics.sha_hash(pathRec);

  Modelica.Utilities.Files.createDirectory("C:\.Test");

  pathSave :="C:\\.Test\\" + sha;

  if not Modelica.Utilities.Files.exist( pathSave + "ShoTermData.mat") then
    TResSho :=
      IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.Scripts.ShortTimeResponseHX(
      steRes=steRes,
      geo=geo,
      soi=soi,
      fill=fill,
      adv=adv,
      pathSave=pathSave);

    existShoTerRes :=false;
  else
    TResSho :=readTrajectory(
      pathSave + "ShoTermData.mat",
      {"TResSho"},
      readTrajectorySize(pathSave + "ShoTermData.mat"));

    existShoTerRes :=true;
  end if;

  if not Modelica.Utilities.Files.exist( pathSave + "Agg" + String(lenSim) + ".mat") then
    existAgg := false;

    kappaMat :=Borefield.BaseClasses.Aggregation.transientFrac(
      q_max=q_max,
      p_max=p_max,
      steRes=steRes,
      geo=geo,
      soi=soi,
      TResSho=TResSho,
      nuMat=nuMat,
      TSteSta=TSteSta);

    writeAgg := writeMatrix(
      fileName=pathSave + "Agg" + String(lenSim) + ".mat", matrixName="kappaMat", matrix=kappaMat, append=false);
  else
    existAgg := true;
    writeAgg := false;

    kappaMat :=readMatrix(
      fileName=pathSave + "Agg" + String(lenSim) + ".mat",
      matrixName="kappaMat",
      rows=q_max,
      columns=p_max);
  end if;
end initializeModel;
