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
        origin={70,30})));
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
        origin={-40,30})));
  Fluid.HeatExchangers.HeaterCooler_T Boiler(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=0)                            annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={10,30})));
  Fluid.Sources.Boundary_pT Sewer1(redeclare package Medium = Medium, nPorts=1)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-90,30})));
  Fluid.Sensors.Temperature senTem_out(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-80,36},{-60,56}})));
  Fluid.Sensors.Temperature senTem_in(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,36},{-30,56}})));
  Modelica.Blocks.Sources.CombiTimeTable TestDataReader(
    table=pipeDataULg150801.data,
    offset={1.245,5,5,5,16.8},
    startTime=100)
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Data.PipeDataULg150801 pipeDataULg150801
    annotation (Placement(transformation(extent={{-32,-60},{-12,-40}})));
  Modelica.Blocks.Sources.RealExpression Tin(y=273.15 + TestDataReader.y[5])
    annotation (Placement(transformation(extent={{80,60},{40,80}})));
  Modelica.Blocks.Sources.Constant Tamb(k=18) "Ambient temperature in degrees"
    annotation (Placement(transformation(extent={{0,70},{-20,90}})));
equation
  connect(Sewer1.ports[1], pipe.port_b) annotation (Line(
      points={{-80,30},{-50,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem_out.port, pipe.port_b) annotation (Line(
      points={{-70,36},{-70,30},{-50,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem_in.port, pipe.port_a) annotation (Line(
      points={{-20,36},{-20,30},{-30,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe.port_a, Boiler.port_b) annotation (Line(
      points={{-30,30},{0,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(Boiler.TSet, Tin.y) annotation (Line(
      points={{22,36},{30,36},{30,70},{38,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Boiler.port_a, WaterCityNetwork.ports[1]) annotation (Line(
      points={{20,30},{60,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe.T_amb, Tamb.y) annotation (Line(
      points={{-40,40},{-40,80},{-21,80}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    Documentation(info="<html>
<p>
The example contains experimental data from a real DHN. See <a href=\"modelica://Annex60.Experimental.Pipe.Data.PipeDatauLg150801\">
experimental data</a> for more information. This data is used to validate a pipe model.</p>

<p><b><span style=\"color: #008000;\">Test bench schematic</span></b> </p>
<p><img src=\"modelica://Annex60/Resources/Images/Experimental/ULgTestBench.png\" border=\"1\"/></p>

<p><b><span style=\"color: #008000;\">Calibration</span></b> </p>
<p>
There are some incertainties about the heat loss coefficient between pipe and surrounding air as weel as regarding the heat conductivity of the insulation. With the given data, the length specific thermal resistance <code>R = 1.21315 </code> (mK/W). <code>R</code> calculated as follows:  <code>R=((1/(2*pipe.lambdaI)*log((0.0603/2+pipe.thicknessIns)/(0.0603/2)))+1/(5*(0.0603+2*pipe.thicknessIns)))/Modelica.Constants.pi</code>  
</p>
<p>
However, it is with <code> R = 0.028 </code> (mK/W) that good results for the outlet temperature when the inlet temperature is close to 68 °C are obtained. Furthermore, a value of <code> R = 0.0155 </code> (mK/W) gives better results for the outlet temperature when the inlet temperature is close to 48 °C.</p>
<p> It seems that a correct value for <code>R</code> should be between 0.0155 (mK/W) and 0.028 (mK/W).
</p>
</html>", revisions="<html>
<ul>
<li>
Januar 19, 2016 by Carles Ribas:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(StopTime=975),
    __Dymola_experimentSetupOutput);
end ValidationPipeULg;
