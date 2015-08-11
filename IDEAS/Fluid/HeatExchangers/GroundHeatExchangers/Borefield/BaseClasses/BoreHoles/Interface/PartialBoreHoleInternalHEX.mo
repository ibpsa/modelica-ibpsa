within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.Interface;
partial model PartialBoreHoleInternalHEX
  extends PartialBoreHoleElement;

  parameter Modelica.SIunits.Temperature T_start
    "Initial temperature of the filling material"
    annotation (Dialog(group="Filling material"));
  parameter Real mSenFac=1
    "Factor for scaling the sensible thermal mass of the volume"
    annotation (Dialog(group="Advanced"));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port
    "Heat port that connects to filling material" annotation (Placement(
        transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={
            {-10,90},{10,110}})));

  annotation (Diagram(coordinateSystem(extent={{-100,-120},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-120},{100,100}})));
end PartialBoreHoleInternalHEX;
