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
    fileName="..\\Inputs\\" + "DHWProfile.txt") annotation (Placement(visible=
          true, transformation(
        origin={-52,30.5},
        extent={{-15,15},{15,-15}},
        rotation=0)));

public
  IDEAS.BaseClasses.Ambient1 ambientCold(
    medium=medium,
    constantAmbientPressure=500000,
    constantAmbientTemperature=TCold)
    annotation (Placement(transformation(extent={{68,-28},{88,-8}})));

  IDEAS.BaseClasses.Ambient1 ambientCold1(
    medium=medium,
    constantAmbientPressure=500000,
    constantAmbientTemperature=TCold)
    annotation (Placement(transformation(extent={{70,-64},{90,-44}})));
  Fluid.Movers.Pump pumpCold(
    useInput=true,
    medium=medium,
    m=5,
    m_flowNom=m_flowNom)
    annotation (Placement(transformation(extent={{50,-28},{30,-8}})));

  Fluid.Movers.Pump pumpHot(
    useInput=true,
    medium=medium,
    m_flowNom=m_flowNom,
    m=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,54})));

equation
  table.u = time;
  m_flowInit = table.y[profileType]*VDayAvg*medium.rho;

algorithm
  if m_flowInit > 0 then
    m_minimum := 1e-3;
    onoff := 1;
  else
    m_minimum := 0;
    onoff := 0;
  end if;
  m_flowTotal := onoff*max(m_flowInit, m_minimum);

  m_flowCold := if noEvent(onoff > 0.5) then m_flowTotal*(THot - TSetVar)/(THot
    *onoff - TCold) else 0;
  m_flowHot := if noEvent(onoff > 0.5) then m_flowTotal - m_flowCold else 0;

equation

  connect(ambientCold.flowPort, pumpCold.flowPort_a) annotation (Line(
      points={{68,-18},{50,-18}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pumpCold.flowPort_b, pumpHot.flowPort_b) annotation (Line(
      points={{30,-18},{0,-18},{0,44},{-1.83697e-015,44}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    Icon(graphics),
    Documentation(info="<html>
<p><b>Description</b> </p>
<p>Model of a domestic hot water (DHW) system composed mainly of a thermostatic mixing valve and a table for reading the DHW flow rate. </p>
<p>This model is an extension of the <a href=\"modelica://IDEAS.Thermal.Components.Domestic_Hot_Water.partial_DHW\">Partial_DHW</a> model, see there for the documentation.</p>
<p><h4>Examples</h4></p>
<p>An example of this model is given in <a href=\"modelica://IDEAS.Thermal.Components.Examples.StorageTank_DHW_HP\">IDEAS.Thermal.Components.Examples.StorageTank_DHW_HP</a>.</p>
</html>"));
end DHW_ProfileReader;
