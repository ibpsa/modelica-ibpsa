within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.GroundHX.BaseClasses.Examples;
model test
  parameter String pathFile = "E:/work/modelica/IDEAS/IDEAS/Resources/C-Sources/testMd5.txt";
  parameter String name = "testMd5";
  parameter String savePath=Modelica.Utilities.Files.loadResource("modelica://IDEAS/Resources/C-Sources/");
  parameter String md5 = IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.GroundHX.BaseClasses.md5(
     savePath+name);
end test;
