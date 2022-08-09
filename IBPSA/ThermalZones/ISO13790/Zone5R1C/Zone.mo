within IBPSA.ThermalZones.ISO13790.Zone5R1C;
model Zone "Thermal zone based on 5R1C network"

  parameter Real airRat(unit="1/h") "Air change rate"
  annotation (Dialog(group="Ventilation"));

  parameter Modelica.Units.SI.Area[4] AWin "Area of windows"
    annotation (Dialog(group="Windows"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer UWin
    "U-value of windows" annotation (Dialog(group="Windows"));

  parameter Modelica.Units.SI.Area[4] AWal
    "Area of external walls" annotation (Dialog(group="Opaque constructions"));
  parameter Modelica.Units.SI.Area ARoo "Area of roof"
    annotation (Dialog(group="Opaque constructions"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer UWal
    "U-value of external walls"
    annotation (Dialog(group="Opaque constructions"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer URoo
    "U-value of roof" annotation (Dialog(group="Opaque constructions"));

  parameter Modelica.Units.SI.Area AFlo "Net conditioned floor area";
  parameter Modelica.Units.SI.Volume VRoo "Volume of room";
  parameter Real facMas "Effective mass area factor";
  replaceable parameter ISO13790.Data.Generic buiMas "Building mass"
    annotation (choicesAllMatching=true);

  parameter Modelica.Units.SI.Angle surTil[4]={1.5707963267949,1.5707963267949,
      1.5707963267949,1.5707963267949} "Tilt angle of surfaces";

  parameter Modelica.Units.SI.Angle surAzi[4]={3.1415926535898,-1.5707963267949,
      0,1.5707963267949} "Azimuth angle of surfaces";

  parameter Real winFra(min=0, max=1)=0.01 "Frame fraction of windows"
    annotation(Dialog(group="Windows"));
  parameter Real gFac(min=0, max=1) "Energy transmittance of glazings"
    annotation(Dialog(group="Windows"));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor HVen(G=airRat*VRoo*
        1005*1.2/3600) "Heat transfer due to ventilation"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor HTra(G=1/(1/(UWal*
        AWal[1] + UWal*AWal[2] + UWal*AWal[3] + UWal*AWal[4] + URoo*ARoo) - 1/(
        9.1*facMas*AFlo))) "Heat transfere through opaque elements"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor HWin(G=UWin*AWin[1] +
        UWin*AWin[2] + UWin*AWin[3] + UWin*AWin[4])
    "Heat transfer through glazed elements"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor HThe(G=3.45*(AWal[1]
         + AWin[1] + AWal[2] + AWin[2] + AWal[3] + AWin[3] + AWal[4] + AWin[4]
         + AFlo + ARoo)) "Coupling conductancec betwee air and surface nodes"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,40})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor HMas(G=9.1*facMas*AFlo)
    "Coupling conductancec between surface and mass nodes" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,-40})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capMas(C=buiMas.heaC*
        AFlo, T(
      displayUnit="K",
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
                                                      iconTransformation(extent={{-126,78},
            {-62,142}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TExt
    "External air temperature"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

  Modelica.Blocks.Math.Add solGai "Total solar heat gains"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));



  BaseClasses.GlazedElements glaEle(
    AWin=AWin,
    winFra=winFra,
    surTil=surTil,
    surAzi=surAzi,
    gFac=gFac) "Solar heat gains of glazed elements"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  BaseClasses.OpaqueElements opaEle(
    AWal=AWal,
    UWal=UWal,
    ARoo=ARoo,
    URoo=URoo,
    surTil={1.5707963267949,1.5707963267949,1.5707963267949,1.5707963267949,0},
    surAzi={surAzi[1],surAzi[2],surAzi[3],
        surAzi[4],0}) "Solar heat gains of opaque elements"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Interfaces.RealInput intGai "Internal heat gains"
    annotation (Placement(transformation(extent={{-180,-140},{-140,-100}})));
  BaseClasses.GainSurface phiSur(
    ATot=AWal[1] + AWin[1] + AWal[2] + AWin[2] + AWal[3] + AWin[3] + AWal[4] +
        AWin[4] + AFlo + ARoo,
    facMas=facMas,
    AFlo=AFlo,
    HWinGai=HWin.G) "Heat flow injected to surface node"
    annotation (Placement(transformation(extent={{120,-10},{100,10}})));

  Modelica.Blocks.Math.Gain phiAir(k=0.5) "Heat flow injected to air node"
    annotation (Placement(transformation(extent={{120,70},{100,90}})));
  BaseClasses.GainMass phiMas(
    ATot=AWal[1] + AWin[1] + AWal[2] + AWin[2] + AWal[3] + AWin[3] + AWal[4] +
        AWin[4] + AFlo + ARoo,
    facMas=facMas,
    AFlo=AFlo) "Heat flow injected to mass node"
    annotation (Placement(transformation(extent={{120,-90},{100,-70}})));



  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TVen
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
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
  connect(glaEle.weaBus, weaBus) annotation (Line(
      points={{-100,-50},{-120,-50},{-120,120}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(opaEle.weaBus, weaBus) annotation (Line(
      points={{-100,-90.9524},{-120,-90.9524},{-120,120}},
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
  connect(solGai.u1, glaEle.solRadWin) annotation (Line(points={{-62,-64},{-72,
          -64},{-72,-50},{-79.2857,-50}}, color={0,0,127}));
  connect(solGai.u2, opaEle.SolRadOpa) annotation (Line(points={{-62,-76},{-72,
          -76},{-72,-89.5238},{-79.5455,-89.5238}}, color={0,0,127}));
  connect(phiSur.solGai, solGai.y) annotation (Line(points={{122,-8},{128,-8},{
          128,-102},{-30,-102},{-30,-70},{-39,-70}}, color={0,0,127}));
  connect(phiMas.solGai, solGai.y) annotation (Line(points={{122,-88},{128,-88},
          {128,-102},{-30,-102},{-30,-70},{-39,-70}}, color={0,0,127}));
  connect(phiAir.y, heaAir.Q_flow)
    annotation (Line(points={{99,80},{80,80}}, color={0,0,127}));
  connect(phiSur.surGai, heaSur.Q_flow)
    annotation (Line(points={{99,0},{80,0}}, color={0,0,127}));
  connect(phiMas.masGai, heaMas.Q_flow)
    annotation (Line(points={{99,-80},{80,-80}}, color={0,0,127}));
  connect(phiAir.u, intGai) annotation (Line(points={{122,80},{134,80},{134,
          -134},{-70,-134},{-70,-120},{-160,-120}}, color={0,0,127}));
  connect(phiSur.intGai, intGai) annotation (Line(points={{122,-4},{134,-4},{
          134,-134},{-70,-134},{-70,-120},{-160,-120}}, color={0,0,127}));
  connect(phiMas.intGai, intGai) annotation (Line(points={{122,-84},{134,-84},{
          134,-134},{-70,-134},{-70,-120},{-160,-120}}, color={0,0,127}));
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
          lineColor={0,0,255},
          textString="%name")}),Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-140,-140},{140,140}})),
    Documentation(info="<html>
<p>
This is a lumped-capacitance simplified building model based  on the 5R1C 
network presented in the ISO 13790:2008 Standard. The simplified 5R1C model uses
five thermal resistances and one thermal capacitance to reproduce the 
transient thermal behaviour of buildings. The thermal zone is modeled with three 
temperature nodes, the indoor air temperature <code>Tair</code>, the envelope internal 
surface temperature <code>Tsur</code> and the building mass temperature Tmas (heat port neglected), and two boundary
condition nodes, supply air temperature <code>Tsup</code> and the external air temperature 
<code>Text</code>. The five resistances are related to heat transfer by ventilation <code>Hve</code>, 
windows <code>Hwin</code>, opaque components (split between <code>Htrasm</code> and <code>Hmass</code>) and heat 
transfer between the internal surfaces of walls and the air temperature <code>Htherm</code>.
The thermal capacitance <code>Cm</code> includes the thermal capacity of the entire building. The heating and/or 
cooling demand is found by calculating the heating and/or cooling power ΦHC that
needs to be supplied to, or extracted from, the internal air node to maintain a 
certain set-point. Internal, Φint , and solar, Φsol, heat gains are input values,
which are split in three components.
</p>
<br>
<p align=\"center\">
<img src=\"modelica://IBPSA/Resources/Images/ThermalZones/ISO13790/Zone/5R1CNetwork.png\" alt=\"image\"/>
</p>
<br>
The ventilation heat transfer coefficient <code>Hve</code> is calculated using
<p align=\"center\" style=\"font-style:italic;\">
H<sub>ve</sub> =
  &rho;<sub>a</sub>c<sub>a</sub>&sum;<sub>k</sub>V&#775;<sub>k</sub>
  </p>
  where <i>ρ<sub>a</sub></i> is density of air, <i>c<sub>a</sub></i> is specific 
  heat of air and <i>V&#775;<sub>k</sub></i> is the k-th volumetric external air
  flow rate.
  
  The coupling conductance <code>Htherm</code> is given by
<p align=\"center\" style=\"font-style:italic;\">
H<sub>therm</sub> =
  h<sub>as</sub>A<sub>tot</sub>
  </p>
  where <i>h<sub>as</sub></i> is the heat transfer coefficient between the air 
  node the surface node, with a fixed value of 3.45 W/m<sup>2</sup>K, and
  <i>A<sub>tot</sub></i> is the area of all surfaces facing the building zone.
  
  The thermal transmission coefficient of windows <code>Hwin</code> is calculated using
<p align=\"center\" style=\"font-style:italic;\">
H<sub>win</sub> =
  &sum;<sub>k</sub>U<sub>win,k</sub>A<sub>win,k</sub>
  </p>
  where <i>U<sub>win,k</sub></i> is the thermal transmittance of window element 
  k of the building envelope and <i>A<sub>k</sub></i>  is the area of the window
  element k of the building envelope.
  
  The coupling conductance <code>Hmass</code> is given by
<p align=\"center\" style=\"font-style:italic;\">
H<sub>mass</sub> =
  h<sub>ms</sub>f<sub>ms</sub>A<sub>f</sub>
  </p>
  where <i>h<sub>ms</sub></i> is the heat transfer coefficient between the mass 
  node and the surfacenode, with fixed value of 9.1 W/m<sup>2</sup>K, 
  <i>f<sub>ms</sub></i> is a correction factor, and <i>A<sub>f</sub></i>
  is the floor area. The correction factor <i>f<sub>ms</sub></i> can be assumed 
  2.5 for light and medium building constructions, and 3 for heavy constructions.
  
  The coupling conductance <code>Htrasm</code> is calculated using
<p align=\"center\" style=\"font-style:italic;\">
H<sub>trasm</sub> =
1 &frasl; (1 &frasl; H<sub>op</sub>-1 &frasl; H<sub>mass</sub>)
  </p>
  where <i>H<sub>op</sub></i> is the thermal transmission coefficient of opaque elements.
  
  The three heat gains components are calculated using
  
<p align=\"center\" style=\"font-style:italic;\">
&Phi;<sub>air</sub> = 0.5&Phi;<sub>int</sub>
</p>
<p align=\"center\" style=\"font-style:italic;\">
&Phi;<sub>sur</sub> = (1-f<sub>ms</sub>A<sub>f</sub> &frasl; A<sub>tot</sub>
-H<sub>win</sub> &frasl; h<sub>ms</sub>A<sub>tot</sub>)(0.5&Phi;<sub>int</sub>+
&Phi;<sub>sol</sub>)</p>
<p align=\"center\" style=\"font-style:italic;\">
&Phi;<sub>mas</sub> = f<sub>ms</sub>A<sub>f</sub> &frasl; A<sub>tot</sub> (0.5&Phi;<sub>int</sub>+
&Phi;<sub>sol</sub>)
</p>
  
  </html>",
  revisions="<html>
<ul>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>",
        info="<html>
<p>
Mass data for heavy building
</p>
</html>"));
end Zone;
