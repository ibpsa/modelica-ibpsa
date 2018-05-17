within IDEAS.Fluid.FixedResistances;
model InsulatedPipe "Insulated pipe characterized by a UA value"

  extends IDEAS.Fluid.Interfaces.Partials.PipeTwoPort(vol(
        prescribedHeatFlowRate=prescribedHeatFlowRate));

  parameter Boolean prescribedHeatFlowRate=false
    "Set to true if the model has a prescribed heat flow at its heatPort"
   annotation(Evaluate=true, Dialog(tab="Assumptions",
      group="Heat transfer"));
  parameter SI.ThermalConductance UA "Thermal conductance of the insulation";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Port for heat exchange with mixing volume" annotation (Placement(
        transformation(extent={{-10,30},{10,50}}),  iconTransformation(extent={{-10,30},
            {10,50}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=
        UA) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-18,20})));
equation
  connect(heatPort,heatPort)  annotation (Line(
      points={{0,40},{0,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol.ports[2], res.port_a) annotation (Line(
      points={{-54,0},{4,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res.port_b, port_b) annotation (Line(
      points={{24,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPort, thermalConductor.port_a) annotation (Line(
      points={{0,40},{0,20},{-8,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol.heatPort, thermalConductor.port_b) annotation (Line(
      points={{-44,10},{-40,10},{-40,20},{-28,20}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>2014 March, Filip Jorissen, Annex60 compatibility</li>
<li>2013 May 23, Roel De Coninck, documentation;</li>
<li>2012 November, Roel De Coninck, first implementation. </li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}),                                                                              graphics={
        Line(
          points={{-68,20},{-68,-20}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{68,20},{68,-20}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-68,0},{-100,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{68,0},{100,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Rectangle(
          extent={{-60,20},{60,-20}},
          lineColor={100,100,100},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                                                                                                    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),                                                                                                    graphics));
end InsulatedPipe;
