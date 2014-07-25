within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.Scripts;
function saveAggregationMatrix
  extends Aggregation.Interface.partialAggFunction;

  input String pathRec;

  input Data.Records.Soil soi "Thermal properties of the ground";
  input Data.Records.Geometry geo "Geometric charachteristic of the borehole";
  input Data.Records.StepResponse steRes "generic step load parameter";
  input Data.Records.Filling fil "Thermal properties of the filling material";
  input Data.Records.Advanced adv "Advanced parameters";

  input Integer lenSim "Simulation length ([s]). By default = 100 days";

  output Real[q_max,p_max] kappaMat "transient resistance for each cell";
  output Integer[q_max] rArr=
    Borefield.BaseClasses.Aggregation.BaseClasses.cellWidth(q_max=q_max,
    p_max=p_max) "width of aggregation cell for each level";
  output Integer[q_max,p_max] nuMat=
    Borefield.BaseClasses.Aggregation.BaseClasses.nbPulseAtEndEachLevel(
    q_max=q_max,
    p_max=p_max,
    rArr=rArr) "nb of aggregated pulse at end of each aggregation cells";
  output Modelica.SIunits.Temperature TSteSta "Quasi steady state temperature";

  output Real[1,steRes.tBre_d + 1] TResSho;
  output String sha;

  output Boolean existShoTerRes;

  output Boolean existAgg;
  output Boolean writeTSteSta;
  output Boolean writeAgg;
  output Real q_max_out;

protected
  String pathSave;
  String dir;
  Real[1,1] mat;
algorithm
  q_max_out :=q_max;
  // --------------- Generate SHA-code and path
  sha := IDEAS.Utilities.Cryptographics.sha_hash(pathRec);

  if Modelica.Utilities.Files.exist("C:") then
    dir :="C://.BfData";
  elseif Modelica.Utilities.Files.exist("/tmp") then
    dir :="/tmp/.BfData";
  else
    dir :="";
    assert(false, "\n
************************************************************************************************************************ \n 
You do not have the writing permission on the C: or home/ folder. Change the variable dir in
IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.Scripts.saveAggregationMatrix to 
write the temperory file at a different location. \n
************************************************************************************************************************ \n ");
  end if;

  Modelica.Utilities.Files.createDirectory(dir);

  pathSave := dir + "/" + sha;

  // --------------- Check if the short term response (TResSho) needs to be calculated or loaded
  if not Modelica.Utilities.Files.exist(pathSave + "ShoTermData.mat") then
    existShoTerRes := false;
  else
    existShoTerRes := true;
  end if;

  assert(existShoTerRes, " \n
************************************************************************************************************************ \n 
The borefield model with this BfData record has not yet been initialized. Please firstly run the following command in the command log: \n" +
"IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.Scripts.initializeModel("+
"pathRecBfData=\"" + pathRec + "\","+
"soi=" + soi.path + "(), " +
"fil=" + fil.path + "()," +
"geo=" + geo.path + "()," +
"steRes=" + steRes.path + "()," +
"adv=" + adv.path + "())"+
"\n
************************************************************************************************************************ \n ");

  TResSho := readMatrix(
    fileName=pathSave + "ShoTermData.mat",
    matrixName="TResSho",
    rows=1,
    columns=steRes.tBre_d + 1);

  // --------------- Check if the aggregation matrix kappaMat and the steady state temperature (TSteSta) need to be calculated or loaded
  if not existShoTerRes or not Modelica.Utilities.Files.exist(pathSave + "Agg" + String(lenSim) + ".mat") then
    existAgg := false;

    TSteSta :=GroundHX.CorrectedBoreFieldWallTemperature(
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

end saveAggregationMatrix;
