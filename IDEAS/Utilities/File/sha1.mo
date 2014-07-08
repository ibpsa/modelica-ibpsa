within IDEAS.Utilities.File;
function sha1
  extends Modelica.Icons.Function;
  input String filePath="E:/work/modelica/IDEAS/IDEAS/Resources/C-Sources/md53.c";
  output String sha1;

external"C" sha1 = sha1(filePath);  //md5_file(filePath, "1234567891234567");
  annotation (Include="#include <sha1.c>", IncludeDirectory="modelica://IDEAS/Resources/C-Sources");
end sha1;
