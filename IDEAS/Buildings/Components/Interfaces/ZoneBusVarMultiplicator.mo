within IDEAS.Buildings.Components.Interfaces;
model ZoneBusVarMultiplicator "Component to scale all flows from the zone propsBus. This can be used to scale the surface to n identical surfaces"
  parameter Real k = 1 "Scaling factor";

  ZoneBus propsBus_a(
    numIncAndAziInBus=sim.numIncAndAziInBus, outputAngles=sim.outputAngles) annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-100,0})));
  ZoneBus propsBus_b(
    numIncAndAziInBus=sim.numIncAndAziInBus, outputAngles=sim.outputAngles) annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={100,0})));
  outer BoundaryConditions.SimInfoManager       sim
    "Simulation information manager for climate data"
    annotation (Placement(transformation(extent={{72,122},{92,142}})));
protected
  Modelica.Blocks.Math.Gain QTra_desgin(k=k)
    annotation (Placement(transformation(extent={{-10,178},{10,198}})));
  Modelica.Blocks.Math.Gain area(k=k)
    annotation (Placement(transformation(extent={{-10,150},{10,170}})));
  BaseClasses.Varia.HeatFlowMultiplicator surfCon(k=k)
    annotation (Placement(transformation(extent={{-6,62},{14,82}})));
  BaseClasses.Varia.HeatFlowMultiplicator surfRad(k=k)
    annotation (Placement(transformation(extent={{-6,34},{14,54}})));
  BaseClasses.Varia.HeatFlowMultiplicator iSolDir(k=k)
    annotation (Placement(transformation(extent={{-6,2},{14,22}})));
  BaseClasses.Varia.HeatFlowMultiplicator iSolDif(k=k)
    annotation (Placement(transformation(extent={{-6,-26},{14,-6}})));
  BaseClasses.Varia.HeatFlowMultiplicator Qgai(k=k)
    annotation (Placement(transformation(extent={{-6,-86},{14,-66}})));
  BaseClasses.Varia.EnergyFlowMultiplicator E(k=k)
    annotation (Placement(transformation(extent={{-6,-116},{14,-96}})));
  WeaBus weaBus(numSolBus=sim.numIncAndAziInBus, outputAngles=sim.outputAngles) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-48})));
  Modelica.Blocks.Routing.RealPassThrough inc
    annotation (Placement(transformation(extent={{-8,-148},{12,-128}})));
  Modelica.Blocks.Routing.RealPassThrough azi
    annotation (Placement(transformation(extent={{-8,-178},{12,-158}})));
  Modelica.Blocks.Routing.RealPassThrough epsLw
    annotation (Placement(transformation(extent={{-8,118},{12,138}})));
  Modelica.Blocks.Routing.RealPassThrough epsSw
    annotation (Placement(transformation(extent={{-8,88},{12,108}})));
equation
  connect(QTra_desgin.u, propsBus_a.QTra_design) annotation (Line(points={{-12,188},
          {-12,188},{-100.1,188},{-100.1,0.1}},
                                              color={0,0,127}));
  connect(QTra_desgin.y, propsBus_b.QTra_design) annotation (Line(points={{11,188},
          {100.1,188},{100.1,-0.1}},color={0,0,127}));
  connect(area.u, propsBus_a.area) annotation (Line(points={{-12,160},{-56,160},
          {-100.1,160},{-100.1,0.1}},
                             color={0,0,127}));
  connect(area.y, propsBus_b.area) annotation (Line(points={{11,160},{54,160},{100.1,
          160},{100.1,-0.1}},color={0,0,127}));
  connect(surfCon.port_a, propsBus_a.surfCon) annotation (Line(points={{-6,72},{
          -44,72},{-100.1,72},{-100.1,0.1}},  color={191,0,0}));
  connect(surfRad.port_a, propsBus_a.surfRad) annotation (Line(points={{-6,44},{
          -46,44},{-100.1,44},{-100.1,0.1}},  color={191,0,0}));
  connect(iSolDif.port_a, propsBus_a.iSolDif) annotation (Line(points={{-6,-16},
          {-100.1,-16},{-100.1,0.1}},
                                   color={191,0,0}));
  connect(iSolDir.port_a, propsBus_a.iSolDir) annotation (Line(points={{-6,12},{
          -48,12},{-100.1,12},{-100.1,0.1}},  color={191,0,0}));
  connect(weaBus, propsBus_a.weaBus) annotation (Line(
      points={{0,-48},{-100.1,-48},{-100.1,0.1}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, propsBus_b.weaBus) annotation (Line(
      points={{0,-48},{54,-48},{100.1,-48},{100.1,-0.1}},
      color={255,204,51},
      thickness=0.5));
  connect(surfCon.port_b, propsBus_b.surfCon) annotation (Line(points={{14,72},{
          58,72},{100.1,72},{100.1,-0.1}}, color={191,0,0}));
  connect(surfRad.port_b, propsBus_b.surfRad) annotation (Line(points={{14,44},{
          60,44},{100.1,44},{100.1,-0.1}}, color={191,0,0}));
  connect(iSolDir.port_b, propsBus_b.iSolDir) annotation (Line(points={{14,12},{
          58,12},{100.1,12},{100.1,-0.1}}, color={191,0,0}));
  connect(iSolDif.port_b, propsBus_b.iSolDif)
    annotation (Line(points={{14,-16},{100.1,-16},{100.1,-0.1}},
                                                             color={191,0,0}));
  connect(Qgai.port_b, propsBus_b.Qgai) annotation (Line(points={{14,-76},{100.1,
          -76},{100.1,-0.1}}, color={191,0,0}));
  connect(E.E_b, propsBus_b.E) annotation (Line(points={{14,-106},{100.1,-106},{
          100.1,-0.1}},
                  color={0,0,0}));
  connect(inc.y, propsBus_b.inc) annotation (Line(points={{13,-138},{100.1,-138},
          {100.1,-0.1}}, color={0,0,127}));
  connect(azi.y, propsBus_b.azi) annotation (Line(points={{13,-168},{100.1,-168},
          {100.1,-0.1}}, color={0,0,127}));
  connect(azi.u, propsBus_a.azi) annotation (Line(points={{-10,-168},{-100.1,-168},
          {-100.1,0.1}}, color={0,0,127}));
  connect(inc.u, propsBus_a.inc) annotation (Line(points={{-10,-138},{-100.1,-138},
          {-100.1,0.1}}, color={0,0,127}));
  connect(E.E_a, propsBus_a.E) annotation (Line(points={{-5.8,-106},{-100.1,-106},
          {-100.1,0.1}}, color={0,0,0}));
  connect(Qgai.port_a, propsBus_a.Qgai) annotation (Line(points={{-6,-76},{-42,-76},
          {-100.1,-76},{-100.1,0.1}},      color={191,0,0}));
  connect(epsLw.u, propsBus_a.epsLw) annotation (Line(points={{-10,128},{-100.1,
          128},{-100.1,0.1}}, color={0,0,127}));
  connect(epsSw.u, propsBus_a.epsSw) annotation (Line(points={{-10,98},{-32,98},
          {-100.1,98},{-100.1,0.1}}, color={0,0,127}));
  connect(epsLw.y, propsBus_b.epsLw) annotation (Line(points={{13,128},{54,128},
          {100.1,128},{100.1,-0.1}}, color={0,0,127}));
  connect(epsSw.y, propsBus_b.epsSw) annotation (Line(points={{13,98},{100.1,98},
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
