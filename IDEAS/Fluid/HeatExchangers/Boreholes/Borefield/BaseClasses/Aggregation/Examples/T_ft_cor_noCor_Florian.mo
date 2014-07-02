within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.BaseClasses.Aggregation.Examples;
function T_ft_cor_noCor_Florian "Return the corrected mean fluid temperature of the borehole/field. The correction is from t=0 till t_d = tBre. 
  Input TResSho give the vector with the correct temperatures for this time period"
  extends GroundHX.BaseClasses.partialBoreFieldTemperature(steRes=IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Data.StepResponse.example(),
  geo=IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Data.GeometricData.example_Florian(),
  soi = IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Data.SoilData.example_Florian(), t_d = 36000);

  //Real delta_T_fts_corBre=0;

algorithm
//  assert( steRes.tBre_d > steRes.t_min_d,  "The choosen tBre_d is too small. It should be bigger than t_min_d!");

  if t_d <= steRes.t_min_d then
    T := 0;
  else
/*
    delta_T_fts_corBre := shoTerRes.TResSho[steRes.tBre_d] - 273.15 - Borefield.GroundHX.T_rt(
      t_d= steRes.tBre_d,
      r=0,
      steRes=steRes,
      geo=geo,
      soi=soi);
*/
    T := GroundHX.BoreFieldWallTemperature(
      t_d=t_d,
      r=geo.rBor,
      steRes=steRes,
      geo=geo,
      soi=soi);
                 //+ delta_T_fts_corBre;
  end if;

end T_ft_cor_noCor_Florian;
