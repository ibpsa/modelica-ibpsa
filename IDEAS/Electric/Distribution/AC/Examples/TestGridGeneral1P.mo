within IDEAS.Electric.Distribution.AC.Examples;
model TestGridGeneral1P
  import IDEAS;
  inner SimInfoManager       sim
    annotation (Placement(transformation(extent={{-80,74},{-60,94}})));
  IDEAS.Electric.Distribution.AC.Components.Grid_1P grid_1P(redeclare
      IDEAS.Electric.Data.Grids.TestGrid2Nodes grid)
    annotation (Placement(transformation(extent={{-6,-10},{14,10}})));
  inner IDEAS.SimInfoManager sim1
    annotation (Placement(transformation(extent={{-80,74},{-60,94}})));
  IDEAS.Electric.Distribution.AC.Examples.Components.SinePower sinePower
    annotation (Placement(transformation(extent={{58,-10},{78,10}})));
  IDEAS.Electric.BaseClasses.AC.Con1PlusNTo1 con1PlusNTo1_1
    annotation (Placement(transformation(extent={{28,-10},{48,10}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource
    voltageSource(
    f=50,
    V=230,
    phi=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-66,-10})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground
    annotation (Placement(transformation(extent={{-76,-54},{-56,-34}})));
equation
  connect(grid_1P.node[:, 2], con1PlusNTo1_1.twoWire) annotation (Line(
      points={{14,0},{28,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(con1PlusNTo1_1.oneWire[1], sinePower.nodes) annotation (Line(
      points={{48,0},{58,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(voltageSource.pin_p, grid_1P.GridConnection) annotation (Line(
      points={{-66,0},{-6,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(voltageSource.pin_n, grid_1P.Ground) annotation (Line(
      points={{-66,-20},{-6,-20},{-6,-4}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(voltageSource.pin_n, ground.pin) annotation (Line(
      points={{-66,-20},{-66,-34}},
      color={85,170,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end TestGridGeneral1P;
