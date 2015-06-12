within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses;
model BoreHoleSegmentHeightPort "Vertical segment of a borehole"
  extends Interface.PartialBoreHoleElement;

  extends IDEAS.Fluid.Interfaces.TwoPortFlowResistanceParameters;
  extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations;
  extends IDEAS.Fluid.Interfaces.PartialHeightPortInterface(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    redeclare final package Medium3 = Medium,
    redeclare final package Medium4 = Medium);

  parameter Modelica.SIunits.Temperature TExt_start=T_start
    "Initial far field temperature"
    annotation (Dialog(tab="Boundary conditions",group="T_start: ground"));
  parameter Modelica.SIunits.Temperature TFil_start=T_start
    "Initial far field temperature"
    annotation (Dialog(tab="Boundary conditions",group="T_start: ground"));

  InternalHEX2UTube intHEX(
    redeclare final package Medium = Medium,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final m3_flow_nominal=m3_flow_nominal,
    final m4_flow_nominal=m4_flow_nominal,
    final dp1_nominal=dp_nominal,
    final dp2_nominal=0,
    final dp3_nominal=dp_nominal,
    final dp4_nominal=0,
    final from_dp1=from_dp,
    final from_dp2=from_dp,
    final from_dp3=from_dp,
    final from_dp4=from_dp,
    final linearizeFlowResistance1=linearizeFlowResistance,
    final linearizeFlowResistance2=linearizeFlowResistance,
    final linearizeFlowResistance3=linearizeFlowResistance,
    final linearizeFlowResistance4=linearizeFlowResistance,
    final deltaM1=deltaM,
    final deltaM2=deltaM,
    final deltaM3=deltaM,
    final deltaM4=deltaM,
    final m1_flow_small=m1_flow_small,
    final m2_flow_small=m2_flow_small,
    final m3_flow_small=m3_flow_small,
    final m4_flow_small=m4_flow_small,
    final soi=soi,
    final fil=fil,
    final gen=gen,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final allowFlowReversal3=allowFlowReversal3,
    final allowFlowReversal4=allowFlowReversal4,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p1_start=p_start,
    final T1_start=T_start,
    final X1_start=X_start,
    final C1_start=C_start,
    final C1_nominal=C_nominal,
    final p2_start=p_start,
    final T2_start=T_start,
    final X2_start=X_start,
    final C2_start=C_start,
    final C2_nominal=C_nominal,
    final p3_start=p_start,
    final T3_start=T_start,
    final X3_start=X_start,
    final C3_start=C_start,
    final C3_nominal=C_nominal,
    final p4_start=p_start,
    final T4_start=T_start,
    final X4_start=X_start,
    final C4_start=C_start,
    final C4_nominal=C_nominal,
    final T_start=T_start,
    dynFil=dynFil)
    "Internal part of the borehole including the pipes and the filling material"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));

    CylindricalGroundLayer soilLay(
    final material=soi,
    final h=gen.hSeg,
    final nSta=gen.nHor,
    final r_a=gen.rBor,
    final r_b=gen.rExt,
    final TInt_start=TFil_start,
    final TExt_start=TExt_start,
    final steadyStateInitial=false) "Heat conduction in the soil layers"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TBouCon
    "Thermal boundary condition for the far-field"
    annotation (Placement(transformation(extent={{68,-10},{48,10}})));
public
  Modelica.Blocks.Sources.RealExpression realExpression(final y=T_start)
    annotation (Placement(transformation(extent={{50,-30},{70,-10}})));

protected
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFlo
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));

public
  parameter Boolean dynFil=true
    "Set to false to remove the dynamics of the filling material." annotation (Dialog(tab="Dynamics"));
equation
  connect(intHEX.port, heaFlo.port_a) annotation (Line(
      points={{-60,10},{-45,10},{-45,1.22125e-015},{-40,1.22125e-015},{-40,0},{
          -30,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaFlo.port_b, soilLay.port_a) annotation (Line(
      points={{-10,0},{-7.5,0},{-7.5,1.22125e-015},{-5,1.22125e-015},{-5,0},{0,
          0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(port_a1, intHEX.port_a1) annotation (Line(
      points={{-100,80},{-76,80},{-76,8.18182},{-70,8.18182}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(soilLay.port_b, TBouCon.port) annotation (Line(
      points={{20,0},{48,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(realExpression.y, TBouCon.T) annotation (Line(
      points={{71,-20},{84,-20},{84,0},{70,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(port_b2, intHEX.port_b2) annotation (Line(
      points={{-100,30},{-86,30},{-86,3.63636},{-70,3.63636}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_a3, intHEX.port_a3) annotation (Line(
      points={{-100,-32},{-84,-32},{-84,-2},{-70,-2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_b4, intHEX.port_b4) annotation (Line(
      points={{-100,-80},{-78,-80},{-78,-6.81818},{-70,-6.81818}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(intHEX.port_b1, port_b1) annotation (Line(
      points={{-50,8.18182},{-38,8.18182},{-38,80},{100,80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(intHEX.port_a2, port_a2) annotation (Line(
      points={{-50,3.63636},{-42,3.63636},{-42,4},{-28,4},{-28,30},{100,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(intHEX.port_b3, port_b3) annotation (Line(
      points={{-50,-1.90909},{-44,-1.90909},{-44,-2},{-36,-2},{-36,-30},{100,
          -30}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(intHEX.port_a4, port_a4) annotation (Line(
      points={{-50,-6.36364},{-40,-6.36364},{-40,-80},{100,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),     graphics),
    Icon(graphics={
        Rectangle(
          extent={{-72,80},{68,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{88,54},{-88,64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{88,-64},{-88,-54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-72,80},{68,68}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-72,-68},{68,-80}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward)}),
    Documentation(info="<html>
<p>
Horizontal layer that is used to model a U-tube borehole heat exchanger. 
This model combines three models, each simulating a different aspect 
of a borehole heat exchanger. 
</p>
<p>
The instance <code>intHEX</code> computes the heat transfer in the pipes and the filling material. 
This computation is done using the model
<a href=\"modelica://IDEAS.Fluid.HeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses.SingleUTubeInternalHEX\">
IDEAS.Fluid.HeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses.SingleUTubeInternalHEX</a>.
</p>
<p>
The instance <code>soiLay</code> computes transient and steady state heat transfer in the soil using a vertical cylinder.
The computation is done using the model <a href=\"modelica://IDEAS.Fluid.HeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses.CylindricalGroundLayer\">
IDEAS.Fluid.HeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses.CylindricalGroundLayer</a>.
</p>
<p>
The model <code>TBouCon</code> is a constant temperature equal to the initial ground temperature.</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end BoreHoleSegmentHeightPort;
