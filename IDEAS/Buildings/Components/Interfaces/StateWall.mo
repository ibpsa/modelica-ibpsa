within IDEAS.Buildings.Components.Interfaces;
partial model StateWall

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a surfCon_a
    "convective nod on the inside"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b surfRad_a
    "rad.node on the inside"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Modelica.Blocks.Interfaces.RealOutput iEpsLw_a
    annotation (Placement(transformation(extent={{46,20},{66,40}})));
  Modelica.Blocks.Interfaces.RealOutput iEpsSw_a
    "output of the interior emissivity for radiative heat losses"
    annotation (Placement(transformation(extent={{46,-10},{66,10}})));

  Modelica.Blocks.Interfaces.RealOutput area_a "output of the area"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={56,60})));
outer Climate.SimInfoManager
                           sim "Simulation information manager"
    annotation (Placement(transformation(extent={{30,-100},{50,-80}})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-50,
            -100},{50,100}}),
                      graphics),
              Diagram(graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-50,-100},{50,100}}),
                                      graphics={Rectangle(extent={{-50,100},{50,
              -100}}, lineColor={127,0,0})}));
end StateWall;
