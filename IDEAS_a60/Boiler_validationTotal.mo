package Annex60 "Library with models for building energy and control systems"
  extends Modelica.Icons.Package;
annotation (
preferredView="info",
version="0.1",
versionBuild=0,
versionDate="2013-09-20",
dateModified = "2013-09-20",
uses(Modelica(version="3.2")),
preferredView="info",
Documentation(info="<html>
<p>
The <code>Annex60</code> library is a free library
that provides basic classes for the development of
Modelica libraries for building and community energy and control systems. 
Many models are based on models from the package
<code>Modelica.Fluid</code> and use
the same ports to ensure compatibility with the Modelica Standard
Library.
</p>
<p>
The web page for this library is
<a href=\"https://github.com/iea-annex60/modelica-annex60\">https://github.com/iea-annex60/modelica-annex60</a>.
Contributions to further advance the library are welcomed.
Contributions may not only be in the form of model development, but also
through model use, model testing,
requirements definition or providing feedback regarding the model applicability
to solve specific problems.
</p>
</html>"));
end Annex60;

package Modelica "Modelica Standard Library (Version 3.2)"
extends Modelica.Icons.Package;

  package Blocks
  "Library of basic input/output control blocks (continuous, discrete, logical, table blocks)"
  import SI = Modelica.SIunits;
  extends Modelica.Icons.Package;

    package Interfaces
    "Library of connectors and partial models for input/output blocks"
      import Modelica.SIunits;
        extends Modelica.Icons.InterfacesPackage;

    connector RealInput = input Real "'input Real' as connector"
      annotation (defaultComponentName="u",
      Icon(graphics={Polygon(
              points={{-100,100},{100,0},{-100,-100},{-100,100}},
              lineColor={0,0,127},
              fillColor={0,0,127},
              fillPattern=FillPattern.Solid)},
           coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true, initialScale=0.2)),
      Diagram(coordinateSystem(
            preserveAspectRatio=true, initialScale=0.2,
            extent={{-100,-100},{100,100}},
            grid={1,1}), graphics={Polygon(
              points={{0,50},{100,0},{0,-50},{0,50}},
              lineColor={0,0,127},
              fillColor={0,0,127},
              fillPattern=FillPattern.Solid), Text(
              extent={{-10,85},{-10,60}},
              lineColor={0,0,127},
              textString="%name")}),
        Documentation(info="<html>
<p>
Connector with one input signal of type Real.
</p>
</html>"));

    connector RealOutput = output Real "'output Real' as connector"
      annotation (defaultComponentName="y",
      Icon(coordinateSystem(
            preserveAspectRatio=true,
            extent={{-100,-100},{100,100}},
            grid={1,1}), graphics={Polygon(
              points={{-100,100},{100,0},{-100,-100},{-100,100}},
              lineColor={0,0,127},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid)}),
      Diagram(coordinateSystem(
            preserveAspectRatio=true,
            extent={{-100,-100},{100,100}},
            grid={1,1}), graphics={Polygon(
              points={{-100,50},{0,0},{-100,-50},{-100,50}},
              lineColor={0,0,127},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid), Text(
              extent={{30,110},{30,60}},
              lineColor={0,0,127},
              textString="%name")}),
        Documentation(info="<html>
<p>
Connector with one output signal of type Real.
</p>
</html>"));

        partial block BlockIcon "Basic graphical layout of input/output block"

          annotation (
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                  100,100}}), graphics={Rectangle(
                extent={{-100,-100},{100,100}},
                lineColor={0,0,127},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid), Text(
                extent={{-150,150},{150,110}},
                textString="%name",
                lineColor={0,0,255})}),
          Documentation(info="<html>
<p>
Block that has only the basic icon for an input/output
block (no declarations, no equations). Most blocks
of package Modelica.Blocks inherit directly or indirectly
from this block.
</p>
</html>"));

        end BlockIcon;

        partial block SO "Single Output continuous control block"
          extends BlockIcon;

          RealOutput y "Connector of Real output signal"
            annotation (Placement(transformation(extent={{100,-10},{120,10}},
                rotation=0)));
          annotation (
            Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics),
          Documentation(info="<html>
<p>
Block has one continuous Real output signal.
</p>
</html>"));

        end SO;

        partial block SI2SO
      "2 Single Input / 1 Single Output continuous control block"
          extends BlockIcon;

          RealInput u1 "Connector of Real input signal 1"
            annotation (Placement(transformation(extent={{-140,40},{-100,80}},
                rotation=0)));
          RealInput u2 "Connector of Real input signal 2"
            annotation (Placement(transformation(extent={{-140,-80},{-100,-40}},
                rotation=0)));
          RealOutput y "Connector of Real output signal"
            annotation (Placement(transformation(extent={{100,-10},{120,10}},
                rotation=0)));

          annotation (
            Documentation(info="<html>
<p>
Block has two continuous Real input signals u1 and u2 and one
continuous Real output signal y.
</p>
</html>"),  Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics));

        end SI2SO;

      partial block partialBooleanBlockIcon
      "Basic graphical layout of logical block"

        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Rectangle(
                extent={{-100,100},{100,-100}},
                lineColor={0,0,0},
                fillColor={210,210,210},
                fillPattern=FillPattern.Solid,
                borderPattern=BorderPattern.Raised), Text(
                extent={{-150,150},{150,110}},
                textString="%name",
                lineColor={0,0,255})}),                        Documentation(info="<html>
<p>
Block that has only the basic icon for an input/output,
Boolean block (no declarations, no equations) used especially
in the Blocks.Logical library.
</p>
</html>"));
      end partialBooleanBlockIcon;
        annotation (
          Documentation(info="<HTML>
<p>
This package contains interface definitions for
<b>continuous</b> input/output blocks with Real,
Integer and Boolean signals. Furthermore, it contains
partial models for continuous and discrete blocks.
</p>

</HTML>
",     revisions="<html>
<ul>
<li><i>Oct. 21, 2002</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>
       and <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       Added several new interfaces. <a href=\"modelica://Modelica/Documentation/ChangeNotes1.5.html\">Detailed description</a> available.
<li><i>Oct. 24, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       RealInputSignal renamed to RealInput. RealOutputSignal renamed to
       output RealOutput. GraphBlock renamed to BlockIcon. SISOreal renamed to
       SISO. SOreal renamed to SO. I2SOreal renamed to M2SO.
       SignalGenerator renamed to SignalSource. Introduced the following
       new models: MIMO, MIMOs, SVcontrol, MVcontrol, DiscreteBlockIcon,
       DiscreteBlock, DiscreteSISO, DiscreteMIMO, DiscreteMIMOs,
       BooleanBlockIcon, BooleanSISO, BooleanSignalSource, MI2BooleanMOs.</li>
<li><i>June 30, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized a first version, based on an existing Dymola library
       of Dieter Moormann and Hilding Elmqvist.</li>
</ul>
</html>
"));
    end Interfaces;

    package Sources
    "Library of signal source blocks generating Real and Boolean signals"
      import Modelica.Blocks.Interfaces;
      import Modelica.SIunits;
      extends Modelica.Icons.SourcesPackage;

      block RealExpression
      "Set output signal to a time varying Real expression"

        Modelica.Blocks.Interfaces.RealOutput y=0.0 "Value of Real output"
          annotation (                            Dialog(group=
                "Time varying output signal"), Placement(transformation(extent={{
                  100,-10},{120,10}}, rotation=0)));

        annotation (
          Icon(coordinateSystem(
              preserveAspectRatio=false,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Rectangle(
                extent={{-100,40},{100,-40}},
                lineColor={0,0,0},
                fillColor={235,235,235},
                fillPattern=FillPattern.Solid,
                borderPattern=BorderPattern.Raised),
              Text(
                extent={{-96,15},{96,-15}},
                lineColor={0,0,0},
                textString="%y"),
              Text(
                extent={{-150,90},{140,50}},
                textString="%name",
                lineColor={0,0,255})}),
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics),
          Documentation(info="<html>
<p>
The (time varying) Real output signal of this block can be defined in its
parameter menu via variable <b>y</b>. The purpose is to support the
easy definition of Real expressions in a block diagram. For example,
in the y-menu the definition \"if time &lt; 1 then 0 else 1\" can be given in order
to define that the output signal is one, if time &ge; 1 and otherwise
it is zero. Note, that \"time\" is a built-in variable that is always
accessible and represents the \"model time\" and that
Variable <b>y</b> is both a variable and a connector.
</p>
</html>"));

      end RealExpression;

          block Sine "Generate sine signal"
            parameter Real amplitude=1 "Amplitude of sine wave";
            parameter SIunits.Frequency freqHz(start=1)
        "Frequency of sine wave";
            parameter SIunits.Angle phase=0 "Phase of sine wave";
            parameter Real offset=0 "Offset of output signal";
            parameter SIunits.Time startTime=0
        "Output = offset for time < startTime";
            extends Interfaces.SO;
    protected
            constant Real pi=Modelica.Constants.pi;

          equation
            y = offset + (if time < startTime then 0 else amplitude*
              Modelica.Math.sin(2*pi*freqHz*(time - startTime) + phase));
            annotation (
              Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={1,1}), graphics={
              Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
              Polygon(
                points={{-80,90},{-88,68},{-72,68},{-80,90}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-90,0},{68,0}}, color={192,192,192}),
              Polygon(
                points={{90,0},{68,8},{68,-8},{90,0}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-80,0},{-68.7,34.2},{-61.5,53.1},{-55.1,66.4},{-49.4,
                    74.6},{-43.8,79.1},{-38.2,79.8},{-32.6,76.6},{-26.9,69.7},{-21.3,
                    59.4},{-14.9,44.1},{-6.83,21.2},{10.1,-30.8},{17.3,-50.2},{23.7,
                    -64.2},{29.3,-73.1},{35,-78.4},{40.6,-80},{46.2,-77.6},{51.9,-71.5},
                    {57.5,-61.9},{63.9,-47.2},{72,-24.8},{80,0}}, color={0,0,0}),
              Text(
                extent={{-147,-152},{153,-112}},
                lineColor={0,0,0},
                textString="freqHz=%freqHz")}),
              Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={1,1}), graphics={
              Line(points={{-80,-90},{-80,84}}, color={95,95,95}),
              Polygon(
                points={{-80,97},{-84,81},{-76,81},{-80,97}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Line(points={{-99,-40},{85,-40}}, color={95,95,95}),
              Polygon(
                points={{97,-40},{81,-36},{81,-45},{97,-40}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Line(
                points={{-41,-2},{-31.6,34.2},{-26.1,53.1},{-21.3,66.4},{-17.1,74.6},
                    {-12.9,79.1},{-8.64,79.8},{-4.42,76.6},{-0.201,69.7},{4.02,59.4},
                    {8.84,44.1},{14.9,21.2},{27.5,-30.8},{33,-50.2},{37.8,-64.2},{
                    42,-73.1},{46.2,-78.4},{50.5,-80},{54.7,-77.6},{58.9,-71.5},{
                    63.1,-61.9},{67.9,-47.2},{74,-24.8},{80,0}},
                color={0,0,255},
                thickness=0.5),
              Line(
                points={{-41,-2},{-80,-2}},
                color={0,0,255},
                thickness=0.5),
              Text(
                extent={{-87,12},{-40,0}},
                lineColor={0,0,0},
                textString="offset"),
              Line(points={{-41,-2},{-41,-40}}, color={95,95,95}),
              Text(
                extent={{-60,-43},{-14,-54}},
                lineColor={0,0,0},
                textString="startTime"),
              Text(
                extent={{75,-47},{100,-60}},
                lineColor={0,0,0},
                textString="time"),
              Text(
                extent={{-80,99},{-40,82}},
                lineColor={0,0,0},
                textString="y"),
              Line(points={{-9,79},{43,79}}, color={95,95,95}),
              Line(points={{-41,-2},{50,-2}}, color={95,95,95}),
              Polygon(
                points={{33,79},{30,66},{37,66},{33,79}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{37,57},{83,39}},
                lineColor={0,0,0},
                textString="amplitude"),
              Polygon(
                points={{33,-2},{30,11},{36,11},{33,-2},{33,-2}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Line(points={{33,77},{33,-2}}, color={95,95,95})}),
          Documentation(info="<html>
<p>
The Real output y is a sine signal:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Blocks/Sources/Sine.png\">
</p>
</html>"));
          end Sine;

          block SawTooth "Generate saw tooth signal"
            parameter Real amplitude=1 "Amplitude of saw tooth";
            parameter SIunits.Time period(final min=Modelica.Constants.small,start = 1)
        "Time for one period";
            parameter Integer nperiod=-1
        "Number of periods (< 0 means infinite number of periods)";
            parameter Real offset=0 "Offset of output signals";
            parameter SIunits.Time startTime=0
        "Output = offset for time < startTime";
            extends Interfaces.SO;
    protected
            SIunits.Time T_start(final start=startTime)
        "Start time of current period";
            Integer count "Period count";
          initial algorithm
            count := integer((time - startTime)/period);
            T_start := startTime + count*period;
          equation
            when integer((time - startTime)/period)>pre(count) then
              count = pre(count)+1;
              T_start = time;
            end when;
            y = offset + (if (time<startTime or nperiod==0 or (nperiod>0 and count>=nperiod)) then 0
                         else amplitude*(time - T_start)/period);
            annotation (
              Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={1,1}), graphics={
              Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
              Polygon(
                points={{-80,90},{-88,68},{-72,68},{-80,90}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
              Polygon(
                points={{90,-70},{68,-62},{68,-78},{90,-70}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-80,-70},{-60,-70},{0,40},{0,-70},{60,41},{60,-70}},
                  color={0,0,0}),
              Text(
                extent={{-147,-152},{153,-112}},
                lineColor={0,0,0},
                textString="period=%period")}),
              Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={1,1}), graphics={
              Polygon(
                points={{-80,90},{-86,68},{-74,68},{-80,90}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Line(points={{-80,68},{-80,-80}}, color={95,95,95}),
              Line(points={{-90,-70},{82,-70}}, color={95,95,95}),
              Polygon(
                points={{90,-70},{68,-65},{68,-75},{90,-70}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{-34,-19},{-37,-32},{-30,-32},{-34,-19}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Line(points={{-34,-20},{-34,-70}}, color={95,95,95}),
              Polygon(
                points={{-34,-70},{-37,-57},{-31,-57},{-34,-70},{-34,-70}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-65,-39},{-29,-47}},
                lineColor={0,0,0},
                textString="offset"),
              Text(
                extent={{-29,-72},{13,-80}},
                lineColor={0,0,0},
                textString="startTime"),
              Text(
                extent={{-82,92},{-43,76}},
                lineColor={0,0,0},
                textString="y"),
              Text(
                extent={{67,-78},{88,-87}},
                lineColor={0,0,0},
                textString="time"),
              Line(points={{-10,-20},{-10,-70}}, color={95,95,95}),
              Line(points={{-10,88},{-10,-20}}, color={95,95,95}),
              Line(points={{30,88},{30,59}}, color={95,95,95}),
              Line(points={{-10,83},{30,83}}, color={95,95,95}),
              Text(
                extent={{-12,94},{34,85}},
                lineColor={0,0,0},
                textString="period"),
              Line(points={{-44,60},{30,60}}, color={95,95,95}),
              Line(points={{-34,47},{-34,-7}}, color={95,95,95}),
              Text(
                extent={{-73,25},{-36,16}},
                lineColor={0,0,0},
                textString="amplitude"),
              Polygon(
                points={{-34,60},{-37,47},{-30,47},{-34,60}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{-34,-20},{-37,-7},{-31,-7},{-34,-20},{-34,-20}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{-10,83},{-1,85},{-1,81},{-10,83}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{30,83},{22,85},{22,81},{30,83}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Line(
                points={{-80,-20},{-10,-20},{30,60},{30,-20},{72,60},{72,-20}},
                color={0,0,255},
                thickness=0.5)}),
          Documentation(info="<html>
<p>
The Real output y is a saw tooth signal:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Blocks/Sources/SawTooth.png\">
</p>
</html>"));
          end SawTooth;
          annotation (
            Documentation(info="<HTML>
<p>
This package contains <b>source</b> components, i.e., blocks which
have only output signals. These blocks are used as signal generators
for Real, Integer and Boolean signals.
</p>

<p>
All Real source signals (with the exception of the Constant source)
have at least the following two parameters:
</p>

<table border=1 cellspacing=0 cellpadding=2>
  <tr><td valign=\"top\"><b>offset</b></td>
      <td valign=\"top\">Value which is added to the signal</td>
  </tr>
  <tr><td valign=\"top\"><b>startTime</b></td>
      <td valign=\"top\">Start time of signal. For time &lt; startTime,
                the output y is set to offset.</td>
  </tr>
</table>

<p>
The <b>offset</b> parameter is especially useful in order to shift
the corresponding source, such that at initial time the system
is stationary. To determine the corresponding value of offset,
usually requires a trimming calculation.
</p>
</HTML>
",     revisions="<html>
<ul>
<li><i>October 21, 2002</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>
       and <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       Integer sources added. Step, TimeTable and BooleanStep slightly changed.</li>
<li><i>Nov. 8, 1999</i>
       by <a href=\"mailto:clauss@eas.iis.fhg.de\">Christoph Clau&szlig;</a>,
       <a href=\"mailto:Andre.Schneider@eas.iis.fraunhofer.de\">Andre.Schneider@eas.iis.fraunhofer.de</a>,
       <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       New sources: Exponentials, TimeTable. Trapezoid slightly enhanced
       (nperiod=-1 is an infinite number of periods).</li>
<li><i>Oct. 31, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       <a href=\"mailto:clauss@eas.iis.fhg.de\">Christoph Clau&szlig;</a>,
       <a href=\"mailto:Andre.Schneider@eas.iis.fraunhofer.de\">Andre.Schneider@eas.iis.fraunhofer.de</a>,
       All sources vectorized. New sources: ExpSine, Trapezoid,
       BooleanConstant, BooleanStep, BooleanPulse, SampleTrigger.
       Improved documentation, especially detailed description of
       signals in diagram layer.</li>
<li><i>June 29, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized a first version, based on an existing Dymola library
       of Dieter Moormann and Hilding Elmqvist.</li>
</ul>
</html>"));
    end Sources;

    package Tables
    "Library of blocks to interpolate in one and two-dimensional tables"
      extends Modelica.Icons.Package;

      model CombiTable2D "Table look-up in two dimensions (matrix/file) "

        import Modelica.Blocks.Types;
        extends Modelica.Blocks.Interfaces.SI2SO;

        parameter Boolean tableOnFile=false
        "true, if table is defined on file or in function usertab"
          annotation(Dialog(group="table data definition"));
        parameter Real table[:, :]=fill(0.0,0,2)
        "table matrix (grid u1 = first column, grid u2 = first row; e.g., table=[0,0;0,1])"
             annotation(Dialog(group="table data definition", enable = not tableOnFile));
        parameter String tableName="NoName"
        "table name on file or in function usertab (see docu)"
             annotation(Dialog(group="table data definition", enable = tableOnFile));
        parameter String fileName="NoName" "file where matrix is stored"
             annotation(Dialog(group="table data definition", enable = tableOnFile,
                               __Dymola_loadSelector(filter="Text files (*.txt);;Matlab files (*.mat)",
                               caption="Open file in which table is present")));
        parameter Modelica.Blocks.Types.Smoothness smoothness=Types.Smoothness.LinearSegments
        "smoothness of table interpolation"
        annotation(Dialog(group="table data interpretation"));
    protected
        Integer tableID;

        function tableInit
        "Initialize 2-dim. table defined by matrix (for details see: Modelica/Resources/C-Sources/ModelicaTables.h)"

          input String tableName;
          input String fileName;
          input Real table[ :, :];
          input Modelica.Blocks.Types.Smoothness smoothness;
          output Integer tableID;
        external "C" tableID = ModelicaTables_CombiTable2D_init(
                       tableName, fileName, table, size(table, 1), size(table, 2),
                       smoothness);
          annotation(Library="ModelicaExternalC");
        end tableInit;

        function tableIpo
        "Interpolate 2-dim. table defined by matrix (for details see: Modelica/Resources/C-Sources/ModelicaTables.h)"
          input Integer tableID;
          input Real u1;
          input Real u2;
          output Real value;
        external "C" value =
                           ModelicaTables_CombiTable2D_interpolate(tableID, u1, u2);
          annotation(Library="ModelicaExternalC");
        end tableIpo;

      equation
        if tableOnFile then
          assert(tableName<>"NoName", "tableOnFile = true and no table name given");
        end if;
        if not tableOnFile then
          assert(size(table,1) > 0 and size(table,2) > 0, "tableOnFile = false and parameter table is an empty matrix");
        end if;

        y = tableIpo(tableID, u1, u2);
        when initial() then
          tableID=tableInit(if tableOnFile then tableName else "NoName",
                            if tableOnFile then fileName else "NoName", table, smoothness);
        end when;
        annotation (
          Documentation(info="<html>
<p>
<b>Linear interpolation</b> in <b>two</b> dimensions of a <b>table</b>.
The grid points and function values are stored in a matrix \"table[i,j]\",
where:
</p>
<ul>
<li> the first column \"table[2:,1]\" contains the u[1] grid points,</li>
<li> the first row \"table[1,2:]\" contains the u[2] grid points,</li>
<li> the other rows and columns contain the data to be interpolated.</li>
</ul>
<p>
Example:
</p>
<pre>
           |       |       |       |
           |  1.0  |  2.0  |  3.0  |  // u2
       ----*-------*-------*-------*
       1.0 |  1.0  |  3.0  |  5.0  |
       ----*-------*-------*-------*
       2.0 |  2.0  |  4.0  |  6.0  |
       ----*-------*-------*-------*
     // u1
   is defined as
      table = [0.0,   1.0,   2.0,   3.0;
               1.0,   1.0,   3.0,   5.0;
               2.0,   2.0,   4.0,   6.0]
   If, e.g., the input u is [1.0;1.0], the output y is 1.0,
       e.g., the input u is [2.0;1.5], the output y is 3.0.
</pre>
<ul>
<li> The interpolation is <b>efficient</b>, because a search for a new interpolation
     starts at the interval used in the last call.</li>
<li> If the table has only <b>one element</b>, the table value is returned,
     independent of the value of the input signal.</li>
<li> If the input signal <b>u1</b> or <b>u2</b> is <b>outside</b> of the defined <b>interval</b>,
     the corresponding value is also determined by linear
     interpolation through the last or first two points of the table.</li>
<li> The grid values (first column and first row) have to be <b>strict</b>
     monotonically increasing.</li>
</ul>
<p>
The table matrix can be defined in the following ways:
</p>
<ol>
<li> Explicitly supplied as <b>parameter matrix</b> \"table\",
     and the other parameters have the following values:
<pre>
   tableName is \"NoName\" or has only blanks,
   fileName  is \"NoName\" or has only blanks.
</pre></li>
<li> <b>Read</b> from a <b>file</b> \"fileName\" where the matrix is stored as
      \"tableName\". Both ASCII and binary file format is possible.
      (the ASCII format is described below).
      It is most convenient to generate the binary file from Matlab
      (Matlab 4 storage format), e.g., by command
<pre>
   save tables.mat tab1 tab2 tab3 -V4
</pre>
      when the three tables tab1, tab2, tab3 should be
      used from the model.</li>
<li>  Statically stored in function \"usertab\" in file \"usertab.c\".
      The matrix is identified by \"tableName\". Parameter
      fileName = \"NoName\" or has only blanks.</li>
</ol>
<p>
Table definition methods (1) and (3) do <b>not</b> allocate dynamic memory,
and do not access files, whereas method (2) does. Therefore (1) and (3)
are suited for hardware-in-the-loop simulation (e.g., with dSpace hardware).
When the constant \"NO_FILE\" is defined, all parts of the
source code of method (2) are removed by the C-preprocessor, such that
no dynamic memory allocation and no access to files takes place.
</p>
<p>
If tables are read from an ASCII-file, the file need to have the
following structure (\"-----\" is not part of the file content):
</p>
<pre>
-----------------------------------------------------
#1
double table2D_1(3,4)   # comment line
0.0  1.0  2.0  3.0  # u[2] grid points
1.0  1.0  3.0  5.0
2.0  2.0  4.0  6.0

double table2D_2(4,4)   # comment line
0.0  1.0  2.0  3.0  # u[2] grid points
1.0  1.0  3.0  5.0
2.0  2.0  4.0  6.0
3.0  3.0  5.0  7.0
-----------------------------------------------------
</pre>
<p>
Note, that the first two characters in the file need to be
\"#1\". Afterwards, the corresponding matrix has to be declared
with type, name and actual dimensions. Finally, in successive
rows of the file, the elements of the matrix have to be given.
Several matrices may be defined one after another.
The matrix elements are interpreted in exactly the same way
as if the matrix is given as a parameter. For example, the first
column \"table2D_1[2:,1]\" contains the u[1] grid points,
and the first row \"table2D_1[1,2:]\" contains the u[2] grid points.
</p>

</html>
"),       Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                  100}}), graphics={
              Line(points={{-60,40},{-60,-40},{60,-40},{60,40},{30,40},{30,-40},{-30,
                    -40},{-30,40},{-60,40},{-60,20},{60,20},{60,0},{-60,0},{-60,-20},
                    {60,-20},{60,-40},{-60,-40},{-60,40},{60,40},{60,-40}}, color={
                    0,0,0}),
              Line(points={{0,40},{0,-40}}, color={0,0,0}),
              Rectangle(
                extent={{-60,20},{-30,0}},
                lineColor={0,0,0},
                fillColor={255,255,0},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-60,0},{-30,-20}},
                lineColor={0,0,0},
                fillColor={255,255,0},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-60,-20},{-30,-40}},
                lineColor={0,0,0},
                fillColor={255,255,0},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-30,40},{0,20}},
                lineColor={0,0,0},
                fillColor={255,255,0},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{0,40},{30,20}},
                lineColor={0,0,0},
                fillColor={255,255,0},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{30,40},{60,20}},
                lineColor={0,0,0},
                fillColor={255,255,0},
                fillPattern=FillPattern.Solid),
              Line(points={{-60,40},{-30,20}}, color={0,0,0}),
              Line(points={{-30,40},{-60,20}}, color={0,0,0})}),
          Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                  100,100}}), graphics={
              Rectangle(
                extent={{-60,60},{60,-60}},
                fillColor={235,235,235},
                fillPattern=FillPattern.Solid,
                lineColor={0,0,255}),
              Line(points={{60,0},{100,0}}, color={0,0,255}),
              Text(
                extent={{-100,100},{100,64}},
                textString="2 dimensional linear table interpolation",
                lineColor={0,0,255}),
              Line(points={{-54,40},{-54,-40},{54,-40},{54,40},{28,40},{28,-40},{-28,
                    -40},{-28,40},{-54,40},{-54,20},{54,20},{54,0},{-54,0},{-54,-20},
                    {54,-20},{54,-40},{-54,-40},{-54,40},{54,40},{54,-40}}, color={
                    0,0,0}),
              Line(points={{0,40},{0,-40}}, color={0,0,0}),
              Rectangle(
                extent={{-54,20},{-28,0}},
                lineColor={0,0,0},
                fillColor={255,255,0},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-54,0},{-28,-20}},
                lineColor={0,0,0},
                fillColor={255,255,0},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-54,-20},{-28,-40}},
                lineColor={0,0,0},
                fillColor={255,255,0},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-28,40},{0,20}},
                lineColor={0,0,0},
                fillColor={255,255,0},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{0,40},{28,20}},
                lineColor={0,0,0},
                fillColor={255,255,0},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{28,40},{54,20}},
                lineColor={0,0,0},
                fillColor={255,255,0},
                fillPattern=FillPattern.Solid),
              Line(points={{-54,40},{-28,20}}, color={0,0,0}),
              Line(points={{-28,40},{-54,20}}, color={0,0,0}),
              Text(
                extent={{-54,-40},{-30,-56}},
                textString="u1",
                lineColor={0,0,255}),
              Text(
                extent={{28,58},{52,44}},
                textString="u2",
                lineColor={0,0,255}),
              Text(
                extent={{-2,12},{32,-22}},
                textString="y",
                lineColor={0,0,255})}));
      end CombiTable2D;
      annotation (Documentation(info="<html>
<p>
This package contains blocks for one- and two-dimensional
interpolation in tables.
</p>
</html>"));
    end Tables;

    package Types
    "Library of constants and types with choices, especially to build menus"
      extends Modelica.Icons.Package;

      type Smoothness = enumeration(
        LinearSegments "Table points are linearly interpolated",
        ContinuousDerivative
          "Table points are interpolated such that the first derivative is continuous")
      "Enumeration defining the smoothness of table interpolation";
      annotation ( Documentation(info="<HTML>
<p>
In this package <b>types</b> and <b>constants</b> are defined that are used
in library Modelica.Blocks. The types have additional annotation choices
definitions that define the menus to be built up in the graphical
user interface when the type is used as parameter in a declaration.
</p>
</HTML>"));
    end Types;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(extent={{-32,-6},{16,-35}}, lineColor={0,0,0}),
        Rectangle(extent={{-32,-56},{16,-85}}, lineColor={0,0,0}),
        Line(points={{16,-20},{49,-20},{49,-71},{16,-71}}, color={0,0,0}),
        Line(points={{-32,-72},{-64,-72},{-64,-21},{-32,-21}}, color={0,0,0}),
        Polygon(
          points={{16,-71},{29,-67},{29,-74},{16,-71}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-32,-21},{-46,-17},{-46,-25},{-32,-21}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
                            Documentation(info="<html>
<p>
This library contains input/output blocks to build up block diagrams.
</p>

<dl>
<dt><b>Main Author:</b>
<dd><a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a><br>
    Deutsches Zentrum f&uuml;r Luft und Raumfahrt e. V. (DLR)<br>
    Oberpfaffenhofen<br>
    Postfach 1116<br>
    D-82230 Wessling<br>
    email: <A HREF=\"mailto:Martin.Otter@dlr.de\">Martin.Otter@dlr.de</A><br>
</dl>
<p>
Copyright &copy; 1998-2010, Modelica Association and DLR.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</HTML>
",   revisions="<html>
<ul>
<li><i>June 23, 2004</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Introduced new block connectors and adapated all blocks to the new connectors.
       Included subpackages Continuous, Discrete, Logical, Nonlinear from
       package ModelicaAdditions.Blocks.
       Included subpackage ModelicaAdditions.Table in Modelica.Blocks.Sources
       and in the new package Modelica.Blocks.Tables.
       Added new blocks to Blocks.Sources and Blocks.Logical.
       </li>
<li><i>October 21, 2002</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>
       and <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       New subpackage Examples, additional components.
       </li>
<li><i>June 20, 2000</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a> and
       Michael Tiller:<br>
       Introduced a replaceable signal type into
       Blocks.Interfaces.RealInput/RealOutput:
<pre>
   replaceable type SignalType = Real
</pre>
       in order that the type of the signal of an input/output block
       can be changed to a physical type, for example:
<pre>
   Sine sin1(outPort(redeclare type SignalType=Modelica.SIunits.Torque))
</pre>
      </li>
<li><i>Sept. 18, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Renamed to Blocks. New subpackages Math, Nonlinear.
       Additional components in subpackages Interfaces, Continuous
       and Sources. </li>
<li><i>June 30, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized a first version, based on an existing Dymola library
       of Dieter Moormann and Hilding Elmqvist.</li>
</ul>
</html>"));
  end Blocks;

  package Thermal
  "Library of thermal system components to model heat transfer and simple thermo-fluid pipe flow"
    extends Modelica.Icons.Package;

    package FluidHeatFlow
    "Simple components for 1-dimensional incompressible thermo-fluid flow models"
      extends Modelica.Icons.Package;

      package Media "Medium properties"
        extends Modelica.Icons.MaterialPropertiesPackage;

        record Medium "Record containing media properties"
          extends Modelica.Icons.Record;
          parameter Modelica.SIunits.Density rho = 1 "Density";
          parameter Modelica.SIunits.SpecificHeatCapacity cp = 1
          "Specific heat capacity at constant pressure";
          parameter Modelica.SIunits.SpecificHeatCapacity cv = 1
          "Specific heat capacity at constant volume";
          parameter Modelica.SIunits.ThermalConductivity lamda = 1
          "Thermal conductivity";
          parameter Modelica.SIunits.KinematicViscosity nue = 1
          "Kinematic viscosity";
          annotation (Documentation(info="<html>
Record containing (constant) medium properties.
</html>"));
        end Medium;
      annotation (Documentation(info="<HTML>
This package contains definitions of medium properties.<br>
<dl>
  <dt><b>Main Authors:</b></dt>
  <dd>
  <p>
  <a href=\"http://www.haumer.at/\">Anton Haumer</a><br>
  Technical Consulting &amp; Electrical Engineering<br>
  A-3423 St.Andrae-Woerdern, Austria<br>
  email: <a href=\"mailto:a.haumer@haumer.at\">a.haumer@haumer.at</a>
</p>
  <p>
  Dr. Christian Kral<br>
  <a href=\"http://www.ait.ac.at/\">Austrian Institute of Technology, AIT</a><br>
  Giefinggasse 2<br>
  A-1210 Vienna, Austria
</p>
  </dd>
</dl>
<p>
Copyright &copy; 1998-2010, Modelica Association, Anton Haumer and Austrian Institute of Technology, AIT.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</HTML>",     revisions="<HTML>
  <ul>
  <li> v1.00 2005/02/01 Anton Haumer<br>
       first stable official release</li>
  <li> v1.11 2005/02/18 Anton Haumer<br>
       corrected usage of cv and cp</li>
  </ul>
</HTML>
"),     Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                  100}}), graphics));
      end Media;

      package Interfaces "Connectors and partial models"
        extends Modelica.Icons.InterfacesPackage;

        connector FlowPort "Connector flow port"

          parameter FluidHeatFlow.Media.Medium medium "Medium in the connector";
          Modelica.SIunits.Pressure p;
          flow Modelica.SIunits.MassFlowRate m_flow;
          Modelica.SIunits.SpecificEnthalpy h;
          flow Modelica.SIunits.EnthalpyFlowRate H_flow;
        annotation (Documentation(info="<HTML>
Basic definition of the connector.<br>
<b>Variables:</b>
<ul>
<li>Pressure p</li>
<li>flow MassFlowRate m_flow</li>
<li>Specific Enthalpy h</li>
<li>flow EnthaplyFlowRate H_flow</li>
</ul>
If ports with different media are connected, the simulation is asserted due to the check of parameter.
</HTML>"));
        end FlowPort;
      annotation (Documentation(info="<HTML>
This package contains connectors and partial models:
<ul>
<li>FlowPort: basic definition of the connector.</li>
<li>FlowPort_a &amp; FlowPort_b: same as FlowPort with different icons to differentiate direction of flow</li>
<li>package Partials (defining basic thermodynamic equations)</li>
</ul>
<dl>
  <dt><b>Main Authors:</b></dt>
  <dd>
  <p>
  <a href=\"http://www.haumer.at/\">Anton Haumer</a><br>
  Technical Consulting &amp; Electrical Engineering<br>
  A-3423 St.Andrae-Woerdern, Austria<br>
  email: <a href=\"mailto:a.haumer@haumer.at\">a.haumer@haumer.at</a>
</p>
  <p>
  Dr. Christian Kral<br>
  <a href=\"http://www.ait.ac.at/\">Austrian Institute of Technology, AIT</a><br>
  Giefinggasse 2<br>
  A-1210 Vienna, Austria
</p>
  </dd>
</dl>
<p>
Copyright &copy; 1998-2010, Modelica Association, Anton Haumer and Austrian Institute of Technology, AIT.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</HTML>",     revisions="<HTML>
  <ul>
  <li> v1.00 2005/02/01 Anton Haumer<br>
       first stable official release</li>
  <li> v1.10 2005/02/15 Anton Haumer<br>
       moved Partials into Interfaces</li>
  <li> v1.11 2005/02/18 Anton Haumer<br>
       corrected usage of cv and cp</li>
  <li> v1.30 Beta 2005/06/02 Anton Haumer<br>
       friction losses are fed to medium</li>
  <li> v1.33 Beta 2005/06/07 Anton Haumer<br>
       corrected usage of simpleFlow</li>
  <li> v1.43 Beta 2005/06/20 Anton Haumer<br>
       Test of mixing / semiLinear</li>
  <li> v1.50 2005/09/07 Anton Haumer<br>
       semiLinear works fine</li>
  </ul>
</HTML>
"),     Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                  100}}), graphics));
      end Interfaces;
      annotation (
        Documentation(info="<HTML>
This package contains very simple-to-use components to model coolant flows as needed to simulate cooling e.g., of electric machines:
<ul>
<li>Components: components like different types of pipe models</li>
<li>Examples: some test examples</li>
<li>Interfaces: definition of connectors and partial models
(containing the core thermodynamic equations)</li>
<li>Media: definition of media properties</li>
<li>Sensors: various sensors for pressure, temperature, volume and enthalpy flow</li>
<li>Sources: various flow sources</li>
</ul>
<b>Variables used in connectors:</b>
<ul>
<li>Pressure p</li>
<li>flow MassFlowRate m_flow</li>
<li>SpecificEnthalpy h</li>
<li>flow EnthalpyFlowRate H_flow</li>
</ul>
EnthalpyFlowRate means the Enthalpy = cp<sub>constant</sub> * m * T that is carried by the medium's flow.<br><br>
<b>Limitations and assumptions:</b>
<ul>
<li>Splitting and mixing of coolant flows (media with the same cp) is possible.</li>
<li>Reversing the direction of flow is possible.</li>
<li>The medium is considered to be incompressible.</li>
<li>No mixtures of media is taken into consideration.</li>
<li>The medium may not change its phase.</li>
<li>Medium properties are kept constant.</li>
<li>Pressure changes are only due to pressure drop and geodetic height differnence rho*g*h (if h > 0).</li>
<li>A user-defined part (0..1) of the friction losses (V_flow*dp) are fed to the medium.</li>
<li><b>Note:</b> Connected flowPorts have the same temperature (mixing temperature)!<br>
Since mixing may occur, the outlet temperature may be different from the connector's temperature.<br>
Outlet temperature is defined by variable T of the corresponding component.</li>
</ul>
<b>Further development:</b>
<ul>
<li>Additional components like tanks (if needed)</li>
</ul>
<dl>
  <dt><b>Main Authors:</b></dt>
  <dd>
  <p>
  <a href=\"http://www.haumer.at/\">Anton Haumer</a><br>
  Technical Consulting &amp; Electrical Engineering<br>
  A-3423 St.Andrae-Woerdern, Austria<br>
  email: <a href=\"mailto:a.haumer@haumer.at\">a.haumer@haumer.at</a>
</p>
  <p>
  Dr. Christian Kral<br>
  <a href=\"http://www.ait.ac.at/\">Austrian Institute of Technology, AIT</a><br>
  Giefinggasse 2<br>
  A-1210 Vienna, Austria
</p>
  </dd>
</dl>
<p>
Copyright &copy; 1998-2010, Modelica Association, Anton Haumer and AIT.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</HTML>",     revisions="<HTML>
  <ul>
  <li> v1.00 2005/02/01 Anton Haumer<br>
       first stable official release</li>
  <li> v1.10 2005/02/15 Anton Haumer<br>
       reorganisation of the package</li>
  <li> v1.11 2005/02/18 Anton Haumer<br>
       corrected usage of cv and cp</li>
  <li> v1.20 Beta 2005/02/18 Anton Haumer<br>
       introduced geodetic height in Components.Pipes<br>
       <i>new models: Components.Valve, Sources.IdealPump</i></li>
  <li> v1.30 Beta 2005/06/02 Anton Haumer<br>
       friction losses are fed to medium</li>
  <li> v1.31 Beta 2005/06/04 Anton Haumer<br>
       <i>new example: PumpAndValve</i><br>
       <i>new example: PumpDropOut</i></li>
  <li> v1.33 Beta 2005/06/07 Anton Haumer<br>
       corrected usage of simpleFlow</li>
  <li> v1.40 2005/06/13 Anton Haumer<br>
       stable release</li>
  <li> v1.42 Beta 2005/06/18 Anton Haumer<br>
       <i>new test example: ParallelPumpDropOut</i></li>
  <li> v1.43 Beta 2005/06/20 Anton Haumer<br>
       Test of mixing / semiLinear<br>
       <i>new test example: OneMass</i><br>
       <i>new test example: TwoMass</i></li>
  <li> v1.50 2005/09/07 Anton Haumer<br>
       semiLinear works fine</li>
  <li> v1.60 2007/01/23 Anton Haumer<br>
       new parameter tapT defining Temperature of heatPort </li>
  <li> v1.6.1 2007/08/12 Anton Haumer<br>
       improved documentation<br>
       removed type TemperatureDifference since this is defined in Modelica.SIunits</li>
  <li> v1.6.2 2007/08/20 Anton Haumer<br>
       improved documentation</li>
  <li> v1.6.3 2007/08/21 Anton Haumer<br>
       improved documentation</li>
  <li> v1.6.4 2007/08/24 Anton Haumer<br>
       removed redeclare type SignalType</li>
  <li> v1.6.5 2007/08/26 Anton Haumer<br>
       fixed unit bug in SimpleFriction</li>
  <li> v1.6.6 2007/11/13 Anton Haumer<br>
       replaced all nonSIunits<br>
       some renaming to be more concise</li>
  <li> v1.6.7 2010/06/25 Christian Kral<br>
       changed company name to AIT</li>
  </ul>
</HTML>
"),     Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                100}}), graphics={
            Polygon(
              points={{-80,10},{-60,-10},{-80,-30},{-20,-30},{0,-10},{-20,10},{-80,
                  10}},
              lineColor={0,128,255},
              fillColor={0,128,255},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-40,-90},{-20,-70},{0,-90},{0,-50},{-20,-30},{-40,-50},{-40,
                  -90}},
              lineColor={255,0,0},
              fillColor={255,0,0},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-20,10},{0,-10},{-20,-30},{40,-30},{60,-10},{40,10},{-20,10}},
              lineColor={255,128,0},
              fillColor={255,128,0},
              fillPattern=FillPattern.Solid)}));
    end FluidHeatFlow;

    package HeatTransfer
    "Library of 1-dimensional heat transfer with lumped elements"
      import Modelica.SIunits.Conversions.*;
      extends Modelica.Icons.Package;

      package Components "Lumped thermal components"
      extends Modelica.Icons.Package;

        model HeatCapacitor "Lumped thermal element storing heat"
          parameter Modelica.SIunits.HeatCapacity C
          "Heat capacity of element (= cp*m)";
          Modelica.SIunits.Temperature T(start=293.15, displayUnit="degC")
          "Temperature of element";
          Modelica.SIunits.TemperatureSlope der_T(start=0)
          "Time derivative of temperature (= der(T))";
          Interfaces.HeatPort_a port annotation (Placement(transformation(
                origin={0,-100},
                extent={{-10,-10},{10,10}},
                rotation=90)));
        equation
          T = port.T;
          der_T = der(T);
          C*der(T) = port.Q_flow;
          annotation (
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={
                Text(
                  extent={{-150,110},{150,70}},
                  textString="%name",
                  lineColor={0,0,255}),
                Polygon(
                  points={{0,67},{-20,63},{-40,57},{-52,43},{-58,35},{-68,25},{-72,
                      13},{-76,-1},{-78,-15},{-76,-31},{-76,-43},{-76,-53},{-70,-65},
                      {-64,-73},{-48,-77},{-30,-83},{-18,-83},{-2,-85},{8,-89},{22,
                      -89},{32,-87},{42,-81},{54,-75},{56,-73},{66,-61},{68,-53},{
                      70,-51},{72,-35},{76,-21},{78,-13},{78,3},{74,15},{66,25},{54,
                      33},{44,41},{36,57},{26,65},{0,67}},
                  lineColor={160,160,164},
                  fillColor={192,192,192},
                  fillPattern=FillPattern.Solid),
                Polygon(
                  points={{-58,35},{-68,25},{-72,13},{-76,-1},{-78,-15},{-76,-31},{
                      -76,-43},{-76,-53},{-70,-65},{-64,-73},{-48,-77},{-30,-83},{-18,
                      -83},{-2,-85},{8,-89},{22,-89},{32,-87},{42,-81},{54,-75},{42,
                      -77},{40,-77},{30,-79},{20,-81},{18,-81},{10,-81},{2,-77},{-12,
                      -73},{-22,-73},{-30,-71},{-40,-65},{-50,-55},{-56,-43},{-58,-35},
                      {-58,-25},{-60,-13},{-60,-5},{-60,7},{-58,17},{-56,19},{-52,
                      27},{-48,35},{-44,45},{-40,57},{-58,35}},
                  lineColor={0,0,0},
                  fillColor={160,160,164},
                  fillPattern=FillPattern.Solid),
                Text(
                  extent={{-69,7},{71,-24}},
                  lineColor={0,0,0},
                  textString="%C")}),
            Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                    {100,100}}), graphics={
                Polygon(
                  points={{0,67},{-20,63},{-40,57},{-52,43},{-58,35},{-68,25},{-72,
                      13},{-76,-1},{-78,-15},{-76,-31},{-76,-43},{-76,-53},{-70,-65},
                      {-64,-73},{-48,-77},{-30,-83},{-18,-83},{-2,-85},{8,-89},{22,
                      -89},{32,-87},{42,-81},{54,-75},{56,-73},{66,-61},{68,-53},{
                      70,-51},{72,-35},{76,-21},{78,-13},{78,3},{74,15},{66,25},{54,
                      33},{44,41},{36,57},{26,65},{0,67}},
                  lineColor={160,160,164},
                  fillColor={192,192,192},
                  fillPattern=FillPattern.Solid),
                Polygon(
                  points={{-58,35},{-68,25},{-72,13},{-76,-1},{-78,-15},{-76,-31},{
                      -76,-43},{-76,-53},{-70,-65},{-64,-73},{-48,-77},{-30,-83},{-18,
                      -83},{-2,-85},{8,-89},{22,-89},{32,-87},{42,-81},{54,-75},{42,
                      -77},{40,-77},{30,-79},{20,-81},{18,-81},{10,-81},{2,-77},{-12,
                      -73},{-22,-73},{-30,-71},{-40,-65},{-50,-55},{-56,-43},{-58,-35},
                      {-58,-25},{-60,-13},{-60,-5},{-60,7},{-58,17},{-56,19},{-52,
                      27},{-48,35},{-44,45},{-40,57},{-58,35}},
                  lineColor={0,0,0},
                  fillColor={160,160,164},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{-6,-1},{6,-12}},
                  lineColor={255,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid),
                Text(
                  extent={{11,13},{50,-25}},
                  lineColor={0,0,0},
                  textString="T"),
                Line(points={{0,-12},{0,-96}}, color={255,0,0})}),
            Documentation(info="<HTML>
<p>
This is a generic model for the heat capacity of a material.
No specific geometry is assumed beyond a total volume with
uniform temperature for the entire volume.
Furthermore, it is assumed that the heat capacity
is constant (indepedent of temperature).
</p>
<p>
The temperature T [Kelvin] of this component is a <b>state</b>.
A default of T = 25 degree Celsius (= SIunits.Conversions.from_degC(25))
is used as start value for initialization.
This usually means that at start of integration the temperature of this
component is 25 degrees Celsius. You may, of course, define a different
temperature as start value for initialization. Alternatively, it is possible
to set parameter <b>steadyStateStart</b> to <b>true</b>. In this case
the additional equation '<b>der</b>(T) = 0' is used during
initialization, i.e., the temperature T is computed in such a way that
the component starts in <b>steady state</b>. This is useful in cases,
where one would like to start simulation in a suitable operating
point without being forced to integrate for a long time to arrive
at this point.
</p>
<p>
Note, that parameter <b>steadyStateStart</b> is not available in
the parameter menue of the simulation window, because its value
is utilized during translation to generate quite different
equations depending on its setting. Therefore, the value of this
parameter can only be changed before translating the model.
</p>
<p>
This component may be used for complicated geometries where
the heat capacity C is determined my measurements. If the component
consists mainly of one type of material, the <b>mass m</b> of the
component may be measured or calculated and multiplied with the
<b>specific heat capacity cp</b> of the component material to
compute C:
</p>
<pre>
   C = cp*m.
   Typical values for cp at 20 degC in J/(kg.K):
      aluminium   896
      concrete    840
      copper      383
      iron        452
      silver      235
      steel       420 ... 500 (V2A)
      wood       2500
</pre>
</HTML>
"));
        end HeatCapacitor;

        model ThermalConductor
        "Lumped thermal element transporting heat without storing it"
          extends Interfaces.Element1D;
          parameter Modelica.SIunits.ThermalConductance G
          "Constant thermal conductance of material";

        equation
          Q_flow = G*dT;
          annotation (
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={
                Rectangle(
                  extent={{-90,70},{90,-70}},
                  lineColor={0,0,0},
                  pattern=LinePattern.None,
                  fillColor={192,192,192},
                  fillPattern=FillPattern.Backward),
                Line(
                  points={{-90,70},{-90,-70}},
                  color={0,0,0},
                  thickness=0.5),
                Line(
                  points={{90,70},{90,-70}},
                  color={0,0,0},
                  thickness=0.5),
                Text(
                  extent={{-150,115},{150,75}},
                  textString="%name",
                  lineColor={0,0,255}),
                Text(
                  extent={{-150,-75},{150,-105}},
                  lineColor={0,0,0},
                  textString="G=%G")}),
            Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                    {100,100}}), graphics={
                Line(
                  points={{-80,0},{80,0}},
                  color={255,0,0},
                  thickness=0.5,
                  arrow={Arrow.None,Arrow.Filled}),
                Text(
                  extent={{-26,-10},{27,-39}},
                  lineColor={255,0,0},
                  textString="Q_flow"),
                Text(
                  extent={{-80,50},{80,20}},
                  lineColor={0,0,0},
                  textString="dT = port_a.T - port_b.T")}),
            Documentation(info="<HTML>
<p>
This is a model for transport of heat without storing it.
It may be used for complicated geometries where
the thermal conductance G (= inverse of thermal resistance)
is determined by measurements and is assumed to be constant
over the range of operations. If the component consists mainly of
one type of material and a regular geometry, it may be calculated,
e.g., with one of the following equations:
</p>
<ul>
<li><p>
    Conductance for a <b>box</b> geometry under the assumption
    that heat flows along the box length:</p>
    <pre>
    G = k*A/L
    k: Thermal conductivity (material constant)
    A: Area of box
    L: Length of box
    </pre>
    </li>
<li><p>
    Conductance for a <b>cylindrical</b> geometry under the assumption
    that heat flows from the inside to the outside radius
    of the cylinder:</p>
    <pre>
    G = 2*pi*k*L/log(r_out/r_in)
    pi   : Modelica.Constants.pi
    k    : Thermal conductivity (material constant)
    L    : Length of cylinder
    log  : Modelica.Math.log;
    r_out: Outer radius of cylinder
    r_in : Inner radius of cylinder
    </pre>
    </li>
</li>
</ul>
<pre>
    Typical values for k at 20 degC in W/(m.K):
      aluminium   220
      concrete      1
      copper      384
      iron         74
      silver      407
      steel        45 .. 15 (V2A)
      wood         0.1 ... 0.2
</pre>
</HTML>
"));
        end ThermalConductor;
        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={
              Rectangle(
                extent={{-100,18},{-70,-100}},
                lineColor={0,0,0},
                fillColor={192,192,192},
                fillPattern=FillPattern.Backward),
              Line(points={{-44,16},{-44,-100}}, color={0,127,255}),
              Line(points={{-4,16},{-4,-100}}, color={0,127,255}),
              Line(points={{30,18},{30,-100}}, color={0,127,255}),
              Line(points={{66,18},{66,-100}}, color={0,127,255}),
              Line(points={{66,-100},{76,-80}}, color={0,127,255}),
              Line(points={{66,-100},{56,-80}}, color={0,127,255}),
              Line(points={{30,-100},{40,-80}}, color={0,127,255}),
              Line(points={{30,-100},{20,-80}}, color={0,127,255}),
              Line(points={{-4,-100},{6,-80}}, color={0,127,255}),
              Line(points={{-4,-100},{-14,-80}}, color={0,127,255}),
              Line(points={{-44,-100},{-34,-80}}, color={0,127,255}),
              Line(points={{-44,-100},{-54,-80}}, color={0,127,255}),
              Line(points={{-70,-60},{66,-60}}, color={191,0,0}),
              Line(points={{46,-70},{66,-60}}, color={191,0,0}),
              Line(points={{46,-50},{66,-60}}, color={191,0,0}),
              Line(points={{46,-30},{66,-20}}, color={191,0,0}),
              Line(points={{46,-10},{66,-20}}, color={191,0,0}),
              Line(points={{-70,-20},{66,-20}}, color={191,0,0})}), Documentation(
              info="<html>

</html>"));
      end Components;

      package Sources "Thermal sources"
      extends Modelica.Icons.SourcesPackage;

        model FixedTemperature "Fixed temperature boundary condition in Kelvin"

          parameter Modelica.SIunits.Temperature T "Fixed temperature at port";
          Interfaces.HeatPort_b port annotation (Placement(transformation(extent={{90,
                    -10},{110,10}}, rotation=0)));
        equation
          port.T = T;
          annotation (
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={
                Text(
                  extent={{-150,150},{150,110}},
                  textString="%name",
                  lineColor={0,0,255}),
                Text(
                  extent={{-150,-110},{150,-140}},
                  lineColor={0,0,0},
                  textString="T=%T"),
                Rectangle(
                  extent={{-100,100},{100,-100}},
                  lineColor={0,0,0},
                  pattern=LinePattern.None,
                  fillColor={159,159,223},
                  fillPattern=FillPattern.Backward),
                Text(
                  extent={{0,0},{-100,-100}},
                  lineColor={0,0,0},
                  textString="K"),
                Line(
                  points={{-52,0},{56,0}},
                  color={191,0,0},
                  thickness=0.5),
                Polygon(
                  points={{50,-20},{50,20},{90,0},{50,-20}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid)}),
            Documentation(info="<HTML>
<p>
This model defines a fixed temperature T at its port in Kelvin,
i.e., it defines a fixed temperature as a boundary condition.
</p>
</HTML>
"),         Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={
                Rectangle(
                  extent={{-100,100},{100,-101}},
                  lineColor={0,0,0},
                  pattern=LinePattern.None,
                  fillColor={159,159,223},
                  fillPattern=FillPattern.Backward),
                Line(
                  points={{-52,0},{56,0}},
                  color={191,0,0},
                  thickness=0.5),
                Text(
                  extent={{0,0},{-100,-100}},
                  lineColor={0,0,0},
                  textString="K"),
                Polygon(
                  points={{52,-20},{52,20},{90,0},{52,-20}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid)}));
        end FixedTemperature;

        model PrescribedTemperature
        "Variable temperature boundary condition in Kelvin"

          Interfaces.HeatPort_b port annotation (Placement(transformation(extent={{90,
                    -10},{110,10}}, rotation=0)));
          Modelica.Blocks.Interfaces.RealInput T annotation (Placement(transformation(
                  extent={{-140,-20},{-100,20}}, rotation=0)));
        equation
          port.T = T;
          annotation (
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={
                Rectangle(
                  extent={{-100,100},{100,-100}},
                  lineColor={0,0,0},
                  pattern=LinePattern.None,
                  fillColor={159,159,223},
                  fillPattern=FillPattern.Backward),
                Line(
                  points={{-102,0},{64,0}},
                  color={191,0,0},
                  thickness=0.5),
                Text(
                  extent={{0,0},{-100,-100}},
                  lineColor={0,0,0},
                  textString="K"),
                Text(
                  extent={{-150,150},{150,110}},
                  textString="%name",
                  lineColor={0,0,255}),
                Polygon(
                  points={{50,-20},{50,20},{90,0},{50,-20}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid)}),
            Documentation(info="<HTML>
<p>
This model represents a variable temperature boundary condition.
The temperature in [K] is given as input signal <b>T</b>
to the model. The effect is that an instance of this model acts as
an infinite reservoir able to absorb or generate as much energy
as required to keep the temperature at the specified value.
</p>
</HTML>
"),         Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={
                Rectangle(
                  extent={{-100,100},{100,-100}},
                  lineColor={0,0,0},
                  pattern=LinePattern.None,
                  fillColor={159,159,223},
                  fillPattern=FillPattern.Backward),
                Text(
                  extent={{0,0},{-100,-100}},
                  lineColor={0,0,0},
                  textString="K"),
                Line(
                  points={{-102,0},{64,0}},
                  color={191,0,0},
                  thickness=0.5),
                Polygon(
                  points={{52,-20},{52,20},{90,0},{52,-20}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid)}));
        end PrescribedTemperature;
        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics),   Documentation(info="<html>

</html>"));
      end Sources;

      package Interfaces "Connectors and partial models"
        extends Modelica.Icons.InterfacesPackage;

        partial connector HeatPort "Thermal port for 1-dim. heat transfer"
          Modelica.SIunits.Temperature T "Port temperature";
          flow Modelica.SIunits.HeatFlowRate Q_flow
          "Heat flow rate (positive if flowing from outside into the component)";
          annotation (Documentation(info="<html>

</html>"));
        end HeatPort;

        connector HeatPort_a
        "Thermal port for 1-dim. heat transfer (filled rectangular icon)"

          extends HeatPort;

          annotation(defaultComponentName = "port_a",
            Documentation(info="<HTML>
<p>This connector is used for 1-dimensional heat flow between components.
The variables in the connector are:</p>
<pre>
   T       Temperature in [Kelvin].
   Q_flow  Heat flow rate in [Watt].
</pre>
<p>According to the Modelica sign convention, a <b>positive</b> heat flow
rate <b>Q_flow</b> is considered to flow <b>into</b> a component. This
convention has to be used whenever this connector is used in a model
class.</p>
<p>Note, that the two connector classes <b>HeatPort_a</b> and
<b>HeatPort_b</b> are identical with the only exception of the different
<b>icon layout</b>.</p></HTML>
"),         Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={Rectangle(
                  extent={{-100,100},{100,-100}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid)}),
            Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                    {100,100}}), graphics={Rectangle(
                  extent={{-50,50},{50,-50}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid), Text(
                  extent={{-120,120},{100,60}},
                  lineColor={191,0,0},
                  textString="%name")}));
        end HeatPort_a;

        connector HeatPort_b
        "Thermal port for 1-dim. heat transfer (unfilled rectangular icon)"

          extends HeatPort;

          annotation(defaultComponentName = "port_b",
            Documentation(info="<HTML>
<p>This connector is used for 1-dimensional heat flow between components.
The variables in the connector are:</p>
<pre>
   T       Temperature in [Kelvin].
   Q_flow  Heat flow rate in [Watt].
</pre>
<p>According to the Modelica sign convention, a <b>positive</b> heat flow
rate <b>Q_flow</b> is considered to flow <b>into</b> a component. This
convention has to be used whenever this connector is used in a model
class.</p>
<p>Note, that the two connector classes <b>HeatPort_a</b> and
<b>HeatPort_b</b> are identical with the only exception of the different
<b>icon layout</b>.</p></HTML>
"),         Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                    {100,100}}), graphics={Rectangle(
                  extent={{-50,50},{50,-50}},
                  lineColor={191,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid), Text(
                  extent={{-100,120},{120,60}},
                  lineColor={191,0,0},
                  textString="%name")}),
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={Rectangle(
                  extent={{-100,100},{100,-100}},
                  lineColor={191,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid)}));
        end HeatPort_b;

        partial model Element1D
        "Partial heat transfer element with two HeatPort connectors that does not store energy"

          Modelica.SIunits.HeatFlowRate Q_flow
          "Heat flow rate from port_a -> port_b";
          Modelica.SIunits.TemperatureDifference dT "port_a.T - port_b.T";
      public
          HeatPort_a port_a annotation (Placement(transformation(extent={{-110,-10},
                    {-90,10}}, rotation=0)));
          HeatPort_b port_b annotation (Placement(transformation(extent={{90,-10},{
                    110,10}}, rotation=0)));
        equation
          dT = port_a.T - port_b.T;
          port_a.Q_flow = Q_flow;
          port_b.Q_flow = -Q_flow;
          annotation (Documentation(info="<HTML>
<p>
This partial model contains the basic connectors and variables to
allow heat transfer models to be created that <b>do not store energy</b>,
This model defines and includes equations for the temperature
drop across the element, <b>dT</b>, and the heat flow rate
through the element from port_a to port_b, <b>Q_flow</b>.
</p>
<p>
By extending this model, it is possible to write simple
constitutive equations for many types of heat transfer components.
</p>
</HTML>
"),     Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                    100}}),
             graphics),
            Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                    {100,100}}),
                    graphics));
        end Element1D;
        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics),
                                   Documentation(info="<html>

</html>"));
      end Interfaces;
      annotation (
         Icon(coordinateSystem(preserveAspectRatio=true,
              extent={{-100,-100},{100,100}}), graphics={
            Polygon(
              points={{-54,-6},{-61,-7},{-75,-15},{-79,-24},{-80,-34},{-78,-42},{-73,
                  -49},{-64,-51},{-57,-51},{-47,-50},{-41,-43},{-38,-35},{-40,-27},
                  {-40,-20},{-42,-13},{-47,-7},{-54,-5},{-54,-6}},
              lineColor={128,128,128},
              fillColor={192,192,192},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-75,-15},{-79,-25},{-80,-34},{-78,-42},{-72,-49},{-64,-51},{
                  -57,-51},{-47,-50},{-57,-47},{-65,-45},{-71,-40},{-74,-33},{-76,-23},
                  {-75,-15},{-75,-15}},
              lineColor={0,0,0},
              fillColor={160,160,164},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{39,-6},{32,-7},{18,-15},{14,-24},{13,-34},{15,-42},{20,-49},
                  {29,-51},{36,-51},{46,-50},{52,-43},{55,-35},{53,-27},{53,-20},{
                  51,-13},{46,-7},{39,-5},{39,-6}},
              lineColor={160,160,164},
              fillColor={192,192,192},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{18,-15},{14,-25},{13,-34},{15,-42},{21,-49},{29,-51},{36,-51},
                  {46,-50},{36,-47},{28,-45},{22,-40},{19,-33},{17,-23},{18,-15},{
                  18,-15}},
              lineColor={0,0,0},
              fillColor={160,160,164},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-9,-23},{-9,-10},{18,-17},{-9,-23}},
              lineColor={191,0,0},
              fillColor={191,0,0},
              fillPattern=FillPattern.Solid),
            Line(
              points={{-41,-17},{-9,-17}},
              color={191,0,0},
              thickness=0.5),
            Line(
              points={{-17,-40},{15,-40}},
              color={191,0,0},
              thickness=0.5),
            Polygon(
              points={{-17,-46},{-17,-34},{-40,-40},{-17,-46}},
              lineColor={191,0,0},
              fillColor={191,0,0},
              fillPattern=FillPattern.Solid)}),
                                Documentation(info="<HTML>
<p>
This package contains components to model <b>1-dimensional heat transfer</b>
with lumped elements. This allows especially to model heat transfer in
machines provided the parameters of the lumped elements, such as
the heat capacity of a part, can be determined by measurements
(due to the complex geometries and many materials used in machines,
calculating the lumped element parameters from some basic analytic
formulas is usually not possible).
</p>
<p>
Example models how to use this library are given in subpackage <b>Examples</b>.<br>
For a first simple example, see <b>Examples.TwoMasses</b> where two masses
with different initial temperatures are getting in contact to each
other and arriving after some time at a common temperature.<br>
<b>Examples.ControlledTemperature</b> shows how to hold a temperature
within desired limits by switching on and off an electric resistor.<br>
A more realistic example is provided in <b>Examples.Motor</b> where the
heating of an electrical motor is modelled, see the following screen shot
of this example:
</p>
<img src=\"modelica://Modelica/Resources/Images/Thermal/HeatTransfer/driveWithHeatTransfer.png\" ALT=\"driveWithHeatTransfer\">
<p>
The <b>filled</b> and <b>non-filled red squares</b> at the left and
right side of a component represent <b>thermal ports</b> (connector HeatPort).
Drawing a line between such squares means that they are thermally connected.
The variables of a HeatPort connector are the temperature <b>T</b> at the port
and the heat flow rate <b>Q_flow</b> flowing into the component (if Q_flow is positive,
the heat flows into the element, otherwise it flows out of the element):
</p>
<pre>   Modelica.SIunits.Temperature  T  \"absolute temperature at port in Kelvin\";
   Modelica.SIunits.HeatFlowRate Q_flow  \"flow rate at the port in Watt\";
</pre>
<p>
Note, that all temperatures of this package, including initial conditions,
are given in Kelvin. For convenience, in subpackages <b>HeatTransfer.Celsius</b>,
 <b>HeatTransfer.Fahrenheit</b> and <b>HeatTransfer.Rankine</b> components are provided such that source and
sensor information is available in degree Celsius, degree Fahrenheit, or degree Rankine,
respectively. Additionally, in package <b>SIunits.Conversions</b> conversion
functions between the units Kelvin and Celsius, Fahrenheit, Rankine are
provided. These functions may be used in the following way:
</p>
<pre>  <b>import</b> SI=Modelica.SIunits;
  <b>import</b> Modelica.SIunits.Conversions.*;
     ...
  <b>parameter</b> SI.Temperature T = from_degC(25);  // convert 25 degree Celsius to Kelvin
</pre>

<p>
There are several other components available, such as AxialConduction (discretized PDE in
axial direction), which have been temporarily removed from this library. The reason is that
these components reference material properties, such as thermal conductivity, and currently
the Modelica design group is discussing a general scheme to describe material properties.
</p>
<p>
For technical details in the design of this library, see the following reference:<br>
<b>Michael Tiller (2001)</b>: <a href=\"http://www.amazon.de\">
Introduction to Physical Modeling with Modelica</a>.
Kluwer Academic Publishers Boston.
</p>
<p>
<b>Acknowledgements:</b><br>
Several helpful remarks from the following persons are acknowledged:
John Batteh, Ford Motors, Dearborn, U.S.A;
<a href=\"http://www.haumer.at/\">Anton Haumer</a>, Technical Consulting &amp; Electrical Engineering, Austria;
Ludwig Marvan, VA TECH ELIN EBG Elektronik GmbH, Wien, Austria;
Hans Olsson, Dassault Syst&egrave;mes AB, Sweden;
Hubertus Tummescheit, Lund Institute of Technology, Lund, Sweden.
</p>
<dl>
  <dt><b>Main Authors:</b></dt>
  <dd>
  <p>
  <a href=\"http://www.haumer.at/\">Anton Haumer</a><br>
  Technical Consulting &amp; Electrical Engineering<br>
  A-3423 St.Andrae-Woerdern, Austria<br>
  email: <a href=\"mailto:a.haumer@haumer.at\">a.haumer@haumer.at</a>
</p>
  </dd>
</dl>
<p><b>Copyright &copy; 2001-2010, Modelica Association, Michael Tiller and DLR.</b></p>

<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</HTML>
",     revisions="<html>
<ul>
<li><i>July 15, 2002</i>
       by Michael Tiller, <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>
       and <a href=\"http://www.robotic.dlr.de/Nikolaus.Schuermann/\">Nikolaus Sch&uuml;rmann</a>:<br>
       Implemented.
</li>
<li><i>June 13, 2005</i>
       by <a href=\"http://www.haumer.at/\">Anton Haumer</a><br>
       Refined placing of connectors (cosmetic).<br>
       Refined all Examples; removed Examples.FrequencyInverter, introducing Examples.Motor<br>
       Introduced temperature dependent correction (1 + alpha*(T - T_ref)) in Fixed/PrescribedHeatFlow<br>
</li>
  <li> v1.1.1 2007/11/13 Anton Haumer<br>
       componentes moved to sub-packages</li>
  <li> v1.2.0 2009/08/26 Anton Haumer<br>
       added component ThermalCollector</li>

</ul>
</html>"));
    end HeatTransfer;
  annotation (Documentation(info="<html>
<p>
This package contains libraries to model heat transfer
and fluid heat flow.
</p>
</html>"));
  end Thermal;

  package Math
  "Library of mathematical functions (e.g., sin, cos) and of functions operating on vectors and matrices"
  import SI = Modelica.SIunits;
  extends Modelica.Icons.Package;

  package Vectors "Library of functions operating on vectors"
    extends Modelica.Icons.Package;

    function interpolate "Interpolate in a vector"
      input Real x[ :]
      "Abszissa table vector (strict monotonically increasing values required)";
      input Real y[ size(x,1)] "Ordinate table vector";
      input Real xi "Desired abszissa value";
      input Integer iLast=1 "Index used in last search";
      output Real yi "Ordinate value corresponding to xi";
      output Integer iNew=1 "xi is in the interval x[iNew] <= xi < x[iNew+1]";
  protected
      Integer i;
      Integer nx=size(x,1);
      Real x1;
      Real x2;
      Real y1;
      Real y2;
    algorithm
      assert(nx > 0, "The table vectors must have at least 1 entry.");
      if nx == 1 then
        yi := y[1];
      else
        // Search interval
        i := min(max(iLast,1),nx-1);
        if xi >= x[i] then
           // search forward
           while i < nx and xi >= x[i] loop
              i := i + 1;
           end while;
           i := i - 1;
        else
           // search backward
           while i > 1 and xi < x[i] loop
              i := i - 1;
           end while;
        end if;

        // Get interpolation data
        x1 := x[i];
        x2 := x[i+1];
        y1 := y[i];
        y2 := y[i+1];

        assert(x2 > x1, "Abszissa table vector values must be increasing");
        // Interpolate
        yi := y1 + (y2 - y1)*(xi - x1)/(x2 - x1);
        iNew :=i;
      end if;

      annotation (Documentation(info="<html>
<h4>Syntax</h4>
<blockquote><pre>
// Real    x[:], y[:], xi, yi;
// Integer iLast, iNew;
        yi = Vectors.<b>interpolate</b>(x,y,xi);
(yi, iNew) = Vectors.<b>interpolate</b>(x,y,xi,iLast=1);
</pre></blockquote>
<h4>Description</h4>
<p>
The function call \"<code>Vectors.interpolate(x,y,xi)</code>\" interpolates in vectors
(x,y) and returns the value yi that corresponds to xi. Vector x[:] must consist
of strictly monotonocially increasing values. If xi &lt; x[1] or &gt; x[end], then
extrapolation takes places through the first or last two x[:] values, respectively.
The search for the interval x[iNew] &le; xi &lt; x[iNew+1] starts at the optional
input argument \"iLast\". The index \"iNew\" is returned as output argument.
The usage of \"iLast\" and \"iNew\" is useful to increase the efficiency of the call,
if many interpolations take place.
</p>

<h4>Example</h4>

<blockquote><pre>
  Real x[:] = { 0,  2,  4,  6,  8, 10};
  Real y[:] = {10, 20, 30, 40, 50, 60};
<b>algorithm</b>
  (yi, iNew) := Vectors.interpolate(x,y,5);  // yi = 35, iNew=3
</pre></blockquote>

</html>"));
    end interpolate;
    annotation (
      preferedView = "info",
      Documentation(info="<HTML>
<h4>Library content</h4>
<p>
This library provides functions operating on vectors:
</p>

<ul>
<li> <a href=\"modelica://Modelica.Math.Vectors.toString\">toString</a>(v)
     - returns the string representation of vector v.</li>

<li> <a href=\"modelica://Modelica.Math.Vectors.isEqual\">isEqual</a>(v1, v2)
     - returns true if vectors v1 and v2 have the same size and the same elements.</li>

<li> <a href=\"modelica://Modelica.Math.Vectors.norm\">norm</a>(v,p)
     - returns the p-norm of vector v.</li>

<li> <a href=\"modelica://Modelica.Math.Vectors.length\">length</a>(v)
     - returns the length of vector v (= norm(v,2), but inlined and therefore usable in
       symbolic manipulations)</li>

<li> <a href=\"modelica://Modelica.Math.Vectors.normalize\">normalize</a>(v)
     - returns vector in direction of v with lenght = 1 and prevents
       zero-division for zero vector.</li>

<li> <a href=\"modelica://Modelica.Math.Vectors.reverse\">reverse</a>(v)
     - reverses the vector elements of v. </li>

<li> <a href=\"modelica://Modelica.Math.Vectors.sort\">sort</a>(v)
     - sorts the elements of vector v in ascending or descending order.</li>

<li> <a href=\"modelica://Modelica.Math.Vectors.find\">find</a>(e, v)
     - returns the index of the first occurence of scalar e in vector v.</li>

<li> <a href=\"modelica://Modelica.Math.Vectors.interpolate\">interpolate</a>(x, y, xi)
     - returns the interpolated value in (x,y) that corresponds to xi.</li>

<li> <a href=\"modelica://Modelica.Math.Vectors.relNodePositions\">relNodePositions</a>(nNodes)
     - returns a vector of relative node positions (0..1).</li>
</ul>

<h4>See also</h4>
<a href=\"modelica://Modelica.Math.Matrices\">Matrices</a>
</HTML>"));
  end Vectors;

  function sin "Sine"
    extends baseIcon1;
    input Modelica.SIunits.Angle u;
    output Real y;

  external "builtin" y=  sin(u);
    annotation (
      Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(points={{-90,0},{68,0}}, color={192,192,192}),
          Polygon(
            points={{90,0},{68,8},{68,-8},{90,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,0},{-68.7,34.2},{-61.5,53.1},{-55.1,66.4},{-49.4,74.6},
                {-43.8,79.1},{-38.2,79.8},{-32.6,76.6},{-26.9,69.7},{-21.3,59.4},
                {-14.9,44.1},{-6.83,21.2},{10.1,-30.8},{17.3,-50.2},{23.7,-64.2},
                {29.3,-73.1},{35,-78.4},{40.6,-80},{46.2,-77.6},{51.9,-71.5},{
                57.5,-61.9},{63.9,-47.2},{72,-24.8},{80,0}}, color={0,0,0}),
          Text(
            extent={{12,84},{84,36}},
            lineColor={192,192,192},
            textString="sin")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(points={{-100,0},{84,0}}, color={95,95,95}),
          Polygon(
            points={{100,0},{84,6},{84,-6},{100,0}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-80,0},{-68.7,34.2},{-61.5,53.1},{-55.1,66.4},{-49.4,74.6},{
                -43.8,79.1},{-38.2,79.8},{-32.6,76.6},{-26.9,69.7},{-21.3,59.4},{
                -14.9,44.1},{-6.83,21.2},{10.1,-30.8},{17.3,-50.2},{23.7,-64.2},{
                29.3,-73.1},{35,-78.4},{40.6,-80},{46.2,-77.6},{51.9,-71.5},{57.5,
                -61.9},{63.9,-47.2},{72,-24.8},{80,0}},
            color={0,0,255},
            thickness=0.5),
          Text(
            extent={{-105,72},{-85,88}},
            textString="1",
            lineColor={0,0,255}),
          Text(
            extent={{70,25},{90,5}},
            textString="2*pi",
            lineColor={0,0,255}),
          Text(
            extent={{-103,-72},{-83,-88}},
            textString="-1",
            lineColor={0,0,255}),
          Text(
            extent={{82,-6},{102,-26}},
            lineColor={95,95,95},
            textString="u"),
          Line(
            points={{-80,80},{-28,80}},
            color={175,175,175},
            smooth=Smooth.None),
          Line(
            points={{-80,-80},{50,-80}},
            color={175,175,175},
            smooth=Smooth.None)}),
      Documentation(info="<html>
<p>
This function returns y = sin(u), with -&infin; &lt; u &lt; &infin;:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/sin.png\">
</p>
</html>"),   Library="ModelicaExternalC");
  end sin;

  function asin "Inverse sine (-1 <= u <= 1)"
    extends baseIcon2;
    input Real u;
    output SI.Angle y;

  external "builtin" y=  asin(u);
    annotation (
      Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(points={{-90,0},{68,0}}, color={192,192,192}),
          Polygon(
            points={{90,0},{68,8},{68,-8},{90,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,-80},{-79.2,-72.8},{-77.6,-67.5},{-73.6,-59.4},{-66.3,
                -49.8},{-53.5,-37.3},{-30.2,-19.7},{37.4,24.8},{57.5,40.8},{68.7,
                52.7},{75.2,62.2},{77.6,67.5},{80,80}}, color={0,0,0}),
          Text(
            extent={{-88,78},{-16,30}},
            lineColor={192,192,192},
            textString="asin")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Text(
            extent={{-40,-72},{-15,-88}},
            textString="-pi/2",
            lineColor={0,0,255}),
          Text(
            extent={{-38,88},{-13,72}},
            textString=" pi/2",
            lineColor={0,0,255}),
          Text(
            extent={{68,-9},{88,-29}},
            textString="+1",
            lineColor={0,0,255}),
          Text(
            extent={{-90,21},{-70,1}},
            textString="-1",
            lineColor={0,0,255}),
          Line(points={{-100,0},{84,0}}, color={95,95,95}),
          Polygon(
            points={{98,0},{82,6},{82,-6},{98,0}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-80,-80},{-79.2,-72.8},{-77.6,-67.5},{-73.6,-59.4},{-66.3,-49.8},
                {-53.5,-37.3},{-30.2,-19.7},{37.4,24.8},{57.5,40.8},{68.7,52.7},{
                75.2,62.2},{77.6,67.5},{80,80}},
            color={0,0,255},
            thickness=0.5),
          Text(
            extent={{82,24},{102,4}},
            lineColor={95,95,95},
            textString="u"),
          Line(
            points={{0,80},{86,80}},
            color={175,175,175},
            smooth=Smooth.None),
          Line(
            points={{80,86},{80,-10}},
            color={175,175,175},
            smooth=Smooth.None)}),
      Documentation(info="<html>
<p>
This function returns y = asin(u), with -1 &le; u &le; +1:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/asin.png\">
</p>
</html>"),   Library="ModelicaExternalC");
  end asin;

  partial function baseIcon1
    "Basic icon for mathematical function with y-axis on left side"

    annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,-80},{-80,68}}, color={192,192,192}),
          Polygon(
            points={{-80,90},{-88,68},{-72,68},{-80,90}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-150,150},{150,110}},
            textString="%name",
            lineColor={0,0,255})}),                          Diagram(
          coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
              100}}), graphics={
          Line(points={{-80,80},{-88,80}}, color={95,95,95}),
          Line(points={{-80,-80},{-88,-80}}, color={95,95,95}),
          Line(points={{-80,-90},{-80,84}}, color={95,95,95}),
          Text(
            extent={{-75,104},{-55,84}},
            lineColor={95,95,95},
            textString="y"),
          Polygon(
            points={{-80,98},{-86,82},{-74,82},{-80,98}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid)}),
      Documentation(info="<html>
<p>
Icon for a mathematical function, consisting of an y-axis on the left side.
It is expected, that an x-axis is added and a plot of the function.
</p>
</html>"));
  end baseIcon1;

  partial function baseIcon2
    "Basic icon for mathematical function with y-axis in middle"

    annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(points={{0,-80},{0,68}}, color={192,192,192}),
          Polygon(
            points={{0,90},{-8,68},{8,68},{0,90}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-150,150},{150,110}},
            textString="%name",
            lineColor={0,0,255})}),                          Diagram(graphics={
          Line(points={{0,80},{-8,80}}, color={95,95,95}),
          Line(points={{0,-80},{-8,-80}}, color={95,95,95}),
          Line(points={{0,-90},{0,84}}, color={95,95,95}),
          Text(
            extent={{5,104},{25,84}},
            lineColor={95,95,95},
            textString="y"),
          Polygon(
            points={{0,98},{-6,82},{6,82},{0,98}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid)}),
      Documentation(info="<html>
<p>
Icon for a mathematical function, consisting of an y-axis in the middle.
It is expected, that an x-axis is added and a plot of the function.
</p>
</html>"));
  end baseIcon2;
  annotation (
    Invisible=true,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics={Text(
          extent={{-59,-9},{42,-56}},
          lineColor={0,0,0},
          textString="f(x)")}),
    Documentation(info="<HTML>
<p>
This package contains <b>basic mathematical functions</b> (such as sin(..)),
as well as functions operating on
<a href=\"modelica://Modelica.Math.Vectors\">vectors</a>,
<a href=\"modelica://Modelica.Math.Matrices\">matrices</a>,
<a href=\"modelica://Modelica.Math.Nonlinear\">nonlinear functions</a>, and
<a href=\"modelica://Modelica.Math.BooleanVectors\">Boolean vectors</a>.
</p>

<dl>
<dt><b>Main Authors:</b>
<dd><a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a> and
    Marcus Baur<br>
    Deutsches Zentrum f&uuml;r Luft und Raumfahrt e.V. (DLR)<br>
    Institut f&uuml;r Robotik und Mechatronik<br>
    Postfach 1116<br>
    D-82230 Wessling<br>
    Germany<br>
    email: <A HREF=\"mailto:Martin.Otter@dlr.de\">Martin.Otter@dlr.de</A><br>
</dl>

<p>
Copyright &copy; 1998-2010, Modelica Association and DLR.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</HTML>
",   revisions="<html>
<ul>
<li><i>October 21, 2002</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>
       and <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       Function tempInterpol2 added.</li>
<li><i>Oct. 24, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Icons for icon and diagram level introduced.</li>
<li><i>June 30, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized.</li>
</ul>

</html>"));
  end Math;

  package Constants
  "Library of mathematical constants and constants of nature (e.g., pi, eps, R, sigma)"
    import SI = Modelica.SIunits;
    import NonSI = Modelica.SIunits.Conversions.NonSIunits;
    extends Modelica.Icons.Package;

    final constant Real pi=2*Modelica.Math.asin(1.0);

    final constant Real small=1.e-60
    "Smallest number such that small and -small are representable on the machine";
    annotation (
      Documentation(info="<html>
<p>
This package provides often needed constants from mathematics, machine
dependent constants and constants from nature. The latter constants
(name, value, description) are from the following source:
</p>

<dl>
<dt>Peter J. Mohr and Barry N. Taylor (1999):</dt>
<dd><b>CODATA Recommended Values of the Fundamental Physical Constants: 1998</b>.
    Journal of Physical and Chemical Reference Data, Vol. 28, No. 6, 1999 and
    Reviews of Modern Physics, Vol. 72, No. 2, 2000. See also <a href=
\"http://physics.nist.gov/cuu/Constants/\">http://physics.nist.gov/cuu/Constants/</a></dd>
</dl>

<p>CODATA is the Committee on Data for Science and Technology.</p>

<dl>
<dt><b>Main Author:</b></dt>
<dd><a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a><br>
    Deutsches Zentrum f&uuml;r Luft und Raumfahrt e. V. (DLR)<br>
    Oberpfaffenhofen<br>
    Postfach 11 16<br>
    D-82230 We&szlig;ling<br>
    email: <a href=\"mailto:Martin.Otter@dlr.de\">Martin.Otter@dlr.de</a></dd>
</dl>

<p>
Copyright &copy; 1998-2010, Modelica Association and DLR.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</html>
",   revisions="<html>
<ul>
<li><i>Nov 8, 2004</i>
       by <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       Constants updated according to 2002 CODATA values.</li>
<li><i>Dec 9, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Constants updated according to 1998 CODATA values. Using names, values
       and description text from this source. Included magnetic and
       electric constant.</li>
<li><i>Sep 18, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Constants eps, inf, small introduced.</li>
<li><i>Nov 15, 1997</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized.</li>
</ul>
</html>"),
      Invisible=true,
      Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
              100}}), graphics={
          Line(
            points={{-34,-38},{12,-38}},
            color={0,0,0},
            thickness=0.5),
          Line(
            points={{-20,-38},{-24,-48},{-28,-56},{-34,-64}},
            color={0,0,0},
            thickness=0.5),
          Line(
            points={{-2,-38},{2,-46},{8,-56},{14,-64}},
            color={0,0,0},
            thickness=0.5)}),
      Diagram(graphics={
          Rectangle(
            extent={{200,162},{380,312}},
            fillColor={235,235,235},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,255}),
          Polygon(
            points={{200,312},{220,332},{400,332},{380,312},{200,312}},
            fillColor={235,235,235},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,255}),
          Polygon(
            points={{400,332},{400,182},{380,162},{380,312},{400,332}},
            fillColor={235,235,235},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,255}),
          Text(
            extent={{210,302},{370,272}},
            lineColor={160,160,164},
            textString="Library"),
          Line(
            points={{266,224},{312,224}},
            color={0,0,0},
            thickness=1),
          Line(
            points={{280,224},{276,214},{272,206},{266,198}},
            color={0,0,0},
            thickness=1),
          Line(
            points={{298,224},{302,216},{308,206},{314,198}},
            color={0,0,0},
            thickness=1),
          Text(
            extent={{152,412},{458,334}},
            lineColor={255,0,0},
            textString="Modelica.Constants")}));
  end Constants;

  package Icons "Library of icons"
    extends Icons.Package;

    partial package ExamplesPackage
    "Icon for packages containing runnable examples"
    //extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
              extent={{-80,100},{100,-80}},
              lineColor={0,0,0},
              fillColor={215,230,240},
              fillPattern=FillPattern.Solid), Rectangle(
              extent={{-100,80},{80,-100}},
              lineColor={0,0,0},
              fillColor={240,240,240},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-58,46},{42,-14},{-58,-74},{-58,46}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>This icon indicates a package that contains executable examples.</p>
