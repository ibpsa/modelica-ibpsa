within IBPSA.Fluid.PVTCollectors.Validation.PVT_UI.Electrical;
model PVT_UI_Electrical_DayType1
  "Validation model for an unglazed rear-insulated PVT Collector"
  extends .Modelica.Icons.Example;

  replaceable package Medium = .IDEAS.Media.Water "Medium model";
  replaceable parameter .IDEAS.Fluid.PVTCollectors.Data.Uncovered.UI_Validation datPVTCol "Collector parameter record"
  annotation (Placement(transformation(extent={{74,-26},{94,-6}})));
  parameter String pvtTyp = "Typ1" "Type identifier for selecting the UI measurement dataset";
  parameter .Modelica.Units.SI.Temperature T_start = 30.65195319 + 273.15 "Initial temperature (from measurement data)";
  parameter Real eleLosFac = 0.09  "Electrical system loss factor of the PV module";
  parameter Real til = 0.78539816339745 "Collector tilt angle [rad]";
  parameter Real azi = 0 "Collector azimuth angle [rad]";
  parameter Real rho = 0.2 "Ground reflectance (albedo)";
  parameter Integer nPanels = 1 "Number of PVT panels connected in the model";
  parameter Integer idxTFlu = 13 "Column index for fluid inlet temperature";
  parameter Integer idxMFlow = 17 "Column index for mass flow rate";
  parameter Integer idxGtil = 2 "Column index for global irradiance in collector plane";
  parameter Integer idxWinSpe = 10 "Column index for wind speed";
  parameter Integer idxTAmb = 12 "Column index for ambient temperature";
  parameter Integer idxMeaPel = 21 "Column index for measured electrical power";
  parameter String meaFile = "modelica://IDEAS/Resources/Data/Fluid/PVTCollectors/Validation/PVT_UI/PVT_UI_" + pvtTyp + "_measurements.txt" "Full path to measurement file";

  inner .Modelica.Blocks.Sources.CombiTimeTable meaDat(
    tableOnFile=true,
    tableName="data",
    fileName=.Modelica.Utilities.Files.loadResource(meaFile),
    columns=1:25) annotation (Placement(transformation(extent={{-92,4},{-72,24}})));

  replaceable .IDEAS.Fluid.PVTCollectors.Validation.PVT_UI.PVTCollectorValidation pvtCol(
    redeclare package Medium = Medium,
    energyDynamics=.Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=.Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=T_start,
    show_T=true,
    azi=azi,
    til=til,
    rho=rho,
    nColType=.IDEAS.Fluid.SolarCollectors.Types.NumberSelection.Number,
    nPanels=nPanels,
    per=datPVTCol,
    eleLosFac=eleLosFac)
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));

  .Modelica.Thermal.HeatTransfer.Celsius.ToKelvin TFluKel annotation (Placement(transformation(extent={{-87,-21},
            {-77,-11}})));
  .Modelica.Thermal.HeatTransfer.Celsius.ToKelvin TAmbKel;

  .IDEAS.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    p = 101325,
    nPorts=1) "Outlet for water flow"
    annotation (Placement(transformation(extent={{62,-30},{42,-10}})));
  .IDEAS.Fluid.Sources.MassFlowSource_T bou(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    m_flow=0.03,
    use_T_in=true,
    nPorts=1) "Inlet for water flow, at a prescribed flow rate and temperature"
    annotation (Placement(transformation(extent={{-58,-30},{-38,-10}})));
  .IDEAS.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        .Modelica.Utilities.Files.loadResource("modelica://IDEAS/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data input file"
    annotation (Placement(transformation(extent={{-52,8},{-32,28}})));
  .IDEAS.Fluid.PVTCollectors.Validation.BaseClasses.ElectricalPV electricalPV(
      P_STC=datPVTCol.P_nominal,
      beta=datPVTCol.beta,
      eleLosFac=eleLosFac,
      n=nPanels,
      module_efficiency=datPVTCol.etaEl,
      til=til,
      azi=azi)
    annotation (Placement(transformation(extent={{-80,-84},{-60,-64}})));
  .Modelica.Blocks.Sources.RealExpression meaPel(y=meaDat.y[idxMeaPel])
  "Measured electrical power [W]" annotation (Placement(transformation(extent={{-87,52},{-61,68}})));
  .Modelica.Blocks.Sources.RealExpression UAbsFluid(y=pvtCol.eleGen.UAbsFluid)
    "Absorber-fluid heat transfer coefficient [W/m2K]" annotation (Placement(transformation(extent={{11,46},{37,62}})));
  .Modelica.Blocks.Sources.RealExpression simPel(y=pvtCol.Pel)
  "Electrical power simulated by PVT model [W]" annotation (Placement(transformation(extent={{-51,52},{-25,68}})));
  .Modelica.Blocks.Sources.RealExpression simPelPV(y=electricalPV.P)
  "Electrical power from standalone PV model [W]"  annotation (Placement(transformation(extent={{-49,-74},{-23,-58}})));
  .Modelica.Blocks.Sources.RealExpression simTcellPV(y=electricalPV.T_cell -
        273.15) "PV-only cell temperature [°C]"  annotation (Placement(transformation(extent={{-49,-92},{-23,-76}})));
  .Modelica.Blocks.Sources.RealExpression simTcell(y=pvtCol.eleGen.TavgCel -
        273.15) "PVT cell temperature [°C]"  annotation (Placement(transformation(extent={{-51,40},{-25,56}})));

equation
  connect(meaDat.y[idxTFlu],TFluKel. Celsius) annotation (Line(points={{-71,14},
          {-68,14},{-68,-6},{-92,-6},{-92,-16},{-88,-16}},                                              color={0,0,127}));
  connect(bou.T_in,TFluKel. Kelvin)        annotation (Line(points={{-60,-16},{-76.5,
          -16}},                                                                        color={0,0,127}));
  connect(bou.m_flow_in, meaDat.y[idxMFlow])
    annotation (Line(points={{-60,-12},{-68,-12},{-68,14},{-71,14}},
                                                         color={0,0,127}));
  connect(bou.ports[1],pvtCol. port_a)
    annotation (Line(points={{-38,-20},{-10,-20}},
                                               color={0,127,255}));
  connect(pvtCol.port_b, sou.ports[1])
    annotation (Line(points={{10,-20},{42,-20}},
                                             color={0,127,255}));
  connect(weaDat.weaBus,pvtCol. weaBus) annotation (Line(
      points={{-32,18},{-14,18},{-14,-12},{-10,-12}},
      color={255,204,51},
      thickness=0.5));
  connect(meaDat.y[idxGtil], electricalPV.Gtil);
  connect(meaDat.y[idxWinSpe], electricalPV.winSpe);
  connect(meaDat.y[idxTAmb], TAmbKel.Celsius);
  connect(TAmbKel.Kelvin, electricalPV.Tamb);
  annotation (
    Documentation(info="<html>
<p>
See the documentation of
<a href=\"modelica://IDEAS.Fluid.PVTCollectors.Validation.PVT_UI\">
IDEAS.Fluid.PVTCollectors.Validation.PVT_UI
</a>
for details on the validation examples and usage.
</p>
</html>", revisions=
"<html>
<ul>
<li>
March 11, 2026, by Lone Meertens:<br/>
Updated thermal formulation from ISO 9806:2013 to ISO 9806:2017. 
This is for <a href=\"https://github.com/open-ideas/IDEAS/issues/1473\">#1473</a>.
</li>
<li>
July 7, 2025, by Lone Meertens:<br/>
First implementation PVT model.
This is for <a href=\"https://github.com/open-ideas/IDEAS/issues/1436\">#1436</a>.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://IDEAS/Resources/Scripts/Dymola/Fluid/PVTCollectors/Validation/PVT_UI/Electrical/PVT_UI_Electrical_DayType1.mos"
        "Simulate and plot"),
 experiment(
      StartTime=18872521.2,
      StopTime=18908900.2,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Diagram(graphics={
        Rectangle(extent={{8,86},{42,46}},    lineColor={28,108,200}),
        Text(
          extent={{4,84},{44,66}},
          textColor={28,108,200},
          textStyle={TextStyle.Bold},
          textString="Calculated 
UAbsFluid 
[W/m2K]"),
        Rectangle(extent={{-92,88},{-18,42}},   lineColor={28,108,200}),
        Text(
          extent={{-90,94},{-24,66}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textStyle={TextStyle.Bold},
          textString="Measured and simulated
electrical power"),
        Rectangle(extent={{-88,-56},{-16,-92}}, lineColor={28,108,200})}));
end PVT_UI_Electrical_DayType1;
