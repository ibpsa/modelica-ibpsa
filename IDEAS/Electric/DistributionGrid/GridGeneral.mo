within IDEAS.Electric.DistributionGrid;
model GridGeneral
  "THE General grid to use, look at the documentation for naming etc."

  parameter Integer Phases=1 "Number of phases simulated" annotation (choices(
      choice=1 "Single Phase",
      choice=3 "3 Phase",
      __Dymola_radioButtons=true));

  /*******No gridinfo should be needed anymore********/
  replaceable parameter IDEAS.Electric.Data.Interfaces.GridType grid(Pha=Phases)
    "Choose a grid Layout" annotation (choicesAllMatching=true);

  parameter Modelica.SIunits.ComplexVoltage VSource=(230*1) + 0*Modelica.ComplexMath.j
    "Voltage at node 1" annotation (choices(
      choice=(230*1) + 0*MCM.j "100% at transformer",
      choice=(230*1.02) + 0*MCM.j "102% at transformer",
      choice=(230*1.05) + 0*MCM.j "105% at transformer",
      choice=(230*1.1) + 0*MCM.j "110% at transformer",
      choice=(230*0.95) + 0*MCM.j "95% at transformer",
      choice=(230*0.9) + 0*MCM.j "90% at transformer"));

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

protected
  parameter Integer Nodes=grid.nNodes;

protected
  IDEAS.Electric.DistributionGrid.Components.Grid1PGeneral grid1PGeneral(
    grid=grid,
    VSource=VSource,
    traPre=traPre,
    Sn=Sn,
    Vsc=Vsc) if Phases == 1
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  IDEAS.Electric.DistributionGrid.Components.Grid3PGeneral grid3PGeneral(
    grid=grid,
    VSource=VSource,
    traPre=traPre,
    Sn=Sn,
    Vsc=Vsc) if Phases == 3
    annotation (Placement(transformation(extent={{-60,-22},{-40,-2}})));

public
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin
    gridNodes3P[3, grid.nNodes] if Phases == 3
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin
    gridNodes[grid.nNodes] if Phases == 1
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  output Modelica.SIunits.ActivePower PLosBra[Nodes]=grid1PGeneral.PLosBra if
    Phases == 1;
  output Modelica.SIunits.ActivePower PGriLosTot=grid1PGeneral.PGriLosTot if
    Phases == 1;

  output Modelica.SIunits.ActivePower PGriTot=grid1PGeneral.PGriTot if Phases
     == 1;
  output Modelica.SIunits.ComplexPower SGriTot=grid1PGeneral.SGriTot if Phases
     == 1;
  output Modelica.SIunits.ReactivePower QGriTot=grid1PGeneral.QGriTot if Phases
     == 1;

  output Modelica.SIunits.ActivePower traLosP0=grid1PGeneral.traLosP0 if traPre
     and Phases == 1;
  output Modelica.SIunits.ActivePower traLosPs=grid1PGeneral.traLosPs if traPre
     and Phases == 1;
  output Modelica.SIunits.ActivePower traLosPtot=grid1PGeneral.traLosPtot if
    traPre and Phases == 1;

  output Modelica.SIunits.ActivePower PGriTot3=grid3PGeneral.PGriTot if Phases
     == 3;
  output Modelica.SIunits.ComplexPower SGriTot3=grid3PGeneral.SGriTot if Phases
     == 3;
  output Modelica.SIunits.ReactivePower QGriTot3=grid3PGeneral.QGriTot if
    Phases == 3;

  output Modelica.SIunits.ActivePower PGriTotPha[3]=grid3PGeneral.PGriTotPha if
       Phases == 3;
  output Modelica.SIunits.ComplexPower SGriTotPha[3]=grid3PGeneral.SGriTotPha if
       Phases == 3;
  output Modelica.SIunits.ReactivePower QGriTotPha[3]=grid3PGeneral.QGriTotPha if
       Phases == 3;

  output Modelica.SIunits.ActivePower PLosBra3[3, Nodes]=grid3PGeneral.PLosBra if
       Phases == 3;
  output Modelica.SIunits.ActivePower PLosNeu[Nodes]=grid3PGeneral.PLosNeu if
    Phases == 3;
  output Modelica.SIunits.ActivePower PGriLosPha[3]=grid3PGeneral.PGriLosPha if
       Phases == 3;
  output Modelica.SIunits.ActivePower PGriLosNeu=grid3PGeneral.PGriLosNeu if
    Phases == 3;
  output Modelica.SIunits.ActivePower PGriLosPhaTot=grid3PGeneral.PGriLosPhaTot if
       Phases == 3;
  output Modelica.SIunits.ActivePower PGriLosTot3=grid3PGeneral.PGriLosTot if
    Phases == 3;

  output Modelica.SIunits.ActivePower traLosP03=grid3PGeneral.traLosP0 if
    traPre and Phases == 3;
  output Modelica.SIunits.ActivePower traLosPs3=grid3PGeneral.traLosPs if
    traPre and Phases == 3;
  output Modelica.SIunits.ActivePower traLosPtot3=grid3PGeneral.traLosPtot if
    traPre and Phases == 3;

  output Modelica.SIunits.Voltage Vabs3[3, Nodes]=grid3PGeneral.Vabs if Phases
     == 3;
  output Modelica.SIunits.Voltage Vabs[Nodes]=grid1PGeneral.Vabs if Phases == 1;

  output Modelica.SIunits.ComplexCurrent Ibranch03P[3]=grid3PGeneral.Ibranch0 if
       Phases == 3;
  output Modelica.SIunits.Current Ibranch0Abs3P[3]={Modelica.ComplexMath.'abs'(
      Ibranch03P[i]) for i in 1:3} if Phases == 3;
  output Modelica.SIunits.ComplexCurrent Ineutral0=grid3PGeneral.Ineutral0 if
    Phases == 3;
  output Modelica.SIunits.Current Ineutral0Abs=Modelica.ComplexMath.'abs'(
      Ineutral0) if Phases == 3;

  output Modelica.SIunits.ComplexCurrent Ibranch0=grid1PGeneral.Ibranch0 if
    Phases == 1;
  output Modelica.SIunits.Current Ibranch0Abs=Modelica.ComplexMath.'abs'(
      Ibranch0) if Phases == 1;

