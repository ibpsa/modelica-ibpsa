within Annex60.Experimental.Pipe.BaseClasses.DoublePipeConfig.IsoPlusDoubleReinforced;
record IsoPlusDR32R "Reinforced DN 32 IsoPlus double pipe"
  import DistrictHeating;
  extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
    h=20e-3,
    Di=32e-3,
    Do=42.4e-3,
    Dc=180e-3);
end IsoPlusDR32R;
