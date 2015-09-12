within Annex60.Experimental.ThermalZones.BaseClasses.CorrectionSolarGain;
partial model PartialCorG
  "partial model for correction of the solar gain factor"

   parameter Integer n = 1 "vector size for input and output";

  Modelica.Blocks.Interfaces.RealOutput solarRadWinTrans[n](unit="W/m2")
    "transmitted solar radiation through window"
    annotation (Placement(transformation(extent={{80,-10},{100,10}}),
        iconTransformation(extent={{80,-10},{100,10}})));
  Modelica.Blocks.Interfaces.RealInput I[n]
    annotation (Placement(transformation(extent={{-120,50},{-80,90}})));
  Modelica.Blocks.Interfaces.RealInput I_diff[n]
    annotation (Placement(transformation(extent={{-120,-30},{-80,10}})));
  Modelica.Blocks.Interfaces.RealInput I_dir[n]
    annotation (Placement(transformation(extent={{-120,10},{-80,50}})));
  Modelica.Blocks.Interfaces.RealInput I_gr[n]
    annotation (Placement(transformation(extent={{-120,-70},{-80,-30}})));
  Modelica.Blocks.Interfaces.RealInput AOI[n]
    annotation (Placement(transformation(extent={{-120,-110},{-80,-70}})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid), Text(
          extent={{-52,24},{62,-16}},
          lineColor={0,0,0},
          textString="%name")}),
    Documentation(info="<html>
<h4><span style=\"color:#008000\">Overview</span></h4>
<p>Partial model for correction cofficient for transmitted solar radiation through a window.</p>
<h4><span style=\"color:#008000\">Level of Development</span></h4>
<p><img src=\"modelica://AixLib/Images/stars3.png\"/> </p>
</html>"));
end PartialCorG;
