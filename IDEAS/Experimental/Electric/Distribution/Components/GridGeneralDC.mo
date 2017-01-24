within IDEAS.Electric.Distribution.Components;
model GridGeneralDC "THE General inhome grid to use."

replaceable parameter Electric.Data.Interfaces.DirectCurrent.GridType grid
    "Choose a grid Layout"                                                             annotation(choicesAllMatching = true);

parameter Integer Nodes = grid.nNodes;

Electric.Distribution.DC.GridDCGeneral gridDCGeneral(grid=grid)
     annotation (Placement(transformation(extent={{-40,-20},{0,20}})));
Modelica.Electrical.Analog.Interfaces.PositivePin loadNodesDC[1,grid.nNodes]
     annotation (Placement(transformation(extent={{90,-10},{110,10}})));
Modelica.Electrical.Analog.Interfaces.PositivePin[2] gridConnection
     annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

output Modelica.SIunits.ActivePower PGriTot=gridDCGeneral.PGriTot;
output Modelica.SIunits.ActivePower PLosBra[Nodes]=gridDCGeneral.PLosBra;
output Modelica.SIunits.ActivePower PLosNeu[Nodes]=gridDCGeneral.PLosNeu;
output Modelica.SIunits.ActivePower PGriLosPha=gridDCGeneral.PGriLosPha;
output Modelica.SIunits.ActivePower PGriLosNeu=gridDCGeneral.PGriLosNeu;
output Modelica.SIunits.ActivePower PGriLosTot=gridDCGeneral.PGriLosTot;

output Modelica.SIunits.Voltage Vabs[Nodes]=gridDCGeneral.Vabs;

output Modelica.SIunits.Current Ibranch0=gridDCGeneral.Ibranch0;
output Modelica.SIunits.Current Ineutral0=gridDCGeneral.Ineutral0;

equation
connect(gridConnection, gridDCGeneral.gridConnection) annotation (Line(
       points={{-100,0},{-40,0}},
       color={0,0,255},
       smooth=Smooth.None));
  connect(gridDCGeneral.nodes1Phase, loadNodesDC) annotation (Line(
      points={{0,0},{100,0}},
      color={0,0,255},
      smooth=Smooth.None));
annotation (Diagram(graphics), Icon(graphics={
        Rectangle(
          extent={{28,60},{70,20}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-26,54},{-26,20},{-6,20},{-6,28},{4,28},{4,32},{-6,32},{-6,44},
              {8,44},{8,50},{-6,50},{-6,54},{-26,54}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-14,20},{-14,0},{-94,0}},
          color={0,0,255},
          smooth=Smooth.None),
        Rectangle(
          extent={{46,50},{50,42}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{56,34},{60,26}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,34},{42,26}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-90,40},{-30,0}},
          lineColor={0,0,255},
          textString="DC"),
        Line(
          points={{48,20},{48,0},{96,0}},
          color={0,0,255},
          smooth=Smooth.None)}),
    Documentation(info="<html>

</html>"));
end GridGeneralDC;