</html>"));
    end ExamplesPackage;

    partial model Example "Icon for runnable examples"

      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Ellipse(extent={{-100,100},{100,-100}},
                lineColor={95,95,95},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
                                       Polygon(
              points={{-36,60},{64,0},{-36,-60},{-36,60}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>This icon indicates an example. The play button suggests that the example can be executed.</p>
</html>"));
    end Example;

    partial package Package "Icon for standard packages"

      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
              extent={{-80,100},{100,-80}},
              lineColor={0,0,0},
              fillColor={215,230,240},
              fillPattern=FillPattern.Solid), Rectangle(
              extent={{-100,80},{80,-100}},
              lineColor={0,0,0},
              fillColor={240,240,240},
              fillPattern=FillPattern.Solid)}),
                                Documentation(info="<html>
<p>Standard package icon.</p>
</html>"));
    end Package;

    partial package BasesPackage "Icon for packages containing base classes"
    //extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
              extent={{-80,100},{100,-80}},
              lineColor={0,0,0},
              fillColor={215,230,240},
              fillPattern=FillPattern.Solid), Rectangle(
              extent={{-100,80},{80,-100}},
              lineColor={0,0,0},
              fillColor={240,240,240},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-30,10},{10,-30}},
              lineColor={0,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid)}),
                                Documentation(info="<html>
<p>This icon shall be used for a package/library that contains base models and classes, respectively.</p>
</html>"));
    end BasesPackage;

    partial package InterfacesPackage "Icon for packages containing interfaces"
    //extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
              extent={{-80,100},{100,-80}},
              lineColor={0,0,0},
              fillColor={215,230,240},
              fillPattern=FillPattern.Solid), Rectangle(
              extent={{-100,80},{80,-100}},
              lineColor={0,0,0},
              fillColor={240,240,240},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{0,50},{20,50},{50,10},{80,10},{80,-30},{50,-30},{20,-70},{
                  0,-70},{0,50}},
              lineColor={0,0,0},
              smooth=Smooth.None,
              fillColor={215,215,215},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-100,10},{-70,10},{-40,50},{-20,50},{-20,-70},{-40,-70},{
                  -70,-30},{-100,-30},{-100,10}},
              lineColor={0,0,0},
              smooth=Smooth.None,
              fillColor={215,230,240},
              fillPattern=FillPattern.Solid)}),
                                Documentation(info="<html>
<p>This icon indicates packages containing interfaces.</p>
</html>"));
    end InterfacesPackage;

    partial package SourcesPackage "Icon for packages containing sources"
    //extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
              extent={{-80,100},{100,-80}},
              lineColor={0,0,0},
              fillColor={215,230,240},
              fillPattern=FillPattern.Solid), Rectangle(
              extent={{-100,80},{80,-100}},
              lineColor={0,0,0},
              fillColor={240,240,240},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-28,12},{-28,-40},{36,-14},{-28,12}},
              lineColor={0,0,0},
              smooth=Smooth.None,
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Line(
              points={{-28,-14},{-68,-14}},
              color={0,0,0},
              smooth=Smooth.None)}),
                                Documentation(info="<html>
<p>This icon indicates a package which contains sources.</p>
</html>"));
    end SourcesPackage;

    partial package MaterialPropertiesPackage
    "Icon for package containing property classes"
    //extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
              extent={{-80,100},{100,-80}},
              lineColor={0,0,0},
              fillColor={215,230,240},
              fillPattern=FillPattern.Solid), Rectangle(
              extent={{-100,80},{80,-100}},
              lineColor={0,0,0},
              fillColor={240,240,240},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-68,50},{52,-70}},
              lineColor={0,0,0},
              fillPattern=FillPattern.Sphere,
              fillColor={215,230,240})}),
                                Documentation(info="<html>
<p>This icon indicates a package that contains properties</p>
</html>"));
    end MaterialPropertiesPackage;

    partial class MaterialProperty "Icon for property classes"

      annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
                {100,100}}),       graphics={
            Ellipse(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              fillPattern=FillPattern.Sphere,
              fillColor={215,230,240})}),
                                Documentation(info="<html>
<p>This icon indicates a property class.</p>
</html>"));
    end MaterialProperty;

    partial record Record "Icon for records"

      annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}}), graphics={
            Rectangle(
              extent={{-100,50},{100,-100}},
              fillColor={255,255,127},
              fillPattern=FillPattern.Solid,
              lineColor={0,0,255}),
            Text(
              extent={{-127,115},{127,55}},
              textString="%name",
              lineColor={0,0,255}),
            Line(points={{-100,-50},{100,-50}}, color={0,0,0}),
            Line(points={{-100,0},{100,0}}, color={0,0,0}),
            Line(points={{0,50},{0,-100}}, color={0,0,0})}),
                                                          Documentation(info="<html>
<p>
This icon is indicates a record.
</p>
</html>"));
    end Record;

    partial package Library
    "This icon will be removed in future Modelica versions, use Package instead"

      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
              extent={{-80,100},{100,-80}},
              lineColor={0,0,0},
              fillColor={215,230,240},
              fillPattern=FillPattern.Solid), Rectangle(
              extent={{-100,80},{80,-100}},
              lineColor={0,0,0},
              fillColor={240,240,240},
              fillPattern=FillPattern.Solid)}),
                                Documentation(info="<html>
<p>This icon of a package will be removed in future versions of the library.</p>
<h5>Note</h5>
<p>This icon will be removed in future versions of the Modelica Standard Library. Instead the icon <a href=\"modelica://Modelica.Icons.Package\">Package</a> shall be used.</p>
</html>"));
    end Library;
    annotation(Documentation(__Dymola_DocumentationClass=true, info="<html>
<p>This package contains definitions for the graphical layout of components which may be used in different libraries. The icons can be utilized by inheriting them in the desired class using &quot;extends&quot; or by directly copying the &quot;icon&quot; layer. </p>
<dl>
<dt><b>Main Authors:</b> </dt>
    <dd><a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a></dd><dd>Deutsches Zentrum fuer Luft und Raumfahrt e.V. (DLR)</dd><dd>Oberpfaffenhofen</dd><dd>Postfach 1116</dd><dd>D-82230 Wessling</dd><dd>email: <a href=\"mailto:Martin.Otter@dlr.de\">Martin.Otter@dlr.de</a></dd><br>
    <dd>Christian Kral</dd><dd><a href=\"http://www.ait.ac.at/\">Austrian Institute of Technology, AIT</a></dd><dd>Mobility Department</dd><dd>Giefinggasse 2</dd><dd>1210 Vienna, Austria</dd><dd>email: <a href=\"mailto:christian.kral@ait.ac.at\">christian.kral@ait.ac.at</a></dd><br>
    <dd align=\"justify\">Johan Andreasson</dd><dd align=\"justify\"><a href=\"http://www.modelon.se/\">Modelon AB</a></dd><dd align=\"justify\">Ideon Science Park</dd><dd align=\"justify\">22370 Lund, Sweden</dd><dd align=\"justify\">email: <a href=\"mailto:johan.andreasson@modelon.se\">johan.andreasson@modelon.se</a></dd>
</dl>
<p>Copyright &copy; 1998-2010, Modelica Association, DLR, AIT, and Modelon AB. </p>
<p><i>This Modelica package is <b>free</b> software; it can be redistributed and/or modified under the terms of the <b>Modelica license</b>, see the license conditions and the accompanying <b>disclaimer</b> in <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a>.</i> </p>
</html>"));
  end Icons;

  package SIunits
  "Library of type and unit definitions based on SI units according to ISO 31-1992"
    extends Modelica.Icons.Package;

    package Conversions
    "Conversion functions to/from non SI units and type definitions of non SI units"
      extends Modelica.Icons.Package;

      package NonSIunits "Type definitions of non SI units"
        extends Modelica.Icons.Package;
        annotation (Documentation(info="<HTML>
<p>
This package provides predefined types, such as <b>Angle_deg</b> (angle in
degree), <b>AngularVelocity_rpm</b> (angular velocity in revolutions per
minute) or <b>Temperature_degF</b> (temperature in degree Fahrenheit),
which are in common use but are not part of the international standard on
units according to ISO 31-1992 \"General principles concerning quantities,
units and symbols\" and ISO 1000-1992 \"SI units and recommendations for
the use of their multiples and of certain other units\".</p>
<p>If possible, the types in this package should not be used. Use instead
types of package Modelica.SIunits. For more information on units, see also
the book of Francois Cardarelli <b>Scientific Unit Conversion - A
Practical Guide to Metrication</b> (Springer 1997).</p>
<p>Some units, such as <b>Temperature_degC/Temp_C</b> are both defined in
Modelica.SIunits and in Modelica.Conversions.NonSIunits. The reason is that these
definitions have been placed erroneously in Modelica.SIunits although they
are not SIunits. For backward compatibility, these type definitions are
still kept in Modelica.SIunits.</p>
</HTML>
"),   Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                  100}}), graphics={Text(
                extent={{-66,-13},{52,-67}},
                lineColor={0,0,0},
                textString="[km/h]")}));
      end NonSIunits;
      annotation (Icon(coordinateSystem(preserveAspectRatio=true,
                       extent={{-100,-100},{100,100}}), graphics),
                                Documentation(info="<HTML>
<p>This package provides conversion functions from the non SI Units
defined in package Modelica.SIunits.Conversions.NonSIunits to the
corresponding SI Units defined in package Modelica.SIunits and vice
versa. It is recommended to use these functions in the following
way (note, that all functions have one Real input and one Real output
argument):</p>
<pre>
  <b>import</b> SI = Modelica.SIunits;
  <b>import</b> Modelica.SIunits.Conversions.*;
     ...
  <b>parameter</b> SI.Temperature     T   = from_degC(25);   // convert 25 degree Celsius to Kelvin
  <b>parameter</b> SI.Angle           phi = from_deg(180);   // convert 180 degree to radian
  <b>parameter</b> SI.AngularVelocity w   = from_rpm(3600);  // convert 3600 revolutions per minutes
                                                      // to radian per seconds
</pre>

</HTML>
"));
    end Conversions;

    type Angle = Real (
        final quantity="Angle",
        final unit="rad",
        displayUnit="deg");

    type Time = Real (final quantity="Time", final unit="s");

    type Frequency = Real (final quantity="Frequency", final unit="Hz");

    type Mass = Real (
        quantity="Mass",
        final unit="kg",
        min=0);

    type Density = Real (
        final quantity="Density",
        final unit="kg/m3",
        displayUnit="g/cm3",
        min=0);

    type Pressure = Real (
        final quantity="Pressure",
        final unit="Pa",
        displayUnit="bar");

    type KinematicViscosity = Real (
        final quantity="KinematicViscosity",
        final unit="m2/s",
        min=0);

    type Power = Real (final quantity="Power", final unit="W");

    type EnthalpyFlowRate = Real (final quantity="EnthalpyFlowRate", final unit=
            "W");

    type MassFlowRate = Real (quantity="MassFlowRate", final unit="kg/s");

    type ThermodynamicTemperature = Real (
        final quantity="ThermodynamicTemperature",
        final unit="K",
        min = 0,
        start = 288.15,
        displayUnit="degC")
    "Absolute temperature (use type TemperatureDifference for relative temperatures)"
                                                                                                        annotation(__Dymola_absoluteValue=true);

    type Temperature = ThermodynamicTemperature;

    type TemperatureDifference = Real (
        final quantity="ThermodynamicTemperature",
        final unit="K") annotation(__Dymola_absoluteValue=false);

    type TemperatureSlope = Real (final quantity="TemperatureSlope",
        final unit="K/s");

    type HeatFlowRate = Real (final quantity="Power", final unit="W");

    type ThermalConductivity = Real (final quantity="ThermalConductivity", final unit=
               "W/(m.K)");

    type ThermalConductance = Real (final quantity="ThermalConductance", final unit=
               "W/K");

    type HeatCapacity = Real (final quantity="HeatCapacity", final unit="J/K");

    type SpecificHeatCapacity = Real (final quantity="SpecificHeatCapacity",
          final unit="J/(kg.K)");

    type SpecificEnergy = Real (final quantity="SpecificEnergy", final unit=
            "J/kg");

    type SpecificEnthalpy = SpecificEnergy;
    annotation (
      Invisible=true,
      Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
              100}}), graphics={Text(
            extent={{-63,-13},{45,-67}},
            lineColor={0,0,0},
            textString="[kg.m2]")}),
      Documentation(info="<html>
<p>This package provides predefined types, such as <i>Mass</i>,
<i>Angle</i>, <i>Time</i>, based on the international standard
on units, e.g.,
</p>

<pre>   <b>type</b> Angle = Real(<b>final</b> quantity = \"Angle\",
                     <b>final</b> unit     = \"rad\",
                     displayUnit    = \"deg\");
</pre>

<p>
as well as conversion functions from non SI-units to SI-units
and vice versa in subpackage
<a href=\"modelica://Modelica.SIunits.Conversions\">Conversions</a>.
</p>

<p>
For an introduction how units are used in the Modelica standard library
with package SIunits, have a look at:
<a href=\"modelica://Modelica.SIunits.UsersGuide.HowToUseSIunits\">How to use SIunits</a>.
</p>

<p>
Copyright &copy; 1998-2010, Modelica Association and DLR.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</html>",   revisions="<html>
<ul>
<li><i>Jan. 27, 2010</i> by Christian Kral:<br/>Added complex units.</li>
<li><i>Dec. 14, 2005</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>Add User&#39;;s Guide and removed &quot;min&quot; values for Resistance and Conductance.</li>
<li><i>October 21, 2002</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a> and <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br/>Added new package <b>Conversions</b>. Corrected typo <i>Wavelenght</i>.</li>
<li><i>June 6, 2000</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>Introduced the following new types<br/>type Temperature = ThermodynamicTemperature;<br/>types DerDensityByEnthalpy, DerDensityByPressure, DerDensityByTemperature, DerEnthalpyByPressure, DerEnergyByDensity, DerEnergyByPressure<br/>Attribute &quot;final&quot; removed from min and max values in order that these values can still be changed to narrow the allowed range of values.<br/>Quantity=&quot;Stress&quot; removed from type &quot;Stress&quot;, in order that a type &quot;Stress&quot; can be connected to a type &quot;Pressure&quot;.</li>
<li><i>Oct. 27, 1999</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>New types due to electrical library: Transconductance, InversePotential, Damping.</li>
<li><i>Sept. 18, 1999</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>Renamed from SIunit to SIunits. Subpackages expanded, i.e., the SIunits package, does no longer contain subpackages.</li>
<li><i>Aug 12, 1999</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>Type &quot;Pressure&quot; renamed to &quot;AbsolutePressure&quot; and introduced a new type &quot;Pressure&quot; which does not contain a minimum of zero in order to allow convenient handling of relative pressure. Redefined BulkModulus as an alias to AbsolutePressure instead of Stress, since needed in hydraulics.</li>
<li><i>June 29, 1999</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>Bug-fix: Double definition of &quot;Compressibility&quot; removed and appropriate &quot;extends Heat&quot; clause introduced in package SolidStatePhysics to incorporate ThermodynamicTemperature.</li>
<li><i>April 8, 1998</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a> and Astrid Jaschinski:<br/>Complete ISO 31 chapters realized.</li>
<li><i>Nov. 15, 1997</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a> and <a href=\"http://www.control.lth.se/~hubertus/\">Hubertus Tummescheit</a>:<br/>Some chapters realized.</li>
</ul>
</html>"),
      Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
              100}}), graphics={
          Rectangle(
            extent={{169,86},{349,236}},
            fillColor={235,235,235},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,255}),
          Polygon(
            points={{169,236},{189,256},{369,256},{349,236},{169,236}},
            fillColor={235,235,235},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,255}),
          Polygon(
            points={{369,256},{369,106},{349,86},{349,236},{369,256}},
            fillColor={235,235,235},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,255}),
          Text(
            extent={{179,226},{339,196}},
            lineColor={160,160,164},
            textString="Library"),
          Text(
            extent={{206,173},{314,119}},
            lineColor={0,0,0},
            textString="[kg.m2]"),
          Text(
            extent={{163,320},{406,264}},
            lineColor={255,0,0},
            textString="Modelica.SIunits")}));
  end SIunits;
