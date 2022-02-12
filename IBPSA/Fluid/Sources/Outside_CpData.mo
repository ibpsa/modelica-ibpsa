within IBPSA.Fluid.Sources;
model Outside_CpData
  "Boundary that takes weather data as an input and computes the wind pressure from a given wind pressure profile"
  extends IBPSA.Fluid.Sources.BaseClasses.Outside;

  parameter Modelica.Units.SI.Angle CpincAng[:](displayUnit="deg")      "Wind incidence angles relative to the surface normal (normal=0), first and last point must by 0 and 2 pi(=360 deg)";
  parameter Real Cp[:](unit="1")      "Cp values at the corresponding CpincAang";
//  parameter Real table[:,2]
//  "Cp at different angles of attack. First column are Cp values, second column are wind angles of attack in degrees";
  parameter Modelica.Units.SI.Angle azi "Surface azimuth (South:0, West:pi/2)"  annotation (choicesAllMatching=true);
  parameter Real Cs=1 "Wind speed modifier";

  Modelica.Units.SI.Pressure pWin(displayUnit="Pa") = Cs*0.5*CpAct*d*vWin*vWin
   "Change in pressure due to wind force";

  // fixme: Should this just use incAng=incAng?
  Real CpAct(
    min=0,
    final unit="1") = IBPSA.Airflow.Multizone.BaseClasses.windPressureProfile(
    incAng=winSurAng,
    xd=incAngExt,
    yd=CpExt,
    d=deri) "Actual wind pressure coefficient";

  // fixme: This is not clear: the original table (now called incAng) are already the wind incidence angle, so why is the surface outward normal used?
  Modelica.Units.SI.Angle winSurAng = winDir-surOut "Wind incidence angle (0: normal to wall)";


  //Extend table to account for 360° profile and generate spline derivatives at support points
//  parameter Real tableRad[:,:]=[Modelica.Constants.D2R*table[:, 1],table[:, 2]]
//    "Table in rad for units of incidence angle";
//  parameter Real prevPoint[1,2] = [tableRad[size(table, 1)-1, 1] - (2*Modelica.Constants.pi),tableRad [size(table, 1)-1, 2]]
//    "Previous point for interpolation";
//  parameter Real nextPoint[1,2] = [tableRad[2, 1] + (2*Modelica.Constants.pi),tableRad [2, 2]]
//    "Next point for interpolation";
//
//  parameter Real tableExt[:,:]=[prevPoint; tableRad; nextPoint]
//    "Extended table";

protected
  final parameter Integer n = size(CpincAng, 1) "Number of data points provided by user";
  final parameter Modelica.Units.SI.Angle incAngExt[:](each displayUnit="deg")=
    cat(1, {CpincAng[n-1]- (2*Modelica.Constants.pi)}, CpincAng, {CpincAng[2] + (2*Modelica.Constants.pi)})
    "Extended number of incidence angles";
  final parameter Real CpExt[n+2]=cat(1, {Cp[n-1]}, Cp, {Cp[2]})
    "Extended number of Cp values";

  final parameter Real[n+2] deri=
      IBPSA.Utilities.Math.Functions.splineDerivatives(
      x=incAngExt,
      y=CpExt,
      ensureMonotonicity=false) "Derivatives for table interpolation";

  Modelica.Blocks.Interfaces.RealInput pWea(min=0, nominal=1E5, final unit="Pa")
   "Pressure from weather bus";

  Modelica.Blocks.Interfaces.RealOutput pTot(min=0, nominal=1E5, final unit="Pa") = pWea + pWin "Sum of atmospheric pressure and wind pressure";
  Modelica.Units.SI.Density d = Medium.density(
    Medium.setState_pTX(p_in_internal, T_in_internal, X_in_internal))
    "Air density";

  // fixme: This is not clear: the original table (now called incAng) are already the wind incidence angle, so why is the surface outward normal used?
  Modelica.Units.SI.Angle surOut = azi-Modelica.Constants.pi   "Angle of surface that is used to compute angle of attack of wind";
  Modelica.Blocks.Interfaces.RealInput vWin(final unit="m/s")    "Wind speed from weather bus";
  Modelica.Blocks.Interfaces.RealInput winDir(final unit="rad",displayUnit="deg") "Wind direction from weather bus";
initial equation
  assert(size(CpincAng, 1) == size(Cp, 1),
    "Size of parameters are size(CpincAng, 1) = " + String(size(CpincAng, 1)) +
    " and size(Cp, 1) = " + String(size(Cp, 1)) + ". They must be equal.");

  assert(abs(CpincAng[1]) < 1E-8 and abs(CpincAng[end]-2*Modelica.Constants.pi) < 1E-8,
    "First and last point in the table must be 0 and 360", level = AssertionLevel.error);

