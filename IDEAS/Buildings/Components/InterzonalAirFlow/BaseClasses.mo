within IDEAS.Buildings.Components.InterzonalAirFlow;
package BaseClasses "Base classes"
  extends Modelica.Icons.BasesPackage;
  partial model PartialInterzonalAirFlow "Partial for interzonal air flow"
    replaceable package Medium = IDEAS.Media.Air "Air medium";
    parameter Integer nPorts "Number of ports for connection to zone air volume";

    Modelica.Fluid.Interfaces.FluidPort_b port_b_interior(
      redeclare package Medium = Medium)
      "Port a connection to zone air model ports"
      annotation (Placement(transformation(extent={{50,-110},{70,-90}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_a_interior(
      redeclare package Medium = Medium)
      "Port b connection to zone air model ports"
      annotation (Placement(transformation(extent={{-70,-110},{-50,-90}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_a_exterior(
      redeclare package Medium = Medium)
      "Port a connection to model exterior ports"
      annotation (Placement(transformation(extent={{10,90},{30,110}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_b_exterior(
      redeclare package Medium = Medium)
      "Port b connection to model exterior ports"
      annotation (Placement(transformation(extent={{-30,90},{-10,110}})));
    Modelica.Fluid.Interfaces.FluidPorts_a[nPorts] ports(
      redeclare each package Medium = Medium) "Ports connector for multiple ports" annotation (Placement(
          transformation(
          extent={{-10,-40},{10,40}},
          rotation=90,
          origin={2,-100})));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end PartialInterzonalAirFlow;
end BaseClasses;
