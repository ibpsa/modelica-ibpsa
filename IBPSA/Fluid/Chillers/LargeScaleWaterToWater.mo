within IBPSA.Fluid.Chillers;
model LargeScaleWaterToWater
  extends Chiller(
    mCon_flow_nominal=autCalMCon_flow*scaFac,
    mEva_flow_nominal=autCalMEva_flow*scaFac,
    tauCon=autCalVCon*rhoCon/autCalMCon_flow,
    tauEva=autCalVEva*rhoEva/autCalMEva_flow);
  extends IBPSA.Fluid.HeatPumps.BaseClasses.LargeScaleWaterToWaterParameters(
    final QUseErrChe_flow_nominal=QUse_flow_nominal,
    final autCalMCon_flow=max(5E-5*QUse_flow_nominal + 0.3161, autCalMMin_flow),
    final autCalMEva_flow=max(5E-5*QUse_flow_nominal - 0.5662, autCalMMin_flow),
    final autCalVCon=max(2E-7*QUse_flow_nominal - 84E-4, autCalVMin),
    final autCalVEva=max(1E-7*QUse_flow_nominal - 66E-4, autCalVMin));
end LargeScaleWaterToWater;
