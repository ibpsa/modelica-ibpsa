within IDEAS.Fluid.FixedResistances;
model Pipe_HeatPort "Pipe with HeatPort"

  extends IDEAS.Fluid.Interfaces.Partials.PipeTwoPort(vol(
        prescribedHeatFlowRate=prescribedHeatFlowRate));

  parameter Boolean prescribedHeatFlowRate=false
    "Set to true if the model has a prescribed heat flow at its heatPort"
   annotation(Evaluate=true, Dialog(tab="Assumptions",
      group="Heat transfer"));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Port for heat exchange with mixing volume" annotation (Placement(
        transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-10,90},
            {10,110}})));

equation
  connect(heatPort,heatPort)  annotation (Line(
      points={{0,100},{0,100}},
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
  connect(vol.heatPort, heatPort) annotation (Line(
      points={{-44,10},{0,10},{0,100}},
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
            100}}),                                                                              graphics={                                                          Polygon(          points={{
              -10,-35},{-10,15},{0,35},{10,15},{10,-35},{-10,-35}},                                                                                                    lineColor={255,0,0},
            fillPattern =                                                                                                   FillPattern.Forward,          fillColor={255,255,255},
          origin={0,55},
          rotation=180),                                                                                                    Rectangle(          extent={{-100,20},{100,-20}},          lineColor={255,255,255},          fillColor={85,170,255},
            fillPattern =                                                                                                   FillPattern.HorizontalCylinder)}),    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),                                                                                                    graphics));
end Pipe_HeatPort;
