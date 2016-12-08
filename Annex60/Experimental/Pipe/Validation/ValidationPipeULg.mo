within Annex60.Experimental.Pipe.Validation;
model ValidationPipeULg "Validation against data from Université de Liège"
  extends Modelica.Icons.Example;
  // R=((1/(2*pipe.lambdaI)*log((0.0603/2+pipe.thicknessIns)/(0.0603/2)))+1/(5*(0.0603+2*pipe.thicknessIns)))/Modelica.Constants.pi
  package Medium = Annex60.Media.Water;
  Fluid.Sources.MassFlowSource_T WaterCityNetwork(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=1.245,
    use_m_flow_in=true) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={70,0})));
  PipeHeatLossMod pipe(
    redeclare package Medium = Medium,
    diameter=0.05248,
    length=39,
    thicknessIns(displayUnit="mm") = 0.013,
    R=((1/(2*pipe.lambdaI)*log((0.0603/2 + pipe.thicknessIns)/(0.0603/2))) + 1/(
        5*(0.0603 + 2*pipe.thicknessIns)))/Modelica.Constants.pi,
    lambdaI=0.04,
    m_flow_nominal=m_flow_nominal,
    thickness=3.9e-3,
    T_ini_out=T_ini_out,
    T_ini_in=T_ini_in)   annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-34,0})));
  Fluid.HeatExchangers.HeaterCooler_T Boiler(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=0) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={34,0})));
  Fluid.Sources.Boundary_pT Sewer1(redeclare package Medium = Medium, nPorts=1)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,0})));
  Fluid.Sensors.TemperatureTwoPort senTem_out(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0,
    T_start=T_ini_out)
    annotation (Placement(transformation(extent={{-60,-10},{-80,10}})));
  Fluid.Sensors.TemperatureTwoPort senTem_in(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0,
    T_start=T_ini_in)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}})));
  Modelica.Blocks.Sources.CombiTimeTable DataReader(table=pipeDataULg.data,
      extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Modelica.Blocks.Sources.Constant Tamb(k=273 + 18)
    "Ambient temperature in Kelvin";
  Modelica.Blocks.Math.UnitConversions.From_degC Tout
    "Ambient temperature in degrees"
    annotation (Placement(transformation(extent={{40,-88},{60,-68}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=291.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-34,70})));
  Modelica.Blocks.Math.UnitConversions.From_degC Tin
    "Input temperature into pipe"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate, used for regularization near zero flow";
    parameter Modelica.SIunits.Temperature T_ini_in=pipeDataULg.T_ini_in + 273.15
    "Initial temperature at pipe inlet";
  parameter Modelica.SIunits.Temperature T_ini_out=pipeDataULg.T_ini_out + 273.15
    "Initial temperature at pipe outlet";
  replaceable Data.PipeDataULg151204_2
                                     pipeDataULg constrainedby
    Data.BaseClasses.PipeDataULg
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Modelica.Blocks.Math.Gain gain(k=1)
    annotation (Placement(transformation(extent={{52,-30},{72,-10}})));
equation
  connect(Boiler.port_a, WaterCityNetwork.ports[1]) annotation (Line(
      points={{44,0},{60,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(DataReader.y[3], Tout.u) annotation (Line(
      points={{21,-50},{32,-50},{32,-78},{38,-78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fixedTemperature.port, pipe.heatPort)
    annotation (Line(points={{-34,60},{-34,35},{-34,10}}, color={191,0,0}));
  connect(DataReader.y[5], Tin.u)
    annotation (Line(points={{21,-50},{29.5,-50},{38,-50}}, color={0,0,127}));
  connect(Tin.y, Boiler.TSet) annotation (Line(points={{61,-50},{61,-50},{92,-50},
          {92,26},{54,26},{54,6},{46,6}}, color={0,0,127}));
  connect(pipe.port_a, senTem_in.port_b)
    annotation (Line(points={{-24,0},{-10,0}}, color={0,127,255}));
  connect(senTem_in.port_a, Boiler.port_b)
    annotation (Line(points={{10,0},{24,0}}, color={0,127,255}));
  connect(pipe.port_b, senTem_out.port_a)
    annotation (Line(points={{-44,0},{-52,0},{-60,0}}, color={0,127,255}));
  connect(Sewer1.ports[1], senTem_out.port_b) annotation (Line(points={{-100,-1.11022e-015},
          {-90,-1.11022e-015},{-90,0},{-80,0}}, color={0,127,255}));
  connect(gain.y, WaterCityNetwork.m_flow_in) annotation (Line(points={{73,-20},
          {88,-20},{88,8},{80,8}}, color={0,0,127}));
  connect(DataReader.y[1], gain.u) annotation (Line(points={{21,-50},{32,-50},{32,
          -20},{50,-20}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Documentation(info="<html>
<p>The example contains <a href=\"modelica://Annex60.Experimental.Pipe.Data.PipeDataULg150801\">experimental data</a> from a real district heating network. This data is used to validate pipe models.</p>
<p>Pipe&apos;s temperature is not initialized, thus the first 70 seconds should be disregarded. </p>
<p>The insulation used is Tubolit 60/13. For this material, a thermal conductivity of about 0.04 W/m<sup>2</sup>K can be found (<a href=\"http://www.armacell.com/WWW/armacell/ACwwwAttach.nsf/ansFiles/PDS_Range_Tubolit_CHf.pdf/$File/PDS_Range_Tubolit_CHf.pdf\">source</a>).</p>
<p><b><span style=\"color: #008000;\">Test bench schematic</span></b> </p>
<p><img src=\"modelica://Annex60/Resources/Images/Experimental/ULgTestBench.png\"/> </p>
<p><b><span style=\"color: #008000;\">Calibration</span></b> </p>
<p>There are some incertainties about the heat loss coefficient between pipe and surrounding air as well as regarding the heat conductivity of the insulation material. With the <a href=\"modelica://Annex60.Experimental.Pipe.Data.PipeDataULg150801\">given data</a>, the length specific thermal resistance <code>R = 2.164 </code>(mK/W). <code>R</code> calculated as follows: </p>
<p><code>R=((1/(2*pipe.lambdaI)*log((0.0603+2*pipe.thicknessIns)/(0.0603)))+1/(5*(0.0603+2*pipe.thicknessIns)))/Modelica.Constants.pi</code> </p>
<p><code>U = 1/R = 0.462 W/mK </code> </p>
<p><b><span style=\"color: #008000;\">Validation</span></b> </p>
<p>The figure below shows the validation results of the pipe model versus the ULg measurements. </p>
<p>The dynamic discrepancy (during the rise and drop in temperature) could be caused by the following:</p>
<ul>
<li>Inaccuracy of the pipe wall thickness and hence of the pipe wall capacity,</li>
<li>Inaccuracy of the mass flow measurement (applying 95&percnt; of the mass flow of 1.245 kg/s shows an even better fit) or </li>
<li>Negligence of another phenomenon, e.g. turbulent mixing at a temperature front.</li>
</ul>
<p><br>Given the accuracy of the temperature measurements of +/- 0.3K, the validation results are satisfying even though the dynamics are not completely represented by the model.</p>
<p><img src=\"modelica://Annex60/Resources/Images/Experimental/ValidationPipeULg.png\"/></p>
</html>", revisions="<html>
<ul>
<li>November 24, 2016 by Bram van der Heijde:<br>Add pipe thickness for wall capacity calculation and expand documentation section.</li>
<li>April 2, 2016 by Bram van der Heijde:<br>Change thermal conductivity and put boundary condition in K.</li>
<li>Januar 26, 2016 by Carles Ribas:<br>First implementation. </li>
</ul>
</html>"),
    experiment(StopTime=875),
    __Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Experimental/Pipe/Validation/ValidationPipeULg.mos"
        "Simulate and plot"),
    __Dymola_experimentSetupOutput(events=false),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end ValidationPipeULg;
