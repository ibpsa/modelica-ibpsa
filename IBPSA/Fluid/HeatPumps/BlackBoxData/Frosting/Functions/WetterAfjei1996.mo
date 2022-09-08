within IBPSA.Fluid.HeatPumps.BlackBoxData.Frosting.Functions;
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
    <i>November 26, 2018&#160;</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>"));
end WetterAfjei1996;
