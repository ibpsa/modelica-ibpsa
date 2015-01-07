within IDEAS.Electric.DistributionGrid.GridSubModels;
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
    annotation (Placement(transformation(extent={{-80,-20},{-40,20}})));
  IDEAS.Electric.BaseClasses.Con3PlusNTo3 con3PlusNTo3_LV
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={60,-3.55271e-015})));

  Components.Branch phase1(R=Modelica.ComplexMath.real(transformer.Zd), X=
        Modelica.ComplexMath.imag(transformer.Zd))
                annotation (Placement(transformation(extent={{-10,6},{10,12}})));
  Components.Branch phase2(R=Modelica.ComplexMath.real(transformer.Zi), X=
        Modelica.ComplexMath.imag(transformer.Zi))
                annotation (Placement(transformation(extent={{-10,-2},{10,4}})));
  Components.Branch phase3(R=Modelica.ComplexMath.real(transformer.Z0), X=
        Modelica.ComplexMath.imag(transformer.Z0))
    annotation (Placement(transformation(extent={{-10,-10},{10,-4}})));

  Modelica.SIunits.ActivePower traLosP0 = transformer.P0
    "No-load losses (can be assumed constant)";
  Modelica.SIunits.ActivePower[3] traLosPha "Joule losses in phase windings";
  Modelica.SIunits.ActivePower traLosPTot = transformer.P0 + traLosPha[1] + traLosPha[2] + traLosPha[3]
    "Total losses in transformer";

equation
  traLosPha[1] = phase1.R*(Modelica.ComplexMath.'abs'(phase1.i))^2;
  traLosPha[2] = phase2.R*(Modelica.ComplexMath.'abs'(phase2.i))^2;
  traLosPha[3] = phase3.R*(Modelica.ComplexMath.'abs'(phase3.i))^2;

  connect(pin_hv_p[1], con3PlusNTo3_HV.fourWire[1])
                                                annotation (Line(
      points={{-100,33.3333},{-90,33.3333},{-90,-1.5},{-80,-1.5}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(pin_hv_p[2], con3PlusNTo3_HV.fourWire[2])
                                                annotation (Line(
      points={{-100,40},{-90,40},{-90,-0.5},{-80,-0.5}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(pin_hv_p[3], con3PlusNTo3_HV.fourWire[3])
                                                annotation (Line(
      points={{-100,46.6667},{-90,46.6667},{-90,0.5},{-80,0.5}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(pin_hv_n, con3PlusNTo3_HV.fourWire[4])
                                             annotation (Line(
      points={{-100,-40},{-90,-40},{-90,1.5},{-80,1.5}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(pin_lv_p[1], con3PlusNTo3_LV.fourWire[1])
                                                annotation (Line(
      points={{100,33.3333},{90,33.3333},{90,1.5},{80,1.5}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(pin_lv_p[2], con3PlusNTo3_LV.fourWire[2])
                                                annotation (Line(
      points={{100,40},{90,40},{90,0.5},{80,0.5}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(pin_lv_p[3], con3PlusNTo3_LV.fourWire[3])
                                                annotation (Line(
      points={{100,46.6667},{90,46.6667},{90,-0.5},{80,-0.5}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(pin_lv_n, con3PlusNTo3_LV.fourWire[4])
                                             annotation (Line(
      points={{100,-40},{90,-40},{90,-1.5},{80,-1.5}},
      color={85,170,255},
      smooth=Smooth.None));

  connect(con3PlusNTo3_HV.threeWire[1], phase1.pin_p)
                                                     annotation (Line(
      points={{-40,-1.33333},{-26,-1.33333},{-26,9},{-10,9}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(con3PlusNTo3_HV.threeWire[2], phase2.pin_p)
                                                     annotation (Line(
      points={{-40,1.11022e-016},{-32.5,1.11022e-016},{-32.5,1},{-10,1}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(con3PlusNTo3_HV.threeWire[3], phase3.pin_p)
                                                     annotation (Line(
      points={{-40,1.33333},{-26,1.33333},{-26,-7},{-10,-7}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(phase1.pin_n, con3PlusNTo3_LV.threeWire[1])
                                                     annotation (Line(
      points={{10,9},{26,9},{26,1.33333},{40,1.33333}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(phase2.pin_n, con3PlusNTo3_LV.threeWire[2])
                                                     annotation (Line(
      points={{10,1},{26,1},{26,-1.22125e-015},{40,-1.22125e-015}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(phase3.pin_n, con3PlusNTo3_LV.threeWire[3])
                                                     annotation (Line(
      points={{10,-7},{26,-7},{26,-1.33333},{40,-1.33333}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(pin_hv_n, pin_lv_n) annotation (Line(
      points={{-100,-40},{100,-40}},
      color={85,170,255},
      smooth=Smooth.None));

      annotation (Diagram(graphics), Documentation(info="<html>
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
