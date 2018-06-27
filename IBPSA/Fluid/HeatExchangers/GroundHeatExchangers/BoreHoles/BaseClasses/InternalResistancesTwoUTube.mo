within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BaseClasses;
model InternalResistancesTwoUTube

  parameter Modelica.SIunits.Length hSeg
    "Length of the internal heat exchanger";
  parameter Modelica.SIunits.Temperature T_start
    "Initial temperature of the filling material";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Data.BorefieldData.Template borFieDat "Borefield data"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  parameter Modelica.SIunits.HeatCapacity Co_fil=borFieDat.filDat.d*borFieDat.filDat.c*hSeg*Modelica.Constants.pi
      *(borFieDat.conDat.rBor^2 - 4*(borFieDat.conDat.rTub + borFieDat.conDat.eTub)^2)
    "Heat capacity of the whole filling material";
  parameter Modelica.SIunits.ThermalResistance Rgb_val
    "Thermal resistance between a grout capacity and the borehole wall, as defined by Bauer et al (2010)";
  parameter Modelica.SIunits.ThermalResistance Rgg1_val
    "Thermal resistance between two neightbouring grout capacities, as defined by Bauer et al (2010)";
  parameter Modelica.SIunits.ThermalResistance Rgg2_val
    "Thermal resistance between two  grout capacities opposite to each other, as defined by Bauer et al (2010)";
  parameter Modelica.SIunits.ThermalResistance RCondGro_val
    "Thermal resistance between a pipe wall and the grout capacity, as defined by Bauer et al (2010)";
  parameter Real x "Capacity location";
  parameter Boolean dynFil=true
      "Set to false to remove the dynamics of the filling material."
      annotation (Dialog(tab="Dynamics"));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_1
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_wall
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rpg1(R=RCondGro_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=90,
        origin={0,80})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb1(R=Rgb_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=90,
        origin={0,30})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rpg2(R=RCondGro_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{-8,8},{8,-8}},
        rotation=180,
        origin={80,1.77636e-015})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb2(R=Rgb_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=0,
        origin={30,0})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rpg3(R=RCondGro_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{-8,8},{8,-8}},
        rotation=90,
        origin={0,-80})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb3(R=Rgb_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{-8,8},{8,-8}},
        rotation=90,
        origin={0,-30})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rpg4(R=RCondGro_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=180,
        origin={-80,1.77636e-015})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb4(R=Rgb_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=180,
        origin={-30,0})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg11(R=Rgg1_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=90,
        origin={90,30})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg21(R=Rgg2_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=270,
        origin={50,30})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg12(R=Rgg1_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=90,
        origin={50,-30})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg22(R=Rgg1_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=180,
        origin={32,-92})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg14(R=Rgg1_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=90,
        origin={-50,30})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg13(R=Rgg2_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=90,
        origin={-50,-30})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil1(T(start=
          T_start, fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
      der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial)),
    C=Co_fil/4) if  dynFil "Heat capacity of the filling material"
                                            annotation (Placement(
        transformation(
        extent={{-72,28.8},{-56,12.8}},
        rotation=90,
        origin={42.8,124})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil2(T(start=
          T_start, fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
      der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial)),
    C=Co_fil/4) if   dynFil "Heat capacity of the filling material"
                                            annotation (Placement(
        transformation(
        extent={{63,-25.2},{49,-11.2}},
        rotation=180,
        origin={117,-25.2})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil3(T(start=
          T_start, fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
      der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial)),
    C=Co_fil/4) if  dynFil "Heat capacity of the filling material"
                                            annotation (Placement(
        transformation(
        extent={{63,25.2},{49,11.2}},
        rotation=270,
        origin={-25.2,-3})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil4(T(start=
          T_start, fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
      der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial)),
    C=Co_fil/4) if  dynFil "Heat capacity of the filling material"
                                            annotation (Placement(
        transformation(
        extent={{70.2,27.648},{54.6,12.288}},
        rotation=180,
        origin={2.2,27.648})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_2
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_3
    annotation (Placement(transformation(extent={{-10,-90},{10,-110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_4
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
equation
  connect(Rpg2.port_a, port_2) annotation (Line(points={{88,7.77156e-016},{96,7.77156e-016},
          {96,0},{100,0}}, color={191,0,0}));
  connect(Rpg4.port_a, port_4) annotation (Line(points={{-88,2.77556e-015},{-100,
          2.77556e-015},{-100,-2},{-100,0}}, color={191,0,0}));
  connect(Rpg1.port_a, port_1) annotation (Line(points={{4.44089e-016,88},{0,88},
          {0,100}}, color={191,0,0}));
  connect(Rgb1.port_b, port_wall)
    annotation (Line(points={{0,22},{0,22},{0,0}}, color={191,0,0}));
  connect(Rgb4.port_b, port_wall) annotation (Line(points={{-22,-8.88178e-016},{
          0,-8.88178e-016},{0,0}}, color={191,0,0}));
  connect(Rgb2.port_b, port_wall)
    annotation (Line(points={{22,0},{22,0},{0,0}}, color={191,0,0}));
  connect(Rgb3.port_b, port_wall) annotation (Line(points={{4.44089e-016,-22},{0,
          -22},{0,0}}, color={191,0,0}));
  connect(Rpg3.port_a, port_3)
    annotation (Line(points={{0,-88},{0,-100},{0,-100}}, color={191,0,0}));
  connect(Rgg11.port_a, Rpg1.port_b) annotation (Line(points={{90,38},{90,38},{
          90,70},{0,70},{0,72}},        color={191,0,0}));
  connect(Rgg21.port_b, Rgb1.port_a) annotation (Line(points={{50,38},{50,38},{
          50,50},{0,50},{0,38},{4.44089e-016,38}}, color={191,0,0}));
  connect(Rgb1.port_a, Rpg1.port_b) annotation (Line(points={{4.44089e-016,38},
          {0,38},{0,72}}, color={191,0,0}));
  connect(Rgg14.port_a, Rgb1.port_a) annotation (Line(points={{-50,38},{-50,38},
          {-50,50},{0,50},{0,38}}, color={191,0,0}));
  connect(capFil1.port, Rpg1.port_b)
    annotation (Line(points={{14,60},{0,60},{0,72}}, color={191,0,0}));
  connect(Rgg12.port_a, Rpg2.port_b)
    annotation (Line(points={{50,-22},{50,0},{72,0}}, color={191,0,0}));
  connect(Rgg21.port_a, Rpg2.port_b) annotation (Line(points={{50,22},{50,22},{
          50,8},{50,0},{72,0}}, color={191,0,0}));
  connect(Rgg22.port_b, Rpg2.port_b) annotation (Line(points={{40,-92},{56,-92},
          {68,-92},{68,0},{72,0}}, color={191,0,0}));
  connect(Rgb2.port_a, Rpg2.port_b)
    annotation (Line(points={{38,0},{56,0},{72,0}}, color={191,0,0}));
  connect(capFil2.port, Rpg2.port_b) annotation (Line(points={{61,9.76996e-015},
          {62,9.76996e-015},{62,0},{72,0},{72,2.77556e-015}}, color={191,0,0}));
  connect(Rgg13.port_b, Rpg3.port_b) annotation (Line(points={{-50,-38},{-50,
          -38},{-50,-50},{0,-50},{0,-72}}, color={191,0,0}));
  connect(Rgg12.port_b, Rpg3.port_b) annotation (Line(points={{50,-38},{50,-50},
          {4.44089e-016,-50},{4.44089e-016,-72}}, color={191,0,0}));
  connect(Rgg11.port_b, Rpg3.port_b) annotation (Line(points={{90,22},{90,22},{
          90,-50},{0,-50},{0,-72}}, color={191,0,0}));
  connect(Rgb3.port_a, Rpg3.port_b)
    annotation (Line(points={{0,-38},{0,-38},{0,-72}}, color={191,0,0}));
  connect(capFil3.port, Rpg3.port_b) annotation (Line(points={{-8.88178e-015,
          -59},{0,-59},{0,-60},{4.44089e-016,-60},{4.44089e-016,-72}}, color={
          191,0,0}));
  connect(Rgg22.port_a, Rpg4.port_b) annotation (Line(points={{24,-92},{-18,-92},
          {-60,-92},{-60,0},{-72,0}}, color={191,0,0}));
  connect(Rpg4.port_b, capFil4.port) annotation (Line(points={{-72,0},{-60.2,0},
          {-60.2,7.10543e-015}}, color={191,0,0}));
  connect(Rgg13.port_a, Rpg4.port_b) annotation (Line(points={{-50,-22},{-50,
          -22},{-50,0},{-50,8.88178e-016},{-72,8.88178e-016}}, color={191,0,0}));
  connect(Rgg14.port_b, Rpg4.port_b) annotation (Line(points={{-50,22},{-50,22},
          {-50,0},{-50,0},{-72,0}}, color={191,0,0}));
  connect(Rgb4.port_a, Rpg4.port_b)
    annotation (Line(points={{-38,0},{-56,0},{-72,0}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end InternalResistancesTwoUTube;
