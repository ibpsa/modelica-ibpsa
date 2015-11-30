within Annex60.Experimental.Pipe.BaseClasses.DoublePipeConfig.IsoPlusDoubleReinforced;
record IsoPlusDR20R "Reinforced DN 20 IsoPlus double pipe"
  import DistrictHeating;
  extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
    Di=20e-3,
    Do=26.9e-3,
    h=20e-3,
    Dc=140e-3);
end IsoPlusDR20R;
