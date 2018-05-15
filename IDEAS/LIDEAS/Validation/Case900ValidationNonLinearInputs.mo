within IDEAS.LIDEAS.Validation;
model Case900ValidationNonLinearInputs
  extends Case900ValidationNonLinear(preInp(y={winBusOut[1].AbsQFlow[1],
          winBusOut[1].AbsQFlow[2],winBusOut[1].AbsQFlow[3],winBusOut[1].iSolDir,
          winBusOut[1].iSolDif,weaBusOut.solTim,weaBusOut.solBus[1].HDirTil,
          weaBusOut.solBus[1].HSkyDifTil,weaBusOut.solBus[1].HGroDifTil,
          weaBusOut.solBus[1].Tenv,weaBusOut.solBus[2].HDirTil,weaBusOut.solBus[
          2].HSkyDifTil,weaBusOut.solBus[2].HGroDifTil,weaBusOut.solBus[2].Tenv,
          weaBusOut.solBus[3].HDirTil,weaBusOut.solBus[3].HSkyDifTil,weaBusOut.solBus[
          3].HGroDifTil,weaBusOut.solBus[3].Tenv,weaBusOut.solBus[4].HDirTil,
          weaBusOut.solBus[4].HSkyDifTil,weaBusOut.solBus[4].HGroDifTil,
          weaBusOut.solBus[4].Tenv,weaBusOut.solBus[5].HDirTil,weaBusOut.solBus[
          5].HSkyDifTil,weaBusOut.solBus[5].HGroDifTil,weaBusOut.solBus[5].Tenv,
          weaBusOut.solBus[6].HDirTil,weaBusOut.solBus[6].HSkyDifTil,weaBusOut.solBus[
          6].HGroDifTil,weaBusOut.solBus[6].Tenv,weaBusOut.Te,weaBusOut.Tdes,
          weaBusOut.TGroundDes,weaBusOut.hConExt,weaBusOut.X_wEnv,weaBusOut.CEnv,
          weaBusOut.dummy,weaBusOut.TskyPow4,weaBusOut.TePow4,weaBusOut.solGloHor,
          weaBusOut.solDifHor,weaBusOut.F1,weaBusOut.F2,weaBusOut.angZen,
          weaBusOut.angHou,weaBusOut.angDec,weaBusOut.solDirPer,weaBusOut.phi,
          QCon.y,QRad.y}), fileName="ssm_Case900LineariseInputs.mat");
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedQCon
    annotation (Placement(transformation(extent={{-68,10},{-48,30}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedQRad
    annotation (Placement(transformation(extent={{-68,-30},{-48,-10}})));
public
  Modelica.Blocks.Sources.Sine QCon(
    freqHz=1/1/3600,
    amplitude=30,
    offset=30) "Fake convective gains"
    annotation (Placement(transformation(extent={{-100,14},{-88,26}})));
public
  Modelica.Blocks.Sources.Sine QRad(
    amplitude=30,
    offset=30,
    freqHz=1/6/3600) "Fake radiative gains"
    annotation (Placement(transformation(extent={{-100,-26},{-88,-14}})));
  Modelica.Blocks.Math.Gain gain(k=1)
    annotation (Placement(transformation(extent={{-82,16},{-74,24}})));
  Modelica.Blocks.Math.Gain gain1(k=1)
    annotation (Placement(transformation(extent={{-82,-24},{-74,-16}})));
equation
  connect(prescribedQCon.port, linRecZon.gainCon) annotation (Line(points={{-48,
          20},{-48,20},{-44,20},{-44,54},{12,54},{12,67},{10,67}}, color={191,0,
          0}));
  connect(prescribedQRad.port, linRecZon.gainRad) annotation (Line(points={{-48,
          -20},{-42,-20},{-42,52},{14,52},{14,64},{10,64}}, color={191,0,0}));
  connect(prescribedQCon.port, recZon.gainCon) annotation (Line(points={{-48,20},
          {-44,20},{-44,-82},{16,-82},{16,-73},{10,-73}}, color={191,0,0}));
  connect(prescribedQRad.port, recZon.gainRad) annotation (Line(points={{-48,-20},
          {-42,-20},{-42,-84},{18,-84},{18,-76},{10,-76}}, color={191,0,0}));
  connect(QCon.y, gain.u) annotation (Line(points={{-87.4,20},{-86,20},{-82.8,20}},
        color={0,0,127}));
  connect(gain.y, prescribedQCon.Q_flow)
    annotation (Line(points={{-73.6,20},{-70,20},{-68,20}}, color={0,0,127}));
  connect(QRad.y, gain1.u)
    annotation (Line(points={{-87.4,-20},{-82.8,-20}}, color={0,0,127}));
  connect(gain1.y, prescribedQRad.Q_flow)
    annotation (Line(points={{-73.6,-20},{-68,-20}}, color={0,0,127}));
end Case900ValidationNonLinearInputs;
