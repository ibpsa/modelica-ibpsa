within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Data.Records;
record ShortTermResponse
  "Read the temperature short term response from file. The data  are generated with the script readTrajectoryTResSho"
  extends Modelica.Icons.Record;
  import SI = Modelica.SIunits;

  parameter String name="ShortTermResponse";
  parameter Integer vecLen "vector lenght (=tBre_d)";
  parameter SI.Time[vecLen] tVec "[s] time vector";
  parameter SI.Temperature[vecLen] TResSho
    "Vector containing the fluid step-reponse temperature in function of the time obtained by the script readTrajectoryTResSho";
end ShortTermResponse;
