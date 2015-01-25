within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.Interface;
partial model PartialSingleBoreHole "Single borehole heat exchanger"
  import Buildings;
  extends PartialBoreHoleElement;
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
                              annotation (choicesAllMatching=true);
  extends IDEAS.Fluid.Interfaces.PartialTwoPortInterface(show_T=true,
      redeclare package Medium = Medium);
  extends IDEAS.Fluid.Interfaces.TwoPortFlowResistanceParameters(final
      computeFlowResistance=false, final linearizeFlowResistance=false);
  extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations;

  Modelica.SIunits.Temperature TWallAve "Average borehole temperature";

end PartialSingleBoreHole;
