within IDEAS.Buildings.Examples;
model Structure "Example detailed building structure model"

  extends IDEAS.Interfaces.BaseClasses.Structure(
    nZones=3,
    ATrans=211,
    VZones={gF.V,fF.V,sF.V});

  //Definition of the thermal zones
  Components.Zone gF(V=216.0, nSurf=8) "second floor (sF) with sleeping area"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Components.Zone fF(V=216.0, nSurf=8) "second floor (sF) with sleeping area"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Components.Zone sF(V=216.0, nSurf=8) "second floor (sF) with sleeping area"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  //Definition of the building envelope for gF
  Components.OuterWall[3] gF_ext(
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType,
    redeclare IDEAS.Buildings.Data.Insulation.Rockwool insulationType,
    AWall={10,21,10},
    azi={IDEAS.Constants.East,IDEAS.Constants.South,IDEAS.Constants.West},
    insulationThickness={0.16,0.16,0.16},
    inc={IDEAS.Constants.Wall,IDEAS.Constants.Wall,IDEAS.Constants.Wall})
    annotation (Placement(transformation(
        extent={{-5.5,-10.5},{5.5,10.5}},
        rotation=90,
        origin={-17.5,-75.5})));
  Components.Window[3] gF_win(
    A={5.5,1,5.5},
    azi={IDEAS.Constants.East,IDEAS.Constants.South,IDEAS.Constants.West},
    redeclare IDEAS.Buildings.Data.Glazing.Ins2Kr glazing,
    inc={IDEAS.Constants.Wall,IDEAS.Constants.Wall,IDEAS.Constants.Wall},
    redeclare IDEAS.Buildings.Components.Shading.None shaType) annotation (
      Placement(transformation(
        extent={{-5.5,-10.5},{5.5,10.5}},
        rotation=90,
        origin={10.5,-75.5})));
  Components.SlabOnGround gF_floor(
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType,
    redeclare IDEAS.Buildings.Data.Insulation.Pur insulationType,
    insulationThickness=0.14,
    AWall=72,
    PWall=26,
    inc=IDEAS.Constants.Floor,
    azi=IDEAS.Constants.South) annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={-47,-76})));
  //Definition of the building envelope for fF
  Components.OuterWall[3] fF_ext(
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType,
    redeclare IDEAS.Buildings.Data.Insulation.Rockwool insulationType,
    AWall={10,21,10},
    azi={IDEAS.Constants.East,IDEAS.Constants.South,IDEAS.Constants.West},
    insulationThickness={0.16,0.16,0.16},
    inc={IDEAS.Constants.Wall,IDEAS.Constants.Wall,IDEAS.Constants.Wall})
    annotation (Placement(transformation(
        extent={{-5.5,-10.5},{5.5,10.5}},
        rotation=90,
        origin={-17.5,-15.5})));
  Components.Window[3] fF_win(
    A={5.5,1,5.5},
    azi={IDEAS.Constants.East,IDEAS.Constants.South,IDEAS.Constants.West},
    redeclare IDEAS.Buildings.Data.Glazing.Ins2Kr glazing,
    inc={IDEAS.Constants.Wall,IDEAS.Constants.Wall,IDEAS.Constants.Wall},
    redeclare IDEAS.Buildings.Components.Shading.None shaType) annotation (
      Placement(transformation(
        extent={{-5.5,-10.5},{5.5,10.5}},
        rotation=90,
        origin={10.5,-15.5})));
  Components.InternalWall fF_floor(
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType,
    redeclare IDEAS.Buildings.Data.Insulation.Pur insulationType,
    insulationThickness=0.04,
    AWall=74,
    inc=IDEAS.Constants.Floor,
    azi=IDEAS.Constants.South) annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={-47,-16})));
  //Definition of the building envelope for sF
  Components.OuterWall[3] sF_ext(
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType,
    redeclare IDEAS.Buildings.Data.Insulation.Rockwool insulationType,
    AWall={10,21,10},
    azi={IDEAS.Constants.East,IDEAS.Constants.South,IDEAS.Constants.West},
    insulationThickness={0.16,0.16,0.16},
    inc={IDEAS.Constants.Wall,IDEAS.Constants.Wall,IDEAS.Constants.Wall})
    annotation (Placement(transformation(
        extent={{-5.5,-10.5},{5.5,10.5}},
        rotation=90,
        origin={-17.5,44.5})));
  Components.Window[3] sF_win(
    A={5.5,1,5.5},
    azi={IDEAS.Constants.East,IDEAS.Constants.South,IDEAS.Constants.West},
    redeclare IDEAS.Buildings.Data.Glazing.Ins2Kr glazing,
    inc={IDEAS.Constants.Wall,IDEAS.Constants.Wall,IDEAS.Constants.Wall},
    redeclare IDEAS.Buildings.Components.Shading.None shaType) annotation (
      Placement(transformation(
        extent={{-5.5,-10.5},{5.5,10.5}},
        rotation=90,
        origin={10.5,44.5})));
  Components.InternalWall sF_floor(
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType,
    redeclare IDEAS.Buildings.Data.Insulation.Pur insulationType,
    insulationThickness=0.04,
    AWall=74,
    inc=IDEAS.Constants.Floor,
    azi=IDEAS.Constants.South) annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={-47,44})));
  Components.OuterWall sF_roof(
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType,
    redeclare IDEAS.Buildings.Data.Insulation.Xps insulationType,
    insulationThickness=0.32,
    AWall=74,
    inc=IDEAS.Constants.Ceiling,
    azi=IDEAS.Constants.South) annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={-77,44})));

