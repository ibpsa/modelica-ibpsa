within IDEAS.Electric.DistributionGrid.Components;
model TransformerImp "This transfomer can be used for three-phase grids"

replaceable parameter IDEAS.Electric.Data.Interfaces.TransformerImp
                                                  transformer
    "Choose a transformer"   annotation(choicesAllMatching = true);

  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin
                  pin_hv_p[3]
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin
                  pin_hv_n
    "Connect this to the voltage source negative pin / ground"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin
                  pin_lv_p[3]
    annotation (Placement(transformation(extent={{90,30},{110,50}})));

  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin
                  pin_lv_n
    "This should NOT be connected for single phase equivalent circuits"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));

  IDEAS.Electric.BaseClasses.Con3PlusNTo3 con3PlusNTo3_HV
    annotation (Placement(transformation(extent={{-60,50},{-40,30}})));
  IDEAS.Electric.BaseClasses.Con3PlusNTo3 con3PlusNTo3_LV
    annotation (Placement(transformation(
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

equation
  connect(pin_hv_p, con3PlusNTo3_HV.fourWire[1:3])
                                                annotation (Line(
      points={{-100,40},{-100,39.75},{-60,39.75}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(pin_hv_n, con3PlusNTo3_HV.fourWire[4])
                                             annotation (Line(
      points={{-100,-40},{-92,-40},{-92,39.25},{-60,39.25}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(pin_lv_p, con3PlusNTo3_LV.fourWire[1:3])
                                                annotation (Line(
      points={{100,40},{100,39.75},{60,39.75}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(pin_lv_n, con3PlusNTo3_LV.fourWire[4])
                                             annotation (Line(
      points={{100,-40},{86,-40},{86,39.25},{60,39.25}},
      color={85,170,255},
      smooth=Smooth.None));

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
  connect(pin_hv_n, pin_lv_n) annotation (Line(
      points={{-100,-40},{100,-40}},
      color={85,170,255},
      smooth=Smooth.None));

      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                          graphics), Documentation(info="<html>
      <p>Select the Rated Power for the Transformer as apparent power<b> Sn</b>! Only three-phase transformers!</p>
<p>This will set the winding impedance, which define the Joule losses and voltage drop over the transformer.</p>
</html>"),
    Icon(graphics={
        Line(
          points={{-10,80},{-10,-80},{-10,-80}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{10,80},{10,-80},{10,-80}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-98,40},{-46,40},{-28,30},{-48,20},{-28,10},{-48,0},{-28,-10},
              {-48,-20},{-28,-30},{-48,-40},{-98,-40}},
          color={85,170,255},
          smooth=Smooth.None),
        Line(
          points={{100,40},{48,40},{30,30},{50,20},{30,10},{50,0},{30,-10},{50,
              -20},{30,-30},{50,-40},{100,-40}},
          color={85,170,255},
          smooth=Smooth.None)}));
end TransformerImp;
