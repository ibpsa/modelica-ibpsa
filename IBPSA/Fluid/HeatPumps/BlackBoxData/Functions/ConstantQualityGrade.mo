within IBPSA.Fluid.HeatPumps.BlackBoxData.Functions;
function ConstantQualityGrade
  "Carnot CoP multiplied with constant quality grade and constant electric power"
  extends
    IBPSA.Fluid.HeatPumps.BlackBoxData.Functions.BaseClasses.PartialBaseFct(
    N,
    TConOut,
    TEvaIn,
    mEva_flow,
    mCon_flow);
    parameter Real qualityGrade=0.3 "Constant quality grade";
    parameter Modelica.Units.SI.Power P_com=2000
    "Constant electric power input for compressor";
protected
  Real COPCarnot "Carnot COP";
algorithm
  COPCarnot := TConOut/(TConOut - TEvaIn);
  Char:={P_com,P_com*COPCarnot*qualityGrade};

  annotation (Documentation(info="<html><p>
  Carnot CoP multiplied with constant quality grade and constant
  electric power, no dependency on speed or mass flow rates!
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
end ConstantQualityGrade;
