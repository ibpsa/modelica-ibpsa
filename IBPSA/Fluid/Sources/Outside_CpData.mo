within IBPSA.Fluid.Sources;
model Outside_CpData
  "Boundary that takes weather data as an input and computes wind pressure for low-rise buildings"
  extends IBPSA.Fluid.Sources.BaseClasses.Outside;

  parameter Real table[:,:]=[0,0.4; 45,0.1; 90,-0.3; 135,-0.35; 180,-0.2; 225,-0.35; 270,-0.3; 315,0.1; 360,0.4] "Cp at different angles of attack";
  parameter Modelica.SIunits.Angle azi "Surface azimuth (South:0, West:pi/2)"  annotation (choicesAllMatching=true);
  parameter Real Cs=1 "Wind speed modifier";

  Modelica.SIunits.Angle alpha "Wind incidence angle (0: normal to wall)";
  Real CpAct(min=0, final unit="1") "Actual wind pressure coefficient";

  Modelica.SIunits.Pressure pWin(displayUnit="Pa")
    "Change in pressure due to wind force";

  Modelica.Blocks.Interfaces.RealOutput pTot(min=0, nominal=1E5, final unit="Pa")
    "Sum of atmospheric pressure and wind pressure";

  Modelica.Blocks.Interfaces.RealInput pWea(min=0, nominal=1E5, final unit="Pa")
    "Pressure from weather bus";
protected
  Modelica.SIunits.Angle surOut = azi-Modelica.Constants.pi   "Angle of surface that is used to compute angle of attack of wind";
  Modelica.Blocks.Interfaces.RealInput vWin(final unit="m/s")    "Wind speed from weather bus";
  Modelica.Blocks.Interfaces.RealInput winDir(final unit="rad",displayUnit="deg") "Wind direction from weather bus";

equation
  alpha = winDir-surOut;

  CpAct =IBPSA.Airflow.Multizone.BaseClasses.windPressureProfile(u=alpha, table=table[:, :]);                                                                                                                                                      //input is in degrees

  pWin = Cs*0.5*CpAct*medium.d*vWin*vWin;
  pTot = pWea + pWin;

  connect(weaBus.winDir, winDir);
  connect(weaBus.winSpe, vWin);
  connect(weaBus.pAtm, pWea);
  connect(p_in_internal, pTot);
  connect(weaBus.TDryBul, T_in_internal);
  annotation (defaultComponentName="out",
    Documentation(info="<html>
<p>The wind direction is computed relative to the azimuth of this surface, which is equal to the parameter <span style=\"font-family: Courier New;\">azi</span>. The surface azimuth is defined in <a href=\"modelica://IDEAS.Types.Azimuth\">IDEAS.Types.Azimuth</a>. For example, if an exterior wall is South oriented, i.e., its outside-facing surface is towards South, use <span style=\"font-family: Courier New;\">IDEAS.Types.Azimuth.S</span>. </p>
<p>The pressure <i>p</i> at the port <span style=\"font-family: Courier New;\">ports</span> is computed as </p>
<p align=\"center\"><i>p = p<sub>w</sub> + C<sub>p,act</sub> C<sub>s</sub>1 &frasl; 2 v<sup>2</sup> &rho;, </i></p>
<p>where <i>p<sub>w</i></sub> is the atmospheric pressure from the weather bus, <i>v</i> is the wind speed from the weather bus, and <i>&rho;</i> is the fluid density. </p>
<p><br>The wind pressure coefficient (C<sub>p,act</sub>) is a function af the wind incidence angle. The relation is defined by a cubic hermite interpolation of the users table input. Typical table values can be obtained from the &quot;AIVC guide to energy efficient ventilation&quot;, appendix 2 (1996).</p>
<p>The default table is appendix 2, table 2.2, face 1. The wind speed modifier (C<sub>s</sub>) can be used to incorporate the effect of the surroundings on the local wind speed. </p>
<p><b>References</b></p>
<ul>
<li>M. W. Liddament, 1996, <i>A guide to energy efficient ventilation</i>. AIVC Annex V. </li>
</ul>
</html>",
revisions="<html>
<ul>
<li>June 26, 2020, by Klaas De Jonge (UGent):<br/>
First implementation</li>
</ul>
</html>
"), Icon(graphics={Text(
          visible=use_Cp_in,
          extent={{-140,92},{-92,62}},
          lineColor={0,0,255},
          textString="C_p"),
          Text(
          visible=use_C_in,
          extent={{-154,-28},{-102,-62}},
          lineColor={0,0,255},
          textString="C"),
        Line(points={{-56,54},{-56,-44},{52,-44}}, color={255,255,255}),
        Line(points={{-56,16},{-50,16},{-44,12},{-38,-2},{-28,-24},{-20,-40},
              {-12,-42},{-6,-36},{0,-34},{6,-36},{12,-42},{20,-40},{28,-14},{
              36,6},{42,12},{50,14}},
                            color={255,255,255},
          smooth=Smooth.Bezier),
        Text(
          extent={{4,-44},{76,-58}},
          lineColor={255,255,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.None,
          textString="Alpha"),
        Text(
          extent={{-54,66},{2,22}},
          lineColor={255,255,255},
          textString="Cp")}));
end Outside_CpData;
