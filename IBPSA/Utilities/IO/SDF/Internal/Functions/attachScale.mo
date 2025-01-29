within IBPSA.Utilities.IO.SDF.Internal.Functions;
impure function attachScale
  extends Modelica.Icons.Function;
  input String fileName;
  input String datasetName;
  input String scaleName;
  input String dimensionName;
  input Integer dimension;
  output String errorMessage;
external "C" errorMessage = ModelicaSDF_attach_scale(fileName, datasetName, scaleName, dimensionName, dimension) annotation (
  Library={"ModelicaSDF"},
  LibraryDirectory="modelica://IBPSA/Utilities/IO/SDF/Resources/Library");
end attachScale;
