within IDEAS.Buildings.Examples.BaseClasses;
model structure "Example detailed building structure model"

  extends IDEAS.Templates.Interfaces.BaseClasses.Structure(
    nZones=3,
    nEmb = 3,
    ATrans=211,
    VZones={gF.V,fF.V,sF.V},
    AZones={gF_floor.AWall,fF_floor.AWall,sF_floor.AWall});

  //Definition of the thermal zones
  Components.Zone gF(V=216.0, nSurf=8,
    redeclare package Medium = Medium,
    airModel(massDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)) "second floor (sF) with sleeping area"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Components.Zone fF(V=216.0, nSurf=8,
    redeclare package Medium = Medium,
    airModel(massDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)) "second floor (sF) with sleeping area"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Components.Zone sF(V=216.0, nSurf=8,
    redeclare package Medium = Medium,
    airModel(massDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial))
                                       "second floor (sF) with sleeping area"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  //Definition of the building envelope for gF
  Components.OuterWall[3] gF_ext(
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType,
    redeclare IDEAS.Buildings.Data.Insulation.Rockwool insulationType,
    AWall={10,21,10},
    azi={IDEAS.Types.Azimuth.E,IDEAS.Types.Azimuth.S,IDEAS.Types.Azimuth.W},
    insulationThickness={0.16,0.16,0.16},
    inc={IDEAS.Types.Tilt.Wall,IDEAS.Types.Tilt.Wall,IDEAS.Types.Tilt.Wall})
    annotation (Placement(transformation(
        extent={{-5.5,-10.5},{5.5,10.5}},
        rotation=90,
        origin={-17.5,-75.5})));
  replaceable Components.Window[
                    3] gF_win(
    A={5.5,1,5.5},
    azi={IDEAS.Types.Azimuth.E,IDEAS.Types.Azimuth.S,IDEAS.Types.Azimuth.W},
    redeclare IDEAS.Buildings.Data.Glazing.Ins2Kr glazing,
    inc={IDEAS.Types.Tilt.Wall,IDEAS.Types.Tilt.Wall,IDEAS.Types.Tilt.Wall},
    redeclare IDEAS.Buildings.Components.Shading.None shaType) annotation (
      Placement(transformation(
        extent={{-5.5,-10.5},{5.5,10.5}},
        rotation=90,
        origin={10.5,-75.5})));

  replaceable Components.SlabOnGround
                          gF_floor(
    redeclare IDEAS.Buildings.Data.Insulation.Pur insulationType,
    insulationThickness=0.14,
    AWall=72,
    PWall=26,
    inc=IDEAS.Types.Tilt.Floor,
    azi=IDEAS.Types.Azimuth.S,
    redeclare IDEAS.Buildings.Data.Constructions.FloorOnGround constructionType)
                               annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={-47,-76})));
  //Definition of the building envelope for fF
  Components.OuterWall[3] fF_ext(
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType,
    redeclare IDEAS.Buildings.Data.Insulation.Rockwool insulationType,
    AWall={10,21,10},
    azi={IDEAS.Types.Azimuth.E,IDEAS.Types.Azimuth.S,IDEAS.Types.Azimuth.W},
    insulationThickness={0.16,0.16,0.16},
    inc={IDEAS.Types.Tilt.Wall,IDEAS.Types.Tilt.Wall,IDEAS.Types.Tilt.Wall})
    annotation (Placement(transformation(
        extent={{-5.5,-10.5},{5.5,10.5}},
        rotation=90,
        origin={-17.5,-15.5})));
  replaceable Components.Window[
                    3] fF_win(
    A={5.5,1,5.5},
    azi={IDEAS.Types.Azimuth.E,IDEAS.Types.Azimuth.S,IDEAS.Types.Azimuth.W},
    redeclare IDEAS.Buildings.Data.Glazing.Ins2Kr glazing,
    inc={IDEAS.Types.Tilt.Wall,IDEAS.Types.Tilt.Wall,IDEAS.Types.Tilt.Wall},
    redeclare IDEAS.Buildings.Components.Shading.None shaType) annotation (
      Placement(transformation(
        extent={{-5.5,-10.5},{5.5,10.5}},
        rotation=90,
        origin={10.5,-15.5})));
  Components.InternalWall fF_floor(
    redeclare IDEAS.Buildings.Data.Insulation.Pur insulationType,
    insulationThickness=0.04,
    AWall=74,
    inc=IDEAS.Types.Tilt.Floor,
    azi=IDEAS.Types.Azimuth.S,
    redeclare IDEAS.Buildings.Data.Constructions.TABS constructionType)
                               annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={-47,-16})));
  //Definition of the building envelope for sF
  Components.OuterWall[3] sF_ext(
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType,
    redeclare IDEAS.Buildings.Data.Insulation.Rockwool insulationType,
    AWall={10,21,10},
    azi={IDEAS.Types.Azimuth.E,IDEAS.Types.Azimuth.S,IDEAS.Types.Azimuth.W},
    insulationThickness={0.16,0.16,0.16},
    inc={IDEAS.Types.Tilt.Wall,IDEAS.Types.Tilt.Wall,IDEAS.Types.Tilt.Wall})
    annotation (Placement(transformation(
        extent={{-5.5,-10.5},{5.5,10.5}},
        rotation=90,
        origin={-17.5,44.5})));
  replaceable Components.Window[
                    3] sF_win(
    A={5.5,1,5.5},
    azi={IDEAS.Types.Azimuth.E,IDEAS.Types.Azimuth.S,IDEAS.Types.Azimuth.W},
    redeclare IDEAS.Buildings.Data.Glazing.Ins2Kr glazing,
    inc={IDEAS.Types.Tilt.Wall,IDEAS.Types.Tilt.Wall,IDEAS.Types.Tilt.Wall},
    redeclare IDEAS.Buildings.Components.Shading.None shaType) annotation (
      Placement(transformation(
        extent={{-5.5,-10.5},{5.5,10.5}},
        rotation=90,
        origin={10.5,44.5})));
  Components.InternalWall sF_floor(
    redeclare IDEAS.Buildings.Data.Insulation.Pur insulationType,
    insulationThickness=0.04,
    AWall=74,
    inc=IDEAS.Types.Tilt.Floor,
    azi=IDEAS.Types.Azimuth.S,
    redeclare IDEAS.Buildings.Data.Constructions.TABS constructionType)
                               annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={-47,44})));
  Components.OuterWall sF_roof(
    redeclare IDEAS.Buildings.Data.Constructions.CavityWall constructionType,
    redeclare IDEAS.Buildings.Data.Insulation.Xps insulationType,
    insulationThickness=0.32,
    AWall=74,
    inc=IDEAS.Types.Tilt.Ceiling,
    azi=IDEAS.Types.Azimuth.S) annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={-77,44})));

