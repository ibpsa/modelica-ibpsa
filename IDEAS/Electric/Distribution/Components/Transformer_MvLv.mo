within IDEAS.Electric.Distribution.Components;
model Transformer_MvLv "Medium to low voltage transfomer for three-phase grids"

  replaceable parameter IDEAS.Electric.Data.Interfaces.TransformerImp
    transformer "Choose a transformer" annotation (choicesAllMatching=true);

  parameter Real gridFreq=50
    "Grid frequency: should normally not be changed when simulating belgian grids!";
  parameter Modelica.SIunits.ComplexVoltage VSource=230 + 0*Modelica.ComplexMath.j "Voltage"
              annotation (choices(
      choice=(230*1) + 0*MCM.j "100% at HVpin of transformer",
      choice=(230*1.02) + 0*MCM.j "102% at HVpin of transformer",
      choice=(230*1.05) + 0*MCM.j "105% at HVpin of transformer",
      choice=(230*1.1) + 0*MCM.j "110% at HVpin of transformer",
      choice=(230*0.95) + 0*MCM.j "95% at HVpin of transformer",
      choice=(230*0.9) + 0*MCM.j "90% at HVpin of transformer"));

  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin
                  pin_lv_p[3]
    annotation (Placement(transformation(extent={{90,50},{110,70}}),
        iconTransformation(extent={{90,50},{110,70}})));

  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin
                  pin_lv_n
    "This should NOT be connected for single phase equivalent circuits"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}}),
        iconTransformation(extent={{90,-70},{110,-50}})));

  IDEAS.Electric.BaseClasses.Con3PlusNTo3 con3PlusNTo3_HV
    annotation (Placement(transformation(extent={{-60,50},{-40,30}})));
  IDEAS.Electric.BaseClasses.Con3PlusNTo3 con3PlusNTo3_LV annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,40})));

  BaseClasses.Branch phase1(R=Modelica.ComplexMath.real(transformer.Zd), X=
        Modelica.ComplexMath.imag(transformer.Zd))
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  BaseClasses.Branch phase2(R=Modelica.ComplexMath.real(transformer.Zi), X=
        Modelica.ComplexMath.imag(transformer.Zi))
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  BaseClasses.Branch phase3(R=Modelica.ComplexMath.real(transformer.Z0), X=
        Modelica.ComplexMath.imag(transformer.Z0))
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));

  Modelica.SIunits.ActivePower traLosP0 = transformer.P0
    "No-load losses (can be assumed constant)";
  Modelica.SIunits.ActivePower traLosPTot = transformer.P0 + phase1.Plos + phase2.Plos + phase3.Plos
    "Total losses in transformer";

