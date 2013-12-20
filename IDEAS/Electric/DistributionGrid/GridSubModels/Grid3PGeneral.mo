within IDEAS.Electric.DistributionGrid.GridSubModels;
model Grid3PGeneral

protected
  IDEAS.Electric.DistributionGrid.GridSubModels.GridOnly3P gridOnly3P(grid=grid)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  IDEAS.Electric.DistributionGrid.GridSubModels.Transformer transformer(
    Phases=3,
    Vsc=Vsc,
    Sn=Sn) if traPre
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  parameter Real gridFreq=50
    "Grid frequency: should normally not be changed when simulating belgian grids!";
  //   IDEAS.Electric.DistributionGrid.Components.CVoltageSource cVoltageSource[3](
  //       Vsource={VSource*(cos(Modelica.Constants.pi*2*i/3) + Modelica.ComplexMath.j
  //         *sin(Modelica.Constants.pi*2*i/3)) for i in 1:3})                                                          annotation (Placement(transformation(
  //         extent={{-10,-10},{10,10}},
  //         rotation=270,
  //         origin={-80,-30})));
  //   IDEAS.Electric.DistributionGrid.Components.CGround cGround
  //     annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource[3]
    voltageSource(
    each V=Modelica.ComplexMath.'abs'(VSource),
    phi={Modelica.ComplexMath.arg(VSource),Modelica.ComplexMath.arg(VSource) +
        2*Modelica.Constants.pi/3,Modelica.ComplexMath.arg(VSource) + 4*
        Modelica.Constants.pi/3},
    each f=gridFreq) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-72,-40})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));

public
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin[4,
    gridOnly3P.grid.nNodes] node4Lines
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));

  replaceable parameter IDEAS.Electric.Data.Interfaces.GridType grid(Pha=3)
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

  /***Everything related to the transfomer***/
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
  /***End of everything related to the transformer***/

  /***Output total power***/
  output Modelica.SIunits.ActivePower PGriTot=gridOnly3P.PGriTot;
  output Modelica.SIunits.ComplexPower SGriTot=gridOnly3P.SGriTot;
  output Modelica.SIunits.ReactivePower QGriTot=gridOnly3P.QGriTot;
  output Modelica.SIunits.ActivePower PGriTotPha[3]=gridOnly3P.PGriTotPha;
  output Modelica.SIunits.ComplexPower SGriTotPha[3]=gridOnly3P.SGriTotPha;
  output Modelica.SIunits.ReactivePower QGriTotPha[3]=gridOnly3P.QGriTotPha;

  output Modelica.SIunits.Voltage Vabs[3, Nodes]=gridOnly3P.Vabs;

  /***Output the Losses***/
  output Modelica.SIunits.ActivePower PLosBra[3, Nodes]=gridOnly3P.PLosBra;
  output Modelica.SIunits.ActivePower PLosNeu[Nodes]=gridOnly3P.PLosNeu;
  output Modelica.SIunits.ActivePower PGriLosPha[3]=gridOnly3P.PGriLosPha;
  output Modelica.SIunits.ActivePower PGriLosNeu=gridOnly3P.PGriLosNeu;
  output Modelica.SIunits.ActivePower PGriLosPhaTot=gridOnly3P.PGriLosPhaTot;
  output Modelica.SIunits.ActivePower PGriLosTot=gridOnly3P.PGriLosTot;

  /***And the Transformer losses if present***/
  output Modelica.SIunits.ActivePower traLosP0=transformer.traLosP0 if traPre;
  output Modelica.SIunits.ActivePower traLosPs=transformer.traLosPs if traPre;
  output Modelica.SIunits.ActivePower traLosPtot=transformer.traLosPtot if
    traPre;

  output Modelica.SIunits.ComplexCurrent[3] Ibranch0={gridOnly3P.branch[p, 1].i
      for p in 1:3};
  output Modelica.SIunits.Current Ibranch0Abs[3]={Modelica.ComplexMath.'abs'(
      Ibranch0[i]) for i in 1:3};
  output Modelica.SIunits.ComplexCurrent Ineutral0=gridOnly3P.neutral[1].i;
  output Modelica.SIunits.Current Ineutral0Abs=Modelica.ComplexMath.'abs'(
      Ineutral0);

protected
  parameter Integer Nodes=grid.nNodes;

  IDEAS.Electric.BaseClasses.Con3PlusNTo3 con3PlusNTo3_1[gridOnly3P.grid.nNodes]
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
public
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin[3,
    gridOnly3P.grid.nNodes] nodes3Phase
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation
  for i in 1:3 loop
    connect(voltageSource[i].pin_n, ground.pin) annotation (Line(
        points={{-72,-50},{-72,-63},{-10,-63},{-10,-70}},
        color={0,0,255},
        smooth=Smooth.None));
  end for;

  if traPre then
    connect(transformer.LVPos, gridOnly3P.TraPin) annotation (Line(
        points={{-20,4},{0,4}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(voltageSource.pin_p, transformer.HVpos) annotation (Line(
        points={{-72,-30},{-72,4},{-40,4}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(ground.pin, transformer.HVgnd) annotation (Line(
        points={{-10,-70},{-50,-70},{-50,-4},{-40,-4}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(transformer.LVgnd, gridOnly3P.TraGnd) annotation (Line(
        points={{-20,-4},{0,-4}},
        color={0,0,255},
        smooth=Smooth.None));
  else
    connect(voltageSource.pin_p, gridOnly3P.TraPin) annotation (Line(
        points={{-72,-30},{-92,-30},{-92,20},{0,20},{0,4}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(ground.pin, gridOnly3P.TraGnd) annotation (Line(
        points={{-10,-70},{0,-70},{0,-4}},
        color={0,0,255},
        smooth=Smooth.None));
  end if;

  connect(gridOnly3P.node, node4Lines) annotation (Line(
      points={{20,0},{60,0}},
      color={0,0,255},
      smooth=Smooth.None));

  for n in 1:gridOnly3P.grid.nNodes loop
    connect(node4Lines[:, n], con3PlusNTo3_1[n].fourWire) annotation (Line(
        points={{60,0},{70,0}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(con3PlusNTo3_1[n].threeWire, nodes3Phase[:, n]) annotation (Line(
        points={{90,0},{100,0}},
        color={85,170,255},
        smooth=Smooth.None));
  end for;

  annotation (Diagram(graphics), Icon(graphics={
        Polygon(
          points={{-32,40},{-32,34},{-4,34},{-4,-80},{4,-80},{4,34},{34,34},{34,
              40},{4,40},{4,46},{-4,46},{-4,40},{-32,40}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={127,0,0}),
        Line(
          points={{-102,4},{-46,12},{-28,36}},
          color={127,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{-100,0},{-12,12},{30,36}},
          color={127,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{-22,36},{30,2},{100,0}},
          color={127,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{30,36},{54,18},{100,4}},
          color={127,0,0},
          smooth=Smooth.Bezier)}));
end Grid3PGeneral;
