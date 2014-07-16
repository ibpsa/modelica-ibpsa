within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.Scripts;
function initializeModel_test
  input String nameBfData="example.mo";
  input String path=Modelica.Utilities.Files.loadResource("modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/BorefieldData/");
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
    write := writeMatrix(
      fileName="C:\\.Test\\" + sha + "Agg.mat",
      matrixName="matrix",
      matrix=matrix,
      append=false);
  else
    exist := true;
    write := false;
  end if;
end initializeModel_test;
