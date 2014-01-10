within IDEAS.Buildings.Components.Interfaces;
partial model StateWall "Partial model for building envelope components"

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a surfCon_a
    "Convective surface node"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b surfRad_a
    "Radiative surface node"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  outer IDEAS.SimInfoManager sim
    "Simulation information manager for climate data"
    annotation (Placement(transformation(extent={{30,-100},{50,-80}})));
  PropsBus propsBus_a annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={50,40}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={50,40})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-50,-100},{50,100}}), graphics));

end StateWall;
