within IBPSA.Electrical.DC.Sources.Validation;
model PVSingleDiodeRooftopBuildingValidation
  "Validation of the single-diode model with empirical data from a rooftop PV system with CIGS modules at UdK, Berlin"
  extends
    IBPSA.Electrical.DC.Sources.Validation.BaseClasses.partialPVRooftopBuildingValidation(
    HGloTil(H(start=100)));
  extends Modelica.Icons.Example;

  PVSingleDiode pVSys1Dio115Wp(
    PVTecTyp=IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThinFilmSI,
    use_Til_in=false,
    til(displayUnit="rad") = til,
    nMod=2,
    redeclare IBPSA.Electrical.Data.PV.SingleDiodeSolibroSL2CIGS115 dat,
    groRef=rho,
    alt=0.08,
    redeclare IBPSA.Electrical.BaseClasses.PV.PVThermalEmpMountCloseToGround
      PVThe) "PV modules with a peak power of 115 Wp"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  PVSingleDiode pVSys1Dio120Wp(
    PVTecTyp=IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThinFilmSI,
    use_Til_in=false,
    til(displayUnit="rad") = til,
    nMod=4,
    redeclare IBPSA.Electrical.Data.PV.SingleDiodeSolibroSL2CIGS120 dat,
    groRef=rho,
    alt=0.08,
    redeclare IBPSA.Electrical.BaseClasses.PV.PVThermalEmpMountCloseToGround
      PVThe) "PV modules with a peak power of 120 Wp"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Modelica.Blocks.Math.Add add "Adds both module DC power outputs"
    annotation (Placement(transformation(extent={{86,24},{96,34}})));
equation
  connect(HGloTil.H, pVSys1Dio115Wp.HGloTil) annotation (Line(points={{21,50},{50,
          50},{50,24},{58,24}}, color={0,0,127}));
  connect(MeaDatHGloHor.y[1], pVSys1Dio115Wp.HGloHor) annotation (Line(points={{
          -79,-90},{-16,-90},{-16,-84},{44,-84},{44,27},{58,27}}, color={0,0,127}));
  connect(from_degC.y, pVSys1Dio115Wp.TDryBul) annotation (Line(points={{-39,-50},
          {-34,-50},{-34,26},{46,26},{46,30},{58,30}}, color={0,0,127}));
  connect(MeaDatWinAngSpe.y[2], pVSys1Dio115Wp.vWinSpe) annotation (Line(points=
         {{-79,10},{-68,10},{-68,84},{46,84},{46,33},{58,33}}, color={0,0,127}));
  connect(add.y, PDCSim) annotation (Line(points={{96.5,29},{96.5,30},{110,30}},
                            color={0,0,127}));
  connect(pVSys1Dio120Wp.PDC, add.u1)
    annotation (Line(points={{81,70},{85,70},{85,32}}, color={0,0,127}));
  connect(pVSys1Dio115Wp.PDC, add.u2)
    annotation (Line(points={{81,30},{81,26},{85,26}}, color={0,0,127}));
  connect(zen.y, pVSys1Dio120Wp.zenAng) annotation (Line(points={{1,-50},{14,-50},
          {14,-22},{34,-22},{34,38},{52,38},{52,70},{70,70}}, color={0,0,127}));
  connect(incAng.y, pVSys1Dio120Wp.incAng) annotation (Line(points={{21,-10},{52,
          -10},{52,70},{70,70}}, color={0,0,127}));
  connect(MeaDatWinAngSpe.y[2], pVSys1Dio120Wp.vWinSpe) annotation (Line(points=
         {{-79,10},{-68,10},{-68,84},{46,84},{46,73},{58,73}}, color={0,0,127}));
  connect(from_degC.y, pVSys1Dio120Wp.TDryBul) annotation (Line(points={{-39,-50},
          {-34,-50},{-34,26},{46,26},{46,30},{52,30},{52,70},{58,70}}, color={0,
          0,127}));
  connect(MeaDatHGloHor.y[1], pVSys1Dio120Wp.HGloHor) annotation (Line(points={{
          -79,-90},{-16,-90},{-16,-84},{44,-84},{44,26},{52,26},{52,67},{58,67}},
        color={0,0,127}));
  connect(HGloTil.H, pVSys1Dio120Wp.HGloTil) annotation (Line(points={{21,50},{50,
          50},{50,64},{58,64}}, color={0,0,127}));
  connect(souDifHor.y, pVSys1Dio120Wp.HDifHor) annotation (Line(points={{-79,-24},
          {-74,-24},{-74,88},{-66,88},{-66,76},{54,76},{54,61},{58,61}}, color=
          {0,0,127}));
  connect(incAng.y, pVSys1Dio115Wp.incAng) annotation (Line(points={{21,-10},{52,
          -10},{52,30},{70,30}}, color={0,0,127}));
  connect(zen.y, pVSys1Dio115Wp.zenAng) annotation (Line(points={{1,-50},{14,-50},
          {14,-22},{34,-22},{34,30},{70,30}}, color={0,0,127}));
  connect(souDifHor.y, pVSys1Dio115Wp.HDifHor) annotation (Line(points={{-79,-24},
          {-74,-24},{-74,88},{-66,88},{-66,76},{54,76},{54,21},{58,21}}, color=
          {0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{100,
            100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{
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
