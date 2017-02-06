within IDEAS.Buildings.Components.Shading;
model Shading
  "Model that allows to select any shading option based on record"
  extends IDEAS.Buildings.Components.Shading.Interfaces.PartialShading(controlled=shaPro.controlled);
  replaceable parameter IDEAS.Buildings.Components.Shading.Interfaces.ShadingProperties shaPro
    constrainedby
    IDEAS.Buildings.Components.Shading.Interfaces.ShadingProperties
    "Shading properties"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
protected
  IDEAS.Buildings.Components.Shading.Box box(
    azi=azi,
    hWin=shaPro.hWin,
    wWin=shaPro.wWin,
    wLeft=shaPro.wLeft,
    wRight=shaPro.wRight,
    ovDep=shaPro.ovDep,
    ovGap=shaPro.ovGap,
    hFin=shaPro.hFin,
    finDep=shaPro.finDep,
    finGap=shaPro.finGap) if
    shaPro.shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.Box
    "Box shading model"                                                           annotation (Placement(transformation(extent={{-16,80},{-6,100}})));
  IDEAS.Buildings.Components.Shading.BuildingShade buildingShade(
    L=shaPro.L,
    dh=shaPro.dh,
    hWin=shaPro.hWin,
    azi=azi) if
    shaPro.shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.BuildingShade
    "Building shade model"
    annotation (Placement(transformation(extent={{-16,60},{-6,80}})));
  IDEAS.Buildings.Components.Shading.Overhang overhang(
    hWin=shaPro.hWin,
    wWin=shaPro.wWin,
    wLeft=shaPro.wLeft,
    wRight=shaPro.wRight,
    dep=shaPro.ovDep,
    gap=shaPro.ovGap,
    azi=azi) if
    shaPro.shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.Overhang
    "Overhang model"
    annotation (Placement(transformation(extent={{-16,40},{-6,60}})));
  IDEAS.Buildings.Components.Shading.OverhangAndScreen overhangAndScreen(
    hWin=shaPro.hWin,
    wWin=shaPro.wWin,
    wLeft=shaPro.wLeft,
    wRight=shaPro.wRight,
    dep=shaPro.ovDep,
    gap=shaPro.ovGap,
    shaCorr=shaPro.shaCorr,
    azi=azi) if
    shaPro.shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.OverhangAndScreen
    "Overhang and screen model"
    annotation (Placement(transformation(extent={{-16,20},{-6,40}})));
  IDEAS.Buildings.Components.Shading.Screen screen(
    azi=azi,
    shaCorr=shaPro.shaCorr) if
    shaPro.shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.Screen
    "Screen model"                                 annotation (Placement(transformation(extent={{-16,0},{-6,20}})));
  IDEAS.Buildings.Components.Shading.SideFins sideFins(
    azi=azi,
    hWin=shaPro.hWin,
    wWin=shaPro.wWin,
    hFin=shaPro.hFin,
    dep=shaPro.finDep,
    gap=shaPro.finGap) if
    shaPro.shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.SideFins
    "Side fin model"
    annotation (Placement(transformation(extent={{-16,-20},{-6,0}})));
  IDEAS.Buildings.Components.Shading.None none(azi=azi) if
    shaPro.shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.None
    "No shading model"
    annotation (Placement(transformation(extent={{-16,-40},{-6,-20}})));

  IDEAS.Buildings.Components.Shading.BoxAndScreen boxAndScreen(
    azi=azi,
    hWin=shaPro.hWin,
    wWin=shaPro.wWin,
    wLeft=shaPro.wLeft,
    wRight=shaPro.wRight,
    ovDep=shaPro.ovDep,
    ovGap=shaPro.ovGap,
    hFin=shaPro.hFin,
    finDep=shaPro.finDep,
    finGap=shaPro.finGap,
    shaCorr=shaPro.shaCorr) if shaPro.shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.BoxAndScreen "Box and screen model"
        annotation (Placement(transformation(extent={{-16,-62},{-6,-42}})));
