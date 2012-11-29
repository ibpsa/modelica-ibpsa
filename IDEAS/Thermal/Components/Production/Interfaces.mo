within IDEAS.Thermal.Components.Production;
package Interfaces

extends Modelica.Icons.InterfacesPackage;

  model PartialDynamicHeaterWithLosses
    "Partial heater model incl dynamics and environmental losses"

    import IDEAS.Thermal.Components.Production.BaseClasses.HeaterType;
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
      annotation (Placement(transformation(extent={{90,-48},{110,-28}}),
          iconTransformation(extent={{90,-48},{110,-28}})));
    Thermal.Components.Interfaces.FlowPort_b flowPort_b(final medium=medium, h(
          min=1140947, max=1558647))
      annotation (Placement(transformation(extent={{90,10},{110,30}})));
    Modelica.Thermal.HeatTransfer.Components.HeatCapacitor mDry(C=cDry, T(start=TInitial))
      "Lumped dry mass subject to heat exchange/accumulation"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          rotation=90,
          origin={-40,-30})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalLosses(G=UALoss)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={-30,-70})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
      "heatPort for thermal losses to environment"
      annotation (Placement(transformation(extent={{-40,-110},{-20,-90}}),
          iconTransformation(extent={{-40,-110},{-20,-90}})));
    Modelica.Blocks.Interfaces.RealInput TSet
      "Temperature setpoint, acts as on/off signal too"
      annotation (Placement(transformation(extent={{-126,-20},{-86,20}}),
          iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={-10,120})));
    Modelica.Blocks.Interfaces.RealOutput PEl "Electrical consumption" annotation (Placement(transformation(
            extent={{-252,10},{-232,30}}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={10,-100})));
  equation

      connect(flowPort_a, heatedFluid.flowPort_a)
                                              annotation (Line(
        points={{100,-38},{-10,-38},{-10,-10}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(heatedFluid.flowPort_b, flowPort_b)
                                              annotation (Line(
        points={{-10,10},{-10,20},{100,20}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(mDry.port, heatedFluid.heatPort)
                                           annotation (Line(
        points={{-30,-30},{-30,6.12323e-016},{-20,6.12323e-016}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(mDry.port, thermalLosses.port_a)
                                      annotation (Line(
        points={{-30,-30},{-30,-30},{-30,-60},{-30,-60}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(thermalLosses.port_b, heatPort)
                                     annotation (Line(
        points={{-30,-80},{-30,-100}},
        color={191,0,0},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,120}}),
                        graphics), Icon(coordinateSystem(extent={{-100,-100},{
              100,120}}),               graphics));
  end PartialDynamicHeaterWithLosses;
end Interfaces;
