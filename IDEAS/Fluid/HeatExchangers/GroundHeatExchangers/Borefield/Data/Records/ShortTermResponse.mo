within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.Records;
record ShortTermResponse
  "Read the temperature short term response from file. The data  are generated with the script readTrajectoryTResSho"
  extends Modelica.Icons.Record;
  import SI = Modelica.SIunits;

  parameter String path=Modelica.Utilities.Files.loadResource("modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/ShortTermResponse/");
  parameter String name="example";
  parameter Integer vecLen=BaseClasses.Scripts.readTrajectoryVecLen(
        path + name + "Data") "vector lenght (=tBre_d)";
  parameter SI.Time[vecLen] tVec = BaseClasses.Scripts.readTrajectorytVec(
        path + name + "Data") "[s] time vector";
  parameter SI.Temperature[vecLen] TResSho = BaseClasses.Scripts.readTrajectoryTResSho(
        path + name + "Data")
    "Vector containing the fluid step-reponse temperature in function of the time obtained by the script readTrajectoryTResSho";
end ShortTermResponse;
