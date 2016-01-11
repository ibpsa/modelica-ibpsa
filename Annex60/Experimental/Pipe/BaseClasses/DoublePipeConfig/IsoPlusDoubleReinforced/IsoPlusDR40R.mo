within Annex60.Experimental.Pipe.BaseClasses.DoublePipeConfig.IsoPlusDoubleReinforced;
record IsoPlusDR40R "Reinforced DN 40 IsoPlus double pipe"
  import DistrictHeating;
  extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
    h=20e-3,
    Di=40e-3,
    Do=48.3e-3,
    Dc=180e-3);
end IsoPlusDR40R;
