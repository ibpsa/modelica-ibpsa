within IDEAS.Buildings.Components;
model InternalWall "interior opaque wall between two zones"
  extends IDEAS.Buildings.Components.Interfaces.PartialOpaqueSurface(
  dT_nominal_a=1,
  E(y= if sim.computeConservationOfEnergy then layMul.E else 0),
  Qgai(y=(if sim.openSystemConservationOfEnergy or not sim.computeConservationOfEnergy
         then 0 else sum(port_emb.Q_flow))),
  final QTra_design=U_value*A    *(TRef_a - TRef_b),
    intCon_a);

  parameter Boolean linIntCon_b=sim.linIntCon
    "= true, if convective heat transfer should be linearised"
    annotation(Dialog(tab="Convection"));
  parameter Modelica.SIunits.TemperatureDifference dT_nominal_b=1
    "Nominal temperature difference used for linearisation, negative temperatures indicate the solid is colder"
    annotation(Dialog(tab="Convection"));
  parameter Modelica.SIunits.Temperature TRef_b=291.15
    "Reference temperature of zone on side of propsBus_b, for calculation of design heat loss"
     annotation (Dialog(group="Design power",tab="Advanced"));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_emb[constructionType.nGain]
    "port for gains by embedded active layers"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  IDEAS.Buildings.Components.Interfaces.ZoneBus propsBus_b(
    numIncAndAziInBus=sim.numIncAndAziInBus,
    outputAngles=sim.outputAngles) "If inc = Floor, then propsbus_b should be connected to the zone below this floor.
    If inc = Ceiling, then propsbus_b should be connected to the zone above this ceiling."
        annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-100,20}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-50,20})));

protected
  final parameter Real U_value=1/(1/8 + sum(constructionType.mats.R) + 1/8)
    "Wall U-value";

  IDEAS.Buildings.Components.BaseClasses.ConvectiveHeatTransfer.InteriorConvection
    intCon_b(
    linearise=linIntCon_b or sim.linearise,
    dT_nominal=dT_nominal_b,
    final inc=inc + Modelica.Constants.pi,
    final A=A)
    "convective surface heat transimission on the interior side of the wall"
    annotation (Placement(transformation(extent={{-22,-10},{-42,10}})));
  Modelica.Blocks.Sources.RealExpression QDesign_b(y=-QTra_design);
  //Negative, because of its losses from zone side b to zone side a, oposite of calculation of QTra_design

  Modelica.Blocks.Sources.RealExpression incExp1(y=inc + Modelica.Constants.pi)
    "Inclination angle";
  Modelica.Blocks.Sources.RealExpression aziExp1(y=azi + Modelica.Constants.pi)
    "Azimuth angle expression";
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow iSolDif1(final Q_flow=0);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow iSolDir1(final Q_flow=0);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow Qgai_b(final Q_flow=0);
  IDEAS.Buildings.Components.BaseClasses.ConservationOfEnergy.PrescribedEnergy
    E_b;
  Modelica.Blocks.Sources.Constant E0(final k=0)
    "All internal energy is assigned to right side";

equation
  connect(layMul.port_b, propsBus_b.surfRad) annotation (Line(
      points={{-10,0},{-14,0},{-14,20.1},{-100.1,20.1}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(propsBus_b.surfCon, intCon_b.port_b) annotation (Line(
      points={{-100.1,20.1},{-48,20.1},{-48,0},{-42,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_b, intCon_b.port_a) annotation (Line(
      points={{-10,0},{-22,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_b, propsBus_b.epsSw) annotation (Line(
      points={{-10,4},{-18,4},{-18,20.1},{-100.1,20.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_b, propsBus_b.epsLw) annotation (Line(
      points={{-10,8},{-16,8},{-16,20.1},{-100.1,20.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.area, propsBus_b.area) annotation (Line(
      points={{0,10},{0,20.1},{-100.1,20.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(iSolDif1.port, propsBus_b.iSolDif);
  connect(iSolDir1.port, propsBus_b.iSolDir);
  connect(QDesign_b.y, propsBus_b.QTra_design);
  connect(incExp1.y, propsBus_b.inc);
  connect(aziExp1.y, propsBus_b.azi);
  connect(Qgai_b.port, propsBus_b.Qgai);
  connect(E_b.port, propsBus_b.E);
  connect(E_b.E, E0.y);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-60,-100},{60,100}}),
        graphics={
        Rectangle(
          extent={{-52,-90},{48,-70}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-50,80},{50,100}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-10,80},{10,-70}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None),
        Line(points={{-50,80},{50,80}}, color={175,175,175}),
        Line(points={{-50,-70},{50,-70}}, color={175,175,175}),
        Line(points={{-50,-90},{50,-90}}, color={175,175,175}),
        Line(points={{-50,100},{50,100}}, color={175,175,175}),
        Line(
          points={{-10,80},{-10,-70}},
          smooth=Smooth.None,
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{10,80},{10,-70}},
          smooth=Smooth.None,
          color={0,0,0},
          thickness=0.5)}),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-60,-100},{60,
            100}})),
    Documentation(info="<html>
<p>
This is a wall model that should be used
to simulate a wall or floor between two zones.
See <a href=modelica://IDEAS.Buildings.Components.Interfaces.PartialOpaqueSurface>IDEAS.Buildings.Components.Interfaces.PartialOpaqueSurface</a> 
for equations, options, parameters, validation and dynamics that are common for all surfaces.
</p>
<h4>Typical use and important parameters</h4>
<p>
Each propsbus needs to be connected to a zone, which may be the same zone.
</p>
<p>
Note that this model is not symmetric: the convection equations depend on the inclination <code>inc</code>,
which is turned 180 degrees between both side. The value of <code>inc</code> is applied to the right side of the model.
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
</ul>
</html>"));
end InternalWall;
