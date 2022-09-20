within IBPSA.Fluid.HeatPumps.BlackBoxData.Frosting.Functions;
partial function PartialBaseFct "Base function for all icing factor functions"
  extends Modelica.Icons.Function;
  input Modelica.Units.SI.ThermodynamicTemperature TEvaInMea
    "Evaporator supply temperature. Should be equal to outdoor air temperature";
  input Modelica.Units.SI.ThermodynamicTemperature TEvaOutMea
    "Evaporator return temperature";
  input Modelica.Units.SI.MassFlowRate mEva_flow
    "Mass flow rate at the evaporator";
  output Real iceFac(min=0, max=1) "Efficiency factor (0..1) to estimate influence of icing. 0 means no heat is transferred through heat exchanger (fully frozen). 1 means no icing/frosting.";

  annotation (Documentation(revisions="<html><ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  Base function for calculation of the icing factor. The normalized
  value represents reduction of heat exchange as a result of icing of
  the evaporator.
</p>
<p>
  iceFac: Efficiency factor (0..1) to estimate influence of icing. 0
  means no heat is transferred through heat exchanger (fully frozen); 1
  means no icing/frosting.
</p>
</html>"));
end PartialBaseFct;
