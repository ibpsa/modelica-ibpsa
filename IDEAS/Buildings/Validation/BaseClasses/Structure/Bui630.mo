within IDEAS.Buildings.Validation.BaseClasses.Structure;
model Bui630 "BESTEST Building model case 630"

  extends IDEAS.Interfaces.BaseClasses.Structure(
    nZones=1,
    ATrans=1,
    VZones={gF.V});

protected
  IDEAS.Buildings.Components.Zone gF(
    nSurf=8,
    V=129.6,
    n50=0.822*0.5*20,
    corrCV=0.822,
    TOpStart=293.15,
    linear=true)
    annotation (Placement(transformation(extent={{40,0},{80,40}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  IDEAS.Buildings.Components.OuterWall[4] wall(
    redeclare final parameter Data.Constructions.LightWall constructionType,
    redeclare final parameter Data.Insulation.fiberglass insulationType,
    final azi={IDEAS.Constants.North,IDEAS.Constants.East,IDEAS.Constants.South,
        IDEAS.Constants.West},
    final insulationThickness={0.066,0.066,0.066,0.066},
    final inc={IDEAS.Constants.Wall,IDEAS.Constants.Wall,IDEAS.Constants.Wall,
        IDEAS.Constants.Wall},
    final AWall={21.6,10.2,21.6,10.2}) annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={-49,-14})));

  IDEAS.Buildings.Components.CommonWall floor(
    redeclare final parameter Data.Constructions.LightFloor constructionType,
    redeclare final parameter Data.Insulation.insulation insulationType,
    final insulationThickness=1.003,
    final AWall=48,
    final inc=IDEAS.Constants.Floor,
    final azi=IDEAS.Constants.South,
    final TBou = 283.15) annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={-19,-14})));
  IDEAS.Buildings.Components.Window[2] win(
    final A={6,6},
    redeclare final parameter Data.Glazing.GlaBesTest glazing,
    final inc={IDEAS.Constants.Wall,IDEAS.Constants.Wall},
    final azi={IDEAS.Constants.East,IDEAS.Constants.West},
    redeclare replaceable IDEAS.Buildings.Components.Shading.Box shaType(
      each hWin=2.0,
      each wWin=3.0,
      each wLeft=0,
      each wRight = 0,
      each ovDep=1.0,
      each ovGap=0.35,
      each finGap = 0,
      each finDep=1.0,
      each hFin=0.35),
    redeclare final parameter IDEAS.Buildings.Data.Frames.None fraType,
    final frac = 0)
    annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={11,-14})));
  IDEAS.Buildings.Components.OuterWall roof(
    redeclare final parameter Data.Constructions.LightRoof constructionType,
    redeclare final parameter Data.Insulation.fiberglass insulationType,
    final insulationThickness=0.1118,
    final AWall=48,
    final inc=IDEAS.Constants.Ceiling,
    final azi=IDEAS.Constants.South) annotation (Placement(transformation(
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

   connect(roof.propsBus_a, gF.propsBus[1]) annotation (Line(
      points={{-83,-9},{-83,31.5},{40,31.5}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(wall.propsBus_a, gF.propsBus[2:5]) annotation (Line(
      points={{-53,-9},{-53,30.5},{40,30.5}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(floor.propsBus_a, gF.propsBus[6]) annotation (Line(
      points={{-23,-9},{-23,26.5},{40,26.5}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(win.propsBus_a, gF.propsBus[7:8]) annotation (Line(
      points={{7,-9},{7,25.5},{40,25.5}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-150,
            -100},{150,100}}), graphics));
end Bui630;
