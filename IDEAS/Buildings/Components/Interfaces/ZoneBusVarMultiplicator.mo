within IDEAS.Buildings.Components.Interfaces;
model ZoneBusVarMultiplicator "Component to scale all flows from the zone propsBus. This can be used to scale the surface to n identical surfaces"
  parameter Real k = 1 "Scaling factor";

  ZoneBus propsBus_a(
    numIncAndAziInBus=sim.numIncAndAziInBus, outputAngles=sim.outputAngles)
    "Unscaled port"                                                         annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-100,0})));
  ZoneBus propsBus_b(
    numIncAndAziInBus=sim.numIncAndAziInBus, outputAngles=sim.outputAngles)
    "Scaled port"                                                           annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={100,0})));
  outer BoundaryConditions.SimInfoManager       sim
    "Simulation information manager for climate data"
    annotation (Placement(transformation(extent={{72,122},{92,142}})));
protected
  Modelica.Blocks.Math.Gain QTra_desgin(k=k) "Design heat flow rate"
    annotation (Placement(transformation(extent={{-10,178},{10,198}})));
  Modelica.Blocks.Math.Gain area(k=k) "Heat exchange surface area"
    annotation (Placement(transformation(extent={{-10,150},{10,170}})));
  BaseClasses.Varia.HeatFlowMultiplicator surfCon(k=k)
    "Block for scaling convective heat transfer"
    annotation (Placement(transformation(extent={{-10,62},{10,82}})));
  BaseClasses.Varia.HeatFlowMultiplicator surfRad(k=k)
    "Block for scaling radiative heat transfer"
    annotation (Placement(transformation(extent={{-10,34},{10,54}})));
  BaseClasses.Varia.HeatFlowMultiplicator iSolDir(k=k)
    "Block for scaling direct solar irradiation"
    annotation (Placement(transformation(extent={{-10,2},{10,22}})));
  BaseClasses.Varia.HeatFlowMultiplicator iSolDif(k=k)
    "Black for scaling diffuse solar irradiation"
    annotation (Placement(transformation(extent={{-10,-26},{10,-6}})));
  BaseClasses.Varia.HeatFlowMultiplicator QGai(k=k)
    "Block for scaling internal gains"
    annotation (Placement(transformation(extent={{-10,-86},{10,-66}})));
  BaseClasses.Varia.EnergyFlowMultiplicator E(k=k)
    "Block for scaling internal energy"
    annotation (Placement(transformation(extent={{-10,-116},{10,-96}})));
  WeaBus weaBus(numSolBus=sim.numIncAndAziInBus, outputAngles=sim.outputAngles) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-48})));
  Modelica.Blocks.Routing.RealPassThrough inc "Inclination angle"
    annotation (Placement(transformation(extent={{-10,-148},{10,-128}})));
  Modelica.Blocks.Routing.RealPassThrough azi "Azimuth angle"
    annotation (Placement(transformation(extent={{-10,-178},{10,-158}})));
  Modelica.Blocks.Routing.RealPassThrough epsLw "Longwave emissivity"
    annotation (Placement(transformation(extent={{-10,118},{10,138}})));
  Modelica.Blocks.Routing.RealPassThrough epsSw "Shortwave emissivity"
    annotation (Placement(transformation(extent={{-10,88},{10,108}})));
