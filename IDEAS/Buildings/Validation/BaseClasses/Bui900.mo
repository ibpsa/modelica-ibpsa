within IDEAS.Buildings.Validation.BaseClasses;
model Bui900 "Building mdoel for Case 900 and following"

extends IDEAS.Interfaces.Structure(nZones=1,ATrans=1,VZones={gF.V});

  IDEAS.Buildings.Components.Zone gF(nSurf=8, V=129.6)
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  IDEAS.Buildings.Components.OuterWall[4] wall(
      AWall={21.6,16.2,9.6,16.2},
      azi={IDEAS.Constants.North,IDEAS.Constants.East,IDEAS.Constants.South,
          IDEAS.Constants.West},
      inc={IDEAS.Constants.Wall,IDEAS.Constants.Wall,IDEAS.Constants.Wall,IDEAS.Constants.Wall},
      redeclare Data.Constructions.HeavyWall
        constructionType,
      redeclare Data.Insulation.foaminsulation
        insulationType,
      insulationThickness={0.0615,0.0615,0.0615,0.0615})
                                               annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={-49,-14})));

  IDEAS.Buildings.Components.SlabOnGround floor(
      redeclare Data.Insulation.insulation
        insulationType,
      AWall=48,
      PWall=0,
      inc=IDEAS.Constants.Floor,
      azi=IDEAS.Constants.South,
      redeclare Data.Constructions.HeavyFloor
        constructionType,
      insulationThickness=1.007)                annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={-19,-14})));
  IDEAS.Buildings.Components.Window[2] win(
      A={6,6},
      redeclare Data.Glazing.GlaBesTest                         glazing,
      inc={IDEAS.Constants.Wall,IDEAS.Constants.Wall},
      azi={IDEAS.Constants.South,IDEAS.Constants.South})
                                           annotation (Placement(transformation(
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
      points={{80,7},{100,7},{100,-60},{120,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gF.gainCon, heatPortCon[1]) annotation (Line(
      points={{80,7},{120,7},{120,20},{150,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gF.gainRad, heatPortRad[1]) annotation (Line(
      points={{80,4},{120,4},{120,-20},{150,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(roof.surfRad_a, gF.surfRad[1]) annotation (Line(
      points={{-73,-9},{-73,3.125},{60,3.125}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(roof.surfCon_a, gF.surfCon[1]) annotation (Line(
      points={{-76,-9},{-76,6.125},{60,6.125}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(wall.surfRad_a, gF.surfRad[2:5]) annotation (Line(
      points={{-43,-9},{-43,3.375},{60,3.375}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(wall.surfCon_a, gF.surfCon[2:5]) annotation (Line(
      points={{-46,-9},{-46,6.375},{60,6.375}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(floor.surfCon_a, gF.surfCon[6]) annotation (Line(
      points={{-16,-9},{-16,7.375},{60,7.375}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(floor.surfRad_a, gF.surfRad[6]) annotation (Line(
      points={{-13,-9},{-13,4.375},{60,4.375}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(win.surfCon_a, gF.surfCon[7:8]) annotation (Line(
      points={{14,-9},{14,7.625},{60,7.625}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(win.surfRad_a, gF.surfRad[7:8]) annotation (Line(
      points={{17,-9},{17,4.625},{60,4.625}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(win[1].iSolDif, gF.iSolDir) annotation (Line(
      points={{21,-11},{68,-11},{68,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(win[1].iSolDir, gF.iSolDif) annotation (Line(
      points={{21,-14},{72,-14},{72,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(win[2].iSolDif, gF.iSolDir) annotation (Line(
      points={{21,-11},{68,-11},{68,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(win[2].iSolDir, gF.iSolDif) annotation (Line(
      points={{21,-14},{72,-14},{72,0}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(floor.port_emb, heatPortEmb[1]) annotation (Line(
        points={{-9,-14},{-4,-14},{-4,-40},{118,-40},{118,60},{150,60}},
        color={191,0,0},
        smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-150,-100},
              {150,100}}),
                         graphics));
end Bui900;
