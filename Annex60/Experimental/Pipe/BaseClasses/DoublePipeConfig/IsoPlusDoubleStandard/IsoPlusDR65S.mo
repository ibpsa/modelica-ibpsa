within Annex60.Experimental.Pipe.BaseClasses.DoublePipeConfig.IsoPlusDoubleStandard;
record IsoPlusDR65S "Standard DN 65 IsoPlus double pipe"
  import DistrictHeating;
  extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
    h=20e-3,
    Di=65e-3,
    Do=76.1e-3,
    Dc=225e-3);
end IsoPlusDR65S;
