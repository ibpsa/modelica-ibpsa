within IBPSA.Fluid.HeatPumps;
model AirToWaterWithFlowsheetAndFluid
  "Detailed 3D performance data with air to water heat pump for different fluids and flowsheets"
  extends ModularReversible(
    final GEvaIns=0,
    final GEvaOut=0,
    final CEva=0,
    final use_evaCap=false,
    final GConIns=0,
    final GConOut=0,
    final CCon=0,
    redeclare model BlackBoxHeatPumpCooling =
        IBPSA.Fluid.Chillers.BlackBoxData.BaseClasses.NoCooling,
    final use_TSet=false,
    redeclare final model BlackBoxHeatPumpHeating =
        IBPSA.Fluid.HeatPumps.BlackBoxData.VCLibMap (
        redeclare IBPSA.Fluid.HeatPumps.BlackBoxData.Frosting.NoFrosting
          iceFacCal,
        refrigerant=refrigerant,
        flowsheet=flowsheet,
        filename=filename),
    final use_rev=false,
    redeclare final model VapourCompressionCycleInertia =
        IBPSA.Fluid.HeatPumps.BlackBoxData.VapourCompressionInertias.NoInertia);
  parameter String filename="modelica://IBPSA/Resources/Data/Fluid/BaseClasses/PerformanceData/VCLibMap/VCLibMap.sdf"
    "Path to the sdf file";
  parameter String refrigerant="R410A" "Identifier for the refrigerant";
  parameter String flowsheet="StandardFlowsheet" "Identifier for the flowsheet";
end AirToWaterWithFlowsheetAndFluid;
