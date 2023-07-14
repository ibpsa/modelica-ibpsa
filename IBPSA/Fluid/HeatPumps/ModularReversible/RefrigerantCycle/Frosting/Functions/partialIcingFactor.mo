within IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.Functions;
partial function partialIcingFactor
  "Base function for all icing factor functions"
  extends Modelica.Icons.Function;
  input Modelica.Units.SI.ThermodynamicTemperature TEvaInMea
    "Evaporator supply temperature. Should be equal to outdoor air temperature";
  input Modelica.Units.SI.ThermodynamicTemperature TEvaOutMea
    "Evaporator return temperature";
  input Modelica.Units.SI.MassFlowRate mEva_flow
    "Mass flow rate at the evaporator";
  output Real iceFac(min=0, max=1)
    "Efficiency factor to estimate influence
    of icing (0: full icing, 1: no icing)";

  annotation (Documentation(revisions="<html><ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  Base function for calculation of the icing factor. The <code>iceFac</code>
  represents reduction of heat exchange as a result of icing of
  the evaporator.
</p>
<p>
  This function is used in the model <a href=
  \"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.FunctionalIcingFactor\">
  IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.FunctionalIcingFactor</a>.
</p>
<p>
  Typically, functions should only require evaporator side data for calculation of
  the <code>iceFac</code>.
</p>
<p>
For more information on the <code>iceFac</code>, see the documentation of <a href=
\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialRefrigerantCycle\">
IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialRefrigerantCycle</a>
</p>
</html>"));
end partialIcingFactor;
