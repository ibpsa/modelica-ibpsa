within IDEAS.Buildings.Components.Interfaces;
partial model StateWall "Partial model for building envelope components"

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a surfCon_a
    "Convective surface node" annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b surfRad_a
    "Radiative surface node" annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Modelica.Blocks.Interfaces.RealOutput iEpsLw_a
    "Longwave emissivity for radiative heat losses" annotation (Placement(transformation(extent={{46,20},{66,40}})));
  Modelica.Blocks.Interfaces.RealOutput iEpsSw_a
    "Shortwave emissivity for solar gain distribution" annotation (Placement(transformation(extent={{46,-10},{66,10}})));
  Modelica.Blocks.Interfaces.RealOutput area_a
    "Total interior surface area of the wall" annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={56,60})));
  outer Climate.SimInfoManager sim
    "Simulation information manager for climate data" annotation (Placement(transformation(extent={{30,-100},{50,-80}})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),
                      graphics),
              Diagram(graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-50,-100},{50,100}}),
                                      graphics));

end StateWall;
