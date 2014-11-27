within IDEAS.Fluid.BaseCircuits;
model FourPortExample

  PipeSection pipeSection
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  PipeSection pipeSection1(enableFourPort1=false)
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  PipeSection pipeSection2(enableFourPort1=false, enableFourPort2=false)
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end FourPortExample;
