within IBPSA.Electrical.DC.Sources.Validation;
model PVTwoDiodesRooftopBuildingValidation
  "Validation with empirical data from a rooftop PV system in at UdK, Berlin"
  extends Modelica.Icons.Example;
  extends IBPSA.Electrical.DC.Sources.Validation.BaseClasses.partialPVRooftopBuildingValidation;
  IBPSA.Electrical.DC.Sources.PVTwoDiodes pVSystemTwoDiodes(
    til=0.05235987755983,
    azi=0,
    redeclare IBPSA.Electrical.BaseClasses.PV.PVThermalEmpMountOpenRack partialPVThermal,
    n_mod=6,
    redeclare IBPSA.Electrical.Data.PV.TwoDiodesSolibroSL2CIGS110 data,
    groRef=0.2,
    alt=0.08)
    annotation (Placement(transformation(extent={{62,0},{82,20}})));


equation

  connect(from_degC.y, pVSystemTwoDiodes.TDryBul) annotation (Line(points={{54.6,-8},
          {58,-8},{58,16.25},{63.5385,16.25}},     color={0,0,127}));
  connect(MeaDataWinAngSpe.y[1], pVSystemTwoDiodes.vWinSpe) annotation (Line(
        points={{50.4,-40},{58,-40},{58,-8},{63.5385,-8},{63.5385,13.75}},
        color={0,0,127}));
  connect(MeaDataTAmb.y[1], pVSystemTwoDiodes.HGloHor) annotation (Line(points={{50.4,
          -52},{54,-52},{54,-18},{56,-18},{56,18.75},{63.5385,18.75}},
        color={0,0,127}));
  connect(HGloTil.H, pVSystemTwoDiodes.HGloTil) annotation (Line(points={{59,50},
          {66,50},{66,48},{67.0769,48},{67.0769,18.625}}, color={0,0,127}));
  connect(souGloHorDif.y, pVSystemTwoDiodes.HDifHor) annotation (Line(points={{79,50},
          {70.6154,50},{70.6154,18.625}},     color={0,0,127}));
  connect(pVSystemTwoDiodes.P, PSim) annotation (Line(points={{80.9231,9.375},{
          110,9.375},{110,10}},
                            color={0,0,127}));
  connect(incAng.incAng, pVSystemTwoDiodes.incAngle) annotation (Line(points={{61,
          -90},{74,-90},{74,-86},{58,-86},{58,26},{74,26},{74,18.625}}, color={0,
          0,127}));
  connect(zen.y, pVSystemTwoDiodes.zenAngle) annotation (Line(points={{41,82},{
          58,82},{58,80},{77.3846,80},{77.3846,18.625}},
                                                      color={0,0,127}));
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
