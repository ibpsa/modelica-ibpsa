within IDEAS.Electric.DistributionGrid.GridSubModels;
model Grid1PGeneral

protected
  IDEAS.Electric.DistributionGrid.GridSubModels.GridOnly1P gridOnly1P(grid=grid)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  IDEAS.Electric.DistributionGrid.GridSubModels.Transformer transformer(
    Phases=1,
    Vsc=Vsc,
    Sn=Sn) if traPre
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  IDEAS.Electric.DistributionGrid.GridSubModels.HouseConnectors houseConnectors(
    numPha=1,
    numNod=Nodes,
    typHouBran=typHouBran) if houCon
    annotation (Placement(transformation(extent={{56,12},{76,32}})));

  IDEAS.Electric.DistributionGrid.Components.CVoltageSource cVoltageSource(Vsource=
        VSource)                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,-30})));
  IDEAS.Electric.DistributionGrid.Components.CGround cGround
    annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));
public
IDEAS.Electric.BaseClasses.CPosPin
                node[gridOnly1P.grid.n]
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  replaceable parameter IDEAS.Electric.Data.Interfaces.GridType
                                               grid(Pha=1)
    "Choose a grid Layout"                                                           annotation(choicesAllMatching = true);
  /*parameter Boolean Loss = true 
    "if true, PLosBra and PGriLosTot gives branch and Grid cable losses"
    annotation(choices(
      choice=true "Calculate Cable Losses",
      choice=false "Do not Calculate Cable Losses",
      __Dymola_radioButtons=true));*/

  parameter Modelica.SIunits.ComplexVoltage VSource=230 + 0*Modelica.ComplexMath.j "Voltage"
    annotation(choices(
  choice=(230*1)+0*MCM.j "100% at HVpin of transformer",
  choice=(230*1.02)+0*MCM.j "102% at HVpin of transformer",
  choice=(230*1.05)+0*MCM.j "105% at HVpin of transformer",
  choice=(230*1.1)+0*MCM.j "110% at HVpin of transformer",
  choice=(230*0.95)+0*MCM.j "95% at HVpin of transformer",
  choice=(230*0.9)+0*MCM.j "90% at HVpin of transformer"));

/**Everything related to the transformer**/
  parameter Boolean traPre = false "Select if transformer is present or not"
  annotation(choices(
  choice=false "No Transformer",
  choice=true "Transformer present",
  __Dymola_radioButtons=true));

  parameter Modelica.SIunits.ApparentPower Sn=160000 if  traPre
    "The apparent power of the transformer (if present)"
     annotation(choices(
        choice=100000 "100 kVA",
        choice=160000 "160 kVA",
        choice=250000 "250 kVA",
        choice=400000 "400 kVA",
        choice=630000 "630 kVA"));

  parameter Real Vsc=4 if  traPre
    "% percentage Short Circuit Voltage of the transformer (if present)"
     annotation(choices(
      choice=3 "3%",
      choice=4 "4%",
      __Dymola_radioButtons=true));
/**End of everything related to the transformer**/

parameter Boolean houCon=false
    "Select if cables for houseconnection should be simulated or not"
annotation(choices(
  choice=false "No houseconnections simulated",
  choice=true "Houseconnections simulated",
  __Dymola_radioButtons=true));

parameter Boolean difConTyp=false
    "Select if different types of cable connections are used for the houseconnections"
annotation(choices(
  choice=false "Houseconnections use same cable type(typ1houBran)",
  choice=true "Different types of cable are used (typHouBranDif)",
  __Dymola_radioButtons=true));
  //  choice=true "Different types",

replaceable parameter IDEAS.Electric.Data.Interfaces.Cable
                                           typ1HouBran=IDEAS.Electric.Data.Cables.PvcAl16()
    "If only 1 type of cable is used in houseconnections, select it here"
