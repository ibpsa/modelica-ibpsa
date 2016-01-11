within Annex60.Experimental;
package TimeDelays
  // Originally at https://github.com/arnoutaertgeerts/DistrictHeating
  // First implementation by Arnout Aertgeerts
  model PDETime "Calculates time delay as the difference between the current simulation time and 
  the inlet time. The inlet time is propagated with the corresponding fluid parcel 
  using the spatialDistribution function."

    Modelica.SIunits.Time tin;
    Modelica.SIunits.Time tout;
    Modelica.SIunits.Time td;

    Real x "Normalized transport quantity";

    Modelica.Blocks.Interfaces.RealInput u "Normalized speed"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
          iconTransformation(extent={{-140,-20},{-100,20}})));

    Modelica.Blocks.Interfaces.RealOutput tau "Time delay"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  equation
    //Speed
    der(x) = u;

    tin = time;
    td = time - tout;

    //Spatial distribution of the time
    (,tout) =
      spatialDistribution(
        time,
        0,
        x,
        true,
        {0.0, 0.5, 1},
        {0.0, -0.5, -1});

    tau = td;

    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
                                  Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
      Line(points={{-92,0},{-80.7,34.2},{-73.5,53.1},{-67.1,66.4},{-61.4,74.6},{-55.8,
                79.1},{-50.2,79.8},{-44.6,76.6},{-38.9,69.7},{-33.3,59.4},{-26.9,44.1},
                {-18.83,21.2},{-1.9,-30.8},{5.3,-50.2},{11.7,-64.2},{17.3,-73.1},{
                23,-78.4},{28.6,-80},{34.2,-77.6},{39.9,-71.5},{45.5,-61.9},{51.9,
                -47.2},{60,-24.8},{68,0}},
        color={0,0,127},
        smooth=Smooth.Bezier),
      Line(points={{-64,0},{-52.7,34.2},{-45.5,53.1},{-39.1,66.4},{-33.4,74.6},{-27.8,
                79.1},{-22.2,79.8},{-16.6,76.6},{-10.9,69.7},{-5.3,59.4},{1.1,44.1},
                {9.17,21.2},{26.1,-30.8},{33.3,-50.2},{39.7,-64.2},{45.3,-73.1},{51,
                -78.4},{56.6,-80},{62.2,-77.6},{67.9,-71.5},{73.5,-61.9},{79.9,-47.2},
                {88,-24.8},{96,0}},
        smooth=Smooth.Bezier),
          Text(
            extent={{20,100},{82,30}},
            lineColor={0,0,255},
            textString="PDE"),
          Text(
            extent={{-82,-30},{-20,-100}},
            lineColor={0,0,255},
            textString="tau"),
          Text(
            extent={{-60,140},{60,100}},
            lineColor={0,0,255},
            textString="%name")}));
  end PDETime;

  model DiffTime
    "Calculates the time delay as proposed by Velut and Tummescheit (2011), using a differential equation."
    /* Source: S. Velut, H. Tummescheit, Implementation of a transmission line model
     for fast simulation of fluid flow dynamics, in: Proceedings 8th Modelica
     Conference, Dresden (2011) pp. 446-453. */

    Real td "Time delay";
    Real tref "Reference time when flow starts again";
    Real ut "Delayed normalized velocity";
    //Real MaxDelay(min=0, start=1);
    Boolean vr;
    Boolean desc;
    Boolean descstop;

    Modelica.Blocks.Interfaces.RealInput u "Normalized speed" annotation (
        Placement(transformation(extent={{-140,-20},{-100,20}}),
          iconTransformation(extent={{-140,-20},{-100,20}})));

    Modelica.Blocks.Interfaces.RealOutput tau "Time delay"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));

    Real uref "memory of last known velocity before zero flow";
  initial equation
    td = 1/u;
    tref = 1e18;
  equation
    ut = delay(
      u,
      td,
      1000);
    vr = abs(u) > 0;

    when change(vr) then
      uref = pre(ut);
    end when;

    when edge(vr) then
      tref = pre(time);
      desc = true;
    end when;

    descstop = time >= tref + 1/uref;
    when edge(descstop) then
      desc = false;
      reinit(td, 1/u);
      reinit(ut, u);
    end when;

    if desc and not descstop then
      der(td) = -u/uref;
    else
      der(td) = 1 - u/ut;
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
  end DiffTime;

  package Examples
    model PDETime
      import DistrictHeating;
      DistrictHeating.TimeDelays.PDETime pulseDelay
        annotation (Placement(transformation(extent={{-10,50},{10,70}})));
      DistrictHeating.TimeDelays.PDETime sineDelay
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
      DistrictHeating.TimeDelays.PDETime rampDelay
        annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
      Modelica.Blocks.Sources.Pulse pulse(
        amplitude=0.9,
        period=100,
        offset=0.1)
        annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
      Modelica.Blocks.Sources.Sine sine(freqHz=0.01, offset=1)
        annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
      Modelica.Blocks.Sources.Ramp ramp(
        height=0.9,
        duration=50,
        offset=0.1)
        annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
    equation
      connect(pulse.y, pulseDelay.u) annotation (Line(
          points={{-39,60},{-12,60}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sine.y, sineDelay.u) annotation (Line(
          points={{-39,0},{-12,0}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(ramp.y, rampDelay.u) annotation (Line(
          points={{-39,-60},{-12,-60}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{
                -100,-100},{100,100}}), graphics), __Dymola_Commands(
            executeCall=simulateModel(
                  "DistrictHeating.TimeDelays.Examples.PDETime",
                  stopTime=1000,
                  fixedstepsize=30,
                  resultFile="PDETime"), file(ensureSimulated=true)=
            "plot.mos" "plot"));
    end PDETime;

    model DiffTime
      import DistrictHeating;
      Modelica.Blocks.Sources.Pulse pulse(
        period=100,
        amplitude=1,
        offset=0)
        annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
      Modelica.Blocks.Sources.Sine sine(freqHz=0.01, offset=1)
        annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
      Modelica.Blocks.Sources.Ramp ramp(
        height=0.9,
        duration=50,
        offset=0.1)
        annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
      TimeDelays.DiffTime pulseDelay
        annotation (Placement(transformation(extent={{-10,50},{10,70}})));
      TimeDelays.DiffTime rampDelay
        annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
      TimeDelays.DiffTime sineDelay
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    equation
      connect(pulse.y, pulseDelay.u) annotation (Line(
          points={{-39,60},{-12,60}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sine.y, sineDelay.u) annotation (Line(
          points={{-39,0},{-12,0}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(ramp.y, rampDelay.u) annotation (Line(
          points={{-39,-60},{-12,-60}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{
                -100,-100},{100,100}}), graphics));
    end DiffTime;

    model Difference
      import DistrictHeating;
      import Annex60;
      Annex60.Experimental.TimeDelays.PDETime pDETime
        annotation (Placement(transformation(extent={{0,40},{20,60}})));
      Annex60.Experimental.Pipe.BaseClasses.DiffTime_modified diffTime
        annotation (Placement(transformation(extent={{0,0},{20,20}})));
      Modelica.Blocks.Sources.Pulse pulse(
        amplitude=-1,
        width=20,
        period=100,
        nperiod=1,
        offset=1,
        startTime=20)
        annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
    equation
      connect(pulse.y, pDETime.u) annotation (Line(points={{-39,30},{-14,30},{-14,50},
              {-2,50}}, color={0,0,127}));
      connect(pulse.y, diffTime.u) annotation (Line(points={{-39,30},{-14,30},{-14,10},
              {-2,10}}, color={0,0,127}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}})),                __Dymola_Commands(
            executeCall=simulateModel(
                  "DistrictHeating.TimeDelays.Examples.PDETime",
                  stopTime=1000,
                  fixedstepsize=30,
                  resultFile="PDETime"), file(ensureSimulated=true)=
            "plot.mos" "plot"));
    end Difference;
  end Examples;
  annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          fillPattern=FillPattern.None,
          extent={{-100,-100},{100,100}},
          radius=25.0),
    Line(points={{-92,0},{-80.7,34.2},{-73.5,53.1},{-67.1,66.4},{-61.4,74.6},{
              -55.8,79.1},{-50.2,79.8},{-44.6,76.6},{-38.9,69.7},{-33.3,59.4},{
              -26.9,44.1},{-18.83,21.2},{-1.9,-30.8},{5.3,-50.2},{11.7,-64.2},{
              17.3,-73.1},{23,-78.4},{28.6,-80},{34.2,-77.6},{39.9,-71.5},{45.5,
              -61.9},{51.9,-47.2},{60,-24.8},{68,0}},
      color={0,0,127},
      smooth=Smooth.Bezier),
    Line(points={{-64,0},{-52.7,34.2},{-45.5,53.1},{-39.1,66.4},{-33.4,74.6},{
              -27.8,79.1},{-22.2,79.8},{-16.6,76.6},{-10.9,69.7},{-5.3,59.4},{
              1.1,44.1},{9.17,21.2},{26.1,-30.8},{33.3,-50.2},{39.7,-64.2},{
              45.3,-73.1},{51,-78.4},{56.6,-80},{62.2,-77.6},{67.9,-71.5},{73.5,
              -61.9},{79.9,-47.2},{88,-24.8},{96,0}},
      smooth=Smooth.Bezier),
        Text(
          extent={{-82,-30},{-20,-100}},
          lineColor={0,0,255},
          textString="tau"),
        Text(
          extent={{-60,140},{60,100}},
          lineColor={0,0,255},
          textString="%name")}));
end TimeDelays;
