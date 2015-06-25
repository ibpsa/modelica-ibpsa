within Annex60.Experimental.Pipe.Examples.PipeAdiabatic;
model FixedRes_TStep
  "Test of fixed resistances with zero-mass-flow and flow reversal"
  extends Modelica.Icons.Example;

  package Medium = Annex60.Media.Water "Medium";

  parameter Modelica.SIunits.Diameter diameter = 0.1 "Pipe diameter";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 0.5
    "Nominal mass flow rate"
  annotation(Dialog(group = "Nominal condition"));

  final parameter Modelica.SIunits.Pressure dpStraightPipe1_nominal=
      Modelica.Fluid.Pipes.BaseClasses.WallFriction.Detailed.pressureLoss_m_flow(
      m_flow=m_flow_nominal,
      rho_a=rho_nominal,
      rho_b=rho_nominal,
      mu_a=mu_nominal,
      mu_b=mu_nominal,
      length=100,
      diameter=diameter,
      roughness=2.5e-5,
      m_flow_small=1e-04) "Pressure loss of a straight pipe at m_flow_nominal";

  final parameter Modelica.SIunits.Pressure dpStraightPipe2_nominal=
      Modelica.Fluid.Pipes.BaseClasses.WallFriction.Detailed.pressureLoss_m_flow(
      m_flow=m_flow_nominal,
      rho_a=rho_nominal,
      rho_b=rho_nominal,
      mu_a=mu_nominal,
      mu_b=mu_nominal,
      length=50,
      diameter=diameter,
      roughness=2.5e-5,
      m_flow_small=1e-04) "Pressure loss of a straight pipe at m_flow_nominal";

  parameter Modelica.SIunits.Pressure dp_test = 20
    "Differential pressure for the test used in ramps";

  Modelica.Blocks.Sources.Constant PAtm(k=101325) "Atmospheric pressure"
      annotation (Placement(transformation(extent={{126,76},{146,96}})));

  Fluid.FixedResistances.FixedResistanceDpM pipe50_1(
    redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    dp_nominal=2*dpStraightPipe2_nominal,
    dp(nominal=10*50),
    use_dh=true,
    dh=0.1) "Pipe 1 in series of two 50 m pipes"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));

  Fluid.FixedResistances.FixedResistanceDpM pipe50_2(
    redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    dp_nominal=2*dpStraightPipe2_nominal,
    dp(nominal=10*50),
    use_dh=true,
    dh=0.1) "Pipe 2 of two 50 m pipes in series"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));

  Fluid.FixedResistances.FixedResistanceDpM pipe100(
    redeclare package Medium = Medium,
    m_flow_nominal=0.5,
    dp_nominal=2*dpStraightPipe1_nominal,
    dp(nominal=10*100),
    use_dh=true,
    dh=0.1) "Pipe with 100 m length in parallel to 2 x 50 m pipes"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,-20})));

  Annex60.Fluid.Sources.Boundary_pT sou1(          redeclare package Medium =
        Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=2,
    T=293.15)
    "Source with high pressure at beginning and lower pressure at end of experiment"
                          annotation (Placement(transformation(extent={{-88,28},
            {-68,48}})));
  Annex60.Fluid.Sources.Boundary_pT sin1(          redeclare package Medium =
        Medium,
    nPorts=2,
    use_p_in=true,
    T=283.15)
    "Sink at with constant pressure, turns into source at the end of experiment"
                          annotation (Placement(transformation(extent={{140,28},
            {120,48}})));
  Annex60.Fluid.Sensors.MassFlowRate masFloSer(redeclare package Medium =
        Medium) "Mass flow rate sensor for the two pipes in series"
    annotation (Placement(transformation(extent={{88,30},{108,50}})));

  Modelica.Blocks.Sources.Step stepT(
    height=10,
    startTime=20,
    offset=273.15 + 20)
    "Step temperature increase to test propagation of temperature wave"
    annotation (Placement(transformation(extent={{-118,10},{-98,30}})));
  Modelica.Blocks.Sources.Ramp decreaseP(
    duration=1800,
    startTime=5000,
    height=-dp_test,
    offset=101325 + dp_test) "Decreasing pressure difference to zero-mass-flow"
    annotation (Placement(transformation(extent={{-156,80},{-136,100}})));
  Modelica.Blocks.Sources.Ramp reverseDP(
    duration=1800,
    offset=0,
    startTime=10000,
    height=-dp_test) "Reverse the flow after a period of zero-mass-flow"
    annotation (Placement(transformation(extent={{-156,40},{-136,60}})));
  Modelica.Blocks.Math.Add add "Combine input signal of two ramps"
    annotation (Placement(transformation(extent={{-118,60},{-98,80}})));

  Annex60.Fluid.Sensors.TemperatureTwoPort senTemSerOut(redeclare package
      Medium = Medium, m_flow_nominal=0.5)
    "Temperature sensor for the outflow of the two pipes in series"
    annotation (Placement(transformation(extent={{56,30},{76,50}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemSerIn(redeclare package Medium
      = Medium, m_flow_nominal=0.5)
    "Temperature of the inflow to the two pipes in series"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));

  Annex60.Fluid.Sensors.MassFlowRate masFloSin(
    redeclare package Medium = Medium)
    "Mass flow rate sensor for the single pipe"
    annotation (Placement(transformation(extent={{88,-30},{108,-10}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemSinOut(redeclare package
      Medium = Medium, m_flow_nominal=0.5)
    "Temperature sensor for the outflow from the single pipe"
    annotation (Placement(transformation(extent={{56,-30},{76,-10}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTemSinIn(redeclare package Medium
      = Medium, m_flow_nominal=0.5)
    "Temperature sensor of the inflow to the single pipe"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

protected
  parameter Medium.ThermodynamicState sta_default=
     Medium.setState_pTX(T=Medium.T_default, p=Medium.p_default, X=Medium.X_default);

  parameter Modelica.SIunits.Density rho_nominal = Medium.density_pTX(Medium.p_default, Medium.T_default, Medium.X_default)
    "Nominal density (e.g., rho_liquidWater = 995, rho_air = 1.2)"
    annotation(Dialog(group="Advanced", enable=use_rho_nominal));

  parameter Modelica.SIunits.DynamicViscosity mu_nominal = Medium.dynamicViscosity(
                                                 Medium.setState_pTX(
                                                     Medium.p_default, Medium.T_default, Medium.X_default))
    "Nominal dynamic viscosity (e.g., mu_liquidWater = 1e-3, mu_air = 1.8e-5)"
    annotation(Dialog(group="Advanced", enable=use_mu_nominal));

equation
  connect(PAtm.y, sin1.p_in)
                            annotation (Line(points={{147,86},{154,86},{154,46},
          {142,46}},
                   color={0,0,127}));
  connect(sin1.ports[1], masFloSer.port_b) annotation (Line(
      points={{120,40},{108,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(stepT.y, sou1.T_in) annotation (Line(
      points={{-97,20},{-90,20},{-90,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(decreaseP.y, add.u1) annotation (Line(
      points={{-135,90},{-130,90},{-130,76},{-120,76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(reverseDP.y, add.u2) annotation (Line(
      points={{-135,50},{-128,50},{-128,64},{-120,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, sou1.p_in) annotation (Line(
      points={{-97,70},{-94,70},{-94,46},{-90,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipe50_2.port_b, senTemSerOut.port_a) annotation (Line(
      points={{40,40},{56,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloSer.port_a, senTemSerOut.port_b) annotation (Line(
      points={{88,40},{76,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou1.ports[1], senTemSerIn.port_a) annotation (Line(
      points={{-68,40},{-60,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe50_1.port_a, senTemSerIn.port_b) annotation (Line(
      points={{-20,40},{-40,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe50_1.port_b, pipe50_2.port_a) annotation (Line(
      points={{0,40},{20,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloSin.port_a, senTemSinOut.port_b) annotation (Line(
      points={{88,-20},{76,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou1.ports[2], senTemSinIn.port_a) annotation (Line(
      points={{-68,36},{-66,36},{-66,-20},{-60,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloSin.port_b, sin1.ports[2]) annotation (Line(
      points={{108,-20},{114,-20},{114,36},{120,36}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe100.port_a, senTemSinIn.port_b) annotation (Line(
      points={{0,-20},{-40,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe100.port_b, senTemSinOut.port_a) annotation (Line(
      points={{20,-20},{56,-20}},
      color={0,127,255},
      smooth=Smooth.None));
    annotation (experiment(StopTime=20000, __Dymola_NumberOfIntervals=5000),
__Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Experimental/PipeAdiabatic/FixedRes_TStep.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{160,
            100}})),
    Documentation(info="<html>
<p>This test is to further look into the differences in mass flow between 2 hydraulic resistances representing pipes of 50 m length each and a single hydraulic resistance for a pipe of length 100 m. These differences occur at low mass flow rates, so dp_test has been lowered to 20 Pa in this example.</p>
</html>", revisions="<html>
<ul>
<li>
June 23, 2015 by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>"));
end FixedRes_TStep;
