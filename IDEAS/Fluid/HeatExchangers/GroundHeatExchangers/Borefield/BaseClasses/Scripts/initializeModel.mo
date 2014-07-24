within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.Scripts;
function initializeModel
  input String pathRecBfData=Modelica.Utilities.Files.loadResource("modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/BorefieldData/example.mo");

  input Data.Records.Soil soi=Data.SoilData.example()
    "Thermal properties of the ground";
  input Data.Records.Filling fil=Data.FillingData.example()
    "Thermal properties of the filling material";
  input Data.Records.Geometry geo=Data.GeometricData.example()
    "Geometric charachteristic of the borehole";
  input Data.Records.Advanced adv=Data.Advanced.example() "Advanced parameters";
  input Data.Records.StepResponse steRes=Data.StepResponse.example()
    "generic step load parameter";

  output String sha;
  output Real[1,steRes.tBre_d + 1] TResSho;
  output Boolean existShoTerRes;

protected
  String pathSave;
  String dir;
  final String pathAbs = Modelica.Utilities.Strings.replace(pathRecBfData, "\\", "/")
    "replace the '' by '/' as the former are not recognized";
algorithm
  // --------------- Generate SHA-code and path
  sha := IDEAS.Utilities.Cryptographics.sha_hash(pathAbs);

  if Modelica.Utilities.Files.exist("C:") then
    dir :="C://.BfData";
  elseif Modelica.Utilities.Files.exist("/tmp") then
    dir :="/tmp/.BfData";
  else
    dir :="";
    assert(false,String(sha) + "\n
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

    IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.Scripts.ShortTimeResponseHX(
      soi=soi,
      fil=fil,
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
end initializeModel;
