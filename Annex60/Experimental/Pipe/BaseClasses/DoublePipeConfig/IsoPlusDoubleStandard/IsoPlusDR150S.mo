within Annex60.Experimental.Pipe.BaseClasses.DoublePipeConfig.IsoPlusDoubleStandard;
record IsoPlusDR150S "Standard DN 150 IsoPlus double pipe"
  import DistrictHeating;
  extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
    Di=150e-3,
    Do=168.3e-3,
    h=40e-3,
    Dc=450e-3);
end IsoPlusDR150S;
