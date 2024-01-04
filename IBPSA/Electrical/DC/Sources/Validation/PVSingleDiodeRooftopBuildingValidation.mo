within IBPSA.Electrical.DC.Sources.Validation;
model PVSingleDiodeRooftopBuildingValidation
  "Validation of the single-diode model with empirical data from a rooftop PV system with CIGS modules at UdK, Berlin"
  extends
    IBPSA.Electrical.DC.Sources.Validation.BaseClasses.partialPVValidation(
    HGloTil(H(start=100)), weaDat(filNam=
          ModelicaServices.ExternalReferences.loadResource(
          "modelica://IBPSA/Resources/Data/Electrical/DC/Sources/Validation/Weather_Berlin_rooftop.mos")));
  extends Modelica.Icons.Example;

  PVSingleDiode pVSys1Dio115Wp(
    PVTecTyp=IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThinFilmSI,
    use_ter=false,
    use_Til_in=false,
    til(displayUnit="rad") = til,
    nMod=2,
    redeclare IBPSA.Electrical.Data.PV.SingleDiodeSolibroSL2CIGS115 dat,
    groRef=rho,
    alt=0.08,
    redeclare IBPSA.Electrical.BaseClasses.PV.PVThermalEmpMountCloseToGround
      PVThe) "PV modules with a peak power of 115 Wp"
    annotation (Placement(transformation(extent={{60,18},{80,42}})));

  PVSingleDiode pVSys1Dio120Wp(
    PVTecTyp=IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThinFilmSI,
    use_ter=false,
    use_Til_in=false,
    til(displayUnit="rad") = til,
    nMod=4,
    redeclare IBPSA.Electrical.Data.PV.SingleDiodeSolibroSL2CIGS120 dat,
    groRef=rho,
    alt=0.08,
    redeclare IBPSA.Electrical.BaseClasses.PV.PVThermalEmpMountCloseToGround
      PVThe) "PV modules with a peak power of 120 Wp"
    annotation (Placement(transformation(extent={{60,58},{80,82}})));

  Modelica.Blocks.Math.Add add "Adds both module DC power outputs"
    annotation (Placement(transformation(extent={{86,44},{96,54}})));

  Modelica.Blocks.Interfaces.RealOutput TModMea(final unit="degC") "Measure module temperature"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  Modelica.Blocks.Sources.CombiTimeTable MeaDatPVPDC(
    tableOnFile=true,
    tableName="meaPV",
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://IBPSA/Resources/Data/Electrical/DC/Sources/Validation/Measurement_data_rooftop_PV_validation.txt"),
    columns={2,3},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    shiftTime=nDay - 1800)
    "This file contains the DC power output of two selected modules. The PVSystem model is validaded with measurement data from Rooftop building: http://www.solar-rooftop.de."
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));

  Modelica.Blocks.Interfaces.RealOutput PDCMea(final unit="W")
    "Measured DC power"
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
equation
  connect(HGloTil.H, pVSys1Dio115Wp.HGloTil) annotation (Line(points={{-19,70},{
          50,70},{50,21},{58,21}},
                                color={0,0,127}));
  connect(zen.y, pVSys1Dio120Wp.zenAng) annotation (Line(points={{1,-50},{50,
          -50},{50,78},{58,78}},                              color={0,0,127}));
  connect(incAng.y, pVSys1Dio120Wp.incAng) annotation (Line(points={{-19,30},{50,
          30},{50,75},{58,75}},  color={0,0,127}));
  connect(HGloTil.H, pVSys1Dio120Wp.HGloTil) annotation (Line(points={{-19,70},{
          50,70},{50,61},{58,61}},
                                color={0,0,127}));
  connect(incAng.y, pVSys1Dio115Wp.incAng) annotation (Line(points={{-19,30},{50,
          30},{50,35},{58,35}},  color={0,0,127}));
  connect(zen.y, pVSys1Dio115Wp.zenAng) annotation (Line(points={{1,-50},{50,
          -50},{50,38},{58,38}},              color={0,0,127}));
  connect(weaBus.HDifHor, pVSys1Dio115Wp.HDifHor) annotation (Line(
      points={{-59.95,-9.95},{-6,-9.95},{-6,-10},{46,-10},{46,18},{58,18}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.HDifHor, pVSys1Dio120Wp.HDifHor) annotation (Line(
      points={{-59.95,-9.95},{-18,-9.95},{-18,-10},{46,-10},{46,58},{58,58}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TDryBul, pVSys1Dio120Wp.TDryBul) annotation (Line(
      points={{-59.95,-9.95},{-59.95,30},{-60,30},{-60,48},{50,48},{50,68},{56,68},
          {56,67},{58,67}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TDryBul, pVSys1Dio115Wp.TDryBul) annotation (Line(
      points={{-59.95,-9.95},{-60,-9.95},{-60,48},{50,48},{50,28},{58,28},{58,27}},
      color={255,204,51},
      thickness=0.5));

  connect(weaBus.HGloHor, pVSys1Dio120Wp.HGloHor) annotation (Line(
      points={{-59.95,-9.95},{-59.95,20},{-60,20},{-60,48},{50,48},{50,64},{58,64}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.HGloHor, pVSys1Dio115Wp.HGloHor) annotation (Line(
      points={{-59.95,-9.95},{-60,-9.95},{-60,48},{50,48},{50,24},{58,24}},
      color={255,204,51},
      thickness=0.5));

  connect(weaBus.winSpe, pVSys1Dio115Wp.vWinSpe) annotation (Line(
      points={{-59.95,-9.95},{-44,-9.95},{-44,-10},{-60,-10},{-60,48},{50,48},{50,
          32},{58,32}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.winSpe, pVSys1Dio120Wp.vWinSpe) annotation (Line(
      points={{-59.95,-9.95},{-59.95,36},{-60,36},{-60,48},{50,48},{50,72},{58,72}},
      color={255,204,51},
      thickness=0.5));
  connect(pVSys1Dio120Wp.PDC, add.u1)
    annotation (Line(points={{81,70},{82,70},{82,52},{85,52}},
                                                       color={0,0,127}));
  connect(add.y, PDCSim) annotation (Line(points={{96.5,49},{103.25,49},{103.25,
          50},{110,50}}, color={0,0,127}));
  connect(pVSys1Dio115Wp.PDC, add.u2)
    annotation (Line(points={{81,30},{82,30},{82,46},{85,46}},
                                                       color={0,0,127}));
  connect(MeaDatPVPDC.y[2], TModMea) annotation (Line(points={{81,-10},{88,-10},
          {88,-50},{110,-50}}, color={0,0,127}));
  connect(MeaDatPVPDC.y[1], PDCMea)
    annotation (Line(points={{81,-10},{110,-10}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{100,
            100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(
      StartTime=18057600,
      StopTime=19094400,
      Interval=300,
      Tolerance=1e-06),
   __Dymola_Commands(file=
          "modelica://IBPSA/Resources/Scripts/Dymola/Electrical/DC/Sources/Validation/PVSingleDiodeRooftopBuildingValidation.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>The PVSystem single-diode model is validaded with empirical data from the Rooftop solar builidng of UdK Berlin: <a href=\"http://www.solar-rooftop.de/\">http://www.solar-rooftop.de/</a> </p>
<p>The dates 29.07.2023 to 09.08.2023 were chosen as an example for the PVSystem model. </p>
<p>The system consists of four modules with 120 Wp and two modules with 115 Wp. </p>
<p>The validation model proves that single-diode PV models tend to overestimate the power output.</p>
<p>This is due to the neglection of staining, shading, other loss effects.</p>
</html>",revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PVSingleDiodeRooftopBuildingValidation;
