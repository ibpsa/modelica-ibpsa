within IDEAS.Buildings.Components;
model Zone "thermal building zone"

extends IDEAS.Buildings.Components.Interfaces.StateZone;

parameter Modelica.SIunits.Volume V "Total zone air volume";
parameter Real n50 = 0.6
    "n50 value cfr airtightness, i.e. the ACH at a pressure diffence of 50 Pa";
parameter Real corrCV = 5 "Multiplication factor for the zone air capacity";
parameter SI.Temperature TOpStart = 291.15;

//to be moved from the zone definition to ventilation models ?
protected
parameter Boolean recuperation = false;
parameter Modelica.SIunits.Efficiency RecupEff = 0.84
    "efficientie on heat recuperation of ventilation air";

//not necessary ?
protected
parameter Modelica.SIunits.Length height = 2.7 "zone height";
parameter Modelica.SIunits.Temperature Tset = 294.15 "setpoint temperature";
parameter Real ACH = 0.0 "ventilation rate";

protected
  IDEAS.Buildings.Components.BaseClasses.ZoneLwGainDistribution radDistr(nSurf=nSurf)
    "distribution of radiative internal gains"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-54,-44})));
  IDEAS.Buildings.Components.BaseClasses.MixedAir conDistr(
    nSurf=nSurf,
    V=V,
    corrCV=corrCV) "convective part of the zone"
    annotation (Placement(transformation(extent={{-2,10},{-22,30}})));
  IDEAS.Buildings.Components.BaseClasses.Ventilation vent(
    n50=n50,
    V=V,
    ACH=ACH,
    RecupEff=RecupEff,
    recuperation=recuperation) "zone ventilation"                                                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,42})));
  IDEAS.Buildings.Components.BaseClasses.ZoneLwDistribution radDistrLw(nSurf=
        nSurf) "internal longwave radiative heat exchange"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-54,-10})));

  Modelica.Blocks.Math.Sum sum(nin=2, k={0.5,0.5}, y(start=TOpStart))
    annotation (Placement(transformation(extent={{0,-66},{12,-54}})));
