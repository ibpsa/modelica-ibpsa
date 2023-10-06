within IBPSA.Electrical.DC.Sources.Validation;
model PVSingleDiodeNISTValidation
  "Model validation based on NIST measurement data"
  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.Time timZon=-5*3600
    "Time zone";
  parameter Modelica.Units.SI.Angle lon=-77.2156*Modelica.Constants.pi/180
    "Longitude";
  parameter Modelica.Units.SI.Angle lat=39.1354*Modelica.Constants.pi/180
    "Latitude";
  parameter Modelica.Units.SI.Angle azi=0
    "Surface azimuth. azi=-90 degree if surface outward unit normal points toward east; azi=0 if it points toward south";
  parameter Modelica.Units.SI.Angle til=10*Modelica.Constants.pi/180
    "Surface tilt. til=90 degree for walls; til=0 for ceilings; til=180 for roof";

  parameter Modelica.Units.SI.Time nDay=(31+28+31+30+31+14)*24*3600 "Day at which simulation starts";


  parameter Real alt(final unit="m")= 0.08 "Site altitude";

  parameter Real rho=0.2 "Ground reflectance";

  constant Real GSC(
    final quantity="Irradiance",
    final unit="W/m2") = 1376 "Solar constant";

  Modelica.Units.SI.Irradiance HGloHor "Global horizontal irradiation";
  Modelica.Units.SI.Irradiance HDifHor "Diffuse horizontal irradiation";
  Real k_t(final unit="1", start=0.5) "Clearness index";
  Modelica.Units.SI.Angle solDec "Solar decimal angle";
  Modelica.Units.SI.Angle solHouAng "Solar hour angle";
  Modelica.Units.SI.Time cloTim "Clock time";

  Modelica.Blocks.Sources.CombiTimeTable NISTdat(
    tableOnFile=true,
    tableName="Roof2016",
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://IBPSA/Resources/Data/Electrical/DC/Sources/Validation/NIST_onemin_Roof_2016.txt"),
    columns={3,5,2,4},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    "The PVSystem model is validaded with measurement data from: https://pvdata.nist.gov/ "
    annotation (Placement(transformation(extent={{-96,-10},{-76,10}})));

  PVSingleDiode pVSinDio(
    redeclare IBPSA.Electrical.Data.PV.SingleDiodeSharpNUU235F2 dat,
    PVTecTyp=IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.MonoSI,
    nMod=312,
    groRef=rho,
    alt=alt,
    til=til,
    redeclare IBPSA.Electrical.BaseClasses.PV.PVThermalEmpMountCloseToGround
      PVThe) "Single-diode PV model" annotation (Placement(transformation(extent={{60,0},{80,20}})));

  Modelica.Blocks.Interfaces.RealOutput PDCSim "Simulated DC output power"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  BoundaryConditions.SolarGeometry.IncidenceAngle incAng(azi=azi, til=til) "Incidence angle"
    annotation (Placement(transformation(extent={{-36,-58},{-20,-42}})));
  Modelica.Blocks.Routing.RealPassThrough zen "Zenith angle"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  BoundaryConditions.SolarIrradiation.GlobalPerezTiltedSurface HGloTil(
    H(start=100),
    til=til,
    azi=azi,
    rho=rho) "Global irradiation on tilted surface"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=ModelicaServices.ExternalReferences.loadResource(
        "modelica://IBPSA/Resources/weatherdata/USA_MD_Baltimore-Washington.Intl.AP.724060_TMY3.mos"),
    computeWetBulbTemperature=false,
    TDryBulSou=IBPSA.BoundaryConditions.Types.DataSource.Input,
    winSpeSou=IBPSA.BoundaryConditions.Types.DataSource.Input,
    HSou=IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor) "Weather data reader"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Modelica.Blocks.Sources.Constant sounDay(k=nDay)
    "Number of validation day (July 28th 2023) in seconds"
    annotation (Placement(transformation(extent={{-96,54},{-80,70}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-16,-10},{4,10}})));
  Modelica.Blocks.Math.UnitConversions.From_degC from_degC "From deg C to K"
    annotation (Placement(transformation(extent={{-62,-4},{-54,4}})));
  Modelica.Blocks.Sources.RealExpression souDifHor(y=HDifHor)
    "Source for diffuse horizontal irradiation"
    annotation (Placement(transformation(extent={{-78,-40},{-58,-20}})));
  Modelica.Blocks.Interfaces.RealOutput PDCMea "Measured DC output power"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Interfaces.RealOutput SolHouAng(final unit="rad") "Solar hour angle"
    annotation (Placement(transformation(extent={{100,-62},{120,-42}})));
  Modelica.Blocks.Interfaces.RealOutput SolDec(final unit="rad")
    "Solar decimal angle"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}})));
  Modelica.Blocks.Interfaces.RealOutput CloTim(final unit="s") "Clock time"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));
  Modelica.Blocks.Math.Gain frokWToW(k=1000)
    "From Kilowatt to Watt transformation"
    annotation (Placement(transformation(extent={{72,-26},{84,-14}})));
