within Annex60.Utilities.Cryptographics;
function md5
  extends Modelica.Icons.Function;
  input String s "String from which the md5 sum will be returned";
  input Integer l = Modelica.Utilities.Strings.length(s) "Length of string";
  output String m;
  external"C" m = str2md5(s, l);
  annotation (Include="#include <str2md5.c>",
              IncludeDirectory="modelica://Annex60/Resources/C-Sources",
              Library={"crypto"});
end md5;
