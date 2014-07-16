within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.BaseClasses.Aggregation.Examples;
function test_aggregateLoad
  input Integer n_max=14;
  input Integer p_max=2;
  // for n_max = 14 and p_max=2 --> q_max = 3

  input Integer q_max=BaseClasses.nbOfLevelAgg(
      n_max, p_max);

  input Real QNew = 2 "New load element";
  input Real[q_max,p_max] QAggOld = fill(1,q_max,p_max)
    "Aggregated load matrix form the previous time step";

  output Integer[q_max] rArr=
      BaseClasses.cellWidth(                             q_max, p_max);
  output Integer[q_max,p_max] nuMat=
      BaseClasses.nbPulseAtEndEachLevel(
        q_max,
        p_max,
        rArr);
  output Real[q_max,p_max] QMat;
algorithm
  QMat := aggregateLoad(
    q_max=q_max,
    p_max=p_max,
    rArr=rArr,
    nuMat=nuMat,
    QNew=QNew,
    QAggOld=QAggOld);
end test_aggregateLoad;
