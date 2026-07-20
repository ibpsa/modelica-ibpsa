within IBPSA.Fluid.PVTCollectors.Validation.PVT_UN;
model PVT_UN_Thermal
  "Validation model for an unglazed rear-non-insulated PVT Collector"
   extends .IDEAS.Fluid.PVTCollectors.Validation.PVT_UI.Thermal.PVT_UI_Thermal_DayType1(
    redeclare package Medium =
      .IDEAS.Media.Antifreeze.PropyleneGlycolWater(
        property_T=293.15, X_a=0.43),
    redeclare parameter .IDEAS.Fluid.PVTCollectors.Data.Uncovered.UN_Validation datPVTCol,
    redeclare parameter .IDEAS.Fluid.PVTCollectors.Validation.PVT_UN.BaseClasses.UN_Validation datPVTColVal,
    redeclare .IDEAS.Fluid.PVTCollectors.Validation.PVT_UN.PVTCollectorValidation pvtCol(
      redeclare package Medium =
        .IDEAS.Media.Antifreeze.PropyleneGlycolWater(property_T=293.15, X_a=0.43),
      energyDynamics=.Modelica.Fluid.Types.Dynamics.FixedInitial,
      massDynamics=.Modelica.Fluid.Types.Dynamics.FixedInitial,
      T_start=17.086651 + 273.15,
      show_T=true,
      azi=0,
      til=0.34906585039887,
      rho=0.2,
      nColType=.IDEAS.Fluid.SolarCollectors.Types.NumberSelection.Number,
      nPanels=1,
      per=datPVTCol,
      eleLosFac=0.07),
    redeclare .IDEAS.Fluid.PVTCollectors.Validation.PVT_UN.PVTCollectorValidation pvtColVal(
      redeclare package Medium =
        .IDEAS.Media.Antifreeze.PropyleneGlycolWater(property_T=293.15, X_a=0.43),
      energyDynamics=.Modelica.Fluid.Types.Dynamics.FixedInitial,
      massDynamics=.Modelica.Fluid.Types.Dynamics.FixedInitial,
      T_start=17.086651 + 273.15,
      show_T=true,
      azi=0,
      til=0.34906585039887,
      rho=0.2,
      nColType=.IDEAS.Fluid.SolarCollectors.Types.NumberSelection.Number,
      nPanels=1,
      per=datPVTCol,
      eleLosFac=0.07),
    idxTFlu = 2,
    idxMFlow = 3,
    idxGtil = 4,
    idxWinSpe = 10,
    idxTAmb = 5,
    idxMeaPel = 19,
    meaFile =
      "modelica://IDEAS/Resources/Data/Fluid/PVTCollectors/Validation/PVT_UN/PVT_UN_measurements_" + week + ".txt");

  parameter String week = "week1";
  annotation ( Documentation(info = "<html>
<p>
This model validates the thermal performance of the 
<a href=\"modelica://IDEAS.Fluid.PVTCollectors.Validation.PVT_UN\">PVT_UN</a> collector, 
an uncovered and uninsulated PVT collector.
</p>
<p>
See the documentation of
<a href=\"modelica://IDEAS.Fluid.PVTCollectors.Validation.PVT_UN\">
PVT_UN
</a>
for details on the validation model and usage.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 11, 2026, by Lone Meertens:<br/>
Updated thermal formulation from ISO 9806:2013 to ISO 9806:2017. 
This is for <a href=\"https://github.com/open-ideas/IDEAS/issues/1473\">#1473</a>.
</li>
<li>
September 3, 2025, by Jelger Jansen:<br/>
Introduce <code>week</code> parameter to change the weather dataset.
This is for <a href=\"https://github.com/open-ideas/IDEAS/issues/1462\">#1462</a>.
</li>
<li>
July 7, 2025, by Lone Meertens:<br/>
First implementation PVT model.
This is for <a href=\"https://github.com/open-ideas/IDEAS/issues/1436\">#1436</a>.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
__Dymola_Commands(file="modelica://IDEAS/Resources/Scripts/Dymola/Fluid/PVTCollectors/Validation/PVT_UN/PVT_UN_Thermal.mos"
        "Simulate and plot"),
 experiment(
      StartTime=16502400,
      StopTime=21513595,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"));
end PVT_UN_Thermal;
