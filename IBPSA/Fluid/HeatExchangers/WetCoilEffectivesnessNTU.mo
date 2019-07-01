within IBPSA.Fluid.HeatExchangers;
model WetCoilEffectivesnessNTU
  "Heat exchanger with effectiveness - NTU relation and simple model for moisture condensation"
  extends IBPSA.Fluid.HeatExchangers.BaseClasses.PartialEffectivenessNTU(
    sensibleOnly1=false,
    UA = 1/(1/hA.hA_1 + 1/hA.hA_2));

  parameter Real r_nominal(
    min=0,
    max=1) = 2/3
    "Ratio between air-side and water-side convective heat transfer (hA-value) at nominal condition";

  IBPSA.Fluid.HeatExchangers.BaseClasses.HADryCoil hA(
    final r_nominal=r_nominal,
    final UA_nominal=UA_nominal,
    final m_flow_nominal_w=m1_flow_nominal,
    final m_flow_nominal_a=m2_flow_nominal,
    waterSideTemperatureDependent=false,
    airSideTemperatureDependent=false)
    "Model for convective heat transfer coefficient";

equation
  // Convective heat transfer coefficient
  hA.m1_flow = m1_flow;
  hA.m2_flow = m2_flow;
  hA.T_1 = T_in1;
  hA.T_2 = T_in2;
  annotation (Documentation(revisions="<html>
<ul>
<li>
April 7, 2019, by Filip Jorissen:<br/>
First implementation for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1109\">#1109</a>.
</li>
</ul>
</html>"));
end WetCoilEffectivesnessNTU;
