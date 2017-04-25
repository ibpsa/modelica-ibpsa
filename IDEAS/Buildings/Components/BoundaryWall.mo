within IDEAS.Buildings.Components;
model BoundaryWall "Opaque wall with optional prescribed heat flow rate or temperature boundary conditions"
  extends IDEAS.Buildings.Components.Interfaces.PartialOpaqueSurface(
     QTra_design=U_value*A    *(273.15 + 21 - TRef_a),
     dT_nominal_a=-1,
     layMul(monLay(energyDynamics=cat(1, {(if not sim.lineariseDymola and use_T_in and energyDynamics ==  Modelica.Fluid.Types.Dynamics.FixedInitial then Modelica.Fluid.Types.Dynamics.DynamicFreeInitial else energyDynamics)}, fill(energyDynamics, layMul.nLay-1)),
          monLayDyn(each addRes_b=(sim.lineariseDymola and use_T_in)))));

  parameter Boolean use_T_in = false
    "Get the boundary temperature from the input connector"
    annotation(Dialog(group="Boundary conditions"));
  parameter Boolean use_Q_in = false
    "Get the boundary heat flux from the input connector"
    annotation(Dialog(group="Boundary conditions"));
  Modelica.Blocks.Interfaces.RealInput T if use_T_in annotation (Placement(
        transformation(extent={{-116,10},{-96,30}}), iconTransformation(extent=
            {{-116,10},{-96,30}})));
  Modelica.Blocks.Interfaces.RealInput Q_flow if use_Q_in annotation (Placement(
        transformation(extent={{-116,-30},{-96,-10}}),
                                                    iconTransformation(extent={{-116,
            -30},{-96,-10}})));
protected
  final parameter Real U_value=1/(1/8 + sum(constructionType.mats.R) + 1/8)
    "Wall U-value";
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow(
     final alpha=0) if use_Q_in
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature if use_T_in
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));


public
  Modelica.Blocks.Math.Product proPreT if  use_T_in
    annotation (Placement(transformation(extent={{-88,28},{-78,18}})));
  Modelica.Blocks.Math.Product proPreQ if use_Q_in
    annotation (Placement(transformation(extent={{-88,-12},{-78,-22}})));
equation
  if use_Q_in then
  connect(Q_flow, proPreQ.u1)
    annotation (Line(points={{-106,-20},{-78,-20},{-89,-20}},
                                                    color={0,0,127}));
  connect(proPreQ.y, prescribedHeatFlow.Q_flow) annotation (Line(points={{-77.5,
          -17},{-69.75,-17},{-69.75,-20},{-60,-20}}, color={0,0,127}));
  connect(proPreQ.u2, propsBus_a.weaBus.dummy) annotation (Line(points={{-89,
          -14},{-92,-14},{-92,40},{100.1,40},{100.1,19.9}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  end if;

  if use_T_in then
      connect(proPreT.y, prescribedTemperature.T) annotation (Line(points={{-77.5,23},
          {-68.75,23},{-68.75,20},{-62,20}}, color={0,0,127}));
  connect(proPreT.u2, propsBus_a.weaBus.dummy) annotation (Line(points={{-89,26},
          {-92,26},{-92,40},{100.1,40},{100.1,19.9}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
    connect(T, proPreT.u1)
    annotation (Line(points={{-106,20},{-106,20},{-89,20}},color={0,0,127}));
  end if;

  connect(layMul.port_b, prescribedHeatFlow.port) annotation (Line(points={{-10,0},
          {-10,0},{-20,0},{-20,-20},{-40,-20}},  color={191,0,0}));
  connect(prescribedTemperature.port, layMul.port_b) annotation (Line(points={{-40,20},
          {-20,20},{-20,0},{-10,0}},     color={191,0,0}));

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}})),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-60,-100},{60,100}}),
        graphics={
        Rectangle(
          extent={{-50,-90},{50,-70}},
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
        Line(
          points={{-50,80},{50,80}},
          color={175,175,175}),
        Line(
          points={{-50,-70},{50,-70}},
          color={175,175,175}),
        Line(
          points={{-50,-90},{50,-90}},
          color={175,175,175}),
        Line(
          points={{-50,100},{50,100}},
          color={175,175,175}),
        Rectangle(
          extent={{-10,80},{10,-70}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None),
        Line(
          points={{-10,80},{-10,-70}},
          smooth=Smooth.None,
          color={175,175,175}),
        Line(
          points={{10,80},{10,-70}},
          smooth=Smooth.None,
          color={0,0,0},
          thickness=0.5)}),
    Documentation(info="<html>
<p>
This is a wall model that should be used
to simulate a wall between a zone and a prescribed temperature or prescribed heat flow rate boundary condition.
See <a href=modelica://IDEAS.Buildings.Components.Interfaces.PartialOpaqueSurface>IDEAS.Buildings.Components.Interfaces.PartialOpaqueSurface</a> 
for equations, options, parameters, validation and dynamics that are common for all surfaces.
</p>
<h4>Main equations</h4>
<p>
Specific to this model is that the model does not contain a convection or radiative heat exchange model at the outside of the wall.
Instead a prescribed temperature or heat flow rate may be set.
</p>
<h4>Typical use and important parameters</h4>
<p>
Parameters <code>use_T_in</code> and <code>use_Q_in</code> may be used
to enable an input for a prescribed boundary condition temperature or heat flow rate.
It is not allowed to enabled both. 
If both are disabled then an adiabatic boundary (<code>Q_flow=0</code>) is assumed.
</p>
</html>", revisions="<html>
<ul>
<li>
March 22, 2017, by Filip Jorissen:<br/>
Changes for JModelica compatibility.
</li>
<li>
January 2, 2017, by Filip Jorissen:<br/>
Updated icon layer.
</li>
<li>
October 22, 2016, by Filip Jorissen:<br/>
Revised documentation for IDEAS 1.0.
</li>
<li>
December 7, 2016, by Damien Picard:<br/>
Set placeCapacityAtSurf_b to false for last layer of layMul when T_in is used and the sim.lineariseDymola is true.
Having a capacity connected directly to the prescribed temperature would require to have the derivative of T_in
when linearized.
The dynamics of the last layer is further set to dynamicFreeInitial when T_in is used to avoid an initialization problem.
</li>
<li>
March 8, 2016, by Filip Jorissen:<br/>
Fixed energyDynamics when using fixed temperature boundary condition input.
This is discussed in issue 462.
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
end BoundaryWall;
