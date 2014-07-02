within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield;
model MultipleBoreHoles_MBL
  "Calculates the average fluid temperature T_fts of the borefield for a given (time dependent) load Q_flow. Compatible with the Modelica Buildings Library"
  import Buildings;

  // FIXME:
  //  1) make it possible to run model without pre-compilation of g-function (short term)
  //  2) make it possible to run model with full pre-compilation of g-fuction (short and long term)
  //  3) Make the enthalpy a differentiable function (look at if statement)

  // Medium in borefield
  replaceable package Medium = Buildings.Media.ConstantPropertyLiquidWater;

  extends BaseClasses.partial_MultipleBoreHoles(     p_max=5, lenSim=3600*24*50);

  // Calculation of the inlet and outlet temperature, if show_T=true
  parameter Boolean show_T=true;
  Modelica.SIunits.Temperature T_hcf_in=Medium.temperature_phX(
      bfData.adv.p_constant,
      sou.h_in,
      X=Medium.X_default[1:Medium.nXi]) if                                                                                              show_T;
  Modelica.SIunits.Temperature T_hcf_out=Medium.temperature_phX(
      bfData.adv.p_constant,
      sin.h_in,
      X=Medium.X_default[1:Medium.nXi]) if                                                                                               show_T;

protected
  Medium.ThermodynamicState sta_hcf
    "thermodynamic state for heat carrier fluid at temperature T_ft";

  Modelica.SIunits.Enthalpy sinEntVal "Enthalpy of the medium of the sink";
  Modelica.SIunits.Enthalpy souEntVal "Enthalpy of the medium of the source";
public
  Buildings.Fluid.Sources.Boundary_ph sin(
    redeclare package Medium = Medium,
    nPorts=1,
    use_h_in=true) "Sink"
    annotation (Placement(transformation(extent={{-88,-10},{-108,10}})));
  Buildings.Fluid.Sources.Boundary_ph sou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_h_in=true) "Sink"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Fluid.Interfaces.FluidPorts_b flowPort_b(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-106,-40},{-86,40}}),
        iconTransformation(extent={{-106,-40},{-86,40}})));
  Modelica.Fluid.Interfaces.FluidPorts_b flowPort_a(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{86,-40},{106,40}}),
        iconTransformation(extent={{86,-40},{106,40}})));

    Modelica.Blocks.Sources.RealExpression sinEnt(y=sinEntVal)
    "Enthalpy of the medium of the sink"
      annotation (Placement(transformation(extent={{-4,-30},{-24,-10}})));
    Modelica.Blocks.Sources.RealExpression souEnt(y=souEntVal)
    "Enthalpy of the medium of the sink"
      annotation (Placement(transformation(extent={{18,-30},{38,-10}})));
equation
  sta_hcf = Medium.setState_pTX(
    bfData.adv.p_constant,
    T_fts,
    X=Medium.X_default[1:Medium.nXi]);

  //if the heat flow is very low, the enthalpie is the same at the inlet and outlet
  if abs(Q_flow) > 10^(-3) then
    sou.h_in = Medium.specificEnthalpy(sta_hcf) - Q_flow/(bfData.steRes.m_flow
      *bfData.geo.nbBh/bfData.geo.nbSer)/2;
    sinEntVal = Medium.specificEnthalpy(sta_hcf) + Q_flow/(bfData.steRes.m_flow
      *bfData.geo.nbBh/bfData.geo.nbSer)/2;
  else
    sou.h_in = Medium.specificEnthalpy(sta_hcf);
    sinEntVal = Medium.specificEnthalpy(sta_hcf);
  end if;

  connect(sin.ports[1], flowPort_b)
                                annotation (Line(
      points={{-108,0},{-96,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[1], flowPort_a)
                                annotation (Line(
      points={{110,0},{96,0}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(sinEnt.y, sin.h_in) annotation (Line(
      points={{-25,-20},{-56,-20},{-56,4},{-86,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(souEnt.y, sou.h_in) annotation (Line(
      points={{39,-20},{62,-20},{62,4},{88,4}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    experiment(StopTime=70000, __Dymola_NumberOfIntervals=50),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,
            140}}), graphics={
        Rectangle(
          extent={{-90,90},{90,-90}},
          lineColor={0,0,0},
          fillColor={234,210,210},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{10,-10},{70,-70}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{10,70},{70,10}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-70,70},{-10,10}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-70,-10},{-10,-70}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-62,62},{-18,18}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{18,62},{62,18}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-62,-18},{-18,-62}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{18,-18},{62,-62}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Text(
          extent={{-76,156},{74,98}},
          lineColor={0,0,255},
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{
            140,140}}), graphics));
end MultipleBoreHoles_MBL;
