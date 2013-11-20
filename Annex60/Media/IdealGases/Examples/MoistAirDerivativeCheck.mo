within Annex60.Media.IdealGases.Examples;
model MoistAirDerivativeCheck
  extends Modelica.Icons.Example;

   package Medium = Annex60.Media.IdealGases.MoistAir;

    Modelica.SIunits.SpecificEnthalpy hLiqSym "Liquid phase enthalpy";
    Modelica.SIunits.SpecificEnthalpy hLiqCod "Liquid phase enthalpy";
    Modelica.SIunits.SpecificEnthalpy hSteSym "Water vapor enthalpy";
    Modelica.SIunits.SpecificEnthalpy hSteCod "Water vapor enthalpy";
    constant Real conv(unit="K/s") = 1
    "Conversion factor to satisfy unit check";
initial equation
     hLiqSym = hLiqCod;
     hSteSym = hSteCod;
equation
    hLiqCod=Medium.enthalpyOfLiquid(conv*time);
    der(hLiqCod)=der(hLiqSym);
    assert(abs(hLiqCod-hLiqSym) < 1E-2, "Model has an error");

    hSteCod=Medium.enthalpyOfCondensingGas(conv*time);
    der(hSteCod)=der(hSteSym);
    assert(abs(hSteCod-hSteSym) < 1E-2, "Model has an error");

   annotation(Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
experiment(StartTime=273.15, StopTime=373.15),
__Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Media/IdealGases/Examples/MoistAirDerivativeCheck.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This example checks whether the function derivative
is implemented correctly. If the derivative implementation
is not correct, the model will stop with an assert statement.
</p>
</html>",   revisions="<html>
<ul>
<li>
November 20, 2013, by Michael Wetter:<br/>
Removed check of <code>enthalpyOfDryAir</code> as this function
is protected and should therefore not be accessed from outside the class.
</li>
<li>
May 12, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end MoistAirDerivativeCheck;
