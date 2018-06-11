within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.Examples;
model CylindricalHeatSource "Test case for cylindricalHeatSource"
  extends Modelica.Icons.Example;

  parameter Real alpha = 1.0e-6 "Ground thermal diffusivity";
  parameter Real rSource = 0.075 "Radius of cylinder source";
  parameter Real[5] r = {rSource, 2*rSource, 5*rSource, 10*rSource, 20*rSource}
    "Radial position of evaluation of the solution";
  Real t "Time";
  Real[5] G "Cylindrical heat source solution";

equation

  t = exp(time) - 1.0;

  for k in 1:5 loop
    G[k] = IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.cylindricalHeatSource(t, alpha, r[k], rSource);
  end for;

  annotation (
    __Dymola_Commands(file=
          "modelica://IBPSA/Resources/Scripts/Dymola/Fluid/HeatExchangers/GroundHeatExchangers/GroundHeatTransfer/ThermalResponseFactors/Examples/CylindricalHeatSource.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=15.0),
    Documentation(info="<html>
<p>
This example demonstrates the use of the function for the evaluation of the
cylindrical heat source solution.
</p>
</html>", revisions="<html>
<ul>
<li>
June 11, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end CylindricalHeatSource;
