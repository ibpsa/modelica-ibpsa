within IDEAS.Buildings.Components;
model OuterWall "Opaque building envelope construction"
   extends IDEAS.Buildings.Components.Interfaces.PartialOpaqueSurface(
     dT_nominal_a=-3,
     QTra_design(fixed=false));

  parameter Boolean linExtCon=sim.linExtCon
    "= true, if exterior convective heat transfer should be linearised (uses average wind speed)"
    annotation(Dialog(tab="Convection"));
  parameter Boolean linExtRad=sim.linExtRad
    "= true, if exterior radiative heat transfer should be linearised"
    annotation(Dialog(tab="Radiation"));

  final parameter Real U_value=1/(1/8 + sum(constructionType.mats.R) + 1/25)
    "Wall U-value";

protected
  IDEAS.Buildings.Components.BaseClasses.ConvectiveHeatTransfer.ExteriorConvection
    extCon(               linearise=linExtCon or sim.linearise, final A=A)
    "convective surface heat transimission on the exterior side of the wall"
    annotation (Placement(transformation(extent={{-22,-28},{-42,-8}})));
  IDEAS.Buildings.Components.BaseClasses.RadiativeHeatTransfer.ExteriorSolarAbsorption
    solAbs(A=A)
    "determination of absorbed solar radiation by wall based on incident radiation"
    annotation (Placement(transformation(extent={{-22,-8},{-42,12}})));
  IDEAS.Buildings.Components.BaseClasses.RadiativeHeatTransfer.ExteriorHeatRadiation
    extRad(               linearise=linExtRad or sim.linearise, final A=A)
    "determination of radiant heat exchange with the environment and sky"
    annotation (Placement(transformation(extent={{-22,12},{-42,32}})));
  BoundaryConditions.SolarIrradiation.RadSolData radSolData(
    inc=inc,
    azi=azi,
    lat=sim.lat,
    final outputAngles=sim.outputAngles,
    incAndAziInBus=sim.incAndAziInBus,
    numIncAndAziInBus=sim.numIncAndAziInBus,
    useLinearisation=sim.lineariseDymola)
    annotation (Placement(transformation(extent={{-94,-4},{-74,16}})));
  Modelica.Blocks.Routing.RealPassThrough Tdes "Design temperature passthrough";
initial equation
  QTra_design =U_value*A*(273.15 + 21 - Tdes.y);

equation

  connect(extCon.port_a, layMul.port_b) annotation (Line(
      points={{-22,-18},{-18,-18},{-18,0},{-10,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(solAbs.port_a, layMul.port_b) annotation (Line(
      points={{-22,2},{-12,2},{-12,0},{-10,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(extRad.port_a, layMul.port_b) annotation (Line(
      points={{-22,22},{-18,22},{-18,0},{-10,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_b,solAbs. epsSw) annotation (Line(
      points={{-10,4},{-16,4},{-16,8},{-22,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_b,extRad. epsLw) annotation (Line(
      points={{-10,8},{-16,8},{-16,25.4},{-22,25.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSolData.weaBus, propsBus_a.weaBus) annotation (Line(
      points={{-74,14},{-74,19.9},{100.1,19.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(radSolData.Tenv,extRad. Tenv) annotation (Line(
      points={{-73.4,4},{-70,4},{-70,38},{-22,38},{-22,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(extCon.Te, propsBus_a.weaBus.Te) annotation (Line(
      points={{-22,-22.8},{100.1,-22.8},{100.1,19.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(extCon.hConExt, propsBus_a.weaBus.hConExt) annotation (Line(
      points={{-22,-27},{100.1,-27},{100.1,19.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tdes.u, propsBus_a.weaBus.Tdes);
  connect(radSolData.solDif, solAbs.solDif) annotation (Line(points={{-73.4,6},{
          -58,6},{-58,4},{-42,4}}, color={0,0,127}));
  connect(radSolData.solDir, solAbs.solDir)
    annotation (Line(points={{-73.4,8},{-42,8}},         color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-60,-100},{60,100}}),
        graphics={
        Rectangle(
          extent={{-50,-90},{50,80}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-50,60},{-30,60},{-30,80},{50,80},{50,100},{-50,100},{-50,60}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          smooth=Smooth.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-30,-70},{-50,-20}},
          lineThickness=0.5,
          fillColor={175,175,175},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None),
        Line(
          points={{-50,60},{-50,66},{-50,100},{50,100}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-50,60},{-30,60},{-30,80},{50,80}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-50,-20},{-30,-20},{-30,-70},{-30,-70},{52,-70}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-50,-20},{-50,-90},{50,-90}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-44,60},{-30,60},{-30,80},{-28,80},{50,80}},
          pattern=LinePattern.None,
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-44,-20},{-30,-20},{-30,-70}},
          pattern=LinePattern.None,
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-44,60},{-44,-20}},
          smooth=Smooth.None,
          color={175,175,175}),
        Line(
          points={{-44,-20},{-30,-20},{-30,-70}},
          smooth=Smooth.None,
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-44,60},{-30,60},{-30,80},{50,80}},
          smooth=Smooth.None,
          color={0,0,0},
          thickness=0.5)}),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}})),
    Documentation(info="<html>
<p>
This is the main wall model that should be used to
simulate a wall or roof between a zone and the outside environment.
See <a href=modelica://IDEAS.Buildings.Components.Interfaces.PartialOpaqueSurface>IDEAS.Buildings.Components.Interfaces.PartialOpaqueSurface</a> 
for equations, options, parameters, validation and dynamics that are common for all surfaces.
</p>
</html>", revisions="<html>
<ul>
<li>
January 2, 2017, by Filip Jorissen:<br/>
Updated icon layer.
</li>
<li>
October 22, 2016, by Filip Jorissen:<br/>
Revised documentation for IDEAS 1.0.
</li>
<li>
February 10, 2016, by Filip Jorissen and Damien Picard:<br/>
Revised implementation: cleaned up connections and partials.
</li>
<li>
June 14, 2015, Filip Jorissen:<br/>
Adjusted implementation for computing conservation of energy.
</li>
<li>
February 10, 2015 by Filip Jorissen:<br/>
Adjusted implementation for grouping of solar calculations.
</li>
</ul>
</html>"));
end OuterWall;
