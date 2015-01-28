within IDEAS.Electric.Distribution.AC;
model Grid1PGeneral

protected
  Components.GridOnly1P gridOnly1P(grid=grid)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
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

public
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

  /***Everything related to the transfomer***/
  parameter Boolean traPre=true
    "Select if transformer is present or not (only true possible for now)";
//    parameter Boolean traPre=false "Select if transformer is present or not"
//      annotation (choices(
//        choice=false "No Transformer",
//        choice=true "Transformer present",
//        __Dymola_radioButtons=true));

  /***Output the cable losses of the grid***/
  Modelica.SIunits.ActivePower PLosBra[Nodes]=gridOnly1P.PLosBra;
  Modelica.SIunits.ActivePower PGriLosTot=gridOnly1P.PGriLosTot;

  Modelica.SIunits.Voltage Vabs[Nodes]=gridOnly1P.Vabs;

  /***Output the losses of the trafo if presen***/
  Modelica.SIunits.ActivePower traLosP0=transformer_MvLv.traLosP0 if traPre;
  Modelica.SIunits.ActivePower traLosPtot=transformer_MvLv.traLosPTot if traPre;

  /***Output the total power exchange of the grid***/
  Modelica.SIunits.ActivePower PGriTot=gridOnly1P.PGriTot;
  Modelica.SIunits.ComplexPower SGriTot=gridOnly1P.SGriTot;
  Modelica.SIunits.ReactivePower QGriTot=gridOnly1P.QGriTot;

  Modelica.SIunits.ComplexCurrent Ibranch0=gridOnly1P.branch[1].i;
  Modelica.SIunits.Current Ibranch0Abs=Modelica.ComplexMath.'abs'(Ibranch0);
protected
  parameter Integer Nodes=grid.nNodes;

public
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin[gridOnly1P.grid.nNodes] gridNodes1P
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Components.Transformer1P_MvLv transformer_MvLv(transformer=transformer)
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
    replaceable parameter IDEAS.Electric.Data.Interfaces.TransformerImp transformer
    "Choose a transformer" annotation (choicesAllMatching=true);
equation

  for n in 1:gridOnly1P.grid.nNodes loop
  end for;

  connect(transformer_MvLv.pin_lv_p,gridOnly1P. TraPin) annotation (Line(
      points={{0,4},{10,4},{10,0},{20,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(gridOnly1P.node, node) annotation (Line(
      points={{40,0},{100,0}},
      color={85,170,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(graphics={
        Line(
          points={{0,36},{24,12},{100,0}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{0,44},{24,16},{100,0}},
          color={85,170,255},
          smooth=Smooth.Bezier),
        Line(
          points={{32,36},{56,10},{102,0}},
          color={0,0,0},
          smooth=Smooth.Bezier),
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
          points={{-100,60},{-12,12},{30,36}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{-100,58},{-46,12},{-28,36}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{-100,60},{-42,12},{0,36}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{-100,-60},{-42,20},{0,44}},
          color={85,170,255},
          smooth=Smooth.Bezier)}));
end Grid1PGeneral;
