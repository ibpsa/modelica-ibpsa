within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.GroundHX.BaseClasses;
function md53
  extends Modelica.Icons.Function;
  input String filePath="E:/work/modelica/IDEAS/IDEAS/Resources/C-Sources/md5.c";
  output String test;

external"C" test = test("alistlog.txt");  //md5_file(filePath, "1234567891234567");
  annotation (Include="#include <md53.c>", IncludeDirectory="modelica://IDEAS/Resources/C-Sources");
end md53;