equation
  connect(screen.Ctrl, Ctrl) annotation (Line(
      points={{-11,0},{-10,0},{-10,-110}},
      color={0,0,127},
      visible=false));
  connect(Ctrl, overhangAndScreen.Ctrl) annotation (Line(
      points={{-10,-110},{-10,20},{-11,20}},
      color={0,0,127},
      visible=false));
  connect(box.solDir, solDir)
    annotation (Line(points={{-16,96},{-60,96},{-60,50}}, color={0,0,127}));
  connect(buildingShade.solDir, solDir)
    annotation (Line(points={{-16,76},{-60,76},{-60,50}}, color={0,0,127}));
  connect(overhang.solDir, solDir)
    annotation (Line(points={{-16,56},{-60,56},{-60,50}}, color={0,0,127}));
  connect(overhangAndScreen.solDir, solDir)
    annotation (Line(points={{-16,36},{-60,36},{-60,50}}, color={0,0,127}));
  connect(screen.solDir, solDir)
    annotation (Line(points={{-16,16},{-60,16},{-60,50}}, color={0,0,127}));
  connect(sideFins.solDir, solDir)
    annotation (Line(points={{-16,-4},{-60,-4},{-60,50}}, color={0,0,127}));
  connect(box.solDif, solDif)
    annotation (Line(points={{-16,92},{-60,92},{-60,10}}, color={0,0,127}));
  connect(buildingShade.solDif, solDif)
    annotation (Line(points={{-16,72},{-60,72},{-60,10}}, color={0,0,127}));
  connect(overhang.solDif, solDif)
    annotation (Line(points={{-16,52},{-60,52},{-60,10}}, color={0,0,127}));
  connect(overhangAndScreen.solDif, solDif)
    annotation (Line(points={{-16,32},{-60,32},{-60,10}}, color={0,0,127}));
  connect(screen.solDif, solDif)
    annotation (Line(points={{-16,12},{-60,12},{-60,10}}, color={0,0,127}));
  connect(sideFins.solDif, solDif)
    annotation (Line(points={{-16,-8},{-60,-8},{-60,10}}, color={0,0,127}));
  connect(box.angInc, angInc)
    annotation (Line(points={{-16,86},{-60,86},{-60,-50}}, color={0,0,127}));
  connect(buildingShade.angInc, angInc)
    annotation (Line(points={{-16,66},{-60,66},{-60,-50}}, color={0,0,127}));
  connect(overhang.angInc, angInc)
    annotation (Line(points={{-16,46},{-60,46},{-60,-50}}, color={0,0,127}));
  connect(overhangAndScreen.angInc, angInc)
    annotation (Line(points={{-16,26},{-60,26},{-60,-50}}, color={0,0,127}));
  connect(screen.angInc, angInc)
    annotation (Line(points={{-16,6},{-60,6},{-60,-50}}, color={0,0,127}));
  connect(sideFins.angInc, angInc)
    annotation (Line(points={{-16,-14},{-60,-14},{-60,-50}}, color={0,0,127}));
  connect(box.angZen, angZen) annotation (Line(points={{-16,84},{-24,84},{-60,84},
          {-60,-70}},          color={0,0,127}));
  connect(buildingShade.angZen, angZen) annotation (Line(points={{-16,64},{-24,64},
          {-60,64},{-60,-70}},          color={0,0,127}));
  connect(overhang.angZen, angZen) annotation (Line(points={{-16,44},{-26,44},{-60,
          44},{-60,-70}},          color={0,0,127}));
  connect(overhangAndScreen.angZen, angZen)
    annotation (Line(points={{-16,24},{-60,24},{-60,-70}}, color={0,0,127}));
  connect(screen.angZen, angAzi) annotation (Line(points={{-16,4},{-24,4},{-60,4},
          {-60,-90}},         color={0,0,127}));
  connect(sideFins.angZen, angZen) annotation (Line(points={{-16,-16},{-24,-16},
          {-60,-16},{-60,-70}},           color={0,0,127}));
  connect(box.angAzi, angAzi)
    annotation (Line(points={{-16,82},{-60,82},{-60,-90}}, color={0,0,127}));
  connect(buildingShade.angAzi, angAzi)
    annotation (Line(points={{-16,62},{-60,62},{-60,-90}}, color={0,0,127}));
  connect(overhang.angAzi, angAzi)
    annotation (Line(points={{-16,42},{-60,42},{-60,-90}}, color={0,0,127}));
  connect(overhangAndScreen.angAzi, angAzi)
    annotation (Line(points={{-16,22},{-60,22},{-60,-90}}, color={0,0,127}));
  connect(screen.angAzi, angAzi)
    annotation (Line(points={{-16,2},{-60,2},{-60,-90}}, color={0,0,127}));
  connect(sideFins.angAzi, angAzi)
    annotation (Line(points={{-16,-18},{-60,-18},{-60,-90}}, color={0,0,127}));
  connect(box.iSolDir, iSolDir)
    annotation (Line(points={{-6,96},{40,96},{40,50}}, color={0,0,127}));
  connect(buildingShade.iSolDir, iSolDir)
    annotation (Line(points={{-6,76},{40,76},{40,50}}, color={0,0,127}));
  connect(overhang.iSolDir, iSolDir)
    annotation (Line(points={{-6,56},{40,56},{40,50}}, color={0,0,127}));
  connect(overhangAndScreen.iSolDir, iSolDir)
    annotation (Line(points={{-6,36},{40,36},{40,50}}, color={0,0,127}));
  connect(screen.iSolDir, iSolDir)
    annotation (Line(points={{-6,16},{40,16},{40,50}}, color={0,0,127}));
  connect(sideFins.iSolDir, iSolDir)
    annotation (Line(points={{-6,-4},{40,-4},{40,50}}, color={0,0,127}));
  connect(box.iSolDif, iSolDif)
    annotation (Line(points={{-6,92},{40,92},{40,10}}, color={0,0,127}));
  connect(buildingShade.iSolDif, iSolDif)
    annotation (Line(points={{-6,72},{40,72},{40,10}}, color={0,0,127}));
  connect(overhang.iSolDif, iSolDif)
    annotation (Line(points={{-6,52},{40,52},{40,10}}, color={0,0,127}));
  connect(overhangAndScreen.iSolDif, iSolDif)
    annotation (Line(points={{-6,32},{40,32},{40,10}}, color={0,0,127}));
  connect(screen.iSolDif, iSolDif)
    annotation (Line(points={{-6,12},{40,12},{40,10}}, color={0,0,127}));
  connect(sideFins.iSolDif, iSolDif)
    annotation (Line(points={{-6,-8},{40,-8},{40,10}}, color={0,0,127}));
  connect(sideFins.iAngInc, iAngInc)
    annotation (Line(points={{-6,-14},{40,-14},{40,-50}}, color={0,0,127}));
  connect(screen.iAngInc, iAngInc)
    annotation (Line(points={{-6,6},{40,6},{40,-50}}, color={0,0,127}));
  connect(overhangAndScreen.iAngInc, iAngInc)
    annotation (Line(points={{-6,26},{40,26},{40,-50}}, color={0,0,127}));
  connect(overhang.iAngInc, iAngInc)
    annotation (Line(points={{-6,46},{40,46},{40,-50}}, color={0,0,127}));
  connect(buildingShade.iAngInc, iAngInc)
    annotation (Line(points={{-6,66},{40,66},{40,-50}}, color={0,0,127}));
  connect(box.iAngInc, iAngInc)
    annotation (Line(points={{-6,86},{40,86},{40,-50}}, color={0,0,127}));
  connect(none.solDir, solDir)
    annotation (Line(points={{-16,-24},{-60,-24},{-60,50}}, color={0,0,127}));
  connect(none.solDif, solDif)
    annotation (Line(points={{-16,-28},{-60,-28},{-60,10}}, color={0,0,127}));
  connect(none.angInc, angInc)
    annotation (Line(points={{-16,-34},{-60,-34},{-60,-50}}, color={0,0,127}));
  connect(none.angAzi, angAzi) annotation (Line(points={{-16,-38},{-24,-38},{-60,
          -38},{-60,-90}}, color={0,0,127}));
  connect(none.angZen, angZen) annotation (Line(points={{-16,-36},{-28,-36},{-60,
          -36},{-60,-70}}, color={0,0,127}));
  connect(none.iAngInc, iAngInc)
    annotation (Line(points={{-6,-34},{40,-34},{40,-50}}, color={0,0,127}));
  connect(none.iSolDif, iSolDif)
    annotation (Line(points={{-6,-28},{40,-28},{40,10}}, color={0,0,127}));
  connect(none.iSolDir, iSolDir)
    annotation (Line(points={{-6,-24},{40,-24},{40,50}}, color={0,0,127}));
  connect(boxAndScreen.solDir, solDir) annotation (Line(points={{-16,-46},{-36,-46},
          {-36,50},{-60,50}}, color={0,0,127}));
  connect(boxAndScreen.solDif, solDif) annotation (Line(points={{-16,-50},{-36,-50},
          {-36,10},{-60,10}}, color={0,0,127}));
  connect(boxAndScreen.angInc, angInc) annotation (Line(points={{-16,-56},{-36,-56},
          {-36,-50},{-60,-50}}, color={0,0,127}));
  connect(boxAndScreen.angZen, angZen) annotation (Line(points={{-16,-58},{-32,-58},
          {-32,-70},{-60,-70}}, color={0,0,127}));
  connect(boxAndScreen.angAzi, angAzi) annotation (Line(points={{-16,-60},{-34,-60},
          {-34,-90},{-60,-90}}, color={0,0,127}));
  connect(boxAndScreen.iSolDir, iSolDir) annotation (Line(points={{-6,-46},{10,-46},
          {10,50},{40,50}}, color={0,0,127}));
  connect(boxAndScreen.iSolDif, iSolDif) annotation (Line(points={{-6,-50},{10,-50},
          {10,10},{40,10}}, color={0,0,127}));
  connect(boxAndScreen.iAngInc, iAngInc) annotation (Line(points={{-6,-56},{12,-56},
          {12,-50},{40,-50}}, color={0,0,127}));
  connect(Ctrl, boxAndScreen.Ctrl) annotation (Line(points={{-10,-110},{-10,-62},
          {-11,-62}}, color={0,0,127}));
end Shading;
