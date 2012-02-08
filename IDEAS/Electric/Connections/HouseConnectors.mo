within IDEAS.Electric.Connections;
model HouseConnectors
  "Makes the connections from the in-home connection to the grid, standard 16mm2 Alu."

parameter Integer numNod = 34
    "The number of nodes in the grid to which the houses are connected";
parameter Integer numPha = 1
    "Is it a single phase equivalent(1) grid, or 3 phase grid connections(3)"
 annotation(choices(
choice=1 "Single Phase",
choice=3 "3 Phase",
__Dymola_radioButtons=true));

//parameter Integer[numNod] conPha={i-integer(floor((i-1)/4)) for i in 1:numNod}
parameter Integer[numNod] conPha={1 for i in 1:numNod}
    "Gives an array of lenth '# Nodes' with in it to which phase the house is connected (1 to 3) or 4 in case of 3 phase connection";

replaceable parameter IDEAS.Electric.Data.Interfaces.Cable
                                           typHouBran[numNod]=fill(IDEAS.Electric.Data.Cables.PvcAl16(),
                                                                                                numNod)
    "An array of length '# Nodes' with the types of cables used for the house connections";

parameter Modelica.SIunits.Length lenHouBran[numNod]=fill(10,numNod)
    "An array of length '# Nodes' with the lengths of the cables used for the house connections";

/***This creates the branches. TODO:adjust mulfac to cope with single phase connections and single phase equivalent 3 phase connections,
for 3 phase connections it can stay at default(1)
Maybe also make sure unused cables have very high impedance so errors will show in results***/
IDEAS.Electric.DistributionGrid.Components.BranchLenTyp[numPha,numNod] branch(
    len={lenHouBran for i in 1:numPha},
    typ={typHouBran for i in 1:numPha},
    mulFac=mulFacZ);

/**This creates the Nodes for the gridconnection and the houseconnection**/
Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin[
                numPha,numNod] griCon
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin[
                               numPha,numNod] houCon
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})),Icon(graphics), Diagram(graphics));
  /**This should input a multiplication factor for the houseconnection.
  The multiplication factor should always be 1/3 in case of a single phase equivalent grid.
  Single phase equivalent connections are not allowed when not using a single phase equivalent grid!!
  A single phase connection with a 3 phase grid will give a multiplication factor of 1 on the connected phase and the Neutral (phase 4)
  and very large multiplication on the others
  A 3 phase connection to a 3 phase grid gives a multiplication factor of 1 on all phases**/

  /***The Losses in the houseconnection***/
Modelica.SIunits.ActivePower PLosHouCon[numNod];
Modelica.SIunits.ActivePower PLosHouConTot;

protected
    parameter Real mulFacZ[numPha,numNod] = {{if numPha==1 then 1/3 else
    (if i==4 then 1
    else
    (if conPha[k]==4 then 1
 elseif
       conPha[k]==i then 1
 else
     5E12))
          for k in 1:numNod}
                            for i in 1:numPha};

equation
  for p in 1:numPha loop
    for n in 1:numNod loop
      connect(branch[p,n].pin_p,griCon[p,n]);
      connect(branch[p,n].pin_n,houCon[p,n]);
    end for;
  end for;

for n in 1:numNod loop
  PLosHouCon[n]=sum(branch[:,n].Plos);
end for;
PLosHouConTot=sum(PLosHouCon);

  annotation (Diagram(graphics), Icon(graphics={Bitmap(extent={{-100,100},{102,
              -100}}, fileName=
              "modelica://IDEAS/Electric/HouseCon.jpg")}));
end HouseConnectors;
