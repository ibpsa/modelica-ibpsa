within IBPSA.Electrical.DC.Sources.Validation;
model PVTwoDiodesRooftopBuildingValidation
  "Validation of the two-diodes PV model with empirical data from a rooftop PV system with CIGS modules at UdK, Berlin"
  extends Modelica.Icons.Example;
  extends
    IBPSA.Electrical.DC.Sources.Validation.BaseClasses.partialPVRooftopBuildingValidation;
  IBPSA.Electrical.DC.Sources.PVTwoDiodes pVSystemTwoDiodes(
    PVTechType=IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThinFilmSI,
    til=til,
    n_mod=6,
    redeclare IBPSA.Electrical.Data.PV.TwoDiodesSolibroSL2CIGS110 data,
    groRef=rho,
    alt=0.08,
    redeclare IBPSA.Electrical.BaseClasses.PV.PVThermalEmpMountCloseToGround
      PVThermal)
    annotation (Placement(transformation(extent={{64,0},{84,20}})));

equation

  connect(pVSystemTwoDiodes.PDC, PDCSim) annotation (Line(points={{85.25,10},{96,
          10},{96,40},{110,40}}, color={0,0,127}));
  connect(zen.y, pVSystemTwoDiodes.zenAngle) annotation (Line(points={{41,-50},{
          52,-50},{52,19},{61.5,19}}, color={0,0,127}));
  connect(incAng.y, pVSystemTwoDiodes.incAngle) annotation (Line(points={{38.8,-10},
          {54,-10},{54,16},{61.5,16}}, color={0,0,127}));
  connect(MeaDatWinAngSpe.y[2], pVSystemTwoDiodes.vWinSpe) annotation (Line(
        points={{-79,10},{-46,10},{-46,24},{48,24},{48,13},{61.5,13}}, color={0,
          0,127}));
  connect(MeaDatHGloHor.y[1], pVSystemTwoDiodes.HGloHor) annotation (Line(
        points={{-79,-90},{-60,-90},{-60,-80},{-20,-80},{-20,-24},{14,-24},{14,7},
          {61.5,7}}, color={0,0,127}));
  connect(souGloHorDif.y, pVSystemTwoDiodes.HDifHor) annotation (Line(points={{-79,
          -24},{-16,-24},{-16,-22},{61.5,-22},{61.5,1}}, color={0,0,127}));
  connect(HGloTil.H, pVSystemTwoDiodes.HGloTil) annotation (Line(points={{41,50},
          {52,50},{52,20},{54,20},{54,4},{61.5,4}}, color={0,0,127}));
  connect(from_degC.y, pVSystemTwoDiodes.TDryBul) annotation (Line(points={{-41.2,
          -50},{-41.2,-6},{-44,-6},{-44,22},{46,22},{46,10},{61.5,10}}, color={0,
          0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{100,
            100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{
            100,100}})),
    experiment(
      StartTime=12182400,
      StopTime=13046400,
      Interval=900,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
   __Dymola_Commands(file=
          "modelica://IBPSA/Resources/Scripts/Dymola/Electrical/DC/Sources/Validation/PVTwoDiodesRooftopBuildingValidation.mos"
        "Simulate and plot"),
    Documentation(info="<html>
    <p>The PVSystem 2 diode model is validaded with empirical data from the Rooftop solar builidng of UdK Berlin: <a href=\"http://www.solar-rooftop.de/\">http://www.solar-rooftop.de/</a> </p>
<p>The date 18.04.2023 was chosen as an example for the PVSystem model. </p>
</html>",revisions="<html>
<ul>
<li>
March 30, 2023, by Christoph Nytsch-Geusen:<br/>
First implementation.
</li>
</ul>
</html>"));
end PVTwoDiodesRooftopBuildingValidation;
