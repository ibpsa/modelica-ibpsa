within IDEAS.Buildings.Components;
model Zone "thermal building zone"

  extends IDEAS.Buildings.Components.Interfaces.StateZone;

  parameter Modelica.SIunits.Volume V "Total zone air volume";
  parameter Real n50 = 0.6
    "n50 value cfr airtightness, i.e. the ACH at a pressure diffence of 50 Pa";
  parameter Real corrCV = 5 "Multiplication factor for the zone air capacity";
  parameter Modelica.SIunits.Temperature TOpStart = 297.15;

  parameter Boolean linear=true;

  final parameter Modelica.SIunits.Power QNom = 1012*1.204*V/3600*n50/20*(273.15
       + 21 - sim.city.Tdes)
    "Design heat losses at reference outdoor temperature";

  Modelica.SIunits.Temperature TAir = conDistr.TCon;
  Modelica.SIunits.Temperature TStar = radDistr.TRad;

protected
  IDEAS.Buildings.Components.BaseClasses.ZoneLwGainDistribution radDistr(nSurf=
        nSurf) "distribution of radiative internal gains" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-54,-44})));
  IDEAS.Buildings.Components.BaseClasses.MixedAir conDistr(
    nSurf=nSurf,
    V=V,
    corrCV=corrCV) "convective part of the zone"
    annotation (Placement(transformation(extent={{-2,10},{-22,30}})));
  IDEAS.Buildings.Components.BaseClasses.AirLeakage vent(n50=n50, V=V)
    "zone air leakage" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,42})));
  IDEAS.Buildings.Components.BaseClasses.ZoneLwDistribution radDistrLw(nSurf=
        nSurf, linear=linear) "internal longwave radiative heat exchange"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-54,-10})));
  Modelica.Blocks.Math.Sum sum(
    nin=2,
    k={0.5,0.5},
    y(start=TOpStart))
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
      points={{-104,30},{-82,30},{-82,-44},{-64,-44}},
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
      points={{-64,-14},{-78,-14},{-78,60},{-104,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radDistr.area, area) annotation (Line(
      points={{-64,-40},{-78,-40},{-78,60},{-104,60}},
      color={0,0,127},
      smooth=Smooth.None));

  annotation (Icon(graphics), Documentation(info="<html>
<p><h4><font color=\"#008000\">General description</font></h4></p>
<p><h5>Goal</h5></p>
<p>Also the thermal response of a zone can be divided into a convective, longwave radiative and shortwave radiative process influencing both thermal comfort in the depicted zone as well as the response of adjacent wall structures.</p>
<p><h5>Description</h5></p>
<p>The air within the zone is modeled based on the assumption that it is well-stirred, i.e. it is characterized by a single uniform air temperature. This is practically accomplished with the mixing caused by the air distribution system. The convective gains and the resulting change in air temperature T_{a} of a single thermal zone can be modeled as a thermal circuit. The resulting heat balance for the air node can be described as c_{a}.V_{a}.dT_{a}/dt = som(Q_{ia}) + sum(h_{ci}.A_{si}.(T_{a}-T_{si})) + sum(m_{az}.(h_{a}-h_{az})) + m_{ae}(h_{a}-h_{ae}) + m_{sys}(h_{a}-h_{sys}) wherefore h_{a} is the specific air enthalpy and where T_{a} is the air temperature of the zone, c_{a} is the specific heat capacity of air at constant pressure, V_{a} is the zone air volume, Q_{a} is a convective internal load, R_{si} is the convective surface resistance of surface s_{i}, A_{si} is the area of surface s_{i}, T_{si} the surface temperature of surface s_{i}, m_{az} is the mass flow rate between zones, m_{ae} is the mass flow rate between the exterior by natural infiltrationa and m_{sys} is the mass flow rate provided by the ventilation system. </p>
<p>Infiltration and ventilation systems provide air to the zones, undesirably or to meet heating or cooling loads. The thermal energy provided to the zone by this air change rate can be formulated from the difference between the supply air enthalpy and the enthalpy of the air leaving the zone <img src=\"modelica://IDEAS/Images/equations/equation-jiSQ22c0.png\" alt=\"h_a\"/>. It is assumed that the zone supply air mass flow rate is exactly equal to the sum of the air flow rates leaving the zone, and all air streams exit the zone at the zone mean air temperature. The moisture dependence of the air enthalpy is neglected.</p>
<p>A multiplier for the zone capacitance f_{ca} is included. A f_{ca} equaling unity represents just the capacitance of the air volume in the specified zone. This multiplier can be greater than unity if the zone air capacitance needs to be increased for stability of the simulation. This multiplier increases the capacitance of the air volume by increasing the zone volume and can be done for numerical reasons or to account for the additional capacitances in the zone to see the effect on the dynamics of the simulation. This multiplier is constant throughout the simulation and is set to 5.0 if the value is not defined <a href=\"IDEAS.Buildings.UsersGuide.References\">[Masy 2008]</a>.</p>
<p>The exchange of longwave radiation in a zone has been previously described in the building component models and further considering the heat balance of the interior surface. Here, an expression based on <i>radiant interchange configuration factors</i> or <i>view factors</i> is avoided based on a delta-star transformation and by definition of a <i>radiant star temperature</i> T_{rs}. Literature <a href=\"IDEAS.Buildings.UsersGuide.References\">[Liesen 1997]</a> shows that the overall model is not significantly sensitive to this assumption. ThisT_{rs} can be derived from the law of energy conservation in the radiant star node as sum(Q_{si,rs}) must equal zero. Long wave radiation from internal sources are dealt with by including them in the heat balance of the radiant star node resulting in a diffuse distribution of the radiative source.</p>
<p>Transmitted shortwave solar radiation is distributed over all surfaces in the zone in a prescribed scale. This scale is an input value which may be dependent on the shape of the zone and the location of the windows, but literature <a href=\"IDEAS.Buildings.UsersGuide.References\">[Liesen 1997]</a> shows that the overall model is not significantly sensitive to this assumption.</p>
<p><h4><font color=\"#008000\">Validation </font></h4></p>
<p>By means of the <code>BESTEST.mo</code> examples in the <code>Validation.mo</code> package.</p>
</html>"));
end Zone;
