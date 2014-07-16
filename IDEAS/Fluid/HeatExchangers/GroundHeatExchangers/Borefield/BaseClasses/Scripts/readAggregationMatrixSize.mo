within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.Scripts;
function readAggregationMatrixSize
  input String fileName;
  input Boolean rendering;
  output Integer[2] matSize;
algorithm
  matSize :=if rendering then {1,1} else readMatrixSize(fileName=fileName,
    matrixName="kappaMat");
end readAggregationMatrixSize;
