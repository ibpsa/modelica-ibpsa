within IDEAS.Interfaces;
model Building

  outer IDEAS.Climate.SimInfoManager
                       sim
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  replaceable IDEAS.Interfaces.Structure building "Building structure"
    annotation (Placement(transformation(extent={{-66,-10},{-36,10}})),choicesAllMatching = true);
  replaceable IDEAS.Interfaces.HeatingSystem heatingSystem(nZones=building.nZones)
    "Thermal heating system"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})),choicesAllMatching = true);
  replaceable IDEAS.Interfaces.Occupant occupant(nZones=building.nZones)
    "Building occupant"
    annotation (Placement(transformation(extent={{-20,-42},{0,-22}})),choicesAllMatching = true);
  replaceable IDEAS.Interfaces.InhomeFeeder inhomeGrid(nHeatingLoads=heatingSystem.nLoads, nOccupantLoads=occupant.nLoads, nVentilationLoads=ventilationSystem.nLoads)
    "Inhome electricity grid system"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})),choicesAllMatching = true);
  replaceable IDEAS.Interfaces.VentilationSystem ventilationSystem(nZones=building.nZones)
    "Ventilation system"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})),choicesAllMatching = true);
  Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug plugFeeder
    "Electricity connection to the district feeder"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

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
  connect(ventilationSystem.pinLoad, inhomeGrid.pinVentilationLoad) annotation (Line(
      points={{0,30},{8,30},{8,0},{20,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(heatingSystem.pinLoad, inhomeGrid.pinHeatingLoad) annotation (Line(
      points={{0,0},{6,0},{6,4},{20,4}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(occupant.pinLoad, inhomeGrid.pinOccupantLoad) annotation (Line(
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
          points={{60,22},{0,74},{-60,24},{-60,-46},{60,-46}},
          color={127,0,0},
          smooth=Smooth.None), Polygon(
          points={{60,22},{56,18},{0,64},{-54,20},{-54,-40},{60,-40},{60,-46},{
              -60,-46},{-60,24},{0,74},{60,22}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-46,6},{-46,-6},{-44,-8},{-24,4},{-24,16},{-26,18},{-46,6}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-46,-18},{-46,-30},{-44,-32},{-24,-20},{-24,-8},{-26,-6},{
              -46,-18}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-44,-4},{-50,-8},{-50,-32},{-46,-36},{28,-36},{42,-26}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{-50,-32},{-44,-28}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{-24,14},{-20,16},{-20,-18},{-16,-22},{-16,-22},{40,-22}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{-24,-10},{-20,-8}},
          color={127,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{40,-12},{40,-32},{50,-38},{58,-32},{58,-16},{54,-10},{48,-6},
              {40,-12}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,-60},{100,-100}},
          lineColor={85,0,0},
          textString="%name")}),                                    Diagram(
        graphics));
end Building;