equation
  connect(surfRad, radDistr.radSurfTot) annotation (Line(
      points={{-100,-60},{-74,-60},{-74,-26},{-54,-26},{-54,-34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radDistr.iSolDir, iSolDir) annotation (Line(
      points={{-58,-54},{-58,-80},{-20,-80},{-20,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radDistr.iSolDif, iSolDif) annotation (Line(
      points={{-54,-54},{-54,-76},{20,-76},{20,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(surfCon, conDistr.conSurf) annotation (Line(
      points={{-100,-30},{-30,-30},{-30,20},{-22,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conDistr.conGain, gainCon) annotation (Line(
      points={{-2,20},{49,20},{49,-30},{100,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radDistr.radGain, gainRad) annotation (Line(
      points={{-50.2,-54},{-50,-54},{-50,-72},{80,-72},{80,-60},{100,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vent.port_a, conDistr.conGain) annotation (Line(
      points={{10,32},{10,20},{-2,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(surfRad, radDistrLw.port_a) annotation (Line(
      points={{-100,-60},{-74,-60},{-74,-26},{-54,-26},{-54,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(epsLw, radDistr.epsLw) annotation (Line(
      points={{-104,30},{-104,30},{-82,30},{-82,-44},{-64,-44}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(epsSw, radDistr.epsSw) annotation (Line(
      points={{-104,0},{-86,0},{-86,-48},{-64,-48}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));

  connect(epsLw, radDistrLw.epsLw) annotation (Line(
      points={{-104,30},{-82,30},{-82,-10},{-64,-10}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));

  connect(sum.y, TSensor) annotation (Line(
      points={{12.6,-60},{59.3,-60},{59.3,0},{106,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radDistr.TRad, sum.u[1]) annotation (Line(
      points={{-44,-44},{-22,-44},{-22,-60.6},{-1.2,-60.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conDistr.TCon, sum.u[2]) annotation (Line(
      points={{-12,10},{-12,-62},{-1.2,-62},{-1.2,-59.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radDistrLw.A, area) annotation (Line(
      points={{-64,-14},{-72,-14},{-72,-14},{-78,-14},{-78,60},{-104,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radDistr.area, area) annotation (Line(
      points={{-64,-40},{-78,-40},{-78,60},{-104,60}},
      color={0,0,127},
      smooth=Smooth.None));

  annotation (Icon(graphics), Documentation(info="<html>
<p>Also the thermal response of a zone can be divided into a convective, longwave radiative and shortwave radiative process influencing both thermal comfort in the depicted zone as well as the response of adjacent wall structures. </p>
<p><h4><font color=\"#008000\">Convective.</font></h4></p>
<p>The air within the zone is modeled based on the assumption that it is well-stirred, i.e. it is characterized by a single uniform air temperature. This is practically accomplished with the mixing caused by the air distribution system. The convective gains and the resulting change in air temperature <img src=\"modelica://IDEAS/Images/equations/equation-ps2Eq199.png\" alt=\"T_a\"/> of a single thermal zone can be modeled as a thermal circuit. The resulting heat balance for the air node can be described as</p>
<p align=\"center\"><img src=\"modelica://IDEAS/Images/equations/equation-5E7Q41vV.png\" alt=\"dT_a/dt*c_a*V_a=sum_i*Q_ia+sum_i*h_sci*A_si*(T_a-T_si)+sum_i*m_az*(h_a-h_az)+m_ae*(h_a-h_ae)+m_asys*(h_a-h_asys)\"/></p>
<p>wherefore <img src=\"modelica://IDEAS/Images/equations/equation-jiSQ22c0.png\" alt=\"h_a\"/> is the specific air enthalpy and where <img src=\"modelica://IDEAS/Images/equations/equation-WIlQpAg5.png\" alt=\"T_a\"/> is the air temperature of the zone, <img src=\"modelica://IDEAS/Images/equations/equation-h7Dz77UJ.png\" alt=\"c_a\"/> is the specific heat capacity of air at constant pressure, <img src=\"modelica://IDEAS/Images/equations/equation-x4LHc8Qp.png\" alt=\"V_a\"/> is the zone air volume, <img src=\"modelica://IDEAS/Images/equations/equation-7maZgvq7.png\" alt=\"Q_a\"/> is a convective internal load, <img src=\"modelica://IDEAS/Images/equations/equation-NZR0rJFG.png\" alt=\"R_si\"/> is the convective surface resistance of surface <img src=\"modelica://IDEAS/Images/equations/equation-bvc5hZ2Y.png\" alt=\"s_i\"/>,<img src=\"modelica://IDEAS/Images/equations/equation-ujUu9oii.png\" alt=\"A_si\"/> is the area of surface<img src=\"modelica://IDEAS/Images/equations/equation-PRmDSqgy.png\" alt=\"s_i\"/>, <img src=\"modelica://IDEAS/Images/equations/equation-LwXKbxRC.png\" alt=\"T_si\"/> the surface temperature of surface <img src=\"modelica://IDEAS/Images/equations/equation-cTp9P38I.png\" alt=\"s_i\"/>, <img src=\"modelica://IDEAS/Images/equations/equation-94Yf3BLu.png\" alt=\"m_az\"/> is the mass flow rate between zones, <img src=\"modelica://IDEAS/Images/equations/equation-Cwfjkj5R.png\" alt=\"m_ae\"/> is the mass flow rate between the exterior by natural infiltration,<img src=\"modelica://IDEAS/Images/equations/equation-ZgcYnSGu.png\" alt=\"m_asys\"/> is the mass flow rate provided by the ventilation system, <img src=\"modelica://IDEAS/Images/equations/equation-pCXdHoAS.png\" alt=\"theta_a\"/> is the air temperature in degrees Celsius, <img src=\"modelica://IDEAS/Images/equations/equation-QSo9JTGT.png\" alt=\"chi_a\"/> is the air humidity ratio, <img src=\"modelica://IDEAS/Images/equations/equation-zntTkmwk.png\" alt=\"c_w\"/> is specific heat of water vapor at constant pressure and <img src=\"modelica://IDEAS/Images/equations/equation-ZjHIP8wZ.png\" alt=\"h_wev\"/> is evaporation heat of water at 0 degrees Celsius. </p>
<p>Infiltration and ventilation systems provide air to the zones, undesirably or to meet heating or cooling loads. The thermal energy provided to the zone by this air change rate can be formulated from the difference between the supply air enthalpy and the enthalpy of the air leaving the zone <img src=\"modelica://IDEAS/Images/equations/equation-jiSQ22c0.png\" alt=\"h_a\"/>. It is assumed that the zone supply air mass flow rate is exactly equal to the sum of the air flow rates leaving the zone, and all air streams exit the zone at the zone mean air temperature. The moisture dependence of the air enthalpy is neglected.</p>
<p>A multiplier for the zone capacitance <img src=\"modelica://IDEAS/Images/equations/equation-BsmTOKms.png\" alt=\"f_ca\"/> is included. A <img src=\"modelica://IDEAS/Images/equations/equation-BsmTOKms.png\" alt=\"f_ca\"/> equaling unity represents just the capacitance of the air volume in the specified zone. This multiplier can be greater than unity if the zone air capacitance needs to be increased for stability of the simulation. This multiplier increases the capacitance of the air volume by increasing the zone volume and can be done for numerical reasons or to account for the additional capacitances in the zone to see the effect on the dynamics of the simulation. This multiplier is constant throughout the simulation and is set to 5.0 if the value is not defined <a href=\"IDEAS.Buildings.UsersGuide.References\">[Masy 2008]</a>.</p>
<p><h4><font color=\"#008000\">Longwave radiation.</font></h4></p>
<p>The exchange of longwave radiation in a zone has been previously described in the building component models and further considering the heat balance of the interior surface. Here, an expression based on <i>radiant interchange configuration factors</i> or <i>view factors</i> is avoided based on a delta-star transformation and by definition of a <i>radiant star temperature</i> <img src=\"modelica://IDEAS/Images/equations/equation-rE4hQkmG.png\" alt=\"T_rs\"/>. Literature <a href=\"IDEAS.Buildings.UsersGuide.References\">[Liesen 1997]</a> shows that the overall model is not significantly sensitive to this assumption. This <img src=\"modelica://IDEAS/Images/equations/equation-rE4hQkmG.png\" alt=\"T_rs\"/> can be derived from the law of energy conservation in the radiant star node as <img src=\"modelica://IDEAS/Images/equations/equation-iH8dRZqh.png\" alt=\"sum_i*Q_sirs\"/> must equal zero. Long wave radiation from internal sources are dealt with by including them in the heat balance of the radiant star node resulting in a diffuse distribution of the radiative source.</p>
<p><h4><font color=\"#008000\">Shortwave radiation.</font></h4></p>
<p>Transmitted shortwave solar radiation is distributed over all surfaces in the zone in a prescribed scale. This scale is an input value which may be dependent on the shape of the zone and the location of the windows, but literature <a href=\"IDEAS.Buildings.UsersGuide.References\">[Liesen 1997]</a> shows that the overall model is not significantly sensitive to this assumption.</p>
</html>"));
end Zone;
