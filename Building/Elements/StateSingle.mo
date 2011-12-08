within IDEAS.Building.Elements;
class StateSingle

parameter Modelica.SIunits.Temperature T0=289.15 "initial temperature";
Modelica.SIunits.Temperature T(start=T0) "initial temperature";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
equation
T = port_a.T;

end StateSingle;