annotation (
preferredView="info",
version="3.2",
versionBuild=9,
versionDate="2010-10-25",
dateModified = "2012-02-09 11:32:00Z",
revisionId="",
uses(Complex(version="1.0"), ModelicaServices(version="1.2")),
conversion(
 noneFromVersion="3.1",
 noneFromVersion="3.0.1",
 noneFromVersion="3.0",
 from(version="2.1", script="modelica://Modelica/Resources/Scripts/Dymola/ConvertModelica_from_2.2.2_to_3.0.mos"),
 from(version="2.2", script="modelica://Modelica/Resources/Scripts/Dymola/ConvertModelica_from_2.2.2_to_3.0.mos"),
 from(version="2.2.1", script="modelica://Modelica/Resources/Scripts/Dymola/ConvertModelica_from_2.2.2_to_3.0.mos"),
 from(version="2.2.2", script="modelica://Modelica/Resources/Scripts/Dymola/ConvertModelica_from_2.2.2_to_3.0.mos")),
__Dymola_classOrder={"UsersGuide","Blocks","StateGraph","Electrical","Magnetic","Mechanics","Fluid","Media","Thermal",
      "Math","Utilities","Constants", "Icons", "SIunits"},
Settings(NewStateSelection=true),
Documentation(info="<HTML>
<p>
Package <b>Modelica&reg;</b> is a <b>standardized</b> and <b>free</b> package
that is developed together with the Modelica&reg; language from the
Modelica Association, see
<a href=\"http://www.Modelica.org\">http://www.Modelica.org</a>.
It is also called <b>Modelica Standard Library</b>.
It provides model components in many domains that are based on
standardized interface definitions. Some typical examples are shown
in the next figure:
</p>

<img src=\"modelica://Modelica/Resources/Images/UsersGuide/ModelicaLibraries.png\">

<p>
For an introduction, have especially a look at:
</p>
<ul>
<li> <a href=\"modelica://Modelica.UsersGuide.Overview\">Overview</a>
  provides an overview of the Modelica Standard Library
  inside the <a href=\"modelica://Modelica.UsersGuide\">User's Guide</a>.</li>
<li><a href=\"modelica://Modelica.UsersGuide.ReleaseNotes\">Release Notes</a>
 summarizes the changes of new versions of this package.</li>
<li> <a href=\"modelica://Modelica.UsersGuide.Contact\">Contact</a>
  lists the contributors of the Modelica Standard Library.</li>
<li> The <b>Examples</b> packages in the various libraries, demonstrate
  how to use the components of the corresponding sublibrary.</li>
</ul>

<p>
This version of the Modelica Standard Library consists of
</p>
<ul>
<li> <b>1280</b> models and blocks, and</li>
<li> <b>910</b> functions
</ul>
<p>
that are directly usable (= number of public, non-partial classes).
</p>

<p>
<b>Licensed by the Modelica Association under the Modelica License 2</b><br>
Copyright &copy; 1998-2010, ABB, AIT, T.&nbsp;B&ouml;drich, DLR, Dassault Syst&egrave;mes AB, Fraunhofer, A.Haumer, Modelon,
TU Hamburg-Harburg, Politecnico di Milano.
</p>

<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</HTML>
"));
end Modelica;

package IDEAS "Integrated District Energy Assessment Simulation"
  extends Modelica.Icons.Library;
  import SI = Modelica.SIunits;

  package Thermal "Thermal systems, HVAC and thermal renewable energy"
    extends Modelica.Icons.Package;
  import SI = Modelica.SIunits;
  import Annex60;

    package Components
    "Thermal models for building HVAC systems and their control"
      extends Modelica.Icons.Package;

      package Production "Models for heat/cold production devices"
        extends Modelica.Icons.Package;

        model Boiler
        "Modulating boiler with losses to environment, based on performance tables"
          extends
          IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses(
              final heaterType=IDEAS.Thermal.Components.Production.BaseClasses.HeaterType.Boiler);

          Real eta "Instanteanous efficiency";

          IDEAS.Thermal.Components.Production.BaseClasses.HeatSource_CondensingGasBurner
                                                           heatSource(
            medium=medium,
            QNom=QNom,
            TBoilerSet=TSet,
            TEnvironment=heatPort.T,
            UALoss=UALoss,
            THxIn=heatedFluid.T_a,
            m_flowHx=heatedFluid.flowPort_a.m_flow,
            modulationMin=modulationMin,
            modulationStart=modulationStart)
            annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
          parameter Real modulationMin=25 "Minimal modulation percentage";
          parameter Real modulationStart=35
          "Min estimated modulation level required for start of HP";
        equation
          // Electricity consumption for electronics and fan only.  Pump is covered by pumpHeater;
          // This data is taken from Viessmann VitoDens 300W, smallest model.  So only valid for
          // very small household condensing gas boilers.
          PEl = 7 + heatSource.modulation/100 * (33-7);
          PFuel = heatSource.PFuel;
          eta = heatSource.eta;
          connect(heatSource.heatPort, heatedFluid.heatPort) annotation (Line(
              points={{-48,30},{-20,30},{-20,6.12323e-016}},
              color={191,0,0},
              smooth=Smooth.None));
          annotation (Diagram(graphics), Icon(graphics={
                Ellipse(
                  extent={{-58,60},{60,-60}},
                  lineColor={127,0,0},
                  fillPattern=FillPattern.Solid,
                  fillColor={255,255,255}),
                Ellipse(extent={{-46,46},{48,-46}}, lineColor={95,95,95}),
                Line(
                  points={{-30,34},{32,-34}},
                  color={95,95,95},
                  smooth=Smooth.None),
                Line(
                  points={{100,20},{44,20}},
                  color={0,0,127},
                  smooth=Smooth.None),
                Line(
                  points={{102,-40},{70,-40},{70,-80},{0,-80},{0,-46}},
                  color={0,0,127},
                  smooth=Smooth.None)}),
            Documentation(info="<html>
<p><h4><font color=\"#008000\">Description </font></h4></p>
<p>Dynamic boiler model, based on interpolation in performance tables. The boiler has thermal losses to the environment which are often not mentioned in the performance tables. Therefore, the additional environmental heat losses are added to the heat production in order to ensure the same performance as in the manufacturers data, while still obtaining a dynamic model with heat losses (also when boiler is off). The heatSource will compute the required power and the environmental heat losses, and try to reach the set point. </p>
<p>See<a href=\"modelica://IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses\"> IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses</a> for more details about the heat losses and dynamics. </p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>Dynamic model based on water content and lumped dry capacity</li>
<li>Limited power (based on QNom and interpolation tables in heatSource) </li>
<li>Heat losses to environment which are compensated &apos;artifically&apos; to meet the manufacturers data in steady state conditions</li>
<li>No enforced min on or min off time; Hysteresis on start/stop thanks to different parameters for minimum modulation to start and stop the heat pump</li>
</ol></p>
<p><h4>Model use</h4></p>
<p>This model is based on performance tables of a specific boiler, as specified by <a href=\"modelica://IDEAS.Thermal.Components.Production.BaseClasses.HeatSource_CondensingGasBurner\">IDEAS.Thermal.Components.Production.BaseClasses.HeatSource_CondensingGasBurner</a>. If a different gas boiler is to be simulated, create a different Burner model with adapted interpolation tables.</p>
<p><ol>
<li>Specify medium and initial temperature (of the water + dry mass)</li>
<li>Specify the nominal power</li>
<li>Specify the minimum required modulation level for the boiler to start (modulation_start) and the minimum modulation level when the boiler is operating (modulation_min). The difference between both will ensure some off-time in case of low heat demands</li>
<li>Connect TSet, the flowPorts and the heatPort to environment. </li>
</ol></p>
<p>See also<a href=\"modelica://IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses\"> IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses</a> for more details about the heat losses and dynamics. </p>
<p><h4>Validation </h4></p>
<p>The model has been verified in order to check if the &apos;artificial&apos; heat loss compensation still leads to correct steady state efficiencies according to the manufacturer data. This verification is integrated in the example model <a href=\"modelica://IDEAS.Thermal.Components.Examples.Boiler_validation\">IDEAS.Thermal.Components.Examples.Boiler_validation</a>.</p>
<p><h4>Example</h4></p>
<p>See validation.</p>
</html>",         revisions="<html>
<p><ul>
<li>2013 May, Roel De Coninck: documentation</li>
<li>2011 August, Roel De Coninck: first version</li>
</ul></p>
</html>"));
        end Boiler;

        package BaseClasses
        "Partials, submodels and general stuff to be used in other HVAC models"
          extends Modelica.Icons.BasesPackage;

          type HeaterType = enumeration(
            HP_AW "Air/water Heat pump",
            HP_BW "Brine/water Heat pump",
            HP_BW_Collective "Brine/water HP with collective borefield",
            Boiler "Boiler")
          "Type of the heater: heat pump, gas boiler, fuel boiler, pellet boiler, ...";

          model HeatSource_CondensingGasBurner
          "Burner for use in Boiler, based on interpolation data.  Takes into account losses of the boiler to the environment"

            //protected
            parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water()
            "Medium in the component";

            final parameter Real[6] modVector={0,20,40,60,80,100}
            "6 modulation steps, %";
            Real eta
            "Instantaneous efficiency of the boiler (higher heating value)";
            Real[6] etaVector
            "Thermal efficiency (higher heating value) for 6 modulation steps, base 1";
            Real[6] QVector "Thermal power for 6 modulation steps, in kW";
            Modelica.SIunits.Power QMax
            "Maximum thermal power at specified evap and condr temperatures, in W";
            Modelica.SIunits.Power QAsked(start=0);
            parameter Modelica.SIunits.ThermalConductance UALoss
            "UA of heat losses of HP to environment";
            parameter Modelica.SIunits.Power QNom
            "The power at nominal conditions (50/30)";

        public
            parameter Real etaNom=0.922
            "Nominal efficiency (higher heating value)of the xxx boiler at 50/30degC.  See datafile";
            parameter Real modulationMin(max=29) = 25
            "Minimal modulation percentage";
              // dont' set this to 0 or very low values, you might get negative P at very low modulations because of wrong extrapolation
            parameter Real modulationStart(min=min(30, modulationMin + 5)) = 35
            "Min estimated modulation level required for start of HP";
            Real modulationInit
            "Initial modulation, decides on start/stop of the boiler";
            Real modulation(min=0, max=1) "Current modulation percentage";
            Modelica.SIunits.Power PFuel "Resulting fuel consumption";
            input Modelica.SIunits.Temperature THxIn "Condensor temperature";
            input Modelica.SIunits.Temperature TBoilerSet
            "Condensor setpoint temperature.  Not always possible to reach it";
            input Modelica.SIunits.MassFlowRate m_flowHx
            "Condensor mass flow rate";
            input Modelica.SIunits.Temperature TEnvironment
            "Temperature of environment for heat losses";

        protected
            Real kgps2lph=3600/medium.rho*1000 "Conversion from kg/s to l/h";
            Modelica.Blocks.Tables.CombiTable2D eta100(smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
                table=[0,100,400,700,1000,1300; 20.0,0.9015,0.9441,0.9599,0.9691,0.9753;
                  30.0,0.8824,0.9184,0.9324,0.941,0.9471; 40.0,0.8736,0.8909,0.902,0.9092,
                  0.9143; 50.0,0.8676,0.8731,0.8741,0.8746,0.8774; 60.0,0.8,0.867,0.8681,
                  0.8686,0.8689; 70.0,0.8,0.8609,0.8619,0.8625,0.8628; 80.0,0.8,0.8547,
                  0.8558,0.8563,0.8566])
              annotation (Placement(transformation(extent={{-58,66},{-38,86}})));
            Modelica.Blocks.Tables.CombiTable2D eta80(smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
                table=[0,100,400,700,1000,1300; 20.0,0.9155,0.9587,0.9733,0.9813,0.9866;
                  30.0,0.8937,0.9311,0.9449,0.953,0.9585; 40.0,0.8753,0.9007,0.9121,
                  0.9192,0.9242; 50.0,0.8691,0.8734,0.8755,0.8804,0.884; 60.0,0.8628,
                  0.8671,0.8679,0.8683,0.8686; 70.0,0.7415,0.8607,0.8616,0.862,0.8622;
                  80.0,0.6952,0.8544,0.8552,0.8556,0.8559])
              annotation (Placement(transformation(extent={{-58,32},{-38,52}})));
            Modelica.Blocks.Tables.CombiTable2D eta60(smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
                table=[0,100,400,700,1000,1300; 20.0,0.9349,0.9759,0.9879,0.9941,0.998;
                  30.0,0.9096,0.9471,0.9595,0.9664,0.9709; 40.0,0.8831,0.9136,0.9247,
                  0.9313,0.9357; 50.0,0.8701,0.8759,0.8838,0.8887,0.8921; 60.0,0.8634,
                  0.8666,0.8672,0.8675,0.8677; 70.0,0.8498,0.8599,0.8605,0.8608,0.861;
                  80.0,0.8488,0.8532,0.8538,0.8541,0.8543])
              annotation (Placement(transformation(extent={{-58,-6},{-38,14}})));
            Modelica.Blocks.Tables.CombiTable2D eta40(smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
                table=[0,100,400,700,1000,1300; 20.0,0.9624,0.9947,0.9985,0.9989,0.999;
                  30.0,0.9333,0.9661,0.9756,0.9803,0.9833; 40.0,0.901,0.9306,0.94,0.9451,
                  0.9485; 50.0,0.8699,0.8871,0.8946,0.8989,0.9018; 60.0,0.8626,0.8647,
                  0.8651,0.8653,0.8655; 70.0,0.8553,0.8573,0.8577,0.8579,0.8581; 80.0,
                  0.8479,0.8499,0.8503,0.8505,0.8506])
              annotation (Placement(transformation(extent={{-58,-44},{-38,-24}})));
            Modelica.Blocks.Tables.CombiTable2D eta20(smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
                table=[0,100,400,700,1000,1300; 20.0,0.9969,0.9987,0.999,0.999,0.999;
                  30.0,0.9671,0.9859,0.99,0.9921,0.9934; 40.0,0.9293,0.9498,0.9549,0.9575,
                  0.9592; 50.0,0.8831,0.9003,0.9056,0.9083,0.9101; 60.0,0.8562,0.857,
                  0.8575,0.8576,0.8577; 70.0,0.8398,0.8479,0.8481,0.8482,0.8483; 80.0,
                  0.8374,0.8384,0.8386,0.8387,0.8388])
              annotation (Placement(transformation(extent={{-58,-86},{-38,-66}})));

            Modelica.SIunits.HeatFlowRate QLossesToCompensate
            "Environment losses";
        public
            Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
            "heatPort connection to water in condensor"
              annotation (Placement(transformation(extent={{90,-10},{110,10}})));
            IDEAS.BaseClasses.Control.Hyst_NoEvent onOff(
              uLow=modulationMin,
              uHigh=modulationStart,
              y(start=0),
              enableRelease=true) "on-off, based on modulationInit"
              annotation (Placement(transformation(extent={{28,40},{48,60}})));

          equation
            assert(m_flowHx*kgps2lph >= 0 and m_flowHx*kgps2lph < 1300,
              "The mass flow rate is outside the range of the boiler (m_flow = " + String(
              m_flowHx*kgps2lph) + " l/h) but should be between 0 and 1300");
            assert(THxIn - 273.15 >= 0 and THxIn - 273.15 < 70,
              "The input temperature is outside the range of the interpolation table. Please ensure that THxIn ("
               + String(THxIn - 273.15) + "degC) is higher than 0 and lower than 70 degC");

            onOff.u = modulationInit;
            onOff.release = if noEvent(m_flowHx > 0) then 1.0 else 0.0;
            QAsked = max(0, m_flowHx*medium.cp*(TBoilerSet - THxIn));
            eta100.u1 = THxIn - 273.15;
            eta100.u2 = m_flowHx*kgps2lph;
            eta80.u1 = THxIn - 273.15;
            eta80.u2 = m_flowHx*kgps2lph;
            eta60.u1 = THxIn - 273.15;
            eta60.u2 = m_flowHx*kgps2lph;
            eta40.u1 = THxIn - 273.15;
            eta40.u2 = m_flowHx*kgps2lph;
            eta20.u1 = THxIn - 273.15;
            eta20.u2 = m_flowHx*kgps2lph;

            // all these are in kW
            etaVector[1] = 0;
            etaVector[2] = eta20.y;
            etaVector[3] = eta40.y;
            etaVector[4] = eta60.y;
            etaVector[5] = eta80.y;
            etaVector[6] = eta100.y;
            QVector = etaVector/etaNom .* modVector/100*QNom;     // in W
            QMax = QVector[6];

            modulationInit = Modelica.Math.Vectors.interpolate(
              QVector,
              modVector,
              QAsked);
            modulation = onOff.y*min(modulationInit, 100);

            // compensation of heat losses (only when the hp is operating)
            QLossesToCompensate = if noEvent(modulation > 0) then UALoss*(heatPort.T -
              TEnvironment) else 0;

            eta = Modelica.Math.Vectors.interpolate(
              modVector,
              etaVector,
              modulation);
            heatPort.Q_flow = -Modelica.Math.Vectors.interpolate(
              modVector,
              QVector,
              modulation) - QLossesToCompensate;
            PFuel = if noEvent(modulation > 0) then -heatPort.Q_flow/eta else 0;

            annotation (
              Diagram(graphics),
              Diagram(graphics),
              Documentation(info="<html>
<p><b>Description</b> </p>
<p>This&nbsp;model&nbsp;is&nbsp;based&nbsp;on&nbsp;data&nbsp;from&nbsp;a Remeha boiler. It is used in the <a href=\"modelica://IDEAS.Thermal.Components.Production.Boiler\">Boiler</a> model. </p>
<p>The&nbsp;nominal&nbsp;power&nbsp;of&nbsp;the&nbsp;original&nbsp;boiler&nbsp;is&nbsp;10.1&nbsp;kW&nbsp;at &nbsp;50/30 degC&nbsp;water&nbsp;temperatures.&nbsp;&nbsp;&nbsp;The&nbsp;efficiency&nbsp;in&nbsp;this&nbsp;point&nbsp;is&nbsp;92.2&percnt;&nbsp;on&nbsp;higher&nbsp;heating&nbsp;value.&nbsp;</p>
<p>First,&nbsp;the&nbsp;efficiency&nbsp;is&nbsp;interpolated&nbsp;for&nbsp;the&nbsp;&nbsp;return&nbsp;water&nbsp;temperature&nbsp;and&nbsp;flowrate&nbsp;at&nbsp;5&nbsp;different&nbsp;modulation&nbsp;levels.&nbsp;These&nbsp;modulation&nbsp;levels&nbsp;are&nbsp;the&nbsp;FUEL&nbsp;input&nbsp;power&nbsp;to&nbsp;the&nbsp;boiler.&nbsp;&nbsp;The&nbsp;results&nbsp;&nbsp;are&nbsp;rescaled&nbsp;to&nbsp;the&nbsp;nominal&nbsp;power&nbsp;of&nbsp;the&nbsp;modelled&nbsp;heatpump&nbsp;(with&nbsp;QNom/QNom_data)&nbsp;and&nbsp;&nbsp;stored&nbsp;in&nbsp;a&nbsp;vector,&nbsp;eta_vector.</p>
<p>Finally,&nbsp;the&nbsp;initial&nbsp;modulation&nbsp;is&nbsp;calculated&nbsp;based&nbsp;on&nbsp;the&nbsp;asked&nbsp;power&nbsp;and&nbsp;the&nbsp;max&nbsp;power&nbsp;at&nbsp;&nbsp;operating&nbsp;conditions:&nbsp;</p>
<p><ul>
<li>&nbsp;&nbsp;if&nbsp;modulation_init&nbsp;&LT;&nbsp;modulation_min,&nbsp;the&nbsp;boiler&nbsp;is&nbsp;OFF,&nbsp;modulation&nbsp;=&nbsp;0.&nbsp;&nbsp;</li>
<li>&nbsp;&nbsp;if&nbsp;modulation_init&nbsp;&GT;&nbsp;100&percnt;,&nbsp;the&nbsp;modulation&nbsp;is&nbsp;100&percnt;</li>
<li>&nbsp;&nbsp;if&nbsp;modulation_init&nbsp;between&nbsp;modulation_min&nbsp;and&nbsp;modulation_start:&nbsp;hysteresis&nbsp;for&nbsp;on/off&nbsp;cycling.</li>
</ul></p>
<p>If&nbsp;the&nbsp;boiler&nbsp;is&nbsp;on&nbsp;another&nbsp;modulation,&nbsp;interpolation&nbsp;is&nbsp;made&nbsp;to&nbsp;get&nbsp;eta&nbsp;at&nbsp;the&nbsp;real&nbsp;modulation.</p>
<p><h4>ATTENTION</h4></p>
<p>This&nbsp;model&nbsp;takes&nbsp;into&nbsp;account&nbsp;environmental&nbsp;heat&nbsp;losses&nbsp;of&nbsp;the&nbsp;boiler.&nbsp;&nbsp;In&nbsp;order&nbsp;to&nbsp;keep&nbsp;the&nbsp;same&nbsp;nominal&nbsp;eta&apos;s&nbsp;during&nbsp;operation,&nbsp;these&nbsp;heat&nbsp;losses&nbsp;are&nbsp;added&nbsp;to&nbsp;the&nbsp;computed&nbsp;power.&nbsp;&nbsp;Therefore,&nbsp;the&nbsp;heat&nbsp;losses&nbsp;are&nbsp;only&nbsp;really&nbsp;&apos;losses&apos;&nbsp;when&nbsp;the&nbsp;boiler&nbsp;is&nbsp;NOT&nbsp;operating.&nbsp;</p>
<p>The&nbsp;eta&nbsp;is&nbsp;calculated&nbsp;as&nbsp;the&nbsp;heat&nbsp;delivered&nbsp;to&nbsp;the&nbsp;heatedFluid&nbsp;divided&nbsp;by&nbsp;the&nbsp;fuel&nbsp;consumption&nbsp;PFuel.&nbsp;</p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>Based on interpolation in manufacturer data for Remeha condensing gas boiler</li>
</ol></p>
<p><h4>Model use</h4></p>
<p>This model is used in the <a href=\"modelica://IDEAS.Thermal.Components.Production.Boiler\">Boiler</a> model. If a different gas boiler is to be simulated, copy this Burner model and adapt the interpolation tables.</p>
<p><h4>Validation </h4></p>
<p>See the <a href=\"modelica://IDEAS.Thermal.Components.Production.Boiler\">Boiler</a> model. </p>
</html>",           revisions="<html>
<p><ul>
<li>2013 May, Roel De Coninck: documentation</li>
<li>2011 August, Roel De Coninck: first version</li>
</ul></p>
</html>"));
          end HeatSource_CondensingGasBurner;
        end BaseClasses;

        package Interfaces
        "Contains partial classes for the IDEAS.Thermal.Components.Production package"
        extends Modelica.Icons.InterfacesPackage;

          model PartialDynamicHeaterWithLosses
          "Partial heater model incl dynamics and environmental losses"

            import IDEAS.Thermal.Components.Production.BaseClasses.HeaterType;
            parameter HeaterType heaterType
            "Type of the heater, is used mainly for post processing";
            parameter Modelica.SIunits.Temperature TInitial=293.15
            "Initial temperature of the water and dry mass";
            parameter Modelica.SIunits.Power QNom "Nominal power";
            parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water()
            "Medium in the component";

             Modelica.SIunits.Power PFuel "Fuel consumption";
            parameter Modelica.SIunits.Time tauHeatLoss=7200
            "Time constant of environmental heat losses";
            parameter Modelica.SIunits.Mass mWater=5
            "Mass of water in the condensor";
            parameter Modelica.SIunits.HeatCapacity cDry=4800
            "Capacity of dry material lumped to condensor";

            final parameter Modelica.SIunits.ThermalConductance UALoss=(cDry + mWater*
                medium.cp)/tauHeatLoss;

            IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort
                                                      heatedFluid(
              medium=medium,
              m=mWater,
              TInitial=TInitial)
              annotation (Placement(transformation(extent={{-10,10},{10,-10}},
                  rotation=90,
                  origin={-10,0})));

            Thermal.Components.Interfaces.FlowPort_a flowPort_a(final medium=medium, h(
                  min=1140947, max=1558647)) "Fluid inlet "
              annotation (Placement(transformation(extent={{90,-48},{110,-28}}),
                  iconTransformation(extent={{90,-48},{110,-28}})));
            Thermal.Components.Interfaces.FlowPort_b flowPort_b(final medium=medium, h(
                  min=1140947, max=1558647)) "Fluid outlet"
              annotation (Placement(transformation(extent={{90,10},{110,30}})));
            Modelica.Thermal.HeatTransfer.Components.HeatCapacitor mDry(C=cDry, T(start=TInitial))
            "Lumped dry mass subject to heat exchange/accumulation"
              annotation (Placement(transformation(extent={{-10,-10},{10,10}},
                  rotation=90,
                  origin={-40,-30})));
            Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalLosses(G=UALoss)
              annotation (Placement(transformation(extent={{-10,-10},{10,10}},
                  rotation=-90,
                  origin={-30,-70})));
            Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
            "heatPort for thermal losses to environment"
              annotation (Placement(transformation(extent={{-40,-110},{-20,-90}}),
                  iconTransformation(extent={{-40,-110},{-20,-90}})));
            Modelica.Blocks.Interfaces.RealInput TSet
            "Temperature setpoint, acts as on/off signal too"
              annotation (Placement(transformation(extent={{-126,-20},{-86,20}}),
                  iconTransformation(
                  extent={{-10,-10},{10,10}},
                  rotation=-90,
                  origin={-10,120})));
            Modelica.Blocks.Interfaces.RealOutput PEl "Electrical consumption" annotation (Placement(transformation(
                    extent={{-252,10},{-232,30}}), iconTransformation(
                  extent={{-10,-10},{10,10}},
                  rotation=-90,
                  origin={-74,-100})));
          equation

              connect(flowPort_a, heatedFluid.flowPort_a)
                                                      annotation (Line(
                points={{100,-38},{-10,-38},{-10,-10}},
                color={255,0,0},
                smooth=Smooth.None));
            connect(heatedFluid.flowPort_b, flowPort_b)
                                                      annotation (Line(
                points={{-10,10},{-10,20},{100,20}},
                color={255,0,0},
                smooth=Smooth.None));
            connect(mDry.port, heatedFluid.heatPort)
                                                   annotation (Line(
                points={{-30,-30},{-30,6.12323e-016},{-20,6.12323e-016}},
                color={191,0,0},
                smooth=Smooth.None));
            connect(mDry.port, thermalLosses.port_a)
                                              annotation (Line(
                points={{-30,-30},{-30,-30},{-30,-60},{-30,-60}},
                color={191,0,0},
                smooth=Smooth.None));
            connect(thermalLosses.port_b, heatPort)
                                             annotation (Line(
                points={{-30,-80},{-30,-100}},
                color={191,0,0},
                smooth=Smooth.None));
            annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,120}},
                    preserveAspectRatio=false),
                                graphics), Icon(coordinateSystem(extent={{-100,-100},{100,
                      120}}, preserveAspectRatio=false),
                                                graphics),
              Documentation(info="<html>
<p><b>Description</b> </p>
<p>This is a partial model from which most heaters (boilers, heat pumps) will extend. This model is <u>dynamic</u> (there is a water content in the heater and a dry mass lumped to it) and it has <u>thermal losses to the environment</u>. To complete this model and turn it into a heater, a <u>heatSource</u> has to be added, specifying how much heat is injected in the heatedFluid pipe, at which efficiency, if there is a maximum power, etc. HeatSource models are grouped in <a href=\"modelica://IDEAS.Thermal.Components.Production.BaseClasses\">IDEAS.Thermal.Components.Production.BaseClasses.</a></p>
<p>The set temperature of the model is passed as a realInput.The model has a realOutput PEl for the electricity consumption.</p>
<p>See the extensions of this model for more details.</p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>the temperature of the dry mass is identical as the outlet temperature of the heater </li>
<li>no pressure drop</li>
</ol></p>
<p><h4>Model use</h4></p>
<p>Depending on the extended model, different parameters will have to be set. Common to all these extensions are the following:</p>
<p><ol>
<li>the environmental heat losses are specified by a <u>time constant</u>. Based on the water content, dry capacity and this time constant, the UA value of the heat transfer to the environment will be set</li>
<li>set the heaterType (useful in post-processing)</li>
<li>connect the set temperature to the TSet realInput connector</li>
<li>connect the flowPorts (flowPort_b is the outlet) </li>
<li>if heat losses to environment are to be considered, connect heatPort to the environment.  If this port is not connected, the dry capacity and water content will still make this a dynamic model, but without heat losses to environment,.  IN that case, the time constant is not used.</li>
</ol></p>
<p><h4>Validation </h4></p>
<p>This partial model is based on physical principles and is not validated. Extensions may be validated.</p>
<p><h4>Examples</h4></p>
<p>See the extensions, like the <a href=\"modelica://IDEAS.Thermal.Components.Production.IdealHeater\">IdealHeater</a>, the <a href=\"modelica://IDEAS.Thermal.Components.Production.Boiler\">Boiler</a> or <a href=\"modelica://IDEAS.Thermal.Components.Production.HP_AWMod_Losses\">air-water heat pump</a></p>
</html>"));
          end PartialDynamicHeaterWithLosses;
        end Interfaces;
      end Production;

      package BaseClasses "Basic components for thermal fluid flow"
        extends Modelica.Icons.BasesPackage;

        model Pipe_HeatPort "Pipe with HeatPort"

          extends Thermal.Components.Interfaces.Partials.TwoPort;
          Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
            annotation (Placement(transformation(extent={{-10,-110},{10,-90}},
                  rotation=0)));
        equation
          // energy exchange with medium
          Q_flow = heatPort.Q_flow;
          // defines heatPort's temperature
          heatPort.T = T;
          // pressure drop = none
          flowPort_a.p = flowPort_b.p;
        annotation (Documentation(info="<html>
<p><b>Description</b> </p>
<p>Model for fluid flow through a pipe, including heat exchange with the environment. A dynamic heat balance is included, based on the in- and outlet enthalpy flow, the heat flux to/from environment and the internal mass m of the fluid content in the pipe. A stationary model is obtained when m=0 </p>
<p>m.cv.der(T) = heatPort.Q_flow + ( h_flow_in - h_flow_out) </p>
<p><b>Note:</b> as can be seen from the equation, injecting heat into a pipe with zero mass flow rate causes temperature rise defined by storing heat in medium&apos;s mass. </p>
<p><h4>Assumptions and limitations</h4></p>
<p><ol>
<li>No pressure drop</li>
<li>Conservation of mass</li>
<li>Heat exchange with environment</li>
</ol></p>
<p><h4>Parameters</h4></p>
<p>The following parameters have to be set by the user</p>
<p><ol>
<li>medium</li>
<li>mass of fluid in the pipe (<b>Note:</b> Setting parameter m to zero leads to neglection of temperature transient cv.m.der(T).)</li>
<li>initial temperature of the fluid (defaults to 20&deg;C)</li>
</ol></p>
<p><h4>Validation </h4></p>
<p>No validation performed; the model is based on physical principles</p>
<p><h4>Examples</h4></p>
<p>An example in which this model is used is the <a href=\"modelica://IDEAS.Thermal.Components.Examples.HydraulicCircuit\">HydraulicCircuit</a>.</p>
</html>",         revisions="<html>
<p><ul>
<li>2013 May 23, Roel De Coninck, documentation;</li>
<li>2012 November, Roel De Coninck, first implementation. </li>
</ul></p>
</html>"),Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                    100}}), graphics={
                Text(extent={{-150,100},{150,40}}, textString="%name"),
                Polygon(
                  points={{-10,-90},{-10,-40},{0,-20},{10,-40},{10,-90},{-10,-90}},
                  lineColor={255,0,0},
                  fillPattern=FillPattern.Forward,
                  fillColor={255,255,255}),
                                      Rectangle(
                  extent={{-100,20},{100,-20}},
                  lineColor={255,255,255},
                  fillColor={85,170,255},
                  fillPattern=FillPattern.HorizontalCylinder)}),
                                    Diagram(coordinateSystem(preserveAspectRatio=
                    false, extent={{-100,-100},{100,100}}),
                                            graphics));
        end Pipe_HeatPort;

        model AbsolutePressure "Defines absolute pressure level"

          parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water()
          "medium"
            annotation(__Dymola_choicesAllMatching=true);
          parameter Modelica.SIunits.Pressure p(start=0) "Pressure ground";
          Thermal.Components.Interfaces.FlowPort_a flowPort(final medium=medium)
            annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
                  rotation=0)));
        equation
          // defining pressure
          flowPort.p = p;
          // no energy exchange; no mass flow by default
          flowPort.H_flow = 0;
        annotation (Documentation(info="<html>
<p><h4>Description</h4></p>
<p><br/>This model sets an absolute pressure at the flowPort. It takes the role of an expansion vessel in an hydraulic system. </p>
<p>The function of this model can also be compared to a grounding in electrical circuits. </p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>There is no enthalpy flowrate (nor mass flow) through the flowPort, so this model does not influence the thermal behaviour of the system. </li>
</ol></p>
<p><h4>Model use</h4></p>
<p>It is important that the absolute pressure is known in EVERY branch of an hydraulic system. All hydraulic components will simply pass the pressure through all their ports, except the pumps. There are two components that can set the pressure: the <a href=\"modelica://IDEAS.Thermal.Components.BaseClasses.Ambient\">IDEAS.Thermal.Components.BaseClasses.Ambient</a> and this one.  Therefore, the model will be balanced if one of these components determines the pressure in every section of the hydraulic circuitry which is isolated by pumps.</p>
<p>The following parameters have to be set:</p>
<p><ol>
<li>medium</li>
<li>the absolute pressure is to be specified, but the value is generally of no importance. </li>
</ol></p>
<p><h4>Validation </h4></p>
<p>None</p>
<p><h4>Example</h4></p>
<p>An example in which this model is used is the <a href=\"modelica://IDEAS.Thermal.Components.Examples.PumpePipeTester\">PumpPipeTester</a>.</p>
</html>"),         Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                    -100},{100,100}}),
                           graphics),
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                    100}}),     graphics={
                Line(
                  points={{-70,20},{-70,-20}},
                  color={0,0,127},
                  smooth=Smooth.None),
                Line(
                  points={{-70,0},{-100,0}},
                  color={0,0,127},
                  smooth=Smooth.None),
                Ellipse(extent={{-60,60},{60,-60}}, lineColor={100,100,100},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid)}));
        end AbsolutePressure;

        model Pump "Prescribed mass flow rate, no heat exchange."

          extends Thermal.Components.Interfaces.Partials.TwoPort;
          parameter Boolean useInput = false
          "Enable / disable MassFlowRate input"
            annotation(Evaluate=true);
          parameter Modelica.SIunits.MassFlowRate m_flowNom(min=0, start=1)
          "Nominal mass flowrate"
            annotation(Dialog(enable=not useVolumeFlowInput));
          parameter Modelica.SIunits.Pressure dpFix=50000
          "Fixed pressure drop, used for determining the electricity consumption";
          parameter Real etaTot = 0.8 "Fixed total pump efficiency";
          Modelica.SIunits.Power PEl "Electricity consumption";
          Modelica.Blocks.Interfaces.RealInput m_flowSet(start = 0, min = 0, max = 1) = m_flow/m_flowNom if useInput
            annotation (Placement(transformation(
                origin={0,100},
                extent={{-10,-10},{10,10}},
                rotation=270)));
      protected
          Modelica.SIunits.MassFlowRate m_flow;

        equation
          if not useInput then
            m_flow = m_flowNom;
          end if;

          Q_flow = 0;
          flowPort_a.m_flow = m_flow;
          PEl = m_flow / medium.rho * dpFix / etaTot;
          annotation (Documentation(info="<html>
<p><b>Description</b> </p>
<p>Basic pump model without heat exchange. This model sets the mass flow rate, either as a constant or based on an input. The thermal equations are identical to the <a href=\"modelica://IDEAS.Thermal.Components.BaseClasses.Pipe\">Pipe</a> model.</p>
<p>If an input is used (<code>useInput&nbsp;=&nbsp;true)</code>, <code>m_flowSet</code> is supposed to be a real value, and the flowrate is then <code>m_flowSet * m_flowNom. m_flowSet </code>is logically between 0 and 1, but any value is possible, as shown in the provided Example.</p>
<p>The model calculates the electricity consumption of the pump in a very simplified way: a fixed pressure drop and an efficiency are given as parameters, and the electricity consumption is computed as:</p>
<pre>PEl&nbsp;=&nbsp;m_flow&nbsp;/&nbsp;medium.rho&nbsp;*&nbsp;dpFix&nbsp;/&nbsp;etaTot;</pre>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>This model does not specify a relation between pressure and flowrate, the flowrate is IMPOSED</li>
<li>If the water content of the pump, m, is zero, there are no thermal dynamics. </li>
<li>The electricity consumption is computed based on a FIXED efficiency and FIXED pressure drop AS PARAMETERS</li>
<li>The inefficiency of the pump does NOT lead to an enthalpy increase of the outlet flow.</li>
</ol></p>
<p><h4>Model use</h4></p>
<p><ol>
<li>Decide if the pump will be controlled through an input or if the flowrate is a constant</li>
<li>Set medium and water content of the pump</li>
<li>Specify the parameters for computing the electricity consumption</li>
</ol></p>
<p><h4>Validation </h4></p>
<p>None</p>
<p><h4>Example </h4></p>
<p>An example in which this model is used is the <a href=\"modelica://IDEAS.Thermal.Components.Examples.HydraulicCircuit\">HydraulicCircuit</a>.</p>
</html>",         revisions="<html>
<p><ul>
<li>2013, Roel De Coninck, documentation</li>
<li>2012, Ruben Baetens, changed graphics</li>
<li>2010, Roel De Coninck, First version</li>
</ul></p>
</html>"),     Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                    100}}),      graphics={
                Ellipse(
                  extent={{-60,60},{60,-60}},
                  lineColor={135,135,135},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Text(
                  extent={{-40,20},{0,-20}},
                  lineColor={0,0,0},
                  textString="V"),
                Line(
                  points={{-100,0},{-60,0}},
                  color={0,128,255},
                  smooth=Smooth.None),
                Line(
                  points={{100,0},{60,0}},
                  color={0,128,255},
                  smooth=Smooth.None),
                Line(
                  points={{0,0},{0,80}},
                  color={0,0,127},
                  smooth=Smooth.None),
                Line(
                  points={{-40,80},{40,80}},
                  color={0,0,127},
                  smooth=Smooth.None),
                Polygon(
                  points={{-38,46},{60,0},{60,0},{-38,-46},{-38,46}},
                  lineColor={135,135,135},
                  fillColor={135,135,135},
                  fillPattern=FillPattern.Solid)}),
            Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                    {100,100}}),
                            graphics));
        end Pump;
      annotation (Documentation(info="<html>
</html>",     revisions="<HTML>
  <ul>
  <li> v1.00 2005/02/01 Anton Haumer<br>
       first stable official release</li>
  <li> v1.20 Beta 2005/02/18 Anton Haumer<br>
       introduced geodetic height in Components.Pipes<br>
       <i>new models: Components.Valve</i></li>
  <li> v1.30 Beta 2005/06/02 Anton Haumer<br>
       friction losses are fed to medium</li>
  </ul>
</HTML>
"),     Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                  100}}), graphics));
      end BaseClasses;

      package Examples
      "Examples that demonstrate the use of the models from IDEAS.Thermal.Components"
        extends Modelica.Icons.ExamplesPackage;

        model Boiler_validation "Validation model for the boiler"

          extends Modelica.Icons.Example;

          Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(medium=
                Data.Media.Water(), p=200000)
            annotation (Placement(transformation(extent={{-38,-32},{-18,-12}})));
          Thermal.Components.BaseClasses.Pump pump(
            medium=Data.Media.Water(),
            useInput=true,
            m=par.m_pump,
            TInitial=par.TIni,
            m_flowNom=par.mFlowNom,
            m_flow(start=par.mFlowStart),
            dpFix=par.dpFix,
            etaTot=par.etaTot)
            annotation (Placement(transformation(extent={{10,-36},{-10,-56}})));
          IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort pipe(
            medium=Data.Media.Water(),
            m=par.m_pipe,
            TInitial=par.TIni)
                             annotation (Placement(transformation(extent={{-10,18},{10,-2}})));
          IDEAS.Thermal.Components.Production.Boiler heater(
            medium=Data.Media.Water(),
            TInitial=par.TIni,
            QNom=par.QNom,
            tauHeatLoss=par.tau_heatLoss,
            mWater=par.mWater,
            cDry=par.cDry)
                       annotation (Placement(transformation(extent={{-70,-16},{-50,4}})));
          Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=par.TFix)
            annotation (Placement(transformation(extent={{-86,-48},{-72,-34}})));

          Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TReturn
            annotation (Placement(transformation(extent={{38,24},{18,44}})));
          Modelica.Blocks.Sources.Sine sine(
            amplitude=par.ampl_sine,
            freqHz=par.freqHz_sine,
            offset=par.offset_sine,
            startTime=par.startTime_sine)
            annotation (Placement(transformation(extent={{90,24},{70,44}})));
          Modelica.Blocks.Sources.SawTooth saw(
            amplitude=par.ampl_saw,
            period=par.period_saw,
            offset=par.offset_saw,
            startTime=par.startTime_saw)
            annotation (Placement(transformation(extent={{-30,-90},{-10,-70}})));
          Modelica.Blocks.Sources.RealExpression realExpression(y=par.TSet)
            annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
          boiler_validation par
            annotation (Placement(transformation(extent={{-36,62},{-16,82}})));

          Modelica.SIunits.Temperature TBoiler_in;
          Modelica.SIunits.Temperature TBoiler_out;
        equation
          TBoiler_in = heater.heatedFluid.T_a;
          TBoiler_out = heater.heatedFluid.T_b;
          connect(heater.heatPort, fixedTemperature.port)
                                                      annotation (Line(
              points={{-63,-16},{-62,-16},{-62,-41},{-72,-41}},
              color={191,0,0},
              smooth=Smooth.None));
          connect(TReturn.port, pipe.heatPort)                    annotation (Line(
              points={{18,34},{0,34},{0,18}},
              color={191,0,0},
              smooth=Smooth.None));
          connect(sine.y, TReturn.T) annotation (Line(
              points={{69,34},{40,34}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(heater.flowPort_b, pipe.flowPort_a) annotation (Line(
              points={{-50,-5.09091},{-50,8},{-10,8}},
              color={0,0,255},
              smooth=Smooth.None));
          connect(pipe.flowPort_b, pump.flowPort_a)        annotation (Line(
              points={{10,8},{48,8},{48,-46},{10,-46}},
              color={0,0,255},
              smooth=Smooth.None));
          connect(pump.flowPort_b, heater.flowPort_a)        annotation (Line(
              points={{-10,-46},{-50,-46},{-50,-10.3636}},
              color={0,0,255},
              smooth=Smooth.None));
          connect(heater.flowPort_a, absolutePressure.flowPort) annotation (Line(
              points={{-50,-10.3636},{-46,-10.3636},{-46,-10},{-44,-10},{-44,
                -22},{-38,-22}},
              color={0,0,255},
              smooth=Smooth.None));

          connect(saw.y, pump.m_flowSet) annotation (Line(
              points={{-9,-80},{0,-80},{0,-56}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(realExpression.y, heater.TSet) annotation (Line(
              points={{-69,20},{-61,20},{-61,4}},
              color={0,0,127},
              smooth=Smooth.None));
          annotation (
            Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                    100}}), graphics),
            experiment(StopTime=40000),
            __Dymola_experimentSetupOutput,
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}})),
            Commands(file="Scripts/Tester_Boiler.mos" "TestModel"),
            Documentation(info="<html>
<p>Model used to validate the <a href=\"modelica://IDEAS.Thermal.Components.Production.Boiler\">IDEAS.Thermal.Components.Production.Boiler</a>. With a fixed set point, the boiler receives different mass flow rates. </p>
</html>"));
        end Boiler_validation;

        record boiler_validation
          extends Modelica.Icons.Record;

          // T Boundary
          parameter Real TSet = 273.15 + 60;
          parameter Real TFix = 273.15 + 20;
          parameter Real TIni = 273.15 + 20;

          // heater
          parameter Real QNom = 5000;
          parameter Real tau_heatLoss = 3600;
          parameter Real mWater = 10;
          parameter Real cDry = 10000;

          // Saw
          parameter Real ampl_saw = 0.9998;
          parameter Real period_saw = 20000;
          parameter Real  offset_saw = 0.0001;
          parameter Real startTime_saw = 1000;

          // pump
          parameter Real m_pump = 0;
          parameter Real mFlowNom = 120/3600;
          parameter Real mFlowStart = 0.0001;
          parameter Real dpFix = 0;
          parameter Real etaTot = 0.8;

          //pipe
          parameter Real m_pipe = 5;

          //sine
          parameter Real ampl_sine = 20;
          parameter Real freqHz_sine = 1/5000;
          parameter Real offset_sine = 273.15 + 30;
          parameter Real startTime_sine = 20000;

        end boiler_validation;
      annotation (Documentation(info="<html>
<p>Examples and testers for all main hydraulic thermal components.  Specific examples of higher level models are provided in the respective packages.</p>
</html>",     revisions="<html>
<p><ul>
<li>2013 May, Roel De Coninck, largely restructured version including renaming and documentation</li>
<li>2010, Roel De Coninck, first version</li>
</ul></p>
</html>"),
        Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                  100}}), graphics));
      end Examples;

      package Interfaces "Connectors and partial models"
        extends Modelica.Icons.InterfacesPackage;

        connector FlowPort "Connector flow port"

          extends Modelica.Thermal.FluidHeatFlow.Interfaces.FlowPort;
        annotation (Documentation(info="<HTML>
Basic definition of the connector.<br>
<b>Variables:</b>
<ul>
<li>Pressure p</li>
<li>flow MassFlowRate m_flow</li>
<li>Specific Enthalpy h</li>
<li>flow EnthaplyFlowRate H_flow</li>
</ul>
If ports with different media are connected, the simulation is asserted due to the check of parameter.
</HTML>"));
        end FlowPort;

        connector FlowPort_a "Filled flow port (used upstream)"

          extends FlowPort;
        annotation (Documentation(info="<HTML>
Same as FlowPort, but icon allows to differentiate direction of flow.
</HTML>"),Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                    100}}), graphics={Rectangle(
                  extent={{-100,100},{100,-100}},
                  lineColor={0,0,255},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid), Ellipse(
                  extent={{-98,98},{98,-98}},
                  lineColor={0,0,255},
                  fillColor={0,0,255},
                  fillPattern=FillPattern.Solid)}),
                                                 Diagram(coordinateSystem(
                  preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                graphics={
                Rectangle(
                  extent={{-50,50},{50,-50}},
                  lineColor={255,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{-48,48},{48,-48}},
                  lineColor={0,0,255},
                  fillColor={0,0,255},
                  fillPattern=FillPattern.Solid),
                Text(
                  extent={{-100,110},{100,50}},
                  lineColor={0,0,255},
                  textString="%name")}));
        end FlowPort_a;

        connector FlowPort_b "Hollow flow port (used downstream)"

          extends FlowPort;
        annotation (Documentation(info="<HTML>
Same as FlowPort, but icon allows to differentiate direction of flow.
</HTML>"),Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                    100}}), graphics={Rectangle(
                  extent={{-100,100},{100,-100}},
                  lineColor={0,0,255},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid), Ellipse(
                  extent={{-98,98},{98,-98}},
                  lineColor={0,0,255},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid)}),
                                                 Diagram(coordinateSystem(
                  preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                graphics={
                Rectangle(
                  extent={{-50,50},{50,-50}},
                  lineColor={255,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Ellipse(extent={{-48,48},{48,-48}}, lineColor={0,0,255}),
                Text(
                  extent={{-100,110},{100,50}},
                  lineColor={0,0,255},
                  textString="%name")}));
        end FlowPort_b;

        package Partials "Partial models"
          extends Modelica.Icons.Package;

          partial model TwoPort "Partial model of two port"

            parameter Thermal.Data.Interfaces.Medium medium=Data.Interfaces.Medium()
            "Medium in the component"
              annotation(choicesAllMatching=true);
            parameter Modelica.SIunits.Mass m(start=1) "Mass of medium";
            // I remove this parameter completely because it can lead to wrong models!!!
            // See note in evernote of RDC
            //parameter Real tapT(final min=0, final max=1)=1
            //  "Defines temperature of heatPort between inlet and outlet temperature";
            parameter Modelica.SIunits.Temperature TInitial=293.15
            "Initial temperature of all Temperature states";

            Modelica.SIunits.HeatFlowRate Q_flow(start=0)
            "Heat exchange with ambient";
            Modelica.SIunits.Temperature T(start=TInitial)
            "Outlet temperature of medium";
            Modelica.SIunits.Temperature T_a(start=TInitial)=flowPort_a.h/
              medium.cp "Temperature at flowPort_a";
            Modelica.SIunits.Temperature T_b(start=TInitial)=flowPort_b.h/
              medium.cp "Temperature at flowPort_b";

            Modelica.SIunits.TemperatureDifference dT(start=0)=if noEvent(
              flowPort_a.m_flow >= 0) then T - T_a else T_b - T
            "Outlet temperature minus inlet temperature";

            Modelica.SIunits.SpecificEnthalpy h=medium.cp*T
            "Medium's specific enthalpy";

        public
            FlowPort_a flowPort_a(final medium=medium, h(min=1140947, max=1558647))
              annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
                    rotation=0)));
            FlowPort_b flowPort_b(final medium=medium, h(min=1140947, max=1558647))
              annotation (Placement(transformation(extent={{90,-10},{110,10}},
                    rotation=0)));
          equation
            // mass balance
            flowPort_a.m_flow + flowPort_b.m_flow = 0;

            // no equation about pressure drop here in order to allow pumps to extend from this partial

            // energy balance
            if m>Modelica.Constants.small then
              flowPort_a.H_flow + flowPort_b.H_flow + Q_flow = m*medium.cv*der(T);
            else
              flowPort_a.H_flow + flowPort_b.H_flow + Q_flow = 0;
            end if;
            // massflow a->b mixing rule at a, energy flow at b defined by medium's temperature
            // massflow b->a mixing rule at b, energy flow at a defined by medium's temperature
            flowPort_a.H_flow = semiLinear(flowPort_a.m_flow,flowPort_a.h,h);
            flowPort_b.H_flow = semiLinear(flowPort_b.m_flow,flowPort_b.h,h);
          annotation (Documentation(info="<html>
<p><b>General description</b> </p>
<p><h5>Goal</h5></p>
<p>Partial model with two flowPorts.</p>
<p><h5>Description </h5></p>
<p>This model is deviated from Modelica.Thermal.FluidHeatFlow.Interfaces.Partials.TwoPort</p>
<p>Possible heat exchange with the ambient is defined by Q_flow; setting this = 0 means no energy exchange.</p>
<p>Setting parameter m (mass of medium within component) to zero leads to neglection of temperature transient cv*m*der(T).</p>
<p>Mass flow can go in both directions, the temperature T is mapped to the outlet temperature. Mixing rule is applied. </p>
<p><h5>Assumptions and limitations </h5></p>
<p><ol>
<li>This model makes assumption of mass balance: outlet flowrate = inlet flowrate</li>
<li>This model includes the energy balance equation as a first order differential equation,<b> unless m=0</b></li>
</ol></p>
<p><h4>Parameters</h4></p>
<p>Partial model, see extensions for implementation details.</p>
<p><h4>Validation </h4></p>
<p>Based on physical principles, no validation performed.</p>
</html>"));
          end TwoPort;
        annotation (Documentation(info="<HTML>
This package contains partial models, defining in a very compact way the basic thermodynamic equations used by the different components.<br>
<dl>
  <dt><b>Main Authors:</b></dt>
  <dd>
  <p>
  <a href=\"http://www.haumer.at/\">Anton Haumer</a><br>
  Technical Consulting &amp; Electrical Engineering<br>
  A-3423 St.Andrae-Woerdern, Austria<br>
  email: <a href=\"mailto:a.haumer@haumer.at\">a.haumer@haumer.at</a>
</p>
  <p>
  Dr. Christian Kral<br>
  <a href=\"http://www.ait.ac.at/\">Austrian Institute of Technology, AIT</a><br>
  Giefinggasse 2<br>
  A-1210 Vienna, Austria
</p>
  </dd>
</dl>
<p>
Copyright &copy; 1998-2010, Modelica Association, Anton Haumer and Austrian Institute of Technology, AIT.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</HTML>",    revisions="<HTML>
  <ul>
  <li> v1.00 2005/02/01 Anton Haumer<br>
       first stable official release</li>
  <li> v1.10 2005/02/15 Anton Haumer<br>
       moved Partials into Interfaces</li>
  <li> v1.11 2005/02/18 Anton Haumer<br>
       corrected usage of cv and cp</li>
  <li> v1.30 Beta 2005/06/02 Anton Haumer<br>
       friction losses are fed to medium</li>
  <li> v1.31 Beta 2005/06/04 Anton Haumer<br>
       searching solution for problems @ m_flow=0</li>
  <li> v1.33 Beta 2005/06/07 Anton Haumer<br>
       corrected usage of simpleFlow</li>
  <li> v1.43 Beta 2005/06/20 Anton Haumer<br>
       Test of mixing / semiLinear</li>
  <li> v1.50 2005/09/07 Anton Haumer<br>
       semiLinear works fine<br>
       removed test-version of semiLinear</li>
  <li> v1.60 2007/01/23 Anton Haumer<br>
       new parameter tapT defining Temperature of heatPort</li>
  </ul>
</HTML>
"));
        end Partials;
      annotation (Documentation(info="<HTML>
This package contains connectors and partial models:
<ul>
<li>FlowPort: basic definition of the connector.</li>
<li>FlowPort_a &amp; FlowPort_b: same as FlowPort with different icons to differentiate direction of flow</li>
<li>package Partials (defining basic thermodynamic equations)</li>
</ul>
<dl>
  <dt><b>Main Authors:</b></dt>
  <dd>
  <p>
  <a href=\"http://www.haumer.at/\">Anton Haumer</a><br>
  Technical Consulting &amp; Electrical Engineering<br>
  A-3423 St.Andrae-Woerdern, Austria<br>
  email: <a href=\"mailto:a.haumer@haumer.at\">a.haumer@haumer.at</a>
</p>
  <p>
  Dr. Christian Kral<br>
  <a href=\"http://www.ait.ac.at/\">Austrian Institute of Technology, AIT</a><br>
  Giefinggasse 2<br>
  A-1210 Vienna, Austria
</p>
  </dd>
</dl>
<p>
Copyright &copy; 1998-2010, Modelica Association, Anton Haumer and Austrian Institute of Technology, AIT.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</HTML>",     revisions="<HTML>
  <ul>
  <li> v1.00 2005/02/01 Anton Haumer<br>
       first stable official release</li>
  <li> v1.10 2005/02/15 Anton Haumer<br>
       moved Partials into Interfaces</li>
  <li> v1.11 2005/02/18 Anton Haumer<br>
       corrected usage of cv and cp</li>
  <li> v1.30 Beta 2005/06/02 Anton Haumer<br>
       friction losses are fed to medium</li>
  <li> v1.33 Beta 2005/06/07 Anton Haumer<br>
       corrected usage of simpleFlow</li>
  <li> v1.43 Beta 2005/06/20 Anton Haumer<br>
       Test of mixing / semiLinear</li>
  <li> v1.50 2005/09/07 Anton Haumer<br>
       semiLinear works fine</li>
  </ul>
</HTML>
"),     Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                  100}}), graphics));
      end Interfaces;
    end Components;

    package Data
        extends Modelica.Icons.MaterialPropertiesPackage;

      package Media
          extends Modelica.Icons.MaterialPropertiesPackage;

        record Water "Medium properties of water"
        extends Thermal.Data.Interfaces.Medium(
            rho=995.6,
            cp=4177,
            cv=4177,
            lamda=0.615,
            nue=0.8E-6);
          annotation (Documentation(info="<html>
Medium: properties of water
</html>"));
        end Water;
      end Media;

      package Interfaces
        extends Modelica.Icons.InterfacesPackage;

        record Medium "Record containing media properties"

          extends Modelica.Icons.MaterialProperty;

          parameter Modelica.SIunits.Density rho = 1 "Density";
          parameter Modelica.SIunits.SpecificHeatCapacity cp = 1
          "Specific heat capacity at constant pressure";
          parameter Modelica.SIunits.SpecificHeatCapacity cv = 1
          "Specific heat capacity at constant volume";
          parameter Modelica.SIunits.ThermalConductivity lamda = 1
          "Thermal conductivity";
          parameter Modelica.SIunits.KinematicViscosity nue = 1
          "Kinematic viscosity";
          annotation (Documentation(info="<html>
Record containing (constant) medium properties.
</html>"));
        end Medium;
      end Interfaces;
    end Data;
  end Thermal;

  package BaseClasses "Base classes for IDEAS"
    extends Modelica.Icons.BasesPackage;

    package Control "General stuff"
      extends Modelica.Icons.Package;

      block Hyst_NoEvent "Hysteresis without events, with Real in- and output"

        extends Modelica.Blocks.Interfaces.partialBooleanBlockIcon;
        parameter Real uLow;
        parameter Real uHigh;
        parameter Boolean enableRelease = false
        "if true, an additional RealInput will be available for releasing the controller";

        Modelica.Blocks.Interfaces.RealInput u
          annotation (Placement(transformation(extent={{-128,-20},{-88,20}})));
        Modelica.Blocks.Interfaces.RealOutput y(start=0)
          annotation (Placement(transformation(extent={{96,-10},{116,10}})));

        output Real error(start=0);

        Modelica.Blocks.Interfaces.RealInput release(start=0) = rel if enableRelease
        "if < 0.5, the controller is OFF"
          annotation (Placement(transformation(extent={{-128,60},{-88,100}})));
    protected
        Real rel
        "release, either 1 ,either from RealInput release if enableRelease is true";

      equation
        if not enableRelease then
          rel = 1;
        end if;

        if noEvent(u >= uHigh and rel > 0.5) then
          y =  1;
        elseif noEvent(u <= uLow) then
          y =  0;
        elseif noEvent(u > uLow) and noEvent(y > 0.5) and noEvent(rel > 0.5) then
          y =  1;
        else
          y =  0;
        end if;

        /* 
  We have experienced errors with the hysteresis without events in case the tolerance of the 
  integrator is too low: some unlogical behaviour.
  To check correct behaviour, it was possible to define the error as below. 
  The u-delay(u,1) is there because der(u) causes problems in case u is not continuous...
  */

        error = if noEvent(u < uHigh and u > uLow and u - delay(u,1) < 0 and y < 0.5) then 1.0
           else 0.0;
        annotation (
          Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                  100}}),     graphics={
              Polygon(
                points={{-65,89},{-73,67},{-57,67},{-65,89}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-65,67},{-65,-81}}, color={192,192,192}),
              Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
              Polygon(
                points={{90,-70},{68,-62},{68,-78},{90,-70}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{70,-80},{94,-100}},
                lineColor={160,160,164},
                textString="u"),
              Text(
                extent={{-65,93},{-12,75}},
                lineColor={160,160,164},
                textString="y"),
              Line(
                points={{-80,-70},{30,-70}},
                color={0,0,0},
                thickness=0.5),
              Line(
                points={{-50,10},{80,10}},
                color={0,0,0},
                thickness=0.5),
              Line(
                points={{-50,10},{-50,-70}},
                color={0,0,0},
                thickness=0.5),
              Line(
                points={{30,10},{30,-70}},
                color={0,0,0},
                thickness=0.5),
              Line(
                points={{-10,-65},{0,-70},{-10,-75}},
                color={0,0,0},
                thickness=0.5),
              Line(
                points={{-10,15},{-20,10},{-10,5}},
                color={0,0,0},
                thickness=0.5),
              Line(
                points={{-55,-20},{-50,-30},{-44,-20}},
                color={0,0,0},
                thickness=0.5),
              Line(
                points={{25,-30},{30,-19},{35,-30}},
                color={0,0,0},
                thickness=0.5),
              Text(
                extent={{-99,2},{-70,18}},
                lineColor={160,160,164},
                textString="true"),
              Text(
                extent={{-98,-87},{-66,-73}},
                lineColor={160,160,164},
                textString="false"),
              Text(
                extent={{19,-87},{44,-70}},
                lineColor={0,0,0},
                textString="uHigh"),
              Text(
                extent={{-63,-88},{-38,-71}},
                lineColor={0,0,0},
                textString="uLow"),
              Line(points={{-69,10},{-60,10}}, color={160,160,164})}),
          Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                  100}}), graphics={
              Polygon(
                points={{-80,90},{-88,68},{-72,68},{-80,90}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-80,68},{-80,-29}}, color={192,192,192}),
              Polygon(
                points={{92,-29},{70,-21},{70,-37},{92,-29}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-79,-29},{84,-29}}, color={192,192,192}),
              Line(points={{-79,-29},{41,-29}}, color={0,0,0}),
              Line(points={{-15,-21},{1,-29},{-15,-36}}, color={0,0,0}),
              Line(points={{41,51},{41,-29}}, color={0,0,0}),
              Line(points={{33,3},{41,22},{50,3}}, color={0,0,0}),
              Line(points={{-49,51},{81,51}}, color={0,0,0}),
              Line(points={{-4,59},{-19,51},{-4,43}}, color={0,0,0}),
              Line(points={{-59,29},{-49,11},{-39,29}}, color={0,0,0}),
              Line(points={{-49,51},{-49,-29}}, color={0,0,0}),
              Text(
                extent={{-92,-49},{-9,-92}},
                lineColor={192,192,192},
                textString="%uLow"),
              Text(
                extent={{2,-49},{91,-92}},
                lineColor={192,192,192},
                textString="%uHigh"),
              Rectangle(extent={{-91,-49},{-8,-92}}, lineColor={192,192,192}),
              Line(points={{-49,-29},{-49,-49}}, color={192,192,192}),
              Rectangle(extent={{2,-49},{91,-92}}, lineColor={192,192,192}),
              Line(points={{41,-29},{41,-49}}, color={192,192,192})}),
          Documentation(info="<HTML>
<p>
This block transforms a <b>Real</b> input signal into a <b>Boolean</b>
output signal:
</p>
<ul>
<li> When the output was <b>false</b> and the input becomes
     <b>greater</b> than parameter <b>uHigh</b>, the output
     switches to <b>true</b>.</li>
<li> When the output was <b>true</b> and the input becomes
     <b>less</b> than parameter <b>uLow</b>, the output
     switches to <b>false</b>.</li>
</ul>
<p>
The start value of the output is defined via parameter
<b>pre_y_start</b> (= value of pre(y) at initial time).
The default value of this parameter is <b>false</b>.
</p>
</HTML>
"));
      end Hyst_NoEvent;
    end Control;
  end BaseClasses;
  annotation (uses(Modelica(version="3.2"),
    Annex60(version="0.1"),
    Buildings(version="1.4")),                             Icon(graphics),
  version="2",
  conversion(noneFromVersion="", noneFromVersion="1"),
    Documentation(info="<html>
<p>Licensed by KU Leuven and 3E under the Modelica License 2 </p>
<p>Copyright &copy; 2013-2023, KU Leuven and 3E. </p>
<p>&nbsp; </p>
<p><i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>;</i>  <i>it can be redistributed and/or modified under the terms of the Modelica License 2. </i></p>
<p><i>For license conditions (including the disclaimer of warranty) see <a href=\"UrlBlockedError.aspx\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"https://www.modelica.org/licenses/ModelicaLicense2\">https://www.modelica.org/licenses/ModelicaLicense2</a>.</i> </p>
</html>"));
end IDEAS;
model IDEAS_Thermal_Components_Examples_Boiler_validation
 extends IDEAS.Thermal.Components.Examples.Boiler_validation;
  annotation(experiment(StopTime=40000),uses(IDEAS(version="2")));
end IDEAS_Thermal_Components_Examples_Boiler_validation;
