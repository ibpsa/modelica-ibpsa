within IDEAS.Building.Elements;
partial model StateDouble

  Modelica.SIunits.TemperatureDifference dT;

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a(T(start=289.15))
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b(T(start=289.15))
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation
dT = port_a.T-port_b.T;

end StateDouble;
