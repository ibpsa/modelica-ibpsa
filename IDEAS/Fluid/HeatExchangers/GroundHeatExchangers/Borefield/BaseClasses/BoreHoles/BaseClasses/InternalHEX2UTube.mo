within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses;
model InternalHEX2UTube
  "Internal part of a borehole for a double U-Tube configuration. In loop 1, fluid 1 streams from a1 to b1 and comes back from a3 to b3. In loop 2: fluid 2 streams from a2 to b2 and comes back from a4 to b4."
  extends Interface.PartialBoreHoleInternalHEX;

  extends IDEAS.Fluid.Interfaces.EightPortHeatMassExchanger(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    redeclare final package Medium3 = Medium,
    redeclare final package Medium4 = Medium,
    T1_start=T_start,
    T2_start=T_start,
    T3_start=T_start,
    T4_start=T_start,
    final tau1=Modelica.Constants.pi*gen.rTub^2*gen.hSeg*rho1_nominal/
        m1_flow_nominal,
    final tau2=Modelica.Constants.pi*gen.rTub^2*gen.hSeg*rho2_nominal/
        m2_flow_nominal,
    final tau3=Modelica.Constants.pi*gen.rTub^2*gen.hSeg*rho3_nominal/
        m3_flow_nominal,
    final tau4=Modelica.Constants.pi*gen.rTub^2*gen.hSeg*rho4_nominal/
        m4_flow_nominal,
    final show_T=true,
    vol1(
      final energyDynamics=energyDynamics,
      final massDynamics=massDynamics,
      final prescribedHeatFlowRate=false,
      final allowFlowReversal=allowFlowReversal1,
      final m_flow_small=m1_flow_small,
      final V=gen.volOneLegSeg,
      mSenFac=mSenFac),
    vol2(
      final energyDynamics=energyDynamics,
      final massDynamics=massDynamics,
      final prescribedHeatFlowRate=false,
      final m_flow_small=m2_flow_small,
      final V=gen.volOneLegSeg,
      mSenFac=mSenFac),
    vol3(
      final energyDynamics=energyDynamics,
      final massDynamics=massDynamics,
      final prescribedHeatFlowRate=false,
      final allowFlowReversal=allowFlowReversal3,
      final m_flow_small=m3_flow_small,
      final V=gen.volOneLegSeg,
      mSenFac=mSenFac),
    vol4(
      final energyDynamics=energyDynamics,
      final massDynamics=massDynamics,
      final prescribedHeatFlowRate=false,
      final m_flow_small=m4_flow_small,
      final V=gen.volOneLegSeg,
      mSenFac=mSenFac));

  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor RConv1
    "Pipe convective resistance" annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-18,64})));
  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor RConv2
    "Pipe convective resistance"
    annotation (Placement(transformation(extent={{40,6},{48,14}})));
  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor RConv3
    "Pipe convective resistance" annotation (Placement(transformation(
        extent={{4,4},{-4,-4}},
        rotation=180,
        origin={-18,-58})));
  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor RConv4
    "Pipe convective resistance" annotation (Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=180,
        origin={-42,10})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rpg1(R=RCondGro_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=90,
        origin={-1,45})));

  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb1(R=Rgb_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=90,
        origin={-1,21})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rpg2(R=RCondGro_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{-7,7},{7,-7}},
        rotation=180,
        origin={33,-1})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb2(R=Rgb_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=0,
        origin={15,-1})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rpg3(R=RCondGro_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={-1,-35})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb3(R=Rgb_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={-1,-15})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rpg4(R=RCondGro_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=180,
        origin={-31,1})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb4(R=Rgb_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=180,
        origin={-13,1})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg11(R=Rgg1_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=90,
        origin={21,21})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg21(R=Rgg2_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=180,
        origin={43,45})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg12(R=Rgg1_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=90,
        origin={21,-19})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg22(R=Rgg2_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=90,
        origin={49,-21})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg14(R=Rgg1_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=90,
        origin={-21,19})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg24(R=Rgg2_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={-39,23})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg13(R=Rgg1_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=90,
        origin={-19,-19})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg23(R=Rgg2_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=180,
        origin={-29,-39})));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil1(T(start=
          T_start, fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
      der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial)),
    C=Co_fil/4) if  dynFil "Heat capacity of the filling material"
                                            annotation (Placement(
        transformation(
        extent={{-54,21.6},{-42,9.6}},
        rotation=90,
        origin={31.6,92})));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil2(T(start=
          T_start, fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
      der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial)),
    C=Co_fil/4) if   dynFil "Heat capacity of the filling material"
                                            annotation (Placement(
        transformation(
        extent={{54,-21.6},{42,-9.6}},
        rotation=180,
        origin={81.6,-32})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil3(T(start=
          T_start, fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
      der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial)),
    C=Co_fil/4) if  dynFil "Heat capacity of the filling material"
                                            annotation (Placement(
        transformation(
        extent={{54,-21.6},{42,-9.6}},
        rotation=180,
        origin={61.6,-52})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil4(T(start=
          T_start, fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
      der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial)),
    C=Co_fil/4) if  dynFil "Heat capacity of the filling material"
                                            annotation (Placement(
        transformation(
        extent={{54,-21.6},{42,-9.6}},
        rotation=180,
        origin={15.6,-30})));

protected
  parameter Modelica.SIunits.HeatCapacity Co_fil=fil.d*fil.c*gen.hSeg*Modelica.Constants.pi
      *(gen.rBor^2 - 4*(gen.rTub + gen.eTub)^2)
    "Heat capacity of the whole filling material";

  parameter Modelica.SIunits.SpecificHeatCapacity cpMed=
      Medium.specificHeatCapacityCp(Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Specific heat capacity of the fluid";
  parameter Modelica.SIunits.ThermalConductivity kMed=
      Medium.thermalConductivity(Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Thermal conductivity of the fluid";
  parameter Modelica.SIunits.DynamicViscosity mueMed=Medium.dynamicViscosity(
      Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Dynamic viscosity of the fluid";

  parameter Real x(fixed=false);
  parameter Real Rgb_val(fixed=false);
  parameter Real Rgg1_val(fixed=false);
  parameter Real Rgg2_val(fixed=false);
  parameter Real RCondGro_val(fixed=false);

public
  Modelica.Blocks.Sources.RealExpression RVol1(y=convectionResistance(
        hSeg=gen.hSeg,
        rBor=gen.rBor,
        rTub=gen.rTub,
        eTub=gen.eTub,
        kMed=kMed,
        mueMed=mueMed,
        cpMed=cpMed,
        m_flow=m1_flow,
        m_flow_nominal=m1_flow_nominal))
    "Convective and thermal resistance at fluid 1"
    annotation (Placement(transformation(extent={{-56,56},{-42,72}})));
  Modelica.Blocks.Sources.RealExpression RVol2(y=convectionResistance(
        hSeg=gen.hSeg,
        rBor=gen.rBor,
        rTub=gen.rTub,
        eTub=gen.eTub,
        kMed=kMed,
        mueMed=mueMed,
        cpMed=cpMed,
        m_flow=m2_flow,
        m_flow_nominal=m2_flow_nominal))
    "Convective and thermal resistance at fluid 2"
    annotation (Placement(transformation(extent={{88,18},{72,0}})));
  Modelica.Blocks.Sources.RealExpression RVol3(y=convectionResistance(
        hSeg=gen.hSeg,
        rBor=gen.rBor,
        rTub=gen.rTub,
        eTub=gen.eTub,
        kMed=kMed,
        mueMed=mueMed,
        cpMed=cpMed,
        m_flow=m3_flow,
        m_flow_nominal=m3_flow_nominal))
    "Convective and thermal resistance at fluid 1"
    annotation (Placement(transformation(extent={{-12,-60},{-26,-76}})));

  Modelica.Blocks.Sources.RealExpression RVol4(y=convectionResistance(
        hSeg=gen.hSeg,
        rBor=gen.rBor,
        rTub=gen.rTub,
        eTub=gen.eTub,
        kMed=kMed,
        mueMed=mueMed,
        cpMed=cpMed,
        m_flow=m1_flow,
        m_flow_nominal=m4_flow_nominal))
    "Convective and thermal resistance at fluid 1"
    annotation (Placement(transformation(extent={{-68,12},{-54,28}})));

  parameter Real mSenFac=1
    "Factor for scaling the sensible thermal mass of the volume"
    annotation (Dialog(tab="Dynamics"));
initial equation
  (x,Rgb_val,Rgg1_val,Rgg2_val,RCondGro_val) = doubleUTubeResistances(
    hSeg=gen.hSeg,
    rBor=gen.rBor,
    rTub=gen.rTub,
    eTub=gen.eTub,
    sha=gen.xC,
    kFil=fil.k,
    kSoi=soi.k,
    kTub=gen.kTub,
    use_Rb=gen.use_Rb,
    Rb=gen.Rb,
    kMed=kMed,
    mueMed=mueMed,
    cpMed=cpMed,
    m_flow_nominal=m1_flow_nominal,
    printDebug=false);

equation
  assert(not gen.singleUTube,
  "This model should be used for double U-type borefield, not single U-type. 
  Check that the record General has been correctly parametrized");
  connect(RVol1.y, RConv1.Rc) annotation (Line(
      points={{-41.3,64},{-24,64}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(RConv1.fluid, vol1.heatPort) annotation (Line(
      points={{-18,70},{-10,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(RConv3.fluid, vol3.heatPort) annotation (Line(
      points={{-14,-58},{-12,-58},{-12,-60},{-10,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol4.heatPort, RConv4.fluid) annotation (Line(
      points={{-50,0},{-48,0},{-48,10},{-46,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(RConv2.fluid, vol2.heatPort) annotation (Line(
      points={{48,10},{48,0},{50,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(RConv1.solid, Rpg1.port_a) annotation (Line(
      points={{-18,58},{-18,52},{-1,52}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(Rpg1.port_b, Rgb1.port_a) annotation (Line(
      points={{-1,38},{-1,28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(RConv2.solid, Rpg2.port_a) annotation (Line(
      points={{40,10},{40,-1}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rgb2.port_a, Rpg2.port_b) annotation (Line(
      points={{22,-1},{26,-1}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rgb2.port_b, port) annotation (Line(
      points={{8,-1},{8,0},{6,0},{6,60},{20,60},{20,100},{0,100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rgb1.port_b, port) annotation (Line(
      points={{-1,14},{0,14},{0,0},{6,0},{6,60},{20,60},{20,100},{0,100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(RConv3.solid, Rpg3.port_a) annotation (Line(
      points={{-22,-58},{-24,-58},{-24,-46},{-1,-46},{-1,-42}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rgb3.port_a, Rpg3.port_b) annotation (Line(
      points={{-1,-22},{-1,-28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rgb3.port_b, port) annotation (Line(
      points={{-1,-8},{0,-8},{0,0},{6,0},{6,60},{20,60},{20,100},{0,100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(RConv4.solid, Rpg4.port_a) annotation (Line(
      points={{-38,10},{-38,1}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rpg4.port_b, Rgb4.port_a) annotation (Line(
      points={{-24,1},{-20,1}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rgb4.port_b, port) annotation (Line(
      points={{-6,1},{-4,1},{-4,0},{6,0},{6,60},{20,60},{20,100},{0,100}},
      color={191,0,0},
      smooth=Smooth.None));
 if dynFil then
     connect(capFil1.port, Rpg1.port_b) annotation (Line(
      points={{10,44},{10,34},{0,34},{0,38},{-1,38}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(capFil2.port, Rpg2.port_b) annotation (Line(
      points={{33.6,-10.4},{26,-10.4},{26,-1}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(capFil3.port, Rpg3.port_b) annotation (Line(
      points={{13.6,-30.4},{13.6,-28},{-1,-28}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(capFil4.port, Rpg4.port_b) annotation (Line(
      points={{-32.4,-8.4},{-24,-8.4},{-24,1}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Rgg21.port_b, capFil3.port) annotation (Line(
      points={{50,45},{80,45},{80,44},{112,44},{112,-30.4},{13.6,-30.4}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Rgg22.port_a, capFil2.port) annotation (Line(
      points={{49,-14},{48,-14},{48,-10.4},{33.6,-10.4}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Rgg22.port_b, capFil4.port) annotation (Line(
      points={{49,-28},{50,-28},{50,-90},{-42,-90},{-42,-8.4},{-32.4,-8.4}},
      color={191,0,0},
      smooth=Smooth.None));
 else
    connect(Rgg11.port_a, Rpg1.port_b);
    connect(Rgg12.port_a, Rpg2.port_b);
    connect(Rgg13.port_b, Rpg3.port_b);
    connect(Rgg14.port_b, Rpg4.port_b);
    connect(Rgg21.port_b, Rpg1.port_b);
    connect(Rgg22.port_a, Rpg2.port_b);
    connect(Rgg22.port_b, Rpg4.port_b);
 end if;
  connect(Rgg11.port_a, Rpg1.port_b) annotation (Line(
      points={{21,28},{22,28},{22,34},{-1,34},{-1,38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rgg11.port_b, Rgb2.port_a) annotation (Line(
      points={{21,14},{22,14},{22,-1}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rgg12.port_a, Rgb2.port_a) annotation (Line(
      points={{21,-12},{22,-12},{22,-1}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rgg12.port_b, Rpg3.port_b) annotation (Line(
      points={{21,-26},{16,-26},{16,-28},{-1,-28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rgg13.port_b, Rpg3.port_b) annotation (Line(
      points={{-19,-26},{-2,-26},{-1,-28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rgg13.port_a, Rpg4.port_b) annotation (Line(
      points={{-19,-12},{-22,-12},{-22,-8},{-24,-8},{-24,1}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rgg14.port_b, Rgb4.port_a) annotation (Line(
      points={{-21,12},{-20,12},{-20,1}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rgg14.port_a, Rgb1.port_a) annotation (Line(
      points={{-21,26},{-20,26},{-20,34},{-2,34},{-1,28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rgg21.port_a, Rpg1.port_b) annotation (Line(
      points={{36,45},{30,45},{30,34},{-1,34},{-1,38}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(Rgg23.port_b, Rpg3.port_b) annotation (Line(
      points={{-22,-39},{-18,-39},{-18,-40},{-12,-40},{-12,-26},{-2,-26},{-1,-28}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(Rgg23.port_a, Rpg1.port_b) annotation (Line(
      points={{-36,-39},{-56,-39},{-56,-40},{-74,-40},{-74,34},{-1,34},{-1,38}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(Rgg24.port_a, Rgb4.port_a) annotation (Line(
      points={{-39,16},{-32,16},{-32,10},{-20,10},{-20,1}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rgg24.port_b, Rgb2.port_a) annotation (Line(
      points={{-39,30},{-38,30},{-38,84},{32,84},{32,12},{22,12},{22,-1}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(RVol2.y, RConv2.Rc) annotation (Line(
      points={{71.2,9},{68,9},{68,18},{44,18},{44,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(RVol3.y, RConv3.Rc) annotation (Line(
      points={{-26.7,-68},{-32,-68},{-32,-50},{-18,-50},{-18,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(RVol4.y, RConv4.Rc) annotation (Line(
      points={{-53.3,20},{-50,20},{-50,14},{-42,14}},
      color={0,0,127},
      smooth=Smooth.None));

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,
            100}}), graphics={Text(
          extent={{-114,74},{-84,68}},
          lineColor={0,0,0},
          textString="Loop 1"), Text(
          extent={{-160,-36},{-130,-42}},
          lineColor={0,0,0},
          textString="Loop 1"),
        Text(
          extent={{-10,14},{0,4}},
          lineColor={0,0,0},
          textString="Tb")}),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,100}}),
        graphics={
        Rectangle(
          extent={{98,74},{-94,86}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{96,24},{-96,36}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{100,-38},{-92,-26}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{94,-88},{-98,-76}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
Model for the heat transfer between the fluid and within the borehole filling. 
This model computes the dynamic response of the fluid in the tubes, 
the heat transfer between the fluid and the borehole filling, 
and the heat storage within the fluid and the borehole filling.
</p>
<p>
This model computes the different thermal resistances present 
in a single-U-tube borehole using the method of Bauer et al. (2011) 
and computing explicitely the fluid-to-ground thermal resistance 
<i>R<sub>b</sub></i> and the 
grout-to-grout resistance
<i>R<sub>a</sub></i> as defined by Hellstroem (1991)
using the multipole method.
The multipole method is implemented in
<a href=\"modelica://IDEAS.Fluid.HeatExchangers.Boreholes.BaseClasses.singleUTubeResistances\">
IDEAS.Fluid.HeatExchangers.Boreholes.BaseClasses.singleUTubeResistances</a>. 
The convection resistance is calculated using the 
Dittus-Boelter correlation
as implemented in
<a href=\"modelica://IDEAS.Fluid.HeatExchangers.Boreholes.BaseClasses.convectionResistance\">
IDEAS.Fluid.HeatExchangers.Boreholes.BaseClasses.convectionResistance</a>. 
</p>
<p>
The figure below shows the thermal network set up by Bauer et al. (2010).
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://IDEAS/Resources/Images/Fluid/HeatExchangers/Boreholes/BaseClasses/Bauer_singleUTube.png\"/>
</p>
<h4>References</h4>
<p>
G. Hellstr&ouml;m. 
<i>Ground heat storage: thermal analyses of duct storage systems (Theory)</i>. 
Dept. of Mathematical Physics, University of Lund, Sweden, 1991.
</p>
<p>
D. Bauer, W. Heidemann, H. M&uuml;ller-Steinhagen, and H.-J. G. Diersch.
<i>
<a href=\"http://dx.doi.org/10.1002/er.1689\">
Thermal resistance and capacity models for borehole heat exchangers
</a>
</i>.
International Journal Of Energy Research, 35:312&ndash;320, 2011.
</p>
</html>", revisions="<html>
<p>
<ul>
<li>
June 18, 2014, by Michael Wetter:<br/>
Added initialization for temperatures and derivatives of <code>capFil1</code>
and <code>capFil2</code> to avoid a warning during translation.
</li>
<li>
February 14, 2014, by Michael Wetter:<br/>
Removed unused parameters <code>B0</code> and <code>B1</code>.
</li>
<li>
January 24, 2014, by Michael Wetter:<br/>
Revised implementation, added comments, replaced 
<code>HeatTransfer.Windows.BaseClasses.ThermalConductor</code>
with resistance models from the Modelica Standard Library.
</li>
<li>
January 23, 2014, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end InternalHEX2UTube;
