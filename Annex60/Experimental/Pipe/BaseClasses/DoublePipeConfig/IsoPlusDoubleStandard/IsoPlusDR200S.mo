within Annex60.Experimental.Pipe.BaseClasses.DoublePipeConfig.IsoPlusDoubleStandard;
record IsoPlusDR200S "Standard DN 200 IsoPlus double pipe"
  import DistrictHeating;
  extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
    Di=200e-3,
    Do=219.1e-3,
    h=45e-3,
    Dc=560e-3);
end IsoPlusDR200S;