equation

  //Approximation of diffuse horizontal irradiation still necessary because
  //the validation data does not contain this information so far

  HGloHor=NISTdat.y[3];
  solDec=SolDec;
  solHouAng=SolHouAng;
  cloTim=CloTim;

  k_t =if HGloHor <= 0.01 then 0 else min(1, max(0, (HGloHor/(GSC*(1 + 0.033*
    cos(360*(Modelica.Constants.pi/180)*cloTim/24/60/60/365)*(cos(lat)*cos(
    SolDec)*cos(SolHouAng) + sin(lat)*sin(SolDec)))))));

  // Erbs diffuse fraction relation
  HDifHor = if HGloHor <= 0.01 then 0 elseif k_t <= 0.22 then (HGloHor)*(1.0 - 0.09
    *k_t) elseif k_t > 0.8 then (HGloHor)*0.165 else (HGloHor)*(0.9511 - 0.1604*
    k_t + 4.388*k_t^2 - 16.638*k_t^3 + 12.336*k_t^4);
  connect(pVSinDio.PDC, PDCSim) annotation (Line(points={{81,10},{96,10},{96,0},
          {110,0}}, color={0,0,127}));
  connect(zen.y, pVSinDio.zenAng) annotation (Line(points={{21,-70},{54,-70},{54,
          10},{70,10}}, color={0,0,127}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-20,0},{-6,0}},
      color={255,204,51},
      thickness=0.5));
  connect(NISTdat.y[1], from_degC.u)
    annotation (Line(points={{-75,0},{-62.8,0}}, color={0,0,127}));
  connect(from_degC.y, weaDat.TDryBul_in) annotation (Line(points={{-53.6,0},{-46,
          0},{-46,9},{-41,9}}, color={0,0,127}));
  connect(NISTdat.y[2], weaDat.winSpe_in) annotation (Line(points={{-75,0},{-68,
          0},{-68,-8},{-46,-8},{-46,-3.9},{-41,-3.9}}, color={0,0,127}));
  connect(souDifHor.y, pVSinDio.HDifHor)
    annotation (Line(points={{-57,-30},{58,-30},{58,1}}, color={0,0,127}));
  connect(NISTdat.y[3], pVSinDio.HGloHor) annotation (Line(points={{-75,0},{-68,
          0},{-68,-16},{32,-16},{32,7},{58,7}}, color={0,0,127}));
  connect(HGloTil.H, pVSinDio.HGloTil)
    annotation (Line(points={{21,50},{32,50},{32,4},{58,4}}, color={0,0,127}));
  connect(weaBus, HGloTil.weaBus) annotation (Line(
      points={{-6,0},{-6,50},{0,50}},
      color={255,204,51},
      thickness=0.5));
  connect(incAng.y, pVSinDio.incAng) annotation (Line(points={{-19.2,-50},{-12,-50},
          {-12,-14},{30,-14},{30,10},{70,10}}, color={0,0,127}));
  connect(NISTdat.y[2], pVSinDio.vWinSpe) annotation (Line(points={{-75,0},{-68,
          0},{-68,-8},{-44,-8},{-44,-16},{32,-16},{32,6},{52,6},{52,13},{58,13}},
        color={0,0,127}));
  connect(weaBus, incAng.weaBus) annotation (Line(
      points={{-6,0},{-6,-24},{-46,-24},{-46,-50},{-36,-50}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.solZen, zen.u) annotation (Line(
      points={{-6,0},{-6,-54},{-12,-54},{-12,-70},{-2,-70}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.solHouAng,SolHouAng)  annotation (Line(
      points={{-6,0},{-6,-52},{110,-52}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.solDec,SolDec)  annotation (Line(
      points={{-6,0},{-6,-70},{110,-70}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.cloTim,CloTim)  annotation (Line(
      points={{-6,0},{-6,-90},{110,-90}},
      color={255,204,51},
      thickness=0.5));
  connect(from_degC.y, pVSinDio.TDryBul)
    annotation (Line(points={{-53.6,0},{58,0},{58,10}}, color={0,0,127}));
  connect(souDifHor.y, weaDat.HDifHor_in) annotation (Line(points={{-57,-30},{-48,
          -30},{-48,-18},{-41,-18},{-41,-9.5}}, color={0,0,127}));
  connect(NISTdat.y[3], weaDat.HGloHor_in) annotation (Line(points={{-75,0},{-68,
          0},{-68,-13},{-41,-13}}, color={0,0,127}));
  connect(frokWToW.y, PDCMea)
    annotation (Line(points={{84.6,-20},{110,-20}}, color={0,0,127}));
  connect(NISTdat.y[4], frokWToW.u) annotation (Line(points={{-75,0},{-68,0},{-68,
          -16},{64,-16},{64,-20},{70.8,-20}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-94,46},{-36,12}},
          horizontalAlignment=TextAlignment.Left,
          textString="1 - Air temperature in degC, 2 - Wind speed in m/s, 3 - Global horizontal irradiance in W/m2, 4 - Ouput power in kW",
          textColor={0,0,0})}),
    experiment(
      StopTime=86400,
      Interval=300,
      Tolerance=1e-06),
      __Dymola_Commands(file=
          "modelica://IBPSA/Resources/Scripts/Dymola/Electrical/DC/Sources/Validation/PVSingleDiodeNISTValidation.mos"
        "Simulate and plot"),
        Documentation(info="<html>
        <p>The PVSystem single-diode model is validaded with measurement data from the NIST <a href=\"https://pvdata.nist.gov/\">https://pvdata.nist.gov/</a></p>
        <p>June 14th was chosen as an exemplary day for the PVSystem model. </p>
        <p>The system consists of 312 mono-Si modules which are mounted on a rooftop.</p>
<p>The validation model proves that single-diode PV models tend to overestimate the power output.</p>
<p>This is due to the neglection of staining, shading, other loss effects.</p>
<p>More information can be found in the study of Maier et al. [1].</p>
<h4>References</h4>
<p>[1] Maier, Laura, Michael Kratz, Christian Vering, Philipp Mehrfeld, and Dirk Mueller.</p>
<p>&quot;Open-source photovoltaic model for early building planning processes: Modeling, application and validation&quot;.</p>
<p>In Building Simulation 2021, vol. 17, pp. 2315-2316. IBPSA, 2021.
Available
<a href=\"http://publications.rwth-aachen.de/record/829358/files/829358.pdf\">
online</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
Oct 5, 2023, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PVSingleDiodeNISTValidation;
