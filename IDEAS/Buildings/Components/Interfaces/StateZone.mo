within IDEAS.Buildings.Components.Interfaces;
partial model StateZone "Partial model for thermal building zones"
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);
  parameter Integer nSurf(min=1)
    "Number of surfaces adjacent to and heat exchangeing with the zone";
  outer IDEAS.SimInfoManager sim
    "Simulation information manager for climate data"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b gainRad
    "Internal zone node for radiative heat gains"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a gainCon
    "Internal zone node for convective heat gains"
    annotation (Placement(transformation(extent={{90,-40},{110,-20}})));
  Modelica.Blocks.Interfaces.RealOutput TSensor(unit="K", displayUnit="degC")
    "Sensor temperature of the zone, i.e. operative temeprature" annotation (
      Placement(transformation(extent={{96,-10},{116,10}}), iconTransformation(
          extent={{96,-10},{116,10}})));
  ZoneBus[nSurf] propsBus(each final numAzi=sim.numAzi,
      each final computeConservationOfEnergy=sim.computeConservationOfEnergy)
                          annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=-90,
        origin={-100,40}), iconTransformation(
        extent={{-20,20},{20,-20}},
        rotation=-90,
        origin={-100,40})));
  Fluid.Interfaces.FlowPort_b flowPort_Out(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-30,90},{-10,110}})));
  Fluid.Interfaces.FlowPort_a flowPort_In(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{10,90},{30,110}})));

protected
  Modelica.Blocks.Sources.RealExpression Eexpr if
       sim.computeConservationOfEnergy "Internal energy model";
  BaseClasses.PrescribedEnergy prescribedHeatFlowE if
        sim.computeConservationOfEnergy
    "Dummy that allows computing total internal energy";
  Modelica.Blocks.Sources.RealExpression Qgai(
    y=(if sim.openSystemConservationOfEnergy
       then 0
       else gainCon.Q_flow + gainRad.Q_flow + flowPort_In.m_flow*actualStream(flowPort_In.h_outflow) + flowPort_Out.m_flow*actualStream(flowPort_Out.h_outflow))) if
       sim.computeConservationOfEnergy "Heat gains in model";
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlowQgai if
       sim.computeConservationOfEnergy
    "Component for computing conservation of energy";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a dummy1 if  sim.computeConservationOfEnergy
    "Dummy heat port for avoiding error by dymola translator";
  IDEAS.Buildings.Components.BaseClasses.EnergyPort dummy2 if   sim.computeConservationOfEnergy
    "Dummy emergy port for avoiding error by dymola translator";
equation
  connect(sim.Qgai, dummy1);
  connect(sim.E, dummy2);
for i in 1:nSurf loop
  connect(sim.weaBus, propsBus[i].weaBus) annotation (Line(
       points={{-88.6,97.2},{-88.6,100},{-100.1,100},{-100.1,39.9}},
       color={255,204,51},
       thickness=0.5,
       smooth=Smooth.None));
  connect(dummy1, propsBus[i].Qgai);
  connect(dummy2, propsBus[i].E);
end for;
  connect(Eexpr.y,prescribedHeatFlowE.E);
  connect(prescribedHeatFlowE.port, sim.E);
  connect(Qgai.y,prescribedHeatFlowQgai. Q_flow);
  connect(prescribedHeatFlowQgai.port, sim.Qgai);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-90,90},{90,-90}},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Backward,
          lineColor={0,0,0}),
        Rectangle(
          extent={{68,70},{-68,-70}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-68,70},{68,70}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Rectangle(
          extent={{-40,-70},{40,-90}},
          lineThickness=0.5,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-40,-90},{68,22},{68,-42},{40,-70},{40,-90},{-40,-90},{-40,-90}},
          lineThickness=0.5,
          smooth=Smooth.None,
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{-68,70},{-68,-70},{-40,-70},{-40,-80},{40,-80},{40,-70},{68,
              -70},{68,70}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Text(
          extent={{-39,40},{39,-40}},
          lineColor={0,0,0},
          fontName="Calibri",
          origin={-2,3},
          rotation=0,
          textString="%name")}),
    Documentation(revisions="<html>
<ul>
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
end StateZone;
