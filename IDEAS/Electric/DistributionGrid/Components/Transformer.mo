within IDEAS.Electric.DistributionGrid.Components;
model Transformer
  "This transfomer can be used in a single phase equivalent circuit or 3 phase"

  // Input parameters //////////////////////////////////////////////////////////////////////////////////////////////
  parameter Modelica.SIunits.ApparentPower Sn=160000
    "Apparant transformer power" annotation (choices(
      choice=100000 "100 kVA",
      choice=160000 "160 kVA",
      choice=250000 "250 kVA",
      choice=400000 "400 kVA",
      choice=630000 "630 kVA"));
  parameter Real Vsc=4 "Short circuit voltage percentage of the transormer"
    annotation (choices(
      choice=3 "3%",
      choice=4 "4%",
      __Dymola_radioButtons=true));
  parameter Integer Phases=1 "Number of phases simulated" annotation (choices(
      choice=1 "Single Phase",
      choice=3 "3 Phase",
      __Dymola_radioButtons=true));

  final parameter Modelica.SIunits.ActivePower P0=if Sn == 100000 then 190
       elseif Sn == 160000 then 260 elseif Sn == 250000 then 365 elseif Sn ==
      400000 then 515 elseif Sn == 630000 then 745 else 190;
  final parameter Modelica.SIunits.ComplexImpedance Zs=(Phases/3)*(((400*Vsc/
      100)^2)/3)/(Sn*(Vsc/100)/3) + 0*Modelica.ComplexMath.j;
  final parameter Modelica.SIunits.ComplexImpedance Zpar=(Phases/3)*(((400/sqrt(
      3))^2)/(P0/3)) + 0*Modelica.ComplexMath.j;

  // Output variables //////////////////////////////////////////////////////////////////////////////////////////////
  Modelica.SIunits.ActivePower traLosP0=sum(Zp.R .* Modelica.ComplexMath.'abs'(
      Zp.i) .* Modelica.ComplexMath.'abs'(Zp.i))
    "Static power loss at zero load";
  Modelica.SIunits.ActivePower traLosPs=sum(ZsHV.R .*
      Modelica.ComplexMath.'abs'(ZsHV.i) .* Modelica.ComplexMath.'abs'(ZsHV.i)
       + ZsLV.R .* Modelica.ComplexMath.'abs'(ZsLV.i) .*
      Modelica.ComplexMath.'abs'(ZsLV.i)) "Load dependent transformer losses";
  Modelica.SIunits.ActivePower traLosPtot=traLosP0 + traLosPs
    "Total resistive power losses in the transormer";

  // Protected variables ///////////////////////////////////////////////////////////////////////////////////////////
protected
  IDEAS.Electric.DistributionGrid.BaseClasses.Branch ZsHV[Phases](each R=
        Modelica.ComplexMath.real(Zs)/2, each X=Modelica.ComplexMath.imag(Zs)/2)
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  IDEAS.Electric.DistributionGrid.BaseClasses.Branch ZsLV[Phases](each R=
        Modelica.ComplexMath.real(Zs)/2, each X=Modelica.ComplexMath.imag(Zs)/2)
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  IDEAS.Electric.DistributionGrid.BaseClasses.Branch Zp[Phases](each R=
        Modelica.ComplexMath.real(Zpar), each X=Modelica.ComplexMath.imag(Zpar))
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,0})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin pin_p[
    Phases] annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin pin_n
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

  // Connection variables //////////////////////////////////////////////////////////////////////////////////////////
public
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin[Phases]
    HVpos(i(re(each start=-230/Modelica.ComplexMath.real(Zpar)), im(each start=
            0)))
    annotation (Placement(transformation(extent={{-70,30},{-50,50}}),
        iconTransformation(extent={{-70,30},{-50,50}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin HVgnd
    "Connect this to the voltage source negative pin / ground"
    annotation (Placement(transformation(extent={{-70,-50},{-50,-30}}),
        iconTransformation(extent={{-70,-50},{-50,-30}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin LVPos[
    Phases] annotation (Placement(transformation(extent={{90,50},{110,70}}),
        iconTransformation(extent={{90,50},{110,70}})));

  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin LVgnd
    "This should NOT be connected for single phase equivalent circuits"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}}),
        iconTransformation(extent={{90,-70},{110,-50}})));

equation
  for i in 1:Phases loop
    connect(Zp[i].pin_n, pin_n) annotation (Line(
        points={{-1.77636e-015,-10},{-1.77636e-015,-29.5},{0,-29.5},{0,-40}},
        color={0,0,255},
        smooth=Smooth.None));
  end for;
  connect(HVgnd, pin_n) annotation (Line(
      points={{-60,-40},{0,-40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pin_n, LVgnd) annotation (Line(
      points={{0,-40},{50,-40},{50,-60},{100,-60}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(ZsHV.pin_n, pin_p) annotation (Line(
      points={{-40,40},{0,40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pin_p, ZsLV.pin_p) annotation (Line(
      points={{0,40},{40,40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(HVpos, ZsHV.pin_p) annotation (Line(
      points={{-60,40},{-60,40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(ZsLV.pin_n, LVPos) annotation (Line(
      points={{60,40},{80,40},{80,60},{100,60}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pin_p, Zp.pin_p) annotation (Line(
      points={{0,40},{0,10},{1.77636e-015,10}},
      color={0,0,255},
      smooth=Smooth.None));

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
            graphics),
    Documentation(info="<html>
<p>Select the Rated Power for the Transformer as apparentpower<b> Sn</b>!</p>
<p>This will set the series and parallel impedances (only resistance for now).</p>
<p>Select the percentage Short Circuit Voltage <b>Vsc</b>, default is 4&percnt;, which normally should not be changed</p>
<p>Select the number of <b>Phases</b> that are being simulated (1 for singel phase equivalent circuit, 3 for full 3 phase simulations).</p>
<p>This will adjust the impedances to make the calculation of losses and voltage drop relevant.</p>
<p>Connect the HVgnd to the ground and negative pin of the voltage source (which should be at LV, being 230V phase voltage). LVgnd is present for completeness, but should NOT be connected to the ground of the source!</p>
<p>Connect the (3 if necessary) positive pin of the voltage source(s) to the HVpos pin(s).</p>
<p>Connect the LVpos pin(s) to the grid&apos;s pin(s) 0.</p>
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
          smooth=Smooth.None)}));
end Transformer;
