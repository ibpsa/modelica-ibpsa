within IDEAS.Buildings.Validation.BaseClasses.Structure;
model Bui600 "BESTEST Building model case 600"

  extends IDEAS.Buildings.Validation.BaseClasses.Structure.BaseClasses.Bui(
    wall(AWall={21.6,16.2,9.6,16.2}),
    gF(nSurf=8));

  IDEAS.Buildings.Components.Window[2] win(
    final A={6,6},
    redeclare final parameter Data.Glazing.GlaBesTest glazing,
    final inc={IDEAS.Types.Tilt.Wall,IDEAS.Types.Tilt.Wall},
    azi={IDEAS.Types.Azimuth.S,IDEAS.Types.Azimuth.S},
    redeclare replaceable IDEAS.Buildings.Components.Shading.None shaType,
    redeclare final parameter IDEAS.Buildings.Data.Frames.None fraType,
    each frac=0)
    annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={11,-14})));
equation
  connect(win.propsBus_a, gF.propsBus[7:8]) annotation (Line(
      points={{9,-9},{9,28},{40,28}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
   annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-150,-100},
            {150,100}}),       graphics));
end Bui600;
