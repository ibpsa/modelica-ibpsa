within IDEAS.Interfaces;
model Building

  outer IDEAS.Climate.SimInfoManager
                       sim
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  replaceable parameter IDEAS.Interfaces.HeatingSystem heatingSystem(nZones=building.nZones)
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})),choicesAllMatching = true);
  replaceable parameter IDEAS.Interfaces.Occupant occupant(nZones=building.nZones)
    annotation (Placement(transformation(extent={{-20,-42},{0,-22}})),choicesAllMatching = true);
  replaceable parameter IDEAS.Interfaces.InhomeFeeder inhomeGrid(nHeatingLoads=heatingSystem.nLoads, nOccupantLoads=occupant.nLoads, nVentilationLoads=ventilationSystem.nLoads)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})),choicesAllMatching = true);
  replaceable parameter IDEAS.Interfaces.VentilationSystem ventilationSystem(nZones=building.nZones)
    annotation (Placement(transformation(extent={{-20,20},{0,40}})),choicesAllMatching = true);
  Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug         plugFeeder
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  replaceable parameter IDEAS.Interfaces.Structure building
    annotation (Placement(transformation(extent={{-66,-10},{-36,10}})),choicesAllMatching = true);
equation
  connect(inhomeGrid.plugFeeder, plugFeeder)
                                        annotation (Line(
      points={{40,0},{100,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(heatingSystem.TSet, occupant.TSet) annotation (Line(
      points={{-10,-9},{-10,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ventilationSystem.plugLoad, inhomeGrid.plugVentilationLoad) annotation (Line(
      points={{0,30},{8,30},{8,0},{20,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(heatingSystem.plugLoad, inhomeGrid.plugHeatingLoad) annotation (Line(
      points={{0,0},{10,0},{10,4},{20,4}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(occupant.plugLoad, inhomeGrid.plugOccupantLoad) annotation (Line(
      points={{0,-32},{8,-32},{8,-4},{20,-4}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(building.heatPortEmb, heatingSystem.heatPortEmb) annotation (Line(
      points={{-36,6},{-20,6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(building.heatPortCon, heatingSystem.heatPortCon) annotation (Line(
      points={{-36,2},{-20,2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(building.heatPortRad, heatingSystem.heatPortRad) annotation (Line(
      points={{-36,-2},{-20,-2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(building.TSensor, heatingSystem.TSensor) annotation (Line(
      points={{-35.4,-6},{-30,-6},{-30,-6},{-19.6,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(building.heatPortCon, ventilationSystem.heatPortCon) annotation (Line(
      points={{-36,2},{-26,2},{-26,30},{-20,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(building.heatPortCon, occupant.heatPortCon) annotation (Line(
      points={{-36,2},{-26,2},{-26,-30},{-20,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(building.heatPortRad, occupant.heatPortRad) annotation (Line(
      points={{-36,-2},{-28,-2},{-28,-34},{-20,-34}},
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
