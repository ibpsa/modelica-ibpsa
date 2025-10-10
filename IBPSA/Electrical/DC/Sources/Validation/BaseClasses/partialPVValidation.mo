within IBPSA.Electrical.DC.Sources.Validation.BaseClasses;
partial model partialPVValidation
  "Partial model for validation of PV model with empirical data"
  extends Modelica.Icons.Example;
    parameter Modelica.Units.SI.Time timZon=+7200
    "Time zone";
  parameter Modelica.Units.SI.Angle lon=0.2303835
    "Longitude";
  parameter Modelica.Units.SI.Angle lat=0.9128072
    "Latitude";
  parameter Modelica.Units.SI.Time nDay=(31+28+31+30+31+30+28)*24*3600
    "Day at which simulation starts";
  parameter Modelica.Units.SI.Angle azi=27.5*Modelica.Constants.pi/180
    "Surface azimuth. azi=-90 degree if surface outward unit normal points toward east; azi=0 if it points toward south";
  parameter Modelica.Units.SI.Angle til=2*Modelica.Constants.pi/180
    "Surface tilt. til=90 degree for walls; til=0 for ceilings; til=180 for roof";
  parameter Real alt(final unit="m")= 2 "Site altitude";

  parameter Real rho=0.2 "Ground reflectance";

  constant Real GSC(
    final quantity="Irradiance",
    final unit="W/m2") = 1376 "Solar constant";

  Modelica.Units.SI.Irradiance HGloHor=realPassThroughHGloHor.y "Global horizontal irradiation";

  //Approximation of diffuse horizontal irradiation still necessary because
  //the validation data does not contain this information so far
  // Erbs diffuse fraction relation
  Real k_t(final unit="1", start=0.5)=if HGloHor <= Modelica.Constants.eps
            then 0
            else min(1, max(0, (HGloHor/(GSC*(1 + 0.033*
            cos(360*(Modelica.Constants.pi/180)*cloTim/24/60/60/365)*
            (cos(lat)*cos(solDec)*cos(solHouAng) + sin(lat)*sin(solDec)))))))
            "Clearness index; factor needed for Erbs diffuse fraction relation";
  Modelica.Units.SI.Irradiance HDifHor=if HGloHor <= Modelica.Constants.eps
            then 0
            elseif k_t <= 0.22
            then (HGloHor)*(1.0 - 0.09*k_t)
            elseif k_t > 0.8
            then (HGloHor)*0.165
            else (HGloHor)*
              (0.9511 - 0.1604*k_t + 4.388*k_t^2 - 16.638*k_t^3 + 12.336*k_t^4) "Diffuse horizontal irradiation";

  Modelica.Units.SI.Angle solDec=realPassThroughSolDec.y "Solar decimal angle";
  Modelica.Units.SI.Angle solHouAng= realPassThroughSolHouAng.y "Solar hour angle";
  Modelica.Units.SI.Time cloTim=realPassThroughCloTim.y "Clock time";

  Modelica.Blocks.Interfaces.RealOutput PDCSim(final unit="W")
    "Simulated DC output power"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
  BoundaryConditions.SolarIrradiation.GlobalPerezTiltedSurface HGloTil(til=til,
      azi=azi,
    rho=rho)
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam="",
    TDryBulSou=IBPSA.BoundaryConditions.Types.DataSource.File,
    winSpeSou=IBPSA.BoundaryConditions.Types.DataSource.File,
    HSou=IBPSA.BoundaryConditions.Types.RadiationDataSource.File)
    annotation (Placement(transformation(extent={{-92,-20},{-72,0}})));

  Modelica.Blocks.Sources.Constant sounDay(k=nDay)
    "Number of validation day (July 28th 2023) in seconds"
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
  BoundaryConditions.SolarGeometry.IncidenceAngle incAng(azi=azi, til=til)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-70,-20},{-50,0}})));
  Modelica.Blocks.Routing.RealPassThrough zen "Zenith angle"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));

  Modelica.Blocks.Routing.RealPassThrough realPassThroughSolHouAng
    "Pass through for solar hour angle"
    annotation (Placement(transformation(extent={{-50,-90},{-30,-70}})));
  Modelica.Blocks.Routing.RealPassThrough realPassThroughCloTim
    "Pass through for clock time"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Modelica.Blocks.Routing.RealPassThrough realPassThroughSolDec
    "Pass through for solar decimal angle"
    annotation (Placement(transformation(extent={{30,-90},{50,-70}})));
  Modelica.Blocks.Routing.RealPassThrough realPassThroughHGloHor
    "Pass through for horizontal global irradiation"
    annotation (Placement(transformation(extent={{70,-90},{90,-70}})));
equation

  connect(weaDat.weaBus, HGloTil.weaBus) annotation (Line(
      points={{-72,-10},{-60,-10},{-60,70},{-40,70}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, incAng.weaBus) annotation (Line(
      points={{-72,-10},{-60,-10},{-60,30},{-40,30}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-72,-10},{-60,-10}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.solZen, zen.u) annotation (Line(
      points={{-59.95,-9.95},{-28,-9.95},{-28,-50},{-22,-50}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.solHouAng, realPassThroughSolHouAng.u) annotation (Line(
      points={{-59.95,-9.95},{-59.95,-80},{-52,-80}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.cloTim, realPassThroughCloTim.u) annotation (Line(
      points={{-59.95,-9.95},{-59.95,-62},{-20,-62},{-20,-80},{-12,-80}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.solDec, realPassThroughSolDec.u) annotation (Line(
      points={{-59.95,-9.95},{-59.95,-62},{20,-62},{20,-80},{28,-80}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.HGloHor, realPassThroughHGloHor.u) annotation (Line(
      points={{-59.95,-9.95},{-60,-9.95},{-60,-62},{60,-62},{60,-80},{68,-80}},
      color={255,204,51},
      thickness=0.5));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{100,
            100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(
      StartTime=18057600,
      StopTime=19008000,
      Interval=300,
      Tolerance=1e-06),
   __Dymola_Commands(file=
          "modelica://IBPSA/Resources/Scripts/Dymola/Electrical/DC/Sources/Validation/PVSingleDiodeRooftopBuildingValidation.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
The PVSystem single-diode model is validated with empirical data from the Rooftop solar builidng of UdK Berlin: <a href=\"http://www.solar-rooftop.de/\">http://www.solar-rooftop.de/</a>.
The dates 28.07.2023 to 09.08.2023 were chosen as an example for the PVSystem model.
The validation model proves that single diode PV models tend to overestimate the power output.
This is due to the neglection of staining, shading, other loss effects.
The irradiation measurements need to be shifted 150 s backwards since the sensor integrates the solar power over a time interval.
This results in a lag between measured power and measured solar irradiation.
</p>
</html>",revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end partialPVValidation;
