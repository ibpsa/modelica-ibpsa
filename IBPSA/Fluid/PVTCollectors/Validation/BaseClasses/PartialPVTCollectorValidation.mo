within IBPSA.Fluid.PVTCollectors.Validation.BaseClasses;
partial model PartialPVTCollectorValidation
  "Base model for UI and UN PVT collector validation models"
  extends .IDEAS.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector(
    redeclare .IDEAS.Fluid.PVTCollectors.Data.Generic per);

  parameter .Modelica.Units.SI.Efficiency eleLosFac(min=0, max=1) = 0.07
    "Loss factor of the PV panel(s)"
    annotation(Dialog(group="Electrical parameters"));
  parameter .IDEAS.Fluid.PVTCollectors.Types.CollectorType collectorType = per.colTyp
    "Collector type used to select a default tauAlpEff";
  parameter Real tauAlpEff(min=0, max=1)=
    if collectorType == .IDEAS.Fluid.PVTCollectors.Types.CollectorType.Uncovered then 0.901 else 0.84
    "Effective transmittance-absorptance product";
  .Modelica.Units.SI.HeatFlux qThSeg[nSeg]
    "Thermal power per segment";
  .Modelica.Blocks.Interfaces.RealOutput Pel
    "Total electrical power output [W]";
  .Modelica.Blocks.Interfaces.RealOutput Qth
    "Total thermal power output [W]";
annotation (
    defaultComponentName="pvtCol",
    Documentation(info="<html>
<p>
This component is a partial model of a PVT collector for model validation.
</p>

</html>", revisions="<html>
<ul>
<li>
March 11, 2026, by Lone Meertens:<br/>
Added new partial model to provide a common base class for PVT collector
validation models and improve consistency between validation cases.
This is for <a href=\"https://github.com/open-ideas/IDEAS/issues/1473\">#1473</a>.
</li>
</ul>
</html>"));
end PartialPVTCollectorValidation;
