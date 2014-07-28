within IDEAS.Utilities;
package test
  model writeFileTest
  end writeFileTest;

  function writeFileTestFunction
    input String fileName="test.txt";
    output Boolean result;
  algorithm
    Modelica.Utilities.Files.createDirectory("C:\.Test");
    result := Modelica.Utilities.Files.exist("C:\\.Test\\" + fileName);
  end writeFileTestFunction;

  function writeFileTestFunction2
    input String nameBfData="example.mo";
    input String path=Modelica.Utilities.Files.loadResource(
        "modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/ShortTermResponse/");
    output String sha;

    output Boolean exist;
    output Boolean write;
  protected
    Real[2,2] matrix={{1,1},{2,2}};
  algorithm
    sha := IDEAS.Utilities.Cryptographics.sha_hash(path + nameBfData);

    Modelica.Utilities.Files.createDirectory("C:\.Test");

    if not Modelica.Utilities.Files.exist("C:\\.Test\\" + sha + "Agg.mat") then
      exist := false;
      write := writeMatrix(
          fileName="C:\\.Test\\" + sha + "Agg.mat",
          matrixName="matrix",
          matrix=matrix,
          append=false);
    else
      exist := true;
      write := false;
    end if;
  end writeFileTestFunction2;
end test;
