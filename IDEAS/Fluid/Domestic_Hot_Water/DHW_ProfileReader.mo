within IDEAS.Fluid.Domestic_Hot_Water;
model DHW_ProfileReader
  "DHW consumption with profile reader.  RealInput mDHW60C is not used."
  import IDEAS;

  extends IDEAS.Fluid.Domestic_Hot_Water.partial_DHW;

  parameter Modelica.SIunits.Volume VDayAvg "Average daily water consumption";
  parameter Integer profileType=1 "Type of the DHW tap profile";
  Real onoff;
  Real m_minimum(start=0);

  Modelica.Blocks.Tables.CombiTable1Ds table(
    tableOnFile=true,
    tableName="data",
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    columns=2:4,
    fileName="..\\Inputs\\" + "DHWProfile.txt")
    "ratio between the actual DHW mass flow rate (per second) and its average daily mass flow rate (per day)"
                                                                                                        annotation (Placement(visible=
          true, transformation(
        origin={49.5,89.75},
        extent={{10.5,10.25},{-10.5,-10.25}},
        rotation=0)));

  Modelica.Blocks.Math.Product m_flowDHW_actual
    annotation (Placement(transformation(extent={{-2,74},{-22,94}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=time)
    annotation (Placement(transformation(extent={{96,80},{76,100}})));
  Modelica.Blocks.Sources.RealExpression m_flowDHW_ave_day(y=VDayAvg*
        Medium.density(Medium.setState_phX(
        port_hot.p,
        inStream(port_hot.h_outflow),
        inStream(port_hot.Xi_outflow))))
    "average mass flow rate of DHW consumption"
    annotation (Placement(transformation(extent={{112,46},{40,66}})));
equation
  connect(m_flowDHW_actual.y, product.u1) annotation (Line(
      points={{-23,84},{-30,84},{-30,62},{-24,62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flowDHW_ave_day.y, m_flowDHW_actual.u2) annotation (Line(
      points={{36.4,56},{30,56},{30,78},{0,78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(table.y[profileType], m_flowDHW_actual.u1) annotation (Line(
      points={{37.95,89.75},{30,89.75},{30,90},{0,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression1.y, table.u) annotation (Line(
      points={{75,90},{74,90},{74,89.75},{62.1,89.75}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-40},{140,
            100}}),
            graphics),
    Icon(graphics),
    Documentation(info="<html>
<p><b>Description</b> </p>
<p>Model of a domestic hot water (DHW) system composed mainly of a thermostatic mixing valve and a table for reading the DHW flow rate. </p>
<p>This model is an extension of the <a href=\"modelica://IDEAS.Thermal.Components.Domestic_Hot_Water.partial_DHW\">Partial_DHW</a> model, see there for the documentation.</p>
<p>The mass flow rate is calculated with following forumlae: <img src=\"modelica://IDEAS/Images/equations/equation-Ckpbj38b.png\" alt=\"m_flow = phi * m_DWHAve * (T_DHW - T_cold) / (T_hot - T_cold)   \"/></p>
<h4>Examples</h4>
<p>An example of this model is given in <a href=\"modelica://IDEAS.Thermal.Components.Examples.StorageTank_DHW_HP\">IDEAS.Thermal.Components.Examples.StorageTank_DHW_HP</a>.</p>
</html>"));
end DHW_ProfileReader;
