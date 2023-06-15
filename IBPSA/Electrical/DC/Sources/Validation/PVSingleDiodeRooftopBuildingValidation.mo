within IBPSA.Electrical.DC.Sources.Validation;
model PVSingleDiodeRooftopBuildingValidation
  "Validation with empirical data from a rooftop PV system with CIGS modules at UdK, Berlin"
  extends
    IBPSA.Electrical.DC.Sources.Validation.BaseClasses.partialPVRooftopBuildingValidation(
      HGloTil(H(start=100)));
  extends Modelica.Icons.Example;

  IBPSA.Electrical.DC.Sources.PVSingleDiode pVSystemSingleDiode(
    PVTechType=IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThinFilmSI,
    til(displayUnit="rad") = til,
    azi(displayUnit="deg") = azi,
    redeclare IBPSA.Electrical.BaseClasses.PV.PVThermalEmpMountOpenRack
      partialPVThermal,
    n_mod=6,
    redeclare IBPSA.Electrical.Data.PV.SingleDiodeSolibroSL2CIGS110 data,
    groRef=rho,
    alt=0.08,
    E_g0=1.7736095e-19)
    annotation (Placement(transformation(extent={{64,0},{92,20}})));

equation

  connect(HGloTil.H, pVSystemSingleDiode.HGloTil) annotation (Line(points={{61,70},
          {78,70},{78,22.5}},                 color={0,0,127}));
  connect(pVSystemSingleDiode.P, PSim) annotation (Line(points={{93.1667,10},{
          110,10}},               color={0,0,127}));
  connect(MeaDataWinAngSpe.y[1], pVSystemSingleDiode.vWinSpe) annotation (Line(
        points={{-72.8,10},{-48,10},{-48,40},{64,40},{64,22.5}}, color={0,0,127}));
  connect(MeaDataRadModTemp.y[1], pVSystemSingleDiode.HGloHor) annotation (Line(
        points={{-79,-90},{-16,-90},{-16,-84},{44,-84},{44,48},{73.3333,48},{
          73.3333,22.5}}, color={0,0,127}));
  connect(souGloHorDif.y, pVSystemSingleDiode.HDifHor) annotation (Line(points={{-79,-24},
          {-8,-24},{-8,-16},{58,-16},{58,54},{82.6667,54},{82.6667,22.5}},
                  color={0,0,127}));
  connect(incAng.y, pVSystemSingleDiode.incAngle) annotation (Line(points={{26.5,
          -29},{52,-29},{52,22.5},{87.3333,22.5}},      color={0,0,127}));
  connect(zen.y, pVSystemSingleDiode.zenAngle) annotation (Line(points={{61,-50},
          {72,-50},{72,-4},{96,-4},{96,22.5},{92,22.5}}, color={0,0,127}));
  connect(from_degC.y, pVSystemSingleDiode.TDryBul) annotation (Line(points={{-49.4,
          -52},{-42,-52},{-42,-6},{-44,-6},{-44,22.5},{68.6667,22.5}},
        color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{100,
            100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{
            100,100}})),
    experiment(
      StartTime=12614400,
      StopTime=12700800,
      Interval=900.00288,
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
