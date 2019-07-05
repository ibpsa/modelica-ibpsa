within IBPSA.Utilities.IO;
package SignalExchange
  "External Signal Exchange Package"
  extends Modelica.Icons.Package;
  block Overwrite "Block that allows a signal to overwritten by an FMU input"
    extends Modelica.Blocks.Interfaces.SISO;
    parameter String Description "Describes the signal being overwritten";
    Modelica.Blocks.Logical.Switch swi
      "Switch between external signal and direct feedthrough signal"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Modelica.Blocks.Sources.RealExpression uExt "External input signal"
      annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
    Modelica.Blocks.Sources.BooleanExpression activate
      "Block to activate use of external signal"
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  protected
    final parameter Boolean boptestOverwrite = true
      "Protected parameter, used by tools to search for overwrite block in models";
  equation
    connect(activate.y, swi.u2)
      annotation (Line(points={{-39,0},{-12,0}}, color={255,0,255}));
    connect(swi.u3, u) annotation (Line(points={{-12,-8},{-80,-8},{-80,0},{-120,
            0}}, color={0,0,127}));
    connect(uExt.y, swi.u1) annotation (Line(points={{-39,20},{-26,20},{-26,8},
            {-12,8}}, color={0,0,127}));
    connect(swi.y, y)
      annotation (Line(points={{11,0},{110,0}}, color={0,0,127}));
    annotation (Documentation(info="<html>
<p>
This block enables the overwriting of a control signal by an external program,
as well as reading of its meta-data, without the need to explicitly propogate 
the external input or activation switch to a top-level model.
</p>
<h4>Typical use and important parameters</h4>
<p>
This block is typically used by the BOPTEST framework 
(see <a href=\"https://github.com/ibpsa/project1-boptest\">BOPTEST</a>)
to identify and activate control signals that can be overwritten by test 
controllers.  It is used in combination with a dedicated parser to perform 
this task (see <a href=\"https://github.com/ibpsa/project1-boptest/tree/master/parsing\">Parser Code</a>).
</p>
<p>
The input <code>u</code> is the signal to be overwritten.  The output
<code>y</code> will be equal to the input signal if the <code>activate</code>
flag is false and will be equal to the external input signal <code>uExt</code>
if the flag is true.
</p>
<p>
It is important to add a brief description of the signal using the 
<code>Description</code> parameter and assign a <code>min</code>, 
<code>max</code>, and <code>unit</code> to the input variable <code>u</code>
by modifying its attributes.
</p>
</html>",
  revisions="<html>
<ul>
<li>
December 17, 2018 by David Blum:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1059\">#1059</a>.
</li>
</ul>
</html>"),  Icon(graphics={
          Line(points={{100,0},{42,0}}, color={0,0,127}),
          Line(points={{42,0},{-20,60}},
          color={0,0,127}),
          Line(points={{42,0},{-20,0}},
          color = DynamicSelect({235,235,235}, if activate.y then {235,235,235}
                      else {0,0,0})),
          Line(points={{-100,0},{-20,0}}, color={0,0,127}),
          Line(points={{-62,60},{-20,60}},  color={0,0,127}),
          Polygon(
            points={{-58,70},{-28,60},{-58,50},{-58,70}},
            lineColor={0,0,127},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-22,62},{-18,58}},
            lineColor={0,0,127},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-22,2},{-18,-2}},
            lineColor={0,0,127},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{40,2},{44,-2}},
            lineColor={0,0,127},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid),
          Line(points={{-16,0},{16,0}},     color={0,0,127},
            origin={-62,60},
            rotation=90),
          Line(points={{-16,0},{16,0}},     color={0,0,127},
            origin={-66,60},
            rotation=90),
          Line(points={{-16,0},{16,0}},     color={0,0,127},
            origin={-70,60},
            rotation=90),
          Ellipse(
            extent={{-77,67},{-91,53}},
            fillPattern=FillPattern.Solid,
            lineColor=DynamicSelect({235,235,235}, if activate.y then {0,255,0}
                      else {235,235,235}),
            fillColor=DynamicSelect({235,235,235}, if activate.y then {0,255,0}
                      else {235,235,235}))}));
  end Overwrite;

  model Read "Block that allows a signal to be read as an FMU output"
    extends Modelica.Blocks.Routing.RealPassThrough;
    parameter String Description "Describes the signal being read";
    parameter SignalTypes.SignalsForKPIs KPIs = SignalTypes.SignalsForKPIs.None
      "Tag with the type of signal for the calculation of the KPIs";

  protected
    final parameter Boolean boptestRead = true
      "Protected parameter, used by tools to search for read block in models";
    annotation (Documentation(info="<html>
<p>
This block enables the reading of a signal and its meta-data by an external 
program without the need to explicitly propogate the signal to a top-level model.
</p>
<h4>Typical use and important parameters</h4>
<p>
This block is typically used by the BOPTEST framework 
(see <a href=\"https://github.com/ibpsa/project1-boptest\">BOPTEST</a>)
to identify and read signals as measurements by test 
controllers.  It is used in combination with a dedicated parser to perform 
this task (see <a href=\"https://github.com/ibpsa/project1-boptest/tree/master/parsing\">Parser Code</a>).
This block is also used by BOPTEST to specify if the signal is needed
for calculation of specific key performance indicators (KPI).  
</p>
<p>
The block output <code>y</code> is equal to the input <code>u</code> so that
the block can be used in line with connections.  However, input signal will
also be directed to an external program as an output.
</p>
<p>
It is important to add a brief description of the signal using the 
<code>Description</code> parameter and assign a type if needed for KPI 
calculation using the <code>KPIs</code> parameter.
</p>
</html>",
  revisions="<html>
<ul>
<li>
April 11, 2019 by Javier Arroyo:<br/>
Enumeration type KPI tags added.
</li>
<li>
December 17, 2018 by David Blum:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1059\">#1059</a>.
</li>
</ul>
</html>"),   Icon(graphics={
          Line(points={{22,60},{70,60}},  color={0,0,127}),
          Line(points={{-38,0},{22,60}}, color={0,0,127}),
          Line(points={{-100,0},{-38,0}}, color={0,0,127}),
          Line(points={{-38,0},{100,0}}, color={0,0,127}),
          Ellipse(
            extent={{-40,2},{-36,-2}},
            lineColor={28,108,200},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{36,70},{66,60},{36,50},{36,70}},
            lineColor={0,0,127},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid),
          Line(points={{-16,0},{16,0}},     color={0,0,127},
            origin={78,60},
            rotation=90),
          Line(points={{-16,0},{16,0}},     color={0,0,127},
            origin={74,60},
            rotation=90),
          Line(points={{-16,0},{16,0}},     color={0,0,127},
            origin={70,60},
            rotation=90)}));
  end Read;

  package Examples
    "This package contains examples for the signal exchange block"
    extends Modelica.Icons.ExamplesPackage;
    model FirstOrder
      "Uses signal exchange block for a first order dynamic system"
      extends Modelica.Icons.Example;
      BaseClasses.ExportedModel expMod
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
      Modelica.Blocks.Sources.Constant uSet(k=2)
        annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
      Modelica.Blocks.Sources.BooleanStep actSet(startTime=50)
        annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
      Modelica.Blocks.Sources.BooleanStep actAct(startTime=100)
        annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
      Modelica.Blocks.Sources.Constant uAct(k=3)
        annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
    equation
      connect(uSet.y, expMod.oveWriSet_u) annotation (Line(points={{-39,70},{
              -20,70},{-20,10},{-12,10}}, color={0,0,127}));
      connect(actSet.y, expMod.oveWriSet_activate) annotation (Line(points={{
              -39,40},{-30,40},{-30,6},{-12,6}}, color={255,0,255}));
      connect(actAct.y, expMod.oveWriAct_activate) annotation (Line(points={{
              -39,-20},{-30,-20},{-30,-4},{-12,-4}}, color={255,0,255}));
      connect(uAct.y, expMod.oveWriAct_u) annotation (Line(points={{-39,10},{
              -34,10},{-34,0},{-12,0}}, color={0,0,127}));
      annotation (experiment(StopTime=150,Tolerance=1e-06),
      __Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Utilities/IO/SignalExchange/Examples/FirstOrder.mos"
            "Simulate and plot"),
    Documentation(info="<html>
<p>
This example uses the signal exchange blocks in an original model,
<a href=\"modelica://IBPSA.Utilities.IO.SignalExchange.Examples.BaseClasses.OriginalModel\">IBPSA.Utilities.IO.SignalExchange.Examples.BaseClasses.OriginalModel</a>
along with a corresponding model that would result if the original model were 
compiled with the BOPTEST parser, <a href=\"modelica://IBPSA.Utilities.IO.SignalExchange.Examples.BaseClasses.ExportedModel\">IBPSA.Utilities.IO.SignalExchange.Examples.BaseClasses.ExportedModel</a>
to demonstrate the overwriting of either setpoint or actuator control signals 
and reading of signals.
</p>
</html>",
    revisions="<html>
<ul>
<li>
December 17, 2018, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
    end FirstOrder;

    package BaseClasses "Contains base classes for signal exchange examples"
      extends Modelica.Icons.BasesPackage;
      model OriginalModel "Original model"

        Modelica.Blocks.Sources.Constant TSet(k=1) "Set point"
          annotation (Placement(transformation(extent={{-70,20},{-50,40}})));
        Modelica.Blocks.Continuous.LimPID conPI(
          controllerType=Modelica.Blocks.Types.SimpleController.PI,
          yMax=10) "Controller"
          annotation (Placement(transformation(extent={{-10,20},{10,40}})));
        Modelica.Blocks.Continuous.FirstOrder firOrd(
          T=1,
          initType=Modelica.Blocks.Types.Init.InitialOutput)
          "First order element"
          annotation (Placement(transformation(extent={{50,20},{70,40}})));
        Overwrite oveWriSet(Description="First order system control setpoint", u(
            min=-10,
            max=-10,
            unit="1"))      "Overwrite block for setpoint"
          annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
        Overwrite oveWriAct(Description="First order system input", u(
            min=-10,
            max=-10,
            unit="1"))      "Overwrite block for actuator signal"
          annotation (Placement(transformation(extent={{20,20},{40,40}})));
        Read rea(Description="First order system output", KPIs=IBPSA.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None)
                 "Measured state variable"
          annotation (Placement(transformation(extent={{50,-30},{30,-10}})));
      equation
        connect(TSet.y, oveWriSet.u)
          annotation (Line(points={{-49,30},{-42,30}}, color={0,0,127}));
        connect(oveWriSet.y, conPI.u_s)
          annotation (Line(points={{-19,30},{-12,30}}, color={0,0,127}));
        connect(conPI.y, oveWriAct.u)
          annotation (Line(points={{11,30},{18,30}}, color={0,0,127}));
        connect(oveWriAct.y, firOrd.u)
          annotation (Line(points={{41,30},{48,30}}, color={0,0,127}));
        connect(firOrd.y, rea.u) annotation (Line(points={{71,30},{80,30},{80,-20},{52,
                -20}}, color={0,0,127}));
        connect(rea.y, conPI.u_m)
          annotation (Line(points={{29,-20},{0,-20},{0,18}}, color={0,0,127}));
        annotation (Documentation(info="<html>
<p>
This is a model of a first order dynamic system with feedback control.
Signal exchange blocks are implemented to overwrite either the setpoint or
actuator control signals as well as read the output fo the first order
system.
</p>
</html>",       revisions="<html>
<ul>
<li>
December 17, 2018, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"),      Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
              coordinateSystem(preserveAspectRatio=false)));
      end OriginalModel;

      model ExportedModel "Model to be exported as an FMU"

        Modelica.Blocks.Interfaces.RealInput oveWriSet_u "Signal for overwrite block for set point"
          annotation (Placement(transformation(extent={{-140,80},{-100,120}})));
        Modelica.Blocks.Interfaces.BooleanInput oveWriSet_activate "Activation for overwrite block for set point"
          annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
        Modelica.Blocks.Interfaces.RealInput oveWriAct_u "Signal for overwrite block for actuator signal"
          annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
        Modelica.Blocks.Interfaces.BooleanInput oveWriAct_activate "Activation for overwrite block for actuator signal"
          annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

        Modelica.Blocks.Interfaces.RealOutput rea = mod.rea.y
          "Measured state variable"
          annotation (Placement(transformation(extent={{100,-10},{120,10}})));

        BaseClasses.OriginalModel mod(oveWriSet(uExt(y=oveWriSet_u), activate(y=
                 oveWriSet_activate)), oveWriAct(uExt(y=oveWriAct_u), activate(
                y=oveWriAct_activate))) "Original model"
          annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
      annotation(Documentation(info="<html>
<p>
This is an example of a model that would be compiled in BOPTEST if the
original model were using the signal exchange blocks.  Note that inputs
are added to activate and set values of control signals that can be overwritten
and outputs are added to read signals from the read blocks.
</p>
</html>",       revisions="<html>
<ul>
<li>
December 17, 2018, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
      end ExportedModel;
    end BaseClasses;
  end Examples;

  package SignalTypes "Package with signal type definitions"
   extends Modelica.Icons.TypesPackage;

    type SignalsForKPIs = enumeration(
        None
          "Not used for KPI",
        AirZoneTemperature
          "Air zone temperature",
        RadiativeZoneTemperature
          "Radiative zone temperature",
        OperativeZoneTemperature
          "Operative zone temperature",
        RelativeHumidity
          "Relative humidity",
        CO2Concentration
          "CO2 Concentration",
        ElectricPower
          "Electric power from grid",
        DistrictHeatingPower
          "Thermal power from district heating",
        GasPower
          "Thermal power from natural gas",
        BiomassPower
          "Thermal power from biomass",
        SolarThermalPower
          "Thermal power from solar thermal",
        FreshWaterFlowRate
          "FreshWaterFlowRate") "Signals used for the calculation of key performance indicators";
  end SignalTypes;
  annotation (Documentation(info="<html>
<p>
Package to allow overwriting of control signals by external programs and 
reading of measurement signals to external programs.
</p>
</html>", Icon(graphics={Rectangle(extent={{-60,60},{60,-60}}, lineColor={0,
              0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,10},{-10,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,10},{30,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-10,0},{10,0}}, color={0,0,0}),
        Line(
          points={{-60,0},{-30,0}},
          color={0,0,0},
          pattern=LinePattern.Dot),
        Line(
          points={{30,0},{60,0}},
          color={0,0,0},
          pattern=LinePattern.Dot),
        Polygon(
          points={{-80,10},{-80,-10},{-60,0},{-80,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{60,10},{60,-10},{80,0},{60,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)})));
end SignalExchange;
