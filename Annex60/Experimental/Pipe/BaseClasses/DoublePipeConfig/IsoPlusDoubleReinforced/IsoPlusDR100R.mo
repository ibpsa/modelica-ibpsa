within Annex60.Experimental.Pipe.BaseClasses.DoublePipeConfig.IsoPlusDoubleReinforced;
record IsoPlusDR100R "Reinforced DN 100 IsoPlus double pipe"
  import DistrictHeating;
  extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
    h=25e-3,
    Di=100e-3,
    Do=114.3e-3,
    Dc=355e-3);
end IsoPlusDR100R;
