within Annex60.Experimental.Pipe.BaseClasses.DoublePipeConfig.IsoPlusDoubleStandard;
record IsoPlusDR100S "Standard DN 100 IsoPlus double pipe"
  import DistrictHeating;
  extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
    h=25e-3,
    Di=100e-3,
    Do=114.3e-3,
    Dc=315e-3);
end IsoPlusDR100S;
