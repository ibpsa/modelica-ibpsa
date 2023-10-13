within IBPSA.Electrical.DC.Sources.Examples;
model PVSingleDiode "Example for the single-diode PV model"
  extends Modelica.Icons.Example;
  extends
    IBPSA.Electrical.DC.Sources.Validation.BaseClasses.partialPVValidation(
      weaDat(filNam=ModelicaServices.ExternalReferences.loadResource(
      "modelica://IBPSA/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")));
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{-56,-20},{-36,0}})));
  Buildings.Electrical.DC.Loads.Resistor    res(R=0.5, V_nominal=12)
    "Resistance"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Electrical.DC.Sources.ConstantVoltage    sou(V=pVSys1Dio120Wp.dat.VOC0)
                                                               "Voltage source"
    annotation (Placement(transformation(extent={{-32,-10},{-12,10}})));
  Buildings.Electrical.DC.Lines.TwoPortResistance lin(R=0.05)
    "Transmission line"
    annotation (Placement(transformation(extent={{6,40},{26,60}})));
  Buildings.Electrical.DC.Sensors.GeneralizedSensor sen "Sensor"
    annotation (Placement(transformation(extent={{34,40},{54,60}})));
  IBPSA.Electrical.DC.Sources.PVSingleDiode
                pVSys1Dio120Wp(
    PVTecTyp=IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThinFilmSI,
    use_ter=true,
    use_Til_in=false,
    til(displayUnit="rad") = til,
    nMod=4,
    redeclare Data.PV.SingleDiodeSolibroSL2CIGS120 dat,
    groRef=rho,
    alt=0.08,
    redeclare IBPSA.Electrical.BaseClasses.PV.PVThermalEmpMountCloseToGround
      PVThe) "PV modules with a peak power of 120 Wp"
    annotation (Placement(transformation(extent={{70,38},{90,62}})));

equation
  connect(sou.terminal,res. terminal) annotation (Line(
      points={{-12,0},{20,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(lin.terminal_n,res. terminal) annotation (Line(
      points={{6,50},{0,50},{0,0},{20,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(lin.terminal_p,sen. terminal_n) annotation (Line(
      points={{26,50},{34,50}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sou.n,ground. p) annotation (Line(
      points={{-32,0},{-46,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sen.terminal_p, pVSys1Dio120Wp.terminal)
    annotation (Line(points={{54,50},{70,50}},
                                             color={0,0,255}));
  connect(pVSys1Dio120Wp.PDC, PDCSim)
    annotation (Line(points={{91,50},{110,50}}, color={0,0,127}));
  connect(weaBus.HDifHor, pVSys1Dio120Wp.HDifHor) annotation (Line(
      points={{-59.95,-9.95},{-59.95,14},{62,14},{62,38},{68,38}},
      color={255,204,51},
      thickness=0.5));
  connect(zen.y, pVSys1Dio120Wp.zenAng) annotation (Line(points={{1,-50},{62,-50},
          {62,58},{68,58}}, color={0,0,127}));
  connect(incAng.y, pVSys1Dio120Wp.incAng) annotation (Line(points={{-19,30},{62,
          30},{62,56},{66,56},{66,55},{68,55}}, color={0,0,127}));
  connect(weaBus.winSpe, pVSys1Dio120Wp.vWinSpe) annotation (Line(
      points={{-59.95,-9.95},{-59.95,14},{62,14},{62,52},{68,52}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.HGloHor, pVSys1Dio120Wp.HGloHor) annotation (Line(
      points={{-59.95,-9.95},{-59.95,2},{-60,2},{-60,14},{62,14},{62,44},{68,44}},
      color={255,204,51},
      thickness=0.5));

  connect(weaBus.TDryBul, pVSys1Dio120Wp.TDryBul) annotation (Line(
      points={{-59.95,-9.95},{-59.95,14},{62,14},{62,48},{68,48},{68,47}},
      color={255,204,51},
      thickness=0.5));
  connect(HGloTil.H, pVSys1Dio120Wp.HGloTil) annotation (Line(points={{-19,70},{
          62,70},{62,56},{68,56},{68,41}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StartTime=3600,
      StopTime=86400,
      Interval=300,
      Tolerance=1e-06),
      Documentation(info="<html>
      <p>
      This model illustrates the use of the single-diode PV model.
      </p>
      <p>
      It shows the exemplary DC power output for a day in San Francisco.
      </p>
      </html>",
      revisions="<html>
      <ul>
      <li>
      October 13, 2023, by Laura Maier:<br/>
      Added model and documentation.
      </li>
      </ul>
      </html>"),
      __Dymola_Commands(file=
        "modelica://IBPSA/Resources/Scripts/Dymola/Electrical/DC/Sources/Examples/PVSingleDiode.mos"
        "Simulate and plot"));
end PVSingleDiode;
