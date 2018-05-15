within IDEAS.LIDEAS.Examples;
model ZoneWithInputsCreateOutputs
  extends ZoneWithInputsLinearise(sim(lineariseDymola=false, createOutputs=true));
  Modelica.Blocks.Sources.Sine occQRad[2](
    freqHz=1/12/3600,
    startTime=7200,
    amplitude=20,
    offset=20) "Fake occupancy gains"
    annotation (Placement(transformation(extent={{40,-144},{60,-124}})));
  Modelica.Blocks.Sources.Sine occQCon[2](
    freqHz=1/6/3600,
    amplitude=60,
    offset=60) "fake occupancy gains"
    annotation (Placement(transformation(extent={{40,-114},{60,-94}})));
  output Components.BaseClasses.Prescribed prescribedOut
    "Prescribed inputs which do not depend on the model states value (e.g. heat flow from occupancy)"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={100,-120})));
  Modelica.Blocks.Sources.RealExpression realExpression[52](y={winBusOut[1].AbsQFlow[
        1],winBusOut[1].AbsQFlow[2],winBusOut[1].AbsQFlow[3],winBusOut[1].iSolDir,
        winBusOut[1].iSolDif,weaBusOut.solTim,weaBusOut.solBus[1].HDirTil,
        weaBusOut.solBus[1].HSkyDifTil,weaBusOut.solBus[1].HGroDifTil,weaBusOut.solBus[
        1].Tenv,weaBusOut.solBus[2].HDirTil,weaBusOut.solBus[2].HSkyDifTil,
        weaBusOut.solBus[2].HGroDifTil,weaBusOut.solBus[2].Tenv,weaBusOut.solBus[
        3].HDirTil,weaBusOut.solBus[3].HSkyDifTil,weaBusOut.solBus[3].HGroDifTil,
        weaBusOut.solBus[3].Tenv,weaBusOut.solBus[4].HDirTil,weaBusOut.solBus[4].HSkyDifTil,
        weaBusOut.solBus[4].HGroDifTil,weaBusOut.solBus[4].Tenv,weaBusOut.solBus[
        5].HDirTil,weaBusOut.solBus[5].HSkyDifTil,weaBusOut.solBus[5].HGroDifTil,
        weaBusOut.solBus[5].Tenv,weaBusOut.solBus[6].HDirTil,weaBusOut.solBus[6].HSkyDifTil,
        weaBusOut.solBus[6].HGroDifTil,weaBusOut.solBus[6].Tenv,weaBusOut.Te,
        weaBusOut.Tdes,weaBusOut.TGroundDes,weaBusOut.hConExt,weaBusOut.X_wEnv,
        weaBusOut.CEnv,weaBusOut.dummy,weaBusOut.TskyPow4,weaBusOut.TePow4,
        weaBusOut.solGloHor,weaBusOut.solDifHor,weaBusOut.F1,weaBusOut.F2,
        weaBusOut.angZen,weaBusOut.angHou,weaBusOut.angDec,weaBusOut.solDirPer,
        weaBusOut.phi,prescribedOut.QCon[1],prescribedOut.QCon[2],prescribedOut.QRad[
        1],prescribedOut.QRad[2]})
    annotation (Placement(transformation(extent={{-10,80},{10,100}})));
equation
  connect(occQCon.y, prescribedOut.QCon) annotation (Line(points={{61,-104},{80,
          -104},{100.1,-104},{100.1,-120.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(occQRad.y, prescribedOut.QRad) annotation (Line(points={{61,-134},{82,
          -134},{100.1,-134},{100.1,-120.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  annotation (Diagram(coordinateSystem(extent={{-100,-160},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-160},{100,100}})),          __Dymola_Commands(file=
          "Scripts/createOutputs_zoneWithInputsCreateOutputs.mos" "Create outputs"));
end ZoneWithInputsCreateOutputs;
