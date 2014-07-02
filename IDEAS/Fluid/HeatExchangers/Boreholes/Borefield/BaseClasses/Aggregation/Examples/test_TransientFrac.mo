within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.BaseClasses.Aggregation.Examples;
function test_TransientFrac "ATTENTION: don't translate this function! otherwise it doesn't work anymore, \\
  because some of the code is not possible to statically translate into c-code!\\
  ATTENTION: first translate transientFrac!
  ---------------------------------------------------------------------
  Borefield.Data.GenericStepParam.tS3600_tmind1_qSte30(),
  Borefield.Data.BorefieldGeometricData.Line1_rB010_h100(),
  Borefield.Data.SoilData.Sandstone(),
  Borefield.Data.ShortTermResponse.SandstoneH100qSte30()
  ---------------------------------------------------------------------
  "
  input Integer n_max=201;
  input Integer p_max=5;
  input Real TSteSta = 280;

  output Integer q_max=BaseClasses.nbOfLevelAgg(
      n_max, p_max);
  output Integer v_max;
  output Integer[q_max] rArr;
  output Integer nbLumpedCells;
  output Integer[q_max,p_max] nuMat;
  output Real[q_max,p_max] kappaMat;

algorithm
  (,v_max) := BaseClasses.nbOfLevelAgg(n_max, p_max);
  rArr := BaseClasses.cellWidth(q_max, p_max);

  nuMat := BaseClasses.nbPulseAtEndEachLevel(
    q_max,
    p_max,
    rArr);

  kappaMat := transientFrac(
    q_max,
    p_max,
    Data.StepResponse.example(),
    Data.GeometricData.example(),
    Data.SoilData.example(),
    Data.ShortTermResponse.example(),
    nuMat=nuMat,
    TSteSta=TSteSta);

end test_TransientFrac;
