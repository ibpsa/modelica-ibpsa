within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.Records;
record AggregationMatrix
  "Read the aggregation matrix from file. The data  are generated with the script AggregationMatrix"
  extends Modelica.Icons.Record;
  import SI = Modelica.SIunits;

  parameter Boolean rendering = true;
  parameter String name = "example";
  parameter String savePath=Modelica.Utilities.Files.loadResource("modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/AggregationMatrix/");
  parameter String path="IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.Records.AggregationMatrix";
   parameter Integer[2] matSize = Borefield.BaseClasses.Scripts.readAggregationMatrixSize(fileName=savePath+name,rendering=rendering);
  //final parameter Integer[2] matSize = if rendering then {1,1} else readMatrixSize(fileName=savePath+name,matrixName="kappaMat");
  parameter Real[matSize[1],matSize[2]] aggMat = if rendering then {{1}} else readMatrix(fileName=savePath+name,matrixName="kappaMat",rows=matSize[1],columns=matSize[2]);
end AggregationMatrix;
