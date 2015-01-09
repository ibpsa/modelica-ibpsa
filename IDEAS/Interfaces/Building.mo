within IDEAS.Interfaces;
model Building

  outer IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  parameter Boolean standAlone=true;

  final parameter Modelica.SIunits.Temperature[building.nZones] T_start = ones(building.nZones)*293.15
    "Operative zonal start temperatures";

  replaceable IDEAS.Interfaces.BaseClasses.Structure building(final T_start=T_start)
    "Building structure" annotation (Placement(transformation(extent={{-66,-10},
            {-36,10}})), choicesAllMatching=true);
  replaceable IDEAS.Interfaces.BaseClasses.HeatingSystem heatingSystem(
    nZones=building.nZones,
    VZones=building.VZones,
    final T_start=T_start,
    final nEmbPorts=building.nEmb) "Thermal building heating system" annotation (Placement(
        transformation(extent={{-20,-10},{20,10}})), choicesAllMatching=true);
  replaceable IDEAS.Interfaces.BaseClasses.Occupant occupant(nZones=building.nZones)
    constrainedby IDEAS.Interfaces.BaseClasses.Occupant(nZones=building.nZones)
    "Building occupant" annotation (Placement(transformation(extent={{-10,-42},
            {10,-22}})), choicesAllMatching=true);
  replaceable IDEAS.Interfaces.BaseClasses.CausalInhomeFeeder inHomeGrid constrainedby
    IDEAS.Interfaces.BaseClasses.CausalInhomeFeeder
    "Inhome low-voltage electricity grid system" annotation (Placement(
        transformation(extent={{32,-10},{52,10}})), __Dymola_choicesAllMatching=true);

  replaceable IDEAS.Interfaces.BaseClasses.VentilationSystem ventilationSystem(
      nZones=building.nZones, VZones=building.VZones) "Ventilation system"
    annotation (Placement(transformation(extent={{-12,20},{8,40}})),
      choicesAllMatching=true);
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin
    plugFeeder(v(re(start=230), im(start=0))) if not standAlone
    "Electricity connection to the district feeder"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource
    voltageSource(
    f=50,
    V=230,
    phi=0) if standAlone annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,-30})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground if
    standAlone
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));

equation
  connect(heatingSystem.TSet, occupant.TSet) annotation (Line(
      points={{0,-10.4},{0,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(building.heatPortEmb, heatingSystem.heatPortEmb) annotation (Line(
      points={{-36,6},{-20,6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(building.heatPortCon, heatingSystem.heatPortCon) annotation (Line(
      points={{-36,2},{-20,2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(building.heatPortCon, occupant.heatPortCon) annotation (Line(
      points={{-36,2},{-26,2},{-26,-30},{-10,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(building.heatPortRad, heatingSystem.heatPortRad) annotation (Line(
      points={{-36,-2},{-20,-2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(building.heatPortRad, occupant.heatPortRad) annotation (Line(
      points={{-36,-2},{-28,-2},{-28,-34},{-10,-34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(building.TSensor, heatingSystem.TSensor) annotation (Line(
      points={{-35.4,-6},{-20.4,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(building.TSensor, ventilationSystem.TSensor) annotation (Line(
      points={{-35.4,-6},{-30,-6},{-30,24},{-12.2,24}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(ventilationSystem.plugLoad, inHomeGrid.nodeSingle) annotation (Line(
      points={{8,30},{26,30},{26,0},{32,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(heatingSystem.plugLoad, inHomeGrid.nodeSingle) annotation (Line(
      points={{20,0},{32,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(occupant.plugLoad, inHomeGrid.nodeSingle) annotation (Line(
      points={{10,-32},{26,-32},{26,0},{32,0}},
      color={85,170,255},
      smooth=Smooth.None));

  if standAlone then
    connect(voltageSource.pin_p, ground.pin) annotation (Line(
        points={{70,-40},{70,-60}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(inHomeGrid.pinSingle, voltageSource.pin_n) annotation (Line(
        points={{52,0},{70,0},{70,-20}},
        color={85,170,255},
        smooth=Smooth.None));
  else
    connect(inHomeGrid.pinSingle, plugFeeder) annotation (Line(
        points={{52,0},{100,0}},
        color={85,170,255},
        smooth=Smooth.None));
  end if;

  connect(heatingSystem.mDHW60C, occupant.mDHW60C) annotation (Line(
      points={{6,-10.4},{6,-22},{3,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ventilationSystem.flowPort_In, building.flowPort_Out) annotation (
      Line(
      points={{-12,32},{-54,32},{-54,30},{-53,30},{-53,10}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ventilationSystem.flowPort_Out, building.flowPort_In) annotation (
      Line(
      points={{-12,28},{-49,28},{-49,10}},
      color={0,0,0},
      smooth=Smooth.None));
  annotation (Icon(graphics={
        Line(
          points={{60,22},{0,74},{-60,24},{-60,-46},{60,-46}},
          color={127,0,0},
          smooth=Smooth.None),
        Polygon(
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
          points={{-46,-18},{-46,-30},{-44,-32},{-24,-20},{-24,-8},{-26,-6},{-46,
              -18}},
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
          lineColor={127,0,0},
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false,
                   extent={{-100,-100},{100,100}}), graphics));
end Building;
