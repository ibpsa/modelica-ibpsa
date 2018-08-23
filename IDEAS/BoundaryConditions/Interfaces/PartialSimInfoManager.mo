within IDEAS.BoundaryConditions.Interfaces;
partial model PartialSimInfoManager
  "Partial providing structure for SimInfoManager"
  parameter String filNam=
    Modelica.Utilities.Files.loadResource("modelica://IDEAS/Resources/weatherdata/Uccle.TMY")
    "File name of TMY3 weather file";
  parameter Modelica.SIunits.Angle lat(displayUnit="deg") = weaDat.lat
    "Latitude of the location"
    annotation(Dialog(tab="Advanced"));
  parameter Modelica.SIunits.Angle lon(displayUnit="deg") = weaDat.lon
    "Longitude of the location"
    annotation(Dialog(tab="Advanced"));
  parameter Modelica.SIunits.Time timZon(displayUnit="h") = weaDat.timZon
    "Time zone for which the simulation time t=0 corresponds to midnight, january 1st";


  parameter SI.Angle incAndAziInBus[:,:] = {{IDEAS.Types.Tilt.Ceiling,0},{IDEAS.Types.Tilt.Wall,IDEAS.Types.Azimuth.S},
                         {IDEAS.Types.Tilt.Wall,IDEAS.Types.Azimuth.W},{IDEAS.Types.Tilt.Wall,IDEAS.Types.Azimuth.N},{IDEAS.Types.Tilt.Wall,IDEAS.Types.Azimuth.E}, {IDEAS.Types.Tilt.Floor,0}}
                        "Combination of inclination and azimuth which are pre-computed and added to solBus." annotation(Dialog(tab="Incidence angles"));

  parameter Boolean computeConservationOfEnergy=false
    "Add equations for verifying conservation of energy"
    annotation (Evaluate=true, Dialog(tab="Conservation of energy"));
  parameter Boolean strictConservationOfEnergy=false
    "This adds an assert statement to make sure that energy is conserved"
    annotation (Evaluate=true, Dialog(tab="Conservation of energy", enable=
          computeConservationOfEnergy));
  parameter Boolean openSystemConservationOfEnergy=false
    "Compute conservation of energy for open system" annotation (Evaluate=true,
      Dialog(tab="Conservation of energy", enable=computeConservationOfEnergy));

  parameter Boolean lineariseDymola=false "Linearises building model equations for Dymola linearisation approach"
    annotation (Dialog(tab="Linearisation"));
  parameter Boolean lineariseJModelica=false "Linearises building model equations for optimisations in JModelica"
    annotation (Dialog(tab="Linearisation"));
  parameter Boolean createOutputs = false
    "Creates output connections when linearising windows"
    annotation(Dialog(tab="Linearisation"));
  parameter Boolean outputAngles=not lineariseDymola
    "Output angles in weaBus. Set to false when linearising" annotation(Dialog(tab="Linearisation"));
  parameter Boolean linIntCon=false
    "= true, if interior convective heat transfer should be linearised"
    annotation (Dialog(tab="Linearisation", group="Convection"));
  parameter Boolean linExtCon=false
    "= true, if exterior convective heat transfer should be linearised (uses average wind speed)"
    annotation (Dialog(tab="Linearisation", group="Convection"));
  parameter Boolean linIntRad=true
    "= true, if interior radiative heat transfer should be linearised"
    annotation (Dialog(tab="Linearisation", group="Radiation"));
  parameter Boolean linExtRad=false
    "= true, if exterior radiative heat transfer for walls should be linearised"
    annotation (Dialog(tab="Linearisation", group="Radiation"));
  // separate parameter linExtRadWin since window dynamics are steady state by default
  parameter Boolean linExtRadWin=true
    "= true, if exterior radiative heat transfer for windows should be linearised"
    annotation (Dialog(tab="Linearisation", group="Radiation"));
  parameter Modelica.SIunits.Energy Emax=1
    "Error bound for violation of conservation of energy" annotation (Evaluate=true,
      Dialog(tab="Conservation of energy", enable=strictConservationOfEnergy));
  parameter Modelica.SIunits.Temperature Tenv_nom= 280
    "Nominal ambient temperature, only used when linearising equations";

  parameter Integer nWindow = 1
    "Number of windows in the to be linearised model"
    annotation(Dialog(tab="Linearisation"));
  parameter Integer nLayWin= 3
    "Number of window layers in the to be linearised model; should be maximum of all windows"
    annotation(Dialog(tab="Linearisation"));
  parameter Real ppmCO2 = 400
    "Default CO2 concentration in [ppm] when using air medium containing CO2"
    annotation(Dialog(tab="Advanced", group="CO2"));
  final parameter Integer numIncAndAziInBus = size(incAndAziInBus,1)
    "Number of pre-computed azimuth";
  final parameter Modelica.SIunits.Temperature Tdes=-8 + 273.15
    "design outdoor temperature";
  final parameter Modelica.SIunits.Temperature TdesGround=10 + 273.15
    "design ground temperature";
  final parameter Boolean linearise=lineariseDymola or lineariseJModelica
    "Linearises building model equations"
    annotation (Dialog(tab="Linearisation"));

  Modelica.SIunits.Temperature Te
    "ambient outdoor temperature for determination of sky radiation exchange";
  Modelica.SIunits.Temperature Tsky "effective overall sky temperature";
  Modelica.SIunits.Temperature TeAv
    "running average of ambient outdoor temperature of the last 5 days, not yet implemented";
  Modelica.SIunits.Temperature Tground "ground temperature";
  Modelica.SIunits.Velocity Va "air velocity";

  Real relHum(final unit="1") "Relative humidity";
  Modelica.SIunits.Temperature TDewPoi "Dewpoint";


  Modelica.SIunits.Energy Etot "Total internal energy";
  Modelica.SIunits.Energy Qint "Total energy from boundary";


  Real hCon=IDEAS.Utilities.Math.Functions.spliceFunction(
      x=Va - 5,
      pos=7.1*abs(Va)^(0.78),
      neg=4.0*Va + 5.6,
      deltax=0.5)
    "Convection coefficient due to wind speed";
  IDEAS.Utilities.Psychrometrics.X_pTphi XiEnv(use_p_in=false)
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  // Icon of weaBus is made very small as it is not intended that a user would use it.
  // weaBus is still directly connected in the zone model and the connector should
  // therefore not be protected.
  // Connector weaDatBus is made available for the user and it should be used instead
  // of weaBus.
  IDEAS.Buildings.Components.Interfaces.WeaBus weaBus(numSolBus=numIncAndAziInBus,
      final outputAngles=outputAngles)
    annotation (Placement(transformation(extent={{90,30},{110,50}}),
        iconTransformation(extent={{90,30},{90,30}})));
  IDEAS.BoundaryConditions.SolarIrradiation.ShadedRadSol[numIncAndAziInBus] radSol(
    inc=incAndAziInBus[:, 1],
    azi=incAndAziInBus[:, 2],
    each lat=lat,
    each outputAngles=outputAngles)
    "Model for computing solar irradiation and properties of predefined set of tilted surfaces"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  Modelica.Blocks.Sources.RealExpression TskyPow4Expr(y=Tsky^4)
    "Power 4 of sky temperature"
    annotation (Placement(transformation(extent={{-20,94},{0,114}})));
  Modelica.Blocks.Sources.RealExpression TePow4Expr(y=Te^4)
    "Power 4 of ambient temperature"
    annotation (Placement(transformation(extent={{-20,106},{0,126}})));
  Modelica.Blocks.Sources.RealExpression hConExpr(y=hCon)
    "Exterior convective heat transfer coefficient"
    annotation (Placement(transformation(extent={{60,-14},{80,6}})));
  Modelica.Blocks.Sources.RealExpression TdesExpr(y=Tdes)
    "Expression for design temperature"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=10e6)
    "Fixed temperature";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a Qgai
    "Thermal gains in model"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  IDEAS.Buildings.Components.BaseClasses.ConservationOfEnergy.EnergyPort E
    "Model internal energy"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

  Modelica.Blocks.Sources.RealExpression CEnv(y=ppmCO2*44/29/1e6)
    "Concentration of trace substance in surroundings"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));

  input IDEAS.Buildings.Components.Interfaces.WindowBus[nWindow] winBusOut(
      each nLay=nLayWin) if createOutputs
    "Bus for windows in case of linearisation";
  Modelica.Blocks.Routing.RealPassThrough solTim
    "Solar time"
    annotation (Placement(transformation(extent={{-86,-2},{-78,6}})));
  IDEAS.BoundaryConditions.WeatherData.Bus weaDatBus
    "Weather data bus connectable to weaBus connector from Buildings Library"
    annotation (Placement(transformation(extent={{-110,-20},{-90,0}}),
        iconTransformation(
        extent={{-20,-19},{20,19}},
        rotation=270,
        origin={99,3.55271e-015})));

