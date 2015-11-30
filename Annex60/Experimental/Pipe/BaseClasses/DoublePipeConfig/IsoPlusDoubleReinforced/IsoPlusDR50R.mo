within Annex60.Experimental.Pipe.BaseClasses.DoublePipeConfig.IsoPlusDoubleReinforced;
record IsoPlusDR50R "Reinforced DN 50 IsoPlus double pipe"
  import DistrictHeating;
  extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
    h=20e-3,
    Di=50e-3,
    Do=60.3e-3,
    Dc=225e-3);
end IsoPlusDR50R;
