within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.GroundHX;
function CorrectedBoreFieldWallTemperature "Return the corrected average borehole wall temperature of the whole borefield
  The correction is from t=0 till t_d = tBre. \\
  Input TResSho gives the vector with the correct temperatures for this time period"
  extends BaseClasses.partialBoreFieldTemperature;
  import SI = Modelica.SIunits;

  input Real[:] TResSho
    "Vector containing the short term  fluid step-reponse temperature in function of the time";

protected
  SI.TemperatureDifference delta_Twall_corBre;

algorithm
  if t_d < steRes.tBre_d then
    T := TResSho[t_d + 1];
    delta_Twall_corBre := 0;
  else
    delta_Twall_corBre := TResSho[steRes.tBre_d] -
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
      soi=soi) + delta_Twall_corBre;
  end if;

end CorrectedBoreFieldWallTemperature;
