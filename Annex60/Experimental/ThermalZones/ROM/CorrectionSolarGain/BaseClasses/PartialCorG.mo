within Annex60.Experimental.ThermalZones.ROM.CorrectionSolarGain.BaseClasses;
partial model PartialCorG
  "Partial model for correction of the solar gain factor"

   parameter Integer n(min = 1) "Vector size for input and output";

  Modelica.Blocks.Interfaces.RealOutput solarRadWinTrans[n](
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") "transmitted solar radiation through windows"
    annotation (Placement(transformation(extent={{80,-10},{100,10}}),
        iconTransformation(extent={{80,-10},{100,10}})));
  Modelica.Blocks.Interfaces.RealInput HSkyDifTil[n](final quantity="RadiantEnergyFluenceRate",
      final unit="W/m2")
    "Hemispherical diffuse solar irradiation on a tilted surfce from the sky"
    annotation (Placement(transformation(extent={{-120,-30},{-80,10}})));
  Modelica.Blocks.Interfaces.RealInput HDirTil[n](
     final quantity="RadiantEnergyFluenceRate",
     final unit="W/m2")
    "Direct solar radiation on a tilted surface per unit area"
    annotation (Placement(transformation(extent={{-120,10},{-80,50}})));
  Modelica.Blocks.Interfaces.RealInput HGroDifTil[n](final quantity=
    "RadiantEnergyFluenceRate", final unit="W/m2")
    "Hemispherical diffuse solar irradiation on a tilted surfce from the ground"
    annotation (Placement(transformation(extent={{-120,-70},{-80,-30}})));
  Modelica.Blocks.Interfaces.RealInput inc[n](final quantity="Angle",
    final unit="rad",
    displayUnit="deg") "Incidence angles"
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
<h4><span style=\"color: #000000\">Overview</span></h4>
<p>Partial model for correction cofficient for transmitted solar radiation through a window.</p>
</html>"));
end PartialCorG;
