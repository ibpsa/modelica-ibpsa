within IDEAS.Electric.DistributionGrid.Components;
model Grid1PGeneral

protected
  GridOnly1P gridOnly1P(grid=grid)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Transformer transformer(
    Phases=1,
    Vsc=Vsc,
    Sn=Sn) if traPre
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  /**ELECTA.DistributionGrid.Components.CVoltageSource cVoltageSource(Vsource=
        VSource)                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,-30})));
  ELECTA.DistributionGrid.Components.CGround cGround
    annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));
  **/
  parameter Real gridFreq=50
    "Grid frequency: should normally not be changed when simulating belgian grids!";
public
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin node[
    gridOnly1P.grid.nNodes]
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  replaceable parameter IDEAS.Electric.Data.Interfaces.GridType grid(Pha=1)
    "Choose a grid Layout" annotation (choicesAllMatching=true);
  /*parameter Boolean Loss = true 
    "if true, PLosBra and PGriLosTot gives branch and Grid cable losses"
    annotation(choices(
      choice=true "Calculate Cable Losses",
      choice=false "Do not Calculate Cable Losses",
      __Dymola_radioButtons=true));*/

  parameter Modelica.SIunits.ComplexVoltage VSource=230 + 0*Modelica.ComplexMath.j "Voltage"
              annotation (choices(
      choice=(230*1) + 0*MCM.j "100% at HVpin of transformer",
      choice=(230*1.02) + 0*MCM.j "102% at HVpin of transformer",
      choice=(230*1.05) + 0*MCM.j "105% at HVpin of transformer",
      choice=(230*1.1) + 0*MCM.j "110% at HVpin of transformer",
      choice=(230*0.95) + 0*MCM.j "95% at HVpin of transformer",
      choice=(230*0.9) + 0*MCM.j "90% at HVpin of transformer"));

  /**Everything related to the transformer**/
  parameter Boolean traPre=false "Select if transformer is present or not"
    annotation (choices(
      choice=false "No Transformer",
      choice=true "Transformer present",
      __Dymola_radioButtons=true));

  parameter Modelica.SIunits.ApparentPower Sn=160000 if traPre
    "The apparent power of the transformer (if present)" annotation (choices(
      choice=100000 "100 kVA",
      choice=160000 "160 kVA",
      choice=250000 "250 kVA",
      choice=400000 "400 kVA",
      choice=630000 "630 kVA"));

  parameter Real Vsc=4 if traPre
    "% percentage Short Circuit Voltage of the transformer (if present)"
    annotation (choices(
      choice=3 "3%",
      choice=4 "4%",
      __Dymola_radioButtons=true));
  /**End of everything related to the transformer**/

  /***Output the cable losses of the grid***/
  Modelica.SIunits.ActivePower PLosBra[Nodes]=gridOnly1P.PLosBra;
  Modelica.SIunits.ActivePower PGriLosTot=gridOnly1P.PGriLosTot;

  Modelica.SIunits.Voltage Vabs[Nodes]=gridOnly1P.Vabs;

  /***Output the losses of the trafo if presen***/
  Modelica.SIunits.ActivePower traLosP0=transformer.traLosP0 if traPre;
  Modelica.SIunits.ActivePower traLosPs=transformer.traLosPs if traPre;
  Modelica.SIunits.ActivePower traLosPtot=transformer.traLosPtot if traPre;

  /***Output the total power exchange of the grid***/
  Modelica.SIunits.ActivePower PGriTot=gridOnly1P.PGriTot;
  Modelica.SIunits.ComplexPower SGriTot=gridOnly1P.SGriTot;
  Modelica.SIunits.ReactivePower QGriTot=gridOnly1P.QGriTot;

  Modelica.SIunits.ComplexCurrent Ibranch0=gridOnly1P.branch[1].i;
  Modelica.SIunits.Current Ibranch0Abs=Modelica.ComplexMath.'abs'(Ibranch0);
protected
  parameter Integer Nodes=grid.nNodes;

public
  Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource
    voltageSource(
    V=Modelica.ComplexMath.'abs'(VSource),
    phi=Modelica.ComplexMath.arg(VSource),
    f=gridFreq) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,-30})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));
equation
  connect(voltageSource.pin_n, ground.pin) annotation (Line(
      points={{-70,-40},{-70,-57},{0,-57},{0,-60}},
      color={85,170,255},
      smooth=Smooth.None));

  if traPre then
    connect(transformer.LVPos[1], gridOnly1P.TraPin) annotation (Line(
        points={{-20,6},{0,6},{0,0},{20,0}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(voltageSource.pin_p, transformer.HVpos[1]) annotation (Line(
        points={{-70,-20},{-70,4},{-36,4}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(ground.pin, transformer.HVgnd) annotation (Line(
        points={{0,-60},{-8,-60},{-8,-36},{-56,-36},{-56,-4},{-36,-4}},
        color={85,170,255},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
  else
    connect(voltageSource.pin_p, gridOnly1P.TraPin) annotation (Line(
        points={{-70,-20},{-92,-20},{-92,26},{12,26},{12,0},{20,0}},
        color={85,170,255},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
  end if;

  connect(gridOnly1P.node, node) annotation (Line(
      points={{40,0},{100,0}},
      color={85,170,255},
      smooth=Smooth.None));

  annotation (Diagram(graphics), Icon(graphics={
        Line(
          points={{-22,36},{30,2},{100,0}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Polygon(
          points={{-32,40},{-32,34},{-4,34},{-4,-80},{4,-80},{4,34},{34,34},{34,
              40},{4,40},{4,46},{-4,46},{-4,40},{-32,40}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={127,0,0}),
        Line(
          points={{-102,4},{-46,12},{-28,36}},
          color={0,0,0},
          smooth=Smooth.Bezier)}));
end Grid1PGeneral;
