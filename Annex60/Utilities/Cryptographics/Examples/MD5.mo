within Annex60.Utilities.Cryptographics.Examples;
model MD5 "Test model for md5 sum"
  extends Modelica.Icons.Example;
  parameter String s = "hello";
  String md5 = Annex60.Utilities.Cryptographics.md5(s);
initial algorithm
  Modelica.Utilities.Streams.print("The md5 sum of '" + s + "' is " + md5);
end MD5;
