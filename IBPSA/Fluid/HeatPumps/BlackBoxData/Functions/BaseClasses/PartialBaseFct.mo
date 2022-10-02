within IBPSA.Fluid.HeatPumps.BlackBoxData.Functions.BaseClasses;
partial function PartialBaseFct
  "Base class for Cycle Characteristic"
  extends Modelica.Icons.Function;
  input Real N "Relative compressor speed";
  input Modelica.Units.SI.Temperature TConOut "Condenser outlet temperature";
  input Modelica.Units.SI.Temperature TEvaIn "Evaporator inlet temperature";
  input Modelica.Units.SI.MassFlowRate mEva_flow "Mass flow rate at evaporator";
  input Modelica.Units.SI.MassFlowRate mCon_flow "Mass flow rate at condenser";
  output Real Char[2] "Array with [Pel, QCon]";

  annotation (Documentation(info="<html><p>
  Base funtion used in HeatPump model. It defines the inputs speed N
  (1/min), condenser outlet temperature T_co (K) and evaporator inlet
  temperature T_ev (K). The output is the vector Char: first value is
  compressor power, second value is the condenser heat flow rate.
</p>
</html>",
    revisions="<html><ul>
  <li>
    <i>December 10, 2013&#160;</i> by Ole Odendahl:<br/>
    Formatted documentation appropriately
  </li>
</ul>
</html>
"));
end PartialBaseFct;
