within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.Scripts;
function writeAggregationMatrix
  input String fileName;
  input Real[:,:] matrix;
  output Boolean status;
algorithm
    status :=writeMatrix(
    fileName=fileName,
    matrixName="kappaMat",
    matrix=matrix,
    append=false);
end writeAggregationMatrix;
