within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.Records;
record ShortTermResponse
  "Read the temperature short term response from file. The data  are generated with the script readTrajectoryTResSho"
  extends Modelica.Icons.Record;
  import SI = Modelica.SIunits;

  parameter Boolean rendering = false;
  parameter String name = "example";
  parameter String savePath=Modelica.Utilities.Files.loadResource("modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/ShortTermResponse/");
  parameter String path="IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.Records.ShortTermResponse";
  parameter Integer vecLen=BaseClasses.Scripts.readTrajectoryVecLen(
        savePath + name + "Data", rendering=rendering)
    "vector lenght (=tBre_d)";
  parameter SI.Time[vecLen] tVec = BaseClasses.Scripts.readTrajectorytVec(
        savePath + name + "Data", rendering=rendering) "[s] time vector";
  parameter SI.Temperature[vecLen] TResSho = BaseClasses.Scripts.readTrajectoryTResSho(
        savePath + name + "Data", rendering=rendering)
    "Vector containing the fluid step-reponse temperature in function of the time obtained by the script readTrajectoryTResSho";
end ShortTermResponse;
