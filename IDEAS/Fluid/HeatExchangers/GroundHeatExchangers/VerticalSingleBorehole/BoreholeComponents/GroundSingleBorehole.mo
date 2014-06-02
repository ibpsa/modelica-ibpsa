within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.VerticalSingleBorehole.BoreholeComponents;
model GroundSingleBorehole "behaviour of the ground for a single borehole"
  // Dieter Patteeuw 13mar2012
  // vertically 3 layers: top (in contact with climate), main part (most of the borehole) and bottom (gets the geothermal flux)
  // radial mesh based on Eskilson

  parameter Modelica.SIunits.Length bhDepth "depth of the borehole";
  parameter Modelica.SIunits.Radius bhRadius "radius of the borehole";
  parameter Modelica.SIunits.Temperature bhTinitial
    "initial temperature of brine and ground";
  parameter Modelica.SIunits.SpecificHeatCapacity groundCp
    "J/kgK specific heat capacity of the ground";
  parameter Modelica.SIunits.ThermalConductivity groundK
    "W/mK thermal conductivity of the ground";
  parameter Modelica.SIunits.Density groundRho "kg/m3 density of the ground";
  parameter Integer typeMesh=1 "Which type of mesh is to be used";
  parameter Modelica.SIunits.HeatFlux geothermalFlux "flux from the earth core";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a fillingGroundMain
    "interface between main part of the borehole and the ground" annotation (
      Placement(transformation(extent={{-110,0},{-90,20}}), iconTransformation(
          extent={{-110,-22},{-86,2}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a topBorehole
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature undisturbedGround(T=
        bhTinitial) "ground far away at constant temperature"
    annotation (Placement(transformation(extent={{80,-8},{60,12}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a fillingGroundTop
    "interface between the top of the borehole and the top of the ground"
    annotation (Placement(transformation(extent={{-110,34},{-90,54}}),
        iconTransformation(extent={{-110,34},{-90,54}})));

protected
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow geothermalFluxShort[
    numberLayers](Q_flow=shortTermFlux) "fixed flux from the earth core"
    annotation (Placement(transformation(extent={{-92,-94},{-72,-74}})));

  CylindricalLayer upperLayer[numberLayers](
    each groundCpCyl=groundCp,
    each groundKCyl=groundK,
    each tempInitial=bhTinitial,
    outerRadiusCyl=rOuterVec,
    innerRadiusCyl=rInnerVec[:, 1],
    each heigthCyl=thicknessTop,
    each groundRhoCyl=groundRho)
    "layer interacting with atmosphere above the short term cylinders"
    annotation (Placement(transformation(extent={{-58,42},{-38,62}})));
  CylindricalLayer mainLayers[numberLayers](
    each groundCpCyl=groundCp,
    each groundKCyl=groundK,
    each tempInitial=bhTinitial,
    each heigthCyl=thicknessMain,
    outerRadiusCyl=rOuterVec,
    innerRadiusCyl=rInnerVec[:, 1],
    each groundRhoCyl=groundRho)
    "main layers, interacting with the borefield, for the short term"
    annotation (Placement(transformation(extent={{-60,-16},{-40,4}})));
  CylindricalLayer bottomLayer[numberLayers](
    each groundCpCyl=groundCp,
    each groundKCyl=groundK,
    each tempInitial=bhTinitial,
    outerRadiusCyl=rOuterVec,
    innerRadiusCyl=rInnerVec[:, 1],
    each heigthCyl=thicknessBottom,
    each groundRhoCyl=groundRho)
    "bottom layer, interacting with the short term parts"
    annotation (Placement(transformation(extent={{-58,-76},{-38,-56}})));

  parameter Modelica.SIunits.ThermalDiffusivity alpha=groundK/(groundRho*
      groundCp);

  //-------------------CALCULATE MESH---------------------------------------------

  // thickness of top and bottom layer
  parameter Modelica.SIunits.Time timeConstantTop=(24*365/2)*3600
    "Temperature pulses on top vary mainly with half a year";
  parameter Modelica.SIunits.Length thicknessTop=0.89*sqrt(alpha*
      timeConstantTop) "diffusion in a plane for the top";
  parameter Modelica.SIunits.Length thicknessMain=bhDepth - thicknessTop
    "part of the borehole not directly exposed to the climate";
  parameter Modelica.SIunits.Time timeConstantBottom=100*(24*365)*3600
    "Bottom represents a reservoir with a time constant of a 100 year";
  parameter Modelica.SIunits.Length thicknessBottom=0.89*sqrt(alpha*
      timeConstantBottom) "diffusion in a plane";

  // radial layers calculation, based on Eskilson (1987)
  // delta R minimal = min(sqrt(alpha* delta_time_minimal, boreholeDepth/5), but minimal time short enough to take the first term
  // R_max = 3* sqrt( alpha * t_max )
  // exponential build up of grid: deltaR = [ dRmin, dRmin, dRmin, dRmin *2^1, dRmin*2^2, ... , R_max]

  // This grid: minimal timestep: 5 minutes, maximal simulation time: 100 year
  // This boils down to :  dTmin*2^(17) > 3*sqrt(alpha* (100 year)
  parameter Integer numberLayers=17;
  //parameter Real sqrtTvec[numberLayers] = [12.5;12.5;12.5;25;50;100;200;400;800;1600;3200;6400;12800;25600;51200;102400;204800];
  parameter Real sqrtTvec[numberLayers]={12.5,12.5,12.5,25,50,100,200,400,800,
      1600,3200,6400,12800,25600,51200,102400,204800};
  // for the making of the grid: cumulative
  parameter Real sqrtTvecCumul[numberLayers]={12.5,25,37.5,62.5,112.5,212.5,
      412.5,812.5,1612.5,3212.5,6412.5,12812.5,25612.5,51212.5,102412.5,
      204812.5,409612.5};
  parameter Real dRvec[numberLayers]=sqrt(alpha)*sqrtTvecCumul;

  parameter Modelica.SIunits.Radius[numberLayers] bhRarray=bhRadius*ones(
      numberLayers);
  parameter Modelica.SIunits.Radius[numberLayers] rOuterVec=dRvec + bhRarray
    "outer radiuses are just the sum";
  parameter Modelica.SIunits.Radius[numberLayers, 1] rInnerVec=[bhRadius;
      rOuterVec[1:(numberLayers - 1)]] "inner radiuses are one step behind";
  //  parameter Modelica.SIunits.HeatFlowRate shortTermFlux = geothermalFlux*Modelica.Constants.pi*((rOuterVec[numberLayers])^2 - bhRadius^2)
  //    "geothermal flux on the short term part";
  //  parameter Modelica.SIunits.HeatFlowRate[numberLayers] shortTermFlux = geothermalFlux*Modelica.Constants.pi*((rOuterVec[:])^2 - (rInnerVec[:,1])^2);

  parameter Modelica.SIunits.HeatFlowRate[numberLayers] shortTermFlux=
      geoFluxCalculation(
      rInner=rInnerVec,
      rOuter=rOuterVec,
      geoFluxValue=geothermalFlux);

  //   for i in 1:numberLayers loop
  //     shortTermFlux[i]:=geothermalFlux*Modelica.Constants.pi*((rOuterVec[i])^2 -
  //       rInnerVec[i, 1]^2);
  //   end for;

equation
  connect(mainLayers[1].innerRadius, fillingGroundMain) annotation (Line(
      points={{-59.6,-5.2},{-78.8,-5.2},{-78.8,10},{-100,10}},
      color={191,0,0},
      smooth=Smooth.None));

  // connection of all the short term main parts to the only top and bottom short term part
  for i in 1:numberLayers loop
    connect(mainLayers[i].upperSurface, upperLayer[i].lowerSurface);
    connect(mainLayers[i].lowerSurface, bottomLayer[i].upperSurface);
    connect(geothermalFluxShort[i].port, bottomLayer[i].lowerSurface);
    connect(upperLayer[i].upperSurface, topBorehole);

  end for;

  // internal connections of main layers and all long term layers
  for i in 1:(numberLayers - 1) loop
    connect(mainLayers[i].outerRadius, mainLayers[i + 1].innerRadius);
  end for;

  connect(upperLayer[1].innerRadius, fillingGroundTop) annotation (Line(
      points={{-57.6,52.8},{-78.8,52.8},{-78.8,44},{-100,44}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(undisturbedGround.port, upperLayer[numberLayers].outerRadius)
    annotation (Line(
      points={{60,2},{10.9,2},{10.9,52.6},{-38.2,52.6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(undisturbedGround.port, mainLayers[numberLayers].outerRadius)
    annotation (Line(
      points={{60,2},{12,2},{12,-5.4},{-40.2,-5.4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(undisturbedGround.port, bottomLayer[numberLayers].outerRadius)
    annotation (Line(
      points={{60,2},{12,2},{12,-65.4},{-38.2,-65.4}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    Icon(graphics={Ellipse(extent={{-52,56},{48,26}}, lineColor={102,0,0}),
          Ellipse(extent={{-50,-20},{48,-54}}, lineColor={102,0,0}),Ellipse(
          extent={{-52,76},{48,52}}, lineColor={102,0,0}),Ellipse(extent={{-50,
          -62},{48,-88}}, lineColor={102,0,0}),Line(
          points={{-52,64},{-50,-76},{-50,-56}},
          color={102,0,0},
          smooth=Smooth.None),Line(
          points={{48,64},{48,-74},{48,-50}},
          color={102,0,0},
          smooth=Smooth.None),Ellipse(
          extent={{-10,68},{6,62}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),Rectangle(
          extent={{-10,64},{6,-38}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),Ellipse(
          extent={{-10,-38},{6,-38}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),Ellipse(
          extent={{-10,-36},{6,-40}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),Text(
          extent={{-94,96},{94,44}},
          lineColor={255,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="%name"),Line(
          points={{-10,36},{-90,36},{-72,36}},
          color={255,0,0},
          smooth=Smooth.None),Line(
          points={{-10,-16},{-88,-16},{-66,-16}},
          color={255,0,0},
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p>Dieter Patteeuw. March April 2012.</p>
<p><b>Description</b> </p>
<p>GroundSingleBorehole makes a 2D mesh of <a href=\"VerticalSingleBorehole.BoreholeComponents.CylindricalLayer\">CyclindricalLayers</a>: namely in the vertical and the radial direction. </p>
<p>The vertical direction consists of 3 layers:</p>
<p>- &apos;Top&apos;, &apos;Upperlayer&apos; : this is the top layer, connected to the ambient air. It is connected to the ambient air (upper) and the main layer (under). It&apos;s thickness is determined as the thermal diffusion period of a sinus with period of one year (which is around 3 meter for typical soil types.</p>
<p>- &apos;Main&apos;, &apos;Mainlayers&apos;: this is the main layer. Typically a borehole is around 50-100 meters deep. The depth of this layer is this distance minus the depth of the top layer. It is connected to the top layer (upper) and the bottomlayers (under). This is the main and most useful part of the model. The heat transfer of a borehole with the surrounding ground is mainly radial in this fraction of the ground.</p>
<p>- &apos;Bottomlayers&apos; : A duplicate of the main layer, but without a borehole in the middle. This layer is intended to mimic the ground beneath the borehole. It is connected to the main layer (upper). At the bottom of this layer, a heat flux is added, namely the geothermal heat flux.</p>
<p><br/>Each 3 layers of the vertical direction, consists of a number of radial layers. These radial layers are intended for the radial heat transfer. </p>
<p>The meshing in the radial direction is performed as described by Eskilson. A good description of this grid can be found on page 173 of the PhD thesis Clara Verhelst titled &QUOT;Model Predictive Control of Ground Coupled Heat Pump Systems for Office Buildings&QUOT;. The original intention of the model was to give in the smallest and the timeperiod considered in the simulation. From this, the grid parameters could be calculated. Modelica does not work with arrays, though, which have a length based on user parameters. Thus, the smallest and largest timeperiod were taken to be 5 minutes and 100 years respectively. Since the grid interdistance is exponential, this only leads to the necessity of 17 radial elements. The radial grid then looks as follows:</p>
<p><img src=\"modelica://VerticalSingleBorehole/RadialMesh.jpg\"/></p>
<p><br/><br/>Source: PhD thesis Clara Verhelst titled &QUOT;Model Predictive Control of Ground Coupled Heat Pump Systems for Office Buildings&QUOT;</p>
<p><h4>Assumptions and limitations </h4></p>
<p>1.&nbsp;&nbsp;A constant initial vertical temperature profile is assumed.</p>
<p>2. At the end of the radial grid, at a timeconstant of a 100 years, a constant ground temperature is assumed.</p>
<p><b>Model use</b> </p>
<p>1.&nbsp;Sub-model. Only use in <a href=\"VerticalSingleBorehole.SingleBorehole\">SingleBorehole</a>.</p>
<p><h4>Validation </h4></p>
<p>See description in <a href=\"VerticalSingleBorehole.SingleBorehole\">SingleBorehole</a></p>
<p><b>Example</b> </p>
<p>An example of this model can be found in the validation models (VerticalSingleBorehole.TestSpitlerConstant and VerticalSingleBorehole.TestSpitlerInterrupted)</p>
</html>"));
end GroundSingleBorehole;
