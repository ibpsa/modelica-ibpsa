within IDEAS.Occupants.Stochastic;
model General

  extends IDEAS.Occupants.Interfaces.Occupant(nLoads=appliances.nLoads+lighting.nLoads);

  Occupancy occupancy(occChain = occupanceData)
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Appliances appliances
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Lighting lighting(lightData=lightData)
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  replaceable parameter Data.BaseClasses.Occupance occupanceData
    annotation (Placement(transformation(extent={{-76,90},{-72,94}})),choicesAllMatching=true);
  replaceable parameter Data.BaseClasses.Lighting lightData
    annotation (Placement(transformation(extent={{-64,90},{-60,94}})),choicesAllMatching=true);
equation
  connect(occupancy.TSet, TSet) annotation (Line(
      points={{0,40},{0,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heatPortCon, occupancy.heatPortCon) annotation (Line(
      points={{-100,20},{-60,20},{-60,32},{-10,32}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatPortCon, appliances.heatPortCon) annotation (Line(
      points={{-100,20},{-60,20},{-60,2},{-20,2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatPortCon, lighting.heatPortCon) annotation (Line(
      points={{-100,20},{-60,20},{-60,-28},{0,-28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatPortRad, occupancy.heatPortRad) annotation (Line(
      points={{-100,-20},{-54,-20},{-54,28},{-10,28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatPortRad, appliances.heatPortRad) annotation (Line(
      points={{-100,-20},{-54,-20},{-54,-2},{-20,-2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatPortRad, lighting.heatPortRad) annotation (Line(
      points={{-100,-20},{-54,-20},{-54,-32},{0,-32}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(appliances.P, ohmsLaw[1:appliances.nLoads].P) annotation (Line(
      points={{0,2},{30,2},{30,2.4},{60,2.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(appliances.Q, ohmsLaw[1:appliances.nLoads].Q) annotation (Line(
      points={{0,-2},{30,-2},{30,-2.4},{60,-2.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lighting.P, ohmsLaw[appliances.nLoads+1:nLoads].P) annotation (Line(
      points={{20,-28},{40,-28},{40,2.4},{60,2.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lighting.Q, ohmsLaw[appliances.nLoads+1:nLoads].Q) annotation (Line(
      points={{20,-32},{44,-32},{44,-2.4},{60,-2.4}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(occupancy.Occ, appliances.Occ) annotation (Line(
        points={{0,20},{0,14},{-10,14},{-10,10}},
        color={255,127,0},
        smooth=Smooth.None));
    connect(occupancy.Occ, lighting.Occ) annotation (Line(
        points={{0,20},{0,14},{10,14},{10,-20}},
        color={255,127,0},
        smooth=Smooth.None));
  annotation (Diagram(graphics));
end General;
