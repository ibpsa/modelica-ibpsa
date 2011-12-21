within IDEAS.Buildings.Examples;
model Example "Example detailed building model"

extends IDEAS.Buildings.Interfaces.Building(nZones=3,ATrans=1,VZones={gF.V,fF.V,sF.V});

//Definition of the thermal zones
  Components.Zone gF(
    V=216.0,
    nSurf=8) "second floor (sF) with sleeping area"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Components.Zone fF(
    V=216.0,
    nSurf=8) "second floor (sF) with sleeping area"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Components.Zone sF(
    V=216.0,
    nSurf=8) "second floor (sF) with sleeping area"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
//Definition of the building envelope for gF
  Components.OuterWall[3] gF_ext(
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType,
    redeclare IDEAS.Buildings.Data.Insulation.Rockwool insulationType,
    AWall={10,21,10},
    azi={IDEAS.Constants.East,IDEAS.Constants.South,IDEAS.Constants.West},
    insulationThickness={0.16,0.16,0.16},
    inc={IDEAS.Constants.Wall,IDEAS.Constants.Wall,IDEAS.Constants.Wall})
    annotation (Placement(transformation(extent={{-5.5,-10.5},{5.5,10.5}},
        rotation=90,
        origin={-17.5,-75.5})));
  Components.Window[3] gF_win(
    A={5.5,1,5.5},
    azi={IDEAS.Constants.East,IDEAS.Constants.South,IDEAS.Constants.West},
    redeclare IDEAS.Buildings.Data.Glazing.Ins2Kr glazing,
    inc={IDEAS.Constants.Wall,IDEAS.Constants.Wall,IDEAS.Constants.Wall})     annotation (Placement(transformation(
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
    annotation (Placement(transformation(extent={{-5.5,-10.5},{5.5,10.5}},
        rotation=90,
        origin={-17.5,-15.5})));
  Components.Window[3] fF_win(
    A={5.5,1,5.5},
    azi={IDEAS.Constants.East,IDEAS.Constants.South,IDEAS.Constants.West},
    redeclare IDEAS.Buildings.Data.Glazing.Ins2Kr glazing,
    inc={IDEAS.Constants.Wall,IDEAS.Constants.Wall,IDEAS.Constants.Wall})     annotation (Placement(transformation(
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
    annotation (Placement(transformation(extent={{-5.5,-10.5},{5.5,10.5}},
        rotation=90,
        origin={-17.5,44.5})));
  Components.Window[3] sF_win(
    A={5.5,1,5.5},
    azi={IDEAS.Constants.East,IDEAS.Constants.South,IDEAS.Constants.West},
    redeclare IDEAS.Buildings.Data.Glazing.Ins2Kr glazing,
    inc={IDEAS.Constants.Wall,IDEAS.Constants.Wall,IDEAS.Constants.Wall})     annotation (Placement(transformation(
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
  connect(gF.gainCon, heatPortCon[1]) annotation (Line(
      points={{60,-53},{118,-53},{118,20},{150,20},{150,13.3333},{150,13.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gF.gainRad, heatPortRad[1]) annotation (Line(
      points={{60,-56},{120,-56},{120,-26.6667},{150,-26.6667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gF.TSensor, TSensor[1]) annotation (Line(
      points={{60.6,-50},{120,-50},{120,-60},{150,-60},{150,-66.6667},{156,
          -66.6667}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fF.TSensor, TSensor[2]) annotation (Line(
      points={{60.6,10},{122,10},{122,-60},{156,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fF.gainCon, heatPortCon[2]) annotation (Line(
      points={{60,7},{118,7},{118,20},{150,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF.gainRad, heatPortRad[2]) annotation (Line(
      points={{60,4},{120,4},{120,-20},{150,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF.gainCon, heatPortCon[3]) annotation (Line(
      points={{60,67},{118,67},{118,20},{150,20},{150,26.6667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF.gainRad, heatPortRad[3]) annotation (Line(
      points={{60,64},{120,64},{120,-20},{150,-20},{150,-13.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF.TSensor, TSensor[3]) annotation (Line(
      points={{60.6,70},{122,70},{122,-60},{150,-60},{150,-53.3333},{156,
          -53.3333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gF_floor.port_emb, heatPortEmb[1]) annotation (Line(
      points={{-37,-76},{-32,-76},{-32,-88},{116,-88},{116,60},{150,60},{150,
          53.3333},{150,53.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF_floor.port_emb, heatPortEmb[2]) annotation (Line(
      points={{-37,-16},{-32,-16},{-32,-30},{116,-30},{116,60},{150,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF_floor.port_emb, heatPortEmb[3]) annotation (Line(
      points={{-37,44},{-32,44},{-32,26},{116,26},{116,60},{150,60},{150,
          66.6667},{150,66.6667}},
      color={191,0,0},
      smooth=Smooth.None));
//Connection of the gF floor
  connect(gF_ext[1].area_a, gF.area[1]) annotation (Line(
      points={{-23.8,-69.34},{-23.8,-44.875},{39.6,-44.875}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gF_ext[2].area_a, gF.area[2]) annotation (Line(
      points={{-23.8,-69.34},{-23.8,-44.625},{39.6,-44.625}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gF_ext[3].area_a, gF.area[3]) annotation (Line(
      points={{-23.8,-69.34},{-23.8,-44.375},{39.6,-44.375}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gF_ext.iEpsLw_a, gF.epsLw[1:3]) annotation (Line(
      points={{-20.65,-69.34},{-20.65,-47.875},{39.6,-47.875}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gF_ext.iEpsSw_a, gF.epsSw[1:3]) annotation (Line(
      points={{-17.5,-69.34},{-17.5,-50.875},{39.6,-50.875}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gF_win.area_a, gF.area[4:6]) annotation (Line(
      points={{4.2,-69.34},{4.2,-44.125},{39.6,-44.125}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gF_win.iEpsLw_a, gF.epsLw[4:6]) annotation (Line(
      points={{7.35,-69.34},{7.35,-47.125},{39.6,-47.125}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gF_win.iEpsSw_a, gF.epsSw[4:6]) annotation (Line(
      points={{10.5,-69.34},{10.5,-50.125},{39.6,-50.125}},
      color={0,0,127},
      smooth=Smooth.None));
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
      points={{21,-73.96},{52,-73.96},{52,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gF_win[1].iSolDir, gF.iSolDir) annotation (Line(
      points={{21,-77.04},{48,-77.04},{48,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gF_win[2].iSolDif, gF.iSolDif) annotation (Line(
      points={{21,-73.96},{52,-73.96},{52,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gF_win[2].iSolDir, gF.iSolDir) annotation (Line(
      points={{21,-77.04},{48,-77.04},{48,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gF_win[3].iSolDif, gF.iSolDif) annotation (Line(
      points={{21,-73.96},{52,-73.96},{52,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gF_win[3].iSolDir, gF.iSolDir) annotation (Line(
      points={{21,-77.04},{48,-77.04},{48,-60}},
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
  connect(gF_floor.iEpsSw_a, gF.epsSw[7]) annotation (Line(
      points={{-47,-70.4},{-47,-49.375},{39.6,-49.375}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gF_floor.iEpsLw_a, gF.epsLw[7]) annotation (Line(
      points={{-50,-70.4},{-50,-46.375},{39.6,-46.375}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gF_floor.area_a, gF.area[7]) annotation (Line(
      points={{-53,-70.4},{-53,-43.375},{39.6,-43.375}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fF_floor.surfRad_b, gF.surfRad[8]) annotation (Line(
      points={{-41,-21},{-41,-55.125},{40,-55.125}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF_floor.surfCon_b, gF.surfCon[8]) annotation (Line(
      points={{-44,-21},{-44,-52.125},{40,-52.125}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF_floor.area_b, gF.area[8]) annotation (Line(
      points={{-53,-21.6},{-53,-43.125},{39.6,-43.125}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fF_floor.iEpsLw_b, gF.epsLw[8]) annotation (Line(
      points={{-50,-21.6},{-50,-46.125},{39.6,-46.125}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fF_floor.iEpsSw_b, gF.epsSw[8]) annotation (Line(
      points={{-47,-21.6},{-47,-49.125},{39.6,-49.125}},
      color={0,0,127},
      smooth=Smooth.None));
//Connection of the fF floor
  connect(fF_ext.area_a, fF.area[1:3]) annotation (Line(
      points={{-23.8,-9.34},{-23.8,15.125},{39.6,15.125}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fF_ext.iEpsLw_a, fF.epsLw[1:3]) annotation (Line(
      points={{-20.65,-9.34},{-20.65,12.125},{39.6,12.125}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fF_ext.iEpsSw_a, fF.epsSw[1:3]) annotation (Line(
      points={{-17.5,-9.34},{-17.5,9.125},{39.6,9.125}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fF_win[1].area_a, fF.area[4]) annotation (Line(
      points={{4.2,-9.34},{4.2,15.875},{39.6,15.875}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fF_win[2].area_a, fF.area[5]) annotation (Line(
      points={{4.2,-9.34},{4.2,16.125},{39.6,16.125}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fF_win[3].area_a, fF.area[6]) annotation (Line(
      points={{4.2,-9.34},{4.2,16.375},{39.6,16.375}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fF_win.iEpsLw_a, fF.epsLw[4:6]) annotation (Line(
      points={{7.35,-9.34},{7.35,12.875},{39.6,12.875}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fF_win.iEpsSw_a, fF.epsSw[4:6]) annotation (Line(
      points={{10.5,-9.34},{10.5,9.875},{39.6,9.875}},
      color={0,0,127},
      smooth=Smooth.None));
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
      points={{21,-13.96},{52,-13.96},{52,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF_win[1].iSolDir, fF.iSolDir) annotation (Line(
      points={{21,-17.04},{48,-17.04},{48,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF_win[2].iSolDif, fF.iSolDif) annotation (Line(
      points={{21,-13.96},{52,-13.96},{52,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF_win[2].iSolDir, fF.iSolDir) annotation (Line(
      points={{21,-17.04},{48,-17.04},{48,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF_win[3].iSolDif, fF.iSolDif) annotation (Line(
      points={{21,-13.96},{52,-13.96},{52,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF_win[3].iSolDir, fF.iSolDir) annotation (Line(
      points={{21,-17.04},{48,-17.04},{48,0}},
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
  connect(fF_floor.iEpsSw_a, fF.epsSw[7]) annotation (Line(
      points={{-47,-10.4},{-47,10.625},{39.6,10.625}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fF_floor.iEpsLw_a, fF.epsLw[7]) annotation (Line(
      points={{-50,-10.4},{-50,13.625},{39.6,13.625}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fF_floor.area_a, fF.area[7]) annotation (Line(
      points={{-53,-10.4},{-53,16.625},{39.6,16.625}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sF_floor.area_b, fF.area[8]) annotation (Line(
      points={{-53,38.4},{-53,16.875},{39.6,16.875}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sF_floor.iEpsLw_b, fF.epsLw[8]) annotation (Line(
      points={{-50,38.4},{-50,13.875},{39.6,13.875}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sF_floor.iEpsSw_b, fF.epsSw[8]) annotation (Line(
      points={{-47,38.4},{-47,10.875},{39.6,10.875}},
      color={0,0,127},
      smooth=Smooth.None));
//Connection of the sF floor
  connect(sF_win[1].iSolDir, sF.iSolDir) annotation (Line(
      points={{21,42.96},{48,42.96},{48,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF_win[1].iSolDif, sF.iSolDif) annotation (Line(
      points={{21,46.04},{52,46.04},{52,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF_win[2].iSolDir, sF.iSolDir) annotation (Line(
      points={{21,42.96},{48,42.96},{48,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF_win[2].iSolDif, sF.iSolDif) annotation (Line(
      points={{21,46.04},{52,46.04},{52,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF_win[3].iSolDir, sF.iSolDir) annotation (Line(
      points={{21,42.96},{48,42.96},{48,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF_win[3].iSolDif, sF.iSolDif) annotation (Line(
      points={{21,46.04},{52,46.04},{52,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF_ext.area_a, sF.area[1:3]) annotation (Line(
      points={{-23.8,50.66},{-23.8,75.125},{39.6,75.125}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sF_ext.iEpsLw_a, sF.epsLw[1:3]) annotation (Line(
      points={{-20.65,50.66},{-20.65,72.125},{39.6,72.125}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sF_ext.iEpsSw_a, sF.epsSw[1:3]) annotation (Line(
      points={{-17.5,50.66},{-17.5,69.125},{39.6,69.125}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sF_win.area_a, sF.area[4:6]) annotation (Line(
      points={{4.2,50.66},{4.2,75.875},{39.6,75.875}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sF_win.iEpsLw_a, sF.epsLw[4:6]) annotation (Line(
      points={{7.35,50.66},{7.35,72.875},{39.6,72.875}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sF_win.iEpsSw_a, sF.epsSw[4:6]) annotation (Line(
      points={{10.5,50.66},{10.5,69.875},{39.6,69.875}},
      color={0,0,127},
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
  connect(sF_floor.iEpsSw_a, sF.epsSw[7]) annotation (Line(
      points={{-47,49.6},{-47,70.625},{39.6,70.625}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sF_floor.iEpsLw_a, sF.epsLw[7]) annotation (Line(
      points={{-50,49.6},{-50,73.625},{39.6,73.625}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sF_floor.area_a, sF.area[7]) annotation (Line(
      points={{-53,49.6},{-53,76.625},{39.6,76.625}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sF_roof.surfCon_a, sF.surfCon[8])   annotation (Line(
      points={{-74,49},{-74,67.875},{40,67.875}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF_roof.iEpsSw_a, sF.epsSw[8])   annotation (Line(
      points={{-77,49.6},{-77,70.875},{39.6,70.875}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sF_roof.iEpsLw_a, sF.epsLw[8])   annotation (Line(
      points={{-80,49.6},{-80,73.875},{39.6,73.875}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sF_roof.area_a, sF.area[8])   annotation (Line(
      points={{-83,49.6},{-83,76.875},{39.6,76.875}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sF_roof.surfRad_a, sF.surfRad[8])   annotation (Line(
      points={{-71,49},{-71,64.875},{40,64.875}},
      color={191,0,0},
      smooth=Smooth.None));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-150,-100},
            {150,100}}),
                      graphics));
end Example;
