within IBPSA.Fluid.PVTCollectors.Validation.PVT_UI.Electrical;
model PVT_UI_Electrical_DayType4
  "Validation model for an unglazed rear-insulated PVT Collector"
  extends PVT_UI_Electrical_DayType1(pvtTyp="Typ4", T_start=48.60870229 + 273.15);
  annotation (Documentation(info="<html>
<p>
See the documentation of
<a href=\"modelica://IBPSA.Fluid.PVTCollectors.Validation.PVT_UI\">
IBPSA.Fluid.PVTCollectors.Validation.PVT_UI
</a>
for details on the validation examples and usage.
</p>
</html>", revisions=
"<html>
<ul>
<li>
March 11, 2026, by Lone Meertens:<br/>
Updated thermal formulation from ISO 9806:2013 to ISO 9806:2017. 
This is for <a href=\"https://github.com/open-ideas/IDEAS/issues/1473\">#1473</a>.
</li>
<li>
July 7, 2025, by Lone Meertens:<br/>
First implementation PVT model.
This is for <a href=\"https://github.com/open-ideas/IDEAS/issues/1436\">#1436</a>.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Fluid/PVTCollectors/Validation/PVT_UI/Electrical/PVT_UI_Electrical_DayType4.mos"
        "Simulate and plot"),
 experiment(
      StartTime=17837640,
      StopTime=17872560.0,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"));
end PVT_UI_Electrical_DayType4;
