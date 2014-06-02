within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield;
model MultipleBoreHoles_IDEAS "Calculates the average fluid temperature T_fts of the borefield for a given (time dependent) load Q_flow.
  Compatible with the IDEAS library"

  // FIXME:
  //  1) make it possible to run model without pre-compilation of g-function (short term)
  //  2) make it possible to run model with full pre-compilation of g-fuction (short and long term)

  // Medium in borefield
  parameter IDEAS.Thermal.Data.Interfaces.Medium medium=IDEAS.Thermal.Data.Media.WaterBuildingsLib()  annotation (__Dymola_choicesAllMatching=true);

  extends BaseClasses.partial_MultipleBoreHoles(     p_max=5, lenSim=3600*24*50);

  Modelica.SIunits.Temperature T_hcf_out
    "Temperature of the medium of the sink";
  Modelica.SIunits.Temperature T_hcf_in
    "Temperature of the medium of the source";

public
  IDEAS.Thermal.Components.BaseClasses.Ambient sink(useTemperatureInput=true,medium = medium)
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  IDEAS.Thermal.Components.Interfaces.FlowPort_b flowPort_b(medium=medium)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}}),
        iconTransformation(extent={{-100,-10},{-80,10}})));
  IDEAS.Thermal.Components.BaseClasses.Ambient sou(useTemperatureInput=true,medium = medium)
    annotation (Placement(transformation(extent={{70,-10},{50,10}})));
  IDEAS.Thermal.Components.Interfaces.FlowPort_a flowPort_a(medium = medium)
    annotation (Placement(transformation(extent={{80,-8},{100,12}}),
        iconTransformation(extent={{80,-8},{100,12}})));
  Modelica.Blocks.Sources.RealExpression sinTemp(y= T_hcf_in)
    "medium temperature of the sink"
    annotation (Placement(transformation(extent={{-12,-40},{-32,-20}})));
  Modelica.Blocks.Sources.RealExpression souTemp( y = T_hcf_out)
    "medium temperature of the source"
    annotation (Placement(transformation(extent={{10,-40},{30,-20}})));
equation
  //if the heat flow is very low, the enthalpie is the same at the inlet and outlet
  if abs(Q_flow) > 10^(-3) then
    T_hcf_in = T_fts - Q_flow/(bfData.steRes.m_flow
      *bfData.geo.nbBh/bfData.geo.nbSer)/medium.cp/2;
    T_hcf_out = T_fts + Q_flow/(bfData.steRes.m_flow
      *bfData.geo.nbBh/bfData.geo.nbSer)/medium.cp/2;
  else
    T_hcf_in = T_fts;
    T_hcf_out = T_fts;
  end if;

  connect(sink.flowPort, flowPort_b) annotation (Line(
      points={{-70,0},{-90,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sou.flowPort, flowPort_a) annotation (Line(
      points={{70,0},{80,0},{80,2},{90,2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sinTemp.y, sink.ambientTemperature) annotation (Line(
      points={{-33,-30},{-40,-30},{-40,-7},{-50,-7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(souTemp.y, sou.ambientTemperature) annotation (Line(
      points={{31,-30},{46,-30},{46,-7},{50,-7}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    experiment(StopTime=70000, __Dymola_NumberOfIntervals=50),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,
            140}}), graphics={
        Rectangle(
          extent={{-90,90},{90,-90}},
          lineColor={0,0,0},
          fillColor={234,210,210},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{10,-10},{70,-70}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{10,70},{70,10}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-70,70},{-10,10}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-70,-10},{-10,-70}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-62,62},{-18,18}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{18,62},{62,18}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-62,-18},{-18,-62}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{18,-18},{62,-62}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Text(
          extent={{-76,156},{74,98}},
          lineColor={0,0,255},
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,
            140}}),     graphics));
end MultipleBoreHoles_IDEAS;
