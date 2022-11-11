within IBPSA.Fluid.HeatPumps;
model LargeScaleWaterToWater
  "Model with automatic parameter estimation for large scale water-to-water heat pumps"
  extends HeatPump(
    mCon_flow_nominal=autCalMCon_flow*scaFac,
    mEva_flow_nominal=autCalMEva_flow*scaFac,
    tauCon=autCalVCon*rhoCon/autCalMCon_flow,
    tauEva=autCalVEva*rhoEva/autCalMEva_flow);
  extends BaseClasses.LargeScaleWaterToWaterParameters(
    final QUseErrChe_flow_nominal=QUse_flow_nominal,
    final autCalMCon_flow=max(4E-5*QUse_flow_nominal - 0.6162, autCalMMin_flow),
    final autCalMEva_flow=max(4E-5*QUse_flow_nominal - 0.3177, autCalMMin_flow),
    final autCalVCon=max(1E-7*QUse_flow_nominal - 94E-4, autCalVMin),
    final autCalVEva=max(1E-7*QUse_flow_nominal - 75E-4, autCalVMin));

  annotation (Documentation(info="<html>
<p></span><span style=\"font-size: 9.75pt;\">TODO: Add doc and revision</p>
</html>"));
end LargeScaleWaterToWater;
