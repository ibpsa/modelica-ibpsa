within IDEAS.Experimental.Media.Examples;
model AirPTDecoupledProperties
  "Model that tests the implementation of the fluid properties"
  extends Modelica.Icons.Example;
  extends IDEAS.Media.Examples.BaseClasses.FluidProperties(
    redeclare package Medium =
        AirPTDecoupled,
    TMin=273.15-30,
    TMax=273.15+60);

  Modelica.SIunits.SpecificEnthalpy hLiq "Specific enthalpy of liquid";

equation
  // Check the implementation of the base properties
  basPro.state.p=p;
  basPro.state.T=T;
  basPro.state.X[1]=X[1];

  hLiq = Medium.enthalpyOfLiquid(T);
  if Medium.nX == 1 then
    assert(abs(h-hLiq) < 1e-8, "Error in enthalpy computation.");
  end if;
   annotation(Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
experiment(StopTime=1),
__Dymola_Commands(file="modelica://IDEAS/Resources/Scripts/Dymola/Experimental/Media/Examples/AirPTDecoupledProperties.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This example checks thermophysical properties of the medium.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 19, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end AirPTDecoupledProperties;
