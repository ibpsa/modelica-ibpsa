within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.GroundHX.BaseClasses;
function md5
  extends Modelica.Icons.Function;
  input String filePath;
  output String md5;

external"C" md5 = main(11); //md5_file(filePath, "1234567891234567");
  annotation (Include="#include <md5.c>", IncludeDirectory="modelica://IDEAS/Resources/C-Sources/md5_2/");
end md5;
