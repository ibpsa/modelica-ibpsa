within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.VerticalSingleBorehole;
model SingleBorehole
  "One single vertical borehole heat exchanger with one u-loop"
  // Dieter Patteeuw 28feb2012

  parameter IDEAS.Thermal.Data.Interfaces.Medium brine=
      IDEAS.Thermal.Data.Interfaces.Medium() "Medium in the component"
    annotation (choicesAllMatching=true);

  parameter Modelica.SIunits.Length boreholeDepth=110 "depth of the borehole";
  parameter Modelica.SIunits.Radius boreholeRadius=0.055
    "radius of the borehole";
  parameter Modelica.SIunits.Temperature tInitial
    "initial temperature of brine and ground";
  parameter Modelica.SIunits.Radius pipeInnerRadius=0.020
    "inner radius of the pipe";
  parameter Modelica.SIunits.Radius pipeOuterRadius=0.019
    "outer radius of the pipe";
  parameter Modelica.SIunits.ThermalConductivity pipeConductivity=0.3895
    "thermal conductivity of the pipe";
  //parameter Real nusseltNumber = 3.5
  //    "80   Nu of flow, standard: fully developed turbulent, Re = 10000, Pr = 7";
  parameter Modelica.SIunits.MassFlowRate referenceMassFlowRate=0.3
    "reference mass flow rate in the U-tube (for calculation Nusselt number)";
  parameter Modelica.SIunits.ThermalConductivity fillingConductivity=1.3
    "thermal conductivity of the filling material";
  parameter Integer configurationPipe=2
    "pipes 1: center, 2: middle, 3: side, see Marcotte Pasquier 2008 table 1";
  parameter Modelica.SIunits.SpecificHeatCapacity groundHeatCapacity=900
    "J/kgK specific heat capacity of the ground";
  parameter Modelica.SIunits.ThermalConductivity groundConductivity=1.3
    "W/mK thermal conductivity of the ground";
  parameter Modelica.SIunits.Density groundDensity=2000
    "kg/m3 density of the ground";
  parameter Modelica.SIunits.HeatFlux geoFlux=0.010
    "thermal flux from the earth core";
  parameter String typeGrid="eskilson"
    "only type of grid so far, based on Eskilson";

  IDEAS.Thermal.Components.Interfaces.FlowPort_a boreholeInlet(medium=brine)
    annotation (Placement(transformation(extent={{-110,34},{-90,54}}),
        iconTransformation(extent={{-106,40},{-80,66}})));
  IDEAS.Thermal.Components.Interfaces.FlowPort_b boreholeOutlet(medium=brine)
    annotation (Placement(transformation(extent={{86,46},{106,66}}),
        iconTransformation(extent={{80,40},{106,66}})));

  Modelica.SIunits.Temperature TIn=boreholeInlet.h/brine.cp;
  Modelica.SIunits.Temperature TOut=boreholeOutlet.h/brine.cp;
  Modelica.SIunits.Power QNet=boreholeInlet.H_flow + boreholeOutlet.H_flow;

  BoreholeComponents.GroundSingleBorehole groundSingleBorehole(
    bhDepth=boreholeDepth,
    bhRadius=boreholeRadius,
    bhTinitial=tInitial,
    groundCp=groundHeatCapacity,
    groundK=groundConductivity,
    groundRho=groundDensity,
    geothermalFlux=geoFlux)
    annotation (Placement(transformation(extent={{-38,-94},{16,-32}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a topClimate
    "connects the top of the borehole with the climate" annotation (Placement(
        transformation(extent={{-20,88},{0,108}}), iconTransformation(extent={{
            -20,88},{0,108}})));

  BoreholeComponents.PipeHeatExchange top(
    medium=brine,
    TInitial=tInitial,
    m=brineMassTop,
    UAflowing=topUA,
    UAstationary=topUAstationary)
    annotation (Placement(transformation(extent={{-64,34},{-44,54}})));
  BoreholeComponents.PipeHeatExchange main(
    medium=brine,
    TInitial=tInitial,
    m=brineMassMain,
    UAflowing=mainUA,
    UAstationary=mainUAstationary)
    annotation (Placement(transformation(extent={{14,34},{34,54}})));

protected
  parameter Modelica.SIunits.Mass brineMassMain=brine.rho*(2*depthMainG)*(
      Modelica.Constants.pi*pipeInnerRadius^2)
    "mass of the content of the pipe";
  parameter Modelica.SIunits.Mass brineMassTop=brine.rho*(2*depthTopG)*(
      Modelica.Constants.pi*pipeInnerRadius^2)
    "mass of the content of the pipe";

  parameter Modelica.SIunits.Length pipeLength=2*boreholeDepth
    "length of the u-pipe";
  parameter Real betaZero=if (configurationPipe < 1.5) then 14.4509 elseif (
      configurationPipe > 2.5) then 21.9059 else 17.4427;
  parameter Real betaOne=if (configurationPipe < 1.5) then -0.8176 elseif (
      configurationPipe > 2.5) then -0.3796 else -0.6052;
  // correlation for grout thermal resistance, see Marcotte Pasquier 2008 table 1
  parameter Real sb=betaZero*(boreholeRadius/pipeOuterRadius)^betaOne;

  // determination of nusselt number of the flow
  parameter Modelica.SIunits.Velocity referenceSpeed=referenceMassFlowRate/(
      brine.rho*(Modelica.Constants.pi*pipeInnerRadius*pipeInnerRadius));
  parameter Modelica.SIunits.ReynoldsNumber reynoldsNumber=(referenceSpeed*2*
      pipeInnerRadius)/(brine.nue);
  parameter Modelica.SIunits.PrandtlNumber prandtlNumber=(brine.cp*brine.nue*
      brine.rho)/(brine.lamda);
  parameter Modelica.SIunits.NusseltNumber nusseltNumber=if (reynoldsNumber <
      10000) then 4.36 else (0.023*(reynoldsNumber^0.8)*(prandtlNumber^3.5));

  // determine the size of the top part of the storage according to diffusion depth
  // thickness of top and bottom layer
  parameter Modelica.SIunits.ThermalDiffusivity alphaG=groundConductivity/(
      groundDensity*groundHeatCapacity);
  parameter Modelica.SIunits.Time timeConstantTopG=(24*365/2)*3600
    "Temperature pulses on top vary mainly with half a year";
  parameter Modelica.SIunits.Length depthTopG=0.89*sqrt(alphaG*timeConstantTopG)
    "length of the upper part of the borehole, factor for plane diffusion: 0.89";
  parameter Modelica.SIunits.Length depthMainG=boreholeDepth - depthTopG
    "length of the main part of the borehole";
  parameter Modelica.SIunits.ThermalConductance convectionMainG=(2*Modelica.Constants.pi
      *pipeInnerRadius*(depthMainG*2))*(nusseltNumber*brine.lamda/
      pipeInnerRadius);
  parameter Modelica.SIunits.ThermalConductance pipeConductionMainG=(2*Modelica.Constants.pi
      *pipeConductivity*(depthMainG*2))/(log(pipeOuterRadius/pipeInnerRadius));
  parameter Modelica.SIunits.ThermalConductance fillingConductionMainG=sb*
      fillingConductivity*depthMainG
    "thermal behaviour of the filling, Marcotte Pasquier 2008 table 1";
  parameter Modelica.SIunits.ThermalConductance mainUA=1/(1/convectionMainG + 1
      /pipeConductionMainG + 1/fillingConductionMainG)
    "total UA-value for the main part of the pipe, when circulation";
  parameter Modelica.SIunits.ThermalConductance stationaryInternalMain=(brine.lamda
      /pipeInnerRadius)*(2*Modelica.Constants.pi*pipeInnerRadius*(depthMainG*2))
    "internal thermal conduction of the fluid in the main part of the pipe, cursus warmteoverdracht p34";
  parameter Modelica.SIunits.ThermalConductance mainUAstationary=1/(1/
      stationaryInternalMain + 1/pipeConductionMainG + 1/fillingConductionMainG)
    "stationary UA-value for the main part of the pipe";

  parameter Modelica.SIunits.ThermalConductance convectionTopG=(2*Modelica.Constants.pi
      *pipeInnerRadius*(depthTopG*2))*(nusseltNumber*brine.lamda/
      pipeInnerRadius);
  parameter Modelica.SIunits.ThermalConductance pipeConductionTopG=(2*Modelica.Constants.pi
      *pipeConductivity*(depthTopG*2))/(log(pipeOuterRadius/pipeInnerRadius));
  parameter Modelica.SIunits.ThermalConductance fillingConductionTopG=sb*
      fillingConductivity*depthTopG
    "thermal behaviour of the filling, Marcotte Pasquier 2008 table 1";
  parameter Modelica.SIunits.ThermalConductance topUA=1/(1/convectionTopG + 1/
      pipeConductionTopG + 1/fillingConductionTopG)
    "total UA-value for the top of the pipe, when circulation";
  parameter Modelica.SIunits.ThermalConductance stationaryInternalTop=(brine.lamda
      /pipeInnerRadius)*(2*Modelica.Constants.pi*pipeInnerRadius*(depthTopG*2))
    "internal thermal conduction of the fluid in the top of the pipe, cursus warmteoverdracht p34";
  parameter Modelica.SIunits.ThermalConductance topUAstationary=1/(1/
      stationaryInternalTop + 1/pipeConductionTopG + 1/fillingConductionTopG)
    "stationary UA-value for the top of the pipe";

equation
  connect(groundSingleBorehole.topBorehole, topClimate) annotation (Line(
      points={{-13.7,-32},{-12,-24},{-6,32},{-10,32},{-10,98}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(top.flowPort_a, boreholeInlet) annotation (Line(
      points={{-64,44},{-100,44}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(top.flowPort_b, main.flowPort_a) annotation (Line(
      points={{-44,44},{14,44}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(main.flowPort_b, boreholeOutlet) annotation (Line(
      points={{34,44},{66,44},{66,56},{96,56}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(top.heatPort, groundSingleBorehole.fillingGroundTop) annotation (Line(
      points={{-54,34},{-46,34},{-46,-49.36},{-38,-49.36}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(main.heatPort, groundSingleBorehole.fillingGroundMain) annotation (
      Line(
      points={{24,34},{24,-92},{-38,-92},{-37.46,-66.1}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Icon(graphics={Ellipse(extent={{-68,50},{60,20}}, lineColor={104,0,0}),Line(
          points={{-68,34},{-68,-74},{-68,-74}},
          color={104,0,0},
          smooth=Smooth.None),Line(
          points={{60,34},{60,-74},{60,-74}},
          color={104,0,0},
          smooth=Smooth.None),Ellipse(extent={{-68,-58},{60,-88}}, lineColor={
          97,0,0}),Rectangle(
          extent={{-82,56},{-16,52}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),Rectangle(
          extent={{-20,54},{-16,-68}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),Rectangle(
          extent={{-16,-64},{-8,-68}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),Rectangle(
          extent={{-8,-64},{0,-68}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),Rectangle(
          extent={{0,56},{4,-68}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),Rectangle(
          extent={{0,56},{80,52}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),Text(
          extent={{-86,106},{80,50}},
          lineColor={115,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          textString="%name")}),
    Diagram(graphics),
    Documentation(info="<html>
<p>Dieter Patteeuw. March April 2012.</p>
<p><b>Description</b> </p>
<p>Single borehole is a model to simulate a vertical ground heat exchanger, more specific a U-tube type. It consists of 4 parts: </p>
<p>1. The model of the pipe and the filling material around the pipe (<a href=\"VerticalSingleBorehole.SingleBorehole\">SingleBorehole</a>). In order to have heat transfer with the surrounding ground, a fluid is circulated in the borehole (typically a brine: water with anti-freeze). </p>
<p>2. The ground around the borehole (<a href=\"VerticalSingleBorehole.BoreholeComponents.GroundSingleBorehole\">GroundSingleBorehole</a>) will react upon the heat transfer with the pipe. This behaviour is modelled by making a numerical mesh of the surrounding ground. Each part of that mesh is modelled as a CylindricalLayer.</p>
<p>3. The model of one fraction of the mesh (<a href=\"VerticalSingleBorehole.BoreholeComponents.CylindricalLayer\">CylindricalLayer</a>) describes the transient heat transfer of a cylindrical layer, by use of thermal resistances and a thermal capacity.</p>
<p>4. The heat exchange of a pipe (<a href=\"VerticalSingleBorehole.BoreholeComponents.PipeHeatExchange\">PipeHeatExchange</a>) is modelled using a eta-NTU model.</p>
<p><h4>Assumptions and limitations </h4></p>
<p>GENERAL:</p>
<p>1.&nbsp;&nbsp;It is assumed that there is no ground water flow in the surrounding ground.</p>
<p>2. The grid of the surrounding ground is made for timescales between 5 minutes and a 100 year. The model should not be used outside these timescales.</p>
<p>3. The model for the pipe and filling material tries to give an approximation of its thermal resistance, using (Marcotte en Pasquier, 2008). This does not always lead to the correct thermal resistance. Ideally, data from a TRT-test or typical values for UAflowing and UAstationary would be used.</p>
<p>4. Radial heat transfer from the borehole is the most important aspect for vertical borehole heat exchanger, this is done quite accurately by using Eskilson.</p>
<p>5. Vertical heat transfer is approximated by making 3 layers, but this is not the best set-up. This should be improved.</p>
<p>SPECIFIC:</p>
<p>6. The model for the pipe and filling material, is the one of Marcotte en Pasquier, 2008. This simplifies the up and down going tube of a segment to one tube.</p>
<p>7. &apos;6&apos; does have an implication on the model. The model is split up in two parts: &apos;top&apos; and &apos;main&apos;. The flow normally goes: &apos;down in top&apos; -&GT;&apos;down in main&apos;-&GT;&apos;up in main&apos; -&GT; &apos;up in top&apos;. Since in the same layer, the up and down part are merged into one tube, this order does not hold anymore. The flow of the water in the model is, due to this merging: &apos;down in top&apos; -&GT; &apos;up in top&apos;-&GT; &apos;down in main&apos;-&GT;&apos;up in main&apos; , which is not correct.</p>
<p><br/><b>Model use</b> </p>
<p>1.&nbsp;Specify the physical parameters of the borehole heat exchanger.</p>
<p>2. Connect the in and outgoing flowports to other components. </p>
<p>3. Connect the top heat port to the ambient air temperature.</p>
<p><h4>Validation </h4></p>
<p>The model is validated against Spitler&apos;s experiment ( Beier, Richard A., Marvin D. Smith, and Jeffrey D. Spitler. &QUOT;Reference data sets for vertical borehole ground heat exchanger models and thermal response test analysis.&QUOT; Geothermics 40.1 (2011): 79-85. ) The behaviour of the model is simular to the experiment, although some large error exists, due to the model of the pipe and filling material around the pipe.</p>
<p>Two experiments were performed in this paper:</p>
<p>1. <a href=\"
VerticalSingleBorehole.TestSpitlerConstant\">A constant heat input rate test.</a></p>
<p>2. <a href=\"VerticalSingleBorehole.TestSpitlerInterrupted\">An interrupted test.</a></p>
<p><br/><b>Example</b> </p>
<p>An example of this model can be found in the validation models (<a href=\"VerticalSingleBorehole.TestSpitlerConstant\">VerticalSingleBorehole.TestSpitlerConstant</a> and <a href=\"VerticalSingleBorehole.TestSpitlerInterrupted\">VerticalSingleBorehole.TestSpitlerInterrupted</a>)</p>
</html>"));
end SingleBorehole;
