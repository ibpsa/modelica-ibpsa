within IBPSA.Fluid.HeatPumps.BlackBoxData.Frosting;
package Functions
  "Package with functions to calculate current icing factor on evaporator"
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
    <i>November 26, 2018&#160;</i> by Fabian Wüllhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>",   info="<html>
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

  function WetterAfjei1996
    "Correction of CoP (Icing, Defrost) according to Wetter,Afjei 1996"
    extends
      IBPSA.Fluid.HeatPumps.BlackBoxData.Frosting.Functions.PartialBaseFct;

  parameter Real A=0.03;
  parameter Real B=-0.004;
  parameter Real C=0.1534;
  parameter Real D=0.8869;
  parameter Real E=26.06;
  protected
  Real factor;
  Real linear_term;
  Real gauss_curve;
  algorithm
  linear_term:=A + B*TEvaInMea;
  gauss_curve:=C*Modelica.Math.exp(-(TEvaInMea - D)*(TEvaInMea - D)/E);
  if linear_term>0 then
    factor:=linear_term + gauss_curve;
  else
    factor:=gauss_curve;
  end if;
  iceFac:=1-factor;
    annotation (Documentation(info="<html><p>
  Correction of CoP (Icing, Defrost) according to Wetter,Afjei 1996.
</p>
</html>",
    revisions="<html><ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wüllhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>"));
  end WetterAfjei1996;
annotation (Documentation(revisions="<html><ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wüllhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  This package contains functions for calculation of an icing factor
  used in <a href=
  \"modelica://IBPSA.Fluid.HeatPumps.BaseClasses.PerformanceData.IcingBlock\">
  IBPSA.Fluid.HeatPumps.BaseClasses.PerformanceData.IcingBlock</a>.
</p>
</html>"));
end Functions;