protected
  final parameter Integer yr=2014 "depcited year for DST only";
  IDEAS.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=filNam)
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  IDEAS.BoundaryConditions.SolarIrradiation.BaseClasses.RelativeAirMass
    relativeAirMass "Computation of relative air mass"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  IDEAS.BoundaryConditions.SolarIrradiation.BaseClasses.SkyBrightness
    skyBrightness "Computation of sky brightness"
    annotation (Placement(transformation(extent={{-30,60},{-10,80}})));
  IDEAS.BoundaryConditions.SolarIrradiation.BaseClasses.SkyClearness skyClearness
    "Computation of sky clearness"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));

  IDEAS.BoundaryConditions.SolarIrradiation.BaseClasses.BrighteningCoefficient
    skyBrightnessCoefficients
    "Computation of sky brightness coefficients F1 and F2"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Modelica.Blocks.Sources.RealExpression TGround(y=TdesGround)
    annotation (Placement(transformation(extent={{60,-44},{80,-24}})));
  Modelica.Blocks.Sources.RealExpression u_dummy(y=1)
    annotation (Placement(transformation(extent={{60,-58},{80,-38}})));
  Modelica.Blocks.Routing.RealPassThrough solHouAng "Solar hour angle"
    annotation (Placement(transformation(extent={{-86,66},{-78,74}})));
  Modelica.Blocks.Routing.RealPassThrough solDec "Solar declination angle"
    annotation (Placement(transformation(extent={{-86,52},{-78,60}})));
  Modelica.Blocks.Routing.RealPassThrough HDirNor "Beam solar irradiation"
    annotation (Placement(transformation(extent={{-86,40},{-78,48}})));
  Modelica.Blocks.Routing.RealPassThrough phiEnv "Relative humidity"
    annotation (Placement(transformation(extent={{-86,12},{-78,20}})));
  Modelica.Blocks.Routing.RealPassThrough TDryBul "Dry bulb air temperature"
    annotation (Placement(transformation(extent={{-86,26},{-78,34}})));
  Modelica.Blocks.Routing.RealPassThrough angZen "Solar zenith angle"
    annotation (Placement(transformation(extent={{-86,80},{-78,88}})));
  Modelica.Blocks.Routing.RealPassThrough HGloHor
    "Global/total solar irradiation on a horizontal plane"
    annotation (Placement(transformation(extent={{-86,108},{-78,116}})));
  Modelica.Blocks.Routing.RealPassThrough HDifHor
    "Diffuse solar irradiation on a horizontal plane"
    annotation (Placement(transformation(extent={{-86,94},{-78,102}})));

