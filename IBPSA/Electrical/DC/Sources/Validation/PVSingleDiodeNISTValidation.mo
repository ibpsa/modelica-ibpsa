within IBPSA.Electrical.DC.Sources.Validation;
model PVSingleDiodeNISTValidation
  "Model validation based on NIST measurement data"
  extends Modelica.Icons.Example;
  extends
    IBPSA.Electrical.DC.Sources.Validation.BaseClasses.partialPVValidation;

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

  parameter Modelica.Units.SI.Time nDay=(31+28+31+30+31+14)*24*3600
  "Day at which simulation starts";


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
    "The PVSystem model is validaded with measurement data from: https://pvdata.nist.gov/. 1 - Air temperature in degC, 2 - Wind speed in m/s, 3 - Global horizontal irradiance in W/m2, 4 - Ouput power in kW"
    annotation (Placement(transformation(extent={{-98,-60},{-78,-40}})));

  PVSingleDiode pVSinDio(
    redeclare IBPSA.Electrical.Data.PV.SingleDiodeSharpNUU235F2 dat,
    PVTecTyp=IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.MonoSI,
    nMod=312,
    groRef=rho,
    alt=alt,
    til=til,
    redeclare IBPSA.Electrical.BaseClasses.PV.PVThermalEmpMountCloseToGround
      PVThe) "Single-diode PV model" annotation (Placement(transformation(extent={{60,38},
            {80,62}})));

  Modelica.Blocks.Math.Gain frokWToW(k=1000)
    "From Kilowatt to Watt transformation"
    annotation (Placement(transformation(extent={{86,-16},{98,-4}})));
  Modelica.Blocks.Sources.CombiTimeTable MeaDatPVPDC(
    tableOnFile=true,
    tableName="MeaDatPVPDC",
    fileName="NoName",
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    shiftTime=nDay - 1800)
    "The PVSystem model is validaded with measurement data from: https://pvdata.nist.gov/. 1 - Air temperature in degC, 2 - Wind speed in m/s, 3 - Global horizontal irradiance in W/m2, 4 - Ouput power in kW"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
equation

  //Approximation of diffuse horizontal irradiation still necessary because
  //the validation data does not contain this information so far
  solHouAng = realPassThroughSolHouAng.y;
  solDec=realPassThroughSolDec.y;
  cloTim=realPassThroughCloTim.y;

  HGloHor=NISTdat.y[3];

  k_t =if HGloHor <= 0.01
       then 0
        else min(1, max(0, (HGloHor/(GSC*(1 + 0.033*
        cos(360*(Modelica.Constants.pi/180)*cloTim/24/60/60/365)*
        (cos(lat)*cos(solDec)*cos(solHouAng) + sin(lat)*sin(solDec)))))));

  // Erbs diffuse fraction relation
  HDifHor = if HGloHor <= 0.01
            then 0
            elseif k_t <= 0.22
            then (HGloHor)*(1.0 - 0.09*k_t)
            elseif k_t > 0.8
            then (HGloHor)*0.165
            else (HGloHor)*
                  (0.9511 - 0.1604*k_t + 4.388*k_t^2 - 16.638*k_t^3 + 12.336*k_t^4);
  connect(pVSinDio.PDC, PDCSim)
    annotation (Line(points={{81,50},{110,50}}, color={0,0,127}));
  connect(MeaDatPVPDC.y[1], frokWToW.u)
    annotation (Line(points={{81,-10},{84.8,-10}}, color={0,0,127}));
  connect(frokWToW.y, PDCMea)
    annotation (Line(points={{98.6,-10},{110,-10}}, color={0,0,127}));
  connect(zen.y, pVSinDio.zenAng) annotation (Line(points={{1,-50},{52,-50},{52,
          58},{58,58}}, color={0,0,127}));
  connect(incAng.y, pVSinDio.incAng) annotation (Line(points={{21,10},{50,10},{
          50,55},{58,55}}, color={0,0,127}));
  connect(weaBus.winSpe, pVSinDio.vWinSpe) annotation (Line(
      points={{-59.95,-9.95},{-59.95,36},{40,36},{40,52},{58,52}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.HGloHor, pVSinDio.HGloHor) annotation (Line(
      points={{-59.95,-9.95},{-10,-9.95},{-10,-10},{40,-10},{40,46},{58,46}},
      color={255,204,51},
      thickness=0.5));
  connect(HGloTil.H, pVSinDio.HGloTil) annotation (Line(points={{21,50},{52,50},
          {52,43},{58,43}}, color={0,0,127}));
  connect(weaBus.HDifHor, pVSinDio.HDifHor) annotation (Line(
      points={{-60,-10},{-28,-10},{-28,30},{40,30},{40,40},{58,40}},
      color={255,204,51},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
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
