within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Extras;
model MultipleBoreHoles_signals
  "Calculates the average fluid temperature T_fts of the borefield for a given (time dependent) load Q_flow. The outputs are of type Real instead of fluid port"

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

  Modelica.Blocks.Sources.RealExpression sinTemp(y= T_hcf_in)
    "medium temperature of the sink"
    annotation (Placement(transformation(extent={{-50,-10},{-70,10}})));
  Modelica.Blocks.Sources.RealExpression souTemp( y = T_hcf_out)
    "medium temperature of the source"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Interfaces.RealOutput T_sin "sink temperature" annotation (
      Placement(transformation(extent={{-88,-10},{-108,10}}),
        iconTransformation(extent={{-88,-10},{-108,10}})));
  Modelica.Blocks.Interfaces.RealOutput T_sou "Source temperature" annotation (
      Placement(transformation(extent={{88,-10},{108,10}}), iconTransformation(
          extent={{88,-10},{108,10}})));
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

  connect(souTemp.y, T_sou) annotation (Line(
      points={{61,0},{98,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sinTemp.y, T_sin) annotation (Line(
      points={{-71,0},{-98,0}},
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{
            140,140}}), graphics));
end MultipleBoreHoles_signals;
