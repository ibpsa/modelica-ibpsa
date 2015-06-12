within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.Interface;
partial model PartialSingleBoreHole "Single borehole heat exchanger"
//   replaceable package Medium =
//       Modelica.Media.Interfaces.PartialMedium "Medium in the component"
//       annotation (choicesAllMatching = true);
  extends PartialBoreHoleElement;
   extends IDEAS.Fluid.Interfaces.PartialTwoPortInterface;
  //  (redeclare package
//       Medium =                                                                                   Medium);
  extends IDEAS.Fluid.Interfaces.TwoPortFlowResistanceParameters(
      computeFlowResistance=false, linearizeFlowResistance=false);
  extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations;

  Modelica.SIunits.Temperature TWallAve "Average borehole temperature";
end PartialSingleBoreHole;