equation
  //Connection to the connectors of the partial type
  //Connection of the gF floor

  //Connection of the fF floor
  //Connection of the sF floor
  connect(sF_roof.propsBus_a, sF.propsBus[8]) annotation (Line(
      points={{-79,49},{-79,72.25},{40,72.25}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(sF_floor.propsBus_a, sF.propsBus[7]) annotation (Line(
      points={{-49,49},{-49,72.75},{40,72.75}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(sF_ext.propsBus_a, sF.propsBus[1:3]) annotation (Line(
      points={{-19.6,50},{-19.6,74.75},{40,74.75}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(sF_win.propsBus_a, sF.propsBus[4:6]) annotation (Line(
      points={{8.4,50},{8.4,73.25},{40,73.25}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(sF_floor.propsBus_b, fF.propsBus[8]) annotation (Line(
      points={{-51,39},{-51,12.25},{40,12.25}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(fF_floor.propsBus_a, fF.propsBus[7]) annotation (Line(
      points={{-49,-11},{-49,12.75},{40,12.75}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(fF_ext.propsBus_a, fF.propsBus[1:3]) annotation (Line(
      points={{-19.6,-10},{-22,-10},{-22,14.75},{40,14.75}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(fF_win.propsBus_a, fF.propsBus[4:6]) annotation (Line(
      points={{8.4,-10},{6,-10},{6,13.25},{40,13.25}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(fF_floor.propsBus_b, gF.propsBus[8]) annotation (Line(
      points={{-51,-21},{-51,-47.75},{40,-47.75}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(gF_floor.propsBus_a, gF.propsBus[7]) annotation (Line(
      points={{-49,-71},{-49,-47.25},{40,-47.25}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(gF_ext.propsBus_a, gF.propsBus[1:3]) annotation (Line(
      points={{-19.6,-70},{-22,-70},{-22,-45.25},{40,-45.25}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(gF_win.propsBus_a, gF.propsBus[4:6]) annotation (Line(
      points={{8.4,-70},{6,-70},{6,-46.75},{40,-46.75}},
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
  connect(gF.flowPort_Out, flowPort_Out[1]) annotation (Line(
      points={{48,-40},{48,-36},{-100,-36},{-100,84},{-22,84},{-22,93.3333},{
          -20,93.3333}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(gF.flowPort_In, flowPort_In[1]) annotation (Line(
      points={{52,-40},{52,-32},{-96,-32},{-96,80},{20,80},{20,93.3333}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(fF.flowPort_Out, flowPort_Out[2]) annotation (Line(
      points={{48,20},{48,26},{-100,26},{-100,84},{-20,84},{-20,100}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(fF.flowPort_In, flowPort_In[2]) annotation (Line(
      points={{52,20},{52,30},{-96,30},{-96,80},{20,80},{20,100}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(sF.flowPort_Out, flowPort_Out[3]) annotation (Line(
      points={{48,80},{48,84},{-20,84},{-20,106.667}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(sF.flowPort_In, flowPort_In[3]) annotation (Line(
      points={{52,80},{52,88},{20,88},{20,106.667}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(gF_floor.port_emb[1], heatPortEmb[1]) annotation (Line(
      points={{-37,-76},{-32,-76},{-32,-92},{114,-92},{114,53.3333},{150,
          53.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF_floor.port_emb[1], heatPortEmb[2]) annotation (Line(
      points={{-37,-16},{-32,-16},{-32,-28},{114,-28},{114,60},{150,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF_floor.port_emb[1], heatPortEmb[3]) annotation (Line(points={{-37,44},
          {-32,44},{-32,36},{112,36},{112,66.6667},{150,66.6667}},     color={
          191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-150,
            -100},{150,100}})));
end structure;
