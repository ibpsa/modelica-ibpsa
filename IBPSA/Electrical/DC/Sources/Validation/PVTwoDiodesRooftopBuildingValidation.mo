within IBPSA.Electrical.DC.Sources.Validation;
model PVTwoDiodesRooftopBuildingValidation
  "Validation with empirical data from a rooftop PV system in at UdK, Berlin"
  extends Modelica.Icons.Example;
  extends IBPSA.Electrical.DC.Sources.Validation.BaseClasses.partialPVRooftopBuildingValidation;
  IBPSA.Electrical.DC.Sources.PVTwoDiodes pVSystemTwoDiodes(
    PVTechType=IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThinFilmSI,

    til=0.05235987755983,
    azi=0,
    redeclare IBPSA.Electrical.BaseClasses.PV.PVThermalEmpMountOpenRack partialPVThermal,
    n_mod=6,
    redeclare IBPSA.Electrical.Data.PV.TwoDiodesSolibroSL2CIGS110 data,
    groRef=0.2,
    alt=0.08)
    annotation (Placement(transformation(extent={{64,0},{84,20}})));

equation
  connect(HGloTil.H, pVSystemTwoDiodes.HGloTil)
    annotation (Line(points={{61,70},{74,70},{74,22.5}}, color={0,0,127}));
  connect(pVSystemTwoDiodes.P, PSim)
    annotation (Line(points={{84.8333,10},{110,10}}, color={0,0,127}));
  connect(from_degC.y, pVSystemTwoDiodes.TDryBul)
    annotation (Line(points={{54.6,-8},{60,-8},{60,22.5},{67.3333,22.5}}, color={0,0,127}));
  connect(MeaDataWinAngSpe.y[1], pVSystemTwoDiodes.vWinSpe)
    annotation (Line(points={{50.4,-40},{60,-40},{60,-6},{58,-6},{58,22.5},{64,22.5}},color={0,0,127}));
  connect(MeaDataRadModTemp.y[1], pVSystemTwoDiodes.HGloHor) annotation (Line(
        points={{50.4,-28},{52,-28},{52,-20},{26,-20},{26,36},{60,36},{60,22.5},
          {70.6667,22.5}},  color={0,0,127}));
  connect(zen.y, pVSystemTwoDiodes.zenAngle) annotation (Line(points={{21,90},{
          58,90},{58,80},{84,80},{84,22.5}},              color={0,0,127}));
  connect(incAng.incAng, pVSystemTwoDiodes.incAngle) annotation (Line(points={{61,-90},
          {62,-90},{62,28},{80.6667,28},{80.6667,22.5}},  color={0,0,127}));
  connect(souGloHorDif.y, pVSystemTwoDiodes.HDifHor) annotation (Line(points={{79,50},
          {77.3333,50},{77.3333,22.5}},           color={0,0,127}));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{100,
            100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{
            100,100}})),
    experiment(
      StartTime=9244800,
      StopTime=10108800,
      Interval=300,
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
