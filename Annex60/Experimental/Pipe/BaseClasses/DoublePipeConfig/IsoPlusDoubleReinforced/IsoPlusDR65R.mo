within Annex60.Experimental.Pipe.BaseClasses.DoublePipeConfig.IsoPlusDoubleReinforced;
record IsoPlusDR65R "Reinforced DN 65 IsoPlus double pipe"
  import DistrictHeating;
  extends DistrictHeating.Pipes.BaseClasses.PipeConfig.IsoPlusDouble(
    h=20e-3,
    Di=65e-3,
    Do=76.1e-3,
    Dc=250e-3);
end IsoPlusDR65R;
