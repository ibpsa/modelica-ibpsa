within IDEAS.LIDEAS.Validation;
model Case900LineariseInputs
  extends Case900Linearise;
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedQCon
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Blocks.Interfaces.RealInput QCon(start=100)
    annotation (Placement(transformation(extent={{-130,0},{-90,40}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedQRad
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Interfaces.RealInput QRad(start=100)
    annotation (Placement(transformation(extent={{-130,-20},{-90,20}})));
equation
  connect(prescribedQCon.Q_flow, QCon)
    annotation (Line(points={{-80,20},{-110,20}}, color={0,0,127}));
  connect(prescribedQRad.Q_flow, QRad)
    annotation (Line(points={{-80,0},{-96,0},{-110,0}},
                                                    color={0,0,127}));
  connect(prescribedQCon.port, linRecZon.gainCon) annotation (Line(points={{-60,
          20},{-50,20},{-40,20},{-40,54},{16,54},{16,67},{10,67}}, color={191,0,
          0}));
  connect(prescribedQRad.port, linRecZon.gainRad) annotation (Line(points={{-60,0},
          {-38,0},{-38,52},{18,52},{18,64},{10,64}},        color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),           __Dymola_Commands(file=
          "Scripts/linearize_Case900LineariseInputs.mos" "Linearise"),
    Documentation(revisions="<html>
<ul>
<li>May 15, 2018 by Damien Picard: <br>First implementation</li>
</ul>
</html>"));
end Case900LineariseInputs;
