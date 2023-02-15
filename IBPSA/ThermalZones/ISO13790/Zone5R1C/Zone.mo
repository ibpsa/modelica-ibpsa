within IBPSA.ThermalZones.ISO13790.Zone5R1C;
model Zone "Thermal zone based on 5R1C network"
  parameter Real airRat(unit="1/h") "Air change rate"
   annotation (Dialog(group="Ventilation"));
  parameter Modelica.Units.SI.Area AWin[:] "Area of windows"
   annotation (Dialog(group="Windows"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer UWin "U-value of windows"
   annotation (Dialog(group="Windows"));
  parameter Modelica.Units.SI.Area AWal[:] "Area of external walls"
   annotation (Dialog(group="Opaque constructions"));
  parameter Modelica.Units.SI.Area ARoo "Area of roof"
   annotation (Dialog(group="Opaque constructions"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer UWal "U-value of external walls"
   annotation (Dialog(group="Opaque constructions"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer URoo "U-value of roof"
   annotation (Dialog(group="Opaque constructions"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer UFlo "U-value of floor"
   annotation (Dialog(group="Opaque constructions"));
  parameter Real b=0.5 "Adjustment factor for ground heat transfer"
   annotation (Dialog(group="Opaque constructions"));
  parameter Modelica.Units.SI.Area AFlo "Net conditioned floor area";
  parameter Modelica.Units.SI.Volume VRoo "Volume of room";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hInt=3.45 "Heat transfer coefficient between surface and air nodes";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hSur=9.1 "Heat transfer coefficient between mass and surface nodes";
  replaceable parameter ISO13790.Data.Generic buiMas "Building mass"
   annotation (
     choicesAllMatching=true,
     Placement(transformation(extent={{100,100},{120,120}})));
  parameter Integer nOrientations "Number of orientations for vertical walls";
  parameter Modelica.Units.SI.Angle surTil[:] "Tilt angle of surfaces";
  parameter Modelica.Units.SI.Angle surAzi[:] "Azimuth angle of surfaces";
  parameter Real winFra(min=0, max=1)=0.001 "Frame fraction of windows"
   annotation(Dialog(group="Windows"));
  parameter Real gFac(min=0, max=1) "Energy transmittance of glazings"
   annotation(Dialog(group="Windows"));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor HVen(
      G=airRat*VRoo*1005*1.2/3600) "Heat transfer due to ventilation"
   annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor HTra(
      G=1/(1/(UWal*sum(AWal) + b*UFlo*AFlo + URoo*ARoo) - 1/(hSur*buiMas.facMas*AFlo))) "Heat transfer through opaque elements"
   annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor HWin(
      G=UWin*sum(AWin)) "Heat transfer through glazed elements"
   annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor HThe(G=hInt*AFlo*ratSur) "Coupling conductance betwee air and surface nodes"
   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,40})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor HMas(G=hSur*buiMas.facMas*AFlo) "Coupling conductance between surface and mass nodes"
   annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,-40})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capMas(
      C=buiMas.heaC*AFlo,
      T(displayUnit="degC",
      fixed=true,
      start=293.15)) "Zone thermal capacity" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={40,-120})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a TAir "Air node"
    annotation (Placement(transformation(extent={{30,70},{50,90}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a TSur "Surface node"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaAir
    annotation (Placement(transformation(extent={{80,70},{60,90}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaSur
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaMas
    annotation (Placement(transformation(extent={{80,-90},{60,-70}})));
  IBPSA.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-140,100},{-100,140}}),
        iconTransformation(extent={{-126,78}, {-62,142}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TExt
    "External air temperature"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Math.Add solGai "Total solar heat gains"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  BaseClasses.GlazedElements Win(
    n=nOrientations,
    AWin=AWin,
    surTil=surTil,
    surAzi=surAzi,
    gFac=gFac,
    winFra=winFra) "Solar heat gains of glazed elements"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  BaseClasses.OpaqueElements Opa(
    n=nOrientations,
    AWal=AWal,
    ARoo=ARoo,
    UWal=UWal,
    URoo=URoo,
    surTil=surTil,
    surAzi=surAzi) "Solar heat gains of opaque elements"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Interfaces.RealInput intSenGai( unit="W") "Internal sensible heat gains"
    annotation (Placement(transformation(extent={{-180,-140},{-140,-100}})));
  BaseClasses.GainSurface phiSur(
    ATot=AFlo*ratSur,
    facMas=buiMas.facMas,
    AFlo=AFlo,
    HWinGai=HWin.G) "Heat flow injected to surface node"
    annotation (Placement(transformation(extent={{120,-10},{100,10}})));
  Modelica.Blocks.Math.Gain phiAir(k=0.5) "Heat flow injected to air node"
    annotation (Placement(transformation(extent={{120,70},{100,90}})));
  BaseClasses.GainMass phiMas(
    ATot=AFlo*ratSur,
    facMas=buiMas.facMas,
    AFlo=AFlo) "Heat flow injected to mass node"
    annotation (Placement(transformation(extent={{120,-90},{100,-70}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TVen "Supply air temperature"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));

protected
  parameter Real ratSur=4.5 "Ratio between the internal surfaces area and the floor area";
equation

  connect(TSur,HWin. port_b)
    annotation (Line(points={{40,0},{20,0}}, color={191,0,0}));
  connect(TAir, HVen.port_b)
    annotation (Line(points={{40,80},{20,80}}, color={191,0,0}));
  connect(TAir, HThe.port_b)
    annotation (Line(points={{40,80},{40,50}}, color={191,0,0}));
  connect(TAir, heaAir.port)
    annotation (Line(points={{40,80},{60,80}}, color={191,0,0}));
  connect(heaSur.port, TSur)
    annotation (Line(points={{60,0},{40,0}}, color={191,0,0}));
  connect(TSur, HMas.port_b)
    annotation (Line(points={{40,0},{40,-30}}, color={191,0,0}));
  connect(weaBus.TDryBul,TExt. T) annotation (Line(
      points={{-120,120},{-120,0},{-102,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TSur, HThe.port_a)
    annotation (Line(points={{40,0},{40,30}}, color={191,0,0}));
  connect(TSur,TSur)
    annotation (Line(points={{40,0},{40,0}}, color={191,0,0}));
  connect(Win.weaBus, weaBus) annotation (Line(
      points={{-100,-50},{-120,-50},{-120,120}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(Opa.weaBus, weaBus) annotation (Line(
      points={{-100,-90},{-120,-90},{-120,120}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(HWin.port_a,TExt. port)
    annotation (Line(points={{0,0},{-80,0}}, color={191,0,0}));
  connect(HTra.port_a, TExt.port) annotation (Line(points={{0,-80},{-20,-80},{-20,
          0},{-80,0}}, color={191,0,0}));
  connect(heaMas.port, HTra.port_b)
    annotation (Line(points={{60,-80},{20,-80}}, color={191,0,0}));
  connect(capMas.port, HTra.port_b)
    annotation (Line(points={{40,-110},{40,-80},{20,-80}}, color={191,0,0}));
  connect(HMas.port_a, HTra.port_b)
    annotation (Line(points={{40,-50},{40,-80},{20,-80}}, color={191,0,0}));
  connect(TVen.port, HVen.port_a)
    annotation (Line(points={{-80,80},{0,80}}, color={191,0,0}));
  connect(weaBus.TDryBul,TVen. T) annotation (Line(
      points={{-120,120},{-120,80},{-102,80}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(solGai.y, phiMas.solGai) annotation (Line(points={{-39,-70},{-32,-70},
          {-32,-104},{134,-104},{134,-88},{122,-88}}, color={0,0,127}));
  connect(phiSur.solGai, solGai.y) annotation (Line(points={{122,-8},{134,-8},{134,
          -104},{-32,-104},{-32,-70},{-39,-70}}, color={0,0,127}));
  connect(intSenGai, phiMas.intSenGai) annotation (Line(points={{-160,-120},{-32,
          -120},{-32,-134},{128,-134},{128,-84},{122,-84}}, color={0,0,127}));
  connect(phiSur.intSenGai, intSenGai) annotation (Line(points={{122,-4},{128,-4},
          {128,-134},{-32,-134},{-32,-120},{-160,-120}}, color={0,0,127}));
  connect(phiAir.u, intSenGai) annotation (Line(points={{122,80},{128,80},{128,-134},
          {-32,-134},{-32,-120},{-160,-120}}, color={0,0,127}));
  connect(phiMas.masGai, heaMas.Q_flow)
    annotation (Line(points={{99,-80},{80,-80}}, color={0,0,127}));
  connect(phiAir.y, heaAir.Q_flow)
    annotation (Line(points={{99,80},{80,80}}, color={0,0,127}));
  connect(phiSur.surGai, heaSur.Q_flow)
    annotation (Line(points={{99,0},{80,0}}, color={0,0,127}));
  connect(Win.solRadWin, solGai.u1) annotation (Line(points={{-79,-50},{-70,-50},
          {-70,-64},{-62,-64}}, color={0,0,127}));
  connect(Opa.y, solGai.u2) annotation (Line(points={{-79,-90},{-70,-90},{-70,-76},
          {-62,-76}}, color={0,0,127}));
  annotation (defaultComponentName="zon5R1C", Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,
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
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{60,-82},{118,-126}},
          textColor={0,0,0},
          textString="ISO"),
        Text(
          extent={{-182,-64},{-118,-110}},
          textColor={0,0,88},
          textString="intSenGai")}),
                                Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-140,-140},{140,140}})),
    Documentation(info="<html>
<p>
This is a lumped-capacity simplified building model based  on the 5R1C
network presented in the ISO 13790:2008 Standard. The simplified 5R1C model uses
five thermal resistances and one thermal capacity to reproduce the
transient thermal behaviour of buildings. The thermal zone is modeled with three
temperature nodes, the indoor air temperature <code>TAir</code>, the envelope internal
surface temperature <code>TSur</code> and the zone's mass temperature <code>TMas</code>
(the heat port is not shown in the figure), and two boundary
condition nodes, supply air temperature <code>TSup</code> and the external air temperature
<code>TExt</code>. The five resistances are related to heat transfer by ventilation <code>HVen</code>,
windows <code>HWin</code>, opaque components (split between <code>HTra</code> and <code>HMas</code>) and heat
transfer between the internal surfaces of walls and the air temperature <code>HThe</code>.
The thermal capacity <code>Cm</code> includes the thermal capacity of the entire zone. The heating and/or
cooling demand is found by calculating the heating and/or cooling power &Phi;HC that
needs to be supplied to, or extracted from, the internal air node to maintain a
certain set-point. Internal, &Phi;int , and solar, &Phi;sol, heat gains are input values,
which are split in three components.
</p>
<br>
<p align=\"center\">
<img src=\"modelica://IBPSA/Resources/Images/ThermalZones/ISO13790/Zone/5R1CNetwork.png\" alt=\"image\"/>
</p>
<br>
The ventilation heat transfer coefficient <code>Hve</code> is calculated using
<p align=\"center\" style=\"font-style:italic;\">
H<sub>ve</sub> =&rho;<sub>a</sub>c<sub>a</sub>&sum;<sub>k</sub>V&#775;<sub>k</sub>,
</p>
where <i>&rho;<sub>a</sub></i> is density of air, <i>c<sub>a</sub></i> is specific
heat of air and <i>V&#775;<sub>k</sub></i> is the k-th volumetric external air
flow rate.
The coupling conductance <code>H<sub>therm</sub></code> is given by
<p align=\"center\" style=\"font-style:italic;\">
H<sub>therm</sub> = h<sub>as</sub>A<sub>tot</sub>,
</p>
where <i>h<sub>as</sub></i> is the heat transfer coefficient between the air
node the surface node, with a fixed value of 3.45 W/m<sup>2</sup>K, and
<i>A<sub>tot</sub></i> is the area of all surfaces facing the building zone.
The thermal transmission coefficient of windows <code>Hwin</code> is calculated using
<p align=\"center\" style=\"font-style:italic;\">
H<sub>win</sub> =
&sum;<sub>k</sub>U<sub>win,k</sub>A<sub>win,k</sub>,
</p>
where <i>U<sub>win,k</sub></i> is the thermal transmittance of window element
k of the building envelope and <i>A<sub>k</sub></i>  is the area of the window
element k of the building envelope. The coupling conductance <code>Hmass</code> is given by
<p align=\"center\" style=\"font-style:italic;\">
H<sub>mass</sub> =h<sub>ms</sub>f<sub>ms</sub>A<sub>f</sub>,
</p>
where <i>h<sub>ms</sub></i> is the heat transfer coefficient between the mass
node and the surfacenode, with fixed value of 9.1 W/m<sup>2</sup>K,
<i>f<sub>ms</sub></i> is a correction factor, and <i>A<sub>f</sub></i>
is the floor area. The correction factor <i>f<sub>ms</sub></i> can be assumed
2.5 for light and medium building constructions, and 3 for heavy constructions.
The coupling conductance <code>Htrasm</code> is calculated using
<p align=\"center\" style=\"font-style:italic;\">
H<sub>trasm</sub> =
1 &frasl; (1 &frasl; H<sub>op</sub>-1 &frasl; H<sub>mass</sub>),
</p>
where <i>H<sub>op</sub></i> is the thermal transmission coefficient of opaque elements.
The three heat gains components are calculated using
<p align=\"center\" style=\"font-style:italic;\">
&Phi;<sub>air</sub> = 0.5&Phi;<sub>int</sub>,
</p>
<p align=\"center\" style=\"font-style:italic;\">
&Phi;<sub>sur</sub> = (1-f<sub>ms</sub>A<sub>f</sub> &frasl; A<sub>tot</sub>
-H<sub>win</sub> &frasl; h<sub>ms</sub>A<sub>tot</sub>)(0.5&Phi;<sub>int</sub>+
&Phi;<sub>sol</sub>),
</p>
<p align=\"center\" style=\"font-style:italic;\">
&Phi;<sub>mas</sub> = f<sub>ms</sub>A<sub>f</sub> &frasl; A<sub>tot</sub> (0.5&Phi;<sub>int</sub>+
&Phi;<sub>sol</sub>).
</p>
</html>",
revisions="<html>
<ul>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>"));
end Zone;
