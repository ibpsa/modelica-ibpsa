within IBPSA.Electrical.DC.Sources.Validation;
model PVSingleDiodeRooftopBuildingValidation
  "Validation of the single-diode model with empirical data from a rooftop PV system with CIGS modules at UdK, Berlin"
  extends
    IBPSA.Electrical.DC.Sources.Validation.BaseClasses.partialPVRooftopBuildingValidation(
    HGloTil(H(start=100)));
  extends Modelica.Icons.Example;

  IBPSA.Electrical.DC.Sources.PVSingleDiode pVSystemSingleDiode(
    PVTechType=IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThinFilmSI,
    use_Til_in=false,
    til(displayUnit="rad") = til,
    n_mod=3,
    redeclare IBPSA.Electrical.Data.PV.SingleDiodeSolibroSL2CIGS110 data,
    groRef=rho,
    alt=0.08,
    redeclare IBPSA.Electrical.BaseClasses.PV.PVThermalEmpMountCloseToGround
      PVThermal)
    annotation (Placement(transformation(extent={{64,0},{92,20}})));

  PVSingleDiode                             pVSystemSingleDiode1(
    PVTechType=IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThinFilmSI,
    use_Til_in=false,
    til(displayUnit="rad") = til,
    n_mod=3,
    redeclare IBPSA.Electrical.Data.PV.SingleDiodeSolibroSL2CIGS110 data,
    groRef=rho,
    alt=0.08,
    redeclare IBPSA.Electrical.BaseClasses.PV.PVThermalEmpMountCloseToGround
      PVThermal)
    annotation (Placement(transformation(extent={{52,56},{86,84}})));

  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{80,32},{90,42}})));
equation
  connect(HGloTil.H, pVSystemSingleDiode.HGloTil) annotation (Line(points={{41,50},
          {60.5,50},{60.5,4}},                color={0,0,127}));
  connect(MeaDatHGloHor.y[1], pVSystemSingleDiode.HGloHor) annotation (Line(
        points={{-79,-90},{-16,-90},{-16,-84},{44,-84},{44,48},{60.5,48},{60.5,7}},
                  color={0,0,127}));
  connect(souGloHorDif.y, pVSystemSingleDiode.HDifHor) annotation (Line(points={{-79,-24},
          {-60,-24},{-60,80},{60.5,80},{60.5,1}},
                  color={0,0,127}));
  connect(incAng.y, pVSystemSingleDiode.incAngle) annotation (Line(points={{38.8,
          -10},{52,-10},{52,32},{88,32},{88,16},{60.5,16}},
                                                        color={0,0,127}));
  connect(zen.y, pVSystemSingleDiode.zenAngle) annotation (Line(points={{41,-50},
          {60,-50},{60,-34},{96,-34},{96,19},{60.5,19}}, color={0,0,127}));
  connect(from_degC.y, pVSystemSingleDiode.TDryBul) annotation (Line(points={{-41.2,
          -50},{0,-50},{0,20},{40,20},{40,34},{68,34},{68,10},{60.5,10}},
        color={0,0,127}));
  connect(MeaDatWinAngSpe.y[2], pVSystemSingleDiode.vWinSpe) annotation (Line(
        points={{-79,10},{-56,10},{-56,40},{60.5,40},{60.5,13}}, color={0,0,127}));
  connect(add.y, PDCSim) annotation (Line(points={{90.5,37},{90.5,36},{96,36},{
          96,40},{110,40}}, color={0,0,127}));
  connect(pVSystemSingleDiode1.PDC, add.u1) annotation (Line(points={{88.125,70},
          {86,70},{86,46},{74,46},{74,40},{79,40}}, color={0,0,127}));
  connect(pVSystemSingleDiode.PDC, add.u2) annotation (Line(points={{93.75,10},
          {92,10},{92,24},{79,24},{79,34}}, color={0,0,127}));
  connect(zen.y, pVSystemSingleDiode1.zenAngle) annotation (Line(points={{41,
          -50},{40,-50},{40,-36},{48,-36},{48,52},{42,52},{42,64},{40,64},{40,
          82},{47.75,82},{47.75,82.6}}, color={0,0,127}));
  connect(incAng.y, pVSystemSingleDiode1.incAngle) annotation (Line(points={{
          38.8,-10},{46,-10},{46,52},{42,52},{42,78.4},{47.75,78.4}}, color={0,
          0,127}));
  connect(MeaDatWinAngSpe.y[2], pVSystemSingleDiode1.vWinSpe) annotation (Line(
        points={{-79,10},{-58,10},{-58,74.2},{47.75,74.2}}, color={0,0,127}));
  connect(from_degC.y, pVSystemSingleDiode1.TDryBul) annotation (Line(points={{
          -41.2,-50},{-41.2,-6},{-44,-6},{-44,18},{-46,18},{-46,70},{47.75,70}},
        color={0,0,127}));
  connect(MeaDatHGloHor.y[1], pVSystemSingleDiode1.HGloHor) annotation (Line(
        points={{-79,-90},{-60,-90},{-60,-80},{-16,-80},{-16,-84},{44,-84},{44,
          36},{18,36},{18,42},{14,42},{14,65.8},{47.75,65.8}}, color={0,0,127}));
  connect(HGloTil.H, pVSystemSingleDiode1.HGloTil) annotation (Line(points={{41,
          50},{41,54},{47.75,54},{47.75,61.6}}, color={0,0,127}));
  connect(souGloHorDif.y, pVSystemSingleDiode1.HDifHor) annotation (Line(points=
         {{-79,-24},{-60,-24},{-60,0},{-50,0},{-50,42},{16,42},{16,57.4},{47.75,
          57.4}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{100,
            100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{
            100,100}})),
    experiment(
      StartTime=18057600,
      StopTime=19094400,
      Interval=300,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
   __Dymola_Commands(file=
          "modelica://IBPSA/Resources/Scripts/Dymola/Electrical/DC/Sources/Validation/PVSingleDiodeRooftopBuildingValidation.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>The PVSystem single-diode model is validaded with empirical data from the Rooftop solar builidng of UdK Berlin: <a href=\"http://www.solar-rooftop.de/\">http://www.solar-rooftop.de/</a> </p>
<p>The dates 28.07.2023 to 09.08.2023 were chosen as an example for the PVSystem model. </p>
<p>The validation model proves that single-diode PV models tend to overestimate the power output.</p>
<p>This is due to the neglection of staining, shading, other loss effects.</p>
</html>",revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_experimentSetupOutput(events=false));
end PVSingleDiodeRooftopBuildingValidation;
