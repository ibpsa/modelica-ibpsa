within IBPSA.Utilities.Cryptographics.Validation;
model SHA1 "Model that verifies the SHA1 encryption C function"
  extends Modelica.Icons.Example;

  //Test strings
  parameter String strIn1 = "abc";
  parameter String strIn2 = "";
  parameter String strIn3 = "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq";
  parameter String strIn4 = "1.23e+4";
  parameter String strIn5 = Modelica.Utilities.Strings.repeat(1000,
    string="aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");

  //Expected outputs
  parameter String strEx1=
    "a9993e364706816aba3e25717850c26c9cd0d89d";
  parameter String strEx2=
    "da39a3ee5e6b4b0d3255bfef95601890afd80709";
  parameter String strEx3=
    "84983e441c3bd26ebaae4aa1f95129e5e54670f1";
  parameter String strEx4=
    "bdd220adb45b392f17915af70ed8a006c382b983";
  parameter String strEx5=
    "34aa973cd4c4daa4f61eeb2bdbad27316534016f";

  //Comparison results
  Boolean cmp1,cmp2,cmp3,cmp4,cmp5,cmpAll;

equation
  cmp1 = Modelica.Utilities.Strings.isEqual(IBPSA.Utilities.Cryptographics.sha(strIn1),strEx1,false);
  cmp2 = Modelica.Utilities.Strings.isEqual(IBPSA.Utilities.Cryptographics.sha(strIn2),strEx2,false);
  cmp3 = Modelica.Utilities.Strings.isEqual(IBPSA.Utilities.Cryptographics.sha(strIn3),strEx3,false);
  cmp4 = Modelica.Utilities.Strings.isEqual(IBPSA.Utilities.Cryptographics.sha(strIn4),strEx4,false);
  cmp5 = Modelica.Utilities.Strings.isEqual(IBPSA.Utilities.Cryptographics.sha(strIn5),strEx5,false);
  cmpAll = cmp1 and cmp2 and cmp3 and cmp4 and cmp5;

  annotation(experiment(Tolerance=1e-4,StopTime=1.0),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Utilities/Cryptographics/Validation/SHA1.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This validation function tests the C implementation of the SHA1 encryption for
the following strings:
<ul>
<li>
<code>&#34;abc&#34;</code>
</li>
<li>
<code>&#34;&#34;</code> <i>(an empty string)</i>
</li>
<li>
<code>&#34;abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq&#34;</code>
</li>
<li>
<code>&#34;1.23e+4&#34;</code>
</li>
<li>
<code>&#34;a&#34;</code> repeated a million consecutive times
</li>
</p>
<p>
If the encrypted strings are identical to the expected (known) encryption
results, the <code>cmpAll</code> boolean variable will return <code>True</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 30, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end SHA1;
