within IBPSA.Utilities.Math.Functions.Examples;
model BesselY0 "Test case for bessel function Y0"
  extends Modelica.Icons.Example;

  Real Y0 "Bessel function Y0";

equation

  Y0 = IBPSA.Utilities.Math.Functions.besselY0(time + Modelica.Constants.small);

  annotation (
    __Dymola_Commands(file=
          "modelica://IBPSA/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/BesselY0.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=30.0),
    Documentation(info="<html>
<p>
This example demonstrates the use of the function for bessel functions of the
second kind of order 0, Y0.
</p>
</html>", revisions="<html>
<ul>
<li>
June 6, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end BesselY0;
