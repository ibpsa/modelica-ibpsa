within IDEAS.Thermal.Components.Production.Auxiliaries;
model PartialDynamicHeaterWithLosses
  "Partial heater model incl dynamics and environmental losses"

  import IDEAS.Thermal.Components.Production.Auxiliaries.HeaterType;
  parameter HeaterType heaterType
    "Type of the heater, is used mainly for post processing";
  parameter Modelica.SIunits.Temperature TInitial=293.15
    "Initial temperature of the water and dry mass";
  parameter Modelica.SIunits.Power QNom "Nominal power";
  parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water()
    "Medium in the component";

   Modelica.SIunits.Power PFuel "Fuel consumption";
  parameter Modelica.SIunits.Time tauHeatLoss=7200
    "Time constant of environmental heat losses";
  parameter Modelica.SIunits.Mass mWater=5 "Mass of water in the condensor";
  parameter Modelica.SIunits.HeatCapacity cDry=4800
    "Capacity of dry material lumped to condensor";

protected
  parameter Modelica.SIunits.ThermalConductance UALoss=(cDry + mWater*
      medium.cp)/tauHeatLoss;

public
  IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort
                                            heatedFluid(
    medium=medium,
    m=mWater,
    TInitial=TInitial)
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-10,0})));

  Thermal.Components.Interfaces.FlowPort_a flowPort_a(final medium=medium, h(
        min=1140947, max=1558647))
    annotation (Placement(transformation(extent={{90,-30},{110,-10}})));
  Thermal.Components.Interfaces.FlowPort_b flowPort_b(final medium=medium, h(
        min=1140947, max=1558647))
    annotation (Placement(transformation(extent={{90,10},{110,30}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor mDry(C=cDry, T(start=TInitial))
    "Lumped dry mass subject to heat exchange/accumulation"
    annotation (Placement(transformation(extent={{-76,32},{-56,52}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalLosses(G=UALoss)
    annotation (Placement(transformation(extent={{-32,22},{-12,42}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "heatPort for thermal losses to environment"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
        iconTransformation(extent={{-10,-110},{10,-90}})));
  Modelica.Blocks.Interfaces.RealInput TSet
    "Temperature setpoint, acts as on/off signal too"
    annotation (Placement(transformation(extent={{-126,-20},{-86,20}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,100})));
  Modelica.Blocks.Interfaces.RealOutput PEl "Electrical consumption" annotation (Placement(transformation(
          extent={{-252,10},{-232,30}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,-100})));
equation

    connect(flowPort_a, heatedFluid.flowPort_a)
                                            annotation (Line(
      points={{100,-20},{-10,-20},{-10,-10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(heatedFluid.flowPort_b, flowPort_b)
                                            annotation (Line(
      points={{-10,10},{-10,20},{100,20}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(mDry.port, heatedFluid.heatPort)
                                         annotation (Line(
      points={{-66,32},{-66,6.12323e-016},{-20,6.12323e-016}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(mDry.port, thermalLosses.port_a)
                                    annotation (Line(
      points={{-66,32},{-32,32}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalLosses.port_b, heatPort)
                                   annotation (Line(
      points={{-12,32},{0,32},{0,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics={
        Ellipse(
          extent={{-60,60},{58,-60}},
          lineColor={127,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Ellipse(extent={{-48,46},{46,-46}}, lineColor={95,95,95}),
        Line(
          points={{-32,34},{30,-34}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{98,20},{42,20}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{100,-20},{68,-20},{68,-80},{-2,-80},{-2,-46}},
          color={0,0,127},
          smooth=Smooth.None)}));
end PartialDynamicHeaterWithLosses;
