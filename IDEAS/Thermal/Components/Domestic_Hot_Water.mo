within IDEAS.Thermal.Components;
package Domestic_Hot_Water "Domestic Hot Water"

  extends Modelica.Icons.Package;

  model DHW_ProfileReader
    "DHW consumption with profile reader.  RealInput mDHW60C is not used."

  extends IDEAS.Thermal.Components.Domestic_Hot_Water.partial_DHW;

    parameter Modelica.SIunits.Volume VDayAvg "Average daily water consumption";
    parameter Integer profileType = 1 "Type of the DHW tap profile";
    Real onoff;
    Real m_minimum(start=0);

    Modelica.Blocks.Tables.CombiTable1Ds table(
      tableOnFile = true,
      tableName = "data",
      smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
      columns=2:4,
      fileName="..\\Inputs\\" + "DHWProfile.txt")
      annotation(Placement(visible = true, transformation(origin={-52,30.5},   extent={{-15,15},
              {15,-15}},                                                                                     rotation = 0)));

  public
    Thermal.Components.BaseClasses.Ambient ambientCold(
      medium=medium,
      constantAmbientPressure=500000,
      constantAmbientTemperature=TCold)
      annotation (Placement(transformation(extent={{68,-28},{88,-8}})));

    Thermal.Components.BaseClasses.Ambient ambientCold1(
      medium=medium,
      constantAmbientPressure=500000,
      constantAmbientTemperature=TCold)
      annotation (Placement(transformation(extent={{70,-64},{90,-44}})));
    Thermal.Components.BaseClasses.Pump pumpCold(
      useInput=true,
      medium=medium,
      m=5,
      m_flowNom=m_flowNom)
      annotation (Placement(transformation(extent={{50,-28},{30,-8}})));

    Thermal.Components.BaseClasses.Pump pumpHot(
      useInput=true,
      medium=medium,
      m_flowNom=m_flowNom,
      m=1)                 annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={0,54})));

  equation
    table.u =  time;
    m_flowInit = table.y[profileType]* VDayAvg * medium.rho;

  algorithm
    if m_flowInit > 0 then
      m_minimum :=1e-3;
      onoff :=1;
    else
      m_minimum :=0;
      onoff :=0;
    end if;
    m_flowTotal := onoff * max(m_flowInit, m_minimum);

    m_flowCold := if noEvent(onoff > 0.5) then m_flowTotal* (THot - TSetVar)/(THot*onoff-TCold) else 0;
    m_flowHot := if noEvent(onoff > 0.5) then m_flowTotal - m_flowCold else 0;

  equation

    connect(ambientCold.flowPort, pumpCold.flowPort_a)
                                                   annotation (Line(
        points={{68,-18},{50,-18}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(pumpCold.flowPort_b, pumpHot.flowPort_b)
                                               annotation (Line(
        points={{30,-18},{0,-18},{0,44},{-1.83697e-015,44}},
        color={255,0,0},
        smooth=Smooth.None));
    annotation (Diagram(graphics), Icon(graphics),
      Documentation(info="<html>
<p><b>Description</b> </p>
<p>Model of a domestic hot water (DHW) system composed mainly of a thermostatic mixing valve and a table for reading the DHW flow rate. </p>
<p>This model is an extension of the <a href=\"modelica://IDEAS.Thermal.Components.Domestic_Hot_Water.partial_DHW\">Partial_DHW</a> model, see there for the documentation.</p>
<p><h4>Examples</h4></p>
<p>An example of this model is given in <a href=\"modelica://IDEAS.Thermal.Components.Examples.StorageTank_DHW_HP\">IDEAS.Thermal.Components.Examples.StorageTank_DHW_HP</a>.</p>
</html>"));
  end DHW_ProfileReader;

  model DHW_RealInput "DHW consumption with input for flowrate at 60 degC"

    extends IDEAS.Thermal.Components.Domestic_Hot_Water.partial_DHW;

  equation
    m_flowInit = mDHW60C;

  algorithm
    m_flowTotal := mDHW60C * (273.15+60-TCold) / (TDHWSet - TCold);
    m_flowCold := m_flowTotal* (THot - TSetVar)/(THot-TCold);
    m_flowHot := m_flowTotal - m_flowCold;

  equation
    connect(ambientCold.flowPort, pumpCold.flowPort_a)
                                                   annotation (Line(
        points={{68,-18},{50,-18}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(flowPortHot, pumpHot.flowPort_a)
                                            annotation (Line(
        points={{-100,0},{-100,64},{1.83697e-015,64}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(pumpHot.flowPort_b, ambientMixed.flowPort)
                                                     annotation (Line(
        points={{-1.83697e-015,44},{0,44},{0,44},{126,44}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(pumpCold.flowPort_b, pumpHot.flowPort_b)
                                               annotation (Line(
        points={{30,-18},{0,-18},{0,44},{-1.83697e-015,44}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(ambientCold1.flowPort, flowPortCold) annotation (Line(
        points={{70,-54},{140,-54},{140,0}},
        color={255,0,0},
        smooth=Smooth.None));
    annotation (Diagram(graphics), Documentation(info="<html>
<p><b>Description</b> </p>
<p>Model of a domestic hot water (DHW) system composed mainly of a thermostatic mixing valve. The DHW flow rate is passed as a realInput.</p>
<p>This model is an extension of the <a href=\"modelica://IDEAS.Thermal.Components.Domestic_Hot_Water.partial_DHW\">Partial_DHW</a> model, see there for the documentation.</p>
<p><h4>Examples</h4></p>
<p>An example of this model is given in <a href=\"modelica://IDEAS.Thermal.Components.Examples.StorageTank_DHW_HP\">IDEAS.Thermal.Components.Examples.StorageTank_DHW_HP</a>.</p>
</html>"));
  end DHW_RealInput;

  partial model partial_DHW "partial DHW model"

    parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water();
    parameter Modelica.SIunits.Temperature TDHWSet(max=273.15+60) = 273.15 + 45
      "DHW temperature setpoint";
    parameter Modelica.SIunits.Temperature TCold=283.15;
    Modelica.SIunits.Temperature THot "Temperature of the hot source";
    Modelica.SIunits.Temperature TMixed(start=TDHWSet)=pumpHot.flowPort_b.h
      /medium.cp "Temperature of the hot source";

    Modelica.SIunits.MassFlowRate m_flowInit(start=0)
      "Initial mass flowrate of total DHW consumption";
    Modelica.SIunits.MassFlowRate m_flowTotal(start=0)
      "mass flowrate of total DHW consumption at TDHWSet, takes into account cut-off at very low flowrates";
    Modelica.SIunits.MassFlowRate m_flowCold(start=0)
      "mass flowrate of cold water to the mixing point";
    Modelica.SIunits.MassFlowRate m_flowHot(start=0)
      "mass flowrate of hot water to the mixing point";
    Modelica.SIunits.Power QHeatTotal = m_flowTotal * medium.cp * ( TMixed - TCold);

    // we need to specify the flowrate in the pump and mixingValve as relative values between 0 and 1
    // so we compute a maximum flowrate and use this as nominal flowrate for these components
    // We suppose the flowrate will always be lower than 1e3 kg/s.

  protected
    parameter Modelica.SIunits.MassFlowRate m_flowNom=1e3
      "only used to set a reference";
    Real m_flowHotInput = m_flowHot/m_flowNom;
    Real m_flowColdInput = m_flowCold/m_flowNom;
    Real TSetVar;

    /*
  Slows down the simulation too much.  Should be in post processing
  Real m_flowIntegrated(start = 0, fixed = true);
  Real m_flowDiscomfort(start=0);
  Real discomfort; //base 1
  Real discomfortWeighted;
  Real dTDiscomfort;
  */

  public
    Thermal.Components.BaseClasses.Ambient ambientCold(
      medium=medium,
      constantAmbientPressure=500000,
      constantAmbientTemperature=TCold)
      annotation (Placement(transformation(extent={{68,-28},{88,-8}})));
    Thermal.Components.BaseClasses.Ambient ambientMixed(
      medium=medium,
      constantAmbientPressure=400000,
      constantAmbientTemperature=283.15)
      annotation (Placement(transformation(extent={{126,34},{146,54}})));
    Thermal.Components.Interfaces.FlowPort_a flowPortHot(medium=medium)
      annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
          iconTransformation(extent={{-110,-10},{-90,10}})));
    Thermal.Components.Interfaces.FlowPort_a flowPortCold(medium=medium)
      annotation (Placement(transformation(extent={{130,-10},{150,10}}),
          iconTransformation(extent={{130,-10},{150,10}})));

    Thermal.Components.BaseClasses.Ambient ambientCold1(
      medium=medium,
      constantAmbientPressure=500000,
      constantAmbientTemperature=TCold)
      annotation (Placement(transformation(extent={{70,-64},{90,-44}})));
    Thermal.Components.BaseClasses.Pump pumpCold(
      useInput=true,
      medium=medium,
      m=5,
      m_flowNom=m_flowNom)
      annotation (Placement(transformation(extent={{50,-28},{30,-8}})));

    Thermal.Components.BaseClasses.Pump pumpHot(
      useInput=true,
      medium=medium,
      m_flowNom=m_flowNom,
      m=1)                 annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={0,54})));

    Modelica.Blocks.Interfaces.RealInput mDHW60C
      "Mass flowrate of DHW at 60 degC in kg/s"
      annotation (Placement(transformation(extent={{-74,70},{-34,110}}),
          iconTransformation(
          extent={{10,10},{-10,-10}},
          rotation=90,
          origin={20,100})));
  equation
    pumpCold.m_flowSet = m_flowColdInput;
    pumpHot.m_flowSet = m_flowHotInput;

    /*
  // computation of DHW discomfort: too slow here, ==> post processing
  der(m_flowIntegrated) =m_flowTotal;
  der(m_flowIntegrated) = m_flowTotal;
  der(m_flowDiscomfort) = if noEvent(TMixed < TDHWSet) then m_flowTotal else 0;
  der(discomfortWeighted) = if noEvent(TMixed < TDHWSet) then m_flowTotal * (TDHWSet - TMixed) else 0;
  discomfort = m_flowDiscomfort / max(m_flowIntegrated, 1);
  dTDiscomfort = discomfortWeighted / max(m_flowDiscomfort,1);
  */
  algorithm

    THot := pumpHot.T;
    // put in the extended models: m_flowTotal := ...
    TSetVar := min(THot,TDHWSet);

  equation
    connect(ambientCold.flowPort, pumpCold.flowPort_a)
                                                   annotation (Line(
        points={{68,-18},{50,-18}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(flowPortHot, pumpHot.flowPort_a)
                                            annotation (Line(
        points={{-100,0},{-100,64},{1.83697e-015,64}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(pumpHot.flowPort_b, ambientMixed.flowPort)
                                                     annotation (Line(
        points={{-1.83697e-015,44},{126,44}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(pumpCold.flowPort_b, pumpHot.flowPort_b)
                                               annotation (Line(
        points={{30,-18},{0,-18},{0,44},{-1.83697e-015,44}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(ambientCold1.flowPort, flowPortCold) annotation (Line(
        points={{70,-54},{140,-54},{140,0}},
        color={255,0,0},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(extent={{-100,-40},{140,100}},
            preserveAspectRatio=false),
                        graphics), Icon(coordinateSystem(extent={{-100,-40},{
              140,100}},
            preserveAspectRatio=false), graphics={
          Line(
            points={{-20,30},{20,-30},{-20,-30},{20,30},{-20,30}},
            color={100,100,100},
            smooth=Smooth.None,
            origin={-30,0},
            rotation=-90),
          Line(
            points={{-70,0},{-70,0},{-100,0}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{20,40},{20,0},{20,0}},
            color={100,100,100},
            smooth=Smooth.None),
          Line(
            points={{0,40},{40,40},{34,80},{4,80},{0,40}},
            color={100,100,100},
            smooth=Smooth.None),
          Line(
            points={{-70,20},{-70,-20}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{140,0},{140,0},{110,0}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{110,18},{110,-22}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{-20,30},{20,-30},{-20,-30},{20,30},{-20,30}},
            color={100,100,100},
            smooth=Smooth.None,
            origin={70,0},
            rotation=-90),
          Line(
            points={{0,0},{40,0},{40,-2}},
            color={100,100,100},
            smooth=Smooth.None)}),
      Documentation(info="<html>
<p><b>Description</b> </p>
<p>Partial model of a domestic hot water (DHW) system composed mainly of a thermostatic mixing valve. The model foresees a cold water flowPort which has to be connected to the system (eg. storage tank).</p>
<p>The model has two flowPorts and a realInput:</p>
<p><ul>
<li><i>flowPortHot</i>: connection to the hot water source (designation: <i>hot</i>)</li>
<li><i>flowPortDold</i>: connection to the inlet of cold water in the hot water source (designation: <i>cold</i>)</li>
<li><i>mDHW60C</i>: desired flowrate of DHW water (designation: <i>mixed</i>), equivalent at 60&deg;C</li>
</ul></p>
<p>In a first step, the desired DHW flow rate is computed based on <i>mDHW60C</i> and the set temperature <i>TDHWSet</i>.  The model tries to reach the given DHW flow rate at a the desired mixing temperature <i>TDHWSet </i>by mixing the hot water with cold water. The resulting hot flowrate will be extracted automatically from the hot source, and through the connection of flowPortCold to the hot source, this same flow rate will be injected (at TCold) in the production system. </p>
<p>There are currently two implementations of this partial model:</p>
<p><ol>
<li><a href=\"modelica://IDEAS.Thermal.Components.Domestic_Hot_Water.DHW_ProfileReader\">Reading in mDHW60c from a table</a></li>
<li><a href=\"modelica://IDEAS.Thermal.Components.Domestic_Hot_Water.DHW_RealInput\">Getting mDHW60c from a realInput</a></li>
</ol></p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>No heat losses</li>
<li>Inertia is foreseen through the inclusion of a water volume on the hot water side (default=1 liter). This parameter is not propagated to the interface, but it can be changed by modifying pumpHot.m.  Putting this water content to zero may lead to numerical problems (not tested)</li>
<li>If THot &LT; TDHWSEt, there is no mixing and TMixed = THot</li>
<li>Fixed TDHWSet and TCold as parameters</li>
<li>The mixed DHW is not available as an outlet or flowPort, it is assumed to be &apos;consumed&apos;. </li>
</ol></p>
<p><h4>Model use</h4></p>
<p><ol>
<li>Set the parameters for cold water temperature and the DHW set temperature (mixed)</li>
<li>Connect <i>flowPortHot </i>to the hot water source</li>
<li>Connect <i>flowPortCold</i> to the cold water inlet of the hot water source</li>
<li>Depending on the implementation: fill out the table or provide a realInput for <i>mDHW60C</i></li>
<li>Thanks to the use of <a href=\"modelica://IDEAS.Thermal.Components.BaseClasses.Ambient\">ambient</a> components in this model, it is <b>NOT</b> required to add additional pumps, ambients or AbsolutePressure to the DHW circuit.</li>
</ol></p>
<p><h4>Validation </h4></p>
<p>The model is verified to work properly by simulation of the different operating conditions.</p>
<p><h4>Examples</h4></p>
<p>An example of this model is given in <a href=\"modelica://IDEAS.Thermal.Components.Examples.StorageTank_DHW_HP\">IDEAS.Thermal.Components.Examples.StorageTank_DHW_HP</a>.</p>
</html>", revisions="<html>
<p><ul>
<li>2013 June, Roel De Coninck: documentation.</li>
<li>2012 September, Roel De Coninck, simplification of equations.</li>
<li>2012 August, Roel De Coninck, first implementation.</li>
</ul></p>
</html>"));
  end partial_DHW;
end Domestic_Hot_Water;
