within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.Scripts;
function initializeModel
  input String nameBfData="example.mo";
  input String path=Modelica.Utilities.Files.loadResource("modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/BorefieldData/");

  input Integer q_max "number of levels";
  input Integer p_max "number of cells by level";

  input Data.Records.StepResponse steRes;
  input Data.Records.Geometry geo;
  input Data.Records.Soil soi;
  input Data.Records.ShortTermResponse shoTerRes;

  input Integer[q_max,p_max] nuMat "number of pulse at the end of each cells";

  input Modelica.SIunits.Temperature TSteSta "steady state temperature";

  output Real[q_max,p_max] kappaMat "transient resistance for each cell";

  output String sha;
  output Boolean exist;
  output Boolean write;
protected
  Real[2,2] matrix={{1,1},{2,2}};
algorithm
  sha := IDEAS.Utilities.Cryptographics.sha_hash(path + nameBfData);

  Modelica.Utilities.Files.createDirectory("C:\.Test");

  if not Modelica.Utilities.Files.exist("C:\\.Test\\" + sha + "Agg.mat") then
    exist := false;

    kappaMat :=Borefield.BaseClasses.Aggregation.transientFrac(
      q_max=q_max,
      p_max=p_max,
      steRes=steRes,
      geo=geo,
      soi=soi,
      shoTerRes=shoTerRes,
      nuMat=nuMat,
      TSteSta=TSteSta);

    write := writeMatrix(
      fileName="C:\\.Test\\" + sha + "Agg.mat", matrixName="kappaMat", matrix=kappaMat, append=false);
  else
    exist := true;
    write := false;

    kappaMat :=readMatrix(
      fileName="C:\\.Test\\" + sha + "Agg.mat",
      matrixName="kappaMat",
      rows=q_max,
      columns=p_max);
  end if;
end initializeModel;
