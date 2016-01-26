within Annex60.Experimental.Pipe.Validation;
model ValidationPipeULg "Validation against data from Université de Liège"
  extends Modelica.Icons.Example;
  // R=((1/(2*pipe.lambdaI)*log((0.0603/2+pipe.thicknessIns)/(0.0603/2)))+1/(5*(0.0603+2*pipe.thicknessIns)))/Modelica.Constants.pi
package Medium = Annex60.Media.Water;
  Fluid.Sources.MassFlowSource_T WaterCityNetwork(
    redeclare package Medium = Medium,
    use_m_flow_in=false,
    m_flow=1.245,
    nPorts=1)            annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={70,0})));
  PipeHeatLoss_PipeDelayMod pipe(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    diameter=0.05248,
    length=39,
    thicknessIns(displayUnit="mm") = 0.013,
    lambdaI=0.12,
    R=((1/(2*pipe.lambdaI)*log((0.0603/2+pipe.thicknessIns)/(0.0603/2)))+1/(5*(0.0603+2*pipe.thicknessIns)))/Modelica.Constants.pi)                                                                                                     annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-34,0})));
  Fluid.HeatExchangers.HeaterCooler_T Boiler(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=0)                            annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={16,0})));
  Fluid.Sources.Boundary_pT Sewer1(redeclare package Medium = Medium, nPorts=1)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-84,0})));
  Fluid.Sensors.Temperature senTem_out(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-70,6},{-50,26}})));
  Fluid.Sensors.Temperature senTem_in(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-4,6},{-24,26}})));
  Modelica.Blocks.Sources.CombiTimeTable DataReader(table=pipeDataULg150801.data)
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Data.PipeDataULg150801 pipeDataULg150801
    annotation (Placement(transformation(extent={{-32,-60},{-12,-40}})));
  Modelica.Blocks.Sources.Constant Tamb(k=18) "Ambient temperature in degrees"
    annotation (Placement(transformation(extent={{0,40},{-20,60}})));
  Modelica.Blocks.Math.UnitConversions.From_degC Tin
    "Ambient temperature in degrees"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Modelica.Blocks.Math.UnitConversions.From_degC Tout
    "Ambient temperature in degrees"
    annotation (Placement(transformation(extent={{40,-88},{60,-68}})));
equation
  connect(Sewer1.ports[1], pipe.port_b) annotation (Line(
      points={{-74,0},{-44,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem_out.port, pipe.port_b) annotation (Line(
      points={{-60,6},{-60,0},{-44,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem_in.port, pipe.port_a) annotation (Line(
      points={{-14,6},{-14,0},{-24,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe.port_a, Boiler.port_b) annotation (Line(
      points={{-24,0},{6,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(Boiler.port_a, WaterCityNetwork.ports[1]) annotation (Line(
      points={{26,0},{60,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe.T_amb, Tamb.y) annotation (Line(
      points={{-34,10},{-34,50},{-21,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DataReader.y[5], Tin.u) annotation (Line(
      points={{21,-50},{38,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tin.y, Boiler.TSet) annotation (Line(
      points={{61,-50},{90,-50},{90,30},{34,30},{34,6},{28,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DataReader.y[3], Tout.u) annotation (Line(
      points={{21,-50},{21,-78},{38,-78}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    Documentation(info="<html>
<p>
The example contains <a href=\"modelica://Annex60.Experimental.Pipe.Data.PipeDataULg150801\">
experimental data</a> from a real district heating network. This data is used to validate pipe models.</p>
<p>Pipe's temperature is not initialized, thus the first 70 seconds should be disregarded.</p>

<p><b><span style=\"color: #008000;\">Test bench schematic</span></b> </p>
<p><img src=\"modelica://Annex60/Resources/Images/Experimental/ULgTestBench.png\" border=\"1\"/></p>

<p><b><span style=\"color: #008000;\">Calibration</span></b> </p>
<p>
There are some incertainties about the heat loss coefficient between pipe and surrounding air as well as regarding the heat conductivity of the insulation material. With the <a href=\"modelica://Annex60.Experimental.Pipe.Data.PipeDataULg150801\">
given data</a>, the length specific thermal resistance <code>R = 1.21315 </code> (mK/W). <code>R</code> calculated as follows:
</p>
<p>
<code>R=((1/(2*pipe.lambdaI)*log((0.0603/2+pipe.thicknessIns)/(0.0603/2)))+1/(5*(0.0603+2*pipe.thicknessIns)))/Modelica.Constants.pi</code>  
</p>
<p>
However, it is with <code> R = 0.028 </code> (mK/W) that good results for the outlet temperature when the inlet temperature is close to 68 °C are obtained. Furthermore, a value of <code> R = 0.0155 </code> (mK/W) gives better results for the outlet temperature when the inlet temperature is close to 48 °C.</p>
<p> It seems that a correct value for <code>R</code> should be between 0.0155 (mK/W) and 0.028 (mK/W).</p>
</html>", revisions="<html>
<ul>
<li>
Januar 26, 2016 by Carles Ribas:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(StopTime=875),__Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Experimental/Pipe/Validation/ValidationPipeULg.mos"
        "Simulate and plot"),
    __Dymola_experimentSetupOutput);
end ValidationPipeULg;
