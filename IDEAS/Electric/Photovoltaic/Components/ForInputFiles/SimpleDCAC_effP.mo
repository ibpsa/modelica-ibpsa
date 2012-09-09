within IDEAS.Electric.Photovoltaic.Components.ForInputFiles;
class SimpleDCAC_effP

extends Modelica.Blocks.Interfaces.BlockIcon;

//  Real eff;
//SI.ActivePower P;
Modelica.SIunits.ApparentPower S;
//SI.ReactivePower Q;
  parameter Real cosphi=1;      //For now

  parameter Real PNom "Nominal power, in Wp";
  parameter Real P_dc_max=230;                 //MPP for one panel.
  parameter Real eff=0.95;       //For now

  Modelica.Blocks.Interfaces.RealInput P_dc
    annotation (Placement(transformation(extent={{-130,-20},{-90,20}})));
  Modelica.Blocks.Interfaces.RealOutput P
    annotation (Placement(transformation(extent={{96,30},{116,50}})));
  Modelica.Blocks.Interfaces.RealOutput Q
    annotation (Placement(transformation(extent={{96,-50},{116,-30}})));
equation
  S^2=P^2+Q^2;
  P=S*cosphi;
  P=eff*P_dc*PNom;

//
//   // Define efficiency as a function of P_dc (production) against the mpp for the system
//   if noEvent(P_dc < (P_dc_max) * 0.05) then      //<5%
//     eff = (0.945 * (P_dc/(P_dc_max))) / 0.05;
//   elseif noEvent(P_dc < (P_dc_max) * 0.30) then  //5%-30%
//     eff = 2.9333 * ((P_dc/(P_dc_max))^3) - 2.16 * ((P_dc/(P_dc_max*NPanelen))^2) + 0.5327*(P_dc/(P_dc_max*NPanelen)) + 0.9234;
//   else                                         //>30%
//     eff = 0.968 + (0.01*((P_dc/(P_dc_max*NPanelen))-0.3) / 0.7);
//   end if;

  annotation (Icon(graphics={Text(
          extent={{-100,20},{-40,-20}},
          lineColor={0,0,0},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          textString="DC"), Text(
          extent={{40,20},{100,-20}},
          lineColor={0,0,0},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          textString="AC"),
        Line(
          points={{-36,0},{36,0},{0,12},{0,-12},{36,0}},
          color={0,0,0},
          smooth=Smooth.None)}), Diagram(graphics));
end SimpleDCAC_effP;
