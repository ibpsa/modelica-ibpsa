within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.Records;
record BorefieldData
  "Record containing all the subrecords which describe all parameter values of the borefield"
  extends Modelica.Icons.Record;

  //  parameter String name = "nameBfSteRes" "name of the record";

  replaceable record Soi = Soil     constrainedby Soil     annotation (
      __Dymola_choicesAllMatching=true);
  Soi soi;

  replaceable record Fill =   Filling             constrainedby Filling
                        annotation (__Dymola_choicesAllMatching=true);
  Fill fil;

  replaceable record Geo =   Geometry              constrainedby Geometry
                          annotation (__Dymola_choicesAllMatching=true);
  Geo geo;

  replaceable record SteRes =    StepResponse     constrainedby StepResponse
                     annotation (__Dymola_choicesAllMatching=true);
  SteRes steRes;

  replaceable record Adv = Advanced (hBor=geo.hBor) constrainedby Advanced
    annotation (__Dymola_choicesAllMatching=true);
  Adv adv;

  replaceable record ShoTerRes =
                              ShortTermResponse
                                             constrainedby ShortTermResponse
    annotation (__Dymola_choicesAllMatching=true);
  ShoTerRes shoTerRes;

  Modelica.SIunits.MassFlowRate m_flow_nominal = steRes.m_flow*geo.nbBh/geo.nbSer
    "total nominal flow to the borefield";
  Modelica.SIunits.Power P_the_nominal = geo.hBor*geo.nbBh*50
    "nominal thermal power of the borefield";
end BorefieldData;
