within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.Examples;
model FiniteLineSource_erfint
  "Test case for the evaluation of the integral of the error function"
  extends Modelica.Icons.Example;

  Real u "Independent variable";
  Real erfint "Integral of the error function";
  Real erfint_num "Numerical integral of the error function";
  Real err "Difference between analytical and numerical evaluations";

initial equation
  erfint_num=0.0;

equation
  u = time;
  erfint = IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.finiteLineSource_erfint(u=u);
  der(erfint_num) = Modelica.Math.Special.erf(u);
  err = erfint - erfint_num;

  annotation (
    __Dymola_Commands(file=
          "modelica://IBPSA/Resources/Scripts/Dymola/Fluid/HeatExchangers/GroundHeatExchangers/GroundHeatTransfer/ThermalResponseFactors/Examples/FiniteLineSource_erfint.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StartTime=0.0, StopTime=15.0),
    Documentation(info="<html>
<p>
This example demonstrates the evaluation of the
integral of the error function.
</p>
</html>", revisions="<html>
<ul>
<li>
July 17, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end FiniteLineSource_erfint;
