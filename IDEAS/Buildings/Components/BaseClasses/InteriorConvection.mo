within IDEAS.Buildings.Components.BaseClasses;
model InteriorConvection "interior surface convection"

  parameter Modelica.SIunits.Area A "surface area";
  parameter Modelica.SIunits.Angle inc "inclination";

  parameter Boolean linearise = false
    "= true, if convective heat transfer should be linearised"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.TemperatureDifference dT_nominal = -2
    "Nominal temperature difference used for linearisation, negative temperatures indicate the solid is colder"
    annotation(Evaluate=true, enable = linearise);
  parameter Modelica.SIunits.TemperatureDifference dT_hCon = abs(dT_nominal)/10
    "Regularization temperature difference"
    annotation(Dialog(tab="Advanced"), Evaluate=true);

  parameter Boolean use_hConState = true
    "Introduce state to avoid non-linear systems when linearise = false"
    annotation(Dialog(tab="Advanced"), Evaluate = true);
  parameter Modelica.SIunits.Time tau = 120
    "Time constant for heat transfer coefficient state when linearise = false"
    annotation(Dialog(tab="Advanced", enable = use_hConState));
  parameter Modelica.SIunits.Length hZone = 2.7
    "Zone height, for calculation of hydraulic diameter"
    annotation(Dialog(tab="Advanced"));
  parameter Modelica.SIunits.Length DhWall = 4*A/(2*A/hZone+2*hZone)
    "Hydraulic diameter for walls"
    annotation(Dialog(tab="Advanced"));
  parameter Modelica.SIunits.Length DhFloor = sqrt(A)
    "Hydraulic diameter for ceiling/floor"
    annotation(Dialog(tab="Advanced"));
  Real hCon(nominal = 3) "Convective heat transfer coefficient";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

protected
  Modelica.SIunits.TemperatureDifference dT;
  final parameter Real coeffWall = 1.823/DhWall^0.121
    "For avoiding calculation of power at every time step";
  final parameter Real coeffFloor = 2.175/DhFloor^0.076
    "For avoiding calculations at every time step";
  final parameter Real coeffCeiling = 0.704/DhFloor^0.601
    "For avoiding calculations at every time step";
  final parameter Boolean isCeiling=abs(sin(inc)) < 10E-5 and cos(inc) > 0
    "true if ceiling"
    annotation(Evaluate=true);
  final parameter Boolean isFloor=abs(sin(inc)) < 10E-5 and cos(inc) < 0
    "true if floor"
    annotation(Evaluate=true);
  final parameter Real sign = if isCeiling then 1 else -1
    "Coefficient for buoyancy direction"
    annotation(Evaluate=true);

  Real hConState(nominal = 3) "Convective heat transfer coefficient state";

equation
    if isCeiling or isFloor then
      if linearise then
        hCon = IDEAS.Utilities.Math.Functions.spliceFunction(
              x=sign*dT_nominal,
              pos=coeffCeiling*abs(dT_nominal)^0.133,
              neg=coeffFloor*abs(dT_nominal)^0.308,
              deltax=  dT_hCon);
      else
        hCon = IDEAS.Utilities.Math.Functions.spliceFunction(
              x=sign*dT,
              pos=coeffCeiling*abs(dT)^0.133,
              neg=coeffFloor*abs(dT)^0.308,
              deltax=  dT_hCon);
      end if;
    else
      if linearise then
        hCon = coeffWall*abs(dT_nominal)^0.293;
      else
        hCon = coeffWall*abs(dT)^0.293;
      end if;
    end if;

  port_a.Q_flow = hConState*dT*A;

  port_a.Q_flow + port_b.Q_flow = 0;
  dT = port_a.T - port_b.T;

  if use_hConState and not linearise then
    der(hConState) = (hCon-hConState)/tau;
  else
    hConState=hCon;
  end if;

  annotation (Icon(graphics={
        Rectangle(
          extent={{-90,80},{-60,-80}},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None),
        Line(points={{-60,20},{76,20}}, color={191,0,0}),
        Line(points={{-34,80},{-34,-80}}, color={0,127,255}),
        Line(points={{-60,-20},{76,-20}}, color={191,0,0}),
        Line(points={{56,30},{76,20}}, color={191,0,0}),
        Line(points={{56,10},{76,20}}, color={191,0,0}),
        Line(points={{56,-10},{76,-20}}, color={191,0,0}),
        Line(points={{56,-30},{76,-20}}, color={191,0,0}),
        Line(points={{6,80},{6,-80}}, color={0,127,255}),
        Line(points={{40,80},{40,-80}}, color={0,127,255}),
        Line(points={{76,80},{76,-80}}, color={0,127,255}),
        Line(points={{-34,-80},{-44,-60}}, color={0,127,255}),
        Line(points={{-34,-80},{-24,-60}}, color={0,127,255}),
        Line(points={{6,-80},{-4,-60}}, color={0,127,255}),
        Line(points={{6,-80},{16,-60}}, color={0,127,255}),
        Line(points={{40,-80},{30,-60}}, color={0,127,255}),
        Line(points={{40,-80},{50,-60}}, color={0,127,255}),
        Line(points={{76,-80},{66,-60}}, color={0,127,255}),
        Line(points={{76,-80},{86,-60}}, color={0,127,255}),
        Text(
          extent={{-150,-90},{150,-130}},
          textString="%name",
          lineColor={0,0,255}),
        Line(
          points={{-60,80},{-60,-80}},
          color={0,0,0},
          thickness=0.5)}), Documentation(info="<html>
<p>The interior natural convective heat transfer coefficient <img src=\"modelica://IDEAS/Images/equations/equation-eZGZlJrg.png\"/> is computed for each interior surface as </p>
<p align=\"center\"><img src=\"modelica://IDEAS/Images/equations/equation-KNBSKUDK.png\"/></p>
<p>where <img src=\"modelica://IDEAS/Images/equations/equation-W5kvS3SS.png\"/> is the characteristic length of the surface, <img src=\"modelica://IDEAS/Images/equations/equation-jhC1rqax.png\"/> is the indoor air temperature and <img src=\"modelica://IDEAS/Images/equations/equation-sbXAgHuQ.png\"/> are correlation coefficients. These parameters {<img src=\"modelica://IDEAS/Images/equations/equation-nHmmePq5.png\"/>,<img src=\"modelica://IDEAS/Images/equations/equation-zJZmNUzp.png\"/>,<img src=\"modelica://IDEAS/Images/equations/equation-7nwXbcLp.png\"/>} are identical to {1.823,-0.121,0.293} for vertical surfaces [Awbi 1999], {2.175,-0.076,0.308} for horizontal surfaces wherefore the heat flux is in the same direction as the buoyancy force <a href=\"IDEAS.Buildings.UsersGuide.References\">[Khalifa 2001]</a>, and {2.72,-,0.13} for horizontal surfaces wherefore the heat flux is in the opposite direction as the buoyancy force <a href=\"IDEAS.Buildings.UsersGuide.References\">[Awbi 1999]</a>. The interior natural convective heat transfer coefficient is only described as function of the temperature difference. Similar to the thermal model for heat transfer through a wall, a thermal circuit formulation for the direct radiant exchange between surfaces can be derived <a href=\"IDEAS.Buildings.UsersGuide.References\">[ Buchberg 1955, Oppenheim 1956]</a>.</p>
<p><br>[Awbi 1999]: H.B. Awbi, A. Hatton, Natural convection from heated room surfaces, Energy and Buildings 30 (1999) 233&ndash;244.</p>
</html>"));
end InteriorConvection;
