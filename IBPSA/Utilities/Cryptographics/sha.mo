within IBPSA.Utilities.Cryptographics;
function sha
  "SHA1 encryption in C of the String array"
  extends Modelica.Icons.Function;
  input String argv "String to be encrypted";
  output String sha1 "SHA1-encrypted string";

external"C" sha1 = hash(argv);
  annotation (Include="#include <simpleHash.c>", IncludeDirectory=
        "modelica://IBPSA/Resources/C-Sources",
    Documentation(revisions="<html>
<ul>
<li>
May 31, 2018 by Alex Laferri&egrave;re:<br/>
Changed the encryption to a SHA1 with a string array input (rather than a file
input), which allows for an encryption of elements longer than 500 characters.
</li>
<li>
January 21, 2018 by Filip Jorissen:<br/>
Revised sha implementation to avoid buffer overflow in borefield.
See <a href=\"https://github.com/open-ideas/IDEAS/issues/755\">
#755</a>.
</li>
</ul>
</html>"));
end sha;
