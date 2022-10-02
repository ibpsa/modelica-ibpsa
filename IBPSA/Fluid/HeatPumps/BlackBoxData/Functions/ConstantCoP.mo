within IBPSA.Fluid.HeatPumps.BlackBoxData.Functions;
function ConstantCoP "Constant CoP and constant electric power"
  extends
    IBPSA.Fluid.HeatPumps.BlackBoxData.Functions.BaseClasses.PartialBaseFct(
    N,
    TConOut,
    TEvaIn,
    mEva_flow,
    mCon_flow);
  parameter Modelica.Units.SI.Power Pel_nominal=2000
    "Constant electric power input for compressor";
    parameter Real CoP "Constant CoP";
algorithm
  Char:={Pel_nominal,Pel_nominal*CoP};

  annotation (Documentation(info="<html><p>
  Carnot CoP and constant electric power, no dependency on speed or
  mass flow rates!
</p>
</html>",
    revisions="<html><ul>
  <li>
    <i>June 21, 2015&#160;</i> by Kristian Huchtemann:<br/>
    implemented
  </li>
</ul>
</html>
"));
end ConstantCoP;
