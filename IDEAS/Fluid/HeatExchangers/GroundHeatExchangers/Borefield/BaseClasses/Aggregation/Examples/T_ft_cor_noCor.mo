within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.Aggregation.Examples;
function T_ft_cor_noCor "Return the corrected mean fluid temperature of the borehole/field. The correction is from t=0 till t_d = tBre. 
  Input TResSho give the vector with the correct temperatures for this time period"
  extends GroundHX.BaseClasses.partialBoreFieldTemperature;

  input Data.Records.ShortTermResponse shoTerRes=
      Data.ShortTermResponse.example();
  input Integer t_d "discrete time at which the temperature is calculated";

protected
  Real delta_T_fts_corBre=0;

algorithm
//  assert( steRes.tBre_d > steRes.t_min_d,  "The choosen tBre_d is too small. It should be bigger than t_min_d!");

  if t_d <= steRes.t_min_d then
    T := 0;
  else

    T := GroundHX.BoreFieldWallTemperature(
      t_d=t_d,
      r=0,
      steRes=steRes,
      geo=geo,
      soi=soi);
                 //+ delta_T_fts_corBre;
  end if;

end T_ft_cor_noCor;
