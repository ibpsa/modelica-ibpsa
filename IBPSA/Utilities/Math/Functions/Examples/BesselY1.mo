within IBPSA.Utilities.Math.Functions.Examples;
model BesselY1 "Test case for bessel function Y1"
  extends Modelica.Icons.Example;

  Real Y1 "Bessel function Y1";

equation

  Y1 = IBPSA.Utilities.Math.Functions.besselY1(time + Modelica.Constants.small);

  annotation (
    __Dymola_Commands(file=
          "modelica://IBPSA/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/BesselY1.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=30.0),
    Documentation(info="<html>
<p>
This example demonstrates the use of the function for bessel functions of the
second kind of order 1, Y1.
</p>
</html>", revisions="<html>
<ul>
<li>
June 6, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end BesselY1;
