within Annex60.Experimental.Pipe.BaseClasses.DoublePipeConfig.IsoPlusDoubleReinforced;
record IsoPlusDR80R "Reinforced DN 80 IsoPlus double pipe"
  import DistrictHeating;
  extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
    Di=80e-3,
    Do=88.9e-3,
    h=25e-3,
    Dc=280e-3);
end IsoPlusDR80R;
