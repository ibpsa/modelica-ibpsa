within IDEAS.Buildings.Validation.BaseClasses.Structure;
model Bui195 "BESTEST Building model case 195"

  extends IDEAS.Interfaces.BaseClasses.Structure(
    nZones=1,
    ATrans=1,
    VZones={gF.V});

protected
  IDEAS.Buildings.Components.Zone gF(
    V=129.6,
    nSurf=6,
    n50=0,
    corrCV=0.822,
    linear=true,
    TOpStart=293.15)
                annotation (Placement(transformation(extent={{40,0},{80,40}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  IDEAS.Buildings.Components.OuterWall[4] wall(
    redeclare final parameter Data.Constructions.LightWall_195 constructionType,
    redeclare final parameter Data.Insulation.fiberglass insulationType,
    final azi={IDEAS.Constants.North,IDEAS.Constants.East,IDEAS.Constants.South,
        IDEAS.Constants.West},
    final insulationThickness={0.066,0.066,0.066,0.066},
    final inc={IDEAS.Constants.Wall,IDEAS.Constants.Wall,IDEAS.Constants.Wall,
        IDEAS.Constants.Wall},
    final AWall={21.6,16.2,21.6,16.2})
                               annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={-49,-14})));

  IDEAS.Buildings.Components.CommonWall floor(
    redeclare final parameter Data.Constructions.LightFloor constructionType,
    redeclare final parameter Data.Insulation.insulation insulationType,
    final TBou = 283.15,
    final insulationThickness=1.003,
    final AWall=48,
    final inc=IDEAS.Constants.Floor,
    final azi=IDEAS.Constants.South) annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={-19,-14})));
  IDEAS.Buildings.Components.OuterWall roof(
    redeclare final parameter Data.Constructions.LightRoof_195 constructionType,
    redeclare final parameter Data.Insulation.fiberglass insulationType,
    final insulationThickness=0.1118,
    final AWall=48,
    final inc=IDEAS.Constants.Ceiling,
    final azi=IDEAS.Constants.South) annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={-79,-14})));

equation
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
      points={{-73,-9},{-73,6.33333},{40,6.33333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(roof.surfCon_a, gF.surfCon[1]) annotation (Line(
      points={{-76,-9},{-76,12.3333},{40,12.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(wall.surfRad_a, gF.surfRad[2:5]) annotation (Line(
      points={{-43,-9},{-43,7},{40,7}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(wall.surfCon_a, gF.surfCon[2:5]) annotation (Line(
      points={{-46,-9},{-46,13},{40,13}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(floor.surfCon_a, gF.surfCon[6]) annotation (Line(
      points={{-16,-9},{-16,15.6667},{40,15.6667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(floor.surfRad_a, gF.surfRad[6]) annotation (Line(
      points={{-13,-9},{-13,9.66667},{40,9.66667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(floor.port_emb, heatPortEmb[1]) annotation (Line(
      points={{-9,-14},{-4,-14},{-4,-40},{118,-40},{118,60},{150,60}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(roof.propsBus_a, gF.propsBus[1]) annotation (Line(
      points={{-83,-9},{-83,31.3333},{40,31.3333}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(wall.propsBus_a, gF.propsBus[2:5]) annotation (Line(
      points={{-53,-9},{-53,30},{40,30}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(floor.propsBus_a, gF.propsBus[6]) annotation (Line(
      points={{-23,-9},{-23,24.6667},{40,24.6667}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(temperatureSensor.T, TSensor[1]) annotation (Line(
      points={{140,-60},{156,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-150,-100},
            {150,100}}),       graphics));
end Bui195;
