within IDEAS.Buildings.Validation.BaseClasses.Structure;
model Bui910 "BESTEST Building model case 910"

  extends IDEAS.Interfaces.BaseClasses.Structure(
    final nZones=1, final nEmb=0,
    ATrans=1,
    VZones={gF.V});

protected
  IDEAS.Buildings.Components.Zone gF(nSurf=8, V=129.6, n50=0.5*20)
    annotation (Placement(transformation(extent={{40,0},{80,40}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  IDEAS.Buildings.Components.OuterWall[4] wall(
    final AWall={21.6,16.2,9.6,16.2},
    final azi={IDEAS.Constants.North,IDEAS.Constants.East,IDEAS.Constants.South,
        IDEAS.Constants.West},
    final inc={IDEAS.Constants.Wall,IDEAS.Constants.Wall,IDEAS.Constants.Wall,
        IDEAS.Constants.Wall},
    redeclare final parameter Data.Constructions.HeavyWall constructionType,
    redeclare final parameter Data.Insulation.foaminsulation insulationType,
    final insulationThickness={0.0615,0.0615,0.0615,0.0615}) annotation (
      Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={-49,-14})));

  IDEAS.Buildings.Components.BoundaryWall floor(
    redeclare final parameter Data.Constructions.HeavyFloor constructionType,
    redeclare final parameter Data.Insulation.insulation insulationType,
    final insulationThickness=1.003,
    final AWall=48,
    final inc=IDEAS.Constants.Floor,
    final azi=IDEAS.Constants.South) annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={-19,-14})));
  IDEAS.Buildings.Components.Window[2] win(
    final A={6,6},
    redeclare final parameter Data.Glazing.GlaBesTest glazing,
    final inc={IDEAS.Constants.Wall,IDEAS.Constants.Wall},
    final azi={IDEAS.Constants.South,IDEAS.Constants.South},
    redeclare replaceable IDEAS.Buildings.Components.Shading.Overhang shaType(
      each hWin=2.0,
      each wWin=3.0,
      each dep=1.0,
      each gap=0.35,
      wLeft={0.5,4.5},
      wRight = {4.5,0.5}),
    redeclare final parameter IDEAS.Buildings.Data.Frames.None fraType,
    each frac = 0) annotation (Placement(
        transformation(
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

   connect(roof.propsBus_a, gF.propsBus[1]) annotation (Line(
      points={{-83,-9},{-83,31.5},{40,31.5}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(wall.propsBus_a, gF.propsBus[2:5]) annotation (Line(
      points={{-53,-9},{-53,27.5},{40,27.5}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(floor.propsBus_a, gF.propsBus[6]) annotation (Line(
      points={{-23,-9},{-23,26.5},{40,26.5}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(win.propsBus_a, gF.propsBus[7:8]) annotation (Line(
      points={{7,-9},{7,24.5},{40,24.5}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));

  connect(flowPort_Out[1], gF.flowPort_Out) annotation (Line(
      points={{-20,100},{-20,60},{56,60},{56,40}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(flowPort_In[1], gF.flowPort_In) annotation (Line(
      points={{20,100},{20,64},{64,64},{64,40}},
      color={0,0,0},
      smooth=Smooth.None));
   annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-150,
            -100},{150,100}}), graphics));
end Bui910;
