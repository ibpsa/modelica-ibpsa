within Annex60.Experimental.ThermalZones.BaseClasses.EqAirTemp;
partial model partialEqAirTemp
  "partial model for equivalent air temperature as defined in VDI 6007-1"

parameter Real aExt=0.6 "Coefficient of absorption of exterior walls (outdoor)";
parameter Modelica.SIunits.Emissivity eExt=0.9
    "Coefficient of emission of exterior walls (outdoor)";
parameter Integer n=4 "Number of orientations (without ground)";
parameter Real wfWall[n]={0.5,0.2,0.2,0.1} "Weight factors of the walls";
parameter Real wfWin[n]={0,0,0,0} "Weight factors of the windows";
parameter Real wfGround=0 "Weight factor of the ground (0 if not considered)";
parameter Modelica.SIunits.Temp_K TGround=284.15
    "Temperature of the ground in contact with floor plate";
parameter Boolean withLongwave=true
    "If longwave radiation exchange is considered" annotation(choices(checkBox = true));
parameter Real unitVec[n]=ones(n);

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a TEqAir
    "equivalent air temperature" annotation (Placement(transformation(extent={{
            98,-56},{118,-36}}), iconTransformation(extent={{78,-76},{118,-36}})));
  Modelica.Blocks.Interfaces.RealInput sunblind[n]
    "opening factor of sunblinds for each direction ( 0 - open to 1 - closed)"   annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-10,100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,80})));
  Modelica.SIunits.Temp_K TEqWall[n] "equivalent wall temperature";
  Modelica.SIunits.Temp_K TEqWin[n] "equivalent window temperature";
  Modelica.SIunits.TemperatureDifference TEqLW[n]
    "equivalent long wave temperature";
  Modelica.SIunits.TemperatureDifference TEqSW[n]
    "equivalent short wave temperature";

  Modelica.SIunits.CoefficientOfHeatTransfer alphaRad=5.0
    "coefficient of heat transfer for linearized radiation";

public
  Modelica.Blocks.Interfaces.RealInput HSol[n](
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") "Solar radiation per unit area" annotation (Placement(
        transformation(extent={{-120,40},{-80,80}}), iconTransformation(extent={
            {-100,-20},{-60,20}})));
  Modelica.Blocks.Interfaces.RealInput TBlaSky(
    final quantity="ThermodynamicTemperature",
    displayUnit="degC",
    final unit="K") "Black-body sky temperature" annotation (Placement(
        transformation(extent={{-120,-10},{-80,30}}),iconTransformation(extent={
            {-100,-20},{-60,20}})));
  Modelica.Blocks.Interfaces.RealInput TDryBul(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Dry bulb temperature" annotation (Placement(
        transformation(extent={{-120,-44},{-80,-4}}),  iconTransformation(
          extent={{-100,-20},{-60,20}})));
initial equation
  assert(noEvent(abs(sum(wfWall) + sum(wfWin) + wfGround) > 0.1), "The sum of the weightfactors (walls,windows and ground) in eqAirTemp is close to 0. If there are no walls, windows and ground at all, this might be irrelevant.", level=AssertionLevel.warning);
annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),  Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                      graphics={
        Rectangle(
          extent={{-70,70},{78,-76}},
          lineColor={170,213,255},
          lineThickness=1,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={170,213,255}),
        Rectangle(
          extent={{-70,70},{78,0}},
          lineColor={170,213,255},
          lineThickness=1,
          fillPattern=FillPattern.Solid,
          fillColor={170,213,255}),
        Rectangle(
          extent={{38,46},{78,-76}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.HorizontalCylinder),
        Polygon(
          points={{79,46},{21,46},{79,70},{79,70},{79,46}},
          smooth=Smooth.None,
          fillColor={236,99,92},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-70,70},{-16,18}},
          lineColor={255,221,0},
          fillColor={255,225,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,-76},{78,-90}},
          lineColor={0,127,0},
          fillColor={0,127,0},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-70,-82},{78,-90}},
          lineColor={0,127,0},
          fillColor={0,127,0},
          fillPattern=FillPattern.Forward),
        Text(
          extent={{-70,-92},{76,-128}},
          lineColor={0,0,255},
          lineThickness=0.5,
          fillColor={236,99,92},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Rectangle(
          extent={{38,46},{78,-14}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{52,28},{80,-12}},
          lineColor={0,0,0},
          fillColor={230,230,230},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{78,32},{84,-18}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{52,8},{68,8},{78,8}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{72,28},{72,-12}},
          color={0,0,0},
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p>EqAirTemp is a component to compute the so called &QUOT;equivalent outdoor air temperature&QUOT;. Basically, this includes a correction for the longwave radiation for windows and walls and absorption of shortwave radiation only for walls.</p>
<p>To the air temperature is added (or substracted) a term for longwave radiation and one term for shortwave radiation. As the shortwave radiation is taken into account only for the walls and the windows can be equipped with a shading, the equal temperatures are computed separately for the windows and for the walls. Due to the different beams in different directions, the temperatures are also computed separately for each direction. You need one weightfactor per direction and wall or window, e.g. 4 directions means 8 weightfactors (4 windows, 4 walls). Additionally, one weightfactor for the ground (for the ground temperature) . </p>
<p>First, a temperature of the earth (not the ground temperature!) and temperature of the sky are computed. The difference is taken into account for the longwave radiance term. </p>
<p>For the windows, the shading input is considered on the longwave term. </p>
<p>For the walls, the shortwave radiance term is computed with the beam of the radiance input. </p>
<p>The n temperatures of the walls, the n temperatures of the windows and the ground temperature are weighted with the weightfactors and summed up.</p>
<h4>Main equations</h4>
<p>The concept is described in VDI 6007. All equations can be found in VDI 6007. </p>
<h4>Assumption and limitations</h4>
<ul>
<li>The computed temperature is the temperature near the wall surface. The radiant and convective heat transfer is considered in the model. The next component connected to the heat port should be the description of the heat conductance through the wall. </li>
<li>The heat transfer through the radiance is considered by an alpha. It is computed and is somewhere around 5. In cases of exorbitant high radiance values, this alpha could be not as accurate as a real T^4 equation.</li>
</ul>
<h4>Parameters</h4>
<p>Inputs: weather data, radiance (beam) by the radiance input and longwave sky radiation, longwave terrestric radiation and air temperature by the Real WeatherData input. There is the possibility to link a <a href=\"AixLib.Building.Components.Weather.Sunblind\">Sunblind</a> by the sunblindsig input. This takes the changes in radiation on the windows through a closed shading into account. </p>
<p>Parameters: </p>
<ul>
<li>Weightfactors: The different equivalent temperatures for the different directions (due to shortwave radiance and the ground) are weighted and summed up with the weightfactors. See VDI 6007 for more information about the weightfactors (equation: U_i*A_i/sum(U*A)). As the equivalent temperature is a weighted temperature for all surfaces and it was originally written for building zones, the temperature of the ground under the thermal zone can be considered (weightfactorgound &GT; 0). The sum of all weightfactors should be 1. </li>
<li>Additionally, you need the coefficient of heat transfer and the coefficient of absorption on the outer side of the walls and windows for all directions (weighted scalars) . The coefficient of absorption is different to the emissivity due to the spectrum of the sunlight (0.6 might be a good choice). </li>
</ul>
<h4>References</h4>
<ul>
<li>German Association of Engineers: Guideline VDI 6007-1, March 2012: Calculation of transient thermal response of rooms and buildings - Modelling of rooms.</li>
<li>Lauster, M.; Teichmann, J.; Fuchs, M.; Streblow, R.; Mueller, D. (2014): Low order thermal network models for dynamic simulations of buildings on city district scale. In: Building and Environment 73, p. 223&ndash;231. DOI: 10.1016/j.buildenv.2013.12.016.</li>
</ul>
</html>",
        revisions="<html>
<ul>
<li><i>October 2014,&nbsp;</i> by Peter Remmen:<br>Implemented.</li>
<li><i>September 2015,&nbsp;</i> by Moritz Lauster:<br>Got rid of cardinality and used assert for warnings.</li>
</ul>
</html>"));
end partialEqAirTemp;
