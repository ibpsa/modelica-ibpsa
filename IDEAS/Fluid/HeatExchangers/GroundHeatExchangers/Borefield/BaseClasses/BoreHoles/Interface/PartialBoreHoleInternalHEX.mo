within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.Interface;
partial model PartialBoreHoleInternalHEX
  extends PartialBoreHoleElement;

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
                              annotation (choicesAllMatching=true);
  parameter Boolean dynFil = true
    "Set to false to remove the dynamics of the filling material."                               annotation (Dialog(tab="Dynamics"));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port
    "Heat port that connects to filling material" annotation (Placement(
        transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={
            {-10,90},{10,110}})));
  parameter Real scaSeg = 1
    "scaling factor used by Borefield.MultipleBoreHoles to represent the whole borefield by one single segment"
                                                                                                        annotation (Dialog(group="Advanced"));
  annotation (Diagram(coordinateSystem(extent={{-100,-120},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-120},{100,100}})));
end PartialBoreHoleInternalHEX;
