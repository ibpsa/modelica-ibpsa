within IDEAS.Buildings.Components.ZoneAirModels.BaseClasses;
partial model PartialAirLeakage
  "air leakage due to limied air tightness"
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_airLea "nominal mass flow of air leakage";
  Modelica.SIunits.SpecificEnthalpy hDiff "Enthalpy difference between air inlet and outlet";

  outer IDEAS.BoundaryConditions.SimInfoManager sim
    "Simulation information manager"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  Modelica.Blocks.Sources.RealExpression reaExpMflo(y=m_flow_nominal_airLea)
    annotation (Placement(transformation(extent={{-86,20},{-40,40}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow_sim if
                                                                                  sim.computeConservationOfEnergy
    annotation (Placement(transformation(extent={{-60,50},{-80,70}})));
  Modelica.Blocks.Sources.RealExpression Qgai(y=-reaExpMflo.y*hDiff)
    annotation (Placement(transformation(extent={{-100,34},{-22,54}})));
  Modelica.Blocks.Routing.RealPassThrough Te annotation (Placement(
    transformation(
    extent={{-10,-10},{10,10}},
    rotation=270,
    origin={6,70})));
protected
  Interfaces.WeaBus weaBus(numSolBus=sim.numIncAndAziInBus, outputAngles=sim.outputAngles)
    annotation (Placement(transformation(extent={{-50,76},{-30,96}})));
equation
  connect(prescribedHeatFlow_sim.port, sim.Qgai)
    annotation (Line(points={{-80,60},{-90,60},{-90,80}}, color={191,0,0}));
  connect(Qgai.y, prescribedHeatFlow_sim.Q_flow) annotation (Line(points={{-18.1,
          44},{-18.1,60},{-60,60}}, color={0,0,127}));
  connect(sim.weaBus, weaBus) annotation (Line(
      points={{-84,92.8},{-40,92.8},{-40,86}},
      color={255,204,51},
      thickness=0.5));

  connect(Te.u, weaBus.Te) annotation (Line(points={{6,82},{6,86.05},{-39.95,86.05}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={Text(
          extent={{-60,60},{60,-60}},
          lineColor={0,128,255},
          textString="ACH")}),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(revisions="<html>
<ul>
<li>
April 20, 2016, Filip Jorissen:<br/>
Added missing density factor.
</li>
<li>
January 29, 2016, Filip Jorissen:<br/>
Implementation now also uses the outdoor humidity and up to one trace substance concentration.
</li>
<li>
June 14, 2015, Filip Jorissen:<br/>
Adjusted implementation for computing conservation of energy.
</li>
</ul>
</html>"));
end PartialAirLeakage;
