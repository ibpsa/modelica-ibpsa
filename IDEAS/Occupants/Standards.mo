within IDEAS.Occupants;
package Standards

  extends Modelica.Icons.Package;

  model ISO13790_Day

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a GainOccAir;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a GainOccRad;
  parameter Modelica.SIunits.Area A;

  Real occ;
  Real power = GainOccAir.Q_flow/0.5;

  parameter Real interval=3600;
  parameter Real period=86400/interval;
  Integer t;

  parameter Real[3] Qday={8,20,2};
  parameter Real[3] Qnigtht={1,1,6};

  equation
  when sample(0,interval) then
    t = if pre(t)+1 <= period then pre(t) + 1 else 1;
  end when;

  if noEvent(t <= 7 or t >= 23) then
    GainOccAir.Q_flow = -A*Qday[3]*0.5;
    GainOccRad.Q_flow = -A*Qday[3]*0.5;
    occ=0;
  elseif noEvent(t > 7 and t <=17) then
    GainOccAir.Q_flow = -A*Qday[1]*0.5;
    GainOccRad.Q_flow = -A*Qday[1]*0.5;
    occ=0;
  else
    GainOccAir.Q_flow = -A*Qday[2]*0.5;
    GainOccRad.Q_flow = -A*Qday[2]*0.5;
    occ=1;
  end if;

    annotation (Icon(graphics={
          Ellipse(
            extent={{-70,70},{70,-70}},
            lineColor={127,0,0},
            fillPattern=FillPattern.Solid,
            fillColor={127,0,0}),
          Ellipse(
            extent={{-60,60},{60,-60}},
            lineColor={127,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{2,0},{2,58},{14,56},{24,52},{32,48},{42,40},{48,32},{54,22},
                {58,10},{58,-4},{56,-16},{50,-28},{44,-38},{42,-40},{2,0}},
            smooth=Smooth.None,
            pattern=LinePattern.None,
            lineColor={0,0,0},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-4,50},{2,-2}},
            lineColor={127,0,0},
            fillColor={127,0,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{2,0},{18,-16},{14,-20},{-4,-2},{2,0}},
            lineColor={127,0,0},
            smooth=Smooth.None,
            fillColor={127,0,0},
            fillPattern=FillPattern.Solid)}));
  end ISO13790_Day;

  model ISO13790_Night

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a GainOccAir;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a GainOccRad;
  parameter Modelica.SIunits.Area A;

  parameter Real interval=3600;
  parameter Real period=86400/interval;
  Integer t;
  Real occ;
  Real power = GainOccAir.Q_flow/0.5;

  parameter Real[3] Qday={8,20,2};
  parameter Real[3] Qnight={1,1,6};

  equation
  when noEvent(rem(time,interval)) < 0.1 then
    t = if pre(t)+1 <= period then pre(t) + 1 else 1;
  end when;

  if noEvent(t <= 7 or t >= 23) then
    GainOccAir.Q_flow = -A*Qnight[3]/2;
    GainOccRad.Q_flow = -A*Qnight[3]/2;
    occ=1;
  elseif noEvent(t > 7 and t <=17) then
    GainOccAir.Q_flow = -A*Qnight[1]/2;
    GainOccRad.Q_flow = -A*Qnight[1]/2;
    occ=0;
  else
    GainOccAir.Q_flow = -A*Qnight[2]/2;
    GainOccRad.Q_flow = -A*Qnight[2]/2;
    occ=0;
    end if;

    annotation (Icon(graphics={
          Ellipse(
            extent={{-70,70},{70,-70}},
            lineColor={127,0,0},
            fillPattern=FillPattern.Solid,
            fillColor={127,0,0}),
          Ellipse(
            extent={{-60,60},{60,-60}},
            lineColor={127,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{2,0},{2,58},{14,56},{24,52},{32,48},{42,40},{48,32},{54,22},
                {58,10},{58,-4},{56,-16},{50,-28},{44,-38},{42,-40},{2,0}},
            smooth=Smooth.None,
            pattern=LinePattern.None,
            lineColor={0,0,0},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-4,50},{2,-2}},
            lineColor={127,0,0},
            fillColor={127,0,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{2,0},{18,-16},{14,-20},{-4,-2},{2,0}},
            lineColor={127,0,0},
            smooth=Smooth.None,
            fillColor={127,0,0},
            fillPattern=FillPattern.Solid)}));
  end ISO13790_Night;
end Standards;
