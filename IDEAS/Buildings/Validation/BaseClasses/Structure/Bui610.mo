within IDEAS.Buildings.Validation.BaseClasses.Structure;
model Bui610 "BESTEST Building model case 610"

extends IDEAS.Interfaces.Structure(nZones=1,ATrans=1,VZones={gF.V});

  IDEAS.Buildings.Components.Zone gF(nSurf=8, V=129.6)
    annotation (Placement(transformation(extent={{40,0},{80,40}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  IDEAS.Buildings.Components.OuterWall[4] wall(
      redeclare Data.Constructions.LightWall
        constructionType,
      redeclare Data.Insulation.fiberglass
        insulationType,
      AWall={21.6,16.2,9.6,16.2},
      azi={IDEAS.Constants.North,IDEAS.Constants.East,IDEAS.Constants.South,
          IDEAS.Constants.West},
      insulationThickness={0.066,0.066,0.066,0.066},
      inc={IDEAS.Constants.Wall,IDEAS.Constants.Wall,IDEAS.Constants.Wall,IDEAS.Constants.Wall})
                                               annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={-49,-14})));
  IDEAS.Buildings.Components.SlabOnGround floor(
      redeclare Data.Constructions.LightFloor
        constructionType,
      redeclare Data.Insulation.insulation
        insulationType,
      insulationThickness=1.003,
      AWall=48,
      PWall=0,
      inc=IDEAS.Constants.Floor,
      azi=IDEAS.Constants.South)                annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={-19,-14})));
  IDEAS.Buildings.Components.Window[2] win(
      A={6,6},
      redeclare Data.Glazing.GlaBesTest                         glazing,
      inc={IDEAS.Constants.Wall,IDEAS.Constants.Wall},
      azi={IDEAS.Constants.South,IDEAS.Constants.South},
    redeclare IDEAS.Buildings.Components.Shading.Overhang shaType(
      H=2.0,
      W=3.0,
      PH=1.0,
      RH=0.5,
      PV=0.0,
      RW=0.0))                             annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={11,-14})));
  IDEAS.Buildings.Components.OuterWall roof(
    redeclare Data.Constructions.LightRoof
      constructionType,
    redeclare Data.Insulation.fiberglass                         insulationType,
    insulationThickness=0.1118,
    AWall=48,
    inc=IDEAS.Constants.Ceiling,
    azi=IDEAS.Constants.South)              annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={-79,-14})));

equation
  connect(temperatureSensor.T, TSensor[1]) annotation (Line(
      points={{140,-60},{156,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gF.gainCon, temperatureSensor.port) annotation (Line(
      points={{80,14},{100,14},{100,-60},{120,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gF.gainCon, heatPortCon[1]) annotation (Line(
      points={{80,14},{120,14},{120,20},{150,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gF.gainRad, heatPortRad[1]) annotation (Line(
      points={{80,8},{120,8},{120,-20},{150,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(roof.surfRad_a, gF.surfRad[1]) annotation (Line(
      points={{-73,-9},{-73,6.25},{40,6.25}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(roof.surfCon_a, gF.surfCon[1]) annotation (Line(
      points={{-76,-9},{-76,12.25},{40,12.25}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(wall.surfRad_a, gF.surfRad[2:5]) annotation (Line(
      points={{-43,-9},{-43,6.75},{40,6.75}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(wall.surfCon_a, gF.surfCon[2:5]) annotation (Line(
      points={{-46,-9},{-46,12.75},{40,12.75}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(floor.surfCon_a, gF.surfCon[6]) annotation (Line(
      points={{-16,-9},{-16,14.75},{40,14.75}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(floor.surfRad_a, gF.surfRad[6]) annotation (Line(
      points={{-13,-9},{-13,8.75},{40,8.75}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(win.surfCon_a, gF.surfCon[7:8]) annotation (Line(
      points={{14,-9},{14,15.25},{40,15.25}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(win.surfRad_a, gF.surfRad[7:8]) annotation (Line(
      points={{17,-9},{17,9.25},{40,9.25}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(win[1].iSolDif, gF.iSolDir) annotation (Line(
      points={{21,-11},{56,-11},{56,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(win[1].iSolDir, gF.iSolDif) annotation (Line(
      points={{21,-14},{64,-14},{64,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(win[2].iSolDif, gF.iSolDir) annotation (Line(
      points={{21,-11},{56,-11},{56,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(win[2].iSolDir, gF.iSolDif) annotation (Line(
      points={{21,-14},{64,-14},{64,0}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(floor.port_emb, heatPortEmb[1]) annotation (Line(
        points={{-9,-14},{-4,-14},{-4,-40},{118,-40},{118,60},{150,60}},
        color={191,0,0},
        smooth=Smooth.None));
  connect(roof.area_a, gF.area[1]) annotation (Line(
      points={{-85,-8.4},{-85,30.25},{39.2,30.25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(roof.iEpsLw_a, gF.epsLw[1]) annotation (Line(
      points={{-82,-8.4},{-82,24.25},{39.2,24.25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(roof.iEpsSw_a, gF.epsSw[1]) annotation (Line(
      points={{-79,-8.4},{-79,18.25},{39.2,18.25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wall.area_a, gF.area[2:5]) annotation (Line(
      points={{-55,-8.4},{-55,30.75},{39.2,30.75}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wall.iEpsLw_a, gF.epsLw[2:5]) annotation (Line(
      points={{-52,-8.4},{-52,24.75},{39.2,24.75}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wall.iEpsSw_a, gF.epsSw[2:5]) annotation (Line(
      points={{-49,-8.4},{-49,18.75},{39.2,18.75}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(floor.area_a, gF.area[6]) annotation (Line(
      points={{-25,-8.4},{-25,32.75},{39.2,32.75}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(floor.iEpsLw_a, gF.epsLw[6]) annotation (Line(
      points={{-22,-8.4},{-22,26.75},{39.2,26.75}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(floor.iEpsSw_a, gF.epsSw[6]) annotation (Line(
      points={{-19,-8.4},{-19,20.75},{39.2,20.75}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(win.area_a, gF.area[7:8]) annotation (Line(
      points={{5,-8.4},{5,33.25},{39.2,33.25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(win.iEpsLw_a, gF.epsLw[7:8]) annotation (Line(
      points={{8,-8.4},{8,27.25},{39.2,27.25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(win.iEpsSw_a, gF.epsSw[7:8]) annotation (Line(
      points={{11,-8.4},{11,21.25},{39.2,21.25}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-150,-100},
            {150,100}}), graphics));
end Bui610;