equation
  connect(QTra_desgin.u, propsBus_a.QTra_design) annotation (Line(points={{-12,188},
          {-100.1,188},{-100.1,0.1}},         color={0,0,127}));
  connect(QTra_desgin.y, propsBus_b.QTra_design) annotation (Line(points={{11,188},
          {100.1,188},{100.1,-0.1}},color={0,0,127}));
  connect(area.u, propsBus_a.area) annotation (Line(points={{-12,160},{-100.1,
          160},{-100.1,0.1}},color={0,0,127}));
  connect(area.y, propsBus_b.area) annotation (Line(points={{11,160},{100.1,160},
          {100.1,-0.1}},     color={0,0,127}));
  connect(surfCon.port_a, propsBus_a.surfCon) annotation (Line(points={{-10,72},
          {-100.1,72},{-100.1,0.1}},          color={191,0,0}));
  connect(surfRad.port_a, propsBus_a.surfRad) annotation (Line(points={{-10,44},
          {-100.1,44},{-100.1,0.1}},          color={191,0,0}));
  connect(iSolDif.port_a, propsBus_a.iSolDif) annotation (Line(points={{-10,-16},
          {-100.1,-16},{-100.1,0.1}},
                                   color={191,0,0}));
  connect(iSolDir.port_a, propsBus_a.iSolDir) annotation (Line(points={{-10,12},
          {-100.1,12},{-100.1,0.1}},          color={191,0,0}));
  connect(weaBus, propsBus_a.weaBus) annotation (Line(
      points={{0,-48},{-100.1,-48},{-100.1,0.1}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, propsBus_b.weaBus) annotation (Line(
      points={{0,-48},{100.1,-48},{100.1,-0.1}},
      color={255,204,51},
      thickness=0.5));
  connect(surfCon.port_b, propsBus_b.surfCon) annotation (Line(points={{10,72},
          {100.1,72},{100.1,-0.1}},        color={191,0,0}));
  connect(surfRad.port_b, propsBus_b.surfRad) annotation (Line(points={{10,44},
          {100.1,44},{100.1,-0.1}},        color={191,0,0}));
  connect(iSolDir.port_b, propsBus_b.iSolDir) annotation (Line(points={{10,12},
          {100.1,12},{100.1,-0.1}},        color={191,0,0}));
  connect(iSolDif.port_b, propsBus_b.iSolDif)
    annotation (Line(points={{10,-16},{100.1,-16},{100.1,-0.1}},
                                                             color={191,0,0}));
  connect(QGai.port_b, propsBus_b.Qgai) annotation (Line(points={{10,-76},{
          100.1,-76},{100.1,-0.1}},
                              color={191,0,0}));
  connect(E.E_b, propsBus_b.E) annotation (Line(points={{10,-106},{100.1,-106},
          {100.1,-0.1}},
                  color={0,0,0}));
  connect(inc.y, propsBus_b.inc) annotation (Line(points={{11,-138},{100.1,-138},
          {100.1,-0.1}}, color={0,0,127}));
  connect(azi.y, propsBus_b.azi) annotation (Line(points={{11,-168},{100.1,-168},
          {100.1,-0.1}}, color={0,0,127}));
  connect(azi.u, propsBus_a.azi) annotation (Line(points={{-12,-168},{-100.1,
          -168},{-100.1,0.1}},
                         color={0,0,127}));
  connect(inc.u, propsBus_a.inc) annotation (Line(points={{-12,-138},{-100.1,
          -138},{-100.1,0.1}},
                         color={0,0,127}));
  connect(E.E_a, propsBus_a.E) annotation (Line(points={{-9.8,-106},{-100.1,
          -106},{-100.1,0.1}},
                         color={0,0,0}));
  connect(QGai.port_a, propsBus_a.Qgai) annotation (Line(points={{-10,-76},{
          -100.1,-76},{-100.1,0.1}},       color={191,0,0}));
  connect(epsLw.u, propsBus_a.epsLw) annotation (Line(points={{-12,128},{-100.1,
          128},{-100.1,0.1}}, color={0,0,127}));
  connect(epsSw.u, propsBus_a.epsSw) annotation (Line(points={{-12,98},{-100.1,
          98},{-100.1,0.1}},         color={0,0,127}));
  connect(epsLw.y, propsBus_b.epsLw) annotation (Line(points={{11,128},{100.1,
          128},{100.1,-0.1}},        color={0,0,127}));
  connect(epsSw.y, propsBus_b.epsSw) annotation (Line(points={{11,98},{100.1,98},
          {100.1,-0.1}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-180},
            {100,200}}), graphics={
        Polygon(
          points={{-100,120},{102,-2},{-100,-120},{-100,120}},
          lineColor={255,215,136},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Text(
          extent={{-76,-110},{72,-160}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="k = %k"),
        Text(
          extent={{-100,158},{100,98}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-180},{100,200}})),
    Documentation(revisions="<html>
<ul>
<li>
August 10, 2018 by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end ZoneBusVarMultiplicator;
