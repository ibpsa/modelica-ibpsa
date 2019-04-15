within IBPSA.Utilities.IO.Files.BaseClasses;
function cacheVals
  "Function for caching results such that they can be written at destruction"
    input IBPSA.Utilities.IO.Files.BaseClasses.JsonWriterObject ID "Json writer object id";
    input Real[:] varVals "Variable values";

    external "C" cacheVals(ID, varVals, size(varVals,1))
    annotation(Include=" #include \"jsonWriterInit.c\"",
    IncludeDirectory="modelica://IBPSA/Resources/C-Sources");

end cacheVals;
