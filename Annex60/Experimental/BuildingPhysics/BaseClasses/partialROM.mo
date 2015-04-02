within Annex60.Experimental.BuildingPhysics.BaseClasses;
partial model partialROM "defines structure of Reduced Order Models"

  parameter Modelica.SIunits.Volume VAir=52.5 "Air Volume of the zone";
  package Medium = Annex60.Media.Air;
  parameter Integer nPorts=0 "Number of ports"
    annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));

  Fluid.MixingVolumes.MixingVolume volAir(m_flow_nominal=0.00001, V=VAir,
    redeclare package Medium = Medium,
    nPorts=nPorts)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports[nPorts](
    redeclare package Medium = Medium) annotation (
      Placement(transformation(
        extent={{-45,-12},{45,12}},
        rotation=0,
        origin={-1,-94}), iconTransformation(
        extent={{-30.5,-8},{30.5,8}},
        rotation=0,
        origin={0,-91.5})));
equation
  connect(volAir.ports, ports) annotation (Line(
      points={{0,-10},{0,-52},{0,-94},{-1,-94}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-100},{100,100}}), graphics));
end partialROM;
