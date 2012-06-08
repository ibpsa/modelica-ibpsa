within IDEAS.Electric.Photovoltaic;
model PVFromFilePQ
  "PV system that reads input from file. It has power (P and Q) output and a voltage pin for sensing overvoltages."
parameter Real amount=30;
parameter Real inc=34 "inclination";
parameter Real azi=0 "azimuth";

parameter Integer PVPha=4;
parameter Integer numPha=(if PVPha==4 then 3 else 1);
parameter Integer prod=1;
parameter Integer timeOff=300;
parameter Real VMax=253;

protected
  IDEAS.Electric.Photovoltaic.Components.ForInputFiles.PvSystemGeneralPQ pvSystemGeneralPQ(
    amount=amount,
    inc=inc,
    azi=azi,
    prod=prod,
    timeOff=timeOff,
    VMax=VMax,
    numPha=numPha)
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

public
Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin    pin[       3] annotation (Placement(transformation(extent={{88,30},
            {108,50}},                                                                                    rotation=0)));
 Modelica.Blocks.Interfaces.RealOutput PQ[2]
    annotation (Placement(transformation(extent={{96,-10},{116,10}})));
  IDEAS.Electric.Photovoltaic.Components.ForInputFiles.PVvoltagemeas pVvoltagemeas(PVPha=
        PVPha)                             annotation (Placement(transformation(
        extent={{-5,-15},{5,15}},
        rotation=90,
        origin={35,49})));
equation
  connect(pvSystemGeneralPQ.PQ, PQ) annotation (Line(
      points={{-19.4,20},{40,20},{40,0},{106,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pvSystemGeneralPQ.pin, pVvoltagemeas.PVside) annotation (Line(
      points={{-19.8,24},{0,24},{0,49},{20,49}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pVvoltagemeas.GridSide, pin) annotation (Line(
      points={{50,49},{73,49},{73,40},{98,40}},
      color={0,0,255},
      smooth=Smooth.None));
      annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),
                         graphics={
        Polygon(
          points={{-80,60},{-60,80},{60,80},{80,60},{80,-60},{60,-80},{-60,-80},
              {-80,-60},{-80,60}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-40,80},{-40,-80}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{40,80},{40,-80}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          extent={{-100,98},{100,-102}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="#")}),        Diagram(graphics));
end PVFromFilePQ;
