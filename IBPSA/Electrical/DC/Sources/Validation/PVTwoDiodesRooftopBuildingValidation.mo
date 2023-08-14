within IBPSA.Electrical.DC.Sources.Validation;
model PVTwoDiodesRooftopBuildingValidation
  "Validation with empirical data from a rooftop PV system with CIGS modules at UdK, Berlin"
  extends Modelica.Icons.Example;
  extends
    IBPSA.Electrical.DC.Sources.Validation.BaseClasses.partialPVRooftopBuildingValidation(
      MeaDatHGloHor(shiftTime=nDay));
  IBPSA.Electrical.DC.Sources.PVTwoDiodes pVSystemTwoDiodes(
    PVTechType=IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThinFilmSI,
    til=til,
    redeclare IBPSA.Electrical.BaseClasses.PV.PVThermalEmpMountCloseToGround
      PVThermal,
    n_mod=6,
    redeclare IBPSA.Electrical.Data.PV.TwoDiodesSolibroSL2CIGS110 data,
    groRef=rho,
    alt=0.08)
    annotation (Placement(transformation(extent={{62,20},{82,40}})));

equation
  connect(HGloTil.H, pVSystemTwoDiodes.HGloTil)
    annotation (Line(points={{41,50},{59.5,50},{59.5,24}},
                                                         color={0,0,127}));
  connect(pVSystemTwoDiodes.PDC, PDCSim)
    annotation (Line(points={{83.25,30},{110,30}}, color={0,0,127}));
  connect(MeaDatHGloHor.y[1], pVSystemTwoDiodes.HGloHor) annotation (Line(
        points={{-79,-90},{-60,-90},{-60,-80},{-40,-80},{-40,-40},{-38,-40},{
          -38,-6},{-42,-6},{-42,40},{50,40},{50,48},{59.5,48},{59.5,27}},
        color={0,0,127}));
  connect(zen.y, pVSystemTwoDiodes.zenAngle) annotation (Line(points={{41,-50},
          {46,-50},{46,50},{86,50},{86,39},{59.5,39}},    color={0,0,127}));
  connect(souGloHorDif.y, pVSystemTwoDiodes.HDifHor) annotation (Line(points={{-79,-24},
          {-48,-24},{-48,2},{-42,2},{-42,26},{-40,26},{-40,38},{52,38},{52,44},
          {56,44},{56,21},{59.5,21}},             color={0,0,127}));

  connect(incAng.y, pVSystemTwoDiodes.incAngle) annotation (Line(points={{38.8,
          -10},{54,-10},{54,46},{74,46},{74,48},{59.5,48},{59.5,36}},
        color={0,0,127}));
  connect(from_degC.y, pVSystemTwoDiodes.TDryBul) annotation (Line(points={{-41.2,
          -50},{-42,-50},{-42,-6},{-44,-6},{-44,38},{44,38},{44,52},{59.5,52},{
          59.5,30}},
        color={0,0,127}));
  connect(MeaDatWinAngSpe.y[2], pVSystemTwoDiodes.vWinSpe) annotation (Line(
        points={{-79,10},{-79,10},{-42,10},{-42,36},{42,36},{42,54},{59.5,54},{
          59.5,33}},
                  color={0,0,127}));
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
          "modelica://IBPSA/Resources/Scripts/Dymola/Electrical/DC/Sources/Validation/PVTwoDiodesRooftopBuildingValidation.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>The PVSystem single-diode model is validaded with empirical data from the Rooftop solar builidng of UdK Berlin: <a href=\"http://www.solar-rooftop.de/\">http://www.solar-rooftop.de/</a> </p>
<p>The dates 28.07.2023 to 09.08.2023 were chosen as an example for the PVSystem model. </p>
<p>The validation model proves that two-diode PV models tend to overestimate the power output.</p>
<p>This is due to the neglection of staining, shading, other loss effects.</p>
</html>",revisions="<html>
<ul>
<li>
March 30, 2023, by Christoph Nytsch-Geusen:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_experimentSetupOutput(events=false));
end PVTwoDiodesRooftopBuildingValidation;
