within IDEAS.Interfaces;
partial model Building

  outer IDEAS.Climate.SimInfoManager
                       sim
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  replaceable IDEAS.Thermal.Interfaces.HeatingSystem heatingSystem(nZones=building.nZones)
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  replaceable IDEAS.Occupants.Interfaces.Occupant occupant(nZones=building.nZones)
    annotation (Placement(transformation(extent={{-20,-42},{0,-22}})));
  replaceable IDEAS.Electric.Interfaces.InhomeFeeder inhomeGrid(nLoads=heatingSystem.nLoads+occupant.nLoads+ventilationSystem.nLoads)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  replaceable IDEAS.Thermal.Interfaces.VentilationSystem ventilationSystem(nZones=building.nZones)
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug Plug
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  replaceable Buildings.Interfaces.Building building
    annotation (Placement(transformation(extent={{-66,-10},{-36,10}})));
equation
  connect(inhomeGrid.PlugFeeder, Plug) annotation (Line(
      points={{40,0},{100,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(heatingSystem.TAsked, occupant.TAsked) annotation (Line(
      points={{-10,-9},{-10,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ventilationSystem.plug, inhomeGrid.plug_loads) annotation (Line(
      points={{0,30},{8,30},{8,0},{20,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(heatingSystem.plug, inhomeGrid.plug_loads) annotation (Line(
      points={{0,0},{20,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(occupant.plug, inhomeGrid.plug_loads) annotation (Line(
      points={{0,-32},{8,-32},{8,0},{20,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(building.genEmb, heatingSystem.port_emb) annotation (Line(
      points={{-41,6},{-20,6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(building.gainCon, heatingSystem.port_con) annotation (Line(
      points={{-41,2},{-20,2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(building.gainRad, heatingSystem.port_rad) annotation (Line(
      points={{-41,-2},{-20,-2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(building.TSensor, heatingSystem.TSensor) annotation (Line(
      points={{-35.4,-6},{-30,-6},{-30,-6},{-19.6,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(building.gainCon, ventilationSystem.conv) annotation (Line(
      points={{-41,2},{-26,2},{-26,30},{-20,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(building.gainCon, occupant.port_con) annotation (Line(
      points={{-41,2},{-26,2},{-26,-30},{-20,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(building.gainRad, occupant.port_rad) annotation (Line(
      points={{-41,-2},{-28,-2},{-28,-34},{-20,-34}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation(Icon(graphics={Line(
          points={{60,8},{0,60},{-60,10},{-60,-60},{60,-60}},
          color={127,0,0},
          smooth=Smooth.None), Polygon(
          points={{60,8},{56,4},{0,50},{-54,6},{-54,-54},{60,-54},{60,-60},{-60,
              -60},{-60,10},{0,60},{60,8}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-46,-8},{-46,-20},{-44,-22},{-24,-10},{-24,2},{-26,4},{-46,-8}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-46,-32},{-46,-44},{-44,-46},{-24,-34},{-24,-22},{-26,-20},{-46,
              -32}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-44,-18},{-50,-22},{-50,-46},{-46,-50},{28,-50},{42,-40}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{-50,-46},{-44,-42}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{-24,0},{-20,2},{-20,-32},{-16,-36},{-16,-36},{40,-36}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{-24,-24},{-20,-22}},
          color={127,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{40,-26},{40,-46},{50,-52},{58,-46},{58,-30},{54,-24},{48,-20},
              {40,-26}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid)}),                         Diagram(
        graphics));
end Building;
