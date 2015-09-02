within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.Interface;
partial model PartialSingleBoreHole "Single borehole heat exchanger"
//   replaceable package Medium =
//       Modelica.Media.Interfaces.PartialMedium "Medium in the component"
//       annotation (choicesAllMatching = true);
  extends PartialBoreHoleElement;
  extends PartialTWall;
   extends IDEAS.Fluid.Interfaces.PartialTwoPortInterface;
  //  (redeclare package
//       Medium =                                                                                   Medium);
  extends IDEAS.Fluid.Interfaces.TwoPortFlowResistanceParameters(
      computeFlowResistance=false, linearizeFlowResistance=false);
  extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations(T_start=gen.T_start);

  Modelica.SIunits.Temperature TWallAve "Average borehole temperature";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-70,84},{70,-76}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-62,-48},{62,-56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-62,62},{62,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-62,10},{62,4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,96},{46,-84}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-54,-84},{-46,96}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-72,84},{-62,-76}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{62,84},{72,-76}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward)}));
end PartialSingleBoreHole;