initial equation
  Etot = 0;
equation
  if strictConservationOfEnergy and computeConservationOfEnergy then
    assert(abs(Etot) < Emax, "Conservation of energy violation > Emax J!");
  end if;

  if not linearise and computeConservationOfEnergy then
    der(Qint) = Qgai.Q_flow;
  else
    Qint = 0;
  end if;
  Etot = Qint - E.E;
  E.Etot = Etot;

  connect(skyClearness.skyCle, skyBrightnessCoefficients.skyCle) annotation (
      Line(
      points={{-39,110},{-36,110},{-36,96},{-2,96}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(skyBrightness.skyBri, skyBrightnessCoefficients.skyBri) annotation (
      Line(
      points={{-9,70},{-8,70},{-8,90},{-2,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(relativeAirMass.relAirMas, skyBrightness.relAirMas) annotation (Line(
      points={{-39,70},{-38,70},{-38,74},{-32,74}},
      color={0,0,127},
      smooth=Smooth.None));

  for i in 1:numIncAndAziInBus loop
    connect(solTim.y, radSol[i].solTim) annotation (Line(points={{-77.6,2},{18,2},
            {18,74},{38,74},{38,73},{39.6,73}},   color={0,0,127}));
    connect(solHouAng.y, radSol[i].angHou) annotation (Line(points={{-77.6,70},{
            -74,70},{-74,48},{30,48},{30,68},{39.6,68}}, color={0,0,127}));
    connect(angZen.y, radSol[i].angZen) annotation (Line(points={{-77.6,84},{-68,
            84},{-68,54},{32,54},{32,66},{39.6,66}}, color={0,0,127}));
    connect(solDec.y, radSol[i].angDec) annotation (Line(points={{-77.6,56},{-76,
            56},{-76,46},{28,46},{28,70},{39.6,70}}, color={0,0,127}));
    connect(radSol[i].solDirPer,HDirNor. y) annotation (Line(points={{39.6,80},{
            22,80},{22,44},{-77.6,44}}, color={0,0,127}));
    connect(radSol[i].solDifHor,HDifHor. y) annotation (Line(points={{39.6,76},{
            26,76},{26,52},{-70,52},{-70,98},{-77.6,98}}, color={0,0,127}));
    connect(HGloHor.y, radSol[i].solGloHor) annotation (Line(points={{-77.6,112},
            {-72,112},{-72,50},{24,50},{24,78},{39.6,78}}, color={0,0,127}));
    connect(radSol[i].F2, skyBrightnessCoefficients.F2) annotation (Line(points={{39.6,60},
            {28,60},{28,86},{21,86}},         color={0,0,127}));
    connect(radSol[i].F1, skyBrightnessCoefficients.F1) annotation (Line(points={{39.6,62},
            {26,62},{26,94},{21,94}},         color={0,0,127}));
    connect(TskyPow4Expr.y, radSol[i].TskyPow4) annotation (Line(points={{1,104},
            {48,104},{48,80.6}}, color={0,0,127}));
    connect(TePow4Expr.y, radSol[i].TePow4) annotation (Line(points={{1,116},{54,
            116},{54,80.6}},               color={0,0,127}));
  end for;
  if not lineariseDymola then
    connect(solTim.y, weaBus.solTim) annotation (Line(points={{-77.6,2},{18,2},{
          18,36},{100.05,36},{100.05,40.05}}, color={0,0,127}));
    connect(angZen.y, weaBus.angZen) annotation (Line(
      points={{-77.6,84},{-68,84},{-68,54},{100.05,54},{100.05,40.05}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(solHouAng.y, weaBus.angHou) annotation (Line(
        points={{-77.6,70},{-74,70},{-74,48},{100.05,48},{100.05,40.05}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(solDec.y, weaBus.angDec) annotation (Line(
        points={{-77.6,56},{-76,56},{-76,46},{100.05,46},{100.05,40.05}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(HGloHor.y, weaBus.solGloHor) annotation (Line(
        points={{-77.6,112},{-72,112},{-72,50},{100.05,50},{100.05,40.05}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(HDifHor.y, weaBus.solDifHor) annotation (Line(
        points={{-77.6,98},{-70,98},{-70,40.05},{100.05,40.05}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(HDirNor.y, weaBus.solDirPer) annotation (Line(
        points={{-77.6,44},{100.05,44},{100.05,40.05}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(phiEnv.y, weaBus.phi) annotation (Line(points={{-77.6,16},{-70,16},{
          -70,42},{100.05,42},{100.05,40.05}},
                                             color={0,0,127}));
    connect(TDryBul.y, weaBus.Te) annotation (Line(points={{-77.6,30},{100.05,30},
          {100.05,40.05}}, color={0,0,127}));
    connect(CEnv.y, weaBus.CEnv) annotation (Line(points={{81,-20},{100.05,-20},
            {100.05,40.05}},
                         color={0,0,127}));
    connect(XiEnv.X[1], weaBus.X_wEnv) annotation (Line(points={{1,30},{100.05,30},
            {100.05,40.05}},                             color={0,0,127}));
    connect(TdesExpr.y, weaBus.Tdes) annotation (Line(
      points={{81,10},{100.05,10},{100.05,40.05}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(u_dummy.y, weaBus.dummy) annotation (Line(points={{81,-48},{100.05,-48},
            {100.05,40.05}},          color={0,0,127}));
    connect(TGround.y, weaBus.TGroundDes) annotation (Line(points={{81,-34},{100.05,
            -34},{100.05,40.05}},    color={0,0,127}));
    connect(hConExpr.y, weaBus.hConExt) annotation (Line(
      points={{81,-4},{100.05,-4},{100.05,40.05}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(XiEnv.X[1], weaDatBus.X_wEnv) annotation (Line(points={{1,30},{-100,
            30},{-100,-10}},                             color={0,0,127}));
    connect(skyBrightnessCoefficients.F1, weaBus.F1) annotation (Line(
      points={{21,94},{26,94},{26,38},{100.05,38},{100.05,40.05}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(skyBrightnessCoefficients.F2, weaBus.F2) annotation (Line(
      points={{21,86},{28,86},{28,34},{100.05,34},{100.05,40.05}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(TskyPow4Expr.y, weaBus.TskyPow4) annotation (Line(
      points={{1,104},{100.05,104},{100.05,40.05}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(TePow4Expr.y, weaBus.TePow4) annotation (Line(
      points={{1,116},{100.05,116},{100.05,40.05}},
      color={0,0,127},
      smooth=Smooth.None));
    for i in 1:numIncAndAziInBus loop
      connect(radSol[i].solBus, weaBus.solBus[i]) annotation (Line(
      points={{60,70},{100.05,70},{100.05,40.05}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
    end for;
   end if;
  connect(fixedTemperature.port, Qgai)
    annotation (Line(points={{0,-92},{0,-100}},          color={191,0,0}));

  connect(TDryBul.y, XiEnv.T) annotation (Line(
      points={{-77.6,30},{-22,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(phiEnv.y, XiEnv.phi) annotation (Line(
      points={{-77.6,16},{-22,16},{-22,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(skyBrightnessCoefficients.zen, angZen.y)
    annotation (Line(points={{-2,84},{-77.6,84}}, color={0,0,127}));
  connect(skyBrightness.HDifHor,HDifHor. y) annotation (Line(points={{-32,66},{-70,
          66},{-70,98},{-77.6,98}}, color={0,0,127}));
  connect(relativeAirMass.zen, angZen.y) annotation (Line(points={{-62,70},{-68,
          70},{-68,84},{-77.6,84}}, color={0,0,127}));
  connect(skyClearness.zen, angZen.y) annotation (Line(points={{-62,104},{-68,104},
          {-68,84},{-77.6,84}}, color={0,0,127}));
  connect(skyClearness.HDifHor,HDifHor. y) annotation (Line(points={{-62,110},{-70,
          110},{-70,98},{-77.6,98}},color={0,0,127}));
  connect(skyClearness.HGloHor,HGloHor. y) annotation (Line(points={{-62,116},{-72,
          116},{-72,112},{-77.6,112}},color={0,0,127}));
  connect(solTim.u, weaDatBus.solTim)
    annotation (Line(points={{-86.8,2},{-100,2},{-100,-10}},color={0,0,127}));
  connect(angZen.u, weaDatBus.solZen) annotation (Line(points={{-86.8,84},{-100,
          84},{-100,-10}},color={0,0,127}));
  connect(HDifHor.u, weaDatBus.HDifHor) annotation (Line(points={{-86.8,98},{
          -100,98},{-100,-10}},
                          color={0,0,127}));
  connect(HGloHor.u, weaDatBus.HGloHor) annotation (Line(points={{-86.8,112},{
          -100,112},{-100,-10}},
                           color={0,0,127}));
  connect(HDirNor.u, weaDatBus.HDirNor) annotation (Line(points={{-86.8,44},{
          -100,44},{-100,-10}},
                          color={0,0,127}));
  connect(solDec.u, weaDatBus.solDec) annotation (Line(points={{-86.8,56},{-100,
          56},{-100,-10}},color={0,0,127}));
  connect(solHouAng.u, weaDatBus.solHouAng) annotation (Line(points={{-86.8,70},
          {-100,70},{-100,-10}},color={0,0,127}));
  connect(TDryBul.u, weaDatBus.TDryBul) annotation (Line(points={{-86.8,30},{
          -100,30},{-100,-10}},
                          color={0,0,127}));
  connect(phiEnv.u, weaDatBus.relHum) annotation (Line(points={{-86.8,16},{-100,
          16},{-100,-10}},color={0,0,127}));
  connect(weaDat.weaBus, weaDatBus) annotation (Line(
      points={{-80,-50},{-80,-40},{-80,-10},{-100,-10}},
      color={255,204,51},
      thickness=0.5));
  connect(CEnv.y, weaDatBus.CEnv) annotation (Line(points={{81,-20},{82,-20},{
          82,-10},{40,-10},{40,-10},{-100,-10}}, color={0,0,127}));
    annotation (
    defaultComponentName="sim",
    defaultComponentPrefixes="inner",
    missingInnerMessage=
        "Your model is using an outer \"sim\" component. An inner \"sim\" component is not defined. For simulation drag IDEAS.BoundaryConditions.SimInfoManager into your model.",
    Icon(graphics={
        Line(points={{-80,-30},{88,-30}}, color={0,0,0}),
        Line(points={{-76,-68},{-46,-30}}, color={0,0,0}),
        Line(points={{-42,-68},{-12,-30}}, color={0,0,0}),
        Line(points={{-8,-68},{22,-30}}, color={0,0,0}),
        Line(points={{28,-68},{58,-30}}, color={0,0,0}),
        Rectangle(
          extent={{-60,76},{60,-24}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95}),
        Rectangle(
          extent={{-50,66},{50,-4}},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255},
          pattern=LinePattern.None),
        Rectangle(
          extent={{-10,-34},{10,-24}},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-40,-60},{-40,-60}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-40,-34},{40,-34},{50,-44},{-52,-44},{-40,-34}},
          smooth=Smooth.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{44,0},{38,40}},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{34,0},{28,12}},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{24,0},{18,56}},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{14,0},{8,36}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{4,0},{-2,12}},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{-6,0},{-46,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Text(
          extent={{-50,66},{-20,26}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Italic},
          fontName="Bookman Old Style",
          textString="i")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            120}})),
    Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>
July 27, 2018 by Filip Jorissen:<br/>
Added outputs <code>CEnv</code> and <code>X_wEnv</code> to <code>weaDatBus</code>.
See <a href=\"https://github.com/open-ideas/IDEAS/issues/868\">#868</a>.
</li>
<li>
June 21, 2018, by Damien Picard:<br/>
Reduce the icon size of weaBus to something very small such that users would
not try to connect to it.
Rename and make public the connector weaDatBus such that it can be connected 
to models from the Buildings library.
</li>
<li>
June 12, 2018, by Filip Jorissen:<br/>
Refactored implementation such that we use more computations from the weather
data reader instead of computing them ourself using equations.
</li>
<li>
June 11, 2018, by Filip Jorissen:<br/>
Revised implementation such that longitude, latitude and time zone are read from
the TMY3 weather file.
Removed split between file path and file name to avoid confusion
and incorrectly formatted paths.
</li>
<li>
June 11, 2018, by Filip Jorissen:<br/>
Changed table name of TMY3 file from 'data' to IBPSA final default 'tab1'
for issue <a href=https://github.com/open-ideas/IDEAS/issues/808>#808</a>.
</li>
<li>
June 8, 2018, by Filip Jorissen:<br/>
Moved input TMY3 file.
See issue <a href=https://github.com/open-ideas/IDEAS/issues/821>#821</a>.
</li>
<li>
June 7, 2018 by Filip Jorissen:<br/>
Created 'input' for TSky, Va and Fc such that
they can be overwriten from the extends clause.
This is for
<a href=\"https://github.com/open-ideas/IDEAS/issues/838\">#838</a>.
</li>
<li>
March 27, 2018, by Filip Jorissen:<br/>
Added relative humidity to weather bus.
See issue <a href=https://github.com/open-ideas/IDEAS/issues/780>#780</a>.
</li>
<li>
January 26, 2018, by Filip Jorissen:<br/>
Added floor orientation to set of precomputed boundary conditions.
See issue <a href=https://github.com/open-ideas/IDEAS/issues/764>#764</a>.
</li>
<li>
January 21, 2018 by Filip Jorissen:<br/>
Added <code>solTim</code> connections for revised azimuth computations.
See <a href=\"https://github.com/open-ideas/IDEAS/issues/753\">
#753</a>.
</li>
<li>
March 21, 2017, by Filip Jorissen:<br/>
Changed linearisation implementation for JModelica compatibility.
See issue <a href=https://github.com/open-ideas/IDEAS/issues/559>#559</a>.
</li>
<li>
January 10, 2017 by Filip Jorissen:<br/>
Set <code>linExtRad = false</code>
and added new parameter <code>linExtRadWin = true</code>
since only for windows is it necessary that
<code>linExtRad</code> is true.
See <a href=https://github.com/open-ideas/IDEAS/issues/615>#615</a>.
</li>
<li>
September 22, 2016 by Filip Jorissen:<br/>
Reworked implementation such that we use Annex 60 
baseclasses for boundary condition computations.
</li>
<li>
March 25, 2016 by Filip Jorissen:<br/>
Reworked radSol implementation to use RealInputs instead of weaBus.
This simplifies translation and interpretation.
Also cleaned up connections.
</li>
<li>
January 29, 2015, Filip Jorissen:<br/>
Made changes for allowing a proper implementation of <code>airLeakage</code>.
</li>
<li>
June 14, 2015, Filip Jorissen:<br/>
Adjusted implementation for computing conservation of energy.
</li>
<li>
February 10, 2015 by Filip Jorissen:<br/>
Adjusted implementation for grouping of solar calculations.
</li>
</ul>
</html>"));
end PartialSimInfoManager;
