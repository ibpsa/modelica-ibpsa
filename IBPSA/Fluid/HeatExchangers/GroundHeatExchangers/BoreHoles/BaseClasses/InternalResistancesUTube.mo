within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BaseClasses;
model InternalResistancesUTube
  parameter Modelica.SIunits.Temperature T_start
    "Initial temperature of the filling material";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Data.BorefieldData.Template borFieDat "Borefield data"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  parameter Modelica.SIunits.HeatCapacity Co_fil=borFieDat.filDat.d*borFieDat.filDat.c*borFieDat.conDat.hSeg*Modelica.Constants.pi
      *(borFieDat.conDat.rBor^2 - 2*(borFieDat.conDat.rTub + borFieDat.conDat.eTub)^2)
    "Heat capacity of the whole filling material";
  parameter Real Rgb_val
    "Thermal resistance between grout zone and borehole wall";
  parameter Real Rgg_val "Thermal resistance between the two grout zones";
  parameter Real RCondGro_val
    "Thermal resistance between: pipe wall to capacity in grout";
  parameter Real x "Capacity location";
  parameter Boolean dynFil=true
      "Set to false to remove the dynamics of the filling material."
      annotation (Dialog(tab="Dynamics"));

  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rpg1(R=RCondGro_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{-12,-12},{12,12}},
        rotation=270,
        origin={0,70})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rpg2(R=RCondGro_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{-12,-12},{12,12}},
        rotation=90,
        origin={0,-70})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb1(R=Rgb_val)
    "Grout thermal resistance"
    annotation (Placement(transformation(extent={{38,28},{62,52}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb2(R=Rgb_val)
    "Grout thermal resistance"
    annotation (Placement(transformation(extent={{38,-52},{62,-28}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg(R=Rgg_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={0,0})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil1(
    C=Co_fil/2,
    T(start=T_start, fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
    der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial))) if     dynFil
    "Heat capacity of the filling material" annotation (Placement(
        transformation(
        extent={{-90,36},{-70,16}},
        rotation=270,
        origin={-68,-40})));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil2(
    C=Co_fil/2,
    T(start=T_start, fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
    der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial))) if       dynFil
    "Heat capacity of the filling material" annotation (Placement(
        transformation(
        extent={{-90,36},{-70,16}},
        rotation=270,
        origin={-66,-120})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_1
    "Thermal connection for pipe 1"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_2
    "Thermal connection for pipe 2"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_wall
    "Thermal connection for borehole wall"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation
  connect(capFil1.port, Rgb1.port_a) annotation (Line(
      points={{-32,40},{38,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(capFil2.port, Rgb2.port_a) annotation (Line(
      points={{-30,-40},{38,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rpg1.port_b, Rgb1.port_a) annotation (Line(
      points={{-2.22045e-015,58},{0,58},{0,40},{38,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rgg.port_a, Rgb1.port_a) annotation (Line(
      points={{2.22045e-015,12},{2.22045e-015,40},{38,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rpg2.port_b, Rgb2.port_a) annotation (Line(
      points={{8.88178e-016,-58},{0,-58},{0,-40},{38,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rgg.port_b, Rgb2.port_a) annotation (Line(
      points={{-2.22045e-015,-12},{-2.22045e-015,-40},{38,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Rpg1.port_a, port_1) annotation (Line(points={{2.22045e-015,82},{2.22045e-015,
          100},{0,100}}, color={191,0,0}));
  connect(Rpg2.port_a, port_2)
    annotation (Line(points={{0,-82},{0,-100}}, color={191,0,0}));
  connect(Rgb1.port_b, port_wall) annotation (Line(points={{62,40},{82,40},{100,
          40},{100,0}}, color={191,0,0}));
  connect(Rgb2.port_b, port_wall)
    annotation (Line(points={{62,-40},{100,-40},{100,0}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end InternalResistancesUTube;
