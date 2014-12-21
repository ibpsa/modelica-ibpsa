within IDEAS.Electric.Photovoltaics.Components;
class PvVoltageToPower

  extends Modelica.Blocks.Interfaces.BlockIcon;

  Modelica.Electrical.Analog.Interfaces.Pin pin
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Modelica.Blocks.Interfaces.RealOutput P
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Modelica.Blocks.Interfaces.RealOutput Q
    annotation (Placement(transformation(extent={{90,10},{110,30}})));
equation
  P = pin.v*pin.i;
  Q = 0;
  annotation (Diagram(graphics));
end PvVoltageToPower;
