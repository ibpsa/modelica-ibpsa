within IBPSA.Fluid.Examples.Performance;
package PressureDrop "Various configurations using PressureDrop models and demonstration of from_dp. See translation statistics."
  extends Modelica.Icons.ExamplesPackage;







annotation (Documentation(info="<html>
<p>
This package contains examples that demonstrate how parameter 
settings and boundary conditions can affect the number and 
size of algebraic loops (statistics). 
</p>
<p>
Either a pressure difference or a mass flow rate is prescribed. 
Parameter <code>from_dp</code> is set to either true or false. 
These combinations are applied to a flow network 
consisting of parallel, series or parallel-series components. 
For the same flow network different statistics 
are generated depending on the configuration.
</p>
</html>"));
end PressureDrop;
