within IBPSA.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.Examples;
model FiniteLineSource_Integrand_Test
  "Test case for finite line source integrand function"
  extends Modelica.Icons.Example;

  parameter Real dis_over_len = 0.0005 "Radial distance between borehole axes";
  parameter Modelica.SIunits.Height len150 = 150.0 "Length of emitting borehole";
  parameter Modelica.SIunits.Height len75 = 75.0 "Length of emitting borehole";
  parameter Modelica.SIunits.Height len25 = 25.0 "Length of emitting borehole";
  parameter Modelica.SIunits.Height len5 = 5.0 "Length of emitting borehole";
  parameter Modelica.SIunits.Height len1 = 1.0 "Length of emitting borehole";
  parameter Modelica.SIunits.Height burDep = 4. "Buried depth of emitting borehole";
  Real u "Integration variable";
  Real y150 "Finite line source integrand";
  Real y75 "Finite line source integrand";
  Real y25 "Finite line source integrand";
  Real y5 "Finite line source integrand";
  Real y1 "Finite line source integrand";

equation
  u = time;
  y150 = IBPSA.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Integrand(
    u=u,
    dis=dis_over_len*len150,
    len1=len150,
    burDep1=burDep,
    len2=len150,
    burDep2=burDep);
  y75 = IBPSA.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Integrand(
    u=u,
    dis=dis_over_len*len75,
    len1=len75,
    burDep1=burDep,
    len2=len75,
    burDep2=burDep);
  y25 = IBPSA.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Integrand(
    u=u,
    dis=dis_over_len*len25,
    len1=len25,
    burDep1=burDep,
    len2=len25,
    burDep2=burDep);
  y5 = IBPSA.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Integrand(
    u=u,
    dis=dis_over_len*len5,
    len1=len5,
    burDep1=burDep,
    len2=len5,
    burDep2=burDep);
  y1 = IBPSA.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Integrand(
    u=u,
    dis=dis_over_len*len1,
    len1=len1,
    burDep1=burDep,
    len2=len1,
    burDep2=burDep);

  annotation (
    __Dymola_Commands(file=
          "modelica://IBPSA/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/HeatTransfer/ThermalResponseFactors/Examples/FiniteLineSource_Integrand_Test.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StartTime=0.01, StopTime=500.0),
    Documentation(info="<html>
<p>
This example demonstrates the evaluation of the
finite line source integrand function.
</p>
</html>", revisions="<html>
<ul>
<li>
March 15, 2019, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end FiniteLineSource_Integrand_Test;
