within IDEAS.Buildings.Components.Comfort.BaseClasses;
partial model PartialComfort "Partial for comfort models"
  extends Modelica.Blocks.Icons.Block;

  Modelica.Blocks.Interfaces.RealInput phi(min=0, max=1) "Relative humidity"
    annotation (
      Placement(transformation(extent={{-120,10},{-100,30}}),
        iconTransformation(extent={{-120,10},{-100,30}})));
  Modelica.Blocks.Interfaces.RealInput TRad(final quantity="ThermodynamicTemperature",
                                          final unit = "K", displayUnit = "degC")
    "Radiation temperature"
    annotation (
      Placement(transformation(extent={{-120,50},{-100,70}}),
        iconTransformation(extent={{-120,50},{-100,70}})));
  Modelica.Blocks.Interfaces.RealInput TAir(final quantity="ThermodynamicTemperature",
                                          final unit = "K", displayUnit = "degC")
    "Air temperature"
    annotation (Placement(
        transformation(extent={{-120,90},{-100,110}})));
  replaceable parameter
    IDEAS.Buildings.Components.OccupancyType.PartialOccupancyType occupancyType
    constrainedby IDEAS.Buildings.Components.OccupancyType.PartialOccupancyType
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
July 18, 2016 by Filip Jorissen:<br/>
First implementation
</li>
</ul>
</html>"));
end PartialComfort;