equation
  //Connection to the connectors of the partial type
  //Connection of the gF floor
  connect(gF_ext.surfCon_a, gF.surfCon[1:3]) annotation (Line(
      points={{-14.35,-70},{-14,-70},{-14,-54},{14,-54},{14,-53.875},{40,-53.875}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(gF_ext.surfRad_a, gF.surfRad[1:3]) annotation (Line(
      points={{-11.2,-70},{-12,-70},{-12,-56},{16,-56},{16,-56.875},{40,-56.875}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(gF_win.surfCon_a, gF.surfCon[4:6]) annotation (Line(
      points={{13.65,-70},{14,-70},{14,-54},{28,-54},{28,-53.125},{40,-53.125}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(gF_win.surfRad_a, gF.surfRad[4:6]) annotation (Line(
      points={{16.8,-70},{16,-70},{16,-56},{28,-56},{28,-56.125},{40,-56.125}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(gF_win[1].iSolDif, gF.iSolDif) annotation (Line(
      points={{21,-72.2},{52,-72.2},{52,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gF_win[1].iSolDir, gF.iSolDir) annotation (Line(
      points={{21,-75.5},{48,-75.5},{48,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gF_win[2].iSolDif, gF.iSolDif) annotation (Line(
      points={{21,-72.2},{52,-72.2},{52,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gF_win[2].iSolDir, gF.iSolDir) annotation (Line(
      points={{21,-75.5},{48,-75.5},{48,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gF_win[3].iSolDif, gF.iSolDif) annotation (Line(
      points={{21,-72.2},{52,-72.2},{52,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gF_win[3].iSolDir, gF.iSolDir) annotation (Line(
      points={{21,-75.5},{48,-75.5},{48,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gF_floor.surfRad_a, gF.surfRad[7]) annotation (Line(
      points={{-41,-71},{-41,-55.375},{40,-55.375}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gF_floor.surfCon_a, gF.surfCon[7]) annotation (Line(
      points={{-44,-71},{-44,-52.375},{40,-52.375}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF_floor.surfRad_b, gF.surfRad[8]) annotation (Line(
      points={{-41,-21},{-41,-55.125},{40,-55.125}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF_floor.surfCon_b, gF.surfCon[8]) annotation (Line(
      points={{-44,-21},{-44,-52.125},{40,-52.125}},
      color={191,0,0},
      smooth=Smooth.None));
  //Connection of the fF floor
  connect(fF_ext.surfCon_a, fF.surfCon[1:3]) annotation (Line(
      points={{-14.35,-10},{-14,-10},{-14,6},{14,6},{14,6.125},{40,6.125}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF_ext.surfRad_a, fF.surfRad[1:3]) annotation (Line(
      points={{-11.2,-10},{-12,-10},{-12,4},{14,4},{14,3.125},{40,3.125}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF_win.surfCon_a, fF.surfCon[4:6]) annotation (Line(
      points={{13.65,-10},{12,-10},{12,6},{26,6},{26,6.875},{40,6.875}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF_win.surfRad_a, fF.surfRad[4:6]) annotation (Line(
      points={{16.8,-10},{16,-10},{16,4},{28,4},{28,3.875},{40,3.875}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF_win[1].iSolDif, fF.iSolDif) annotation (Line(
      points={{21,-12.2},{52,-12.2},{52,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF_win[1].iSolDir, fF.iSolDir) annotation (Line(
      points={{21,-15.5},{48,-15.5},{48,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF_win[2].iSolDif, fF.iSolDif) annotation (Line(
      points={{21,-12.2},{52,-12.2},{52,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF_win[2].iSolDir, fF.iSolDir) annotation (Line(
      points={{21,-15.5},{48,-15.5},{48,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF_win[3].iSolDif, fF.iSolDif) annotation (Line(
      points={{21,-12.2},{52,-12.2},{52,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF_win[3].iSolDir, fF.iSolDir) annotation (Line(
      points={{21,-15.5},{48,-15.5},{48,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF_floor.surfRad_a, fF.surfRad[7]) annotation (Line(
      points={{-41,-11},{-41,4.625},{40,4.625}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF_floor.surfRad_b, fF.surfRad[8]) annotation (Line(
      points={{-41,39},{-41,4.875},{40,4.875}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF_floor.surfCon_a, fF.surfCon[7]) annotation (Line(
      points={{-44,-11},{-44,7.625},{40,7.625}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF_floor.surfCon_b, fF.surfCon[8]) annotation (Line(
      points={{-44,39},{-44,7.875},{40,7.875}},
      color={191,0,0},
      smooth=Smooth.None));
  //Connection of the sF floor
  connect(sF_win[1].iSolDir, sF.iSolDir) annotation (Line(
      points={{21,44.5},{48,44.5},{48,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF_win[1].iSolDif, sF.iSolDif) annotation (Line(
      points={{21,47.8},{52,47.8},{52,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF_win[2].iSolDir, sF.iSolDir) annotation (Line(
      points={{21,44.5},{48,44.5},{48,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF_win[2].iSolDif, sF.iSolDif) annotation (Line(
      points={{21,47.8},{52,47.8},{52,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF_win[3].iSolDir, sF.iSolDir) annotation (Line(
      points={{21,44.5},{48,44.5},{48,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF_win[3].iSolDif, sF.iSolDif) annotation (Line(
      points={{21,47.8},{52,47.8},{52,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF_ext.surfCon_a, sF.surfCon[1:3]) annotation (Line(
      points={{-14.35,50},{-14,50},{-14,66},{14,66},{14,66.125},{40,66.125}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF_ext.surfRad_a, sF.surfRad[1:3]) annotation (Line(
      points={{-11.2,50},{-10,50},{-10,64},{16,64},{40,63.125}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF_win.surfCon_a, sF.surfCon[4:6]) annotation (Line(
      points={{13.65,50},{14,50},{14,66.875},{40,66.875}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF_win.surfRad_a, sF.surfRad[4:6]) annotation (Line(
      points={{16.8,50},{16,50},{16,63.875},{40,63.875}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF_floor.surfRad_a, sF.surfRad[7]) annotation (Line(
      points={{-41,49},{-41,64.625},{40,64.625}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF_floor.surfCon_a, sF.surfCon[7]) annotation (Line(
      points={{-44,49},{-44,67.625},{40,67.625}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF_roof.surfCon_a, sF.surfCon[8]) annotation (Line(
      points={{-74,49},{-74,67.875},{40,67.875}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF_roof.surfRad_a, sF.surfRad[8]) annotation (Line(
      points={{-71,49},{-71,64.875},{40,64.875}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF_roof.propsBus_a, sF.propsBus[8]) annotation (Line(
      points={{-81,49},{-81,72.25},{40,72.25}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(sF_floor.propsBus_a, sF.propsBus[7]) annotation (Line(
      points={{-51,49},{-51,72.75},{40,72.75}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(sF_ext.propsBus_a, sF.propsBus[1:3]) annotation (Line(
      points={{-21.7,50},{-21.7,75.75},{40,75.75}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(sF_win.propsBus_a, sF.propsBus[4:6]) annotation (Line(
      points={{6.3,50},{6.3,74.25},{40,74.25}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(sF_floor.propsBus_b, fF.propsBus[8]) annotation (Line(
      points={{-51,39},{-51,12.25},{40,12.25}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(fF_floor.propsBus_a, fF.propsBus[7]) annotation (Line(
      points={{-51,-11},{-51,12.75},{40,12.75}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(fF_ext.propsBus_a, fF.propsBus[1:3]) annotation (Line(
      points={{-21.7,-10},{-22,-10},{-22,15.75},{40,15.75}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(fF_win.propsBus_a, fF.propsBus[4:6]) annotation (Line(
      points={{6.3,-10},{6,-10},{6,14.25},{40,14.25}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(fF_floor.propsBus_b, gF.propsBus[8]) annotation (Line(
      points={{-51,-21},{-51,-47.75},{40,-47.75}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(gF_floor.propsBus_a, gF.propsBus[7]) annotation (Line(
      points={{-51,-71},{-51,-47.25},{40,-47.25}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(gF_ext.propsBus_a, gF.propsBus[1:3]) annotation (Line(
      points={{-21.7,-70},{-22,-70},{-22,-44.25},{40,-44.25}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(gF_win.propsBus_a, gF.propsBus[4:6]) annotation (Line(
      points={{6.3,-70},{6,-70},{6,-45.75},{40,-45.75}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  //Connection with Interface
  connect(gF.gainCon, heatPortCon[1]) annotation (Line(
      points={{60,-53},{104,-53},{104,13.3333},{150,13.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF.gainCon, heatPortCon[2]) annotation (Line(
      points={{60,7},{104,7},{104,20},{150,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF.gainCon, heatPortCon[3]) annotation (Line(
      points={{60,67},{104,67},{104,26.6667},{150,26.6667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gF.gainRad, heatPortRad[1]) annotation (Line(
      points={{60,-56},{106,-56},{106,-26.6667},{150,-26.6667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF.gainRad, heatPortRad[2]) annotation (Line(
      points={{60,4},{104,4},{104,-20},{150,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF.gainRad, heatPortRad[3]) annotation (Line(
      points={{60,64},{106,64},{106,-13.3333},{150,-13.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gF.TSensor, TSensor[1]) annotation (Line(
      points={{60.6,-50},{104,-50},{104,-66.6667},{156,-66.6667}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fF.TSensor, TSensor[2]) annotation (Line(
      points={{60.6,10},{104,10},{104,-60},{156,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sF.TSensor, TSensor[3]) annotation (Line(
      points={{60.6,70},{104,70},{104,-53.3333},{156,-53.3333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gF_floor.port_emb, heatPortEmb[1]) annotation (Line(
      points={{-37,-76},{-32,-76},{-32,-90},{80,-90},{80,60},{150,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF_floor.port_emb, heatPortEmb[2]) annotation (Line(
      points={{-37,-16},{-32,-16},{-32,-30},{80,-30},{80,60},{150,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF_floor.port_emb, heatPortEmb[3]) annotation (Line(
      points={{-37,44},{-32,44},{-32,30},{80,30},{80,60},{150,60}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-150,
            -100},{150,100}}), graphics));
end Structure;
