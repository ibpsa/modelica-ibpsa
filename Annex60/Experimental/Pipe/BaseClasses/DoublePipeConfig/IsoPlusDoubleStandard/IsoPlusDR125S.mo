within Annex60.Experimental.Pipe.BaseClasses.DoublePipeConfig.IsoPlusDoubleStandard;
record IsoPlusDR125S "Standard DN 125 IsoPlus double pipe"
  import DistrictHeating;
  extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
    Di=125e-3,
    Do=139.7e-3,
    h=30e-3,
    Dc=400e-3);
end IsoPlusDR125S;
