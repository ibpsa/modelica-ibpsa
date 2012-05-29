within IDEAS.Thermal.Components;
package Examples "Examples that demonstrate the use of the models from IDEAS.Thermal.Components"
  extends Modelica.Icons.ExamplesPackage;


annotation (Documentation(info="<HTML>
This package contains test examples:
<ul>
<li>1.SimpleCooling: heat is dissipated through a media flow</li>
<li>2.ParallelCooling: two heat sources dissipate through merged media flows</li>
<li>3.IndirectCooling: heat is disspated through two cooling cycles</li>
<li>4.PumpAndValve: demonstrates usage of an IdealPump and a Valve</li>
<li>5.PumpDropOut: demonstrates shutdown and restart of a pump</li>
<li>6.ParallelPumpDropOut: demonstrates shutdown and restart of a pump in a parallel circuit</li>
<li>7.OneMass: cooling of a mass (thermal capacity) by a coolant flow</li>
<li>8.TwoMass: cooling of two masses (thermal capacities) by two parallel coolant flows</li>
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
  Dr.Christian Kral<br>
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
</HTML>",
        revisions="<HTML>
  <ul>
  <li> v1.00 2005/02/01 Anton Haumer<br>
       first stable official release</li>
  <li> v1.31 Beta 2005/06/04 Anton Haumer<br>
       <i>new example: PumpAndValve</i><br>
       <i>new example: PumpDropOut</i></li>
  <li> v1.42 Beta 2005/06/18 Anton Haumer<br>
       <i>new test example: ParallelPumpDropOut</i></li>
  <li> v1.43 Beta 2005/06/20 Anton Haumer<br>
       Test of mixing / semiLinear<br>
       <i>new test example: OneMass</i><br>
       <i>new test example: TwoMass</i></li>
  </ul>
</HTML>
"),
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics));
end Examples;