public
  Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource
    voltageSource(
    V=Modelica.ComplexMath.'abs'(VSource),
    phi=Modelica.ComplexMath.arg(VSource),
    f=gridFreq) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,14})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-90,-20})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={30,0})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor1
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={30,-28})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermalResistor
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={12,-14})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermalResistor1
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={12,-42})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector1
    annotation (Placement(transformation(extent={{2,4},{22,24}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={12,-68})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=sim.Te)
    annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));
  outer SimInfoManager sim
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
equation
  connect(pin_lv_p, con3PlusNTo3_LV.fourWire[1:3])
                                                annotation (Line(
      points={{100,60},{100,60},{86,60},{86,40},{74,40},{74,39.75},{60,39.75}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(pin_lv_n, con3PlusNTo3_LV.fourWire[4])
                                             annotation (Line(
      points={{100,-60},{86,-60},{86,39.25},{60,39.25}},
      color={85,170,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));

  connect(con3PlusNTo3_HV.threeWire[1], phase1.pin_p)
                                                     annotation (Line(
      points={{-40,40.6667},{-30,40.6667},{-30,50},{-10,50}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(con3PlusNTo3_HV.threeWire[2], phase2.pin_p)
                                                     annotation (Line(
      points={{-40,40},{-10,40}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(con3PlusNTo3_HV.threeWire[3], phase3.pin_p)
                                                     annotation (Line(
      points={{-40,39.3333},{-30,39.3333},{-30,30},{-10,30}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(phase1.pin_n, con3PlusNTo3_LV.threeWire[1])
                                                     annotation (Line(
      points={{10,50},{30,50},{30,40.6667},{40,40.6667}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(phase2.pin_n, con3PlusNTo3_LV.threeWire[2])
                                                     annotation (Line(
      points={{10,40},{40,40}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(phase3.pin_n, con3PlusNTo3_LV.threeWire[3])
                                                     annotation (Line(
      points={{10,30},{30,30},{30,39.3333},{40,39.3333}},
      color={85,170,255},
      smooth=Smooth.None));

  connect(voltageSource.pin_n, ground.pin) annotation (Line(
      points={{-80,4},{-80,-20}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(ground.pin, con3PlusNTo3_HV.fourWire[4]) annotation (Line(
      points={{-80,-20},{-70,-20},{-70,39.25},{-60,39.25}},
      color={85,170,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(ground.pin, pin_lv_n) annotation (Line(
      points={{-80,-20},{-80,-60},{100,-60}},
      color={85,170,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(voltageSource.pin_p, con3PlusNTo3_HV.fourWire[1]) annotation (Line(
      points={{-80,24},{-80,40.75},{-60,40.75}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(voltageSource.pin_p, con3PlusNTo3_HV.fourWire[2]) annotation (Line(
      points={{-80,24},{-80,40.25},{-60,40.25}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(voltageSource.pin_p, con3PlusNTo3_HV.fourWire[3]) annotation (Line(
      points={{-80,24},{-80,39.75},{-60,39.75}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(heatCapacitor.port, thermalResistor.port_a) annotation (Line(
      points={{20,1.77636e-015},{12,1.77636e-015},{12,-4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalResistor.port_b, heatCapacitor1.port) annotation (Line(
      points={{12,-24},{12,-28},{20,-28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor1.port, thermalResistor1.port_a) annotation (Line(
      points={{20,-28},{12,-28},{12,-32}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalCollector1.port_b, thermalResistor.port_a) annotation (Line(
      points={{12,4},{12,-4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(phase1.port_a, thermalCollector1.port_a[1]) annotation (Line(
      points={{2,52},{12,52},{12,24.6667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(phase2.port_a, thermalCollector1.port_a[2]) annotation (Line(
      points={{2,42},{12,42},{12,24}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(phase3.port_a, thermalCollector1.port_a[3]) annotation (Line(
      points={{2,32},{12,32},{12,23.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalResistor1.port_b, prescribedTemperature.port) annotation (Line(
      points={{12,-52},{12,-58}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(realExpression.y, prescribedTemperature.T) annotation (Line(
      points={{1,-90},{12,-90},{12,-80}},
      color={0,0,127},
      smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                          graphics), Documentation(info="<html>
      <p>Select the Rated Power for the Transformer as apparent power<b> Sn</b>! Only three-phase transformers!</p>
<p>This will set the winding impedance, which define the Joule losses and voltage drop over the transformer.</p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
         graphics={
        Line(
          points={{10,60},{10,-60},{10,-60}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{20,60},{20,-60},{20,-60}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-70,40},{-18,40},{0,30},{-20,20},{0,10},{-20,0},{0,-10},{-20,
              -20},{0,-30},{-20,-40},{-70,-40}},
          color={85,170,255},
          smooth=Smooth.None),
        Line(
          points={{48,60},{48,40},{30,30},{50,20},{30,10},{50,0},{30,-10},{50,
              -20},{30,-30},{50,-40},{50,-60}},
          color={85,170,255},
          smooth=Smooth.None),
        Line(
          points={{48,60},{100,60}},
          color={85,170,255},
          smooth=Smooth.None),
        Line(
          points={{50,-60},{100,-60}},
          color={85,170,255},
          smooth=Smooth.None),
        Ellipse(
          extent={{-90,20},{-50,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-70,40},{-70,20}},
          color={85,170,255},
          smooth=Smooth.None),
        Line(
          points={{-70,-20},{-70,-40}},
          color={85,170,255},
          smooth=Smooth.None),
        Line(
          points={{-82,2},{-78,10},{-74,10},{-68,-10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-60,-2},{-64,-10},{-68,-10},{-74,10}},
          color={0,0,0},
          smooth=Smooth.None)}));
end Transformer_MvLv;
