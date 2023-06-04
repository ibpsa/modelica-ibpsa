within IBPSA.Electrical.DC.Sources.Validation;
model PVSingleDiodeRooftopBuildingValidation
  "Validation with empirical data from a rooftop PV system in at UdK, Berlin"
  extends IBPSA.Electrical.DC.Sources.Validation.BaseClasses.partialPVRooftopBuildingValidation;
  extends Modelica.Icons.Example;

  IBPSA.Electrical.DC.Sources.PVSingleDiode pVSystemSingleDiode(
    PVTechType=IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThinFilmSI,
    til(displayUnit="rad") = 0.05235987755983,
    azi(displayUnit="rad") = 0,
    redeclare IBPSA.Electrical.BaseClasses.PV.PVThermalEmpMountCloseToGround
      partialPVThermal,
    n_mod=6,
    redeclare IBPSA.Electrical.Data.PV.SingleDiodeSolibroSL2CIGS110 data,
    groRef=0.2,
    alt=0.08)
    annotation (Placement(transformation(extent={{64,0},{84,20}})));


equation

  connect(HGloTil.H, pVSystemSingleDiode.HGloTil) annotation (Line(points={{61,70},
          {74,70},{74,22.5}},                 color={0,0,127}));
  connect(pVSystemSingleDiode.P, PSim) annotation (Line(points={{84.8333,10},{
          84.8333,10},{110,10}},  color={0,0,127}));
  connect(from_degC.y, pVSystemSingleDiode.TDryBul) annotation (Line(points={{54.6,-8},
          {60,-8},{60,22.5},{67.3333,22.5}},            color={0,0,127}));
  connect(MeaDataWinAngSpe.y[1], pVSystemSingleDiode.vWinSpe) annotation (Line(
        points={{50.4,-40},{60,-40},{60,-6},{58,-6},{58,22.5},{64,22.5}},
        color={0,0,127}));
  connect(MeaDataRadModTemp.y[1], pVSystemSingleDiode.HGloHor) annotation (Line(
        points={{50.4,-28},{52,-28},{52,-20},{26,-20},{26,36},{60,36},{60,22.5},
          {70.6667,22.5}},  color={0,0,127}));
  connect(zen.y, pVSystemSingleDiode.zenAngle) annotation (Line(points={{21,90},
          {58,90},{58,80},{84,80},{84,22.5}},             color={0,0,127}));
  connect(incAng.incAng, pVSystemSingleDiode.incAngle) annotation (Line(points={{61,-90},
          {62,-90},{62,28},{80.6667,28},{80.6667,22.5}},  color={0,0,127}));
  connect(souGloHorDif.y, pVSystemSingleDiode.HDifHor) annotation (Line(points={{79,50},
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
          "modelica://IBPSA/Resources/Scripts/Dymola/Electrical/DC/Sources/Validation/PVSingleDiodeRooftopBuildingValidation.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>The PVSystem single-diode model is validaded with empirical data from the Rooftop solar builidng of UdK Berlin: <a href=\"http://www.solar-rooftop.de/\">http://www.solar-rooftop.de/</a> </p>
<p>The dates 18.04.2023 to 28.04.2023 were chosen as an example for the PVSystem model. </p>
<p>The validation model proves that single diode PV models tend to overestimate the power output.</p>
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
