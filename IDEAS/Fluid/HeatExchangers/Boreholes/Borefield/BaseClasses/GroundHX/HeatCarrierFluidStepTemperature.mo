within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.BaseClasses.GroundHX;
function HeatCarrierFluidStepTemperature "Return the corrected average of the (vertical) mean temperature at the center of each borehole of the boreholes field. \\
  The correction is from t=0 till t_d = tBre. \\
  Input TResSho gives the vector with the correct temperatures for this time period"
  extends BaseClasses.partialBoreFieldTemperature;
  import SI = Modelica.SIunits;

  input Data.Records.ShortTermResponse shoTerRes=
      Data.ShortTermResponse.example();

protected
  SI.TemperatureDifference delta_T_fts_corBre;

algorithm
  assert(steRes.tBre_d > steRes.t_min_d,
    "The choosen tBre_d is too small. It should be bigger than t_min_d!");
  if t_d < steRes.tBre_d then
    T := shoTerRes.TResSho[t_d + 1];
    delta_T_fts_corBre := 0;
  else
    delta_T_fts_corBre := shoTerRes.TResSho[steRes.tBre_d] -
      BoreFieldWallTemperature(
      t_d=steRes.tBre_d,
      r=geo.rBor,
      steRes=steRes,
      geo=geo,
      soi=soi);
    T := BoreFieldWallTemperature(
      t_d=t_d,
      r=geo.rBor,
      steRes=steRes,
      geo=geo,
      soi=soi) + delta_T_fts_corBre;
  end if;

end HeatCarrierFluidStepTemperature;