equation
  connect(weaBus.winDir, winDir);
  connect(weaBus.winSpe, vWin);
  connect(weaBus.pAtm, pWea);
  connect(p_in_internal, pTot);
  connect(weaBus.TDryBul, T_in_internal);

  annotation (defaultComponentName="out",
    Documentation(info="<html>
<p>
This model describes boundary conditions for
pressure, enthalpy, and species concentration that can be obtained
from weather data. The model is identical to
<a href=\"modelica://IBPSA.Fluid.Sources.Outside\">
IBPSA.Fluid.Sources.Outside</a>,
except that it adds the wind pressure to the
pressure at the fluid ports <code>ports</code>.
</p>
<p>
The pressure <i>p</i> at the fluid ports is computed as:
</p>
<p align=\"center\" style=\"font-style:italic;\">
p = p<sub>w</sub> + C<sub>p,act</sub> C<sub>s</sub>1 &frasl; 2 v<sup>2</sup> &rho;,
</p>
<p>
where <i>p<sub>w</sub></i> is the atmospheric pressure from the weather bus,
<i>v</i> is the wind speed from the weather bus, and
<i>&rho;</i> is the fluid density.
</p>
<p>
The wind pressure coefficient <i>C<sub>p,act</sub></i> is a function af the surface wind incidence
angle and are defined relative to the surface azimuth (normal to the surface is 0).
The wind incidence angle <code>incAng</code> is computed from the wind direction obtained from the weatherfile 
with the surface azimuth <code>azi</code> as the base of the angle.
The relation between the wind pressure coefficient <i>C<sub>p,act</sub></i> and the incidence angle <code>incAng</code>
is defined by a cubic hermite interpolation of the users table input.
Typical table values can be obtained from the &quot;AIVC guide to energy efficient ventilation&quot;,
appendix 2 (1996). The default table is appendix 2, table 2.2, face 1.
</p>
<p>
The wind speed modifier <i>C<sub>s</sub></i> can be used to incorporate the effect of the surroundings on the local wind speed.
</p>
<h4>Definition of angles</h4>
<p>
The wind incidence angle and surface azimuths are defined as follows:
The wind indicience angle is obtained directly from the weather data bus <code>weaBus.winDir</code>.
This variable contains the data from the weather data file that was read, such as a TMY3 file.
In accordance to TMY3, the data is as shown in the table below.
</p>
<p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<caption>Value of <code>winDir</code> if the wind blows from different directions.</caption>
<tr><td></td>  <td style=\"text-align: center\">Wind from North:<br/>0 <br/> 0&deg;</td>  <td></td> </tr>
<tr><td style=\"text-align: center\">Wind from West:<br/>3&pi;/2 <br/> 270&deg;</td>  <td></td>  <td style=\"text-align: center\">Wind from East:<br/>&pi;/2 <br/> 90&deg;</td></tr>
<tr><td></td>  <td style=\"text-align: center\">Wind from South:<br/>&pi; <br/> 180&deg;</td>  <td></td></tr>
</table>
</p>
<p>
For the surface azimuth <code>azi</code>, the specification from
<a href=\"modelica://IBPSA.Types.Azimuth\">IBPSA.Types.Azimuth</a> is
used, which is as shown in the table below.
</p>

<p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<caption>Value of <code>azi</code> if the exterior wall faces in the different directions.</caption>
<tr><td></td>  <td style=\"text-align: center\">Wall facing north:<br> &pi; <br/> 180&deg;</td>  <td></td> </tr>
<tr><td style=\"text-align: center\">Wall facing West:<br/> &pi;/2 <br/> 90&deg;</td>  <td></td>  <td style=\"text-align: center\">Wall facing east:<br/> 3&pi;/2 <br/> 270&deg;</td></tr>
<tr><td></td>  <td style=\"text-align: center\">Wall facing South:<br/>0; <br/> 0&deg;</td>  <td></td></tr>
</table>
</p>

<p>
fixme: Not clear what these angles are. They seem to be not consistent with TMY3 and IBPSA.Types.Azimuth.
Is that the variable <code>winSurAng</code>?
</p>
<p align=\"center\"><img alt=\"image\" src=\"modelica://IBPSA/Resources/Images/Fluid/Sources/Cp_data.png\"/> </p>

<h4>Related model</h4>
<p>
This model differs from <a href=\"modelica://IBPSA.Fluid.Sources.Outside_CpLowRise\">
IBPSA.Fluid.Sources.Outside_CpLowRise</a> by the calculation of the wind pressure coefficient
<i>C<sub>p,act</sub></i>.
The wind pressure coefficient is defined by a user-defined table instead of a generalized equation
such that it can be used for all building sizes and situations, for shielded buildings,
and for buildings with non-rectangular shapes.
</p>
<p>
<b>References</b>
</p>
<ul>
<li>M. W. Liddament, 1996, <i>A guide to energy efficient ventilation</i>. AIVC Annex V. </li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
February 2, 2022, by Michael Wetter:<br/>
Revised implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1436\">IBPSA, #1436</a>.
</li>
<li>
Apr 6, 2021, by Klaas De Jonge:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={Text(
          visible=use_Cp_in,
          extent={{-140,92},{-92,62}},
          textColor={0,0,255},
          textString="C_p"),
          Text(
          visible=use_C_in,
          extent={{-154,-28},{-102,-62}},
          textColor={0,0,255},
          textString="C"),
        Line(points={{-56,54},{-56,-44},{52,-44}}, color={255,255,255}),
        Line(points={{-56,16},{-50,16},{-44,12},{-38,-2},{-28,-24},{-20,-40},
              {-12,-42},{-6,-36},{0,-34},{6,-36},{12,-42},{20,-40},{28,-14},{
              36,6},{42,12},{50,14}},
                            color={255,255,255},
          smooth=Smooth.Bezier),
        Text(
          extent={{-54,66},{2,22}},
          textColor={255,255,255},
          textString="Cp")}));
end Outside_CpData;
