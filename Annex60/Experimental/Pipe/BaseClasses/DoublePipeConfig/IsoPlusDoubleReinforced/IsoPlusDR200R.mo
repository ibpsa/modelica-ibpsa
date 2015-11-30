within Annex60.Experimental.Pipe.BaseClasses.DoublePipeConfig.IsoPlusDoubleReinforced;
record IsoPlusDR200R "Reinforced DN 200 IsoPlus double pipe"
  import DistrictHeating;
  extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
    Di=200e-3,
    Do=219.1e-3,
    h=45e-3,
    Dc=630e-3);
end IsoPlusDR200R;
