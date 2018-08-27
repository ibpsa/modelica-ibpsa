within IDEAS.Buildings.Components.LightControl.BaseClasses;
partial block PartialLights
  "Partial for defining the lighting control"
  extends Modelica.Blocks.Icons.Block;
  parameter Boolean useCtrlInput= false "=true to use control external input";
  parameter Boolean useOccInput= false "=true to use occupancy light control";
  Modelica.Blocks.Interfaces.RealOutput ctrl "Number of occupants"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Modelica.Blocks.Interfaces.RealInput lightCtrl if
                                                 useCtrlInput
    "Input for lighting control" annotation (
      Placement(transformation(extent={{-140,-40},{-100,0}})));
  Modelica.Blocks.Interfaces.RealInput lightOcc if
                                                 useOccInput
    "Input for lighting control" annotation (
      Placement(transformation(extent={{-140,0},{-100,40}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
July 26, 2018 by Filip Jorissen:<br/>
First implementation
See <a href=\"https://github.com/open-ideas/IDEAS/issues/760\">#760</a>.
</li>
</ul>
</html>"));
end PartialLights;
