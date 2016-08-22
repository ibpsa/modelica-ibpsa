within IDEAS.Utilities.Cryptographics.BaseClasses;
function sha "Rewritten sha-code returning a unique number for each file."
  extends Modelica.Icons.Function;
  input String argv;
  output String sha1;

external"C" sha1 = sha1(argv);
  annotation (Include="#include <sha1.c>", IncludeDirectory="modelica://IDEAS/Resources/C-Sources");
end sha;
