within IBPSA.ThermalZones.ISO13790.Zone5R1C;
model Zone

  parameter Real nVe(unit="1/h") "Air change rate"
  annotation (Dialog(group="Ventilation"));

  parameter Modelica.Units.SI.Area[4] Awin "Area of windows"
    annotation (Dialog(group="Windows"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer Uwin
    "U-value of windows" annotation (Dialog(group="Windows"));

  parameter Modelica.Units.SI.Area[4] Awal
    "Area of external walls" annotation (Dialog(group="Opaque constructions"));
  parameter Modelica.Units.SI.Area Aroo "Area of roof"
    annotation (Dialog(group="Opaque constructions"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer Uwal
    "U-value of external walls"
    annotation (Dialog(group="Opaque constructions"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer Uroo
    "U-value of roof" annotation (Dialog(group="Opaque constructions"));

  parameter Modelica.Units.SI.Area Af "Net conditioned floor area";
  parameter Modelica.Units.SI.Volume Vroo "Volume of room";
  parameter Real f_ms;
  replaceable parameter ISO13790.Data.Generic buiMas "Building mass"
    annotation (choicesAllMatching=true);

  parameter Modelica.Units.SI.Angle surfaceTilt[4]={1.5707963267949,1.5707963267949,
      1.5707963267949,1.5707963267949} "Tilt angle of surfaces";

  parameter Modelica.Units.SI.Angle surfaceAzimuth[4]={3.1415926535898,-1.5707963267949,
      0,1.5707963267949} "Azimuth angle of surfaces";

  parameter Real winFrame(min=0, max=1)=0.01 "Frame fraction of windows"
    annotation(Dialog(group="Windows"));
  parameter Real gFactor(min=0, max=1) "Energy transmittance of glazings"
    annotation(Dialog(group="Windows"));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor Hvent(G=nVe*Vroo
        *1005*1.2/3600) "Heat transfer due to ventilation"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor Htrasm(G=1/(1/(Uwal*
        Awal[1] + Uwal*Awal[2] + Uwal*Awal[3] + Uwal*Awal[4] + Uroo*Aroo) - 1/(9.1
        *f_ms*Af))) "Heat transfere through opaque elements"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor Hwin(G=Uwin*Awin[1] +
        Uwin*Awin[2] + Uwin*Awin[3] + Uwin*Awin[4])
    "Heat transfer through glazed elements"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor Hthermal(G=3.45*(
        Awal[1] + Awin[1] + Awal[2] + Awin[2] + Awal[3] + Awin[3] + Awal[4] +
        Awin[4] + Af + Aroo)/Af*Af)
             "Coupling conductancec betwee air and surface nodes"
                                                                annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,40})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor Hmass(G=9.1*f_ms*Af)
    "Coupling conductancec between surface and mass nodes"      annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,-40})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor zoneCap(C=buiMas.heaC*Af, T(displayUnit = "K", fixed=true,start=
          293.15)) "Zone thermal capacity"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={40,-120})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a Tair "Air node"
    annotation (Placement(transformation(extent={{30,70},{50,90}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a Tsur "Surface node"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow qNodAir
    annotation (Placement(transformation(extent={{80,70},{60,90}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow qNodSur
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow qNodMas
    annotation (Placement(transformation(extent={{80,-90},{60,-70}})));
  IBPSA.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-140,100},{-100,140}}),
                                                      iconTransformation(extent={{-126,78},
            {-62,142}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature outTemp
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

  Modelica.Blocks.Math.Add solGains "Total solar heat gains"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));



  BaseClasses.GlazedElements glazedElements(
    Awin=Awin,
    winFrame=winFrame,
    surfaceTilt=surfaceTilt,
    surfaceAzimuth=surfaceAzimuth,
    gFactor=gFactor) "Solar heat gains of glazed elements"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  BaseClasses.OpaqueElements opaqueElements(
    Awal=Awal,
    Uwal=Uwal,
    Aroo=Aroo,
    Uroo=Uroo,
    surfaceTilt={1.5707963267949,1.5707963267949,1.5707963267949,1.5707963267949,
        0},
    surfaceAzimuth={surfaceAzimuth[1],surfaceAzimuth[2],surfaceAzimuth[3],
        surfaceAzimuth[4],0}) "Solar heat gains of opaque elements"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Interfaces.RealInput intGains "Internal heat gains"
    annotation (Placement(transformation(extent={{-180,-140},{-140,-100}})));
  BaseClasses.GainSurface qSur(
    f_ms=f_ms,
    Af=Af,
    HwinG=Hwin.G,
    f_at=(Awal[1] + Awin[1] + Awal[2] + Awin[2] + Awal[3] + Awin[3] + Awal[4]
         + Awin[4] + Af + Aroo)/Af)
                  "Heat flow injected to surface node"
    annotation (Placement(transformation(extent={{120,-10},{100,10}})));

  Modelica.Blocks.Math.Gain qAir(k=0.5) "Heat flow injected to air node"
    annotation (Placement(transformation(extent={{120,70},{100,90}})));
  BaseClasses.GainMass qMas(
    HwinG=Hwin.G,
    f_ms=f_ms,
    Af=Af,
    f_at=(Awal[1] + Awin[1] + Awal[2] + Awin[2] + Awal[3] + Awin[3] + Awal[4]
         + Awin[4] + Af + Aroo)/Af)
           "Heat flow injected to mass node"
    annotation (Placement(transformation(extent={{120,-90},{100,-70}})));



equation

  connect(Tsur, Hwin.port_b)
    annotation (Line(points={{40,0},{20,0}}, color={191,0,0}));
  connect(Tair, Hvent.port_b)
    annotation (Line(points={{40,80},{20,80}}, color={191,0,0}));
  connect(Tair, Hthermal.port_b)
    annotation (Line(points={{40,80},{40,50}}, color={191,0,0}));
  connect(Tair, qNodAir.port)
    annotation (Line(points={{40,80},{60,80}}, color={191,0,0}));
  connect(qNodSur.port, Tsur)
    annotation (Line(points={{60,0},{40,0}}, color={191,0,0}));
  connect(Tsur, Hmass.port_b)
    annotation (Line(points={{40,0},{40,-30}}, color={191,0,0}));
  connect(weaBus.TDryBul, outTemp.T) annotation (Line(
      points={{-120,120},{-120,0},{-102,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(Tsur, Hthermal.port_a)
    annotation (Line(points={{40,0},{40,30}}, color={191,0,0}));
  connect(Tsur, Tsur)
    annotation (Line(points={{40,0},{40,0}}, color={191,0,0}));
  connect(glazedElements.weaBus, weaBus) annotation (Line(
      points={{-100,-50},{-120,-50},{-120,120}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(opaqueElements.weaBus, weaBus) annotation (Line(
      points={{-100,-90},{-120,-90},{-120,120}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(glazedElements.y, solGains.u1) annotation (Line(points={{-79.2857,-50},
          {-70,-50},{-70,-64},{-62,-64}}, color={0,0,127}));
  connect(opaqueElements.y, solGains.u2) annotation (Line(points={{-79.5455,-90},
          {-70,-90},{-70,-76},{-62,-76}}, color={0,0,127}));
  connect(Hvent.port_a, outTemp.port) annotation (Line(points={{0,80},{-20,80},
          {-20,0},{-80,0}}, color={191,0,0}));
  connect(Hwin.port_a, outTemp.port)
    annotation (Line(points={{0,0},{-80,0}}, color={191,0,0}));
  connect(Htrasm.port_a, outTemp.port) annotation (Line(points={{0,-80},{-20,-80},
          {-20,0},{-80,0}}, color={191,0,0}));
  connect(qNodMas.port, Htrasm.port_b)
    annotation (Line(points={{60,-80},{20,-80}}, color={191,0,0}));
  connect(zoneCap.port, Htrasm.port_b)
    annotation (Line(points={{40,-110},{40,-80},{20,-80}}, color={191,0,0}));
  connect(Hmass.port_a, Htrasm.port_b)
    annotation (Line(points={{40,-50},{40,-80},{20,-80}}, color={191,0,0}));
  connect(qNodSur.Q_flow,qSur. y)
    annotation (Line(points={{80,0},{99,0}}, color={0,0,127}));
  connect(qSur.intG, intGains) annotation (Line(points={{122,-4},{132,-4},{132,
          -136},{-74,-136},{-74,-120},{-160,-120}}, color={0,0,127}));
  connect(qAir.y, qNodAir.Q_flow)
    annotation (Line(points={{99,80},{80,80}}, color={0,0,127}));
  connect(qAir.u, intGains) annotation (Line(points={{122,80},{132,80},{132,-136},
          {-74,-136},{-74,-120},{-160,-120}}, color={0,0,127}));
  connect(qMas.y, qNodMas.Q_flow)
    annotation (Line(points={{99,-80},{80,-80}}, color={0,0,127}));
  connect(qMas.intG, intGains) annotation (Line(points={{122,-84},{132,-84},{
          132,-136},{-74,-136},{-74,-120},{-160,-120}}, color={0,0,127}));
  connect(solGains.y,qSur. solG) annotation (Line(points={{-39,-70},{-30,-70},{
          -30,-100},{132,-100},{132,-8},{122,-8}}, color={0,0,127}));
  connect(solGains.y,qMas. solG) annotation (Line(points={{-39,-70},{-30,-70},{
          -30,-100},{132,-100},{132,-88},{122,-88}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -140},{140,140}}), graphics={Rectangle(
          extent={{-140,140},{140,-140}},
          lineThickness=1,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={100,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-120,120},{120,-120}},
          lineColor={28,108,200},
          fillColor={170,213,255},
          fillPattern=FillPattern.Sphere),
        Text(
          extent={{-104,174},{118,142}},
          lineColor={0,0,255},
          textString="%name")}),Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-140,-140},{140,140}})),
    Documentation(info="<html>
<p>
This is a lumped-capacitance simplified building model based  on the 5R1C 
network presented in the ISO 13790:2008 Standard. The simplified 5R1C model uses
five thermal resistances and one thermal capacitance to reproduce the 
transient thermal behaviour of buildings. 
<code>nExt,</code> the vector of the capacities <code>CExt[nExt]</code> that is
connected via the vector of resistances <code>RExt[nExt]</code> and
<code>RExtRem</code> to the ambient and indoor air.
By default, the model neglects all
internal thermal masses that are not directly connected to the ambient.
However, the thermal capacity of the room air can be increased by
using the parameter <code>mSenFac</code>.
</p>
<p>
The image below shows the RC-network of this model.
</p>
<p align=\"center\">
<img src=\"modelica://IBPSA/Resources/Images/ThermalZones/ISO13790/Zone/5R1CNetwork_v2.png\" alt=\"image\"/>
</p>
  </html>"));
end Zone;