annotation(choices(
choice=IDEAS.Electric.Data.Cables.PvcAl16() "PVC Aluminum 16 mm^2",
choice=IDEAS.Electric.Data.Cables.PvcAl25() "PVC Aluminum 25 mm^2"));
replaceable parameter IDEAS.Electric.Data.Interfaces.Cable[
                                           Nodes] typHouBranDif={IDEAS.Electric.Data.Cables.PvcAl16()
                                                                                                 for i in 1:Nodes}
    "Give the array of cable connection types if different types of cables are used";

/***Output the cable losses of the grid***/
output Modelica.SIunits.ActivePower PLosBra[Nodes]=gridOnly1P.PLosBra;
output Modelica.SIunits.ActivePower PGriLosTot=gridOnly1P.PGriLosTot;

output Modelica.SIunits.Voltage Vabs[Nodes]=gridOnly1P.Vabs;

/***Output the losses of the trafo if presen***/
output Modelica.SIunits.ActivePower traLosP0=transformer.traLosP0 if traPre;
output Modelica.SIunits.ActivePower traLosPs=transformer.traLosPs if traPre;
output Modelica.SIunits.ActivePower traLosPtot=transformer.traLosPtot if traPre;

/***And the losses in the houseconnections***/
output Modelica.SIunits.ActivePower PLosHouCon[Nodes]=houseConnectors.PLosHouCon if
       houCon;
output Modelica.SIunits.ActivePower PLosHouConTot=houseConnectors.PLosHouConTot if
       houCon;

/***Output the total power exchange of the grid***/
  output Modelica.SIunits.ActivePower PGriTot=gridOnly1P.PGriTot;
  output Modelica.SIunits.ComplexPower SGriTot=gridOnly1P.SGriTot;
  output Modelica.SIunits.ReactivePower QGriTot=gridOnly1P.QGriTot;

  output Modelica.SIunits.ComplexCurrent Ibranch0=gridOnly1P.branch[1].i;
  output Modelica.SIunits.Current Ibranch0Abs=Modelica.ComplexMath.'abs'(
                                                        Ibranch0);
protected
  parameter Integer Nodes=grid.n;
  parameter IDEAS.Electric.Data.Interfaces.Cable
                                 typHouBran[Nodes]= (if not difConTyp then fill(typ1HouBran,Nodes) else typHouBranDif);
equation
  connect(cVoltageSource.n, cGround.p) annotation (Line(
      points={{-80,-40},{-80,-60}},
      color={0,0,255},
      smooth=Smooth.None));

  if traPre then
  connect(transformer.LVPos[1], gridOnly1P.TraPin) annotation (Line(
      points={{-20,4},{20,4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(cVoltageSource.p, transformer.HVpos[1]) annotation (Line(
      points={{-80,-20},{-80,4},{-40,4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(cGround.p, transformer.HVgnd) annotation (Line(
      points={{-80,-60},{-50,-60},{-50,-4},{-40,-4}},
      color={0,0,255},
      smooth=Smooth.None));
  else
  connect(cVoltageSource.p, gridOnly1P.TraPin) annotation (Line(
      points={{-80,-20},{-92,-20},{-92,20},{20,20},{20,4}},
      color={0,0,255},
      smooth=Smooth.None));
  end if;

if houCon then
  connect(gridOnly1P.node, houseConnectors.griCon[1, :]) annotation (Line(
      points={{40,0},{48,0},{48,22},{56,22}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(houseConnectors.houCon[1, :], node)
   annotation (Line(
      points={{76,22},{88,22},{88,0},{100,0}},
      color={0,0,255},
      smooth=Smooth.None));
else
   connect(gridOnly1P.node, node) annotation (Line(
      points={{40,0},{100,0}},
      color={0,0,255},
      smooth=Smooth.None));
end if;

annotation (Diagram(graphics), Icon(graphics={Bitmap(extent={{-100,100},{102,
              -100}}, fileName=
              "modelica://ELECTA/icon-ssnav-08-electricity.jpg")}));
end Grid1PGeneral;