equation
  connect(grid3PGeneral.nodes3Phase, gridNodes3P) annotation (Line(
      points={{-40,-12},{30,-12},{30,0},{100,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(grid1PGeneral.node, gridNodes) annotation (Line(
      points={{-40,30},{30,30},{30,0},{100,0}},
      color={0,0,255},
      smooth=Smooth.None));

  annotation (
    Diagram(graphics),
    Icon(graphics={
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
          smooth=Smooth.Bezier)}),
    Documentation(info="<html>
<p>This is THE general grid to use!</p>
<p>You can set these parameters (all possible graphically):</p>
<p><ul>
<li>the number of phases using <b>Phases</b></li>
<li>the grid layout using <b>grid</b></li>
<li>the voltage at node 1 using <b>VSource</b></li>
<li>Wether or not to implement a transformer using <b>traPre</b></li>
<li>If transformer: The nominal Power <b>Sn</b></li>
<li>If transformer: The percentage short circuit voltage <b>Vsc</b> (if needed to be changed)</li>
</ul></p>
<p>The connectors depend on the selection of single or 3 phase</p>
<p><ul>
<li>1 phase =&GT; gridNodes [number of nodes]</li>
<li>3 phase =&GT; gridNodes3 [3,number of nodes]</li>
</ul></p>
<p><br/>Total Power is given as:</p>
<p>For 1 phase:</p>
<p><ul>
<li>PGriTot (active)</li>
<li>QGriTot (reactive)</li>
<li>SGriTot (complex)</li>
</ul></p>
<p><br/>For 3 phase:</p>
<p><ul>
<li>PGriTot3 (active)</li>
<li>QGriTot3 (reactive)</li>
<li>SGriTot3 (complex)</li>
<li>PGriTotPha[3](active in each phase)</li>
<li>QGriTotPha[3](passive in each phase)</li>
<li>SGriTotPha[3](complex in each phase)</li>
</ul></p>
<p><br/>The Loss power is given as:</p>
<p>For 1 phase:</p>
<p><ul>
<li>PLosBra [number of branches/nodes]</li>
<li>PGriLosTot (total active power loss)</li>
</ul></p>
<p><br/>For 3 phase:</p>
<p><ul>
<li>PLosBra3[3,number of branches/nodes]</li>
<li>PLosNeu[number of branches/nodes] (loss in each neutral branch)</li>
<li>PGriLosPha[3] (total grid loss in each phase)</li>
<li>PGriLosNeu (total loss in neutral branches)</li>
<li>PGriLosPhaTot (total loss in phase branches)</li>
<li>PGriLosTot3 (<b>Total</b> grid loss)</li>
</ul></p>
</html>"));
end GridGeneral;
