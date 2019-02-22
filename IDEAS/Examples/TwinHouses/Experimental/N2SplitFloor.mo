within IDEAS.Examples.TwinHouses.Experimental;
model N2SplitFloor
  "N2 model with split floor for solar gains in living room"
  extends BaseClasses.Structures.TwinhouseN2(W18(A=41.15 - A_split), Living(
        nSurf=19, redeclare ZoneLwGainDistribution radDistr(weightFactorDir=cat(
            1,
            zeros(18),
            {1}))));

  parameter Modelica.SIunits.Area A_split = 6
    "Surface area that is used for direct solar gains";
  Buildings.Components.BoundaryWall       W56(
    inc=incFloor,
    azi=aziSouth,
    redeclare parameter BaseClasses.Data.Constructions.ground constructionType,
    use_T_in=true,
    T_start=T_start,
    A=A_split)
    annotation (Placement(transformation(extent={{131,44},{141,24}})));
equation
  connect(W56.T, W18.T) annotation (Line(points={{127.167,32},{122,32},{122,32},
          {122,22},{111.167,22}}, color={0,0,127}));
  connect(W56.propsBus_a, Living.propsBus[19]) annotation (Line(
      points={{140.167,32},{140,32},{140,84},{-108,84},{-108,68.5}},
      color={255,204,51},
      thickness=0.5));
  annotation (Documentation(revisions="<html>
<ul>
<li>
January 24, 2017 by Filip Jorissen:<br/>
First implementation
</li>
</ul>
</html>", info="<html>
<p>
Twinhouse N2 model with additional separate floor surface for direct solar gains.
</p>
</html>"));
end N2SplitFloor;
