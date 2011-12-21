within IDEAS.Electric.DistributionGrid.GridSubModels;
model Grid3PGeneral

protected
  IDEAS.Electric.DistributionGrid.GridSubModels.GridOnly3P gridOnly3P(grid=grid)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  IDEAS.Electric.DistributionGrid.GridSubModels.Transformer transformer(
    Phases=3,
    Vsc=Vsc,
    Sn=Sn) if traPre
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  IDEAS.Electric.DistributionGrid.Components.CVoltageSource cVoltageSource[3](
      Vsource={VSource*(cos(Modelica.Constants.pi*2*i/3) + Modelica.ComplexMath.j
        *sin(Modelica.Constants.pi*2*i/3)) for i in 1:3})                                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,-30})));
  IDEAS.Electric.DistributionGrid.Components.CGround cGround
    annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));
  IDEAS.Electric.DistributionGrid.GridSubModels.HouseConnectors houseConnectors(
    numPha=4,
    numNod=Nodes,
    typHouBran=typHouBran,
    conPha=conPha) if houCon
    annotation (Placement(transformation(extent={{52,-30},{72,-10}})));

public
  IDEAS.Electric.BaseClasses.CPosPin
                  node[4,gridOnly3P.grid.n]
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

replaceable parameter IDEAS.Electric.Data.Interfaces.GridType
                                             grid(Pha=3) "Choose a grid Layout"
                                                                                     annotation(choicesAllMatching = true);
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

/***Everything related to the transfomer***/
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
 /***End of everything related to the transformer***/

/***Everything related to the houseconnections***/
parameter Boolean houCon=true
    "Select if cables for houseconnection should be simulated or not"
  annotation(choices(
  choice=false "No houseconnections simulated",
  choice=true "Houseconnections simulated",
  __Dymola_radioButtons=true));
parameter Integer[Nodes] conPha={4 for i in 1:Nodes}
    "Gives an array of lenth '# Nodes' with in it to which phase the house is connected (1 to 3) or 4 in case of 3 phase connection";
parameter Boolean difConTyp=false
    "Select if different types of cable connections are used for the houseconnections"
annotation(choices(
  choice=false "Houseconnections use same cable type(typ1houBran)",
  choice=true "Different types of cable are used (typHouBranDif)",
  __Dymola_radioButtons=true));
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

/***Output total power***/
output Modelica.SIunits.ActivePower PGriTot=gridOnly3P.PGriTot;
output Modelica.SIunits.ComplexPower SGriTot=gridOnly3P.SGriTot;
output Modelica.SIunits.ReactivePower QGriTot=gridOnly3P.QGriTot;
output Modelica.SIunits.ActivePower PGriTotPha[3]=gridOnly3P.PGriTotPha;
output Modelica.SIunits.ComplexPower SGriTotPha[3]=gridOnly3P.SGriTotPha;
output Modelica.SIunits.ReactivePower QGriTotPha[3]=gridOnly3P.QGriTotPha;

output Modelica.SIunits.Voltage Vabs[3,Nodes]=gridOnly3P.Vabs;

/***Output the Losses***/
output Modelica.SIunits.ActivePower PLosBra[3,Nodes]=gridOnly3P.PLosBra;
output Modelica.SIunits.ActivePower PLosNeu[Nodes]=gridOnly3P.PLosNeu;
output Modelica.SIunits.ActivePower PGriLosPha[3]=gridOnly3P.PGriLosPha;
output Modelica.SIunits.ActivePower PGriLosNeu=gridOnly3P.PGriLosNeu;
output Modelica.SIunits.ActivePower PGriLosPhaTot=gridOnly3P.PGriLosPhaTot;
output Modelica.SIunits.ActivePower PGriLosTot=gridOnly3P.PGriLosTot;

/***And the Transformer losses if present***/
output Modelica.SIunits.ActivePower traLosP0=transformer.traLosP0 if traPre;
output Modelica.SIunits.ActivePower traLosPs=transformer.traLosPs if traPre;
output Modelica.SIunits.ActivePower traLosPtot=transformer.traLosPtot if traPre;

/***And the losses in the houseconnections***/
output Modelica.SIunits.ActivePower PLosHouCon[Nodes]=houseConnectors.PLosHouCon if
       houCon;
output Modelica.SIunits.ActivePower PLosHouConTot=houseConnectors.PLosHouConTot if
       houCon;

output Modelica.SIunits.ComplexCurrent[3] Ibranch0={gridOnly3P.branch[p,1].i for p in 1:3};
output Modelica.SIunits.Current Ibranch0Abs[3]={Modelica.ComplexMath.'abs'(
                                                          Ibranch0[i]) for i in 1:3};
output Modelica.SIunits.ComplexCurrent Ineutral0=gridOnly3P.neutral[1].i;
output Modelica.SIunits.Current Ineutral0Abs=Modelica.ComplexMath.'abs'(
                                                       Ineutral0);

protected
  parameter Integer Nodes=grid.n;
  parameter IDEAS.Electric.Data.Interfaces.Cable
                                 typHouBran[Nodes]= (if not difConTyp then fill(typ1HouBran,Nodes) else typHouBranDif) if  houCon;

equation
for i in 1:3 loop
  connect(cVoltageSource[i].n,cGround. p) annotation (Line(
      points={{-80,-40},{-80,-60}},
      color={0,0,255},
      smooth=Smooth.None));
end for;

if traPre then
  connect(transformer.LVPos, gridOnly3P.TraPin) annotation (Line(
      points={{-20,4},{20,4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(cVoltageSource.p,transformer.HVpos) annotation (Line(
      points={{-80,-20},{-80,4},{-40,4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(cGround.p,transformer.HVgnd) annotation (Line(
      points={{-80,-60},{-50,-60},{-50,-4},{-40,-4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(transformer.LVgnd, gridOnly3P.TraGnd) annotation (Line(
      points={{-20,-4},{20,-4}},
      color={0,0,255},
      smooth=Smooth.None));
else
  connect(cVoltageSource.p, gridOnly3P.TraPin) annotation (Line(
      points={{-80,-20},{-92,-20},{-92,20},{20,20},{20,4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(cGround.p, gridOnly3P.TraGnd) annotation (Line(
      points={{-80,-60},{20,-60},{20,-4}},
      color={0,0,255},
      smooth=Smooth.None));
end if;

if houCon then
    connect(gridOnly3P.node,houseConnectors. griCon)
    annotation (Line(
      points={{40,0},{48,0},{48,-20},{52,-20}},
      color={0,0,255},
      smooth=Smooth.None));
    connect(houseConnectors.houCon,node)
      annotation (Line(
      points={{72,-20},{88,-20},{88,0},{100,0}},
      color={0,0,255},
      smooth=Smooth.None));

else
    connect(gridOnly3P.node,node)  annotation (Line(
      points={{40,0},{100,0}},
      color={0,0,255},
      smooth=Smooth.None));
end if;

  annotation (Diagram(graphics), Icon(graphics={Bitmap(extent={{-100,100},{102,
              -100}}, fileName=
              "modelica://ELECTA/icon-ssnav-08-electricity.jpg")}));
end Grid3PGeneral;
