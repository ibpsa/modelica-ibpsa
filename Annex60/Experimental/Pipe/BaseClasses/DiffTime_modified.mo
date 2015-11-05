within Annex60.Experimental.Pipe.BaseClasses;
model DiffTime_modified
  "Calculates the time delay as proposed by Velut and Tummescheit (2011), using a differential equation."
  /* Source: S. Velut, H. Tummescheit, Implementation of a transmission line model
     for fast simulation of fluid flow dynamics, in: Proceedings 8th Modelica
     Conference, Dresden (2011) pp. 446-453. */

  Real td "Time delay";
  Real ut "Delayed normalized velocity";
  //Real MaxDelay(min=0, start=1);
  Boolean vr;
  Boolean vl, v0;

  Real t0 "Time the fluid stands still";

  Modelica.Blocks.Interfaces.RealInput u "Normalized speed" annotation (
      Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.RealOutput tau "Time delay"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Real uref "memory of last known velocity before zero flow";
initial equation
  td = 1/u;
equation
  ut = delay(
    u,
    td,
    1000);
  vr = u > 0;
  vl = u < 0;

  v0 = u ==0;

  when edge(vr) then // flow starts going right

  end when;

  when edge(vl) then // flow starts going left

  end when;

  when edge(v0) then // flow stops
    t0 = 0;

  end when;

  if v0 then
    der(t0)=1;
    der(tau)=0;
  elseif ut==0 then

  else
    der(dt)=1-u/ut;
    der(t0)=0;
  end if;
  tau = td;

  annotation (
    Placement(transformation(extent={{-10,-10},{10,10}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-92,0},{-80.7,34.2},{-73.5,53.1},{-67.1,66.4},{-61.4,74.6},{-55.8,
              79.1},{-50.2,79.8},{-44.6,76.6},{-38.9,69.7},{-33.3,59.4},{-26.9,44.1},
              {-18.83,21.2},{-1.9,-30.8},{5.3,-50.2},{11.7,-64.2},{17.3,-73.1},{
              23,-78.4},{28.6,-80},{34.2,-77.6},{39.9,-71.5},{45.5,-61.9},{51.9,
              -47.2},{60,-24.8},{68,0}},
          color={0,0,127},
          smooth=Smooth.Bezier),
        Line(points={{-64,0},{-52.7,34.2},{-45.5,53.1},{-39.1,66.4},{-33.4,74.6},
              {-27.8,79.1},{-22.2,79.8},{-16.6,76.6},{-10.9,69.7},{-5.3,59.4},{1.1,
              44.1},{9.17,21.2},{26.1,-30.8},{33.3,-50.2},{39.7,-64.2},{45.3,-73.1},
              {51,-78.4},{56.6,-80},{62.2,-77.6},{67.9,-71.5},{73.5,-61.9},{79.9,
              -47.2},{88,-24.8},{96,0}}, smooth=Smooth.Bezier),
        Text(
          extent={{20,100},{82,30}},
          lineColor={0,0,255},
          textString="Diff"),
        Text(
          extent={{-82,-30},{-20,-100}},
          lineColor={0,0,255},
          textString="tau"),
        Text(
          extent={{-60,140},{40,100}},
          lineColor={0,0,255},
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end DiffTime_modified;
