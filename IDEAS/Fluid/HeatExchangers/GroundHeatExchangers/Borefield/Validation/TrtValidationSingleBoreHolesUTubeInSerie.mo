within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Validation;
model TrtValidationSingleBoreHolesUTubeInSerie
  extends
    IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.Examples.SingleBoreHoleUTubeSerStepLoad(
    redeclare Data.SoilData.SoilTrt soi,
    redeclare Data.FillingData.FillingTrt fil,
    redeclare Data.GeneralData.GeneralTrtUTube gen,
    hea(Q_flow_nominal=3618));

    Real Rb_sim2 = (borHolSer.borHol[1].borHolSeg[1].intHEX.vol1.T + borHolSer.borHol[1].borHolSeg[1].intHEX.vol2.T - 2*borHolSer.borHol[1].borHolSeg[1].intHEX.port.T)/2/(Q/gen.hSeg);
    Modelica.SIunits.Temperature T_mea = 3.307*log(time + 1) - 6.2715 + 273.15;
end TrtValidationSingleBoreHolesUTubeInSerie;
