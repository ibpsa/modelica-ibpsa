within IDEAS.Electric.DistributionGrid.GridSubModels;
model Transformer
  "This transfomer can be used in a single phase equivalent circuit or 3 phase"

parameter Modelica.SIunits.ApparentPower Sn=160000
 annotation(choices(
choice=100000 "100 kVA",
choice=160000 "160 kVA",
choice=250000 "250 kVA",
choice=400000 "400 kVA",
choice=630000 "630 kVA"));

parameter Real Vsc=4 "% percentage Short Circuit Voltage"
 annotation(choices(
choice=3 "3%",
choice=4 "4%",
__Dymola_radioButtons=true));

parameter Integer Phases=1 "Number of phases simulated"
 annotation(choices(
choice=1 "Single Phase",
choice=3 "3 Phase",
__Dymola_radioButtons=true));

  IDEAS.Electric.DistributionGrid.Components.Branch ZsHV[Phases](each R=
        Modelica.ComplexMath.real(Zs)/2, each X=Modelica.ComplexMath.imag(Zs)/2)
    annotation (Placement(transformation(extent={{-60,38},{-40,42}})));
  IDEAS.Electric.DistributionGrid.Components.Branch ZsLV[Phases](each R=
        Modelica.ComplexMath.real(Zs)/2, each X=Modelica.ComplexMath.imag(Zs)/2)
    annotation (Placement(transformation(extent={{40,38},{60,42}})));
  IDEAS.Electric.DistributionGrid.Components.Branch Zp[Phases](each R=
        Modelica.ComplexMath.real(Zpar), each X=Modelica.ComplexMath.imag(Zpar))
  annotation (Placement(transformation(
        extent={{-10,-3},{10,3}},
        rotation=270,
        origin={0,-11})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin
                  HVpos[Phases](i(
                                re(  each start=-230/Modelica.ComplexMath.real(
                                                              Zpar)), im(  each start=0)))
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin
                  HVgnd
    "Connect this to the voltage source negative pin / ground"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin
                  LVPos[Phases]
    annotation (Placement(transformation(extent={{90,30},{110,50}})));

  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin
                  LVgnd
    "This should NOT be connected for single phase equivalent circuits"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));

/***Transformer losses***/
Modelica.SIunits.ActivePower traLosP0;
Modelica.SIunits.ActivePower traLosPs;
Modelica.SIunits.ActivePower traLosPtot;

parameter Modelica.SIunits.ActivePower P0=
  if Sn==100000 then 190
  elseif Sn==160000 then 260
  elseif Sn==250000 then 365
  elseif Sn==400000 then 515
  elseif Sn==630000 then 745
  else 190;
protected
parameter Modelica.SIunits.ComplexImpedance Zs=(Phases/3)*(((400*Vsc/100)^2)/3)/(Sn*(Vsc/100)/3)+0*Modelica.ComplexMath.j;
parameter Modelica.SIunits.ComplexImpedance Zpar=(Phases/3)*(((400/sqrt(3))^2)/(P0/3))+0*Modelica.ComplexMath.j;
protected
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin
                  pin_p[Phases]
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin
                  pin_n
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
equation
for i in 1:Phases loop
    connect(Zp[i].pin_n, pin_n) annotation (Line(
      points={{-1.83697e-015,-21},{-1.83697e-015,-29.5},{0,-29.5},{0,-40}},
      color={0,0,255},
      smooth=Smooth.None));
end for;
  connect(HVgnd, pin_n) annotation (Line(
      points={{-100,-40},{0,-40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pin_n, LVgnd) annotation (Line(
      points={{0,-40},{100,-40}},
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
      points={{-100,40},{-60,40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(ZsLV.pin_n, LVPos) annotation (Line(
      points={{60,40},{100,40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pin_p, Zp.pin_p) annotation (Line(
      points={{0,40},{0,19.5},{0,-1},{1.83697e-015,-1}},
      color={0,0,255},
      smooth=Smooth.None));
  traLosP0 = sum({(Zp[i].R*(Modelica.ComplexMath.'abs'(Zp[i].i))^2) for i in 1:
    Phases});
  traLosPs = sum({((ZsHV[i].R*(Modelica.ComplexMath.'abs'(ZsHV[i].i))^2) + (
    ZsLV[i].R*(Modelica.ComplexMath.'abs'(ZsLV[i].i))^2)) for i in 1:Phases});
traLosPtot=traLosP0+traLosPs;

annotation (Diagram(graphics), Documentation(info="<html>
<p>Select the Rated Power for the Transformer as apparentpower<b> Sn</b>!</p>
<p>This will set the series and parallel impedances (only resistance for now).</p>
<p>Select the percentage Short Circuit Voltage <b>Vsc</b>, default is 4&percnt;, which normally should not be changed</p>
<p>Select the number of <b>Phases</b> that are being simulated (1 for singel phase equivalent circuit, 3 for full 3 phase simulations).</p>
<p>This will adjust the impedances to make the calculation of losses and voltage drop relevant.</p>
<p>Connect the HVgnd to the ground and negative pin of the voltage source (which should be at LV, being 230V phase voltage). LVgnd is present for completeness, but should NOT be connected to the ground of the source!</p>
<p>Connect the (3 if necessary) positive pin of the voltage source(s) to the HVpos pin(s).</p>
<p>Connect the LVpos pin(s) to the grid&apos;s pin(s) 0.</p>
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
end Transformer;
