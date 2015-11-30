within Annex60.Experimental.Pipe.BaseClasses.DoublePipeConfig.IsoPlusDoubleReinforced;
record IsoPlusDR25R "Reinforced DN 25 IsoPlus double pipe"
  import DistrictHeating;
  extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
    h=20e-3,
    Di=25e-3,
    Do=33.7e-3,
    Dc=160e-3);
end IsoPlusDR25R;
