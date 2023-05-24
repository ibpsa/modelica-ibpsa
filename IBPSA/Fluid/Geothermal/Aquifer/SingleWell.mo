within IBPSA.Fluid.Geothermal.Aquifer;
model SingleWell
  "Model of a single well for aquifer thermal energy storage"
 replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component" annotation (choices(
        choice(redeclare package Medium = IBPSA.Media.Air "Moist air"),
        choice(redeclare package Medium = IBPSA.Media.Water "Water"),
        choice(redeclare package Medium =
            IBPSA.Media.Antifreeze.PropyleneGlycolWater (
              property_T=293.15,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));
  parameter Integer nVol(min=1)=10 "Number of volumes" annotation (
      Dialog(group="Domain discretization"));
  parameter Modelica.Units.SI.Height h=200 "Aquifer thickness";
  parameter Real phi=0.2 "Reservoir porosity";
  parameter Modelica.Units.SI.Radius r_wb=0.1 "Wellbore radius" annotation (
      Dialog(group="Domain discretization"));
  parameter Modelica.Units.SI.Radius r_max=2400 "Domain radius" annotation (
      Dialog(group="Domain discretization"));
  parameter Real griFac(min=1) = 1.15 "Grid factor for spacing" annotation (
      Dialog(group="Domain discretization"));
  parameter Modelica.Units.SI.Temperature T_ini=273.15+10 "Initial temperature of domain" annotation (
      Dialog(group="Domain discretization"));
  parameter Modelica.Units.SI.Density rhoAqu=2680 "Density of aquifer" annotation (
      Dialog(group="Properties of aquifer"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cpAqu=833 "Specific heat capacity of aquifer" annotation (
      Dialog(group="Properties of aquifer"));
  parameter Modelica.Units.SI.ThermalConductivity kAqu=2.8 "Thermal conductivity of aquifer" annotation (
      Dialog(group="Properties of aquifer"));
  parameter Modelica.Units.SI.Temperature TGro=273.15+12 "Undirsturbed ground temperature" annotation (
      Dialog(group="Properties of ground"));

  IBPSA.Fluid.MixingVolumes.MixingVolume vol[nVol](
    redeclare final package Medium=Medium,
    each T_start=T_ini,
    each m_flow_nominal=1,
    V=VWat,
    each nPorts=2)
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare final package Medium=Medium)
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  IBPSA.Fluid.Sources.Boundary_pT bou(redeclare final package Medium=Medium,
    T=T_ini,
    nPorts=1)
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCap[nVol](C=C,
      each T(start=T_ini))
    annotation (Placement(transformation(extent={{-52,-40},{-32,-20}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor theRes[nVol](R=R)
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature groTem(T=TGro)
    annotation (Placement(transformation(extent={{90,-50},{70,-30}})));
  IBPSA.Fluid.FixedResistances.PressureDrop res(redeclare final package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=1
    "Pressure drop at nominal mass flow rate";
protected
  parameter Modelica.Units.SI.Radius r[nVol + 1](each fixed=false)
    "Radius to the boundary of the i-th domain";
  parameter Modelica.Units.SI.Radius rC[nVol](each fixed=false)
    "Radius to the center of the i-th domain";
  parameter Modelica.Units.SI.SpecificHeatCapacity cpWat(fixed=false)
    "Water specific heat capacity";
  parameter Modelica.Units.SI.Density rhoWat(fixed=false)
    "Water density";
  parameter Modelica.Units.SI.ThermalConductivity kWat(fixed=false)
    "Water thermal conductivity";
  parameter Modelica.Units.SI.HeatCapacity C[nVol](each fixed=false)
    "Heat capacity of segment";
  parameter Modelica.Units.SI.Volume VWat[nVol](each fixed=false)
    "Volumes of water";
  parameter Modelica.Units.SI.ThermalResistance R[nVol+1](each fixed=false)
    "Thermal resistances between nodes";
  parameter Real cAqu(each fixed=false)
    "Heat capacity normalized with volume for aquifer";
  parameter Real kVol(each fixed=false)
    "Heat conductivity normalized with volume";

initial equation
  assert(r_wb < r_max, "Error: Model requires r_wb < r_max");
  assert(0 < r_wb,   "Error: Model requires 0 < r_wb");

  cAqu=rhoAqu*cpAqu*(1-phi);
  kVol=kWat*phi+kAqu*(1-phi);

  cpWat=Medium.specificHeatCapacityCp(Medium.setState_pTX(
    Medium.p_default,
    Medium.T_default,
    Medium.X_default));
  rhoWat=Medium.density(Medium.setState_pTX(
    Medium.p_default,
    Medium.T_default,
    Medium.X_default));
  kWat=Medium.thermalConductivity(Medium.setState_pTX(
    Medium.p_default,
    Medium.T_default,
    Medium.X_default));

  r[1] = r_wb;
  for i in 2:nVol+1 loop
    r[i]= r[i-1] + (r_max - r_wb)  * (1-griFac)/(1-griFac^(nVol)) * griFac^(i-2);
  end for;
  for i in 1:nVol loop
    rC[i] = (r[i]+r[i+1])/2;
  end for;
  for i in 1:nVol loop
    C[i] = cAqu*h*3.14*(r[i+1]^2-r[i]^2);
  end for;
  for i in 1:nVol loop
    VWat[i] = phi*h*3.14*(r[i+1]^2-r[i]^2);
  end for;
  R[1]=Modelica.Math.log(rC[1]/r_wb)/(2*Modelica.Constants.pi*kVol*h);
  R[nVol+1]=Modelica.Math.log(r_max/rC[nVol])/(2*Modelica.Constants.pi*kVol*h);
  for i in 2:nVol loop
  R[i] = Modelica.Math.log(rC[i]/rC[i-1])/(2*Modelica.Constants.pi*kVol*h);
  end for;

equation

  if nVol > 1 then
    for i in 1:(nVol - 1) loop
      connect(vol[i].ports[1], vol[i + 1].ports[1]);
    end for;
  end if;
  if nVol > 1 then
    for i in 1:(nVol - 1) loop
      connect(heaCap[i + 1].port, theRes[i].port_b);
    end for;
  end if;

  connect(groTem.port, theRes[nVol].port_b)
    annotation (Line(points={{70,-40},{50,-40}}, color={191,0,0}));
  connect(bou.ports[1], vol[nVol].ports[2]) annotation (Line(points={{40,0},{1,0},
          {1,20}},       color={0,127,255}));

  connect(vol.heatPort, heaCap.port) annotation (Line(points={{-10,30},{-20,30},
          {-20,-12},{0,-12},{0,-40},{-42,-40}}, color={191,0,0}));
  connect(theRes.port_a, vol.heatPort) annotation (Line(points={{30,-40},{0,-40},
          {0,-12},{-20,-12},{-20,30},{-10,30}}, color={191,0,0}));
  connect(port_a, res.port_a)
    annotation (Line(points={{0,100},{0,60},{-80,60},{-80,0},{-60,0}},
                                                color={0,127,255}));
  connect(res.port_b, vol[1].ports[1])
    annotation (Line(points={{-40,0},{-1,0},{-1,20}},
                                                    color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-20,100},{20,-2}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{20,2},{-20,-6}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={211,168,137},
          fillPattern=FillPattern.Forward),
        Rectangle(
          extent={{-100,20},{100,-48}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-100,100},{100,82}},
          lineColor={0,0,0},
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-36,100},{36,-16}},
          fillColor={218,218,218},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{36,-8},{-36,-24}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-147,-108},{153,-148}},
          textColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        defaultComponentName="aquWel",
        Documentation(info="<html>
<p>
This model simulates aquifer thermal energy storage.
</p>
<p>
To calculate aquifer temperature at different locations over time, the model applies 
theoretical principles of water flow and heat transfer phenomena. The model is based on 
the partial differential equation (PDE) for 1D conductive-convective transient 
radial heat transport in porous media
<p align=\"center\" style=\"font-style:italic;\">
&rho; c (&part; T(r,t) &frasl; &part;t) =
k (&part;&sup2; T(r,t) &frasl; &part;r&sup2;) - &rho;<sub>w</sub> c<sub>w</sub> u(&part; T(r,t) &frasl; &part;t),
</p>
<p>
where
<i>&rho;</i>
is the mass density,
<i>c</i>
is the specific heat capacity per unit mass,
<i>T</i>
is the temperature at location <i>r</i> and time <i>t</i>,
<i>u</i> is water velocity and
<i>k</i> is the heat conductivity. The subscript <i>w</i> indicates water.
The first term on the right hand side of the equation describes the effect of conduction, while
the second term describes the fluid flow. 
<h4>Spatial discretization</h4>
To discretize the conductive-convective equation, the domain is divided into a series 
of thermal capacitances and thermal resistances along the radial direction. The 
implementation uses an array of 
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Components.HeatCapacitor\">Modelica.Thermal.HeatTransfer.Components.HeatCapacitor</a>
and <a href=\"modelica://Modelica.Thermal.HeatTransfer.Components.ThermalResistor\">Modelica.Thermal.HeatTransfer.Components.ThermalResistor</a>
Fluid flow was modelled by adding a series of fluid volumes, which are connected 
to the thermal capacitances via heat ports. The fluid stream was developed using 
the model <a href=\"modelica://IBPSA.Fluid.MixingVolumes.MixingVolume\">IBPSA.Fluid.MixingVolumes.MixingVolume</a>.
The geometric representation of the model is illustrated in the figure below. 

</p>
<p align=\"center\">
<img  alt=\"image\" src=\"modelica://IBPSA/Resources/Images/Fluid/Geothermal/Aquifer/Geometry.png\" width=\"800\">
</p>
</html>", revisions="<html>
<ul>
<li>
May 2023, by Alessandro Maccarini:<br/>
First Implementation.
</li>
</ul>
</html>"));
end SingleWell;
