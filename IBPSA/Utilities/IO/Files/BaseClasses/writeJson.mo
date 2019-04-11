within IBPSA.Utilities.IO.Files.BaseClasses;
function writeJson
  "Write a vector of String-Real tuples to JSON format"
    input String fileName "JSON file name";
    input String[:] varNames "Variable names";
    input Real[:] varVals "Variable values";

    external "C" writeJson(fileName, varNames, size(varNames,1), varVals, size(varVals,1))
    annotation(Include=" #include \"writeJson.c\"",
    IncludeDirectory="modelica://IBPSA/Resources/C-Sources");

end writeJson;
