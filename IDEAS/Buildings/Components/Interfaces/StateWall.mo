within IDEAS.Buildings.Components.Interfaces;
partial model StateWall "Partial model for building envelope components"

  ZoneBus propsBus_a(numAng=incidenceAngles.numAng)
                     annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={50,40}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={50,40})));
  inner IncidenceAngles incidenceAngles(
    offset=sim.incidenceAngles.offset,
    numAng=sim.incidenceAngles.numAng,
    lat=sim.incidenceAngles.lat)
    annotation (Placement(transformation(extent={{-100,82},{-80,102}})));
  outer SimInfoManager       sim
    annotation (Placement(transformation(extent={{-60,78},{-40,98}})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-50,-100},{50,100}}), graphics));

end StateWall;
