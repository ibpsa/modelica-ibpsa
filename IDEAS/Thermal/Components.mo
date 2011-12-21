within IDEAS.Thermal;
package Components

  extends Modelica.Icons.Package;

  package Production "Package for heat/cold production devices"
    extends Modelica.Icons.Package;

    package Auxiliaries
      "Partials, submodels and general stuff to be used in other HVAC models"

      type HeaterType = enumeration(
          HP_AW "Air/water Heat pump",
          HP_BW "Brine/water Heat pump",
          HP_BW_Collective "Brine/water HP with collective borefield",
          Boiler "Boiler")
        "Type of the heater: heat pump, gas boiler, fuel boiler, pellet boiler, ...";
      model PartialDynamicHeaterWithLosses
        "Partial heater model incl dynamics and environmental losses"

        import IDEAS.Thermal.Components.Production.Auxiliaries.HeaterType;
        parameter HeaterType heaterType
          "Type of the heater, is used mainly for post processing";
        parameter Modelica.SIunits.Temperature TInitial=293.15
          "Initial temperature of the water and dry mass";
        parameter Modelica.SIunits.Power QNom "Nominal power";
        parameter TME.FHF.Interfaces.Medium
                                       medium=TME.FHF.Media.Water()
          "Medium in the component";
         Modelica.SIunits.Power PEl "Electrical consumption";
         Modelica.SIunits.Power PFuel "Fuel consumption";
        parameter Modelica.SIunits.Time tauHeatLoss=7200
          "Time constant of environmental heat losses";
        parameter Modelica.SIunits.Mass mWater=5
          "Mass of water in the condensor";
        parameter Modelica.SIunits.HeatCapacity cDry=4800
          "Capacity of dry material lumped to condensor";

      protected
        parameter Modelica.SIunits.ThermalConductance UALoss=(cDry + mWater*
            medium.cp)/tauHeatLoss;

      public
        IDEAS.Thermal.Components.BaseClasses.HeatedPipe
                                      heatedFluid(
          medium=medium,
          m=mWater,
          TInitial=TInitial)
          annotation (Placement(transformation(extent={{-10,10},{10,-10}},
              rotation=90,
              origin={-10,0})));

        IDEAS.Thermal.Components.Interfaces.FlowPort_a
                                      flowPort_a(final medium=medium, h(min=
                1140947, max=1558647))
          annotation (Placement(transformation(extent={{90,-30},{110,-10}})));
        IDEAS.Thermal.Components.Interfaces.FlowPort_b
                                      flowPort_b(final medium=medium, h(min=
                1140947, max=1558647))
          annotation (Placement(transformation(extent={{90,10},{110,30}})));
        Modelica.Thermal.HeatTransfer.Components.HeatCapacitor mDry(C=cDry, T(start=TInitial))
          "Lumped dry mass subject to heat exchange/accumulation"
          annotation (Placement(transformation(extent={{-76,32},{-56,52}})));
        Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalLosses(G=UALoss)
          annotation (Placement(transformation(extent={{-32,22},{-12,42}})));
        Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
          "heatPort for thermal losses to environment"
          annotation (Placement(transformation(extent={{-10,90},{10,110}})));
        Modelica.Blocks.Interfaces.RealInput TSet
          "Temperature setpoint, acts as on/off signal too"
          annotation (Placement(transformation(extent={{-126,-20},{-86,20}})));
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
            points={{-12,32},{0,32},{0,100}},
            color={191,0,0},
            smooth=Smooth.None));
        annotation (Diagram(graphics), Icon(graphics));
      end PartialDynamicHeaterWithLosses;

      model HP_CondensationPower
        "Computation of theoretical condensation power of the refrigerant based on interpolation data"

        /*
  This model is based on data we received from Daikin from an Altherma heat pump.
  The nominal power of the original heat pump is 7177W at 2/35°C
   
  First, the thermal power and electricity consumption are interpolated for the 
  evaporator and condensing temperature at 4 different modulation levels.  The results
  are rescaled to the nominal power of the modelled heatpump (with QNom/QNom_data) and
  stored in 2 different vectors, Q_vector and P_vector.
  
  Finally, the modulation is calculated based on the asked power and the max power at 
  operating conditions: 
  - if modulation_init < modulation_min, the heat pump is OFF, modulation = 0.  
  - if modulation_init > 100%, the modulation is 100%
  - if modulation_init between modulation_min and modulation_start: hysteresis for on/off cycling.
  
  If the heat pump is on another interpolation is made to get P and Q at the real modulation.
  The COP is calculated as Q/P. 
  
  */
      //protected
        parameter TME.FHF.Interfaces.Medium
                                       medium = TME.FHF.Media.Water()
          "Medium in the component";
        final parameter Modelica.SIunits.Power QNomRef=7177
          "Nominal power of the Daikin Altherma.  See datafile";
        final parameter Real[5] mod_vector = {0, 30, 50, 90, 100}
          "5 modulation steps, %";
        Real[5] Q_vector "Thermal power for 5 modulation steps, in kW";
        Real[5] P_vector "Electrical power for 5 modulation steps, in kW";
        Modelica.SIunits.Power QMax
          "Maximum thermal power at specified evap and condr temperatures, in W";
        Modelica.SIunits.Power QAsked(start=0);

      public
        parameter Modelica.SIunits.Power QNom=QNomRef "Nominal power at 2/35";
        parameter Real modulation_min(max=29)=25
          "Minimal modulation percentage";
          // dont' set this to 0 or very low values, you might get negative P at very low modulations because of wrong extrapolation
        parameter Real modulation_start(min=min(30,modulation_min+5)) = 35
          "Min estimated modulation level required for start of HP";
        Real modulationInit
          "Initial modulation, decides on start/stop of the HP";
        Real modulation(min=0, max=1) "Current modulation percentage";
        Modelica.SIunits.Power PEl "Resulting electrical power";
        input Modelica.SIunits.Temperature TEvaporator "Evaporator temperature";
        input Modelica.SIunits.Temperature TCondensor_in
          "Condensor temperature";
        input Modelica.SIunits.Temperature TCondensor_set
          "Condensor setpoint temperature.  Not always possible to reach it";
        input Modelica.SIunits.MassFlowRate m_flowCondensor
          "Condensor mass flow rate";

      protected
        Modelica.Blocks.Tables.CombiTable2D P100(
            smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
              -15,-10,-7,-2,2,7,12,18,30; 30,1.96,2.026,2.041,2.068,2.075,2.28,2.289,
              2.277,2.277; 35,2.08,2.174,2.199,2.245,2.266,2.508,2.537,2.547,2.547;
              40,2.23,2.338,2.374,2.439,2.473,2.755,2.804,2.838,2.838; 45,2.39,2.519,
              2.566,2.65,2.699,3.022,3.091,3.149,3.149; 50,2.56,2.718,2.777,2.88,2.942,
              3.309,3.399,3.481,3.481])
          annotation (Placement(transformation(extent={{-58,66},{-38,86}})));
        Modelica.Blocks.Tables.CombiTable2D P90(
             smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
              -15,-10,-7,-2,2,7,12,18,30; 30,1.76,1.79,1.8,1.81,1.81,1.94,1.93,1.9,
              1.9; 35,1.88,1.96,1.98,1.98,1.99,2.19,2.16,2.15,2.15; 40,2.01,2.11,2.14,
              2.16,2.18,2.42,2.4,2.41,2.41; 45,2.16,2.28,2.32,2.39,2.39,2.66,2.71,
              2.69,2.69; 50,2.32,2.46,2.51,2.6,2.61,2.92,2.99,3.05,3.05])
          annotation (Placement(transformation(extent={{-58,32},{-38,52}})));
        Modelica.Blocks.Tables.CombiTable2D P50(
            smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
              -15,-10,-7,-2,2,7,12,18,30; 30,1.14,1.11,1.09,1.02,0.98,0.98,0.92,0.81,
              0.81; 35,1.26,1.24,1.22,1.16,1.12,1.14,1.09,0.98,0.98; 40,1.39,1.39,
              1.37,1.35,1.28,1.36,1.28,1.21,1.21; 45,1.54,1.55,1.53,1.49,1.46,1.52,
              1.49,1.38,1.38; 50,1.68,1.73,1.72,1.68,1.66,1.75,1.72,1.62,1.62])
          annotation (Placement(transformation(extent={{-58,-6},{-38,14}})));
        Modelica.Blocks.Tables.CombiTable2D P30(
            smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
              -15,-10,-7,-2,2,7,12,18,30; 30,0.78,0.7,0.62,0.534,0.496,0.494,0.416,
              0.388,0.388; 35,0.9,0.82,0.71,0.602,0.561,0.563,0.477,0.453,0.453; 40,
              1.04,0.97,0.88,0.696,0.65,0.653,0.552,0.531,0.531; 45,1.17,1.13,1.04,
              0.86,0.774,0.773,0.646,0.625,0.625; 50,1.35,1.28,1.23,1.11,0.96,0.931,
              0.765,0.739,0.739])
          annotation (Placement(transformation(extent={{-58,-44},{-38,-24}})));
        Modelica.Blocks.Tables.CombiTable2D Q100(
           smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
              -15,-10,-7,-2,2,7,12,18,30; 30,4.82,5.576,6.023,6.892,7.642,10.208,11.652,
              13.518,13.518; 35,4.59,5.279,5.685,6.484,7.177,9.578,10.931,12.692,12.692;
              40,4.43,5.056,5.43,6.174,6.824,9.1,10.386,12.072,12.072; 45,4.32,4.906,
              5.255,5.957,6.576,8.765,10.008,11.647,11.647; 50,4.27,4.824,5.155,5.828,
              6.426,8.564,9.786,11.408,11.408])
          annotation (Placement(transformation(extent={{26,66},{46,86}})));
        Modelica.Blocks.Tables.CombiTable2D Q90(
           smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
              -15,-10,-7,-2,2,7,12,18,30; 30,4.338,5.019,5.42,6.203,6.877,9.188,10.486,
              12.166,12.166; 35,4.131,4.751,5.117,5.836,6.459,8.62,9.838,11.423,11.423;
              40,3.987,4.551,4.887,5.556,6.141,8.19,9.348,10.865,10.865; 45,3.888,
              4.415,4.73,5.361,5.918,7.888,9.007,10.483,10.483; 50,3.843,4.342,4.639,
              5.245,5.784,7.708,8.807,10.267,10.267])
          annotation (Placement(transformation(extent={{26,32},{46,52}})));
        Modelica.Blocks.Tables.CombiTable2D Q50(
            smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
              -15,-10,-7,-2,2,7,12,18,30; 30,2.41,2.788,3.011,3.446,3.821,5.104,5.826,
              6.759,6.759; 35,2.295,2.639,2.843,3.242,3.589,4.789,5.466,6.346,6.346;
              40,2.215,2.528,2.715,3.087,3.412,4.55,5.193,6.036,6.036; 45,2.16,2.453,
              2.628,2.979,3.288,4.382,5.004,5.824,5.824; 50,2.135,2.412,2.577,2.914,
              3.213,4.282,4.893,5.704,5.704])
          annotation (Placement(transformation(extent={{26,-6},{46,14}})));
        Modelica.Blocks.Tables.CombiTable2D Q30(
           smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
              -15,-10,-7,-2,2,7,12,18,30; 30,1.446,1.673,1.807,2.068,2.292,3.063,3.495,
              4.055,4.055; 35,1.377,1.584,1.706,1.945,2.153,2.873,3.279,3.808,3.808;
              40,1.329,1.517,1.629,1.852,2.047,2.73,3.116,3.622,3.622; 45,1.296,1.472,
              1.577,1.787,1.973,2.629,3.002,3.494,3.494; 50,1.281,1.447,1.546,1.748,
              1.928,2.569,2.936,3.422,3.422])
          annotation (Placement(transformation(extent={{26,-44},{46,-24}})));

      public
        Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
          "heatPort connection to water in condensor"
          annotation (Placement(transformation(extent={{90,-10},{110,10}})));
        Commons.General.Hyst_NoEvent onOff(
           uLow = modulation_min,
          uHigh = modulation_start) "on-off, based on modulationInit"
          annotation (Placement(transformation(extent={{-60,-88},{-40,-68}})));
      equation
        onOff.u = modulationInit;
        QAsked = m_flowCondensor * medium.cp * (TCondensor_set - TCondensor_in);
        P100.u1 = heatPort.T - 273.15;
        P100.u2 = TEvaporator - 273.15;
        P90.u1 = heatPort.T - 273.15;
        P90.u2 = TEvaporator - 273.15;
        P50.u1 = heatPort.T - 273.15;
        P50.u2 = TEvaporator - 273.15;
        P30.u1 = heatPort.T - 273.15;
        P30.u2 = TEvaporator - 273.15;
        Q100.u1 = heatPort.T - 273.15;
        Q100.u2 = TEvaporator - 273.15;
        Q90.u1 = heatPort.T - 273.15;
        Q90.u2 = TEvaporator - 273.15;
        Q50.u1 = heatPort.T - 273.15;
        Q50.u2 = TEvaporator - 273.15;
        Q30.u1 = heatPort.T - 273.15;
        Q30.u2 = TEvaporator - 273.15;

        // all these are in kW
        Q_vector[1] = 0;
        Q_vector[2] = Q30.y * QNom/QNomRef;
        Q_vector[3] = Q50.y * QNom/QNomRef;
        Q_vector[4] = Q90.y * QNom/QNomRef;
        Q_vector[5] = Q100.y * QNom/QNomRef;
        P_vector[1] = 0;
        P_vector[2] = P30.y * QNom/QNomRef;
        P_vector[3] = P50.y * QNom/QNomRef;
        P_vector[4] = P90.y * QNom/QNomRef;
        P_vector[5] = P100.y * QNom/QNomRef;
        QMax = 1000* Q100.y * QNom/QNomRef;

        modulationInit = QAsked/QMax * 100;
        modulation = smooth(2, if noEvent(m_flowCondensor > 0 and onOff.y > 0.5) then min(modulationInit, 100) else 0);

        heatPort.Q_flow = -1000 * Modelica.Math.Vectors.interpolate(mod_vector, Q_vector, modulation);
        PEl = 1000 * Modelica.Math.Vectors.interpolate(mod_vector, P_vector, modulation);

        annotation (Diagram(graphics),
                    Diagram(graphics));
      end HP_CondensationPower;

      model HP_CondensationPower_Losses
        "Computation of theoretical condensation power of the refrigerant based on interpolation data.  Takes into account losses of the heat pump to the environment"

        /*
  This model is based on data we received from Daikin from an Altherma heat pump.
  The nominal power of the original heat pump is 7177W at 2/35°C
   
  First, the thermal power and electricity consumption are interpolated for the 
  evaporator and condensing temperature at 4 different modulation levels.  The results
  are rescaled to the nominal power of the modelled heatpump (with QNom/QNom_data) and
  stored in 2 different vectors, Q_vector and P_vector.
  
  Finally, the modulation is calculated based on the asked power and the max power at 
  operating conditions: 
  - if modulation_init < modulation_min, the heat pump is OFF, modulation = 0.  
  - if modulation_init > 100%, the modulation is 100%
  - if modulation_init between modulation_min and modulation_start: hysteresis for on/off cycling.
  
  If the heat pump is on another modulation, interpolation is made to get P and Q at the real modulation.
  
  ATTENTION
  This model takes into account environmental heat losses of the heat pump (at condensor side).
  In order to keep the same nominal COP's during operation of the heat pump, these heat losses are added
  to the computed power.  Therefore, the heat losses are only really 'losses' when the heat pump is 
  NOT operating. 
  
  The COP is calculated as the heat delivered to the condensor divided by the electrical consumption (P). 
  
  */
      //protected
        parameter TME.FHF.Interfaces.Medium
                                       medium = TME.FHF.Media.Water()
          "Medium in the component";
        final parameter Modelica.SIunits.Power QNomRef=7177
          "Nominal power of the Daikin Altherma.  See datafile";
        final parameter Real[5] mod_vector = {0, 30, 50, 90, 100}
          "5 modulation steps, %";
        Real[5] Q_vector "Thermal power for 5 modulation steps, in kW";
        Real[5] P_vector "Electrical power for 5 modulation steps, in kW";
        Modelica.SIunits.Power QMax
          "Maximum thermal power at specified evap and condr temperatures, in W";
        Modelica.SIunits.Power QAsked(start=0);
        parameter Modelica.SIunits.ThermalConductance UALoss
          "UA of heat losses of HP to environment";
        final parameter Modelica.SIunits.Power QNom=QDesign*betaFactor/
            fraLosDesNom
          "The power at nominal conditions (2/35) taking into account beta factor and power loss fraction";

      public
        parameter Real fraLosDesNom = 0.68
          "Ratio of power at design conditions over power at 2/35°C";
        parameter Real betaFactor = 0.8
          "Relative sizing compared to design heat load";
        parameter Modelica.SIunits.Power QDesign=QNomRef "Design heat load";
        parameter Real modulation_min(max=29)=25
          "Minimal modulation percentage";
          // dont' set this to 0 or very low values, you might get negative P at very low modulations because of wrong extrapolation
        parameter Real modulation_start(min=min(30,modulation_min+5)) = 35
          "Min estimated modulation level required for start of HP";
        Real modulationInit
          "Initial modulation, decides on start/stop of the HP";
        Real modulation(min=0, max=100) "Current modulation percentage";
        Modelica.SIunits.Power PEl "Resulting electrical power";
        input Modelica.SIunits.Temperature TEvaporator "Evaporator temperature";
        input Modelica.SIunits.Temperature TCondensor_in
          "Condensor temperature";
        input Modelica.SIunits.Temperature TCondensor_set
          "Condensor setpoint temperature.  Not always possible to reach it";
        input Modelica.SIunits.MassFlowRate m_flowCondensor
          "Condensor mass flow rate";
        input Modelica.SIunits.Temperature TEnvironment
          "Temperature of environment for heat losses";

      protected
        Modelica.Blocks.Tables.CombiTable2D P100(
            smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
              -15,-10,-7,-2,2,7,12,18,30; 30,1.96,2.026,2.041,2.068,2.075,2.28,2.289,
              2.277,2.277; 35,2.08,2.174,2.199,2.245,2.266,2.508,2.537,2.547,2.547;
              40,2.23,2.338,2.374,2.439,2.473,2.755,2.804,2.838,2.838; 45,2.39,2.519,
              2.566,2.65,2.699,3.022,3.091,3.149,3.149; 50,2.56,2.718,2.777,2.88,2.942,
              3.309,3.399,3.481,3.481])
          annotation (Placement(transformation(extent={{-58,66},{-38,86}})));
        Modelica.Blocks.Tables.CombiTable2D P90(
             smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
              -15,-10,-7,-2,2,7,12,18,30; 30,1.76,1.79,1.8,1.81,1.81,1.94,1.93,1.9,
              1.9; 35,1.88,1.96,1.98,1.98,1.99,2.19,2.16,2.15,2.15; 40,2.01,2.11,2.14,
              2.16,2.18,2.42,2.4,2.41,2.41; 45,2.16,2.28,2.32,2.39,2.39,2.66,2.71,
              2.69,2.69; 50,2.32,2.46,2.51,2.6,2.61,2.92,2.99,3.05,3.05])
          annotation (Placement(transformation(extent={{-58,32},{-38,52}})));
        Modelica.Blocks.Tables.CombiTable2D P50(
            smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
              -15,-10,-7,-2,2,7,12,18,30; 30,1.14,1.11,1.09,1.02,0.98,0.98,0.92,0.81,
              0.81; 35,1.26,1.24,1.22,1.16,1.12,1.14,1.09,0.98,0.98; 40,1.39,1.39,
              1.37,1.35,1.28,1.36,1.28,1.21,1.21; 45,1.54,1.55,1.53,1.49,1.46,1.52,
              1.49,1.38,1.38; 50,1.68,1.73,1.72,1.68,1.66,1.75,1.72,1.62,1.62])
          annotation (Placement(transformation(extent={{-58,-6},{-38,14}})));
        Modelica.Blocks.Tables.CombiTable2D P30(
            smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
              -15,-10,-7,-2,2,7,12,18,30; 30,0.78,0.7,0.62,0.534,0.496,0.494,0.416,
              0.388,0.388; 35,0.9,0.82,0.71,0.602,0.561,0.563,0.477,0.453,0.453; 40,
              1.04,0.97,0.88,0.696,0.65,0.653,0.552,0.531,0.531; 45,1.17,1.13,1.04,
              0.86,0.774,0.773,0.646,0.625,0.625; 50,1.35,1.28,1.23,1.11,0.96,0.931,
              0.765,0.739,0.739])
          annotation (Placement(transformation(extent={{-58,-44},{-38,-24}})));
        Modelica.Blocks.Tables.CombiTable2D Q100(
           smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
              -15,-10,-7,-2,2,7,12,18,30; 30,4.82,5.576,6.023,6.892,7.642,10.208,11.652,
              13.518,13.518; 35,4.59,5.279,5.685,6.484,7.177,9.578,10.931,12.692,12.692;
              40,4.43,5.056,5.43,6.174,6.824,9.1,10.386,12.072,12.072; 45,4.32,4.906,
              5.255,5.957,6.576,8.765,10.008,11.647,11.647; 50,4.27,4.824,5.155,5.828,
              6.426,8.564,9.786,11.408,11.408])
          annotation (Placement(transformation(extent={{26,66},{46,86}})));
        Modelica.Blocks.Tables.CombiTable2D Q90(
           smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
              -15,-10,-7,-2,2,7,12,18,30; 30,4.338,5.019,5.42,6.203,6.877,9.188,10.486,
              12.166,12.166; 35,4.131,4.751,5.117,5.836,6.459,8.62,9.838,11.423,11.423;
              40,3.987,4.551,4.887,5.556,6.141,8.19,9.348,10.865,10.865; 45,3.888,
              4.415,4.73,5.361,5.918,7.888,9.007,10.483,10.483; 50,3.843,4.342,4.639,
              5.245,5.784,7.708,8.807,10.267,10.267])
          annotation (Placement(transformation(extent={{26,32},{46,52}})));
        Modelica.Blocks.Tables.CombiTable2D Q50(
            smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
              -15,-10,-7,-2,2,7,12,18,30; 30,2.41,2.788,3.011,3.446,3.821,5.104,5.826,
              6.759,6.759; 35,2.295,2.639,2.843,3.242,3.589,4.789,5.466,6.346,6.346;
              40,2.215,2.528,2.715,3.087,3.412,4.55,5.193,6.036,6.036; 45,2.16,2.453,
              2.628,2.979,3.288,4.382,5.004,5.824,5.824; 50,2.135,2.412,2.577,2.914,
              3.213,4.282,4.893,5.704,5.704])
          annotation (Placement(transformation(extent={{26,-6},{46,14}})));
        Modelica.Blocks.Tables.CombiTable2D Q30(
           smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
              -15,-10,-7,-2,2,7,12,18,30; 30,1.446,1.673,1.807,2.068,2.292,3.063,3.495,
              4.055,4.055; 35,1.377,1.584,1.706,1.945,2.153,2.873,3.279,3.808,3.808;
              40,1.329,1.517,1.629,1.852,2.047,2.73,3.116,3.622,3.622; 45,1.296,1.472,
              1.577,1.787,1.973,2.629,3.002,3.494,3.494; 50,1.281,1.447,1.546,1.748,
              1.928,2.569,2.936,3.422,3.422])
          annotation (Placement(transformation(extent={{26,-44},{46,-24}})));
        Modelica.SIunits.HeatFlowRate QLossesToCompensate "Environment losses";
      public
        Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
          "heatPort connection to water in condensor"
          annotation (Placement(transformation(extent={{90,-10},{110,10}})));
        Commons.General.Hyst_NoEvent onOff(
           uLow = modulation_min,
          uHigh = modulation_start,
          y(
          start = 0),
          enableRelease=true) "on-off, based on modulationInit"
          annotation (Placement(transformation(extent={{-60,-88},{-40,-68}})));
      equation
        onOff.u = modulationInit;
        onOff.release = if noEvent(m_flowCondensor > 0) then 1.0 else 0.0;
        QAsked = m_flowCondensor * medium.cp * (TCondensor_set - TCondensor_in);
        P100.u1 = heatPort.T - 273.15;
        P100.u2 = TEvaporator - 273.15;
        P90.u1 = heatPort.T - 273.15;
        P90.u2 = TEvaporator - 273.15;
        P50.u1 = heatPort.T - 273.15;
        P50.u2 = TEvaporator - 273.15;
        P30.u1 = heatPort.T - 273.15;
        P30.u2 = TEvaporator - 273.15;
        Q100.u1 = heatPort.T - 273.15;
        Q100.u2 = TEvaporator - 273.15;
        Q90.u1 = heatPort.T - 273.15;
        Q90.u2 = TEvaporator - 273.15;
        Q50.u1 = heatPort.T - 273.15;
        Q50.u2 = TEvaporator - 273.15;
        Q30.u1 = heatPort.T - 273.15;
        Q30.u2 = TEvaporator - 273.15;

        // all these are in kW
        Q_vector[1] = 0;
        Q_vector[2] = Q30.y * QNom/QNomRef;
        Q_vector[3] = Q50.y * QNom/QNomRef;
        Q_vector[4] = Q90.y * QNom/QNomRef;
        Q_vector[5] = Q100.y * QNom/QNomRef;
        P_vector[1] = 0;
        P_vector[2] = P30.y * QNom/QNomRef;
        P_vector[3] = P50.y * QNom/QNomRef;
        P_vector[4] = P90.y * QNom/QNomRef;
        P_vector[5] = P100.y * QNom/QNomRef;
        QMax = 1000* Q100.y * QNom/QNomRef;

        modulationInit = QAsked/QMax * 100;
        modulation = onOff.y * min(modulationInit, 100);

        // compensation of heat losses (only when the hp is operating)
        QLossesToCompensate = if noEvent(modulation > 0) then UALoss * (heatPort.T-TEnvironment) else 0;

        heatPort.Q_flow = -1000 * Modelica.Math.Vectors.interpolate(mod_vector, Q_vector, modulation) - QLossesToCompensate;
        PEl = 1000 * Modelica.Math.Vectors.interpolate(mod_vector, P_vector, modulation);

        annotation (Diagram(graphics),
                    Diagram(graphics));
      end HP_CondensationPower_Losses;

      model HP_CondensationPower_Losses_MinOff
        "Computation of theoretical condensation power of the refrigerant based on interpolation data.  Takes into account losses of the heat pump to the environment"

        /*
  This model is based on data we received from Daikin from an Altherma heat pump.
  The nominal power of the original heat pump is 7177W at 2/35°C
   
  First, the thermal power and electricity consumption are interpolated for the 
  evaporator and condensing temperature at 4 different modulation levels.  The results
  are rescaled to the nominal power of the modelled heatpump (with QNom/QNom_data) and
  stored in 2 different vectors, Q_vector and P_vector.
  
  Finally, the modulation is calculated based on the asked power and the max power at 
  operating conditions: 
  - if modulation_init < modulation_min, the heat pump is OFF, modulation = 0.  
  - if modulation_init > 100%, the modulation is 100%
  - if modulation_init between modulation_min and modulation_start: hysteresis for on/off cycling.
  
  If the heat pump is on another modulation, interpolation is made to get P and Q at the real modulation.
  
  ATTENTION
  This model takes into account environmental heat losses of the heat pump (at condensor side).
  In order to keep the same nominal COP's during operation of the heat pump, these heat losses are added
  to the computed power.  Therefore, the heat losses are only really 'losses' when the heat pump is 
  NOT operating. 
  
  The COP is calculated as the heat delivered to the condensor divided by the electrical consumption (P). 
  
  */
      //protected
        parameter TME.FHF.Interfaces.Medium
                                       medium = TME.FHF.Media.Water()
          "Medium in the component";
        final parameter Modelica.SIunits.Power QNomRef=7177
          "Nominal power of the Daikin Altherma.  See datafile";
        final parameter Real[5] mod_vector = {0, 30, 50, 90, 100}
          "5 modulation steps, %";
        Real[5] Q_vector "Thermal power for 5 modulation steps, in kW";
        Real[5] P_vector "Electrical power for 5 modulation steps, in kW";
        Modelica.SIunits.Power QMax
          "Maximum thermal power at specified evap and condr temperatures, in W";
        Modelica.SIunits.Power QAsked(start=0);
        parameter Modelica.SIunits.ThermalConductance UALoss
          "UA of heat losses of HP to environment";
        final parameter Modelica.SIunits.Power QNom=QDesign*betaFactor/
            fraLosDesNom
          "The power at nominal conditions (2/35) taking into account beta factor and power loss fraction";

      public
        parameter Real fraLosDesNom = 0.68
          "Ratio of power at design conditions over power at 2/35°C";
        parameter Real betaFactor = 0.8
          "Relative sizing compared to design heat load";
        parameter Modelica.SIunits.Power QDesign=QNomRef "Design heat load";
        parameter Real modulation_min(max=29)=25
          "Minimal modulation percentage";
          // dont' set this to 0 or very low values, you might get negative P at very low modulations because of wrong extrapolation
        parameter Real modulation_start(min=min(30,modulation_min+5)) = 35
          "Min estimated modulation level required for start of HP";
        Real modulationInit
          "Initial modulation, decides on start/stop of the HP";
        Real modulation(min=0, max=1) "Current modulation percentage";
        Modelica.SIunits.Power PEl "Resulting electrical power";
        input Modelica.SIunits.Temperature TEvaporator "Evaporator temperature";
        input Modelica.SIunits.Temperature TCondensor_in
          "Condensor temperature";
        input Modelica.SIunits.Temperature TCondensor_set
          "Condensor setpoint temperature.  Not always possible to reach it";
        input Modelica.SIunits.MassFlowRate m_flowCondensor
          "Condensor mass flow rate";
        input Modelica.SIunits.Temperature TEnvironment
          "Temperature of environment for heat losses";

      protected
        Modelica.Blocks.Tables.CombiTable2D P100(
            smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
              -15,-10,-7,-2,2,7,12,18,30; 30,1.96,2.026,2.041,2.068,2.075,2.28,2.289,
              2.277,2.277; 35,2.08,2.174,2.199,2.245,2.266,2.508,2.537,2.547,2.547;
              40,2.23,2.338,2.374,2.439,2.473,2.755,2.804,2.838,2.838; 45,2.39,2.519,
              2.566,2.65,2.699,3.022,3.091,3.149,3.149; 50,2.56,2.718,2.777,2.88,2.942,
              3.309,3.399,3.481,3.481])
          annotation (Placement(transformation(extent={{-58,66},{-38,86}})));
        Modelica.Blocks.Tables.CombiTable2D P90(
             smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
              -15,-10,-7,-2,2,7,12,18,30; 30,1.76,1.79,1.8,1.81,1.81,1.94,1.93,1.9,
              1.9; 35,1.88,1.96,1.98,1.98,1.99,2.19,2.16,2.15,2.15; 40,2.01,2.11,2.14,
              2.16,2.18,2.42,2.4,2.41,2.41; 45,2.16,2.28,2.32,2.39,2.39,2.66,2.71,
              2.69,2.69; 50,2.32,2.46,2.51,2.6,2.61,2.92,2.99,3.05,3.05])
          annotation (Placement(transformation(extent={{-58,32},{-38,52}})));
        Modelica.Blocks.Tables.CombiTable2D P50(
            smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
              -15,-10,-7,-2,2,7,12,18,30; 30,1.14,1.11,1.09,1.02,0.98,0.98,0.92,0.81,
              0.81; 35,1.26,1.24,1.22,1.16,1.12,1.14,1.09,0.98,0.98; 40,1.39,1.39,
              1.37,1.35,1.28,1.36,1.28,1.21,1.21; 45,1.54,1.55,1.53,1.49,1.46,1.52,
              1.49,1.38,1.38; 50,1.68,1.73,1.72,1.68,1.66,1.75,1.72,1.62,1.62])
          annotation (Placement(transformation(extent={{-58,-6},{-38,14}})));
        Modelica.Blocks.Tables.CombiTable2D P30(
            smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
              -15,-10,-7,-2,2,7,12,18,30; 30,0.78,0.7,0.62,0.534,0.496,0.494,0.416,
              0.388,0.388; 35,0.9,0.82,0.71,0.602,0.561,0.563,0.477,0.453,0.453; 40,
              1.04,0.97,0.88,0.696,0.65,0.653,0.552,0.531,0.531; 45,1.17,1.13,1.04,
              0.86,0.774,0.773,0.646,0.625,0.625; 50,1.35,1.28,1.23,1.11,0.96,0.931,
              0.765,0.739,0.739])
          annotation (Placement(transformation(extent={{-58,-44},{-38,-24}})));
        Modelica.Blocks.Tables.CombiTable2D Q100(
           smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
              -15,-10,-7,-2,2,7,12,18,30; 30,4.82,5.576,6.023,6.892,7.642,10.208,11.652,
              13.518,13.518; 35,4.59,5.279,5.685,6.484,7.177,9.578,10.931,12.692,12.692;
              40,4.43,5.056,5.43,6.174,6.824,9.1,10.386,12.072,12.072; 45,4.32,4.906,
              5.255,5.957,6.576,8.765,10.008,11.647,11.647; 50,4.27,4.824,5.155,5.828,
              6.426,8.564,9.786,11.408,11.408])
          annotation (Placement(transformation(extent={{26,66},{46,86}})));
        Modelica.Blocks.Tables.CombiTable2D Q90(
           smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
              -15,-10,-7,-2,2,7,12,18,30; 30,4.338,5.019,5.42,6.203,6.877,9.188,10.486,
              12.166,12.166; 35,4.131,4.751,5.117,5.836,6.459,8.62,9.838,11.423,11.423;
              40,3.987,4.551,4.887,5.556,6.141,8.19,9.348,10.865,10.865; 45,3.888,
              4.415,4.73,5.361,5.918,7.888,9.007,10.483,10.483; 50,3.843,4.342,4.639,
              5.245,5.784,7.708,8.807,10.267,10.267])
          annotation (Placement(transformation(extent={{26,32},{46,52}})));
        Modelica.Blocks.Tables.CombiTable2D Q50(
            smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
              -15,-10,-7,-2,2,7,12,18,30; 30,2.41,2.788,3.011,3.446,3.821,5.104,5.826,
              6.759,6.759; 35,2.295,2.639,2.843,3.242,3.589,4.789,5.466,6.346,6.346;
              40,2.215,2.528,2.715,3.087,3.412,4.55,5.193,6.036,6.036; 45,2.16,2.453,
              2.628,2.979,3.288,4.382,5.004,5.824,5.824; 50,2.135,2.412,2.577,2.914,
              3.213,4.282,4.893,5.704,5.704])
          annotation (Placement(transformation(extent={{26,-6},{46,14}})));
        Modelica.Blocks.Tables.CombiTable2D Q30(
           smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
              -15,-10,-7,-2,2,7,12,18,30; 30,1.446,1.673,1.807,2.068,2.292,3.063,3.495,
              4.055,4.055; 35,1.377,1.584,1.706,1.945,2.153,2.873,3.279,3.808,3.808;
              40,1.329,1.517,1.629,1.852,2.047,2.73,3.116,3.622,3.622; 45,1.296,1.472,
              1.577,1.787,1.973,2.629,3.002,3.494,3.494; 50,1.281,1.447,1.546,1.748,
              1.928,2.569,2.936,3.422,3.422])
          annotation (Placement(transformation(extent={{26,-44},{46,-24}})));
        Modelica.SIunits.HeatFlowRate QLossesToCompensate "Environment losses";
      public
        Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
          "heatPort connection to water in condensor"
          annotation (Placement(transformation(extent={{90,-10},{110,10}})));
        Commons.General.Hyst_NoEvent_MinOnOff
                                     onOff(
           uLow = modulation_min,
          uHigh = modulation_start,
          y(
          start = 0),
          minOffTime=900) "on-off, based on modulationInit"
          annotation (Placement(transformation(extent={{-60,-88},{-40,-68}})));
      equation
        onOff.u = modulationInit;
        QAsked = m_flowCondensor * medium.cp * (TCondensor_set - TCondensor_in);
        P100.u1 = heatPort.T - 273.15;
        P100.u2 = TEvaporator - 273.15;
        P90.u1 = heatPort.T - 273.15;
        P90.u2 = TEvaporator - 273.15;
        P50.u1 = heatPort.T - 273.15;
        P50.u2 = TEvaporator - 273.15;
        P30.u1 = heatPort.T - 273.15;
        P30.u2 = TEvaporator - 273.15;
        Q100.u1 = heatPort.T - 273.15;
        Q100.u2 = TEvaporator - 273.15;
        Q90.u1 = heatPort.T - 273.15;
        Q90.u2 = TEvaporator - 273.15;
        Q50.u1 = heatPort.T - 273.15;
        Q50.u2 = TEvaporator - 273.15;
        Q30.u1 = heatPort.T - 273.15;
        Q30.u2 = TEvaporator - 273.15;

        // all these are in kW
        Q_vector[1] = 0;
        Q_vector[2] = Q30.y * QNom/QNomRef;
        Q_vector[3] = Q50.y * QNom/QNomRef;
        Q_vector[4] = Q90.y * QNom/QNomRef;
        Q_vector[5] = Q100.y * QNom/QNomRef;
        P_vector[1] = 0;
        P_vector[2] = P30.y * QNom/QNomRef;
        P_vector[3] = P50.y * QNom/QNomRef;
        P_vector[4] = P90.y * QNom/QNomRef;
        P_vector[5] = P100.y * QNom/QNomRef;
        QMax = 1000* Q100.y * QNom/QNomRef;

        modulationInit = QAsked/QMax * 100;
        modulation = smooth(2, if noEvent(m_flowCondensor > 0 and onOff.y > 0.5) then min(modulationInit, 100) else 0);

        // compensation of heat losses (only when the hp is operating)
        QLossesToCompensate = if noEvent(modulation > 0) then UALoss * (heatPort.T-TEnvironment) else 0;

        heatPort.Q_flow = -1000 * Modelica.Math.Vectors.interpolate(mod_vector, Q_vector, modulation) - QLossesToCompensate;
        PEl = 1000 * Modelica.Math.Vectors.interpolate(mod_vector, P_vector, modulation);

        annotation (Diagram(graphics),
                    Diagram(graphics));
      end HP_CondensationPower_Losses_MinOff;

      model HP_BW_CondensationPower_Losses
        "Brine/Water, Computation of theoretical condensation power of the refrigerant based on interpolation data.  Takes into account losses of the heat pump to the environment"

        /*
  This model is based on catalogue data from Viessmann for the vitocal 300-G, type BW/BWC 108 (8kW nominal power) 
  
  First, the thermal power and electricity consumption are interpolated for the 
  evaporator and condensing set temperature.  The results
  are rescaled to the nominal power of the modelled heatpump (with QNom/QNom_data).
    
  The heat pump is an on/off heat pump, and a hysteresis is foreseen around the condensor set temperature
  for on/off switching 
   
  ATTENTION
  This model takes into account environmental heat losses of the heat pump (at condensor side).
  In order to keep the same nominal COP's during operation of the heat pump, these heat losses are added
  to the computed power.  Therefore, the heat losses are only really 'losses' when the heat pump is 
  NOT operating. 
  
  The COP is calculated as the heat delivered to the condensor divided by the electrical consumption (P). 
  
  */
      //protected
        parameter TME.FHF.Interfaces.Medium
                                       medium = TME.FHF.Media.Water()
          "Medium in the condensor";
        parameter TME.FHF.Interfaces.Medium
                                       mediumEvap = TME.FHF.Media.Water()
          "Medium in the evaporator";
        final parameter Modelica.SIunits.Power QNomRef=8270
          "Nominal power of the Viesmann Vitocal 300-G BW/BWC 108.  See datafile";
        parameter Modelica.SIunits.ThermalConductance UALoss
          "UA of heat losses of HP to environment";
        final parameter Modelica.SIunits.Power QNom=QDesign*betaFactor/
            fraLosDesNom
          "The power at nominal conditions (2/35) taking into account beta factor and power loss fraction";

      public
        parameter Real fraLosDesNom = 1
          "Ratio of power at design conditions over power at 0/35°C";
        parameter Real betaFactor = 0.8
          "Relative sizing compared to design heat load";
        parameter Modelica.SIunits.Power QDesign=QNomRef "Design heat load";
        Modelica.SIunits.Power PEl "Resulting electrical power";
        Modelica.SIunits.Temperature TEvaporator "Evaporator temperature";
        input Modelica.SIunits.Temperature TCondensor_in
          "Condensor temperature";
        input Modelica.SIunits.Temperature TCondensor_set
          "Condensor setpoint temperature.  Not always possible to reach it";
        input Modelica.SIunits.MassFlowRate m_flowCondensor
          "Condensor mass flow rate";
        input Modelica.SIunits.Temperature TEnvironment
          "Temperature of environment for heat losses";
        Real modulation(min=0, max=100)
          "Current modulation percentage, has no function in this on/off heat pump";

      protected
        Modelica.Blocks.Tables.CombiTable2D P100(
            smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
              0,15; 35,1.8,1.99; 45,2.2,2.41; 55,2.72,2.98])
          annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
        Modelica.Blocks.Tables.CombiTable2D Q100(
           smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
              0,15; 35,8.27,12.25; 45,7.75,11.63; 55,7.38,11.07])
          annotation (Placement(transformation(extent={{20,60},{40,80}})));
        Modelica.Blocks.Tables.CombiTable2D evap100(smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
            table=[0,0,15; 35,6.6,10.73; 45,5.82,9.76; 55,5.06,8.63])
          "Evaporator power, in kW"
          annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

        Modelica.SIunits.HeatFlowRate QLossesToCompensate "Environment losses";
        Modelica.SIunits.HeatFlowRate QCond;
        Modelica.SIunits.HeatFlowRate QEvap;
        Modelica.SIunits.Power PComp;
      public
        Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
          "heatPort connection to water in condensor"
          annotation (Placement(transformation(extent={{90,-10},{110,10}})));
        Commons.General.Hyst_NoEvent onOff(
           uLow = -2.5,
          uHigh = 2.5,
          y(
          start = 0),
          enableRelease=true) "on-off, based on modulationInit"
          annotation (Placement(transformation(extent={{20,20},{40,40}})));

        IDEAS.Thermal.Components.Interfaces.FlowPort_a
                                      flowPort_a(medium=mediumEvap)
          annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
        IDEAS.Thermal.Components.Interfaces.FlowPort_b
                                      flowPort_b(medium=mediumEvap)
          annotation (Placement(transformation(extent={{10,-110},{30,-90}})));
        IDEAS.Thermal.Components.BaseClasses.HeatedPipe
                                      evaporator(
          medium=mediumEvap,
          m=3,
          TInitial=283.15)
          annotation (Placement(transformation(extent={{-24,-46},{-4,-66}})));
        Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
          annotation (Placement(transformation(extent={{-46,-34},{-26,-14}})));
      equation
        TEvaporator = flowPort_a.h/mediumEvap.cp;
        onOff.u = TCondensor_set-heatPort.T;
        onOff.release = noEvent(if m_flowCondensor > 0 then 1.0 else 0.0);
        //QAsked = m_flowCondensor * medium.cp * (TCondensor_set - TCondensor_in);
        P100.u1 = heatPort.T - 273.15;
        P100.u2 = TEvaporator - 273.15;
        Q100.u1 = heatPort.T - 273.15;
        Q100.u2 = TEvaporator - 273.15;
        evap100.u1 = heatPort.T - 273.15;
        evap100.u2 = TEvaporator - 273.15;

        // all these are in W

        QCond = Q100.y * QNom/QNomRef * 1000;
        PComp = P100.y * QNom/QNomRef * 1000;
        QEvap = evap100.y * QNom/QNomRef * 1000;

        // compensation of heat losses (only when the hp is operating)
        QLossesToCompensate = onOff.y * UALoss * (heatPort.T-TEnvironment);
        modulation = onOff.y * 100;
        heatPort.Q_flow = -onOff.y * QCond - QLossesToCompensate;
        PEl = onOff.y * PComp;
        prescribedHeatFlow.Q_flow = - onOff.y * QEvap;

        connect(flowPort_a,evaporator. flowPort_a) annotation (Line(
            points={{-40,-100},{-42,-100},{-42,-56},{-24,-56}},
            color={255,0,0},
            smooth=Smooth.None));
        connect(evaporator.flowPort_b, flowPort_b) annotation (Line(
            points={{-4,-56},{20,-56},{20,-100}},
            color={255,0,0},
            smooth=Smooth.None));
        connect(prescribedHeatFlow.port, evaporator.heatPort) annotation (Line(
            points={{-26,-24},{-14,-24},{-14,-46}},
            color={191,0,0},
            smooth=Smooth.None));
        annotation (Diagram(graphics),
                    Diagram(graphics));
      end HP_BW_CondensationPower_Losses;

      model Burner
        "Burner for use in Boiler, based on interpolation data.  Takes into account losses of the boiler to the environment"

        /*
  This model is based on data from XXX (get source data ruben mailede me).
  The nominal power of the original boiler is 10.1 kW bij 50/30°C water temperatures. 
  The efficiency in this point is 92.2% on higher heating value. 
   
  First, the efficiency is interpolated for the 
  return water temperature and flowrate at 5 different modulation levels. These modulation
  levels are the FUEL input power to the boiler.  The results
  are rescaled to the nominal power of the modelled heatpump (with QNom/QNom_data) and
  stored in a vector, eta_vector.
  
  Finally, the initial modulation is calculated based on the asked power and the max power at 
  operating conditions: 
  - if modulation_init < modulation_min, the boiler is OFF, modulation = 0.  
  - if modulation_init > 100%, the modulation is 100%
  - if modulation_init between modulation_min and modulation_start: hysteresis for on/off cycling.
  
  If the heat pump is on another modulation, interpolation is made to get eta at the real modulation.
  
  ATTENTION
  This model takes into account environmental heat losses of the boiler.
  In order to keep the same nominal eta's during operation, these heat losses are added
  to the computed power.  Therefore, the heat losses are only really 'losses' when the boiler is 
  NOT operating. 
  
  The eta is calculated as the heat delivered to the heatExchanger divided by the fuel consumption PFuel. 
  
  */
      //protected
        parameter TME.FHF.Interfaces.Medium
                                       medium = TME.FHF.Media.Water()
          "Medium in the component";

        final parameter Real[6] modVector = {0, 20, 40, 60, 80, 100}
          "6 modulation steps, %";
        Real eta
          "Instantaneous efficiency of the boiler (higher heating value)";
        Real[6] etaVector
          "Thermal efficiency (higher heating value) for 6 modulation steps, base 1";
        Real[6] QVector "Thermal power for 6 modulation steps, in kW";
        Modelica.SIunits.Power QMax
          "Maximum thermal power at specified evap and condr temperatures, in W";
        Modelica.SIunits.Power QAsked(start=0);
        parameter Modelica.SIunits.ThermalConductance UALoss
          "UA of heat losses of HP to environment";
        final parameter Modelica.SIunits.Power QNom=QDesign*betaFactor/
            fraLosDesNom
          "The power at nominal conditions (50/30) taking into account beta factor and power loss fraction";

      public
        parameter Real fraLosDesNom = 1
          "Ratio of power at design conditions over power at 50/30°C";
        parameter Real betaFactor = 1
          "Relative sizing compared to design heat load";
        parameter Modelica.SIunits.Power QDesign "Design heat load";
        parameter Real etaNom = 0.922
          "Nominal efficiency (higher heating value)of the xxx boiler at 50/30°C.  See datafile";
        parameter Real modulationMin(max=29)=25 "Minimal modulation percentage";
          // dont' set this to 0 or very low values, you might get negative P at very low modulations because of wrong extrapolation
        parameter Real modulationStart(min=min(30,modulationMin+5)) = 35
          "Min estimated modulation level required for start of HP";
        Real modulationInit
          "Initial modulation, decides on start/stop of the boiler";
        Real modulation(min=0, max=1) "Current modulation percentage";
        Modelica.SIunits.Power PFuel "Resulting fuel consumption";
        input Modelica.SIunits.Temperature THxIn "Condensor temperature";
        input Modelica.SIunits.Temperature TBoilerSet
          "Condensor setpoint temperature.  Not always possible to reach it";
        input Modelica.SIunits.MassFlowRate m_flowHx "Condensor mass flow rate";
        input Modelica.SIunits.Temperature TEnvironment
          "Temperature of environment for heat losses";

      protected
        Real kgps2lph = 3600 / medium.rho * 1000 "Conversion from kg/s to l/h";
        Modelica.Blocks.Tables.CombiTable2D eta100(smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
              100,400,700,1000,1300; 20.0,0.9015,0.9441,0.9599,0.9691,0.9753; 30.0,0.8824,
              0.9184,0.9324,0.941,0.9471; 40.0,0.8736,0.8909,0.902,0.9092,0.9143; 50.0,
              0.8676,0.8731,0.8741,0.8746,0.8774; 60.0,0.8,0.867,0.8681,0.8686,0.8689;
              70.0,0.8,0.8609,0.8619,0.8625,0.8628; 80.0,0.8,0.8547,0.8558,0.8563,0.8566])
          annotation (Placement(transformation(extent={{-58,66},{-38,86}})));
        Modelica.Blocks.Tables.CombiTable2D eta80(smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
            table=[0,100,400,700,1000,1300;20.0,0.9155,0.9587,0.9733,0.9813,0.9866;30.0,0.8937,0.9311,0.9449,0.953,0.9585;40.0,0.8753,0.9007,0.9121,0.9192,0.9242;50.0,0.8691,0.8734,0.8755,0.8804,0.884;60.0,0.8628,0.8671,0.8679,0.8683,0.8686;70.0,0.7415,0.8607,0.8616,0.862,0.8622;80.0,0.6952,0.8544,0.8552,0.8556,0.8559])
          annotation (Placement(transformation(extent={{-58,32},{-38,52}})));
        Modelica.Blocks.Tables.CombiTable2D eta60(smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
            table=[0,100,400,700,1000,1300;20.0,0.9349,0.9759,0.9879,0.9941,0.998;30.0,0.9096,0.9471,0.9595,0.9664,0.9709;40.0,0.8831,0.9136,0.9247,0.9313,0.9357;50.0,0.8701,0.8759,0.8838,0.8887,0.8921;60.0,0.8634,0.8666,0.8672,0.8675,0.8677;70.0,0.8498,0.8599,0.8605,0.8608,0.861;80.0,0.8488,0.8532,0.8538,0.8541,0.8543])
          annotation (Placement(transformation(extent={{-58,-6},{-38,14}})));
        Modelica.Blocks.Tables.CombiTable2D eta40(smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
            table=[0,100,400,700,1000,1300;20.0,0.9624,0.9947,0.9985,0.9989,0.999;30.0,0.9333,0.9661,0.9756,0.9803,0.9833;40.0,0.901,0.9306,0.94,0.9451,0.9485;50.0,0.8699,0.8871,0.8946,0.8989,0.9018;60.0,0.8626,0.8647,0.8651,0.8653,0.8655;70.0,0.8553,0.8573,0.8577,0.8579,0.8581;80.0,0.8479,0.8499,0.8503,0.8505,0.8506])
          annotation (Placement(transformation(extent={{-58,-44},{-38,-24}})));
        Modelica.Blocks.Tables.CombiTable2D eta20(smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
            table=[0,100,400,700,1000,1300;20.0,0.9969,0.9987,0.999,0.999,0.999;30.0,0.9671,0.9859,0.99,0.9921,0.9934;40.0,0.9293,0.9498,0.9549,0.9575,0.9592;50.0,0.8831,0.9003,0.9056,0.9083,0.9101;60.0,0.8562,0.857,0.8575,0.8576,0.8577;70.0,0.8398,0.8479,0.8481,0.8482,0.8483;80.0,0.8374,0.8384,0.8386,0.8387,0.8388])
          annotation (Placement(transformation(extent={{-58,-86},{-38,-66}})));

        Modelica.SIunits.HeatFlowRate QLossesToCompensate "Environment losses";
      public
        Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
          "heatPort connection to water in condensor"
          annotation (Placement(transformation(extent={{90,-10},{110,10}})));
        Commons.General.Hyst_NoEvent onOff(
          uLow = modulationMin,
          uHigh = modulationStart,
          y(
          start = 0),
          enableRelease=true) "on-off, based on modulationInit"
          annotation (Placement(transformation(extent={{28,40},{48,60}})));

      equation
        onOff.u = modulationInit;
        onOff.release = if noEvent(m_flowHx > 0) then 1.0 else 0.0;
        QAsked = max(0, m_flowHx * medium.cp * (TBoilerSet - THxIn));
        eta100.u1 = THxIn - 273.15;
        eta100.u2 = m_flowHx * kgps2lph;
        eta80.u1 = THxIn - 273.15;
        eta80.u2 = m_flowHx * kgps2lph;
        eta60.u1 = THxIn - 273.15;
        eta60.u2 = m_flowHx * kgps2lph;
        eta40.u1 = THxIn - 273.15;
        eta40.u2 = m_flowHx * kgps2lph;
        eta20.u1 = THxIn - 273.15;
        eta20.u2 = m_flowHx * kgps2lph;

        // all these are in kW
        etaVector[1] = 0;
        etaVector[2] = eta20.y;
        etaVector[3] = eta40.y;
        etaVector[4] = eta60.y;
        etaVector[5] = eta80.y;
        etaVector[6] = eta100.y;
        QVector = etaVector / etaNom .* modVector/100 * QNom; // in W
        QMax = QVector[6];

        modulationInit = Modelica.Math.Vectors.interpolate(QVector, modVector, QAsked);
        modulation = onOff.y * min(modulationInit, 100);

        // compensation of heat losses (only when the hp is operating)
        QLossesToCompensate = if noEvent(modulation > 0) then UALoss * (heatPort.T-TEnvironment) else 0;

        eta = Modelica.Math.Vectors.interpolate(modVector, etaVector, modulation);
        heatPort.Q_flow = - Modelica.Math.Vectors.interpolate(modVector, QVector, modulation) - QLossesToCompensate;
        PFuel = if noEvent(modulation >0) then -heatPort.Q_flow / eta else 0;

        annotation (Diagram(graphics),
                    Diagram(graphics));
      end Burner;
    end Auxiliaries;

    model Boiler
      "Modulating boiler with losses to environment, based on performance tables"
      extends
        IDEAS.Thermal.Components.Production.Auxiliaries.PartialDynamicHeaterWithLosses(
          final heaterType=IDEAS.Thermal.Components.Production.Auxiliaries.HeaterType.Boiler);

      Real eta "Instanteanous efficiency";

      IDEAS.Thermal.Components.Production.Auxiliaries.Burner heatSource(
        medium=medium,
        QDesign=QNom,
        TBoilerSet=TSet,
        TEnvironment=heatPort.T,
        UALoss=UALoss,
        THxIn=heatedFluid.T_a,
        m_flowHx=heatedFluid.flowPort_a.m_flow)
        annotation (Placement(transformation(extent={{-48,-46},{-28,-26}})));
    equation
      // Electricity consumption for electronics and fan only.  Pump is covered by pumpHeater;
      // This data is taken from Viessmann VitoDens 300W, smallest model.  So only valid for
      // very small household condensing gas boilers.
      PEl = 7 + heatSource.modulation/100 * (33-7);
      PFuel = heatSource.PFuel;
      eta = heatSource.eta;
      connect(heatSource.heatPort, heatedFluid.heatPort) annotation (Line(
          points={{-28,-36},{-20,-36},{-20,6.12323e-016}},
          color={191,0,0},
          smooth=Smooth.None));
      annotation (Diagram(graphics), Icon(graphics));
    end Boiler;

    model HP_BW "BW HP with losses to environment"

      extends
        IDEAS.Thermal.Components.Production.Auxiliaries.PartialDynamicHeaterWithLosses(
          final heaterType=IDEAS.Thermal.Components.Production.Auxiliaries.HeaterType.HP_BW);
      parameter Modelica.SIunits.Power QNom "Nominal power at 2/35";
      parameter TME.FHF.Interfaces.Medium
                                     mediumEvap=TME.FHF.Media.Water()
        "Medium in the evaporator";

      Real COP "Instanteanous COP";

      IDEAS.Thermal.Components.Production.Auxiliaries.HP_BW_CondensationPower_Losses
        heatSource(
        medium=medium,
        mediumEvap=mediumEvap,
        QDesign=QNom,
        TCondensor_in=heatedFluid.T_a,
        TCondensor_set=TSet,
        m_flowCondensor=heatedFluid.flowPort_a.m_flow,
        TEnvironment=heatPort.T,
        UALoss=UALoss)
        annotation (Placement(transformation(extent={{-48,-46},{-28,-26}})));
      outer Commons.SimInfoManager sim
        annotation (Placement(transformation(extent={{-82,66},{-62,86}})));
      IDEAS.Thermal.Components.Interfaces.FlowPort_a
                                    flowPortEvap_a(medium=mediumEvap)
        annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
      IDEAS.Thermal.Components.Interfaces.FlowPort_b
                                    flowPortEvap_b(medium=mediumEvap)
        annotation (Placement(transformation(extent={{10,-110},{30,-90}})));
    equation
      PFuel = 0;
      PEl = heatSource.PEl;
      COP = if noEvent(PEl > 0) then heatedFluid.heatPort.Q_flow / PEl else 0;
      connect(flowPortEvap_a, heatSource.flowPort_a)
                                                 annotation (Line(
          points={{-40,-100},{-42,-100},{-42,-46}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(heatSource.flowPort_b, flowPortEvap_b)
                                                 annotation (Line(
          points={{-36,-46},{-34,-46},{-34,-72},{20,-72},{20,-100}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(heatSource.heatPort, heatedFluid.heatPort)
                                                     annotation (Line(
          points={{-28,-36},{-20,-36},{-20,6.12323e-016}},
          color={191,0,0},
          smooth=Smooth.None));
      annotation (Diagram(graphics), Icon(graphics={
            Line(
              points={{-28,72},{-50,-30}},
              color={0,0,255},
              smooth=Smooth.None,
              thickness=1),
            Line(
              points={{0,70},{-22,-32}},
              color={0,0,255},
              smooth=Smooth.None,
              thickness=1),
            Line(
              points={{36,68},{14,-34}},
              color={0,0,255},
              smooth=Smooth.None,
              thickness=1),
            Line(
              points={{34,68},{42,64},{46,64},{56,56},{56,54},{62,40},{62,38},{64,
                  32},{64,30},{60,24},{58,22},{54,20},{52,18},{46,16},{40,16},{34,
                  16},{28,16},{18,16}},
              color={0,0,255},
              smooth=Smooth.None,
              thickness=1),
            Line(
              points={{-46,24},{-44,24},{2,24}},
              color={0,0,255},
              thickness=1,
              smooth=Smooth.None)}));
    end HP_BW;

    model HP_AWMod_Losses "Modulating AW HP with losses to environment"

      extends
        IDEAS.Thermal.Components.Production.Auxiliaries.PartialDynamicHeaterWithLosses(
          final heaterType=IDEAS.Thermal.Components.Production.Auxiliaries.HeaterType.HP_AW);

      Real COP "Instanteanous COP";
      parameter Real betaFactor = 0.8
        "Relative sizing compared to design heat load";

    public
      IDEAS.Thermal.Components.Production.Auxiliaries.HP_CondensationPower_Losses
        heatSource(
        medium=medium,
        QDesign=QNom,
        TEvaporator=sim.Te,
        TCondensor_in=heatedFluid.T_a,
        TCondensor_set=TSet,
        m_flowCondensor=heatedFluid.flowPort_a.m_flow,
        TEnvironment=heatPort.T,
        UALoss=UALoss)
        annotation (Placement(transformation(extent={{-46,-46},{-26,-26}})));
      outer Commons.SimInfoManager sim
        annotation (Placement(transformation(extent={{-82,66},{-62,86}})));

    equation
      PFuel = 0;
      PEl = heatSource.PEl;
      COP = if noEvent(PEl > 0) then heatedFluid.heatPort.Q_flow / PEl else 0;

      connect(heatSource.heatPort, heatedFluid.heatPort)
                                                     annotation (Line(
          points={{-26,-36},{-20,-36},{-20,6.12323e-016}},
          color={191,0,0},
          smooth=Smooth.None));
      annotation (Diagram(graphics), Icon(graphics={
            Line(
              points={{-28,72},{-50,-30}},
              color={0,0,255},
              smooth=Smooth.None,
              thickness=1),
            Line(
              points={{0,70},{-22,-32}},
              color={0,0,255},
              smooth=Smooth.None,
              thickness=1),
            Line(
              points={{36,68},{14,-34}},
              color={0,0,255},
              smooth=Smooth.None,
              thickness=1),
            Line(
              points={{34,68},{42,64},{46,64},{56,56},{56,54},{62,40},{62,38},{64,
                  32},{64,30},{60,24},{58,22},{54,20},{52,18},{46,16},{40,16},{34,
                  16},{28,16},{18,16}},
              color={0,0,255},
              smooth=Smooth.None,
              thickness=1),
            Line(
              points={{-46,24},{-44,24},{2,24}},
              color={0,0,255},
              thickness=1,
              smooth=Smooth.None)}));
    end HP_AWMod_Losses;

    model HP_AWMod_Losses_MinOff
      "Modulating AW HP with losses to environment and minimum off-time"

      extends
        IDEAS.Thermal.Components.Production.Auxiliaries.PartialDynamicHeaterWithLosses(
          final heaterType=IDEAS.Thermal.Components.Production.Auxiliaries.HeaterType.HP_AW);

      Real COP "Instanteanous COP";

    public
      IDEAS.Thermal.Components.Production.Auxiliaries.HP_CondensationPower_Losses_MinOff
        heatSource(
        medium=medium,
        QDesign=QNom,
        TEvaporator=sim.Te,
        TCondensor_in=heatedFluid.T_a,
        TCondensor_set=TSet,
        m_flowCondensor=heatedFluid.flowPort_a.m_flow,
        TEnvironment=heatPort.T,
        UALoss=UALoss)
        annotation (Placement(transformation(extent={{-48,-46},{-28,-26}})));
      outer Commons.SimInfoManager sim
        annotation (Placement(transformation(extent={{-82,66},{-62,86}})));

    equation
      PFuel = 0;
      PEl = heatSource.PEl;
      COP = if noEvent(PEl > 0) then heatedFluid.heatPort.Q_flow / PEl else 0;

      connect(heatSource.heatPort, heatedFluid.heatPort)
                                                     annotation (Line(
          points={{-28,-36},{-20,-36},{-20,6.12323e-016}},
          color={191,0,0},
          smooth=Smooth.None));
      annotation (Diagram(graphics), Icon(graphics={
            Line(
              points={{-28,72},{-50,-30}},
              color={0,0,255},
              smooth=Smooth.None,
              thickness=1),
            Line(
              points={{0,70},{-22,-32}},
              color={0,0,255},
              smooth=Smooth.None,
              thickness=1),
            Line(
              points={{36,68},{14,-34}},
              color={0,0,255},
              smooth=Smooth.None,
              thickness=1),
            Line(
              points={{34,68},{42,64},{46,64},{56,56},{56,54},{62,40},{62,38},{64,
                  32},{64,30},{60,24},{58,22},{54,20},{52,18},{46,16},{40,16},{34,
                  16},{28,16},{18,16}},
              color={0,0,255},
              smooth=Smooth.None,
              thickness=1),
            Line(
              points={{-46,24},{-44,24},{2,24}},
              color={0,0,255},
              thickness=1,
              smooth=Smooth.None)}));
    end HP_AWMod_Losses_MinOff;

    model HP_BW_Borehole "BW HP with borehole included"

      extends
        IDEAS.Thermal.Components.Production.Auxiliaries.PartialDynamicHeaterWithLosses(
          final heaterType=IDEAS.Thermal.Components.Production.Auxiliaries.HeaterType.HP_BW);
      parameter Modelica.SIunits.Power QNom "Nominal power at 2/35";
      parameter TME.FHF.Interfaces.Medium
                                     mediumEvap=TME.FHF.Media.Water()
        "Medium in the evaporator";
      parameter TME.FHF.Interfaces.Medium
                                     mediumBorehole = TME.FHF.Media.Water();

      Real COP "Instanteanous COP";

      IDEAS.Thermal.Components.Production.Auxiliaries.HP_BW_CondensationPower_Losses
        heatSource(
        medium=medium,
        mediumEvap=mediumEvap,
        QDesign=QNom,
        TCondensor_in=heatedFluid.T_a,
        TCondensor_set=TSet,
        m_flowCondensor=heatedFluid.flowPort_a.m_flow,
        TEnvironment=heatPort.T,
        UALoss=UALoss)
        annotation (Placement(transformation(extent={{-48,-46},{-28,-26}})));
      outer Commons.SimInfoManager sim
        annotation (Placement(transformation(extent={{-82,66},{-62,86}})));
      IDEAS.Thermal.Components.VerticalGroundHeatExchanger.VerticalHeatExchangerModels.BoreHole
                                                                          boreHole(medium=
            mediumBorehole)
        annotation (Placement(transformation(extent={{36,-70},{56,-50}})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                              pumpBorehole(
        medium=mediumBorehole,
        m=0,
        useInput=true,
        m_flowNom=0.5,
        dpFix=80000)
                annotation (Placement(transformation(extent={{-4,-68},{12,-52}})));
      IDEAS.Thermal.Components.BaseClasses.AbsolutePressure
                                          absolutePressure(medium=
            mediumBorehole, p=300000)
        annotation (Placement(transformation(extent={{68,-46},{80,-34}})));
    equation
      PFuel = 0;
      PEl = heatSource.PEl + pumpBorehole.PEl;
      COP = if noEvent(heatSource.PEl > 0) then heatedFluid.heatPort.Q_flow / PEl else 0;
      pumpBorehole.m_flowSet = if noEvent(heatSource.PEl > 0) then 1 else 0;
      connect(heatSource.heatPort, heatedFluid.heatPort)
                                                     annotation (Line(
          points={{-28,-36},{-20,-36},{-20,6.12323e-016}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(heatSource.flowPort_b, pumpBorehole.flowPort_a)
                                                      annotation (Line(
          points={{-36,-46},{-36,-60},{-4,-60}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(pumpBorehole.flowPort_b, boreHole.flowPort_a)
                                                    annotation (Line(
          points={{12,-60},{24.1,-60},{24.1,-60.2},{36.2,-60.2}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(heatSource.flowPort_a, boreHole.flowPort_b) annotation (Line(
          points={{-42,-46},{-42,-88},{82,-88},{82,-60},{55.8,-60}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(absolutePressure.flowPort, boreHole.flowPort_b) annotation (Line(
          points={{68,-40},{55.8,-40},{55.8,-60}},
          color={255,0,0},
          smooth=Smooth.None));
      annotation (Diagram(graphics), Icon(graphics={
            Line(
              points={{-28,72},{-50,-30}},
              color={0,0,255},
              smooth=Smooth.None,
              thickness=1),
            Line(
              points={{0,70},{-22,-32}},
              color={0,0,255},
              smooth=Smooth.None,
              thickness=1),
            Line(
              points={{36,68},{14,-34}},
              color={0,0,255},
              smooth=Smooth.None,
              thickness=1),
            Line(
              points={{34,68},{42,64},{46,64},{56,56},{56,54},{62,40},{62,38},{64,
                  32},{64,30},{60,24},{58,22},{54,20},{52,18},{46,16},{40,16},{34,
                  16},{28,16},{18,16}},
              color={0,0,255},
              smooth=Smooth.None,
              thickness=1),
            Line(
              points={{-46,24},{-44,24},{2,24}},
              color={0,0,255},
              thickness=1,
              smooth=Smooth.None)}));
    end HP_BW_Borehole;

    model CollectorG
      "Glazed collector, originally from master thesis Mark Gutschoven, 2010-2011"

      // not cleaned up nor validated

     extends Modelica.Thermal.FluidHeatFlow.Interfaces.Partials.TwoPort(m=medium.rho
            *Vol);
    Commons.Meteo.Solar.Elements.AngleHour angleHour;
    /*
Model_Mark.Meteo.Solar.RadiationSolar radSol(
    TeAv=265,
    solDirPer=sim.solDirPer,
    solDirHor=sim.solDirHor,
    solDifHor=sim.solDifHor,
    inc=30,
    azi=0,
    A=1);
*/
      parameter Real pi=Modelica.Constants.pi;
      //parameter Real inc(start=30);

      parameter Modelica.SIunits.Volume Vol=AColTot * 1.3 *1e-3;
      parameter Modelica.SIunits.Area ACol "Surface of a single collector";
      parameter Integer nCol "Number of collectors in series";
      final parameter Modelica.SIunits.Area AColTot = ACol * nCol
        "Total effective surface";

      parameter Modelica.SIunits.Length h_g(start=-2)
        "Geodetic height (heigth difference from flowPort_a to flowPort_b)";

      //pressure drop coefficietns
      parameter Real a=2*0.0008436127;
      parameter Real b=2*0.1510363177;//2 vanwege in serie
      parameter Real correctie=11.1/16.5;//drukval collector is ongeveer gelijk per l/h.m²

      Modelica.SIunits.Irradiance Ibeam=radSol.solDir;
      Modelica.SIunits.Irradiance Idiff=radSol.solDif;
      Real cosXi=cos(radSol.angInc);
      Real angle_zenit = radSol.angZen;

      // gemeten in dezelfde hoek als collector
      Modelica.SIunits.Temperature T_amb=sim.Te;
      Modelica.SIunits.Temperature T_coll=(T_a+T_b)/2;
      Modelica.SIunits.Temp_K T_sky=(T_amb^1.5)*0.0552;

      Modelica.SIunits.Efficiency eta;
      // parameters from Viesmann vitosol 200F (http://www.viessmann.be/etc/medialib/internet-be/Nederlandstalige_media/Tech_Doc/Zon/Vitosol_300-F.Par.8340.File.File.tmp/PLA_Vitosol_5818440_B-fl_5-2010.pdf p 13)
      parameter Modelica.SIunits.Efficiency eta_0=0.793;
      parameter Real k1=4.04;
      parameter Real k2=0.0182;

      parameter Modelica.SIunits.TransmissionCoefficient ta=0.95*0.9
        "transmission-absorption coefficient";

      parameter Real b_IAM=-0.09; // based on Kta 50° = 0.95
      Modelica.SIunits.TransmissionCoefficient Kta= (1+b_IAM*(1/cosXi-1)); // Duffie Beckman p263
      Modelica.SIunits.TransmissionCoefficient IAM= Kta
        "incidence angle modifier Kta=0.95 at 50°";

       Real Ul;
       Real Q_loss;
       Real QInNet;
       Modelica.SIunits.Power QInBru=AColTot*(Ibeam + Idiff);
       Modelica.SIunits.Power QNet=-(flowPort_b.H_flow + flowPort_a.H_flow)
        "Net power delivered by the collector";
       parameter Modelica.SIunits.TransmissionCoefficient GSC=0;
       Real Q_lossRad;

      parameter Real eps=0.03;

      Modelica.SIunits.Irradiance S;

    Real feq=if noEvent((V_flow/nCol*correctie)>0.00001) then (1e8)*V_door^(-0.376) else 1e8*0.00001^(-0.376);
    Real V_door=V_flow/nCol*correctie;
    Real dpEq=2*(feq*medium.rho*(V_flow/nCol*correctie)^2/2*(nue/nue_ref)^0.25);

    parameter Real nue_ref=1.004e-6;
    Real nue = (5.8127*exp(-0.03*(T-273)))*1e-6;
      Modelica.SIunits.Pressure dp_ref;

      Real I=Idiff+Ibeam;
      Modelica.Blocks.Interfaces.RealOutput TCol
        annotation (Placement(transformation(extent={{94,-70},{114,-50}})));
      outer Commons.SimInfoManager sim
        annotation (Placement(transformation(extent={{-86,60},{-66,80}})));
      Commons.Meteo.Solar.RadSol radSol(inc=30 * pi/180, azi=0, A=1)
        annotation (Placement(transformation(extent={{-40,58},{-20,78}})));
    equation
      eta = if noEvent(S<1) then eta_0 - k1*(T_coll - T_amb) - k2*((T_coll -
        T_amb)^2) else eta_0 - k1*(T_coll - T_amb)/S - k2*((T_coll -
        T_amb)^2)/S;
      // vergelijking die efficientiecurve collector beschrijft

    /*  eta = if (S<1) then 0 else if noEvent(eta_0 - k1*(T_coll - T_amb)/S - k2*((T_coll
     - T_amb)^2)/S) > 0 then eta_0 - k1*(T_coll - T_amb)/S - k2*((T_coll -
    T_amb)^2)/S else 0;
    */

      Ul= (k1 + k2*(T_coll - T_amb));//stralingsverliezen verwaarloosd

      dp = dpEq + medium.rho*Modelica.Constants.g_n*h_g;
      // energy exchange with medium
      dp_ref= (a*((V_flow/nCol*correctie)*(10^3*3600))^2 + b*(V_flow/nCol*correctie)*(10^3*3600))*1e2;
      Q_loss= Ul*AColTot*(T_coll - T_amb)+(1-eta_0)*S*AColTot;

    S=Ibeam*IAM*(1-GSC)+Idiff+ 1e-8;
    // IAM= Incident angle modifier and GSC shading coefficient;

    Q_flow= eta_0*(S*AColTot)- Ul*AColTot*(T_coll - T_amb);
    QInNet = S*AColTot;

    Q_lossRad= eps*Modelica.Constants.sigma*AColTot*(T_coll^4-T_sky^4);// not considered
    TCol=T;

      annotation (
        Documentation(info="<html>
<p>Glazed flat plate solar collector, originally modelled by Mark Gutschoven in his master thesis, 2010-2011</p>
<p>This model is not yet validated nor cleaned according to the conventions</p>
</html>"),
        Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                100}}), graphics),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
                100,100}}), graphics));
    end CollectorG;

    model SolarThermalSystem_Simple
      "Very basic simple solar thermal system, without storage (complete primary circuit + control)"

      parameter TME.FHF.Interfaces.Medium
                                     medium = TME.FHF.Media.Water();
      parameter Modelica.SIunits.Area ACol
        "Area of one single series-connected collector";
      parameter Integer nCol "Number of collectors in series";
      parameter Real m_flowSp = 30 "Specific mass flow rate, in liter/hm2";

      output Modelica.SIunits.Power QCol
        "Net power delivered by the solar collector";
      output Modelica.SIunits.Power QSTS
        "Net power delivered by the primary circuit";

      IDEAS.Thermal.Components.HeatProduction.CollectorG
                                               collectorG(
        medium=medium,
        h_g=2,
        ACol=ACol,
        nCol=nCol,
        T0=283.15)
        annotation (Placement(transformation(extent={{-84,-28},{-64,-8}})));
      IDEAS.Thermal.Components.BaseClasses.HeatedPipe
                                    pipeHot(medium=medium, m=5)
        annotation (Placement(transformation(extent={{-46,-28},{-26,-8}})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                              pump(medium=medium,
        m=0,
        useInput=true,
        m_flowNom=m_flowSp*ACol*nCol/3600)
        annotation (Placement(transformation(extent={{-10,-28},{10,-8}})));
      IDEAS.Thermal.Components.BaseClasses.HeatedPipe
                                    pipeCold(medium=medium, m=5)
        annotation (Placement(transformation(extent={{-26,-78},{-46,-58}})));

      IDEAS.Thermal.Control.SolarThermalControl_DT
                                          solarThermalControl_DT(
       TSafetyMax=363.15)
        annotation (Placement(transformation(extent={{54,44},{34,64}})));
      IDEAS.Thermal.Components.Interfaces.FlowPort_a flowPort_a(medium=medium)
        annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
      IDEAS.Thermal.Components.Interfaces.FlowPort_b flowPort_b(medium=medium)
        annotation (Placement(transformation(extent={{90,-30},{110,-10}})));
      Modelica.Blocks.Interfaces.RealInput TSafety
        annotation (Placement(transformation(extent={{128,58},{88,98}})));
      Modelica.Blocks.Interfaces.RealInput TLow
        annotation (Placement(transformation(extent={{126,14},{86,54}})));
      outer Commons.SimInfoManager sim
        annotation (Placement(transformation(extent={{-92,68},{-72,88}})));
    equation
      QCol = collectorG.QNet;
      QSTS = - (flowPort_a.H_flow + flowPort_b.H_flow);
      connect(collectorG.flowPort_b, pipeHot.flowPort_a)    annotation (Line(
          points={{-64,-18},{-46,-18}},
          color={255,0,0},
          smooth=Smooth.None));

      connect(pipeHot.flowPort_b, pump.flowPort_a)    annotation (Line(
          points={{-26,-18},{-10,-18}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(pipeCold.flowPort_b, collectorG.flowPort_a)    annotation (Line(
          points={{-46,-68},{-92,-68},{-92,-18},{-84,-18}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(solarThermalControl_DT.onOff, pump.m_flowSet) annotation (Line(
          points={{33.4,56},{0,56},{0,-8}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(collectorG.TCol, solarThermalControl_DT.TCollector) annotation (Line(
          points={{-63.6,-24},{-54,-24},{-54,40},{82,40},{82,54},{54.6,54}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(flowPort_a, pipeCold.flowPort_a) annotation (Line(
          points={{100,-60},{38,-60},{38,-68},{-26,-68}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(flowPort_b, pump.flowPort_b) annotation (Line(
          points={{100,-20},{64,-20},{64,-18},{10,-18}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(TSafety, solarThermalControl_DT.TSafety) annotation (Line(
          points={{108,78},{70,78},{70,60},{54.6,60}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(TLow, solarThermalControl_DT.TTankBot) annotation (Line(
          points={{106,34},{70,34},{70,48},{54.6,48}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end SolarThermalSystem_Simple;
  end Production;

  package Emission "Models for heat/cold emission"

    extends Modelica.Icons.Package;

    package Auxiliaries
      type EmissionType = enumeration(
          Radiators "Radiators",
          FloorHeating "Floor heating",
          RadiatorsAndFloorHeating "Both radiators and floor heating")
        "Type of the emission system: radiarors or floor heating";
      partial model Partial_Tabs "Partial tabs model"

        replaceable parameter
          IDEAS.Thermal.Components.Emission.FH_Characteristics FHChars(A_Floor=
              A_Floor) constrainedby
          IDEAS.Thermal.Components.Emission.FH_Characteristics(A_Floor=A_Floor) annotation (choicesAllMatching = true);

        parameter TME.FHF.Interfaces.Medium
                                       medium=TME.FHF.Interfaces.Medium()
          "Medium in the component";
        parameter Modelica.SIunits.MassFlowRate m_flowMin
          "Minimal flowrate when in operation";
        parameter Modelica.SIunits.Area A_Floor=1 "Total Surface of the TABS";

        IDEAS.Thermal.Components.Interfaces.FlowPort_a
                                      flowPort_a(medium = medium)
          annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
        IDEAS.Thermal.Components.Interfaces.FlowPort_b
                                      flowPort_b(medium = medium)
          annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
        Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
          annotation (Placement(transformation(extent={{-10,90},{10,110}})));
        Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_b
          annotation (Placement(transformation(extent={{-10,-108},{10,-88}})));

        annotation (Diagram(graphics));

      end Partial_Tabs;

      model Partial_EmbeddedPipe "Partial for the embedded pipe model"
        import IDEAS.Thermal.Components.Emission.Auxiliaries.EmissionType;
        extends Partial_Emission(final emissionType = EmissionType.FloorHeating);

        parameter Modelica.SIunits.MassFlowRate m_flowMin
          "Minimal flowrate when in operation";

      end Partial_EmbeddedPipe;

      partial model Partial_Emission
        "Partial emission system for both radiators and floor heating"

        import IDEAS.Thermal.Components.Emission.Auxiliaries.EmissionType;
        parameter EmissionType emissionType = EmissionType.RadiatorsAndFloorHeating
          "Type of the heat emission system";

        parameter TME.FHF.Interfaces.Medium
                                       medium = TME.FHF.Media.Water();

      // Interfaces ////////////////////////////////////////////////////////////////////////////////////////
        Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortConv if
            (emissionType == EmissionType.Radiators or emissionType == EmissionType.RadiatorsAndFloorHeating)
          "convective heat transfer from radiators"
          annotation (Placement(transformation(extent={{10,90},{30,110}})));
        Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortRad if
            (emissionType == EmissionType.Radiators or emissionType == EmissionType.RadiatorsAndFloorHeating)
          "radiation heat transfer from radiators"
          annotation (Placement(transformation(extent={{50,90},{70,110}})));
        Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortFH if
            (emissionType == EmissionType.FloorHeating or emissionType == EmissionType.RadiatorsAndFloorHeating)
          "Port to the core of a floor heating/concrete activation"
          annotation (Placement(transformation(extent={{-96,90},{-76,110}})));
      // General parameters for the design (nominal) conditions /////////////////////////////////////////////

      // Other parameters//////////////////////////////////////////////////////////////////////////////////////
        parameter Modelica.SIunits.Temperature TInitial=293.15
          "Initial temperature of all state variables";
        replaceable parameter
          IDEAS.Thermal.Components.Emission.FH_Characteristics FHChars if (
          emissionType == EmissionType.FloorHeating or emissionType ==
          EmissionType.RadiatorsAndFloorHeating)                                                               annotation (choicesAllMatching=true);

      // Variables ///////////////////////////////////////////////////////////////////////////////////////////
        Modelica.SIunits.Temperature TMean(start=TInitial, fixed=false)
          "Mean water temperature";
        Modelica.SIunits.Temperature TIn(start=TInitial, fixed=false)
          "Temperature of medium inflow through flowPort_a";
        Modelica.SIunits.Temperature TOut(start=TInitial, fixed=false)
          "Temperature of medium outflow through flowPort_b";

      // General outputs

        IDEAS.Thermal.Components.Interfaces.FlowPort_a
                                      flowPort_a(h(start=TInitial*medium.cp,
              fixed=false), medium=medium)
          annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
        IDEAS.Thermal.Components.Interfaces.FlowPort_b
                                      flowPort_b(h(start=TInitial*medium.cp,
              fixed=false), medium=medium)
          annotation (Placement(transformation(extent={{90,-10},{110,10}})));
      initial equation
        //der(flowPort_a.h) = 0;
        annotation(Icon(graphics),
            Diagram(graphics));
      end Partial_Emission;
    end Auxiliaries;

    record FH_Characteristics
      "Record containing all parameters for a given floor heating"

      // The terminology from prEN 15377 is followed, even if I find the development of the theory
      // by Koschenz and Lehmann better (see Thermoaktive Bauteilsysteme tabs, from Empa)

      // First Version 20110622

      // Changed 20110629:
      // Important: this record ALSO contains the parameters that are specific to the building.

      parameter Modelica.SIunits.Length T(
        min=0.15,
        max=0.3)=0.2 "Pipe spacing, limits imposed by prEN 15377-3 p22";
      parameter Modelica.SIunits.Length d_a=0.02
        "External diameter of the pipe";
      parameter Modelica.SIunits.Length s_r=0.0025 "Thickness of the pipe wall";
      parameter Modelica.SIunits.ThermalConductivity lambda_r=0.35
        "Thermal conductivity of the material of the pipe";
      parameter Modelica.SIunits.Length S_1=0.1
        "Thickness of the concrete/screed ABOVE the pipe layer";
      parameter Modelica.SIunits.Length S_2=0.1
        "Thickness of the concrete/screed UNDER the pipe layer";
      parameter Modelica.SIunits.Area A_Floor=1
        "Tabs floor surface, CHANGE THIS!!";
      parameter Modelica.SIunits.ThermalConductivity lambda_b=1.8
        "Thermal conductivity of the concrete or screed layer";
      parameter Modelica.SIunits.SpecificHeatCapacity c_b=840
        "Thermal capacity of the concrete/screed material";
      parameter Modelica.SIunits.Density rho_b=2100
        "Density of the concrete/screed layer";
      constant Integer n1=3 "Number of discrete capacities in upper layer";
      constant Integer n2=3 "Number of discrete capacities in lower layer";

    end FH_Characteristics;

    record FH_Standard1 "Basic floor heating design 1"
      extends IDEAS.Thermal.Components.Emission.FH_Characteristics;
    end FH_Standard1;

    record FH_Standard2 "Larger pipes and bigger interdistance"
      extends IDEAS.Thermal.Components.Emission.FH_Characteristics(
        T=0.2,
        d_a=0.025,
        s_r=0.0025);
    end FH_Standard2;

    record FH_ValidationEmpa "According to Koschenz, 2000, par 4.5.1"
      extends IDEAS.Thermal.Components.Emission.FH_Characteristics(
        T=0.25,
        d_a=0.02,
        s_r=0.0025,
        n1=10,
        n2=10,
        lambda_r=0.55);
    end FH_ValidationEmpa;

    record FH_ValidationEmpa4_6 "According to Koschenz, 2000, par 4.6"
      extends IDEAS.Thermal.Components.Emission.FH_Characteristics(
        S_1=0.1,
        S_2=0.2,
        T=0.20,
        d_a=0.025,
        s_r=0.0025,
        n1=10,
        n2=10,
        lambda_r=0.45);
                  // A_Floor should be 120m * 0.2m = 24 m²
    end FH_ValidationEmpa4_6;

    model NakedTabs "HeatPort only very simple tabs system"

      replaceable parameter
        IDEAS.Thermal.Components.Emission.FH_Characteristics FHChars                   annotation (choicesAllMatching = true);

      parameter Integer n1 = FHChars.n1;
      parameter Integer n2 = FHChars.n2;
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
        annotation (Placement(transformation(extent={{-10,90},{10,110}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_b
        annotation (Placement(transformation(extent={{-10,-108},{10,-88}})));
      Modelica.Thermal.HeatTransfer.Components.ThermalConductor[n1+1] U1(each G = FHChars.lambda_b / (FHChars.S_1 / (n1+1)) * FHChars.A_Floor)
                                                                   annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={0,32})));
      Modelica.Thermal.HeatTransfer.Components.ThermalConductor[n2+1] U2(each G = FHChars.lambda_b / (FHChars.S_2 / (n2+1)) * FHChars.A_Floor)
                                                                   annotation (
          Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=90,
            origin={0,-22})));
      Modelica.Thermal.HeatTransfer.Components.HeatCapacitor[n1] C1(each C = FHChars.A_Floor * FHChars.S_1/n1 * FHChars.rho_b * FHChars.c_b,
        each T(fixed=false))
        annotation (Placement(transformation(extent={{32,54},{52,74}})));

      Modelica.Thermal.HeatTransfer.Components.HeatCapacitor[n2] C2(each C = FHChars.A_Floor * FHChars.S_2/n2 * FHChars.rho_b * FHChars.c_b)
        annotation (Placement(transformation(extent={{30,-62},{50,-42}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a portCore
        annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
    equation
      for i in 1:n1 loop
        connect(U1[i].port_b, U1[i+1].port_a);
        connect(U1[i].port_b, C1[i].port);
      end for;
      for i in 1:n2 loop
        connect(U2[i].port_b, U2[i+1].port_a);
        connect(U2[i].port_b, C2[i].port);
      end for;
      connect(U1[n1+1].port_b, port_a);
      connect(U2[n2+1].port_b, port_b);
      connect(portCore, U1[1].port_a) annotation (Line(
          points={{-100,0},{-6.12323e-016,0},{-6.12323e-016,22}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(portCore, U2[1].port_a) annotation (Line(
          points={{-100,0},{6.12323e-016,0},{6.12323e-016,-12}},
          color={191,0,0},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end NakedTabs;

    model NakedTabsMassiveCore
      "HeatPort only very simple tabs system, with lumped capacity to the core layer"

      replaceable parameter
        IDEAS.Thermal.Components.Emission.FH_Characteristics FHChars                   annotation (choicesAllMatching = true);

      parameter Integer n1 = FHChars.n1;
      parameter Integer n2 = FHChars.n2;
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
        annotation (Placement(transformation(extent={{-10,90},{10,110}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_b
        annotation (Placement(transformation(extent={{-10,-108},{10,-88}})));
      Modelica.Thermal.HeatTransfer.Components.ThermalConductor[n1+1] U1(each G = FHChars.lambda_b / (FHChars.S_1 / (n1+1)) * FHChars.A_Floor)
                                                                   annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={0,32})));
      Modelica.Thermal.HeatTransfer.Components.ThermalConductor[n2+1] U2(each G = FHChars.lambda_b / (FHChars.S_2 / (n2+1)) * FHChars.A_Floor)
                                                                   annotation (
          Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=90,
            origin={0,-22})));
      Modelica.Thermal.HeatTransfer.Components.HeatCapacitor[n1] C1(each C = FHChars.A_Floor * FHChars.S_1/(n1+1) * FHChars.rho_b * FHChars.c_b)
        annotation (Placement(transformation(extent={{32,54},{52,74}})));

      Modelica.Thermal.HeatTransfer.Components.HeatCapacitor[n2] C2(each C = FHChars.A_Floor * FHChars.S_2/(n2+1) * FHChars.rho_b * FHChars.c_b)
        annotation (Placement(transformation(extent={{30,-62},{50,-42}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a portCore
        annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
      Modelica.Thermal.HeatTransfer.Components.HeatCapacitor C0(C = FHChars.A_Floor * FHChars.S_1/(n1+1) * FHChars.rho_b * FHChars.c_b + FHChars.A_Floor * FHChars.S_2/(n2+1) * FHChars.rho_b * FHChars.c_b)
        "Capacitor to the core"
        annotation (Placement(transformation(extent={{34,6},{54,26}})));
    equation
      for i in 1:n1 loop
        connect(U1[i].port_b, U1[i+1].port_a);
        connect(U1[i].port_b, C1[i].port);
      end for;
      for i in 1:n2 loop
        connect(U2[i].port_b, U2[i+1].port_a);
        connect(U2[i].port_b, C2[i].port);
      end for;
      connect(U1[n1+1].port_b, port_a);
      connect(U2[n2+1].port_b, port_b);
      connect(portCore, U1[1].port_a) annotation (Line(
          points={{-100,0},{-6.12323e-016,0},{-6.12323e-016,22}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(portCore, U2[1].port_a) annotation (Line(
          points={{-100,0},{6.12323e-016,0},{6.12323e-016,-12}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(C0.port, U1[1].port_a) annotation (Line(
          points={{44,6},{44,0},{-6.12323e-016,0},{-6.12323e-016,22}},
          color={191,0,0},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end NakedTabsMassiveCore;

    model Tabs "Very simple tabs system"

      extends IDEAS.Thermal.Components.Emission.Auxiliaries.Partial_Tabs;

      replaceable IDEAS.Thermal.Components.Emission.EmbeddedPipeDynTOut embeddedPipe(
        medium=medium,
        FHChars=FHChars,
        m_flowMin=m_flowMin) constrainedby
        IDEAS.Thermal.Components.Emission.Auxiliaries.Partial_EmbeddedPipe(
        medium=medium,
        FHChars=FHChars,
        m_flowMin=m_flowMin)
        annotation (choices(
          choice(redeclare
              IDEAS.Thermal.Components.Emission.EmbeddedPipe_prEN15377            embeddedPipe),
          choice(redeclare
              IDEAS.Thermal.Components.Emission.EmbeddedPipeDynTOut                    embeddedPipe),
          choice(redeclare
              IDEAS.Thermal.Components.Emission.EmbeddedPipeDynSwitch       embeddedPipe)),
          Placement(transformation(extent={{-56,-8},{-36,12}})));

      NakedTabs nakedTabs(FHChars=FHChars, n1=FHChars.n1, n2=FHChars.n2) annotation (Placement(transformation(extent={{-12,-8},{8,12}})));
        // It's a bit stupid to explicitly pass n1 and n2 again, but it's the only way to avoid warnings/errors in dymola 2012.
    equation
      connect(flowPort_a, embeddedPipe.flowPort_a) annotation (Line(
          points={{-100,40},{-70,40},{-70,2},{-56,2}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(flowPort_b, embeddedPipe.flowPort_b) annotation (Line(
          points={{-100,-40},{-26,-40},{-26,2},{-36,2}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(nakedTabs.port_a, port_a) annotation (Line(
          points={{-2,12},{-2,100},{0,100}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(nakedTabs.port_b, port_b) annotation (Line(
          points={{-2,-7.8},{-2,-98},{0,-98}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(embeddedPipe.heatPortFH, nakedTabs.portCore) annotation (Line(
          points={{-54.6,12},{-33.3,12},{-33.3,2},{-12,2}},
          color={191,0,0},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end Tabs;

    model TabsMassiveCore "Very simple tabs system, with NakedTabsMassiveCore"

      extends IDEAS.Thermal.Components.Emission.Auxiliaries.Partial_Tabs;

      replaceable IDEAS.Thermal.Components.Emission.EmbeddedPipeDynTOut embeddedPipe(
        medium=medium,
        FHChars=FHChars,
        m_flowMin=m_flowMin) constrainedby
        IDEAS.Thermal.Components.Emission.Auxiliaries.Partial_EmbeddedPipe(
        medium=medium,
        FHChars=FHChars,
        m_flowMin=m_flowMin)
        annotation (choices(
          choice(redeclare
              IDEAS.Thermal.Components.Emission.EmbeddedPipe_prEN15377            embeddedPipe),
          choice(redeclare
              IDEAS.Thermal.Components.Emission.EmbeddedPipeDynTOut                    embeddedPipe),
          choice(redeclare
              IDEAS.Thermal.Components.Emission.EmbeddedPipeDynSwitch       embeddedPipe)),
          Placement(transformation(extent={{-56,-8},{-36,12}})));

      NakedTabsMassiveCore
                nakedTabs(FHChars=FHChars, n1=FHChars.n1, n2=FHChars.n2) annotation (Placement(transformation(extent={{-12,-8},{8,12}})));
        // It's a bit stupid to explicitly pass n1 and n2 again, but it's the only way to avoid warnings/errors in dymola 2012.
    equation
      connect(flowPort_a, embeddedPipe.flowPort_a) annotation (Line(
          points={{-100,40},{-70,40},{-70,2},{-56,2}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(flowPort_b, embeddedPipe.flowPort_b) annotation (Line(
          points={{-100,-40},{-26,-40},{-26,2},{-36,2}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(nakedTabs.port_a, port_a) annotation (Line(
          points={{-2,12},{-2,100},{0,100}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(nakedTabs.port_b, port_b) annotation (Line(
          points={{-2,-7.8},{-2,-98},{0,-98}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(embeddedPipe.heatPortFH, nakedTabs.portCore) annotation (Line(
          points={{-54.6,12},{-33.3,12},{-33.3,2},{-12,2}},
          color={191,0,0},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end TabsMassiveCore;

    model TabsDiscretized "Discretized tabs system"

      extends IDEAS.Thermal.Components.Emission.Auxiliaries.Partial_Tabs;

      replaceable parameter
        IDEAS.Thermal.Components.Emission.FH_Characteristics FHCharsDiscretized(A_Floor=
            A_Floor/n) constrainedby
        IDEAS.Thermal.Components.Emission.FH_Characteristics(A_Floor=A_Floor/n);

      parameter Integer n(min=2)=2 "number of discrete elements";

      IDEAS.Thermal.Components.Emission.Tabs[n] tabs(
        each medium=medium,
        each A_Floor=A_Floor/n,
        each m_flowMin=m_flowMin,
        each FHChars=FHCharsDiscretized)
        annotation (Placement(transformation(extent={{-54,-8},{-34,12}})));

      Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector(m=n)
        annotation (Placement(transformation(extent={{-54,52},{-34,32}})));
      Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector1(m=n)
        annotation (Placement(transformation(extent={{-54,-46},{-34,-26}})));
    equation
      connect(flowPort_a, tabs[1].flowPort_a) annotation (Line(
          points={{-100,40},{-76,40},{-76,6},{-54,6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(tabs[n].flowPort_b, flowPort_b) annotation (Line(
          points={{-54,-2},{-76,-2},{-76,-40},{-100,-40}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(thermalCollector.port_b, port_a) annotation (Line(
          points={{-44,52},{-44,74},{0,74},{0,100}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(tabs.port_a, thermalCollector.port_a) annotation (Line(
          points={{-44,12},{-44,32}},
          color={191,0,0},
          smooth=Smooth.None));

      for i in 1:n-1 loop
        connect(tabs[i].flowPort_b,tabs[i+1].flowPort_a);
      end for;

      connect(tabs.port_b, thermalCollector1.port_a) annotation (Line(
          points={{-44,-7.8},{-44,-26}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(thermalCollector1.port_b, port_b) annotation (Line(
          points={{-44,-46},{-44,-80},{0,-80},{0,-98}},
          color={191,0,0},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end TabsDiscretized;

    model TabsDiscretized_2
      "Discretized tabs system, with discretized floor surface temperature too"

      extends IDEAS.Thermal.Components.Emission.Auxiliaries.Partial_Tabs;

      replaceable parameter
        IDEAS.Thermal.Components.Emission.FH_Characteristics FHCharsDiscretized(A_Floor=
            A_Floor/n) constrainedby
        IDEAS.Thermal.Components.Emission.FH_Characteristics(A_Floor=A_Floor/n);

      parameter Integer n(min=2)=2 "number of discrete elements";

      IDEAS.Thermal.Components.Emission.Tabs[n] tabs(
        each medium=medium,
        each A_Floor=A_Floor/n,
        each m_flowMin=m_flowMin,
        each FHChars=FHCharsDiscretized)
        annotation (Placement(transformation(extent={{-54,-8},{-34,12}})));

    equation
      connect(flowPort_a, tabs[1].flowPort_a) annotation (Line(
          points={{-100,40},{-76,40},{-76,6},{-54,6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(tabs[n].flowPort_b, flowPort_b) annotation (Line(
          points={{-54,-2},{-76,-2},{-76,-40},{-100,-40}},
          color={255,0,0},
          smooth=Smooth.None));

      for i in 1:n-1 loop
        connect(tabs[i].flowPort_b,tabs[i+1].flowPort_a);
      end for;
      for i in 1:n loop
        connect(tabs[i].port_b, port_b);
      end for;

      annotation (Diagram(graphics));
    end TabsDiscretized_2;

    model Radiator "Simple 1-node radiator model according to EN 442"

      import IDEAS.Thermal.Components.Emission.Auxiliaries.EmissionType;
      extends IDEAS.Thermal.Components.Emission.Auxiliaries.Partial_Emission(
          final emissionType=EmissionType.Radiators);

      /* The capacity of the radiator is based on a calculation for 1 
  type of radiator from Radson.  The headlines of the calculation:
  - we suppose the normative 75/65/20 design conditions (this is a crucial parameter!!!)
  - we take a type 22 radiator from the Radson Compact or Integra series
  - we take a length of 1.05m, height 0.6m
  - we get a power of 1924W, a water content of 7.24 l and a steel weight of 35.52 kg
  - water content: 0.0038 l/W 
  - steel weight: 0.018 kg/W
  Resulting capacity: 24.6 J/K per Watt of nominal power
  
  Redo this calculation for other design conditions
  Example: for 45/35/20 we would get 3.37 times less power, 
  so we have to increase the volume and weight per W by 3.37
  */

      parameter Modelica.SIunits.Temperature TInNom=75 + 273.15
        "Nominal inlet temperature";
      parameter Modelica.SIunits.Temperature TOutNom=65 + 273.15
        "Nominal outlet temperature";
      parameter Modelica.SIunits.Temperature TZoneNom=20 + 273.15
        "Nominal room temperature";

      parameter Modelica.SIunits.Power QNom=1000
        "Nominal thermal power at the specified conditions";
      parameter Real fraRad = 0.35 "Fraction of radiation at Nominal power";
      parameter Real n = 1.3 "Radiator coefficient according to EN 442-2";

      parameter Real powerFactor = 1
        "Size increase compared to design at 75/65/20";
        // For reference: 45/35/20 is 3.37; 50/40/20 is 2.5:
        // Source: http://www.radson.com/be/producten/paneelradiatoren/radson-compact.htm, accessed on 15/06/2011
      parameter Modelica.SIunits.Mass mMedium(start=1)=0.0038*QNom*powerFactor
        "Mass of medium (water) in the radiator";
      parameter Modelica.SIunits.Mass mDry(start=1)=0.018*QNom*powerFactor
        "Mass of dry material (steel/aluminium) in the radiator";
      // cpDry for steel: based on carbon steel, Polytechnisch zakboekje, E1/8
      parameter Modelica.SIunits.SpecificHeatCapacity cpDry=480
        "Specific heat capacity of the dry material, default is for steel";

      final parameter Real UA = QNom / ( (TInNom + TOutNom)/2 - TZoneNom)^n;

      Modelica.SIunits.HeatFlowRate QTotal(start=0)
        "Total heat emission of the radiator";
      Modelica.SIunits.TemperatureDifference dTRadRoo;

    protected
      parameter Modelica.SIunits.MassFlowRate mFlowNom=QNom/medium.cp/(TInNom -
          TOutNom) "nominal mass flowrate";

    equation
      dTRadRoo = max(0, TMean - heatPortConv.T);
      // mass balance
      flowPort_a.m_flow + flowPort_b.m_flow = 0;

      // no pressure drop
      flowPort_a.p = flowPort_b.p;

      // fixing temperatures
    algorithm
      if noEvent(flowPort_a.m_flow > mFlowNom/10) then
        TIn := flowPort_a.h/medium.cp;
        TOut := max(heatPortConv.T, 2*TMean - TIn);
      else
        TIn := TMean;
        TOut := TMean;
      end if;

    equation
      // radiator equation
      QTotal = - UA * (dTRadRoo)^n; // negative for heat emission!
      heatPortConv.Q_flow = QTotal * (1-fraRad);
      heatPortRad.Q_flow = QTotal * fraRad;

      // energy balance
      // the mass is lumped to TMean!  TOut can be DIFFERENT from TMean (when there is a flowrate)
      flowPort_a.H_flow + flowPort_b.H_flow + QTotal = (mMedium * medium.cp + mDry * cpDry) * der(TMean);

      // massflow a->b mixing rule at a, energy flow at b defined by medium's temperature
      // massflow b->a mixing rule at b, energy flow at a defined by medium's temperature
      flowPort_a.H_flow = semiLinear(flowPort_a.m_flow,flowPort_a.h,TOut * medium.cp);
      flowPort_b.H_flow = semiLinear(flowPort_b.m_flow,flowPort_b.h,TOut * medium.cp);
    annotation (Documentation(info="<HTML>
Partial model with two flowPorts.<br>
Possible heat exchange with the ambient is defined by Q_flow; setting this = 0 means no energy exchange.<br>
Setting parameter m (mass of medium within pipe) to zero
leads to neglection of temperature transient cv*m*der(T).<br>
Mixing rule is applied.<br>
Parameter 0 &lt; tapT &lt; 1 defines temperature of heatPort between medium's inlet and outlet temperature.
</HTML>"),     Icon(graphics={
            Rectangle(
              extent={{-92,46},{94,-50}},
              lineColor={0,0,255},
              fillColor={170,213,255},
              fillPattern=FillPattern.Solid),
            Line(
              points={{-60,38},{-60,-42}},
              color={0,0,255},
              thickness=0.5,
              smooth=Smooth.None),
            Line(
              points={{-40,38},{-40,-42}},
              color={0,0,255},
              thickness=0.5,
              smooth=Smooth.None),
            Line(
              points={{0,38},{0,-42}},
              color={0,0,255},
              thickness=0.5,
              smooth=Smooth.None),
            Line(
              points={{-20,38},{-20,-42}},
              color={0,0,255},
              thickness=0.5,
              smooth=Smooth.None),
            Line(
              points={{40,38},{40,-42}},
              color={0,0,255},
              thickness=0.5,
              smooth=Smooth.None),
            Line(
              points={{20,38},{20,-42}},
              color={0,0,255},
              thickness=0.5,
              smooth=Smooth.None),
            Line(
              points={{60,38},{60,-42}},
              color={0,0,255},
              thickness=0.5,
              smooth=Smooth.None)}));
    end Radiator;

    model EmbeddedPipe_prEN15377
      "Static embedded pipe model according to prEN 15377 and (Koschenz, 2000)"

      /*
  This model is identical to the norm prEN 15377 and corresponding background as developed in (Koschenz, 2000).  
  Nomenclature from EN 15377.
  
  ATTENTION: this model is problematic when there is no flowrate. Actually, I did not solve this issue so 
  do not use this model if the flowrate can become zero. 
  
  */

      extends
        IDEAS.Thermal.Components.Emission.Auxiliaries.Partial_EmbeddedPipe;

      // General model parameters ////////////////////////////////////////////////////////////////
      final parameter Modelica.SIunits.Length L_r=FHChars.A_Floor/FHChars.T
        "Length of the circuit";

      // Initialization ////////////////////////////////////////////////////////////////
      parameter Modelica.SIunits.Temperature TInitial=293.15
        "Initial temperature of the fluid";

      // Auxiliary parameters and variables ////////////////////////////////////////////////////////////////
      final parameter Modelica.SIunits.Mass mMedium=Modelica.Constants.pi/4*(
          FHChars.d_a - 2*FHChars.s_r)^2*L_r*medium.rho
        "Mass of the water in the tube";
      Modelica.SIunits.Temperature TMean(start=TInitial)
        "Mean radiator temperature";
      Modelica.SIunits.Temperature TIn(start=TInitial)
        "Temperature of medium inflow through flowPort_a";
      Modelica.SIunits.Temperature TOut(start=TInitial)
        "Temperature of medium outflow through flowPort_b";
      final parameter Real rey = m_flowMin * (FHChars.d_a - 2*FHChars.s_r) / (medium.nue * Modelica.Constants.pi / 4 * (FHChars.d_a - 2*FHChars.s_r)^2)
        "Fix Reynolds number for assert of turbulent flow";
      Real m_flowSp = flowPort_a.m_flow/FHChars.A_Floor "in kg/s.m²";
      Real m_flowMinSp = m_flowMin / FHChars.A_Floor "in kg/s.m²";
      Modelica.SIunits.Velocity flowSpeed=flowPort_a.m_flow/medium.rho/(Modelica.Constants.pi
          /4*(FHChars.d_a - 2*FHChars.s_r)^2);

      // Resistances ////////////////////////////////////////////////////////////////
      Modelica.SIunits.ThermalResistance R_z
        "Flowrate dependent thermal resistance of pipe length";
      Modelica.SIunits.ThermalInsulance R_w
        "Flow dependent resistance of convective heat transfer inside pipe, only valid if turbulent flow (see assert in initial equation)";
      final parameter Modelica.SIunits.ThermalInsulance R_r=FHChars.T*log(FHChars.d_a
          /(FHChars.d_a - 2*FHChars.s_r))/(2*Modelica.Constants.pi*FHChars.lambda_r)
        "Fix resistance of thermal conduction through pipe wall";
      final parameter Modelica.SIunits.ThermalInsulance R_x=(FHChars.T*log(
          FHChars.T/(3.14*FHChars.d_a)))/(2*3.14*FHChars.lambda_b)
        "Fix resistance of thermal conduction from pipe wall to layer";

        Modelica.Thermal.HeatTransfer.Components.ThermalConductor resistance_x(G=FHChars.A_Floor/R_x) annotation (Placement(
            transformation(
            extent={{10,10},{-10,-10}},
            rotation=180,
            origin={68,0})));
      Modelica.Thermal.HeatTransfer.Components.ThermalConductor resistance_r(G=FHChars.A_Floor/R_r)
        annotation (Placement(transformation(
            extent={{10,10},{-10,-10}},
            rotation=180,
            origin={34,0})));
      TME.VariableThermalConductor resistance_w
        annotation (Placement(transformation(
            extent={{10,10},{-10,-10}},
            rotation=180,
            origin={2,0})));
      Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature theta_v
        "Average temperature in the pipe" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-64,0})));

      TME.VariableThermalConductor resistance_z
        annotation (Placement(transformation(
            extent={{10,10},{-10,-10}},
            rotation=180,
            origin={-32,0})));

    // Equations and stuff ////////////////////////////////////////////////////////////////////////
    initial equation
      assert(FHChars.S_1 > 0.3 * FHChars.T, "Thickness of the concrete or screed layer above the tubes is smaller than 0.3 * the tube interdistance. 
    The model is not valid for this case");
      assert(FHChars.S_2 > 0.3 * FHChars.T, "Thickness of the concrete or screed layer under the tubes is smaller than 0.3 * the tube interdistance. 
    The model is not valid for this case");
      assert(rey > 2700, "The minimal flowrate leads to laminar flow.  Adapt the model (specifically R_w) to these conditions");
      assert(m_flowMinSp * medium.cp * (R_w + R_r + R_x) >= 0.5, "Model is not valid, division in n parts is required");

    algorithm
      if noEvent(abs(flowPort_a.m_flow) > m_flowMin/10) then
        TIn := flowPort_a.h/medium.cp;
        R_w :=FHChars.T^0.13/8/Modelica.Constants.pi*((FHChars.d_a - 2*FHChars.s_r)/
          (m_flowSp*L_r))^0.87;
        R_z := 1 / (2 * m_flowSp * medium.cp);
        // energy balance
        TOut :=TIn - (-theta_v.port.Q_flow/flowPort_a.m_flow/medium.cp);
        assert(noEvent(flowSpeed >= 0.05), "Attention, flowSpeed is smaller than 0.05 m/s");
        assert(noEvent(flowSpeed <= 0.5), "Attention, flowSpeed is larger than 0.5 m/s");
      else
        R_w := FHChars.T / (200 * (FHChars.d_a - 2*FHChars.s_r) * Modelica.Constants.pi);
        // R_z has to be a big value, because otherwise heat exchange will take place
        // based on TIn
        R_z := 1e10;
        TIn := 293.15;
        TOut := TIn;

      end if;

    equation
      theta_v.T = TIn;
      resistance_w.G = FHChars.A_Floor/R_w;
      resistance_z.G = FHChars.A_Floor/R_z;
      TMean = resistance_z.port_b.T;
      // mass balance: see partial
      flowPort_a.m_flow + flowPort_b.m_flow = 0;

      // no pressure drop
      flowPort_a.p = flowPort_b.p;

      // massflow a->b mixing rule at a, energy flow at b defined by medium's temperature
      // massflow b->a mixing rule at b, energy flow at a defined by medium's temperature
      flowPort_a.H_flow = semiLinear(flowPort_a.m_flow,flowPort_a.h,TOut * medium.cp);
      flowPort_b.H_flow = semiLinear(flowPort_b.m_flow,flowPort_b.h,TOut * medium.cp);

      connect(resistance_r.port_b,resistance_x. port_a) annotation (Line(
          points={{44,-1.22465e-015},{51,-1.22465e-015},{51,1.22465e-015},{58,
              1.22465e-015}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(resistance_w.port_b,resistance_r. port_a) annotation (Line(
          points={{12,-1.22465e-015},{18,-1.22465e-015},{18,1.22465e-015},{24,
              1.22465e-015}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(theta_v.port, resistance_z.port_a) annotation (Line(
          points={{-54,0},{-48,0},{-48,1.22465e-015},{-42,1.22465e-015}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(resistance_z.port_b, resistance_w.port_a) annotation (Line(
          points={{-22,-1.22465e-015},{-16,-1.22465e-015},{-16,1.22465e-015},{-8,
              1.22465e-015}},
          color={191,0,0},
          smooth=Smooth.None));

      connect(resistance_x.port_b, heatPortFH) annotation (Line(
          points={{78,-1.22465e-015},{82,-1.22465e-015},{82,0},{84,0},{84,52},{-86,
              52},{-86,100}},
          color={191,0,0},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end EmbeddedPipe_prEN15377;

    model EmbeddedPipeDynTOut
      "Embedded pipe model based on prEN 15377 and (Koschenz, 2000), water capacity lumped to TOut"

      extends
        IDEAS.Thermal.Components.Emission.Auxiliaries.Partial_EmbeddedPipe;

      /*
  This model is based on the norm prEN 15377 for the nomenclature but relies more on the 
  background as developed in (Koschenz, 2000).  
  There is one major deviation: instead of calculating R_z (to get the mean water temperature in the
  tube from the supply temperature and flowrate), this mean water temperatue is modelled specifically, 
  based on the mass of the water in the system.  
  
    
  Important remarks:
  - I did NOT model the resistance taking into account the tube length but explicitly simulate the mass of the water in the tube and the cooling down of the water in the tube (linear temperature profile).
  - I lump the water mass to TOut.  This seems to give the best results.  When lumping to TMean there are additional algebraic constraints to be imposed on 
    TOut which is not nice as for my applications, TOut is more important (influences efficiencies of heat pumps, storage stratification etc.)
  - my appraoch gives exactly the same results as the norm in both dynamic and static results, but is also able to cope with no-flow conditions
  - Configuration of the model can be tricky: the speed of the fluid (flowSpeed) is influencing the convective resistance (R_w) and therefore these 2 configurations are NOT the same:

        1. 10 m² of floor with 100 kg/h flowrate (m_flowSp = 10 kg/h/m²)
        2. 1 m² of floor heating with 10 kg/h flowrate (m_flowSp = 10 kg/h/m²)

  - Validation of the model is not evident with the data in Koschenz, 2000:

        * 4.5.1 is very strange: the results seem to be obtained with 1m² and 12 kg/h total flowrate, but this leads to very low flowSpeed value (although Reynolds number is still high?) and an alpha convection of only 144 W/m²K ==> I exclude this case explicitly with an assert statement on the flowSpeed
        * 4.6 is ok and I get exactly the same results, but this leads to extremely low supply temperatures in order to reach 20 W/m²
        * 4.5.2 not tested

  About the number of elements in the floor construction (see model Tabs): this seems to have an important impact on the results.  1 capacity above and below is clearly not enough.  No detailed sensitivity study made, but it seems that 3 capacities on each side were needed in my tests to get good results.
  
  
  */

      // General model parameters ////////////////////////////////////////////////////////////////
      // in partial: parameter SI.MassFlowRate m_flowMin "Minimal flowrate when in operation";
      final parameter Modelica.SIunits.Length L_r=FHChars.A_Floor/FHChars.T
        "Length of the circuit";

      // Resistances ////////////////////////////////////////////////////////////////
      // there is no R_z in the model because I explicitly simulate the dynamics of the water
      // SI.ThermalResistance R_z "Flowrate dependent thermal resistance of pipe length";
      Modelica.SIunits.ThermalInsulance R_w
        "Flow dependent resistance of convective heat transfer inside pipe, only valid if turbulent flow (see assert in initial equation)";
      //Real R_w_debug[2]={(FHChars.d_a - 2*FHChars.s_r), (m_flowSp * L_r)};
      final parameter Modelica.SIunits.ThermalInsulance R_r=FHChars.T*log(FHChars.d_a
          /(FHChars.d_a - 2*FHChars.s_r))/(2*Modelica.Constants.pi*FHChars.lambda_r)
        "Fix resistance of thermal conduction through pipe wall";
      final parameter Modelica.SIunits.ThermalInsulance R_x=(FHChars.T*log(
          FHChars.T/(3.14*FHChars.d_a)))/(2*3.14*FHChars.lambda_b)
        "Fix resistance of thermal conduction from pipe wall to layer";

      // Auxiliary parameters and variables ////////////////////////////////////////////////////////////////
      final parameter Modelica.SIunits.Mass mMedium=Modelica.Constants.pi/4*(
          FHChars.d_a - 2*FHChars.s_r)^2*L_r*medium.rho
        "Mass of the water in the tube";

      final parameter Real rey = m_flowMin * (FHChars.d_a - 2*FHChars.s_r) / (medium.nue * Modelica.Constants.pi / 4 * (FHChars.d_a - 2*FHChars.s_r)^2)
        "Fix Reynolds number for assert of turbulent flow";
      Real m_flowSp = flowPort_a.m_flow / FHChars.A_Floor "in kg/s.m²";
      Real m_flowMinSp = m_flowMin / FHChars.A_Floor "in kg/s.m²";
      Modelica.SIunits.Velocity flowSpeed=flowPort_a.m_flow/medium.rho/(Modelica.Constants.pi
          /4*(FHChars.d_a - 2*FHChars.s_r)^2);

      Modelica.Thermal.HeatTransfer.Components.ThermalConductor resistance_x(G = FHChars.A_Floor / R_x) annotation (Placement(
            transformation(
            extent={{10,10},{-10,-10}},
            rotation=180,
            origin={46,0})));
      Modelica.Thermal.HeatTransfer.Components.ThermalConductor resistance_r(G = FHChars.A_Floor / R_r)
        annotation (Placement(transformation(
            extent={{10,10},{-10,-10}},
            rotation=180,
            origin={12,0})));
      TME.VariableThermalConductor resistance_w
        annotation (Placement(transformation(
            extent={{10,10},{-10,-10}},
            rotation=180,
            origin={-20,0})));
      Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature theta_w
        "Average temperature in the pipe" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-54,0})));

    // Equations and stuff ////////////////////////////////////////////////////////////////////////
    initial equation
      assert(FHChars.S_1 > 0.3 * FHChars.T, "Thickness of the concrete or screed layer above the tubes is smaller than 0.3 * the tube interdistance. 
    The model is not valid for this case");
      assert(FHChars.S_2 > 0.3 * FHChars.T, "Thickness of the concrete or screed layer under the tubes is smaller than 0.3 * the tube interdistance. 
    The model is not valid for this case");
      assert(rey > 2700, "The minimal flowrate leads to laminar flow.  Adapt the model (specifically R_w) to these conditions");
      assert(m_flowMinSp * medium.cp * (R_w + R_r + R_x) >= 0.5, "Model is not valid, division in n parts is required");

    equation

    algorithm
      if noEvent(abs(flowPort_a.m_flow) > m_flowMin/10) then
        TIn := flowPort_a.h/medium.cp;
        TMean := (TIn + TOut)/2;
        R_w :=FHChars.T^0.13/8/Modelica.Constants.pi * abs(((FHChars.d_a - 2*FHChars.s_r)/
          (m_flowSp*L_r)))^0.87;
        //assert(noEvent(flowSpeed >= 0.05), "Attention, flowSpeed in the floorheating is smaller than 0.05 m/s");
        //assert(noEvent(flowSpeed <= 0.5), "Attention, flowSpeed in the floorheating is larger than 0.5 m/s");
      else
        TIn := TOut;
        TMean := TOut;
        R_w := FHChars.T / (200 * (FHChars.d_a - 2*FHChars.s_r) * Modelica.Constants.pi);
      end if;

    equation
      theta_w.T = TMean;
      resistance_w.G = FHChars.A_Floor/R_w;
      // mass balance
      flowPort_a.m_flow + flowPort_b.m_flow = 0;

      // no pressure drop
      flowPort_a.p = flowPort_b.p;

      // energy balance
      // the mass is lumped to TOut!  TOut will be DIFFERENT from TMean (when there is a flowrate)
      flowPort_a.H_flow + flowPort_b.H_flow + theta_w.port.Q_flow = mMedium * medium.cp * der(TOut);

      // massflow a->b mixing rule at a, energy flow at b defined by medium's temperature
      // massflow b->a mixing rule at b, energy flow at a defined by medium's temperature
      flowPort_a.H_flow = semiLinear(flowPort_a.m_flow,flowPort_a.h,TOut * medium.cp);
      flowPort_b.H_flow = semiLinear(flowPort_b.m_flow,flowPort_b.h,TOut * medium.cp);
      connect(resistance_r.port_b,resistance_x. port_a) annotation (Line(
          points={{22,-1.22465e-015},{29,-1.22465e-015},{29,1.22465e-015},{36,
              1.22465e-015}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(resistance_w.port_b,resistance_r. port_a) annotation (Line(
          points={{-10,-1.22465e-015},{-4,-1.22465e-015},{-4,1.22465e-015},{2,
              1.22465e-015}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(theta_w.port,resistance_w. port_a) annotation (Line(
          points={{-44,0},{-38,0},{-38,1.22465e-015},{-30,1.22465e-015}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(resistance_x.port_b, heatPortFH) annotation (Line(
          points={{56,-1.22465e-015},{62,-1.22465e-015},{62,62},{-86,62},{-86,100}},
          color={191,0,0},
          smooth=Smooth.None));

      annotation (Diagram(graphics));
    end EmbeddedPipeDynTOut;

    model EmbeddedPipeDynSwitch
      "Fully dynamic embedded pipe model (based on prEN 15377 and (Koschenz, 2000))"

      extends
        IDEAS.Thermal.Components.Emission.Auxiliaries.Partial_EmbeddedPipe;

      /*
  This model is based on the norm prEN 15377 for the nomenclature but relies more on the 
  background as developed in (Koschenz, 2000).  
  There is one major deviation: instead of calculating R_z (to get the mean water temperature in the
  tube from the supply temperature and flowrate), this mean water temperatue is modelled specifically, 
  based on the mass of the water in the system.  
  
    
  Important remarks:
  - I did NOT model the resistance taking into account the tube length but explicitly simulate the mass of the water in the tube and the cooling down of the water in the tube (linear temperature profile).
  - I lump the water mass to TOut.  This seems to give the best results.  When lumping to TMean there are additional algebraic constraints to be imposed on 
    TOut which is not nice as for my applications, TOut is more important (influences efficiencies of heat pumps, storage stratification etc.)
  - my appraoch gives exactly the same results as the norm in both dynamic and static results, but is also able to cope with no-flow conditions
  - Configuration of the model can be tricky: the speed of the fluid (flowSpeed) is influencing the convective resistance (R_w) and therefore these 2 configurations are NOT the same:

        1. 10 m² of floor with 100 kg/h flowrate (m_flowSp = 10 kg/h/m²)
        2. 1 m² of floor heating with 10 kg/h flowrate (m_flowSp = 10 kg/h/m²)

  - Validation of the model is not evident with the data in Koschenz, 2000:

        * 4.5.1 is very strange: the results seem to be obtained with 1m² and 12 kg/h total flowrate, but this leads to very low flowSpeed value (although Reynolds number is still high?) and an alpha convection of only 144 W/m²K ==> I exclude this case explicitly with an assert statement on the flowSpeed
        * 4.6 is ok and I get exactly the same results, but this leads to extremely low supply temperatures in order to reach 20 W/m²
        * 4.5.2 not tested

  About the number of elements in the floor construction (see model Tabs): this seems to have an important impact on the results.  1 capacity above and below is clearly not enough.  No detailed sensitivity study made, but it seems that 3 capacities on each side were needed in my tests to get good results.
  
  
  */

      // General model parameters ////////////////////////////////////////////////////////////////
      // in partial: parameter SI.MassFlowRate m_flowMin "Minimal flowrate when in operation";
      final parameter Modelica.SIunits.Length L_r=FHChars.A_Floor/FHChars.T
        "Length of the circuit";

      // Resistances ////////////////////////////////////////////////////////////////
      // there is no R_z in the model because I explicitly simulate the dynamics of the water
      // SI.ThermalResistance R_z "Flowrate dependent thermal resistance of pipe length";
      Modelica.SIunits.ThermalInsulance R_w
        "Flow dependent resistance of convective heat transfer inside pipe, only valid if turbulent flow (see assert in initial equation)";
      //Real R_w_debug[2]={(FHChars.d_a - 2*FHChars.s_r), (m_flowSp * L_r)};
      final parameter Modelica.SIunits.ThermalInsulance R_r=FHChars.T*log(FHChars.d_a
          /(FHChars.d_a - 2*FHChars.s_r))/(2*Modelica.Constants.pi*FHChars.lambda_r)
        "Fix resistance of thermal conduction through pipe wall";
      final parameter Modelica.SIunits.ThermalInsulance R_x=(FHChars.T*log(
          FHChars.T/(3.14*FHChars.d_a)))/(2*3.14*FHChars.lambda_b)
        "Fix resistance of thermal conduction from pipe wall to layer";

      // Auxiliary parameters and variables ////////////////////////////////////////////////////////////////
      final parameter Modelica.SIunits.Mass mMedium=Modelica.Constants.pi/4*(
          FHChars.d_a - 2*FHChars.s_r)^2*L_r*medium.rho
        "Mass of the water in the tube";
      final parameter Real rey = m_flowMin * (FHChars.d_a - 2*FHChars.s_r) / (medium.nue * Modelica.Constants.pi / 4 * (FHChars.d_a - 2*FHChars.s_r)^2)
        "Fix Reynolds number for assert of turbulent flow";
      Real m_flowSp = flowPort_a.m_flow / FHChars.A_Floor "in kg/s.m²";
      Real m_flowMinSp = m_flowMin / FHChars.A_Floor "in kg/s.m²";
      Modelica.SIunits.Velocity flowSpeed=flowPort_a.m_flow/medium.rho/(Modelica.Constants.pi
          /4*(FHChars.d_a - 2*FHChars.s_r)^2);
      // TMeanDyn is used for the situation without flowrate only!!
      Modelica.SIunits.Temperature TMeanDyn(start=TInitial)
        "Mean water temperature WITH lumped capacity";

      Modelica.Thermal.HeatTransfer.Components.ThermalConductor resistance_x(G = FHChars.A_Floor / R_x) annotation (Placement(
            transformation(
            extent={{10,10},{-10,-10}},
            rotation=180,
            origin={46,0})));
      Modelica.Thermal.HeatTransfer.Components.ThermalConductor resistance_r(G = FHChars.A_Floor / R_r)
        annotation (Placement(transformation(
            extent={{10,10},{-10,-10}},
            rotation=180,
            origin={12,0})));
      TME.VariableThermalConductor resistance_w
        annotation (Placement(transformation(
            extent={{10,10},{-10,-10}},
            rotation=180,
            origin={-20,0})));
      Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature theta_w
        "Average temperature in the pipe" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-54,0})));

    // Equations and stuff ////////////////////////////////////////////////////////////////////////
    initial equation
      assert(FHChars.S_1 > 0.3 * FHChars.T, "Thickness of the concrete or screed layer above the tubes is smaller than 0.3 * the tube interdistance. 
    The model is not valid for this case");
      assert(FHChars.S_2 > 0.3 * FHChars.T, "Thickness of the concrete or screed layer under the tubes is smaller than 0.3 * the tube interdistance. 
    The model is not valid for this case");
      assert(rey > 2700, "The minimal flowrate leads to laminar flow.  Adapt the model (specifically R_w) to these conditions");
      assert(m_flowMinSp * medium.cp * (R_w + R_r + R_x) >= 0.5, "Model is not valid, division in n parts is required");

    equation

    algorithm
      if (flowPort_a.m_flow > m_flowMin/2) then
        TIn := flowPort_a.h/medium.cp;
        TMean := (TIn + TOut)/2;
        R_w :=FHChars.T^0.13/8/Modelica.Constants.pi*((FHChars.d_a - 2*FHChars.s_r)/
          (m_flowSp*L_r))^0.87;
        //assert(noEvent(flowSpeed >= 0.05), "Attention, flowSpeed in the floorheating is smaller than 0.05 m/s");
        //assert(noEvent(flowSpeed <= 0.5), "Attention, flowSpeed in the floorheating is larger than 0.5 m/s");
      else
        TIn := TOut;
        TMean := TMeanDyn;
        R_w := FHChars.T / (200 * (FHChars.d_a - 2*FHChars.s_r) * Modelica.Constants.pi);
      end if;

    when flowPort_a.m_flow < m_flowMin/2 then
      reinit(TMeanDyn, pre(TMean));
    end when;

    when flowPort_a.m_flow > m_flowMin/2 then
      reinit(TOut, pre(TMeanDyn));
    end when;

    equation
      theta_w.T = TMean;
      resistance_w.G = FHChars.A_Floor/R_w;
      // mass balance
      flowPort_a.m_flow + flowPort_b.m_flow = 0;

      // no pressure drop
      flowPort_a.p = flowPort_b.p;

      // energy balance
      // the mass is lumped to TOut!  TOut will be DIFFERENT from TMean (when there is a flowrate)
      flowPort_a.H_flow + flowPort_b.H_flow + theta_w.port.Q_flow = mMedium * medium.cp * der(TOut);
      flowPort_a.H_flow + flowPort_b.H_flow + theta_w.port.Q_flow = mMedium * medium.cp * der(TMeanDyn);

      // massflow a->b mixing rule at a, energy flow at b defined by medium's temperature
      // massflow b->a mixing rule at b, energy flow at a defined by medium's temperature
      flowPort_a.H_flow = semiLinear(flowPort_a.m_flow,flowPort_a.h,TOut * medium.cp);
      flowPort_b.H_flow = semiLinear(flowPort_b.m_flow,flowPort_b.h,TOut * medium.cp);
      connect(resistance_r.port_b,resistance_x. port_a) annotation (Line(
          points={{22,-1.22465e-015},{29,-1.22465e-015},{29,1.22465e-015},{36,
              1.22465e-015}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(resistance_w.port_b,resistance_r. port_a) annotation (Line(
          points={{-10,-1.22465e-015},{-4,-1.22465e-015},{-4,1.22465e-015},{2,
              1.22465e-015}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(theta_w.port,resistance_w. port_a) annotation (Line(
          points={{-44,0},{-38,0},{-38,1.22465e-015},{-30,1.22465e-015}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(resistance_x.port_b, heatPortFH) annotation (Line(
          points={{56,-1.22465e-015},{62,-1.22465e-015},{62,62},{-86,62},{-86,100}},
          color={191,0,0},
          smooth=Smooth.None));

      annotation (Diagram(graphics));
    end EmbeddedPipeDynSwitch;
  end Emission;

package Storage

  extends Modelica.Icons.Package;

  model StorageTank "Simplified stratified storage tank"

    parameter TME.FHF.Interfaces.Medium
                                   medium=TME.FHF.Interfaces.Medium()
        "Medium in the tank";
    //Tank geometry and composition
    parameter Integer nbrNodes(min=1) = 5 "Number of nodes";
    parameter Modelica.SIunits.Volume volumeTank(min=0)
        "Total volume of the tank";
    parameter Modelica.SIunits.Length heightTank(min=0)
        "Total height of the tank";
    final parameter Modelica.SIunits.Mass mNode=volumeTank*medium.rho/nbrNodes
        "Mass of each node";
    parameter Modelica.SIunits.CoefficientOfHeatTransfer U(min=0)=0.4
        "Average heat loss coefficient per m² of tank surface";
    parameter Modelica.SIunits.Temperature[nbrNodes] TInitial={293.15 for i in
          1:nbrNodes} "Initial temperature of all Temperature states";
    parameter Boolean preventNaturalDestratification = true
        "if true, this automatically increases the insulation of the top layer";

    IDEAS.Thermal.Components.BaseClasses.HeatedPipe[
                                  nbrNodes] nodes(
      each medium = medium,
      each m = mNode,
      TInitial = TInitial) "Array of nodes";
    IDEAS.Thermal.Components.Interfaces.FlowPort_a
                                  flowPort_a(final medium=medium, h(min=1140947,
            max=1558647)) "Upper flowPort, connected to node[1]"
      annotation (Placement(transformation(extent={{-10,90},{10,110}})));
    IDEAS.Thermal.Components.Interfaces.FlowPort_b
                                  flowPort_b(final medium=medium, h(min=1140947,
            max=1558647)) "Lower flowPort, connected to node[nbrNodes]"
      annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
    IDEAS.Thermal.Components.Interfaces.FlowPort_a[
                                  nbrNodes + 1] flowPorts(each medium=medium,
          each h(min=1140947, max=1558647))
        "Array of nbrNodes+1 flowPorts. flowPorts[i] is connected to the upper flowPort of node i"
      annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatExchEnv
        "HeatPort for conduction between tank and environment"       annotation (
        Placement(transformation(extent={{52,-10},{72,10}}), iconTransformation(
            extent={{52,-10},{72,10}})));

    IDEAS.Thermal.Components.Storage.Buoyancy
                                buoancy(
      nbrNodes = nbrNodes,
      medium = medium,
      tau = 100,
      V = volumeTank)
        "Buoancy model to mix nodes in case of inversed temperature stratification";

  function areaCalculation
    input Modelica.SIunits.Volume volumeTank;
    input Modelica.SIunits.Length heightTank;
    input Integer nbrNodes;
    input Boolean pnd;
    output Modelica.SIunits.Area[nbrNodes] A
          "Array with (fictive) heat loss area for each node";
      protected
    final parameter Modelica.SIunits.Length dia=sqrt((4*volumeTank)/Modelica.Constants.pi
            /heightTank) "Tank diameter";
    final parameter Modelica.SIunits.Area areaLossSideNode=Modelica.Constants.pi
            *dia*heightTank/nbrNodes "Side area per node";
    final parameter Modelica.SIunits.Area areaLossBotTop=Modelica.Constants.pi*
            dia^2/4 "Top (and bottom) area";

  algorithm
    if nbrNodes == 1 then
      A[nbrNodes] := 2*areaLossBotTop + areaLossSideNode;
    elseif nbrNodes == 2 then
      A[1] := areaLossBotTop + areaLossSideNode;
      A[2] := areaLossBotTop + areaLossSideNode;
    else
      A := cat(1,{areaLossSideNode + areaLossBotTop}, {areaLossSideNode for i in 1:nbrNodes-2}, {areaLossSideNode + areaLossBotTop});
      if pnd then
        // we DECREASE the area of the top node in order NOT to let it cool down faster than the node just below.  This
        // is equivalent to increasing the insulation of the top node so the total losses in W/K are equal to the 2nd node.
        A[1] := 0.99*areaLossSideNode;
      end if;
    end if;
  end areaCalculation;

    protected
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor[nbrNodes] lossNodes(
      G = U * areaCalculation(volumeTank, heightTank, nbrNodes, preventNaturalDestratification))
        "Array of conduction loss components to the environment";

  equation
    // Connection of upper and lower node to external flowPorts
    connect(flowPort_a, nodes[1].flowPort_a);
    connect(flowPort_b,nodes[nbrNodes].flowPort_b);

    // Interconnection of nodes
    if nbrNodes > 1 then
      for i in 2:nbrNodes loop
        connect(nodes[i-1].flowPort_b, nodes[i].flowPort_a);
      end for;
    end if;

    // Connection of environmental heat losses to the nodes
    connect(lossNodes.port_a, nodes.heatPort);
    for i in 1:nbrNodes loop
      connect(heatExchEnv, lossNodes[i].port_b);
    end for;

    // Connection of flowPorts to the nodes
    connect(flowPorts[1:end-1], nodes.flowPort_a);
    connect(flowPorts[end], nodes[end].flowPort_b);

    // Connection of buoancy model
    connect(buoancy.heatPort, nodes.heatPort);
    annotation (Icon(graphics={
          Ellipse(extent={{-62,76},{60,52}}, lineColor={0,0,255}),
          Ellipse(extent={{-62,-46},{60,-70}}, lineColor={0,0,255}),
          Rectangle(extent={{-62,64},{60,-58}}, lineColor={0,0,255})}), Diagram(
          graphics));
  end StorageTank;

  model StratifiedInlet "Stratified inlet for a storage tank"

    /*
  Idea: the entering fluid flow is ENTIRELY injected between the nodes that have
  adjacent temperatures.
  In other words: the fluid seeks it's way to the nodes with most close temperature 
  in order to prevent destratification
  
  First version 20110629 by RDC
  
  */

    parameter TME.FHF.Interfaces.Medium
                                   medium=TME.FHF.Interfaces.Medium()
        "Medium in the component";
    parameter Integer nbrNodes(min=1) = 5 "Number of nodes in the tank";
    input Modelica.SIunits.Temperature[nbrNodes] TNodes
        "Temperature of the nodes in the tank";
      // it seems not possible to work with the enthalpies provided by flowPorts because they depend
      // on the flow direction in the tank...
    Modelica.SIunits.Temperature T(start=293.15)=flowPort_a.h/medium.cp
        "Inlet temperature";
    Integer inlet(start=0) "Number of the inlet node";

    IDEAS.Thermal.Components.Interfaces.FlowPort_a
                                  flowPort_a(medium=medium) "Inlet flowport"
      annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
    IDEAS.Thermal.Components.Interfaces.FlowPort_b[
                                  nbrNodes + 1] flowPorts(each medium=medium)
        "Array of outlet flowPorts"
      annotation (Placement(transformation(extent={{90,-10},{110,10}})));

    protected
    Integer testNode(start=0) "Node counter";

  algorithm
    inlet := 0;
    testNode := 1;
    while inlet == 0 loop
      if T > TNodes[testNode] then
        inlet := testNode;
      else
        inlet := 0;
      end if;

      testNode :=testNode + 1;

      if testNode == nbrNodes + 1 then
        // T is colder than the coldest (lowest) layer, inject between last and one-but-last
        inlet := nbrNodes;
      else
        inlet := inlet;
      end if;

    end while;

  equation
    flowPort_a.p = flowPorts[inlet].p;
    flowPort_a.H_flow = semiLinear(flowPort_a.m_flow, flowPort_a.h, flowPorts[inlet].h);

  for i in 1:nbrNodes+1 loop
    if i==inlet then
      flowPort_a.m_flow + flowPorts[i].m_flow = 0;
      flowPorts[i].H_flow = semiLinear(flowPorts[i].m_flow, flowPorts[i].h, flowPort_a.h);
    else
      flowPorts[i].m_flow = 0;
      flowPorts[i].H_flow = 0;
    end if;
  end for;

    annotation (Diagram(graphics));
  end StratifiedInlet;

  model Buoyancy
      "Model to add buoyancy if there is a temperature inversion in the tank"
    parameter TME.FHF.Interfaces.Medium medium=TME.FHF.Interfaces.Medium()
        "Medium in the tank";
    parameter Modelica.SIunits.Volume V "Total tank volume";
    parameter Integer nbrNodes(min=2) = 2 "Number of tank nodes";
    parameter Modelica.SIunits.Time tau(min=0) "Time constant for mixing";

    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nbrNodes] heatPort
        "Heat input into the volumes"
      annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));

    Modelica.SIunits.HeatFlowRate[nbrNodes-1] Q_flow
        "Heat flow rate from segment i+1 to i";
    protected
     parameter Real k(unit="W/K") = V*medium.rho*medium.cp/tau/nbrNodes
        "Proportionality constant, since we use dT instead of dH";
  equation
    for i in 1:nbrNodes-1 loop
      Q_flow[i] = k*max(heatPort[i+1].T-heatPort[i].T, 0);
    end for;

    heatPort[1].Q_flow = -Q_flow[1];
    for i in 2:nbrNodes-1 loop
         heatPort[i].Q_flow = -Q_flow[i]+Q_flow[i-1];
    end for;
    heatPort[nbrNodes].Q_flow = Q_flow[nbrNodes-1];
    annotation (Documentation(info="<html>
<p>
This model outputs a heat flow rate that can be added to fluid volumes
in order to emulate buoyancy during a temperature inversion.
For simplicity, this model does not compute a buoyancy induced mass flow rate,
but rather a heat flow that has the same magnitude as the enthalpy flow
associated with the buoyancy induced mass flow rate.
</p>
</html>",   revisions="<html>
<ul>
<li>
October 28, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
          graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-44,68},{36,28}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-42,-26},{38,-66}},
            lineColor={255,0,0},
            fillColor={255,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{26,10},{32,-22}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={255,0,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{28,22},{22,10},{36,10},{36,10},{28,22}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={255,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-32,22},{-26,-10}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-28,-18},{-36,-6},{-22,-6},{-22,-6},{-28,-18}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid)}),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
              100,100}}),
              graphics));
  end Buoyancy;
end Storage;

package Ventilation

  extends Modelica.Icons.Package;

end Ventilation;

  package VerticalGroundHeatExchanger
    "Vertical Ground/Brine heat exchanger resulting from master thesis of Harm Leenders, 2010-2011"

    package Examples
      model Example_Borehole "Most basic example/tester for a borehole "
        VerticalHeatExchangerModels.BoreHole boreHole
          annotation (Placement(transformation(extent={{2,-6},{-18,14}})));
        IDEAS.Thermal.Components.BaseClasses.HeatedPipe heatedPipe(
          medium=TME.FHF.Media.Water(),
          m=1,
          TInitial=277.15)
          annotation (Placement(transformation(extent={{-32,40},{-12,20}})));
        IDEAS.Thermal.Components.BaseClasses.Pump pump(
          medium=TME.FHF.Media.Water(),
          m=0,
          useInput=true,
          m_flowNom=0.5)
          annotation (Placement(transformation(extent={{-2,20},{18,40}})));
        Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
              277.15)
          annotation (Placement(transformation(extent={{-54,56},{-34,76}})));
        inner Commons.SimInfoManager sim(redeclare Commons.Meteo.Files.min60 detail,
            redeclare Commons.Meteo.Locations.Uccle city)
          annotation (Placement(transformation(extent={{-92,70},{-72,90}})));
        IDEAS.Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(p=300000)
          annotation (Placement(transformation(extent={{62,46},{82,66}})));
        Modelica.Blocks.Sources.Step step(startTime=20000)
          annotation (Placement(transformation(extent={{-18,72},{2,92}})));
      equation
        connect(heatedPipe.flowPort_b, pump.flowPort_a) annotation (Line(
            points={{-12,30},{-2,30}},
            color={255,0,0},
            smooth=Smooth.None));
        connect(fixedTemperature.port, heatedPipe.heatPort) annotation (Line(
            points={{-34,66},{-22,66},{-22,40}},
            color={191,0,0},
            smooth=Smooth.None));
        connect(absolutePressure.flowPort, pump.flowPort_b) annotation (Line(
            points={{62,56},{18,56},{18,30}},
            color={255,0,0},
            smooth=Smooth.None));
        connect(pump.flowPort_b, boreHole.flowPort_a) annotation (Line(
            points={{18,30},{20,30},{20,3.8},{1.8,3.8}},
            color={255,0,0},
            smooth=Smooth.None));
        connect(heatedPipe.flowPort_a, boreHole.flowPort_b) annotation (Line(
            points={{-32,30},{-46,30},{-46,4},{-17.8,4}},
            color={255,0,0},
            smooth=Smooth.None));
        connect(step.y, pump.m_flowSet) annotation (Line(
            points={{3,82},{8,82},{8,40}},
            color={0,0,127},
            smooth=Smooth.None));
        annotation (Diagram(graphics), Commands(file=
                "../../smartbuildings/TME/Scripts/Tester_Borehole.mos" "RunTest"));
      end Example_Borehole;
    end Examples;

    package EssentialCalculations

      function CalculateRadius "This function calculates the radiuspoints of the earth given the radius of the pipe, the borehole radius,
  the last radius and the number of intervals."
      input Real boreholeRadius "The radius of the borehole [m].";
      input Real outerRadius "The farest radius [m].";
      input Integer numberOfIntervals "The number of intervals [/].";
      // **************
      // OUTPUT
      // **************
      output Real radius[numberOfIntervals]
          "All the radius points of the model [m].";
      algorithm
        radius[1]:=boreholeRadius;
      for index in 2:numberOfIntervals loop
      radius[index] := radius[index-1] + (outerRadius-boreholeRadius)*(1-2)/(1-2^(numberOfIntervals-1))*2^(index-2);
      end for;
      // Based on page 178 Bianchi
      end CalculateRadius;

      function CalculateMassWeightedRadius
        "Calculates the masscentre of the radius with the given radius."
        // **********
        // This function calculates the mass weighted radius of the given array of radius.
        // The mass weigthed radius is the same as the inner weigthed radius.
        // **********
      // **************
      // INPUT
      // **************
          // The radius to calculate the mass weigthed radius of.
          input Modelica.SIunits.Radius radius[:];
      // **************
      // OUTPUT
      // **************
          output Modelica.SIunits.Radius weightedRadius[size(radius,1) - 1];
      algorithm
        for index in 1:size(radius,1) - 1 loop
          weightedRadius[index] :=  sqrt((radius[index+1]^2  + radius[index]^2)/2);
        end for;
        // Based on Bianchi Bianchi p 179. EWS-model takes middlepoint. This is the massgravitycentre?
        // Fault in Biahchi, minussign should be plus sign...
      end CalculateMassWeightedRadius;

      function CalculateWeightedOuterRadius
        "Calculates the weighted radius outwards the node."
        // **********
        // This function calculates the mass weigthed outer radius of the given array of radius and
        // the given weigthed radius.
        // **********
      // **************
      // INPUT
      // **************
          // The radius to calculate the mass weigthed radius of.
          input Modelica.SIunits.Radius radius[:];
          // The weigthed radius to calculated with.
          input Modelica.SIunits.Radius weightedRadius[:];
      // **************
      // OUTPUT
      // **************
          // The weigthed outer radius.
          output Modelica.SIunits.Radius weightedOuterRadius[size(radius,1)-1];
      algorithm
      for i in 1:size(weightedRadius,1)-1 loop
        weightedOuterRadius[i] := weightedRadius[i+1];
      end for;
      weightedOuterRadius[size(weightedOuterRadius,1)] := radius[size(radius,1)];
      end CalculateWeightedOuterRadius;
    end EssentialCalculations;

    package AdaptedFluid "A package containig adepted fluid classes."

      record Medium "Record containing media properties"
        extends Modelica.Icons.Record;
        parameter Modelica.SIunits.Density rho = 1 "Density";
        parameter Modelica.SIunits.SpecificHeatCapacity cp = 1
          "Specific heat capacity at constant pressure";
        parameter Modelica.SIunits.SpecificHeatCapacity cv = 1
          "Specific heat capacity at constant volume";
        parameter Modelica.SIunits.ThermalConductivity lamda = 0.615
          "Thermal conductivity";
        parameter Modelica.SIunits.KinematicViscosity nue= 0.8E-6
          "kinematic viscosity";
        annotation (Documentation(info="<html>
Record containing (constant) medium properties.
</html>"));
      end Medium;

      model TwoPort
        "FlowPort_a.m_flow is positive. It means, port_a is inwards en port_b is outwards. Made for a pipe"
      // **************
      // INPUT
      // **************
        // Medius of the twoport.
        parameter Medium medium;
        // Diameter of the pipe.
        parameter Modelica.SIunits.Radius diam = 0.08;
        // Length of the pipe.
        parameter Modelica.SIunits.Length len = 12.5;
        // Total mass in the pipe.
        parameter Modelica.SIunits.Mass m = medium.rho * diam^2*3.14 * len
          "Mass of medium";
        parameter Modelica.SIunits.Temperature T0(start=293.15, displayUnit="degC")
          "Initial temperature of medium";
              parameter Real tapT(final min=0, final max=1)=1
          "Defines temperature of heatPort between inlet and outlet temperature";
              Modelica.SIunits.Pressure dp=flowPort_a.p - flowPort_b.p
          "Pressure drop a->b";
              Modelica.SIunits.VolumeFlowRate V_flow=flowPort_a.m_flow/medium.rho
          "Volume flow a->b";
              Modelica.SIunits.HeatFlowRate Q_flow "Heat exchange with ambient";
              output Modelica.SIunits.Temperature T(start=T0)
          "Outlet temperature of medium";
              output Modelica.SIunits.Temperature T_a=flowPort_a.h/medium.cp
          "Temperature at flowPort_a";
              output Modelica.SIunits.Temperature T_b=flowPort_b.h/medium.cp
          "Temperature at flowPort_b";
              output Modelica.SIunits.TemperatureDifference dT=if noEvent(V_flow>=0) then T-T_a else T_b-T
          "Temperature increase of coolant in flow direction";
      protected
              Modelica.SIunits.SpecificEnthalpy h = medium.cp*T
          "Medium's specific enthalpy";
              Modelica.SIunits.Temperature T_q = T  - noEvent(sign(V_flow))*(1 - tapT)*dT
          "Temperature relevant for heat exchange with ambient";
      public
              Modelica.Thermal.FluidHeatFlow.Interfaces.FlowPort_a flowPort_a(final
            medium= medium)
                annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
                      rotation=0)));
              Modelica.Thermal.FluidHeatFlow.Interfaces.FlowPort_b flowPort_b(final
            medium= medium)
                annotation (Placement(transformation(extent={{90,-10},{110,10}},
                      rotation=0)));
      equation
              // mass balance
              flowPort_a.m_flow + flowPort_b.m_flow = 0;
              // energy balance
              flowPort_a.H_flow + flowPort_b.H_flow + Q_flow = m*medium.cv*der(T);
              // massflow a->b mixing rule at a, energy flow at b defined by medium's temperature
              // massflow b->a mixing rule at b, energy flow at a defined by medium's temperature
              flowPort_a.H_flow = semiLinear(flowPort_a.m_flow,flowPort_a.h,h);
              flowPort_b.H_flow = semiLinear(flowPort_b.m_flow,flowPort_b.h,h);
          annotation(__Dymola_choicesAllMatching=true);
      end TwoPort;

      connector FlowPort "conector flow port. Based on the library"
        parameter Medium medium "Medium in the connector";
        Modelica.SIunits.Pressure p "Pressure of the port";
        flow Modelica.SIunits.MassFlowRate m_flow(start=0.64)
          "The massflowrate";
        Modelica.SIunits.SpecificEnthalpy h "The specific enthalyp";
        flow Modelica.SIunits.EnthalpyFlowRate H_flow(start=77000)
          "enthalyp flow rate";
      annotation (Documentation(info="<HTML>
Basic definition of the connector.<br>
<b>Variables:</b>
<ul>
<li>Pressure p</li>
<li>flow MassFlowRate m_flow</li>
<li>Specific Enthalpy h</li>
<li>flow EnthaplyFlowRate H_flow</li>
</ul>
If ports with different media are connected, the simulation is asserted due to the check of parameter.
</HTML>"));
      end FlowPort;

      connector FlowPort_a "Filled flow port (used upstream)"
        extends FlowPort;
      annotation (Documentation(info="<HTML>
Same as FlowPort, but icon allows to differentiate direction of flow.
</HTML>"),
        Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                  100}}), graphics),           Diagram(coordinateSystem(
                preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
              graphics));
      end FlowPort_a;

      connector FlowPort_b "Hollow flow port (used downstream)"
        extends FlowPort;
      annotation (Documentation(info="<HTML>
Same as FlowPort, but icon allows to differentiate direction of flow.
</HTML>"),
        Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                  100}}), graphics),           Diagram(coordinateSystem(
                preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
              graphics));
      end FlowPort_b;

      partial model SimpleFriction "Simple friction model"
      // Vflow moet positief zijn!
        //****
        // Formula's for pressure should be checked!
        //****
        parameter Medium medium2;

        parameter Modelica.SIunits.Length L = 10 "Friction length";
        parameter Modelica.SIunits.Radius Rad = 0.08 "Radius friction";
        parameter Modelica.SIunits.Area A= ( Modelica.Constants.pi*(Rad)^2)
          "Area of friction";
        parameter Modelica.SIunits.VolumeFlowRate V_flowLaminar = 2300*medium2.nue/(Rad*2)
          "Laminar flow";
        parameter Modelica.SIunits.Pressure dpLaminar = medium2.rho*(64/2300)*(L/(Rad*2))/2*(V_flowLaminar/A)^2
          "Laminar pressure drop";
        parameter Modelica.SIunits.VolumeFlowRate V_flowNominal= 0.003/A
          "Nominal flow";
        parameter Modelica.SIunits.Pressure dpNominal(start=1)= medium2.rho*Modelica.Constants.g_n*frictionLoss*(L/(Rad*2))*((V_flowNominal/A)^2)/2;
        parameter Real frictionLoss = 0.04 "Can be everyting ranging 0-1";
        parameter Modelica.SIunits.Pressure dpNomMin=dpLaminar/V_flowLaminar*V_flowNominal;
        Modelica.SIunits.Pressure pressureDrop(start=140);
        Modelica.SIunits.VolumeFlowRate volumeFlow(start=0.00064);
        Modelica.SIunits.Power Q_friction(start=0);
      equation
        pressureDrop =  dpLaminar/V_flowLaminar*volumeFlow;
        Q_friction = frictionLoss*volumeFlow*pressureDrop;
      end SimpleFriction;

      model HeatedPipe "Pipe with heat exchange"
        extends TwoPort;
        extends SimpleFriction;
        parameter Modelica.SIunits.Length h_g = 10;
        Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort;
      equation
            // coupling with FrictionModel
            volumeFlow = V_flow;
            dp = pressureDrop + medium.rho*Modelica.Constants.g_n*h_g;
            // energy exchange with medium
            // defines heatPort's temperature
            // heatPort.T = T_q;
            heatPort.Q_flow = Q_flow + Q_friction;
            heatPort.T = T_q;
            // defines heatPort's temperature
      end HeatedPipe;
    end AdaptedFluid;

    package Earth "Contains the earth related models."

      record RecordEarthLayer
      // **************
      // This record contains all the parameters concerning the earth.
      // **************
      // This represents the radius of the earth.
      parameter Modelica.SIunits.Length depthOfEarth= 10;
      // This represents the 1/numberOfVerticalBottumLayers of the total depth of the earth beneath (m)
      parameter Modelica.SIunits.Length depthOfEarthUnder = 10;
      // This is the density of the earth (kg/m³)
      parameter Modelica.SIunits.Density densityEarth= 1600;
      // This represents the radius of the earth.
      parameter Modelica.SIunits.Radius radius[numberOfHorizontalNodes];
      // This is the thermal conductivity of the earth (T)
      parameter Modelica.SIunits.ThermalConductivity lambda= 1.3;
      // This is the specific heat capacity of the earth (J/(kg.K))
      parameter Modelica.SIunits.SpecificHeatCapacity heatCapacitanceEarth= 850;
      // This is the start temperature of the earth (K)
      parameter Modelica.SIunits.Temperature startTemperature = 283;
      // This is the temperature of the earth (K) of the undisturbed ground.
      parameter Modelica.SIunits.Temperature endTemperature = 283;
      // This is the temperature on top of the earth (K)
      parameter Modelica.SIunits.Temperature outSideTemperature = 288;
      // This parameter represents the number of vertical layers you want to divide the soil underneath the borehole.
      parameter Integer numberOfVerticalBottumLayers = 11;
      // This number represents the number of horizontalnodes outside the borehole.
      parameter Integer numberOfHorizontalNodes = 17;
      // This paramter represents the temperature gradient per meter in the earth (K/m)
      parameter Real gradient = 0.15/100;
      // This is the total depth.
      parameter Real totalDepth = 120;
      // This is the total depth of the block beneath the earth containing the borehole.
      parameter Real metersOfEarthBlock = 20;
      // This is the temperature on the bottum of the earth.
      parameter Real bottumTemperature = 45;
      end RecordEarthLayer;

      function CalculateEarthCapacities
      // **************
      // This function calculates an array of capacities..
      // **************
      // **************
      // INPUT
      // **************
      // This represents the 1/10 of the total depth of the borehole (m)
      input Modelica.SIunits.Length depthOfEarth[:];
      // This is the specific heat capacity of the earth (J/(kg.K))
      input Modelica.SIunits.SpecificHeatCapacity heatCapacitanceEarth[:];
      // This is the density of the earth (kg/m³)
      input Modelica.SIunits.Density densityEarth[:];
      // This is the inner radius of the ring (m)
      input Modelica.SIunits.Radius innerRadius[:];
      // This is outer radius of the ring (m)
      input Modelica.SIunits.Radius outerRadius[:];
      // **************
      // OUTPUT
      // **************
      // The heatcapacity of the earth (J/K)
      output Modelica.SIunits.HeatCapacity capacity[size(depthOfEarth,1)];
      algorithm
        for index in 1:size(depthOfEarth,1) loop
      capacity[index] := Modelica.Constants.pi*depthOfEarth[index]*densityEarth[index]*heatCapacitanceEarth[index]*(outerRadius[index]^2-innerRadius[index]^2);
      end for;
      end CalculateEarthCapacities;

      function CalculateEarthResistors
      // **************
      // This function calculates an array of thermal conductances.
      // **************
      // This represents the 1/10 of the total depth of the borehole (m)
      input Modelica.SIunits.Length depthOfEarth[:];
      // This is the thermal conductivity of the earth (T)
      input Modelica.SIunits.ThermalConductivity lambda[:];
      // This is the weighted inner radius of the ring (m)
      input Modelica.SIunits.Radius weightedInnerRadius[:];
      // This is the weighted outer radius of the ring (m)
      input Modelica.SIunits.Radius weightedOuterRadius[:];
      // This is radius
      input Modelica.SIunits.Radius radius[:];
      // **************
      // OUTPUT
      // **************
      // This is the thermal conductance (W/K)
      output Modelica.SIunits.ThermalResistance thermalResistance[size(depthOfEarth,1)];
      algorithm
      for index in 1:size(depthOfEarth,1) loop
      thermalResistance[index] := Modelica.Math.log(weightedOuterRadius[index]/weightedInnerRadius[index])/(depthOfEarth[index]*Modelica.Constants.pi*2*lambda[index]);
      end for;
      end CalculateEarthResistors;

      function CalculateContactResistanceEarthSideFilling
      // **************
      // This function calculates the thermal conductance of the contact resistor between the
      // filling material and the earth given the depth of earth, the thermal diffusivity of the filling material,
      // the thermal conductivity of the earth, the radius of the pipe,
      // the radius of the borehole and the first radius of the earth.
      // **************
      // **************
      // INPUT
      // **************
      // This represents the 1/10 of the total depth of the borehole (m)
      input Modelica.SIunits.Length depthOfEarth;
      // This is the thermal conductivity of the earth
      input Modelica.SIunits.ThermalConductivity lambdaEarth;
      // This is the radius of the borehole.
      input Modelica.SIunits.Radius radiusBorehole;
      // The first radius of the earth.
      input Modelica.SIunits.Radius firstRadiusEarth;
      // **************
      // OUTPUT
      // **************
      // This is the thermal conductance (W/K)
      output Modelica.SIunits.ThermalResistance thermalResistance;
      // Otherwise Jmodelica isn't running..
      protected
      Modelica.SIunits.Radius weightedRadius =  sqrt((firstRadiusEarth^2 + radiusBorehole^2)/2);
      algorithm
      // This parameter represents the weighted outer radius.
      weightedRadius := sqrt((firstRadiusEarth^2 + radiusBorehole^2)/2);
      thermalResistance := Modelica.Math.log(weightedRadius/radiusBorehole)/(depthOfEarth*Modelica.Constants.pi*2*lambdaEarth);
      end CalculateContactResistanceEarthSideFilling;

      function ConstructArray
        // Constructs an array with the necessairy givens for creating a BlockEartLayer
      // The radius of the pipe.
      input Modelica.SIunits.Radius radiusPipe;
      input Modelica.SIunits.Radius[:] radius;
      input Integer size;
      // **************
      // OUTPUT
      // **************
      // All the radius points of the model.
      output Real totalRadius[size];
      algorithm
        totalRadius[1]:=0;
        totalRadius[2]:= radiusPipe;
      for index in 3:size loop
      totalRadius[index] := radius[index-2];
      end for;
      end ConstructArray;

      function CalculateThermalResistanceBlock
      // **************
      // This function calculates an array of thermal conductances.
      // **************
      // This represents the 1/10 of the total depth of the borehole (m)
      input Modelica.SIunits.Length depthOfEarth[:];
      // This is the thermal conductivity of the earth (T)
      input Modelica.SIunits.ThermalConductivity lambda[:];
      // This is the weighted inner radius of the ring (m)
      input Modelica.SIunits.Radius weightedInnerRadius[:];
      // This is the weighted outer radius of the ring (m)
      input Modelica.SIunits.Radius weightedOuterRadius[:];
      input Modelica.SIunits.Radius radiusPipe;
      input Modelica.SIunits.Radius radiusBorehole;
      // **************
      // OUTPUT
      // **************
      // This is the thermal conductance (W/K)
      output Modelica.SIunits.ThermalResistance thermalResistance[size(depthOfEarth,1)+3];
      algorithm
      thermalResistance[1] := 1/(lambda[1]*radiusPipe*2*Modelica.Constants.pi);
      thermalResistance[2] := Modelica.Math.log(radiusBorehole/sqrt((radiusBorehole^2 + radiusPipe^2)/2))/(depthOfEarth[1]*Modelica.Constants.pi*2*lambda[1]);
      thermalResistance[3] := Modelica.Math.log(weightedInnerRadius[1]/radiusBorehole)/(depthOfEarth[1]*Modelica.Constants.pi*2*lambda[1]);
      for index in 1:size(depthOfEarth,1) loop
      thermalResistance[index+3] :=
      Modelica.Math.log(weightedOuterRadius[index]/weightedInnerRadius[index])/(depthOfEarth[index]*Modelica.Constants.pi*2*lambda[index]);
      end for;
      end CalculateThermalResistanceBlock;

      function CalculateEarthCapacitiesBlock
      // **************
      // This function calculates an array of capacities..
      // **************
      // **************
      // INPUT
      // **************
      // This represents the 1/10 of the total depth of the borehole (m)
      input Modelica.SIunits.Length depthOfEarth[:];
      // This is the specific heat capacity of the earth (J/(kg.K))
      input Modelica.SIunits.SpecificHeatCapacity heatCapacitanceEarth[:];
      // This is the density of the earth (kg/m³)
      input Modelica.SIunits.Density densityEarth[:];
      // This is the inner radius of the ring (m)
      input Modelica.SIunits.Radius innerRadius[:];
      // This is outer radius of the ring (m)
      input Modelica.SIunits.Radius outerRadius[:];
      input Modelica.SIunits.Radius radiusPipe;
      // **************
      // OUTPUT
      // **************
      // The heatcapacity of the earth (J/K)
      output Modelica.SIunits.HeatCapacity capacity[size(depthOfEarth,1)+2];
      algorithm
      capacity[1] := Modelica.Constants.pi*depthOfEarth[1]*densityEarth[1]*heatCapacitanceEarth[1]*radiusPipe^2;
      capacity[2] := Modelica.Constants.pi*depthOfEarth[1]*densityEarth[1]*heatCapacitanceEarth[1]*(innerRadius[1]^2-radiusPipe^2);
        for index in 1:size(depthOfEarth,1) loop
      capacity[index+2] := Modelica.Constants.pi*depthOfEarth[index]*densityEarth[index]*heatCapacitanceEarth[index]*(outerRadius[index]^2-innerRadius[index]^2);
      end for;
      end CalculateEarthCapacitiesBlock;

      function CalculateQ
        "This function calculates the heatflow in a cilinder, given the heatflow per square and the radius of the cilinder."
      input Real QperSquare "Heatflow per square";
      input Real[:] radias "Radia to calculate with";
      input Integer size;
      output Real[size] Q;
      algorithm
        for index in 1:size loop
          Q[index] :=QperSquare*Modelica.Constants.pi*(radias[index + 1]^2 - radias[index]^2);
        end for;
      end CalculateQ;

      function CalculateEarthResistance
      input Modelica.SIunits.Length depthOfEarth;
      // This is the thermal conductivity of the earth (T)
      input Modelica.SIunits.ThermalConductivity lambda;
      // This is the weighted inner radius of the ring (m)
      input Modelica.SIunits.Radius outerRadius;
      // This is the weighted outer radius of the ring (m)
      input Modelica.SIunits.Radius innerRadius;
      // **************
      // OUTPUT
      // **************
      // This is the thermal conductance (W/K)
      output Modelica.SIunits.ThermalResistance thermalResistance;
      algorithm
      thermalResistance := if innerRadius == 0 then 1/(lambda*outerRadius*2*Modelica.Constants.pi) else Modelica.Math.log(outerRadius/innerRadius)/(depthOfEarth*Modelica.Constants.pi*2*lambda);
      end CalculateEarthResistance;

      function CalculateEarthCapacitie
      // **************
      // This function calculates an array of capacities..
      // **************
      // **************
      // INPUT
      // **************
      // This represents the 1/10 of the total depth of the borehole (m)
      input Modelica.SIunits.Length depthOfEarth;
      // This is the specific heat capacity of the earth (J/(kg.K))
      input Modelica.SIunits.SpecificHeatCapacity heatCapacitanceEarth;
      // This is the density of the earth (kg/m³)
      input Modelica.SIunits.Density densityEarth;
      // This is the inner radius of the ring (m)
      input Modelica.SIunits.Radius innerRadius;
      // This is outer radius of the ring (m)
      input Modelica.SIunits.Radius outerRadius;
      // **************
      // OUTPUT
      // **************
      // The heatcapacity of the earth (J/K)
      output Modelica.SIunits.HeatCapacity capacity;
      algorithm
      capacity := Modelica.Constants.pi*depthOfEarth*densityEarth*heatCapacitanceEarth*(outerRadius^2-innerRadius^2);
      end CalculateEarthCapacitie;

      model EarthCapacitor
      // **************
      // This model represents a earth capacitor with a given start temperature and a given capaicty.
      // **************
            // **************
            // * parameters *
            // **************
                  // The start temperature of the capacitor (K)
                 parameter Modelica.SIunits.Temperature startTemperature=288;
                  // The heat capacity of the capacitor (J/K)
                  parameter Modelica.SIunits.HeatCapacity capacity=500;
            // **************
            // * Variables *
            // **************
                  // The temperature of the capacitor (K)
                  Modelica.SIunits.Temperature temperature(start=startTemperature);
                  // The connection port of the capacitor
                  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a portA;
      //Real energy(start=0);
      equation
        temperature = portA.T;
        capacity*der(temperature) = portA.Q_flow;
      // energy = (startTemperature - portA.T)*capacity;
      end EarthCapacitor;

      model EarthResistor
      extends Modelica.Thermal.HeatTransfer.Components.ThermalConductor(G=1/thermalResistance);
      // **************
      // This model represents a earth resistor with a given thermal conductance.
      // **************
            // **************
            // * parameters *
            // **************
                // The thermal conductance (W/K)
                parameter Modelica.SIunits.ThermalResistance thermalResistance = 0.125;
                //parameter Modelica.SIunits.Temperature startTemperature=280;
      end EarthResistor;

      model CalculateResistors
      // **************
      // This model calculates every thermal conductance of the different rings, given its depth,
      // the radius of the meshed earth, the thermal counductivity of the earth.
      // **************
            // **************
            // * parameters *
            // **************
                // This represents the 1/10 of the total depth of the borehole (m)
                parameter Modelica.SIunits.Length depthOfEarth=10;
                // The points of the radius of the mesh of the earth.
                parameter Modelica.SIunits.Radius radius[:];
                // The thermal Conductivity.
                parameter Modelica.SIunits.ThermalConductivity lambda=0.1;
                // Here we calculate the innerWeigthedRadius, given the radius. (the weighted radius = the weighted inner radius)
                parameter Modelica.SIunits.Radius[size(radius,1)-1]
          weightedRadius =                                                           EssentialCalculations.CalculateMassWeightedRadius(                      radius);
                // Here we calculate the outerWeigthedRadius, given the radius.
                parameter Modelica.SIunits.Radius[size(radius,1)-1]
          weightedOuterRadius =                                                           EssentialCalculations.CalculateWeightedOuterRadius(                      radius, weightedRadius);
                // Here we calculate the thermal conductance.
                parameter Modelica.SIunits.ThermalResistance[size(radius,1)-1]
          thermalResistance =           CalculateEarthResistors(
                      fill(depthOfEarth,size(radius,1)-1),
                      fill(lambda,size(radius,1)-1),
                      weightedRadius,
                      weightedOuterRadius,
                      radius);
      end CalculateResistors;

      model CalculateCapacitors
      // **************
      // This model calculates every heat capacity of the different rings, given its depth,
      // the radius of the meshed earth, the density of the earth, the specific heat capacitance.
      // **************
            // **************
            // * parameters *
            // **************
                // The points of the radius of the mesh of the earth.
                parameter Modelica.SIunits.Radius radius[:];
                // This represents the 1/10 of the total depth of the borehole (m)
                parameter Modelica.SIunits.Length depthOfEarth=10;
                // This is the density of the earth.
                parameter Modelica.SIunits.Density densityEarth=1600;
                // This is the heat capacitance of the earth.
                parameter Modelica.SIunits.SpecificHeatCapacity
          heatCapacitanceEarth =                                                     10;
                // Here we calculate the different capacities.
                parameter Modelica.SIunits.HeatCapacity capacities[size(radius,1)-1] = CalculateEarthCapacities(
                fill(depthOfEarth,size(radius,1)-1),
                fill(heatCapacitanceEarth,size(radius,1)-1),
                fill(densityEarth,size(radius,1)-1),
                radius[1:size(radius,1)-1],
                radius[2:size(radius,1)]);
      end CalculateCapacitors;

      model EarthLayer
      // **************
      // This model generates a connection between different earthrings.
      // The connection of earthrings defines a layer in the earth.
      // The parameters for generating are given in the recordEarthLayer.
      // Port_a is directed towards the borehole. port_b is directed opposited of port_a.
      // **************
            // **************
            // * parameters *
            // **************
            // This record contains all the parameters concerning the earth.
            parameter RecordEarthLayer recordEarthLayer;
            // The number of the layer
            parameter Real numberOfLayer;
            // The temperature difference to the bottom
            parameter Real differenceToBottum= recordEarthLayer.totalDepth - recordEarthLayer.depthOfEarth*(numberOfLayer - 1/2);
            parameter Real offset = 0;
            // **************
            // * Variables *
            // **************
            // Define all the earth resistors.

          // The rings of the earth.
      public
          Earthring[recordEarthLayer.numberOfHorizontalNodes - 1] earthRings(
          each recordEarthLayer=recordEarthLayer,
          innerRadius=recordEarthLayer.radius[1:(size(recordEarthLayer.radius, 1) - 1)],

          outerRadius=recordEarthLayer.radius[2:(size(recordEarthLayer.radius,
              1))],
          each startTemperature=-recordEarthLayer.gradient*differenceToBottum
               + recordEarthLayer.bottumTemperature);

           // boundary condition
            Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow = 0);
      equation
        // Connect every ring
             for index in 1:(size(earthRings,1)-1) loop
                connect(earthRings[index].earthResistorOutWard.port_b,earthRings[index+1].earthResistorInWard.port_a);
             end for;

             // connect the boundary condition
             connect(earthRings[size(earthRings,1)].earthResistorOutWard.port_b, fixedHeatFlow.port);
      end EarthLayer;

      model ContactResistanceEarthSideFilling
      // **************
      // This model represents a contact resistor between the earth and the filling material.
      // The thermal conductance is calculated with the parameters given in the record of the contactResistance.
      // **************
            // **************
            // * parameters *
            // **************
                // This record contains the essential information for calculating the thermal conductance.
                parameter RecordEarthLayer recordEarthLayer;
                // The thermal conductance (W/K) is calculated with the given information in recordContactResistanceEarthBoreHole
                parameter Modelica.SIunits.ThermalResistance thermalResistance = CalculateContactResistanceEarthSideFilling(
                recordEarthLayer.depthOfEarth,
                recordEarthLayer.lambda,
                recordEarthLayer.radius[1],
                recordEarthLayer.radius[2]);
            // **************
            // * variables *
            // **************
                // The inputport
                Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a;
                // The outputport
                Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b;
      equation
      thermalResistance*port_a.Q_flow = (port_a.T - port_b.T);
      port_a.Q_flow = -port_b.Q_flow;
      end ContactResistanceEarthSideFilling;

      model BlockEarthLayer
        "This model represents the earht below the borehole."
           // **************
            // * parameters *
            // **************
            // This record contains all the parameters concerning the earth.
            parameter RecordEarthLayer recordEarthLayer;
            // Radius of the pipe.
            parameter Modelica.SIunits.Radius radiusPipe;
            // Radius of the borehole
            parameter Modelica.SIunits.Radius radiusBorehole = recordEarthLayer.radius[1];
            // All gridpoints.
            parameter Real[size(recordEarthLayer.radius,1)+2] radia = ConstructArray( radiusPipe,recordEarthLayer.radius,size(recordEarthLayer.radius,1)+2);
            // All inner radia
            parameter Real[size(recordEarthLayer.radius,1)+1] innerRadius = radia[1:size(recordEarthLayer.radius,1)+1];
            // All outer radia
            parameter Real[size(recordEarthLayer.radius,1)+1] outerRadius = radia[2:size(recordEarthLayer.radius,1)+2];
            parameter Real numberOfLayer = 1;
            parameter Real differenceToBottum= recordEarthLayer.metersOfEarthBlock - recordEarthLayer.depthOfEarthUnder*(numberOfLayer - 1/2);
           // All earthrings below bottum

            parameter Integer numberOfEarthRings = size(recordEarthLayer.radius,1)+1;
      public
            EarthringUnder[size(recordEarthLayer.radius, 1) + 1] earthRings(
          each recordEarthLayer=recordEarthLayer,
          innerRadius=innerRadius,
          outerRadius=outerRadius,
          each startTemperature=-recordEarthLayer.gradient*differenceToBottum +
              recordEarthLayer.bottumTemperature);

            // Fixed heatflow (boundary)
            Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedTemperature(  Q_flow=0);
            // Fixed heatflow (boundary)
            Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedFlow(Q_flow=0);

            // Help Variable
            Real getLeftBoundaryTemperature;
      equation

            // Connect boundary condition
            connect(earthRings[1].earthResistorInWard.port_a, fixedFlow.port);

            // Connect help variable
            getLeftBoundaryTemperature = fixedFlow.port.T;

            // Connect every earthring
             for index in 1:(size(earthRings,1)-1) loop
                connect(earthRings[index].earthResistorOutWard.port_b,earthRings[index+1].earthResistorInWard.port_a);
             end for;

             // Connect boundary
             connect(earthRings[size(earthRings,1)].earthResistorOutWard.port_b, fixedTemperature.port);
      end BlockEarthLayer;

      model BlockEarth
            // This record contains all the parameters concerning the earth.
            parameter RecordEarthLayer recordEarthLayer;
            // Radius of a pipe.
            parameter Modelica.SIunits.Radius radiusPipe = 0.025;
      // Layers beneath the borehole.
      parameter Integer layers = recordEarthLayer.numberOfVerticalBottumLayers;
      // The layers in the block beneath the borehole.
      BlockEarthLayer[layers] blockEarthLayer(
          each recordEarthLayer=recordEarthLayer,
          each radiusPipe=radiusPipe,
          numberOfLayer=1:recordEarthLayer.numberOfVerticalBottumLayers);
      //UNCOMMENT VOOR FLUX ONDERAAN
      // The fixed temperature beneath downwards.
        Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow[size(blockEarthLayer[1].earthRings,1)]
          earthFlux(   Q_flow=CalculateQ(0.040,radia,size(recordEarthLayer.radius,1)+1));
      Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow[size(blockEarthLayer[1].earthRings,1)]
          fixedFlows(each Q_flow = 0);
      parameter Real[size(recordEarthLayer.radius,1)+2] radia = ConstructArray(               radiusPipe,recordEarthLayer.radius,size(recordEarthLayer.radius,1)+2);
      equation
              // Connect the layers in between.
             for index in 1:layers-1 loop
                for index2 in 1:size(blockEarthLayer[1].earthRings,1) loop
                    connect(blockEarthLayer[index].earthRings[index2].verticalResistorDown.port_b,blockEarthLayer[index+1].earthRings[index2].verticalResistorUp.port_a);
                end for;
             // Connect the bottum layer with the fixed tempeartues.
             end for;
             for index in 1:size(blockEarthLayer[1].earthRings,1) loop
                    connect(blockEarthLayer[layers].earthRings[index].verticalResistorDown.port_b,fixedFlows[index].port);
             end for;
      //UNCOMMENT VOOR FLUX ONDERAAN
               for index in 1:size(blockEarthLayer[1].earthRings,1) loop
                      connect(blockEarthLayer[layers].earthRings[index].verticalResistorDown.port_a,earthFlux[index].port);
               end for;
      end BlockEarth;

      model CalculateResistorsBlock
      // **************
      // This model calculates every thermal conductance of the different rings, given its depth,
      // the radius of the meshed earth, the thermal counductivity of the earth for the block underneath the borehole.
      // **************
            // **************
            // * parameters *
            // **************
                // This represents the 1/10 of the total depth of the borehole (m)
                parameter Modelica.SIunits.Radius radiusPipe;
                parameter Modelica.SIunits.Radius radiusBorehole;
                parameter Modelica.SIunits.Length depthOfEarth=10;
                // The points of the radius of the mesh of the earth.
                parameter Modelica.SIunits.Radius radius[:];
                // The thermal Conductivity.
                parameter Modelica.SIunits.ThermalConductivity lambda=0.1;
                // Here we calculate the innerWeigthedRadius, given the radius. (the weighted radius = the weighted inner radius)
                parameter Modelica.SIunits.Radius[size(radius,1)-1]
          weightedRadius =                                                           EssentialCalculations.CalculateMassWeightedRadius(                      radius);
                // Here we calculate the outerWeigthedRadius, given the radius.
                parameter Modelica.SIunits.Radius[size(radius,1)-1]
          weightedOuterRadius =                                                           EssentialCalculations.CalculateWeightedOuterRadius(                      radius, weightedRadius);
                // Here we calculate the thermal conductance.
                parameter Modelica.SIunits.ThermalResistance[size(radius,1)+2]
          thermalResistance =           CalculateThermalResistanceBlock(
                      fill(depthOfEarth,size(radius,1)-1),
                      fill(lambda,size(radius,1)-1),
                      weightedRadius,
                      weightedOuterRadius,radiusPipe,radiusBorehole);
      end CalculateResistorsBlock;

      model CalculateCapacitorsBlock
      // **************
      // This model calculates every heat capacity of the different rings, given its depth,
      // the radius of the meshed earth, the density of the earth, the specific heat capacitance.
      // **************
            // **************
            // * parameters *
            // **************
             parameter Modelica.SIunits.Radius radiusPipe;
                // The points of the radius of the mesh of the earth.
                parameter Modelica.SIunits.Radius radius[:];
                // This represents the 1/10 of the total depth of the borehole (m)
                parameter Modelica.SIunits.Length depthOfEarth=10;
                // This is the density of the earth.
                parameter Modelica.SIunits.Density densityEarth=1600;
                // This is the heat capacitance of the earth.
                parameter Modelica.SIunits.SpecificHeatCapacity
          heatCapacitanceEarth =                                                     10;
                // Here we calculate the different capacities.
                parameter Modelica.SIunits.HeatCapacity capacities[size(radius,1)+1] = CalculateEarthCapacitiesBlock(
                fill(depthOfEarth,size(radius,1)-1),
                fill(heatCapacitanceEarth,size(radius,1)-1),
                fill(densityEarth,size(radius,1)-1),
                radius[1:size(radius,1)-1],
                radius[2:size(radius,1)],
                radiusPipe);
      end CalculateCapacitorsBlock;

      model TopOnGround "Represents the top ground with a fixed temperature"
      parameter RecordEarthLayer recordEarthLayer;

      // No index needed anymore..?
      parameter Integer index=16;

      Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
          fixedTemperature;

      end TopOnGround;

      model Earthring
        "This class represents a ring of earth, containing a earth capacitor and for connections (up, down, inward, outward)"
      parameter RecordEarthLayer recordEarthLayer
          "Record containing the necessairy information";
      parameter Modelica.SIunits.Radius innerRadius = 1 "The inner radius";
      parameter Modelica.SIunits.Radius outerRadius = 10 "the outer radius ";
      parameter Modelica.SIunits.Radius weightedRadius = sqrt((innerRadius^2 + outerRadius^2)/2)
          "The weighted radius";
      parameter Modelica.SIunits.Temperature startTemperature=288
          "The starttemperature of this ring of earth";

      // Two earth resistors, inward and outward.
      EarthResistor earthResistorOutWard(thermalResistance=
              CalculateEarthResistance(
                    recordEarthLayer.depthOfEarth,
                    recordEarthLayer.lambda,
                    outerRadius,
                    weightedRadius));
      EarthResistor earthResistorInWard(thermalResistance=
              CalculateEarthResistance(
                    recordEarthLayer.depthOfEarth,
                    recordEarthLayer.lambda,
                    weightedRadius,
                    innerRadius));

      // The earth capacitor
      EarthCapacitor earthCapacitor(capacity=CalculateEarthCapacitie(
                    recordEarthLayer.depthOfEarth,
                    recordEarthLayer.heatCapacitanceEarth,
                    recordEarthLayer.densityEarth,
                    innerRadius,
                    outerRadius), startTemperature=startTemperature);

      //Two vertical resistors.
      VerticalHeatExchangerModels.VerticalResistor verticalResistorUp(
          lambda=recordEarthLayer.lambda,
          depthOfEarth=recordEarthLayer.depthOfEarth/2,
          innerRadius=innerRadius,
          outerRadius=outerRadius);
      VerticalHeatExchangerModels.VerticalResistor verticalResistorDown(
          lambda=recordEarthLayer.lambda,
          depthOfEarth=recordEarthLayer.depthOfEarth/2,
          innerRadius=innerRadius,
          outerRadius=outerRadius);

      // Help variable: Temperature of earthRing is defined on the outwardRadius;
      Modelica.SIunits.Temperature getTemperature;
      equation

      //Every resistor is connected to one point. Towards the borehole is always port_a in the horizontal direction.
      //  In the vertical direction is port_a the most upper port.
      connect(verticalResistorUp.port_b,earthCapacitor.portA);
      connect(verticalResistorDown.port_a,earthCapacitor.portA);
      connect(earthResistorOutWard.port_a,earthCapacitor.portA);
      connect(earthResistorInWard.port_b,earthCapacitor.portA);

      getTemperature = earthResistorOutWard.port_b.T;

      end Earthring;

      model EarthringUnder "See earthring, should be inheritance... no time"
      parameter RecordEarthLayer recordEarthLayer;
      parameter Modelica.SIunits.Radius innerRadius = 1;
      parameter Modelica.SIunits.Radius outerRadius = 10;
      parameter Modelica.SIunits.Radius weightedRadius = sqrt((innerRadius^2 + outerRadius^2)/2);
      parameter Modelica.SIunits.Temperature startTemperature=288;
      EarthResistor earthResistorOutWard(thermalResistance=
              CalculateEarthResistance(
                    recordEarthLayer.depthOfEarthUnder,
                    recordEarthLayer.lambda,
                    outerRadius,
                    weightedRadius));
      EarthResistor earthResistorInWard(thermalResistance=
              CalculateEarthResistance(
                    recordEarthLayer.depthOfEarthUnder,
                    recordEarthLayer.lambda,
                    weightedRadius,
                    innerRadius));
      EarthCapacitor earthCapacitor(capacity=CalculateEarthCapacitie(
                    recordEarthLayer.depthOfEarthUnder,
                    recordEarthLayer.heatCapacitanceEarth,
                    recordEarthLayer.densityEarth,
                    innerRadius,
                    outerRadius), startTemperature=startTemperature);
      VerticalHeatExchangerModels.VerticalResistor verticalResistorUp(
          lambda=recordEarthLayer.lambda,
          depthOfEarth=recordEarthLayer.depthOfEarthUnder/2,
          innerRadius=innerRadius,
          outerRadius=outerRadius);
      VerticalHeatExchangerModels.VerticalResistor verticalResistorDown(
          lambda=recordEarthLayer.lambda,
          depthOfEarth=recordEarthLayer.depthOfEarthUnder/2,
          innerRadius=innerRadius,
          outerRadius=outerRadius);

      // Help variable: Temperature of earthRing is defined on the outwardRadius;
      Modelica.SIunits.Temperature getTemperature;

      equation
      connect(verticalResistorUp.port_b,earthCapacitor.portA);
      connect(verticalResistorDown.port_a,earthCapacitor.portA);
      connect(earthResistorOutWard.port_a,earthCapacitor.portA);
      connect(earthResistorInWard.port_b,earthCapacitor.portA);

      getTemperature = earthResistorOutWard.port_b.T;

      end EarthringUnder;

      model EarthLayerNotInUse
        // Not in use anymore, could be faster if used. Difference, no earthring, less equations.

      //  OPGELET! FOR LUS VAN CONNECTIES WERKEN NIET IN JMODELICA!
      //  Vermits het niet werkt, alle connecties met de hand coderen!
      // **************
      // This model generates a connection of capacitors en resistors of the earth.
      // The parameters for generating are given in the recordEarthLayer.
      // Port_a is directed towards the borehole. port_b is directed opposited of port_a.
      // The last resistor is connected to a fixed temperature, the end-temperature.
      // **************
            // **************
            // * parameters *
            // **************
            // This record contains all the parameters concerning the earth.
            parameter RecordEarthLayer recordEarthLayer;
            // Calculate all the inductances of the earth resistor.
            parameter CalculateResistors calculatedRecordsEarthResistor(
             depthOfEarth=recordEarthLayer.depthOfEarth,
            radius=recordEarthLayer.radius,
            lambda=recordEarthLayer.lambda);
            // Calculate all the capacities of the earth capacitors
            parameter CalculateCapacitors calculatedRecordsEarthCapacitor(radius=recordEarthLayer.radius,
            depthOfEarth=recordEarthLayer.depthOfEarth,
            densityEarth=recordEarthLayer.densityEarth,
            heatCapacitanceEarth=recordEarthLayer.heatCapacitanceEarth);
            parameter Real numberOfLayer;
            parameter Real differenceToBottum= recordEarthLayer.totalDepth - recordEarthLayer.depthOfEarth*(numberOfLayer - 1/2);
            parameter Real offset = 0;
            // **************
            // * Variables *
            // **************
            // Define all the earth resistors.
      public
            EarthResistor[size(recordEarthLayer.radius,1)-1] resistors(thermalResistance=calculatedRecordsEarthResistor.thermalResistance); //,each
            //startTemperature =       recordEarthLayer.startTemperature);
            // Define all the earth capacitors.
            EarthCapacitor[size(recordEarthLayer.radius,1)-1] capacitors(capacity = calculatedRecordsEarthCapacitor.capacities,each
            startTemperature =      -recordEarthLayer.gradient*differenceToBottum + recordEarthLayer.bottumTemperature);
            ContactResistanceEarthSideFilling contactResistanceEarthSideFilling(recordEarthLayer=recordEarthLayer);
            // Define the end temperature
            Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedTemperature(   Q_flow = 0);
            VerticalHeatExchangerModels.VerticalResistor[size(recordEarthLayer.radius,
          1) - 1] verticalResistors(
          each lambda=recordEarthLayer.lambda,
          each depthOfEarth=recordEarthLayer.depthOfEarth/2,
          innerRadius=recordEarthLayer.radius[1:size(recordEarthLayer.radius, 1)
               - 1],
          outerRadius=recordEarthLayer.radius[2:size(recordEarthLayer.radius, 1)]);

         VerticalHeatExchangerModels.VerticalResistor[size(recordEarthLayer.radius,
          1) - 1] verticalResistorsUp(
          each lambda=recordEarthLayer.lambda,
          each depthOfEarth=recordEarthLayer.depthOfEarth/2,
          innerRadius=recordEarthLayer.radius[1:size(recordEarthLayer.radius, 1)
               - 1],
          outerRadius=recordEarthLayer.radius[2:size(recordEarthLayer.radius, 1)]);

      equation
             connect(resistors[1].port_a, contactResistanceEarthSideFilling.port_b);
             for index in 1:size(resistors,1) loop
                connect(resistors[index].port_a,capacitors[index].portA);
             end for;
             for index in 1:size(resistors,1)-1 loop
                connect(resistors[index].port_b,resistors[index + 1].port_a);
             end for;
             connect(resistors[size(resistors,1)].port_b, fixedTemperature.port);
            for index in 1:size(capacitors,1) loop
                connect(capacitors[index].portA,verticalResistors[index].port_a);
            end for;
            for index in 1:size(capacitors,1) loop
                connect(capacitors[index].portA,verticalResistorsUp[index].port_b);
            end for;
      end EarthLayerNotInUse;

      model BlockEarthLayerNotInUse
           // **************
            // * parameters *
            // **************
            // This record contains all the parameters concerning the earth.
            parameter RecordEarthLayer recordEarthLayer;
            // Radius of the pipe.
            parameter Modelica.SIunits.Radius radiusPipe;
            // Radius of the pipe.
            parameter Modelica.SIunits.Radius radiusBorehole = recordEarthLayer.radius[1];
            // Calculate all the inductances of the earth resistor
            parameter CalculateResistorsBlock calculatedRecordsEarthResistor(
             depthOfEarth=recordEarthLayer.depthOfEarthUnder,
            radius=recordEarthLayer.radius,
            lambda=recordEarthLayer.lambda,
            radiusPipe=radiusPipe,
            radiusBorehole=radiusBorehole);
            // Calculate all the capacities of the earth capacitors
            parameter CalculateCapacitorsBlock calculatedRecordsEarthCapacitor(radius=recordEarthLayer.radius,
            depthOfEarth=recordEarthLayer.depthOfEarthUnder,
            densityEarth=recordEarthLayer.densityEarth,
            heatCapacitanceEarth=recordEarthLayer.heatCapacitanceEarth,
            radiusPipe=radiusPipe);
            parameter Real[size(capacitors,1)+1] radia = ConstructArray(               radiusPipe,recordEarthLayer.radius,size(capacitors,1)+1);
            parameter Real[size(capacitors,1)] innerRadius = radia[1:size(capacitors,1)];
            parameter Real[size(capacitors,1)] outerRadius = radia[2:size(capacitors,1) +1];
            parameter Real numberOfLayer = 1;
            parameter Real differenceToBottum= recordEarthLayer.metersOfEarthBlock - recordEarthLayer.depthOfEarthUnder*(numberOfLayer - 1/2);
      public
            EarthResistor[size(recordEarthLayer.radius,1)+2] resistors(thermalResistance=calculatedRecordsEarthResistor.thermalResistance); //,each
            //startTemperature =       recordEarthLayer.startTemperature);
            // Define all the earth capacitors.
            EarthCapacitor[size(recordEarthLayer.radius,1)+1] capacitors(capacity = calculatedRecordsEarthCapacitor.capacities, each
            startTemperature =       -recordEarthLayer.gradient*differenceToBottum + recordEarthLayer.bottumTemperature);
            Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedTemperature(  Q_flow=0);
            //Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedFlow(T=recordEarthLayer.endTemperature);
            Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedFlow(Q_flow=0);
            VerticalHeatExchangerModels.VerticalResistor[size(capacitors, 1)] verticalResistors(
          each lambda=recordEarthLayer.lambda,
          each depthOfEarth=recordEarthLayer.depthOfEarthUnder/2,
          innerRadius=innerRadius,
          outerRadius=outerRadius);
             VerticalHeatExchangerModels.VerticalResistor[size(capacitors, 1)] verticalResistorsUp(
          each lambda=recordEarthLayer.lambda,
          each depthOfEarth=recordEarthLayer.depthOfEarthUnder/2,
          innerRadius=innerRadius,
          outerRadius=outerRadius);
      equation
            connect(resistors[1].port_a, fixedFlow.port);
            // Connect every resistorside with a capacitor.
             for index in 1:size(capacitors,1) loop
                connect(resistors[index].port_b,capacitors[index].portA);
             end for;
              // Connect every resistorside with an other capacitor
             for index in 1:size(capacitors,1) loop
                connect(resistors[index + 1].port_a,capacitors[index].portA);
             end for;
             // Connect every capacitor with a vertikal resistor downwards.
             for index in 1:size(capacitors,1) loop
                connect(verticalResistors[index].port_a,capacitors[index].portA);
             end for;
             // Connect every capacitor with a vertikal resistor upwards.
             for index in 1:size(capacitors,1) loop
                connect(verticalResistorsUp[index].port_b,capacitors[index].portA);
             end for;
             connect(resistors[size(resistors,1)].port_b, fixedTemperature.port);
      end BlockEarthLayerNotInUse;
    end Earth;

    package Borehole "Everything concering the borehole."

      package Fillingmaterial

        record RecordContactResistanceEarthBoreHole
          "Record containing the information for the contact resistance."
        parameter Modelica.SIunits.Length depthOfEarth = 10
            "This represents the 1/10 of the total depth of the borehole (m)";
        parameter Modelica.SIunits.ThermalConductivity lambdaFillMaterial =  2.6
            "This is the thermal conductivity of the filling material (W/(m.K))";
        parameter Modelica.SIunits.ThermalConductivity lambdaEarth =  1.3
            "This is the thermal conductivity of the earth (W/(m.K))";
        parameter Modelica.SIunits.Radius radiusBorehole =  0.057
            "This is the radius of the borehole (m)";
        parameter Modelica.SIunits.Radius radiusPipe = 0.015
            "This is the radius of the pipe (m)";
        end RecordContactResistanceEarthBoreHole;

        record RecordContactResistanceBorepipeFilling
          "Record containing the information for the contact resistance."

        parameter Modelica.SIunits.Length depthOfEarth = 10
            "This represents the 1/10 of the total depth of the borehole (m)";
        parameter Modelica.SIunits.ThermalDiffusivity alphaSole = 4.36*2.6/(0.014*2)
            "This is the thermal diffusivity of the brine... not necessairy in here I think";
        parameter Modelica.SIunits.Radius radiusPipe=0.015
            "This is the radius of the pipe (m)";
        parameter Modelica.SIunits.Radius radiusBorehole=0.057
            "This is the radius of the borehole (m)";
        parameter Modelica.SIunits.ThermalConductivity lambdaFilling=2.6
            "This is the thermal conductivity of the filling material (W/(m.K))";

        end RecordContactResistanceBorepipeFilling;

        record RecordFillingMaterialCapacitor
          "Record containing the neccaisary inforamtion about the filling material capacitor."
        parameter Modelica.SIunits.Temperature startTemperature = 288
            "This is the start temperature of the capacitor (K).";
        parameter Modelica.SIunits.Length depthOfEarth =  10
            " This represents the 1/10 of the total depth of the borehole (m)";
        parameter Modelica.SIunits.SpecificHeatCapacity heatCapacitanceFillig =  750
            "This is the specific heat capacity of the earth (J/(kg.K))";
        parameter Modelica.SIunits.Density densityFillig =  3000
            " This is the density of the fillling material (kg/m³)";
        parameter Modelica.SIunits.Radius innerRadius = 0.01
            "This is the inner of the pipe (m)";
        parameter Modelica.SIunits.Radius outerRadius = 0.13
            "This is the radius of the borehole (m)";
        end RecordFillingMaterialCapacitor;

        function CalculateFillingMaterialCapacitor
          "The filling material capacitor"
        // **************
        // This function calculates the capacity of the pipe filling material given the
        // the length of the pipe, the density of the filling material,
        // and the specific heat of the fiiling material, the inner radius and the
        // outer radius.
        // **************
        // **************
        // INPUT
        // **************
        // The length of the pipe (this is the 1/10 of the total length).
        input Modelica.SIunits.Length depthOfEarth;
        // The specific heat of the filling material.
        input Modelica.SIunits.SpecificHeatCapacity heatCapacitanceFillig;
        // The density of the filling material.
        input Modelica.SIunits.Density densityFillig;
        // The inner radius of the filling material.
        input Modelica.SIunits.Radius innerRadius;
        // The outer radius of the filling material;
        input Modelica.SIunits.Radius outerRadius;
        // **************
        // OUTPUT
        // **************
        // The capacity of the filling material.
        output Modelica.SIunits.HeatCapacity capacity;
        algorithm
          // Minus two times the inner radius square, this is the space taken by the pipes.
        capacity :=  Modelica.Constants.pi*densityFillig*heatCapacitanceFillig*(outerRadius^2-2*innerRadius^2)*depthOfEarth;
        end CalculateFillingMaterialCapacitor;

        function CalculateContactResistanceFillingsidePipe
          "Calculates the contact resistance towards the pipes."
        // **************
        // This function calculates the thermal conductance of the contact resistance between the
        // filling material and the pipes given the depth of earth, the thermal diffusivity of the brine,
        // the thermal conductivity of the filling material, the radius of the pipe
        // and the radius of the borehole.
        // **************
        // **************
        // INPUT
        // **************
        // This represents the 1/10 of the total depth of the borehole (m)
        input Modelica.SIunits.Length depthOfEarth;
        // This is the thermal conductivity of the filling material
        input Modelica.SIunits.ThermalConductivity lambdaFilling;
        // This is the radius of the pipe
        input Modelica.SIunits.Radius radiusPipe;
        // This is the radius of the borehole.
        input Modelica.SIunits.Radius radiusBorehole;
        // **************
        // OUTPUT
        // **************
        // This is the thermal conductance (W/K)
        output Modelica.SIunits.ThermalResistance thermalResistance;
              // **************
              // * parameters *
              // **************
        // This parameter represents the weigthed inner radius.
        protected
        Modelica.SIunits.Radius weightedInnerRadius =  sqrt((radiusBorehole^2 + radiusPipe^2)/2);
        algorithm
        weightedInnerRadius := sqrt((radiusBorehole^2 + radiusPipe^2)/2);
        // What should this be? Is it 0.5*radiusBorehole or sqrt(2)*radiusborehole*2, bring in spacing between pipes?
        // This is a crucial point...
        // Paper describes the resistance with this formula... Don't forget to multiply the resistance by two...
        thermalResistance := Modelica.Math.log((radiusBorehole-weightedInnerRadius) /(radiusPipe))/(4*Modelica.Constants.pi*depthOfEarth*lambdaFilling);
        //thermalResistance :=  radiusBorehole^2/(lambdaFilling*(radiusBorehole - weightedInnerRadius)*foefel);
        // The EWS Model gievers this as formula. I don't think the dimensions are right...
        //thermalResistance :=  (radiusBorehole^2/sqrt(2))/(lambdaFilling);
        // I propose the next:
        //(radiusBorehole^2/sqrt(2))/(Modelica.Constants.pi*depthOfEarth*lambdaFilling);
        end CalculateContactResistanceFillingsidePipe;

        function CalculateContactResistanceFillingsideEarth
          "Calculates the resistance from the fillingmaterial towards the earth."
        // **************
        // This function calculates the thermal conductance of the contact resistor between the
        // filling material and the earth given the depth of earth, the thermal diffusivity of the filling material,
        // the thermal conductivity of the earth, the radius of the pipe,
        // the radius of the borehole and the first radius of the earth.
        // **************
        // **************
        // INPUT
        // **************
        // This represents the 1/10 of the total depth of the borehole (m)
        input Modelica.SIunits.Length depthOfEarth;
        // This is the thermal conductivity of the filling material
        input Modelica.SIunits.ThermalConductivity lambdaFillMaterial;
        // This is the radius of the pipe
        input Modelica.SIunits.Radius radiusPipe;
        // This is the radius of the borehole.
        input Modelica.SIunits.Radius radiusBorehole;
        // **************
        // OUTPUT
        // **************
        // This is the thermal conductance (W/K)
        output Modelica.SIunits.ThermalResistance thermalResistance;
              // **************
              // * parameters *
              // **************
        // This parameter represents the weighted inner radius.
        protected
        Modelica.SIunits.Radius weightedInnerRadius =  sqrt((radiusBorehole^2 + radiusPipe^2)/2);
        algorithm
        // This parameter represents the weighted inner radius.
        weightedInnerRadius := sqrt((radiusBorehole^2 + radiusPipe^2)/2);
        thermalResistance := Modelica.Math.log(radiusBorehole/(weightedInnerRadius))/(depthOfEarth*Modelica.Constants.pi*2*lambdaFillMaterial);
        end CalculateContactResistanceFillingsideEarth;

        model FillingMaterialCapacitor "The fillingmaterials capacitor"
        // **************
        // This model represents the capacitor of the filling material.
        // **************
              // **************
              // * parameters *
              // **************
        // This parameter contains all the essential information for calculating the capacity.
        parameter RecordFillingMaterialCapacitor recordFillingMaterialCapacitor;
        // The capacity is calculated with the data in recordFillingMaterialCapacitor.
        parameter Modelica.SIunits.HeatCapacity capacity = CalculateFillingMaterialCapacitor(
        recordFillingMaterialCapacitor.depthOfEarth,
        recordFillingMaterialCapacitor.heatCapacitanceFillig,
        recordFillingMaterialCapacitor.densityFillig,
        recordFillingMaterialCapacitor.innerRadius,
        recordFillingMaterialCapacitor.outerRadius);
              // **************
              // * variables *
              // **************
        // This variable represent the temperature of the filling material.
        Modelica.SIunits.Temperature temperature(start=recordFillingMaterialCapacitor.startTemperature, displayUnit="degC")
            "Temperature of element";
        // This heatport represents the heatport of the capacitor.
        Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a portA;
        equation
          temperature = portA.T;
          capacity*der(temperature) = portA.Q_flow;
        end FillingMaterialCapacitor;

        model ContactResistanceFillingsidePipe
          "The contact resistance for the fillingside towards the pipe"
        // **************
        // This model represents a contact resistance between the filling material and the pipes.
        // The thermal conductance is calculated with the parameters given in the record of the contactResistance.
        // **************
              // **************
              // * parameters *
              // **************
                  // This record contains the essential information for calculating the thermal conductance.
                  parameter
            VerticalGroundHeatExchanger.Borehole.Fillingmaterial.RecordContactResistanceBorepipeFilling
            recordContactResistanceBorepipeFilling;
                  // The thermal conductance (W/K) is calculated with the given information in recordContactResistanceBorepipeFilling
                  parameter Modelica.SIunits.ThermalResistance thermalResistance = CalculateContactResistanceFillingsidePipe(
                  recordContactResistanceBorepipeFilling.depthOfEarth,
                  recordContactResistanceBorepipeFilling.lambdaFilling,
                  recordContactResistanceBorepipeFilling.radiusPipe,
                  recordContactResistanceBorepipeFilling.radiusBorehole);
              // **************
              // * variables *
              // **************
                  // The inputport
                  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a;
                  // The outputport
                  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b;
        equation
        thermalResistance*port_a.Q_flow = (port_a.T - port_b.T);
        port_a.Q_flow = -port_b.Q_flow;
        end ContactResistanceFillingsidePipe;

        model ContactResistanceFillingsideEarth
          "The contact resistance towards the earth."
        // **************
        // This model represents a contact resistor between the earth and the filling material.
        // The thermal conductance is calculated with the parameters given in the record of the contactResistance.
        // **************
              // **************
              // * parameters *
              // **************
                  // This record contains the essential information for calculating the thermal conductance.
                  parameter RecordContactResistanceEarthBoreHole
            recordContactResistanceEarthBoreHole;
                  // The thermal conductance (W/K) is calculated with the given information in recordContactResistanceEarthBoreHole
                  parameter Modelica.SIunits.ThermalResistance thermalResistance = CalculateContactResistanceFillingsideEarth(
                  recordContactResistanceEarthBoreHole.depthOfEarth,
                  recordContactResistanceEarthBoreHole.lambdaFillMaterial,
                  recordContactResistanceEarthBoreHole.radiusPipe,
                  recordContactResistanceEarthBoreHole.radiusBorehole);
              // **************
              // * variables *
              // **************
                  // The inputport
                  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a;
                  // The outputport
                  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b;
        equation
        thermalResistance*port_a.Q_flow = (port_a.T - port_b.T);
        port_a.Q_flow = -port_b.Q_flow;
        end ContactResistanceFillingsideEarth;

        model FillingMaterial "The filling material."
        // **************
        // This model represents a fillingmaterial of a borehole. It contains a capacitor and the
        // contact resistor between the pipe and the filling material and the contact resistance between
        // the earth and the filling material.
        // The necessairy information is given with the recordFillingMaterialCapacitor and
        // the RecordContactResistanceEarthBoreHole.
        // **************
              // * parameters *
              // **************
        // This parameter contains the information for the capacitor of filling material.
        parameter RecordFillingMaterialCapacitor recordFillingMaterialCapacitor;
        // This parameter contains the information for the contactresistor of filling material and the earth.
        parameter RecordContactResistanceEarthBoreHole
            recordContactResistanceEarthBoreHole;
        // This parameter contains the information for the contactresistor of filling material and the pipes.
        parameter RecordContactResistanceBorepipeFilling
            recordContactResistanceBorepipeFilling;
              // **************
              // * variables *
              // **************
        // This variable represents the contact resistance between the earth and the filling material.
         VerticalGroundHeatExchanger.Borehole.Fillingmaterial.ContactResistanceFillingsideEarth
            contactResistanceFillingsideEarth(
              recordContactResistanceEarthBoreHole=
                recordContactResistanceEarthBoreHole);
        // This variable represents the filling material capacitor.
        VerticalGroundHeatExchanger.Borehole.Fillingmaterial.FillingMaterialCapacitor
            fillingMaterialCapacitor(recordFillingMaterialCapacitor=
                recordFillingMaterialCapacitor);
        // This variable represents the contact resistoance between the filling material and the pipes.
        VerticalGroundHeatExchanger.Borehole.Fillingmaterial.ContactResistanceFillingsidePipe
            contactResistanceFillingsideUpwardPipe(
              recordContactResistanceBorepipeFilling=
                recordContactResistanceBorepipeFilling);
        // This variable represents the contact resistoance between the filling material and the pipes.
        VerticalGroundHeatExchanger.Borehole.Fillingmaterial.ContactResistanceFillingsidePipe
            contactResistanceFillingsideDownwardPipe(
              recordContactResistanceBorepipeFilling=
                recordContactResistanceBorepipeFilling);
        // This variable represents the vertical resistor for conduction in the vertical direction.
        VerticalHeatExchangerModels.VerticalResistor verticalResistor(
            lambda=recordContactResistanceEarthBoreHole.lambdaFillMaterial,
            depthOfEarth=recordFillingMaterialCapacitor.depthOfEarth/2,
            innerRadius=recordFillingMaterialCapacitor.innerRadius,
            outerRadius=recordFillingMaterialCapacitor.outerRadius);
        VerticalHeatExchangerModels.VerticalResistor verticalResistorUp(
            lambda=recordContactResistanceEarthBoreHole.lambdaFillMaterial,
            depthOfEarth=recordFillingMaterialCapacitor.depthOfEarth/2,
            innerRadius=recordFillingMaterialCapacitor.innerRadius,
            outerRadius=recordFillingMaterialCapacitor.outerRadius);
        equation

                  // Everything is connected to one point. Towards the pipes is port_a. In the vertical direction, port_a is the most upper port.
          connect(contactResistanceFillingsideEarth.port_a,fillingMaterialCapacitor.portA);
          connect(contactResistanceFillingsideUpwardPipe.port_b,fillingMaterialCapacitor.portA);
          connect(contactResistanceFillingsideDownwardPipe.port_b,fillingMaterialCapacitor.portA);
          connect(fillingMaterialCapacitor.portA, verticalResistor.port_a);
          connect(fillingMaterialCapacitor.portA, verticalResistorUp.port_b);
        end FillingMaterial;
      end Fillingmaterial;

      package Borehole

        record RecordPipes
          "Containing every information necaissary for the pipes."
        parameter Modelica.SIunits.Radius radiusPipe =  0.03045
            "This is the radius of the pipes (m)";
        parameter Modelica.SIunits.Length depthOfEarth =  10
            "This represents the 1/10 of the total depth of the borehole (m)";
        parameter Modelica.SIunits.Density densitySole =  1111
            "This is the density of the brine (kg/m³)";
        parameter Modelica.SIunits.SpecificHeatCapacity heatCapacitanceSole =  3990
            "This is the specific heat capacity of the brine (J/(kg.K))";
        parameter Modelica.SIunits.Temperature startTemperature = 293
            "This is the start temperature of the brine in the pipes (K)";
        parameter Modelica.SIunits.ThermalDiffusivity alphaSole = 64
            "This is the thermal diffusity of the brine (m²/s)";
        parameter Modelica.SIunits.ThermalConductivity lambdaFillMaterial = 2.9
            "This is the thermal conductivity of the filling material (W/(m.K))";
        end RecordPipes;

        function CalculateContactResistanceFillingPipeside
          "The convective heattransfer"
        // **************
        // This function calculates the thermal conductance of the contact resistance between the
        // filling material and the pipes given the depth of earth, the thermal diffusivity of the brine,
        // the thermal conductivity of the filling material, the radius of the pipe
        // and the radius of the borehole.
        // **************
        // **************
        // INPUT
        // **************
        // This represents the 1/10 of the total depth of the borehole (m)
        input Modelica.SIunits.Length depthOfEarth;
        // This is the thermal diffusivity of the brine
        input Modelica.SIunits.ThermalDiffusivity alphaSole;
        // This is the radius of the pipe
        input Modelica.SIunits.Radius radiusPipe;
        // **************
        // OUTPUT
        // **************
        // This is the thermal conductance (W/K)
        output Modelica.SIunits.ThermalResistance thermalResistance;
              // **************
              // * parameters *
              // **************
             // parameter Real uhx = 60; This is standard used in the EWS model.
        // This parameter represents the weigthed inner radius.
        algorithm
        thermalResistance := 2/(alphaSole*Modelica.Constants.pi*depthOfEarth*radiusPipe);
        end CalculateContactResistanceFillingPipeside;

        model ContactResistanceFillingPipeside
          "The contact resistance for the pipes."
        // **************
        // This model represents a contact resistance between the filling material and the pipes.
        // The thermal conductance is calculated with the parameters given in the record of the contactResistance.
        // **************
              // **************
              // * parameters *
              // **************
                  // This record contains the essential information for calculating the thermal conductance.
                  parameter RecordPipes recordPipeCapacitor;
                  // The thermal conductance (W/K) is calculated with the given information in recordContactResistanceBorepipeFilling
                  parameter Modelica.SIunits.ThermalResistance thermalResistance = CalculateContactResistanceFillingPipeside(
                  recordPipeCapacitor.depthOfEarth,
                  recordPipeCapacitor.alphaSole,
                  recordPipeCapacitor.radiusPipe);
              // **************
              // * variables *
              // **************
                  // The inputport
                  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a;
                  // The outputport
                  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b;
        equation
        thermalResistance*port_a.Q_flow = (port_a.T - port_b.T);
        port_a.Q_flow = -port_b.Q_flow;
        end ContactResistanceFillingPipeside;

        model PipesOfBorehole
        // **************
        // This model represents a piece of borehole, containing two pipes, but no fillingmaterial.
        // This model has aswell the connection point for the filling material, namely, the mean temperature.
        // **************
              // **************
              // * parameters *
              // **************
        // The record containing all the necasairy information for making two pipes.
        parameter VerticalGroundHeatExchanger.Borehole.Borehole.RecordPipes recordPipeCapacitor;
        parameter AdaptedFluid.Medium medium;
        // pipe upward. port_b is the port closest to the top of earth.
        AdaptedFluid.HeatedPipe upwardPipe(
            len=recordPipeCapacitor.depthOfEarth,
            diam=recordPipeCapacitor.radiusPipe,
            medium=medium,
            medium2=medium,
            T0=recordPipeCapacitor.startTemperature,
            Rad=recordPipeCapacitor.radiusPipe,
            h_g=-recordPipeCapacitor.depthOfEarth,
            L=recordPipeCapacitor.depthOfEarth);
         // pipe downward port_a is the port closest to the top of earth.
        AdaptedFluid.HeatedPipe downwardPipe(
            len=recordPipeCapacitor.depthOfEarth,
            diam=recordPipeCapacitor.radiusPipe,
            medium=medium,
            medium2=medium,
            T0=recordPipeCapacitor.startTemperature,
            Rad=recordPipeCapacitor.radiusPipe,
            h_g=recordPipeCapacitor.depthOfEarth,
            L=recordPipeCapacitor.depthOfEarth);
        // The pipe convection.
        VerticalGroundHeatExchanger.Borehole.Borehole.ContactResistanceFillingPipeside
            contactResistanceUpwardPipe(recordPipeCapacitor=recordPipeCapacitor);
        VerticalGroundHeatExchanger.Borehole.Borehole.ContactResistanceFillingPipeside
            contactResistanceDownwardPipe(recordPipeCapacitor=
                recordPipeCapacitor);
        equation
          connect(upwardPipe.heatPort,contactResistanceUpwardPipe.port_a);
          connect(downwardPipe.heatPort,contactResistanceDownwardPipe.port_a);
        end PipesOfBorehole;

        model BottumPipesOfBorehole "The two bottumpipes of the borehole"
          extends VerticalGroundHeatExchanger.Borehole.Borehole.PipesOfBorehole;
        // **************
        // This model represents a piece of borehole, containing two pipes, but no fillingmaterial.
        // This model has aswell the connection point for the filling material, namely, the mean temperature.
        // Its the bottom piece of borehole, so the upwardpipe and the downward pipe are connected.
        // **************
        equation
          connect(downwardPipe.flowPort_b,upwardPipe.flowPort_a);
        end BottumPipesOfBorehole;
      end Borehole;
    end Borehole;

    package VerticalHeatExchangerModels
      "This package contains all the information for composing the total model"

      function CalculateVerticalResistance
                  input Modelica.SIunits.Length depthOfEarth;
                  // This is the thermal conductivity of the earth (T)
                  input Modelica.SIunits.ThermalConductivity lambda;
                  input Modelica.SIunits.Radius innerRadius;
                  // This is outer radius of the ring (m)
                  input Modelica.SIunits.Radius outerRadius;
      // **************
      // OUTPUT
      // **************
      // The capacity of the filling material.
      output Modelica.SIunits.ThermalResistance thermalResistance;
      algorithm
        thermalResistance := depthOfEarth/(lambda*Modelica.Constants.pi*(outerRadius^2 - innerRadius^2));
      end CalculateVerticalResistance;

      model CreateRecords
      // **************
      // This model creates all the necaissairy records for running the model.
      // The model gets the information for creating the records from the ultimate record:
      // AlTheParameters!
      // **************
      //parameter Real[6] radius = {0.057,  0.11868,  0.2420,  0.488,  0.982238,  2};
      // This record contains the information for creating all the records.
      parameter
          IDEAS.Thermal.Components.VerticalGroundHeatExchanger.VerticalHeatExchangerModels.AlTheParameters
          alTheParameters;
      // In this piece, the radius is calculated.
       parameter Real[alTheParameters.numberOfHorizontalNodes] radiustotal = EssentialCalculations.CalculateRadius(
       alTheParameters.radiusBorehole,
       alTheParameters.outSideRadius,
       alTheParameters.numberOfHorizontalNodes);
      parameter Real[alTheParameters.numberOfHorizontalNodes] radius = radiustotal;
      // This is the record for the pipes.
      parameter VerticalGroundHeatExchanger.Borehole.Borehole.RecordPipes recordPipeCapacitor(
          radiusPipe=alTheParameters.radiusPipe,
          depthOfEarth=alTheParameters.depthOfEarth,
          densitySole=alTheParameters.densitySole,
          heatCapacitanceSole=alTheParameters.heatCapacitanceSole,
          startTemperature=alTheParameters.startTemperaturePipe + 273.15,
          alphaSole=alTheParameters.alphaSole,
          lambdaFillMaterial=alTheParameters.lambdaFillMaterial);
      // This is the record for the contactresistance between the pipes and the filling material.
      parameter
          VerticalGroundHeatExchanger.Borehole.Fillingmaterial.RecordContactResistanceBorepipeFilling
          recordContactResistanceBorepipeFilling(
          depthOfEarth=alTheParameters.depthOfEarth,
          alphaSole=alTheParameters.alphaSole,
          radiusPipe=alTheParameters.radiusPipe,
          radiusBorehole=alTheParameters.radiusBorehole,
          lambdaFilling=alTheParameters.lambdaFillMaterial);
      // This is the record for the contactresistance between the pipes and the earth.
      parameter
          VerticalGroundHeatExchanger.Borehole.Fillingmaterial.RecordContactResistanceEarthBoreHole
          recordContactResistanceEarthBoreHole(
          depthOfEarth=alTheParameters.depthOfEarth,
          lambdaFillMaterial=alTheParameters.lambdaFillMaterial,
          lambdaEarth=alTheParameters.lambdaEarth,
          radiusPipe=alTheParameters.radiusPipe,
          radiusBorehole=alTheParameters.radiusBorehole);
      // This is the record for the earth layer.
      parameter Earth.RecordEarthLayer recordEarthLayer(
          radius=radius,
          depthOfEarth=alTheParameters.depthOfEarth,
          depthOfEarthUnder=alTheParameters.depthOfEarthUnder,
          densityEarth=alTheParameters.densityEarth,
          lambda=alTheParameters.lambdaEarth,
          heatCapacitanceEarth=alTheParameters.heatCapacitanceEarth,
          startTemperature=alTheParameters.startTemperatureEarth + 273.15,
          endTemperature=alTheParameters.endTemperature + 273.15,
          outSideTemperature=alTheParameters.outSideTemperature + 273.15,
          numberOfVerticalBottumLayers=alTheParameters.numberOfVerticalBottumLayers,

          numberOfHorizontalNodes=alTheParameters.numberOfHorizontalNodes,
          gradient=alTheParameters.gradient,
          bottumTemperature=alTheParameters.bottumTemperature + 273.15,
          totalDepth=alTheParameters.totalDepthHeatExchanger + alTheParameters.bottumDepth,

          metersOfEarthBlock=alTheParameters.bottumDepth);

      // This is the record for the filling material.
      parameter
          VerticalGroundHeatExchanger.Borehole.Fillingmaterial.RecordFillingMaterialCapacitor
          recordFillingMaterialCapacitor(
          startTemperature=alTheParameters.startTemperatureEarth + 273.15,
          depthOfEarth=alTheParameters.depthOfEarth,
          heatCapacitanceFillig=alTheParameters.heatCapacitanceFillig,
          densityFillig=alTheParameters.densityFillig,
          innerRadius=alTheParameters.radiusPipe,
          outerRadius=alTheParameters.radiusBorehole);
      end CreateRecords;

      model HorizontalLayer
        "This model represents one horizontalLayer, containing fillingmateria, earthlayer and borepipes."
      // **************
      // This model represents one horizontal layer.
      // A horizontal layer consists of earth, filling material and the borehole.
      // All three of them are connected described by Bianchi.
      // **************
            // **************
            // * parameters *
            // **************
            // These records contain the information for constructing the horizontal layer.
      parameter VerticalGroundHeatExchanger.Borehole.Borehole.RecordPipes recordPipeCapacitor;
      parameter Earth.RecordEarthLayer recordEarthLayer;
      parameter
          VerticalGroundHeatExchanger.Borehole.Fillingmaterial.RecordContactResistanceEarthBoreHole
          recordContactResistanceEarthBoreHole;
      parameter
          VerticalGroundHeatExchanger.Borehole.Fillingmaterial.RecordFillingMaterialCapacitor
          recordFillingMaterialCapacitor;
      parameter
          VerticalGroundHeatExchanger.Borehole.Fillingmaterial.RecordContactResistanceBorepipeFilling
          recordContactResistanceBorepipeFilling;
      parameter AdaptedFluid.Medium medium;
      parameter Real numberOfLayer;
      parameter Real offset = 0;
      parameter Real differenceToBottum= recordEarthLayer.totalDepth - recordEarthLayer.depthOfEarth*(numberOfLayer - 1/2);
      parameter Modelica.SIunits.Temperature TIni = -recordEarthLayer.gradient*differenceToBottum +
              recordEarthLayer.bottumTemperature;
            // **************
            // * variables *
            // **************
      // This variable represents a piece of borehole containing the pipes. This piece is replaceable with a bottumPieceOfBorehole for representing
      // the bottum horizontal layer.
      replaceable VerticalGroundHeatExchanger.Borehole.Borehole.PipesOfBorehole
          pieceOfBoreHole(
          recordPipeCapacitor=recordPipeCapacitor,
          medium=medium,
          upwardPipe(T0=TIni),
          downwardPipe(T0=TIni));
      Earth.EarthLayer earthLayer(
          recordEarthLayer=recordEarthLayer,
          numberOfLayer=numberOfLayer,
          offset=offset,
          earthRings(each startTemperature=TIni));
       VerticalGroundHeatExchanger.Borehole.Fillingmaterial.FillingMaterial fillingMaterial(
          recordFillingMaterialCapacitor=recordFillingMaterialCapacitor,
          recordContactResistanceEarthBoreHole=recordContactResistanceEarthBoreHole,
          recordContactResistanceBorepipeFilling=recordContactResistanceBorepipeFilling,
          fillingMaterialCapacitor(temperature(start=TIni, fixed=true)));
      equation
          // connect(earthLayer.contactResistanceEarthSideFilling.port_a,fillingMaterial.fillingMaterialCapacitor.portA);
          connect(earthLayer.earthRings[1].earthResistorInWard.port_a,fillingMaterial.contactResistanceFillingsideEarth.port_b);
          connect(fillingMaterial.contactResistanceFillingsideUpwardPipe.port_a,pieceOfBoreHole.contactResistanceUpwardPipe.port_b);
          connect(fillingMaterial.contactResistanceFillingsideDownwardPipe.port_a,pieceOfBoreHole.contactResistanceDownwardPipe.port_b);
        annotation (Documentation(info="<html>
<p>This model represents one horizontal layer.</p>
<p>A horizontal layer consists of earth, filling material and the borehole. All three of them are connected as described by Bianchi.</p>
<p>The intitial temperature of each earth ring, the filling material and of the brine in the pipes is identical. It depends on the position of the layer, the vertical temperature gradient in the ground and the (initial) ground temperature at the bottom of the borehole. </p>
</html>",       revisions="<html>
<p>Original version by Harm Leenders, 2011</p>
<p>Initialisation of brine and filling material temperature at ground temperature by Roel De Coninck, 26/11/2011</p>
</html>"));
      end HorizontalLayer;

      model VerticalResistor "This represents a vertical resistor in the grid."
      // **************
      // This model represents a contact resistance between the filling material and the pipes.
      // The thermal conductance is calculated with the parameters given in the record of the contactResistance.
      // **************
            // **************
            // * parameters *
            // **************
                  parameter Modelica.SIunits.Length depthOfEarth;
                  // This is the thermal conductivity of the earth (T)
                  parameter Modelica.SIunits.ThermalConductivity lambda;
                  parameter Modelica.SIunits.Radius innerRadius;
                  // This is outer radius of the ring (m)
                  parameter Modelica.SIunits.Radius outerRadius;
                // The thermal conductance (W/K) is calculated with the given information in recordContactResistanceBorepipeFilling
                parameter Modelica.SIunits.ThermalResistance thermalResistance = CalculateVerticalResistance(
                depthOfEarth,
                lambda,
                innerRadius,
                outerRadius);
            // **************
            // * variables *
            // **************
                // The inputport
                Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a;
                // The outputport
                Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b;
      equation
      thermalResistance*port_a.Q_flow = (port_a.T - port_b.T);
      port_a.Q_flow = -port_b.Q_flow;
      end VerticalResistor;

      model BottumHorizontalLayer "Represents the bottum horizontallayer"
                                  extends HorizontalLayer(redeclare
            VerticalGroundHeatExchanger.Borehole.Borehole.BottumPipesOfBorehole
            pieceOfBoreHole(recordPipeCapacitor=recordPipeCapacitor));
      // **************
      // This model represents the bottom horizontal layer.
      // A horizontal layer consists of earth, filling material and the borehole.
      // All three of them are connected.
      // The difference with the horizontal layer is the piece of borehole.
      // **************
      end BottumHorizontalLayer;

      model BoreHole "Vertical ground/brine heat exchanger, single borehole"

          replaceable parameter
          IDEAS.Thermal.Components.VerticalGroundHeatExchanger.VerticalHeatExchangerModels.AlTheParameters
          alTheParameters                                                                                                   annotation(choicesAllMatching=true);
          CreateRecords allTheRecords(alTheParameters=alTheParameters);
          parameter TME.FHF.Interfaces.Medium
                                         medium = TME.FHF.Media.Water();
            // **************
            // * variables *
            // **************
            // This array contains the horizontallayers.

      protected
          HorizontalLayer[allTheRecords.alTheParameters.numberOfVerticalBoreholeLayers
           - 1] horizontalLayers(
          each recordContactResistanceBorepipeFilling=allTheRecords.recordContactResistanceBorepipeFilling,

          each recordContactResistanceEarthBoreHole=allTheRecords.recordContactResistanceEarthBoreHole,

          each recordEarthLayer=allTheRecords.recordEarthLayer,
          each recordPipeCapacitor=allTheRecords.recordPipeCapacitor,
          each recordFillingMaterialCapacitor=allTheRecords.recordFillingMaterialCapacitor,

          each medium=medium,
          numberOfLayer=1:(allTheRecords.alTheParameters.numberOfVerticalBoreholeLayers
               - 1),
          each offset=0);

            // This variable represents the bottum horizontal layer.
          BottumHorizontalLayer bottumHorizontalLayer(
          recordContactResistanceBorepipeFilling=allTheRecords.recordContactResistanceBorepipeFilling,

          recordContactResistanceEarthBoreHole=allTheRecords.recordContactResistanceEarthBoreHole,

          recordEarthLayer=allTheRecords.recordEarthLayer,
          recordPipeCapacitor=allTheRecords.recordPipeCapacitor,
          recordFillingMaterialCapacitor=allTheRecords.recordFillingMaterialCapacitor,

          medium=medium,
          numberOfLayer=allTheRecords.alTheParameters.numberOfVerticalBoreholeLayers);

          Earth.BlockEarth blockEarth(recordEarthLayer=allTheRecords.recordEarthLayer,
            radiusPipe=allTheRecords.recordPipeCapacitor.radiusPipe);
          Earth.TopOnGround[size(horizontalLayers[1].earthLayer.earthRings, 1)]
          topOnGround(each recordEarthLayer=allTheRecords.recordEarthLayer,
            index=1:size(horizontalLayers[1].earthLayer.earthRings, 1));

          Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedFlowSpeciaal(Q_flow=0);

      public
        Modelica.SIunits.Temperature TIn=flowPort_a.h/medium.cp;
        Modelica.SIunits.Temperature TOut=flowPort_b.h/medium.cp;
        Modelica.SIunits.Power QNet=flowPort_a.H_flow + flowPort_a.H_flow;

        AdaptedFluid.FlowPort_a flowPort_a(medium = medium)
          annotation (Placement(transformation(extent={{-108,-12},{-88,8}})));
        AdaptedFluid.FlowPort_b flowPort_b(medium = medium)
          annotation (Placement(transformation(extent={{88,-10},{108,10}})));
        outer Commons.SimInfoManager sim
          annotation (Placement(transformation(extent={{-90,74},{-70,94}})));
      equation
        // The upwardpipe of layer x is connected with the upwardpipe of layer x + 1 (the massflow and the heatresistance)
        // The downwardpipe of layer x is connected with the downwardpipe of layer x + 1 (the massflow and the heatresistance)
             for index in 1:size(horizontalLayers,1)-1 loop
                connect(horizontalLayers[index].pieceOfBoreHole.downwardPipe.flowPort_b,horizontalLayers[index + 1].pieceOfBoreHole.downwardPipe.flowPort_a);
                connect(horizontalLayers[index].pieceOfBoreHole.upwardPipe.flowPort_a,horizontalLayers[index + 1].pieceOfBoreHole.upwardPipe.flowPort_b);
                connect(horizontalLayers[index].fillingMaterial.verticalResistor.port_b,horizontalLayers[index+1].fillingMaterial.verticalResistorUp.port_a);
                for index2 in 1:size(horizontalLayers[index].earthLayer.earthRings,1) loop
                    connect(horizontalLayers[index].earthLayer.earthRings[index2].verticalResistorDown.port_b,horizontalLayers[index+1].earthLayer.earthRings[index2].verticalResistorUp.port_a);
                end for;
             end for;
            connect(horizontalLayers[size(horizontalLayers,1)].pieceOfBoreHole.downwardPipe.flowPort_b,bottumHorizontalLayer.pieceOfBoreHole.downwardPipe.flowPort_a);
            connect(horizontalLayers[size(horizontalLayers,1)].pieceOfBoreHole.upwardPipe.flowPort_a,bottumHorizontalLayer.pieceOfBoreHole.upwardPipe.flowPort_b);
            connect(horizontalLayers[size(horizontalLayers,1)].fillingMaterial.verticalResistor.port_b,bottumHorizontalLayer.fillingMaterial.verticalResistorUp.port_a);
            for index2 in 1:size(horizontalLayers[1].earthLayer.earthRings,1) loop
              connect(horizontalLayers[size(horizontalLayers,1)].earthLayer.earthRings[index2].verticalResistorDown.port_b,bottumHorizontalLayer.earthLayer.earthRings[index2].verticalResistorUp.port_a);
            end for;
            connect(bottumHorizontalLayer.fillingMaterial.verticalResistor.port_b,blockEarth.blockEarthLayer[1].earthRings[1].verticalResistorUp.port_a);
            connect(bottumHorizontalLayer.fillingMaterial.verticalResistor.port_b,blockEarth.blockEarthLayer[1].earthRings[2].verticalResistorUp.port_a);
            for index2 in 1:size(horizontalLayers[1].earthLayer.earthRings,1) loop
              connect(bottumHorizontalLayer.earthLayer.earthRings[index2].verticalResistorDown.port_b,blockEarth.blockEarthLayer[1].earthRings[index2+2].verticalResistorUp.port_a);
            end for;
             for index3 in 1:size(horizontalLayers[1].earthLayer.earthRings,1) loop
               connect(horizontalLayers[1].earthLayer.earthRings[index3].verticalResistorUp.port_a,topOnGround[index3].fixedTemperature.port);
             end for;
             for index3 in 1:size(horizontalLayers[1].earthLayer.earthRings,1) loop
               topOnGround[index3].fixedTemperature.port.T = sim.Te;
             end for;
          connect(fixedFlowSpeciaal.port,horizontalLayers[1].fillingMaterial.verticalResistorUp.port_a);
          connect(flowPort_a, horizontalLayers[1].pieceOfBoreHole.downwardPipe.flowPort_a);
          connect(flowPort_b, horizontalLayers[1].pieceOfBoreHole.upwardPipe.flowPort_b);
        annotation (Icon(graphics={Line(
                points={{-60,0},{-10,0},{-10,-96},{10,-96},{10,0},{62,0}},
                color={0,0,255},
                thickness=1,
                smooth=Smooth.None)}), Documentation(info="<html>
<p>The model is composed of different horizontal layers, each containing:</p>
<p><ul>
<li>a downward and upward pipe for the brine flow</li>
<li>filling material</li>
<li>different earth rings</li>
</ul></p>
<p>Below these layers there are a few layers without pipe to simulate the ground in more detail. </p>
<p>The layers are connected vertically, meaning that vertical heat transfer is possible. The initial temperature of each layer is different, but all capacities in a given layer are initialized on the same temperature. It depends on the geometry of the model, the vertical temperature gradient and the initial temperature at the depth of the borehole. </p>
<p>Attention: the references &apos;upward&apos; and &apos;downward&apos; pipe suppose connection of the input flowrate to the a-port.</p>
</html>",       revisions="<html>
<p>Originally developed by Harm Leenders in his master thesis in 2010-2011.</p>
<p>26/11/2011 - Better initialization of the brine and filling material temperatures, Roel De Coninck.</p>
</html>"));
      end BoreHole;

      record AlTheParameters
        "Record containing all the parameters, all others should extend from this one"
      // **************
      // This record contains all the parameters that are changable.
      // The first part contains the physicalparameters.
      // The second part contains the numerical parameters.
      // **************
            // **************
            //  * First part *
            // **************
                  // **************
                  // Parameters the heatExchanger
                  // **************
                      // This represents the total depth of the borehole (m)
                      parameter Modelica.SIunits.Length totalDepthHeatExchanger =  160;
                      // This represents the depth of the earth under the borehole (m)
                      parameter Modelica.SIunits.Length bottumDepth =  totalDepthHeatExchanger*0.2;
                  // **************
                  // Parameters the holes
                  // **************
                        // This is the radius of the borehole (m)
                        parameter Modelica.SIunits.Radius radiusBorehole = 0.13; //0.1016;
                        // This is the radius of the pipes (m)
                        parameter Modelica.SIunits.Radius radiusPipe = 0.025;
                  // **************?
                  // Parameters of the brine
                  // **************
                        // This is the density of the brine (kg/m³)
                        parameter Modelica.SIunits.Density densitySole =  1000;
                        // This is the specific heat capacity of the brine (J/(kg.K))
                        parameter Modelica.SIunits.SpecificHeatCapacity
          heatCapacitanceSole =                                                                4180;
                        // This is the start temperature of the brine in the pipes (K)
                        parameter Modelica.SIunits.Temperature
          startTemperaturePipe =                                                      6.85;
                        // This is the thermal diffusity of the brine (m²/s)
                        parameter Modelica.SIunits.ThermalDiffusivity alphaSole = 4.36*lambdaFillMaterial/(2*radiusPipe);
                  // **************
                  // Parameters of the fillingmaterial.
                  // **************
                        // This is the thermal conductivity of the filling material (W/(m.K))
                        parameter Modelica.SIunits.ThermalConductivity
          lambdaFillMaterial =                                                               2.9;//0.7; 2.9
                        // This is the specific heat capacity of the filling material(J/(kg.K)).
                        parameter Modelica.SIunits.SpecificHeatCapacity
          heatCapacitanceFillig =                                                              861;//  861; 1790
                        // This is the density of the filling material (kg/m³).
                        parameter Modelica.SIunits.Density densityFillig =  1605;
                  // **************
                  // Parameters of the earth.
                  // **************
                        // This is the density of the earth (kg/m³)
                        parameter Modelica.SIunits.Density densityEarth= 1605;
                        // This is the specific heat capacity of the earth (J/(kg.K))
                        parameter Modelica.SIunits.SpecificHeatCapacity
          heatCapacitanceEarth =                                                              861;
                        // This is the start temperature of the earth (K)
                        parameter Modelica.SIunits.Temperature
          startTemperatureEarth =                                                      6.85;
                        // This is the thermal conductivity of the earth (T)
                        parameter Modelica.SIunits.ThermalConductivity
          lambdaEarth =                                                               0.7; //0.7
                        // This is the end temperature of the earth (K)
                        parameter Modelica.SIunits.Temperature endTemperature = 6.85;
                        // This is the temperature of the earth outside if fixed(K)
                        parameter Modelica.SIunits.Temperature outSideTemperature = 300-273.15;
            // **************
            //  * Second part *
            // **************
                      // This parameter represents the number of vertical layers you want to divide your borehole.
                      parameter Integer numberOfVerticalBoreholeLayers = 10;
                      // This parameter represents the number of vertical layers you want to divide the soil underneath the borehole.
                      parameter Integer numberOfVerticalBottumLayers = 7;
                     // This number represents the number of horizontalnodes outside the borehole.
                      parameter Integer numberOfHorizontalNodes = 8;
                      // This represents the 1/numberOfVerticalBoreholeLayers of the total depth of the borehole (m)
                      parameter Modelica.SIunits.Length depthOfEarth =  totalDepthHeatExchanger/numberOfVerticalBoreholeLayers; //10*depthOfEarth = depth of total borehole
                      // This represents the 1/numberOfVerticalBottumLayers of the total depth of the earth beneath (m)
                      parameter Modelica.SIunits.Length depthOfEarthUnder =  bottumDepth/numberOfVerticalBottumLayers; //10*depthOfEarth = depth of total borehole
                      // This parameter represents the outsideRadius, depending on the simulation time, remember to choose wisely...
                      parameter Modelica.SIunits.Radius outSideRadius = 60;
                      // The thermalgradient in the ground (temperature increase per meter)
                      parameter Real gradient = 0.1142/100;
                      // The lowest temperature of the ground. 9.85 is the average temperature...
                      parameter Real bottumTemperature = 9.85+gradient*(bottumDepth+totalDepthHeatExchanger);
      end AlTheParameters;

      record Config1_10_3x7
        extends AlTheParameters(
          numberOfVerticalBoreholeLayers = 10,
          numberOfVerticalBottumLayers = 3,
          numberOfHorizontalNodes = 7);
      end Config1_10_3x7;
    end VerticalHeatExchangerModels;
    annotation ();
  end VerticalGroundHeatExchanger;

  package BaseClasses "Basic components for thermal fluid flow"
    extends Modelica.Icons.Package;

    model IsolatedPipe "Pipe without heat exchange"

      extends IDEAS.Thermal.Components.Interfaces.Partials.TwoPort;

    equation
      Q_flow = 0;
      // pressure drop = none
      flowPort_a.p = flowPort_b.p;
    annotation (Documentation(info="<HTML>
Pipe without heat exchange.<br>
Thermodynamic equations are defined by Partials.TwoPortMass(Q_flow = 0).<br>
<b>Note:</b> Setting parameter m (mass of medium within pipe) to zero
leads to neglection of temperature transient cv*m*der(T).
</HTML>"),
      Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                100}}), graphics={Rectangle(
              extent={{-90,20},{90,-20}},
              lineColor={255,0,0},
              fillColor={0,0,255},
              fillPattern=FillPattern.Solid), Text(extent={{-150,100},{150,40}},
                textString="%name")}),                          Diagram(
            coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                100,100}}),                                             graphics));
    end IsolatedPipe;

    model HeatedPipe "Pipe with heat exchange"

      extends IDEAS.Thermal.Components.Interfaces.Partials.TwoPort;
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
        annotation (Placement(transformation(extent={{-10,-110},{10,-90}},
              rotation=0)));
    equation
      // energy exchange with medium
      Q_flow = heatPort.Q_flow;
      // defines heatPort's temperature
      heatPort.T = T;
      // pressure drop = none
      flowPort_a.p = flowPort_b.p;
    annotation (Documentation(info="<HTML>
Pipe with heat exchange.<br>
Thermodynamic equations are defined by Partials.TwoPort.<br>
Q_flow is defined by heatPort.Q_flow.<br>
<b>Note:</b> Setting parameter m (mass of medium within pipe) to zero
leads to neglection of temperature transient cv*m*der(T).<br>
<b>Note:</b> Injecting heat into a pipe with zero massflow causes
temperature rise defined by storing heat in medium's mass.
</HTML>"),
      Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                100}}), graphics={
            Rectangle(
              extent={{-90,20},{90,-20}},
              lineColor={255,0,0},
              fillColor={0,0,255},
              fillPattern=FillPattern.Solid),
            Text(extent={{-150,100},{150,40}}, textString="%name"),
            Polygon(
              points={{-10,-90},{-10,-40},{0,-20},{10,-40},{10,-90},{-10,-90}},
              lineColor={255,0,0})}),
                                Diagram(coordinateSystem(preserveAspectRatio=
                false, extent={{-100,-100},{100,100}}),
                                        graphics));
    end HeatedPipe;

    model Ambient "Ambient with constant properties"

      extends IDEAS.Thermal.Components.Interfaces.Partials.Ambient;
      parameter Boolean usePressureInput=false
        "Enable / disable pressure input"
        annotation(Evaluate=true);
      parameter Modelica.SIunits.Pressure constantAmbientPressure(start=0)
        "Ambient pressure"
        annotation(Dialog(enable=not usePressureInput));
      parameter Boolean useTemperatureInput=false
        "Enable / disable temperature input"
        annotation(Evaluate=true);
      parameter Modelica.SIunits.Temperature constantAmbientTemperature(start=293.15, displayUnit="degC")
        "Ambient temperature"
        annotation(Dialog(enable=not useTemperatureInput));
      Modelica.Blocks.Interfaces.RealInput ambientPressure=pAmbient if usePressureInput
        annotation (Placement(transformation(extent={{110,60},{90,80}},
              rotation=0)));
      Modelica.Blocks.Interfaces.RealInput ambientTemperature=TAmbient if useTemperatureInput
        annotation (Placement(transformation(extent={{110,-60},{90,-80}},
              rotation=0)));
    protected
      Modelica.SIunits.Pressure pAmbient;
      Modelica.SIunits.Temperature TAmbient;
    equation
      if not usePressureInput then
        pAmbient = constantAmbientPressure;
      end if;
      if not useTemperatureInput then
        TAmbient = constantAmbientTemperature;
      end if;
      flowPort.p = pAmbient;
      T = TAmbient;
    annotation (Documentation(info="<HTML>
(Infinite) ambient with constant pressure and temperature.<br>
Thermodynamic equations are defined by Partials.Ambient.
</HTML>"),     Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}}), graphics),
        Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                100,100}}), graphics={Text(
              extent={{20,80},{80,20}},
              lineColor={0,0,0},
              textString="p"), Text(
              extent={{20,-20},{80,-80}},
              lineColor={0,0,0},
              textString="T")}));
    end Ambient;

    model AbsolutePressure "Defines absolute pressure level"

      parameter TME.FHF.Interfaces.Medium medium=TME.FHF.Media.Water() "medium"
        annotation(__Dymola_choicesAllMatching=true);
      parameter Modelica.SIunits.Pressure p(start=0) "Pressure ground";
      IDEAS.Thermal.Components.Interfaces.FlowPort_a flowPort(final medium=
            medium)
        annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
              rotation=0)));
    equation
      // defining pressure
      flowPort.p = p;
      // no energy exchange; no mass flow by default
      flowPort.H_flow = 0;
    annotation (Documentation(info="<HTML>
AbsolutePressure to define pressure level of a closed cooling cycle.
Coolant's mass flow, temperature and enthalpy flow are not affected.<br>
</HTML>"),     Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}}),
                       graphics),
        Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                100,100}}), graphics={Text(
              extent={{-150,150},{150,90}},
              lineColor={0,0,255},
              textString="%name"), Ellipse(
              extent={{-90,90},{90,-90}},
              lineColor={255,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid)}));
    end AbsolutePressure;

    model Pump "Enforces constant mass flow rate"

      extends IDEAS.Thermal.Components.Interfaces.Partials.TwoPort;
      parameter Boolean useInput = false "Enable / disable MassFlowRate input"
        annotation(Evaluate=true);
      parameter Modelica.SIunits.MassFlowRate m_flowNom(min=0, start=1)
        "Nominal mass flowrate"
        annotation(Dialog(enable=not useVolumeFlowInput));
      parameter Modelica.SIunits.Pressure dpFix=50000
        "Fixed pressure drop, used for determining the electricity consumption";
      parameter Real etaTot = 0.8 "Fixed total pump efficiency";
      Modelica.SIunits.Power PEl "Electricity consumption";
      Modelica.Blocks.Interfaces.RealInput m_flowSet(start = 0, min = 0, max = 1) = m_flow/m_flowNom if useInput
        annotation (Placement(transformation(
            origin={0,100},
            extent={{-10,-10},{10,10}},
            rotation=270)));
    protected
      Modelica.SIunits.MassFlowRate m_flow;

    equation
      if not useInput then
        m_flow = m_flowNom;
      end if;

      Q_flow = 0;
      flowPort_a.m_flow = m_flow;
      PEl = m_flow / medium.rho * dpFix / etaTot;
      annotation (Documentation(info="<HTML>
Fan resp. pump with constant volume flow rate. Pressure increase is the response of the whole system.
Coolant's temperature and enthalpy flow are not affected.<br>
Setting parameter m (mass of medium within fan/pump) to zero
leads to neglection of temperature transient cv*m*der(T).<br>
Thermodynamic equations are defined by Partials.TwoPort.
</HTML>"), Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                {100,100}}), graphics={
            Ellipse(
              extent={{-90,90},{90,-90}},
              lineColor={255,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{-150,-90},{150,-150}},
              lineColor={0,0,255},
              textString="%name"),
            Polygon(
              points={{-60,68},{90,10},{90,-10},{-60,-68},{-60,68}},
              lineColor={255,0,0},
              fillColor={0,0,255},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{-40,20},{0,-20}},
              lineColor={0,0,0},
              textString="V")}),
        Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                {100,100}}),
                        graphics));
    end Pump;

    model MixingVolume "Ideal mixing volume"

      parameter TME.FHF.Interfaces.Medium medium=TME.FHF.Interfaces.Medium();
      parameter Integer nbrPorts(min=2) = 2 "Number of fluid ports, min 2";
      parameter Modelica.SIunits.Mass m=1 "Mass of the mixing volume";
      parameter Modelica.SIunits.Temperature TInitial=293.15
        "Initial temperature of the mass in the volume";
      Modelica.SIunits.Temperature T(start=TInitial)
        "Temperature of the fluid in the mixing volume";
      Modelica.SIunits.SpecificEnthalpy h=T*medium.cp
        "Specific enthalpy of the fluid in the mixing volume";

      IDEAS.Thermal.Components.Interfaces.FlowPort_a flowPorts[nbrPorts](each
          final medium=medium)
          annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

    equation
      // mass balance
      sum(flowPorts.m_flow) = 0;

      // all pressures are equal
      for i in 2:nbrPorts loop
        flowPorts[i].p = flowPorts[1].p;
      end for;

      // energy balance
      sum(flowPorts.H_flow) = m * medium.cp * der(T);

      // enthalpy outflow
      for i in 1:nbrPorts loop
        flowPorts[i].H_flow = semiLinear(flowPorts[i].m_flow, flowPorts[i].h, h);
      end for;

      annotation (Icon(graphics={Ellipse(
              extent={{-90,78},{88,-92}},
              lineColor={0,0,255},
              fillColor={170,170,255},
              fillPattern=FillPattern.Solid)}));
    end MixingVolume;

    model IdealMixer "Temperature based ideal mixer"

      parameter TME.FHF.Interfaces.Medium medium=TME.FHF.Media.Water();
      Modelica.Blocks.Interfaces.RealInput TMixedSet
        "Mixed outlet temperature setpoint" annotation (Placement(transformation(
            extent={{20,-20},{-20,20}},
            rotation=90,
            origin={0,106})));

      parameter Modelica.SIunits.MassFlowRate mFlowMin
        "Minimum outlet flowrate for mixing to start";
      Modelica.SIunits.Temperature TCold=pumpCold.T;
      Modelica.SIunits.Temperature THot=mixingVolumeHot.T
        "Temperature of the hot source";
      Modelica.SIunits.Temperature TMixed(start=273.15 + 20)=flowPortMixed.h/
        medium.cp "Temperature of the mixed water";

    protected
      Modelica.SIunits.MassFlowRate m_flowMixed=-flowPortMixed.m_flow
        "mass flowrate of the mixed flow";
      Modelica.SIunits.MassFlowRate m_flowCold(min=0)
        "mass flowrate of cold water to the mixing point";
      parameter Modelica.SIunits.MassFlowRate m_flowNom=100
        "Just a large nominal flowrate";
      Real m_flowColdInput(min=0) = m_flowCold/m_flowNom;
    //  Real m_flowHotInput = m_flowHot/m_flowNom;

      Pump pumpCold(
        useInput=true,
        medium=medium,
        m_flowNom=m_flowNom,
        m=1)
        annotation (Placement(transformation(extent={{10,-10},{-10,10}},
            rotation=-90,
            origin={0,-62})));

    public
      IDEAS.Thermal.Components.Interfaces.FlowPort_a flowPortHot(medium=medium,
          h(
          start=293.15*medium.cp,
          min=1140947,
          max=1558647))
        annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

      IDEAS.Thermal.Components.Interfaces.FlowPort_a flowPortCold(medium=medium,
          h(
          start=293.15*medium.cp,
          min=1140947,
          max=1558647))
        annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

      IDEAS.Thermal.Components.Interfaces.FlowPort_a flowPortMixed(medium=
            medium, h(
          start=293.15*medium.cp,
          min=1140947,
          max=1558647))
        annotation (Placement(transformation(extent={{90,-10},{110,10}})));

    protected
      MixingVolume mixingVolumeHot(
        medium=medium,
        m=5,
        nbrPorts=2)
        annotation (Placement(transformation(extent={{-76,6},{-56,26}})));
    equation
      //m_flowTotal = table.y[profileType] * VDayAvg * medium.rho;
      pumpCold.m_flowSet = m_flowColdInput;
    //  pumpHot.m_flowSet = m_flowHotInput;

        if noEvent(THot < TMixedSet) then
          // no mixing
          m_flowCold =  0;
        elseif noEvent(TCold > TMixedSet) then
           m_flowCold = m_flowMixed;
        elseif noEvent(flowPortMixed.m_flow < -mFlowMin) then
          m_flowCold =  - (flowPortHot.m_flow * THot + flowPortMixed.m_flow * TMixedSet) / TCold;
        else
          m_flowCold =  0;
        end if;

    //m_flowCold = max(0, -(flowPortHot.m_flow*THot + flowPortMixed.m_flow* TMixedSet)/TCold);

    //  flowPortMixed.p = 300000;
    //  flowPortMixed.H_flow = semiLinear(flowPortMixed.m_flow,flowPortMixed.h,ambient.T*medium.cp);

      connect(flowPortCold, pumpCold.flowPort_a) annotation (Line(
          points={{0,-100},{0,-72},{-1.83697e-015,-72}},
          color={255,0,0},
          smooth=Smooth.None));

      connect(flowPortHot, mixingVolumeHot.flowPorts[1]) annotation (Line(
          points={{-100,0},{-66,5.5}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(mixingVolumeHot.flowPorts[2], flowPortMixed) annotation (Line(
          points={{-66,6.5},{18,6.5},{18,0},{100,0}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(pumpCold.flowPort_b, flowPortMixed) annotation (Line(
          points={{1.83697e-015,-52},{8,-52},{8,0},{100,0}},
          color={255,0,0},
          smooth=Smooth.None));
      annotation (Diagram(graphics), Icon(graphics={
            Polygon(
              points={{-60,30},{-60,-30},{0,0},{-60,30}},
              lineColor={0,0,255},
              smooth=Smooth.None),
            Polygon(
              points={{60,30},{60,-30},{0,0},{60,30}},
              lineColor={0,0,255},
              smooth=Smooth.None),
            Polygon(
              points={{-30,30},{-30,-30},{30,0},{-30,30}},
              lineColor={0,0,255},
              smooth=Smooth.None,
              origin={0,-30},
              rotation=90)}));
    end IdealMixer;

    model DomesticHotWater "DHW consumption to be coupled to a heat source"

      parameter TME.FHF.Interfaces.Medium medium=TME.FHF.Media.Water();
      parameter Modelica.SIunits.Temperature TDHWSet=273.15 + 45
        "DHW temperature setpoint";
      parameter Modelica.SIunits.Temperature TCold=283.15;
      Modelica.SIunits.Temperature THot "Temperature of the hot source";
      Modelica.SIunits.Temperature TMixed(start=TDHWSet)=pumpHot.flowPort_b.h/
        medium.cp "Temperature of the hot source";
      parameter Modelica.SIunits.Volume VDayAvg
        "Average daily water consumption";

      Modelica.SIunits.MassFlowRate m_flowTotal
        "mass flowrate of total DHW consumption";
      Modelica.SIunits.MassFlowRate m_flowCold
        "mass flowrate of cold water to the mixing point";
      Modelica.SIunits.MassFlowRate m_flowHot
        "mass flowrate of hot water to the mixing point";

      // we need to specify the flowrate in the pump and mixingValve as relative values between 0 and 1
      // so we compute a maximum flowrate and use this as nominal flowrate for these components
      // We suppose the daily consumption will always be consumed in MORE than 10s.

      parameter Integer profileType = 1 "Type of the DHW tap profile";
      Modelica.Blocks.Tables.CombiTable1Ds table(
        tableOnFile = true,
        tableName = "data",
        smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
        fileName= "..\\Inputs\\" + "DHWProfile.txt",
        columns=2:4)
        annotation(Placement(visible = true, transformation(origin={-62,66.5},   extent={{-15,15},
                {15,-15}},                                                                                     rotation = 0)));
    protected
      parameter Modelica.SIunits.MassFlowRate m_flowNom=VDayAvg*medium.rho/100
        "only used to set a reference";
      Real m_flowHotInput = m_flowHot/m_flowNom;
      Real m_flowColdInput = m_flowCold/m_flowNom;
      Real TSetVar;
      Real m_minimum(start=0);
      Real onoff;

      /*
  Slows down the simulation too much.  Should be in post processing
  Real m_flowIntegrated(start = 0, fixed = true);
  Real m_flowDiscomfort(start=0);
  Real discomfort; //base 1
  Real discomfortWeighted;
  Real dTDiscomfort;
  */

    public
      IDEAS.Thermal.Components.BaseClasses.Ambient ambientCold(
        medium=medium,
        constantAmbientPressure=500000,
        constantAmbientTemperature=TCold)
        annotation (Placement(transformation(extent={{68,-28},{88,-8}})));
      IDEAS.Thermal.Components.BaseClasses.Ambient ambientMixed(
        medium=medium,
        constantAmbientPressure=400000,
        constantAmbientTemperature=283.15)
        annotation (Placement(transformation(extent={{66,28},{86,48}})));
      IDEAS.Thermal.Components.Interfaces.FlowPort_a flowPortHot(medium=medium)
        annotation (Placement(transformation(extent={{-10,90},{10,110}})));
      IDEAS.Thermal.Components.Interfaces.FlowPort_a flowPortCold(medium=medium)
        annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

      IDEAS.Thermal.Components.BaseClasses.Ambient ambientCold1(
        medium=medium,
        constantAmbientPressure=500000,
        constantAmbientTemperature=TCold)
        annotation (Placement(transformation(extent={{70,-64},{90,-44}})));
      IDEAS.Thermal.Components.BaseClasses.Pump pumpCold(
        useInput=true,
        medium=medium,
        m=5,
        m_flowNom=m_flowNom)
        annotation (Placement(transformation(extent={{50,-28},{30,-8}})));

      IDEAS.Thermal.Components.BaseClasses.Pump pumpHot(
        useInput=true,
        medium=medium,
        m_flowNom=m_flowNom,
        m=1)                 annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=-90,
            origin={0,54})));

      Modelica.Blocks.Sources.Sine  sine(
        amplitude=0.1,
        startTime=7*3600,
        freqHz=1/86400,
        offset=0)
        annotation (Placement(transformation(extent={{-70,2},{-50,22}})));
    equation
      //m_flowTotal = table.y[profileType] * VDayAvg * medium.rho;
      table.u =  time;
      pumpCold.m_flowSet = m_flowColdInput;
      pumpHot.m_flowSet = m_flowHotInput;
      //pumpHot1.m_flowSet = m_flowHotInput;
      /*
  // computation of DHW discomfort: too slow here, ==> post processing
  der(m_flowIntegrated) =m_flowTotal;
  der(m_flowIntegrated) = m_flowTotal;
  der(m_flowDiscomfort) = if noEvent(TMixed < TDHWSet) then m_flowTotal else 0;
  der(discomfortWeighted) = if noEvent(TMixed < TDHWSet) then m_flowTotal * (TDHWSet - TMixed) else 0;
  discomfort = m_flowDiscomfort / max(m_flowIntegrated, 1);
  dTDiscomfort = discomfortWeighted / max(m_flowDiscomfort,1);
  */
    algorithm

      if noEvent(table.y[profileType] > 0) then
        m_minimum :=1e-6;
        onoff :=1;
      else
        m_minimum :=0;
        onoff :=0;
      end if;

      THot := pumpHot.T;
      m_flowTotal := max(table.y[profileType], m_minimum)* VDayAvg * medium.rho;
      TSetVar := min(THot,TDHWSet);
      m_flowCold := if noEvent(onoff > 0.5) then m_flowTotal* (THot - TSetVar)/(THot*onoff-TCold) else 0;
      m_flowHot := if noEvent(onoff > 0.5) then m_flowTotal - m_flowCold else 0;

    equation
      connect(ambientCold.flowPort, pumpCold.flowPort_a)
                                                     annotation (Line(
          points={{68,-18},{50,-18}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(flowPortHot, pumpHot.flowPort_a)
                                              annotation (Line(
          points={{0,100},{0,64},{1.83697e-015,64}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(pumpHot.flowPort_b, ambientMixed.flowPort)
                                                       annotation (Line(
          points={{-1.83697e-015,44},{0,44},{0,38},{66,38}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(pumpCold.flowPort_b, pumpHot.flowPort_b)
                                                 annotation (Line(
          points={{30,-18},{0,-18},{0,44},{-1.83697e-015,44}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(ambientCold1.flowPort, flowPortCold) annotation (Line(
          points={{70,-54},{0,-54},{0,-100}},
          color={255,0,0},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end DomesticHotWater;
  annotation (Documentation(info="<HTML>
This package contains components:
<ul>
<li>pipe without heat exchange</li>
<li>pipe with heat exchange</li>
<li>valve (simple controlled valve)</li>
</ul>
Pressure drop is taken from partial model SimpleFriction.<br>
Thermodynamic equations are defined in partial models (package Partials).<br>
<dl>
  <dt><b>Main Authors:</b></dt>
  <dd>
  <p>
  <a href=\"http://www.haumer.at/\">Anton Haumer</a><br>
  Technical Consulting &amp; Electrical Engineering<br>
  A-3423 St.Andrae-Woerdern, Austria<br>
  email: <a href=\"mailto:a.haumer@haumer.at\">a.haumer@haumer.at</a>
</p>
  <p>
  Dr. Christian Kral<br>
  <a href=\"http://www.ait.ac.at/\">Austrian Institute of Technology, AIT</a><br>
  Giefinggasse 2<br>
  A-1210 Vienna, Austria
</p>
  </dd>
</dl>
<p>
Copyright &copy; 1998-2010, Modelica Association, Anton Haumer and Austrian Institute of Technology, AIT.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</HTML>", revisions="<HTML>
  <ul>
  <li> v1.00 2005/02/01 Anton Haumer<br>
       first stable official release</li>
  <li> v1.20 Beta 2005/02/18 Anton Haumer<br>
       introduced geodetic height in Components.Pipes<br>
       <i>new models: Components.Valve</i></li>
  <li> v1.30 Beta 2005/06/02 Anton Haumer<br>
       friction losses are fed to medium</li>
  </ul>
</HTML>
"), Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
              100}}), graphics={
          Polygon(
            points={{-56,10},{-56,-90},{-6,-40},{44,10},{44,-90},{-56,10}},
            lineColor={0,0,255},
            fillColor={0,128,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-16,10},{4,10},{-6,-10},{-16,10}},
            lineColor={0,0,127},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid),
          Line(points={{-6,-10},{-6,-40},{-6,-38}}, color={0,0,127})}));
  end BaseClasses;

  package Examples
    "Examples that demonstrate the use of the models from IDEAS.Thermal.Components"
    extends Modelica.Icons.ExamplesPackage;

    model PumpePipeTester "Identical as the one in FluidHeatFlow_NoPressure"

      IDEAS.Thermal.Components.BaseClasses.Pump
                              pump1(
        medium=TME.FHF.Media.Water(),
        useInput=true,
        m_flowNom=0.5,
        m=0)
        annotation (Placement(transformation(extent={{-36,28},{-16,48}})));
      IDEAS.Thermal.Components.BaseClasses.HeatedPipe
                            pipe1(
        medium=TME.FHF.Media.Water(),
        m=5) annotation (Placement(transformation(extent={{10,28},{30,48}})));
      Modelica.Blocks.Sources.Sine pulse(
        startTime=200,
        freqHz=1/3600,
        amplitude=1)
        annotation (Placement(transformation(extent={{-68,60},{-48,80}})));
      IDEAS.Thermal.Components.BaseClasses.AbsolutePressure
                               absolutePressure(medium=
            TME.FHF.Media.Water(),                p=200000)
        annotation (Placement(transformation(extent={{58,62},{78,82}})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                         volumeFlow1(
        medium=TME.FHF.Media.Water(),
        m_flowNom=0.5,
        useInput=true,
        m=0)
        annotation (Placement(transformation(extent={{-36,-16},{-16,4}})));
      IDEAS.Thermal.Components.BaseClasses.HeatedPipe
                            pipe2(
        medium=TME.FHF.Media.Water(),
        m=5) annotation (Placement(transformation(extent={{10,-16},{30,4}})));
      Modelica.Blocks.Sources.Pulse pulse1(period=1800, startTime=3600,
        amplitude=1)
        annotation (Placement(transformation(extent={{-64,2},{-44,22}})));
      IDEAS.Thermal.Components.BaseClasses.IsolatedPipe
                              pipe3(medium=TME.FHF.Media.Water(),
                                                          m=5)
             annotation (Placement(transformation(extent={{50,4},{70,24}})));
      Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=20)
        annotation (Placement(transformation(extent={{-6,-52},{14,-32}})));
      Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=333.15)
        annotation (Placement(transformation(extent={{-56,-52},{-36,-32}})));
      Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor1(G=
           20) annotation (Placement(transformation(extent={{16,76},{36,96}})));
      Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T=313.15)
        annotation (Placement(transformation(extent={{-34,76},{-14,96}})));
    equation
      connect(pump1.flowPort_b, pipe1.flowPort_a)             annotation (Line(
          points={{-16,38},{10,38}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(absolutePressure.flowPort, pipe1.flowPort_b)        annotation (Line(
          points={{58,72},{48,72},{48,68},{30,68},{30,38}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(volumeFlow1.flowPort_b, pipe2.flowPort_a)         annotation (Line(
          points={{-16,-6},{10,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(pipe1.flowPort_b, pipe3.flowPort_a)                annotation (Line(
          points={{30,38},{38,38},{38,14},{50,14}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(pipe2.flowPort_b, pipe3.flowPort_a)                 annotation (Line(
          points={{30,-6},{34,-6},{34,-4},{40,-4},{40,14},{50,14}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(pipe3.flowPort_b, volumeFlow1.flowPort_a)         annotation (Line(
          points={{70,14},{74,14},{74,-62},{-76,-62},{-76,-6},{-36,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(pipe3.flowPort_b, pump1.flowPort_a)              annotation (Line(
          points={{70,14},{74,14},{74,-62},{-76,-62},{-76,38},{-36,38}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(thermalConductor.port_b, pipe2.heatPort)         annotation (Line(
          points={{14,-42},{18,-42},{18,-16},{20,-16}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(fixedTemperature.port, thermalConductor.port_a) annotation (Line(
          points={{-36,-42},{-6,-42}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(fixedTemperature1.port, thermalConductor1.port_a) annotation (Line(
          points={{-14,86},{16,86}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(thermalConductor1.port_b, pipe1.heatPort)        annotation (Line(
          points={{36,86},{44,86},{44,28},{20,28}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(pulse.y, pump1.m_flowSet) annotation (Line(
          points={{-47,70},{-26,70},{-26,48}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(pulse1.y, volumeFlow1.m_flowSet) annotation (Line(
          points={{-43,12},{-38,12},{-38,14},{-26,14},{-26,4}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(graphics),
        experiment(StopTime=10000),
        __Dymola_experimentSetupOutput);
    end PumpePipeTester;

    model HPTester "Identical as the one in FluidHeatFlow_NoPressure"
      import Commons;

      IDEAS.Thermal.Components.BaseClasses.AbsolutePressure
                               absolutePressure(medium=
            TME.FHF.Media.Water(),                p=200000)
        annotation (Placement(transformation(extent={{58,62},{78,82}})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                         volumeFlow1(
        medium=TME.FHF.Media.Water(),
        m=1,
        m_flowNom=0.3,
        useInput=true)
        annotation (Placement(transformation(extent={{-36,-16},{-16,4}})));
      IDEAS.Thermal.Components.BaseClasses.HeatedPipe
                            isolatedPipe1(
        medium=TME.FHF.Media.Water(),
        m=5,
        TInitial=313.15) annotation (Placement(transformation(extent={{12,-16},{32,4}})));
      IDEAS.Thermal.Components.HeatProduction.HP_AWMod_Losses
                          HP(
       medium=TME.FHF.Media.Water(),
        QNom=5000,
        TSet=pulse.y,
        tauHeatLoss=3600,
        mWater=10,
        cDry=10000)
                   annotation (Placement(transformation(extent={{42,10},{62,30}})));
      Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=300)
        annotation (Placement(transformation(extent={{-6,-52},{14,-32}})));
      Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
        annotation (Placement(transformation(extent={{-56,-52},{-36,-32}})));
      inner Commons.SimInfoManager sim(redeclare Commons.Meteo.Files.min15
          detail, redeclare Commons.Meteo.Locations.Uccle city)
        annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
      Modelica.Blocks.Sources.Pulse pulse(
        amplitude=45,
        period=10000,
        offset=273)
        annotation (Placement(transformation(extent={{-30,66},{-10,86}})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                         volumeFlow2(
        medium=TME.FHF.Media.Water(),
        m=1,
        m_flowNom=0.3,
        useInput=true)
        annotation (Placement(transformation(extent={{-32,-148},{-12,-128}})));
      IDEAS.Thermal.Components.BaseClasses.HeatedPipe
                            isolatedPipe2(
        medium=TME.FHF.Media.Water(),
        m=5,
        TInitial=313.15) annotation (Placement(transformation(extent={{16,-148},{36,
                -128}})));
      IDEAS.Thermal.Components.HeatProduction.HP_AWMod
                          HP_NoLosses(
        medium=TME.FHF.Media.Water(),
        QNom=5000,
        TSet=pulse.y)
                   annotation (Placement(transformation(extent={{56,-148},{76,-128}})));
      Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor1(
                                                                                 G=300)
        annotation (Placement(transformation(extent={{-2,-184},{18,-164}})));
      Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(
                                                                              T=293.15)
        annotation (Placement(transformation(extent={{-52,-184},{-32,-164}})));
      IDEAS.Thermal.Components.BaseClasses.AbsolutePressure
                               absolutePressure1(
                                                medium=
            TME.FHF.Media.Water(),                p=200000)
        annotation (Placement(transformation(extent={{54,-108},{74,-88}})));
     Real PElLossesInt( start = 0, fixed = true);
     Real PElNoLossesInt( start = 0, fixed = true);
     Real QUsefulLossesInt( start = 0, fixed = true);
     Real QUsefulNoLossesInt( start = 0, fixed = true);
     Real SPFLosses( start = 0);
     Real SPFNoLosses( start = 0);

    equation
      volumeFlow1.m_flowSet = if pulse.y > 300 then 1 else 0;
      volumeFlow2.m_flowSet = if pulse.y > 300 then 1 else 0;
      der(PElLossesInt) = HP.PEl;
      der(PElNoLossesInt) = HP_NoLosses.PEl;
      der(QUsefulLossesInt) =thermalConductor.port_b.Q_flow;
      der(QUsefulNoLossesInt) = thermalConductor1.port_b.Q_flow;
      SPFLosses = if noEvent(PElLossesInt > 0) then QUsefulLossesInt/PElLossesInt else 0;
      SPFNoLosses = if noEvent(PElNoLossesInt > 0) then QUsefulNoLossesInt/PElNoLossesInt else 0;

      connect(volumeFlow1.flowPort_b, isolatedPipe1.flowPort_a) annotation (Line(
          points={{-16,-6},{12,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(isolatedPipe1.flowPort_b, HP.flowPort_a)            annotation (Line(
          points={{32,-6},{52,-6},{52,18},{62,18}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(HP.flowPort_b, volumeFlow1.flowPort_a)            annotation (Line(
          points={{62,22},{82,22},{82,-62},{-76,-62},{-76,-6},{-36,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(thermalConductor.port_b, isolatedPipe1.heatPort) annotation (Line(
          points={{14,-42},{18,-42},{18,-16},{22,-16}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(fixedTemperature.port, thermalConductor.port_a) annotation (Line(
          points={{-36,-42},{-6,-42}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(absolutePressure.flowPort, HP.flowPort_a)            annotation (Line(
          points={{58,72},{80,72},{80,12},{76,12},{76,18},{62,18}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(HP.heatPort, fixedTemperature.port) annotation (Line(
          points={{52,30},{94,30},{94,-72},{-36,-72},{-36,-42}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(volumeFlow2.flowPort_b,isolatedPipe2. flowPort_a) annotation (Line(
          points={{-12,-138},{16,-138}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(isolatedPipe2.flowPort_b, HP_NoLosses.flowPort_a)   annotation (Line(
          points={{36,-138},{56,-138}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(HP_NoLosses.flowPort_b, volumeFlow2.flowPort_a)   annotation (Line(
          points={{76,-138},{86,-138},{86,-194},{-72,-194},{-72,-138},{-32,-138}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(thermalConductor1.port_b, isolatedPipe2.heatPort)
                                                               annotation (Line(
          points={{18,-174},{22,-174},{22,-148},{26,-148}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(fixedTemperature1.port, thermalConductor1.port_a)
                                                              annotation (Line(
          points={{-32,-174},{-2,-174}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(absolutePressure1.flowPort, HP_NoLosses.flowPort_a)  annotation (Line(
          points={{54,-98},{54,-138},{56,-138}},
          color={255,0,0},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -200},{100,100}}),
                          graphics),
        experiment(StopTime=25000),
        __Dymola_experimentSetupOutput,
        Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-200},{100,100}})));
    end HPTester;

    model RadTester "Simple radiator tester"
      import Commons;

      IDEAS.Thermal.Components.BaseClasses.AbsolutePressure
                               absolutePressure(medium=
            TME.FHF.Media.Water(),                p=200000)
        annotation (Placement(transformation(extent={{50,-52},{70,-32}})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                         volumeFlow1(
        medium=TME.FHF.Media.Water(),
        m=4,
        TInitial=313.15,
        m_flowNom=0.05)
        annotation (Placement(transformation(extent={{-58,-16},{-38,4}})));
      IDEAS.Thermal.Components.BaseClasses.HeatedPipe
                            boiler(
        medium=TME.FHF.Media.Water(),
        m=5,
        TInitial=313.15) annotation (Placement(transformation(extent={{-26,-16},{-6,
                4}})));
      IDEAS.Thermal.Components.HeatEmission.Radiator
                          radiator(
        medium=TME.FHF.Media.Water(),
                              QNom=3000) "Hydraulic radiator model"
                   annotation (Placement(transformation(extent={{52,-16},{72,4}})));
      inner Commons.SimInfoManager sim(redeclare Commons.Meteo.Files.min15
          detail, redeclare Commons.Meteo.Locations.Uccle city)
        annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
      Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
        prescribedTemperature
        annotation (Placement(transformation(extent={{32,24},{52,44}})));
      Modelica.Blocks.Sources.Step step(
        height=2,
        offset=291,
        startTime=10000)
        annotation (Placement(transformation(extent={{-4,24},{16,44}})));
      Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow=3000)
        annotation (Placement(transformation(extent={{-50,-52},{-30,-32}})));
    equation

      connect(volumeFlow1.flowPort_b, boiler.flowPort_a)        annotation (Line(
          points={{-38,-6},{-26,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(boiler.flowPort_b, radiator.flowPort_a)             annotation (Line(
          points={{-6,-6},{52,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(radiator.flowPort_b, volumeFlow1.flowPort_a)      annotation (Line(
          points={{72,-6},{82,-6},{82,-62},{-76,-62},{-76,-6},{-58,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(absolutePressure.flowPort, radiator.flowPort_a)      annotation (Line(
          points={{50,-42},{50,-30},{48,-30},{48,-6},{52,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(step.y, prescribedTemperature.T) annotation (Line(
          points={{17,34},{30,34}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));
      connect(prescribedTemperature.port, radiator.heatPortConv) annotation (Line(
          points={{52,34},{64,34},{64,4}},
          color={191,0,0},
          thickness=0.5,
          smooth=Smooth.None));
      connect(prescribedTemperature.port, radiator.heatPortRad) annotation (Line(
          points={{52,34},{68,34},{68,4}},
          color={191,0,0},
          thickness=0.5,
          smooth=Smooth.None));
      connect(fixedHeatFlow.port, boiler.heatPort) annotation (Line(
          points={{-30,-42},{-16,-42},{-16,-16}},
          color={191,0,0},
          thickness=0.5,
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end RadTester;

    model HeatingSystem
      import Commons;

      IDEAS.Thermal.Components.BaseClasses.AbsolutePressure
                               absolutePressure(medium=
            TME.FHF.Media.Water(),                p=200000)
        annotation (Placement(transformation(extent={{-88,40},{-68,60}})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                      pump1(
        medium=TME.FHF.Media.Water(),
        useInput=true,
        m_flowNom=0.048,
        m=0)
        annotation (Placement(transformation(extent={{-8,8},{12,28}})));
      IDEAS.Thermal.Components.HeatProduction.HP_AWMod
                          HP(
       medium=TME.FHF.Media.Water(),
       TSet = 45+273.15,
        QNom=5000) annotation (Placement(transformation(extent={{-54,8},{-34,28}})));
      inner Commons.SimInfoManager sim(redeclare Commons.Meteo.Files.min15
          detail, redeclare Commons.Meteo.Locations.Uccle city)
        annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                      pump2(
        medium=TME.FHF.Media.Water(),
        useInput=true,
        m_flowNom=0.048,
        m=0)
        annotation (Placement(transformation(extent={{-6,-52},{14,-32}})));
      IDEAS.Thermal.Components.HeatEmission.Radiator_Old
                          radiator(medium=TME.FHF.Media.Water())
        annotation (Placement(transformation(extent={{34,8},{54,28}})));
      IDEAS.Thermal.Components.HeatEmission.Radiator_Old
                          radiator1(
        medium=TME.FHF.Media.Water(),
        QNom=2000)
        annotation (Placement(transformation(extent={{34,-52},{54,-32}})));
      Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C=1e5)
        annotation (Placement(transformation(extent={{32,54},{52,74}})));
      Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor1(C=1e5)
        annotation (Placement(transformation(extent={{34,-18},{54,2}})));
      Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TAmb1
        annotation (Placement(transformation(extent={{138,42},{118,62}})));
      Modelica.Thermal.HeatTransfer.Components.Convection convection1
        annotation (Placement(transformation(extent={{80,42},{100,62}})));
      Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TAmb2
        annotation (Placement(transformation(extent={{140,-26},{120,-6}})));
      Modelica.Thermal.HeatTransfer.Components.Convection convection2
        annotation (Placement(transformation(extent={{82,-26},{102,-6}})));
      Modelica.Blocks.Sources.Pulse[2] TOpSet(
        each width=67,
        each startTime=3600*7,
        each offset=0,
        period={86400,86400},
        each amplitude=1)
        annotation (Placement(transformation(extent={{-48,60},{-28,80}})));
    equation
       TAmb1.T = sim.Te;
       convection1.Gc = 100;
          TAmb2.T = sim.Te;
       convection2.Gc = 200;
      connect(HP.flowPort_b, pump1.flowPort_a)       annotation (Line(
          points={{-34,18},{-8,18}},
          color={255,0,0},
          thickness=0.5,
          smooth=Smooth.None));
      connect(HP.flowPort_b, pump2.flowPort_a)       annotation (Line(
          points={{-34,18},{-20,18},{-20,-42},{-6,-42}},
          color={255,0,0},
          thickness=0.5,
          smooth=Smooth.None));
      connect(pump1.flowPort_b, radiator.flowPort_a)       annotation (Line(
          points={{12,18},{34,18}},
          color={255,0,0},
          thickness=0.5,
          smooth=Smooth.None));
      connect(radiator.flowPort_b, HP.flowPort_a) annotation (Line(
          points={{54,18},{70,18},{70,-80},{-70,-80},{-70,18},{-54,18}},
          color={255,0,0},
          thickness=0.5,
          smooth=Smooth.None));
      connect(pump2.flowPort_b, radiator1.flowPort_a)       annotation (Line(
          points={{14,-42},{34,-42}},
          color={255,0,0},
          thickness=0.5,
          smooth=Smooth.None));
      connect(radiator1.flowPort_b, HP.flowPort_a) annotation (Line(
          points={{54,-42},{60,-42},{60,-72},{-54,-72},{-54,18}},
          color={255,0,0},
          thickness=0.5,
          smooth=Smooth.None));
      connect(heatCapacitor.port, radiator.heatPortConv) annotation (Line(
          points={{42,54},{42,28},{41,28}},
          color={191,0,0},
          thickness=0.5,
          smooth=Smooth.None));
      connect(heatCapacitor.port, radiator.heatPortRad) annotation (Line(
          points={{42,54},{46,54},{46,28},{49,28}},
          color={191,0,0},
          thickness=0.5,
          smooth=Smooth.None));
      connect(radiator1.heatPortConv, heatCapacitor1.port) annotation (Line(
          points={{41,-32},{42,-32},{42,-18},{44,-18}},
          color={191,0,0},
          thickness=0.5,
          smooth=Smooth.None));
      connect(radiator1.heatPortRad, heatCapacitor1.port) annotation (Line(
          points={{49,-32},{49,-26},{44,-26},{44,-18}},
          color={191,0,0},
          thickness=0.5,
          smooth=Smooth.None));
      connect(convection1.fluid, TAmb1.port)
                                           annotation (Line(
          points={{100,52},{118,52}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(convection2.fluid, TAmb2.port)
                                           annotation (Line(
          points={{102,-16},{120,-16}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(convection2.solid, heatCapacitor1.port) annotation (Line(
          points={{82,-16},{64,-16},{64,-18},{44,-18}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(convection1.solid, heatCapacitor.port) annotation (Line(
          points={{80,52},{62,52},{62,54},{42,54}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(TOpSet[1].y, pump1.m_flowSet) annotation (Line(
          points={{-27,70},{-14,70},{-14,68},{2,68},{2,28}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(TOpSet[2].y, pump2.m_flowSet) annotation (Line(
          points={{-27,70},{-18,70},{-18,-32},{4,-32}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(absolutePressure.flowPort, HP.flowPort_a) annotation (Line(
          points={{-88,50},{-88,18},{-54,18}},
          color={255,0,0},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end HeatingSystem;

    model StorageTank "Thermal storage tank tester"
      import Commons;

      IDEAS.Thermal.Components.BaseClasses.AbsolutePressure
                               absolutePressure(medium=
            TME.FHF.Media.Water(),                p=200000)
        annotation (Placement(transformation(extent={{56,-40},{76,-20}})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                         volumeFlow1(
        medium=TME.FHF.Media.Water(),
        m=4,
        useInput=true,
        TInitial=313.15,
        m_flowNom=0.1)
        annotation (Placement(transformation(extent={{-88,-16},{-68,4}})));
      IDEAS.Thermal.Components.BaseClasses.HeatedPipe
                            boiler(
        medium=TME.FHF.Media.Water(),
        m=5,
        TInitial=313.15) annotation (Placement(transformation(extent={{-54,-16},{-34,
                4}})));
      IDEAS.Thermal.Components.HeatEmission.Radiator_Old
                          radiator(
        medium=TME.FHF.Media.Water()) "Hydraulic radiator model"
                   annotation (Placement(transformation(extent={{52,-16},{72,4}})));
      inner Commons.SimInfoManager sim(redeclare Commons.Meteo.Files.min15
          detail, redeclare Commons.Meteo.Locations.Uccle city)
        annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
      Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
        prescribedTemperature
        annotation (Placement(transformation(extent={{32,24},{52,44}})));
      Modelica.Blocks.Sources.Step step(
        height=2,
        offset=291,
        startTime=10000)
        annotation (Placement(transformation(extent={{-4,24},{16,44}})));
      Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
                                                          prescribedHeatFlow
        annotation (Placement(transformation(extent={{-68,-52},{-48,-32}})));
      IDEAS.Thermal.Components.Storage.StorageTank
                             tank(
        medium=TME.FHF.Media.Water(),
        volumeTank=1,
        nbrNodes=5,
        heightTank=2)                                         annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-10,-32})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                         volumeFlow2(
        medium=TME.FHF.Media.Water(),
        m=4,
        m_flowNom=0.05,
        TInitial=313.15,
        useInput=true)
        annotation (Placement(transformation(extent={{60,-84},{40,-64}})));
      Modelica.Blocks.Logical.OnOffController onOff(bandwidth=5)
        annotation (Placement(transformation(extent={{-86,32},{-66,52}})));
      Modelica.Blocks.Math.BooleanToReal booleanToReal
        annotation (Placement(transformation(extent={{-48,32},{-28,52}})));
      Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=283.15)
        annotation (Placement(transformation(extent={{-4,-64},{16,-44}})));
      Modelica.Blocks.Sources.Pulse pulse1(
        amplitude=1,
        period=3600,
        startTime=2000)
        annotation (Placement(transformation(extent={{28,-54},{48,-34}})));
    equation
    onOff.reference = 60+273.15;
    onOff.u = tank.nodes[1].T;
    prescribedHeatFlow.Q_flow=3000 * booleanToReal.y;

      connect(volumeFlow1.flowPort_b, boiler.flowPort_a)        annotation (Line(
          points={{-68,-6},{-54,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(boiler.flowPort_b, radiator.flowPort_a)             annotation (Line(
          points={{-34,-6},{52,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(absolutePressure.flowPort, radiator.flowPort_a)      annotation (Line(
          points={{56,-30},{48,-30},{48,-6},{52,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(step.y, prescribedTemperature.T) annotation (Line(
          points={{17,34},{30,34}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));
      connect(prescribedTemperature.port, radiator.heatPortConv) annotation (Line(
          points={{52,34},{59,34},{59,4}},
          color={191,0,0},
          thickness=0.5,
          smooth=Smooth.None));
      connect(prescribedTemperature.port, radiator.heatPortRad) annotation (Line(
          points={{52,34},{67,34},{67,4}},
          color={191,0,0},
          thickness=0.5,
          smooth=Smooth.None));
      connect(prescribedHeatFlow.port, boiler.heatPort) annotation (Line(
          points={{-48,-42},{-44,-42},{-44,-16}},
          color={191,0,0},
          thickness=0.5,
          smooth=Smooth.None));
      connect(boiler.flowPort_b, tank.flowPort_a) annotation (Line(
          points={{-34,-6},{-10,-6},{-10,-22}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(radiator.flowPort_b, volumeFlow2.flowPort_a) annotation (Line(
          points={{72,-6},{82,-6},{82,-74},{60,-74}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(onOff.y, booleanToReal.u) annotation (Line(
          points={{-65,42},{-50,42}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(booleanToReal.y, volumeFlow1.m_flowSet) annotation (Line(
          points={{-27,42},{-20,42},{-20,16},{-78,16},{-78,4}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(volumeFlow2.flowPort_b, tank.flowPort_b) annotation (Line(
          points={{40,-74},{-10,-74},{-10,-42}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(tank.flowPort_b, volumeFlow1.flowPort_a) annotation (Line(
          points={{-10,-42},{-10,-74},{-96,-74},{-96,-6},{-88,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(fixedTemperature.port,tank.heatExchEnv)  annotation (Line(
          points={{16,-54},{20,-54},{20,-32},{-3.8,-32}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(pulse1.y, volumeFlow2.m_flowSet) annotation (Line(
          points={{49,-44},{54,-44},{54,-60},{50,-60},{50,-64}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end StorageTank;

    model AmbientTester

    parameter TME.FHF.Interfaces.Medium medium=TME.FHF.Media.Water();
      IDEAS.Thermal.Components.BaseClasses.Ambient
                         ambient(medium = medium,
        constantAmbientPressure=200000,
        constantAmbientTemperature=283.15)
        annotation (Placement(transformation(extent={{-56,0},{-76,20}})));
      IDEAS.Thermal.Components.BaseClasses.HeatedPipe
                            heatedPipe(medium = medium, m=5)
        annotation (Placement(transformation(extent={{-20,0},{0,20}})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                      pump(medium = medium,
        m=4,
        m_flowNom=1)
        annotation (Placement(transformation(extent={{20,0},{40,20}})));
      IDEAS.Thermal.Components.BaseClasses.Ambient
                         ambient1(medium = medium,
        constantAmbientPressure=600000,
        constantAmbientTemperature=313.15)
        annotation (Placement(transformation(extent={{66,0},{86,20}})));
    equation
      connect(ambient.flowPort, heatedPipe.flowPort_a) annotation (Line(
          points={{-56,10},{-20,10}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(heatedPipe.flowPort_b, pump.flowPort_a) annotation (Line(
          points={{0,10},{20,10}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(ambient1.flowPort, pump.flowPort_b) annotation (Line(
          points={{66,10},{40,10}},
          color={255,0,0},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end AmbientTester;

    model TempMixingTester "Test the temperature mixing valve"

      parameter TME.FHF.Interfaces.Medium medium=TME.FHF.Media.Water();

      IDEAS.Thermal.Components.Storage.StorageTank
                             storageTank(
        TInitial={273.15 + 60 for i in 1:storageTank.nbrNodes},
        volumeTank=0.3,
        heightTank=1.6,
        U=0.4,
        medium=medium)
        annotation (Placement(transformation(extent={{2,-64},{-70,10}})));

      IDEAS.Thermal.Components.BaseClasses.Ambient
                         ambient(
        medium=medium,
        constantAmbientPressure=500000,
        constantAmbientTemperature=283.15)
        annotation (Placement(transformation(extent={{54,-92},{74,-72}})));
      IDEAS.Thermal.Components.BaseClasses.Ambient
                         ambient1(
        medium=medium,
        constantAmbientPressure=400000,
        constantAmbientTemperature=283.15)
        annotation (Placement(transformation(extent={{74,16},{94,36}})));
      IDEAS.Thermal.Components.BaseClasses.IdealMixer
                                   temperatureMixing(
        medium=medium,
        mFlowMin=0.01)
        annotation (Placement(transformation(extent={{2,16},{22,36}})));
      Modelica.Blocks.Sources.Pulse pulse(
        period=86400,
        startTime=7*3600,
        width=50) annotation (Placement(transformation(extent={{16,66},{36,86}})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                      pump1(
        medium=medium,
        m_flowNom=0.1,
        m=0,
        TInitial=283.15,
        useInput=true)
        annotation (Placement(transformation(extent={{38,16},{58,36}})));
    equation
      temperatureMixing.TMixedSet=273.15+35;
      connect(storageTank.flowPort_a, temperatureMixing.flowPortHot) annotation (
          Line(
          points={{-34,10},{-16,10},{-16,26},{2,26}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(ambient.flowPort, storageTank.flowPort_b) annotation (Line(
          points={{54,-82},{-34,-82},{-34,-64}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(ambient.flowPort, temperatureMixing.flowPortCold) annotation (Line(
          points={{54,-82},{38,-82},{38,-80},{12,-80},{12,16}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(temperatureMixing.flowPortMixed, pump1.flowPort_a) annotation (Line(
          points={{22,26},{38,26}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(pump1.flowPort_b, ambient1.flowPort) annotation (Line(
          points={{58,26},{74,26}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(pulse.y, pump1.m_flowSet) annotation (Line(
          points={{37,76},{48,76},{48,36}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end TempMixingTester;

    model DHWTester "Test the DHW component"

      parameter TME.FHF.Interfaces.Medium medium=TME.FHF.Media.Water();

      IDEAS.Thermal.Components.Storage.StorageTank
                             storageTank(
        TInitial={273.15 + 60 for i in 1:storageTank.nbrNodes},
        volumeTank=0.3,
        heightTank=1.6,
        UA=0.4,
        medium=medium)
        annotation (Placement(transformation(extent={{42,-64},{-30,10}})));

      IDEAS.Thermal.Components.BaseClasses.DomesticHotWater
               dHW(medium = medium,
        VDayAvg=0.2,
        TDHWSet=273.15 + 45,
        profileType=3)
        annotation (Placement(transformation(extent={{46,-30},{66,-10}})));
      IDEAS.Thermal.Components.HeatProduction.HP_AWMod
                          hP_AWMod(TSet = HPControl.THPSet, QNom=10000, medium=medium)
        annotation (Placement(transformation(extent={{-72,-6},{-52,14}})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                      pump(medium = medium,
        m=1,
        m_flowNom=0.5,
        useInput=true)
        annotation (Placement(transformation(extent={{-36,-74},{-56,-54}})));
      inner Commons.SimInfoManager sim(redeclare Commons.Meteo.Files.min15
          detail, redeclare Commons.Meteo.Locations.Uccle city)
                  annotation (Placement(transformation(extent={{8,62},{28,82}})));
      IDEAS.Thermal.Control.HPControl_HeatingCurve
                                      HPControl(
        TTankTop = storageTank.nodes[1].T,
        TTankBot = storageTank.nodes[4].T,
        dTSafetyTop=3,
        dTHPTankSet=2,
        DHW=true,
        TDHWSet=318.15)
        annotation (Placement(transformation(extent={{-48,34},{-28,54}})));
      Modelica.Blocks.Sources.Pulse pulse(period=3600)
        annotation (Placement(transformation(extent={{-72,-34},{-52,-14}})));
    equation
      //pump.m_flowSet = HPControl.onOff;
      pump.m_flowSet = HPControl.onOff;
      connect(dHW.flowPortCold, storageTank.flowPort_b) annotation (Line(
          points={{56,-30},{58,-30},{58,-64},{6,-64}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(dHW.flowPortHot, storageTank.flowPort_a) annotation (Line(
          points={{56,-10},{56,12},{6,12},{6,10}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(storageTank.flowPort_b, pump.flowPort_a) annotation (Line(
          points={{6,-64},{-36,-64}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(pump.flowPort_b, hP_AWMod.flowPort_a) annotation (Line(
          points={{-56,-64},{-78,-64},{-78,4},{-72,4}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(hP_AWMod.flowPort_b, storageTank.flowPort_a) annotation (Line(
          points={{-52,4},{-24,4},{-24,10},{6,10}},
          color={255,0,0},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end DHWTester;

    model MixingVolumeTester "Test the mixing volume component"

      parameter TME.FHF.Interfaces.Medium medium=TME.FHF.Media.Water();

      IDEAS.Thermal.Components.BaseClasses.Ambient
                         ambient(medium = medium,
        constantAmbientPressure=200000,
        constantAmbientTemperature=283.15)
        annotation (Placement(transformation(extent={{-46,10},{-66,30}})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                      pump(medium = medium,
        m=4,
        m_flowNom=1)
        annotation (Placement(transformation(extent={{30,10},{50,30}})));
      IDEAS.Thermal.Components.BaseClasses.Ambient
                         ambient1(medium = medium,
        constantAmbientPressure=600000,
        constantAmbientTemperature=313.15)
        annotation (Placement(transformation(extent={{76,10},{96,30}})));
      IDEAS.Thermal.Components.BaseClasses.MixingVolume
                              mixingVolume(
        medium=medium,
        nbrPorts=3,
        m=10) annotation (Placement(transformation(extent={{-14,42},{6,62}})));
      IDEAS.Thermal.Components.BaseClasses.Ambient
                         ambient2(medium = medium,
        constantAmbientPressure=1000000,
        constantAmbientTemperature=313.15)
        annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                      pump1(
                           medium = medium,
        m=4,
        useInput=true,
        m_flowNom=0.5)
        annotation (Placement(transformation(extent={{-22,-18},{-2,2}})));
      Modelica.Blocks.Sources.Step step(startTime=500)
        annotation (Placement(transformation(extent={{-92,-14},{-72,6}})));
    equation
      connect(ambient1.flowPort,pump. flowPort_b) annotation (Line(
          points={{76,20},{50,20}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(ambient.flowPort, mixingVolume.flowPorts[1]) annotation (Line(
          points={{-46,20},{-10,20},{-10,30},{-4,30},{-4,41.3333}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(mixingVolume.flowPorts[2], pump.flowPort_a) annotation (Line(
          points={{-4,42},{-4,20},{30,20}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(ambient2.flowPort, pump1.flowPort_a) annotation (Line(
          points={{-20,-40},{-36,-40},{-36,-8},{-22,-8}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(pump1.flowPort_b, mixingVolume.flowPorts[3]) annotation (Line(
          points={{-2,-8},{-2,42.6667},{-4,42.6667}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(step.y, pump1.m_flowSet) annotation (Line(
          points={{-71,-4},{-42,-4},{-42,2},{-12,2}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end MixingVolumeTester;

    model DHWTester_badmixing "Test the DHW component"

      parameter TME.FHF.Interfaces.Medium medium=TME.FHF.Media.Water();

      IDEAS.Thermal.Components.Storage.StorageTank
                             storageTank(
        TInitial={273.15 + 60 for i in 1:storageTank.nbrNodes},
        volumeTank=0.3,
        heightTank=1.6,
        UA=0.4,
        medium=medium)
        annotation (Placement(transformation(extent={{30,-64},{-8,4}})));

      IDEAS.Thermal.HeatingSystems.DHW_MixingVolume
               dHW(medium = medium,
        TDHWSet=273.15 + 35,
        VDayAvg=0.001)
        annotation (Placement(transformation(extent={{48,-30},{68,-10}})));
      IDEAS.Thermal.Components.HeatProduction.HP_AWMod
                          hP_AWMod(TSet = HPControl.THPSet, QNom=20000, medium=medium)
        annotation (Placement(transformation(extent={{-72,-6},{-52,14}})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                      pump(medium = medium,
        m=1,
        m_flowNom=0.5,
        useInput=true)
        annotation (Placement(transformation(extent={{-36,-74},{-56,-54}})));
      inner Commons.SimInfoManager sim(redeclare Commons.Meteo.Files.min15
          detail, redeclare Commons.Meteo.Locations.Uccle city)
                  annotation (Placement(transformation(extent={{8,62},{28,82}})));
      IDEAS.Thermal.Control.HPControl_HeatingCurve
                                      HPControl(
        TTankTop = storageTank.nodes[1].T,
        TTankBot = storageTank.nodes[4].T,
        dTSafetyTop=3,
        dTHPTankSet=2)
        annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
      Modelica.Blocks.Sources.Pulse pulse(period=3600)
        annotation (Placement(transformation(extent={{-80,34},{-60,54}})));
    equation
      pump.m_flowSet = HPControl.onOff;

      connect(dHW.flowPortCold, storageTank.flowPort_b) annotation (Line(
          points={{58,-30},{58,-64},{11,-64}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(dHW.flowPortHot, storageTank.flowPort_a) annotation (Line(
          points={{58,-10},{58,4},{11,4}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(storageTank.flowPort_b, pump.flowPort_a) annotation (Line(
          points={{11,-64},{-36,-64}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(pump.flowPort_b, hP_AWMod.flowPort_a) annotation (Line(
          points={{-56,-64},{-78,-64},{-78,4},{-72,4}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(hP_AWMod.flowPort_b, storageTank.flowPort_a) annotation (Line(
          points={{-52,4},{11,4}},
          color={255,0,0},
          smooth=Smooth.None));
       annotation (Diagram(graphics));
    end DHWTester_badmixing;

    model RadiatorCoolingDown

      IDEAS.Thermal.Components.HeatEmission.Radiator_Old
                              radiator_new(
        medium=TME.FHF.Media.Water(),
        QNom=1000,
        TInitial=333.15)
        annotation (Placement(transformation(extent={{-64,76},{-44,56}})));
      IDEAS.Thermal.Components.HeatEmission.Radiator_Old
                              radiator_new1(
        medium=TME.FHF.Media.Water(),
        QNom=2000,
        TInitial=333.15)
        annotation (Placement(transformation(extent={{-64,-10},{-44,10}})));
      Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=294.15)
        annotation (Placement(transformation(extent={{-14,20},{-34,40}})));
      IDEAS.Thermal.Components.BaseClasses.Ambient
                         ambient(
        medium=TME.FHF.Media.Water(),
        usePressureInput=false,
        constantAmbientPressure=200000,
        constantAmbientTemperature=333.15)
        annotation (Placement(transformation(extent={{-90,16},{-70,36}})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                      pump(
        medium=TME.FHF.Media.Water(),
        m_flowNom=0.05,
        m=1,
        useInput=true)
        annotation (Placement(transformation(extent={{-20,56},{0,76}})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                      pump1(
        medium=TME.FHF.Media.Water(),
        m=1,
        m_flowNom=0.05,
        useInput=true)
        annotation (Placement(transformation(extent={{-18,-10},{2,10}})));
      IDEAS.Thermal.Components.BaseClasses.Ambient
                         ambient1(
        medium=TME.FHF.Media.Water(),
        constantAmbientPressure=300000,
        constantAmbientTemperature=283.15)
        annotation (Placement(transformation(extent={{48,14},{68,34}})));
      IDEAS.Thermal.Components.HeatEmission.Radiator_Old
                              radiator_new2(
        medium=TME.FHF.Media.Water(),
        QNom=1000,
        powerFactor=3.37,
        TInNom=318.15,
        TOutNom=308.15,
        TInitial=333.15)
        annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                      pump2(
        medium=TME.FHF.Media.Water(),
        m=1,
        m_flowNom=0.05,
        useInput=true)
        annotation (Placement(transformation(extent={{-14,-50},{6,-30}})));
    equation
      pump.m_flowSet = if time > 1 then 0 else 1;
      pump1.m_flowSet = if time > 1 then 0 else 1;
      pump2.m_flowSet = if time > 1 then 0 else 1;
      connect(fixedTemperature.port, radiator_new.heatPortConv) annotation (Line(
          points={{-34,30},{-57,30},{-57,56}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(fixedTemperature.port, radiator_new.heatPortRad) annotation (Line(
          points={{-34,30},{-49,30},{-49,56}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(fixedTemperature.port, radiator_new1.heatPortConv) annotation (Line(
          points={{-34,30},{-57,30},{-57,10}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(fixedTemperature.port, radiator_new1.heatPortRad) annotation (Line(
          points={{-34,30},{-50,30},{-50,10},{-49,10}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(ambient.flowPort, radiator_new.flowPort_a) annotation (Line(
          points={{-90,26},{-96,26},{-96,66},{-64,66}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(ambient.flowPort, radiator_new1.flowPort_a) annotation (Line(
          points={{-90,26},{-96,26},{-96,0},{-64,0}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(radiator_new1.flowPort_b, pump1.flowPort_a) annotation (Line(
          points={{-44,0},{-18,0}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(radiator_new.flowPort_b, pump.flowPort_a) annotation (Line(
          points={{-44,66},{-20,66}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(pump.flowPort_b, ambient1.flowPort) annotation (Line(
          points={{0,66},{48,66},{48,24}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(ambient1.flowPort, pump1.flowPort_b) annotation (Line(
          points={{48,24},{50,24},{50,0},{2,0}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(radiator_new2.flowPort_b,pump2. flowPort_a) annotation (Line(
          points={{-40,-40},{-14,-40}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(fixedTemperature.port, radiator_new2.heatPortConv) annotation (Line(
          points={{-34,30},{-36,30},{-36,-16},{-53,-16},{-53,-30}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(fixedTemperature.port, radiator_new2.heatPortRad) annotation (Line(
          points={{-34,30},{-36,30},{-36,-20},{-45,-20},{-45,-30}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(pump2.flowPort_b, ambient1.flowPort) annotation (Line(
          points={{6,-40},{48,-40},{48,24}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(ambient.flowPort, radiator_new2.flowPort_a) annotation (Line(
          points={{-90,26},{-96,26},{-96,-40},{-60,-40}},
          color={255,0,0},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end RadiatorCoolingDown;

    model RadTester_EnergyBalance
      "Test for energy balance of the radiator model"
      import Commons;

      Real QBoiler( start = 0);
      Real QRadiator( start = 0);

      IDEAS.Thermal.Components.BaseClasses.AbsolutePressure
                               absolutePressure(medium=
            TME.FHF.Media.Water(),                p=200000)
        annotation (Placement(transformation(extent={{50,-52},{70,-32}})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                         volumeFlow1(
        medium=TME.FHF.Media.Water(),
        m=4,
        m_flowNom=0.05,
        TInitial=293.15,
        useInput=true)
        annotation (Placement(transformation(extent={{-36,-16},{-16,4}})));
      IDEAS.Thermal.Components.BaseClasses.HeatedPipe
                            boiler(
        medium=TME.FHF.Media.Water(),
        m=5,
        TInitial=293.15) annotation (Placement(transformation(extent={{12,-16},{32,4}})));
      IDEAS.Thermal.Components.HeatEmission.Radiator_Old
                          radiator(
        medium=TME.FHF.Media.Water(),
                              QNom=3000,
        TInNom=318.15,
        TOutNom=308.15,
        powerFactor=3.37) "Hydraulic radiator model"
                   annotation (Placement(transformation(extent={{52,-16},{72,4}})));
      inner Commons.SimInfoManager sim(redeclare Commons.Meteo.Files.min15
          detail, redeclare Commons.Meteo.Locations.Uccle city)
        annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
      Modelica.Thermal.HeatTransfer.Sources.FixedTemperature
        prescribedTemperature(T=293.15)
        annotation (Placement(transformation(extent={{32,24},{52,44}})));
      Modelica.Blocks.Sources.Pulse step(
        startTime=10000,
        offset=0,
        amplitude=3000,
        period=10000,
        nperiod=3)
        annotation (Placement(transformation(extent={{-62,-50},{-42,-30}})));
      Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
                                                          boilerHeatFlow
        annotation (Placement(transformation(extent={{-12,-50},{8,-30}})));
      Modelica.Blocks.Sources.Pulse step1(
        startTime=10000,
        offset=0,
        period=10000,
        amplitude=1,
        nperiod=5)
        annotation (Placement(transformation(extent={{-56,30},{-36,50}})));
    equation
    der(QBoiler) = boilerHeatFlow.Q_flow;
    der(QRadiator) = -radiator.heatPortConv.Q_flow - radiator.heatPortRad.Q_flow;

      connect(volumeFlow1.flowPort_b, boiler.flowPort_a)        annotation (Line(
          points={{-16,-6},{12,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(boiler.flowPort_b, radiator.flowPort_a)             annotation (Line(
          points={{32,-6},{52,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(radiator.flowPort_b, volumeFlow1.flowPort_a)      annotation (Line(
          points={{72,-6},{82,-6},{82,-62},{-76,-62},{-76,-6},{-36,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(absolutePressure.flowPort, radiator.flowPort_a)      annotation (Line(
          points={{50,-42},{50,-30},{48,-30},{48,-6},{52,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(prescribedTemperature.port, radiator.heatPortConv) annotation (Line(
          points={{52,34},{59,34},{59,4}},
          color={191,0,0},
          thickness=0.5,
          smooth=Smooth.None));
      connect(prescribedTemperature.port, radiator.heatPortRad) annotation (Line(
          points={{52,34},{67,34},{67,4}},
          color={191,0,0},
          thickness=0.5,
          smooth=Smooth.None));
      connect(boilerHeatFlow.port, boiler.heatPort) annotation (Line(
          points={{8,-40},{14,-40},{14,-38},{22,-38},{22,-16}},
          color={191,0,0},
          thickness=0.5,
          smooth=Smooth.None));
      connect(step.y, boilerHeatFlow.Q_flow) annotation (Line(
          points={{-41,-40},{-12,-40}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(step1.y, volumeFlow1.m_flowSet) annotation (Line(
          points={{-35,40},{-26,40},{-26,4}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end RadTester_EnergyBalance;

    model FloorHeatingTester "Simple floorheating tester"

      /*
  This test model is checking the tabs power and outlet temperature for different cases
  - step up on the input temp
  - step down on the input temp
  - step up in flowrate
  - step down in flowrate
  
  Check all the reactions to these steps carefully before using a tabs model.
    
  */
      import Commons;

      parameter TME.FHF.Interfaces.Medium medium=TME.FHF.Media.Water();
      parameter Modelica.SIunits.Area A_Floor=20;

      IDEAS.Thermal.Components.BaseClasses.AbsolutePressure
                               absolutePressure(medium=medium, p=200000)
        annotation (Placement(transformation(extent={{34,-54},{54,-34}})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                         volumeFlow1(
        medium=medium,
        m_flowNom=300/3600,
        useInput=true,
        m=0,
        TInitial=293.15)
        annotation (Placement(transformation(extent={{-36,-16},{-16,4}})));
      replaceable IDEAS.Thermal.Components.HeatEmission.Tabs
                                                       tabs(
        medium=medium,
        m_flowMin=15*20/3600,
        A_Floor=A_Floor,
        redeclare IDEAS.Thermal.Components.HeatEmission.FH_Standard2
                                                               FHChars)
         constrainedby
        IDEAS.Thermal.Components.HeatEmission.Auxiliaries.Partial_Tabs(
           medium=medium,
           m_flowMin=15*20/3600,
           A_Floor=A_Floor,
           redeclare TME.FHF.Components.HeatEmission.FH_Standard2 FHChars)
        "tabs model"
                   annotation (Placement(transformation(extent={{68,2},{88,22}})));
      inner Commons.SimInfoManager sim(redeclare Commons.Meteo.Files.min15
          detail, redeclare Commons.Meteo.Locations.Uccle city)
        annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
      Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
        prescribedTemperature
        annotation (Placement(transformation(extent={{32,24},{52,44}})));
      Modelica.Blocks.Sources.Sine step(
        startTime=50000,
        offset=293.15,
        amplitude=2,
        freqHz=1/86400)
        annotation (Placement(transformation(extent={{-10,72},{10,92}})));
      Modelica.Thermal.HeatTransfer.Components.Convection convection
        annotation (Placement(transformation(extent={{88,64},{68,44}})));
      Modelica.Blocks.Sources.TimeTable tempTable(
        offset=0,
        startTime=0,
        table=[0,293.15; 5000,293.15; 5000,303.15; 150000,303.15; 150000,293.15;
            300000,293.15])
        annotation (Placement(transformation(extent={{-50,-38},{-36,-24}})));
      IDEAS.Thermal.Components.BaseClasses.HeatedPipe
                            heatedPipe(medium=medium, m=0)
        annotation (Placement(transformation(extent={{-28,-86},{-8,-66}})));
      IDEAS.Thermal.Components.BaseClasses.HeatedPipe
                            heatedPipe1(medium=medium, m=0)
        annotation (Placement(transformation(extent={{8,-16},{28,4}})));
      Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
        prescribedTemperature1
        annotation (Placement(transformation(extent={{-10,-48},{10,-28}})));
      Modelica.Blocks.Sources.TimeTable m_flowTable(
        offset=0,
        startTime=0,
        table=[0,0; 500,0; 500,1; 20000,1; 20000,0; 25000,0; 25000,1; 40000,1;
            40000,0; 45000,0])
        annotation (Placement(transformation(extent={{-74,32},{-54,52}})));
      Modelica.Blocks.Sources.Constant const(k=293.15)
        annotation (Placement(transformation(extent={{-10,40},{10,60}})));
      Modelica.Blocks.Sources.Constant const1(k=1)
        annotation (Placement(transformation(extent={{-74,2},{-54,22}})));
      Modelica.Blocks.Sources.Step const2(
        height=10,
        offset=293.15,
        startTime=5000)
        annotation (Placement(transformation(extent={{-50,-62},{-36,-48}})));
    equation
      convection.Gc = 11*A_Floor;

      connect(absolutePressure.flowPort, tabs.flowPort_a)          annotation (Line(
          points={{34,-44},{34,-30},{48,-30},{48,16},{68,16}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(tabs.port_a, convection.solid) annotation (Line(
          points={{78,22},{80,22},{80,32},{94,32},{94,54},{88,54}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(convection.fluid, prescribedTemperature.port) annotation (Line(
          points={{68,54},{62,54},{62,34},{52,34}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(tabs.flowPort_b, heatedPipe.flowPort_b) annotation (Line(
          points={{68,8},{62,8},{62,-76},{-8,-76}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(heatedPipe.flowPort_a, volumeFlow1.flowPort_a) annotation (Line(
          points={{-28,-76},{-42,-76},{-42,-74},{-62,-74},{-62,-6},{-36,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(volumeFlow1.flowPort_b, heatedPipe1.flowPort_a) annotation (Line(
          points={{-16,-6},{8,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(heatedPipe1.flowPort_b, tabs.flowPort_a) annotation (Line(
          points={{28,-6},{34,-6},{34,-4},{44,-4},{44,16},{68,16}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(prescribedTemperature1.port, heatedPipe1.heatPort) annotation (Line(
          points={{10,-38},{18,-38},{18,-16}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(const.y, prescribedTemperature.T) annotation (Line(
          points={{11,50},{18,50},{18,34},{30,34}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(const1.y, volumeFlow1.m_flowSet) annotation (Line(
          points={{-53,12},{-26,4}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(tempTable.y, prescribedTemperature1.T) annotation (Line(
          points={{-35.3,-31},{-22,-31},{-22,-38},{-12,-38}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(graphics),
        experiment(StopTime=40000, Interval=10),
        __Dymola_experimentSetupOutput,
        Commands(file="Scripts/Tester_FloorHeating.mos" "RunTester"));
    end FloorHeatingTester;

    model FloorHeatingValidation
      "Testing the floorheating according to Koschenz, par. 4.5.1"
      import Commons;

      parameter TME.FHF.Interfaces.Medium medium=TME.FHF.Media.Water();

      IDEAS.Thermal.Components.BaseClasses.AbsolutePressure
                               absolutePressure(medium=medium, p=200000)
        annotation (Placement(transformation(extent={{34,-54},{54,-34}})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                         volumeFlow1(
        medium=medium,
        m=4,
        useInput=true,
        TInitial=303.15,
        m_flowNom=12*24/3600)
        annotation (Placement(transformation(extent={{-36,-16},{-16,4}})));
      IDEAS.Thermal.Components.HeatEmission.Tabs
                      tabs(
        medium=medium,
        A_Floor=24,
        redeclare IDEAS.Thermal.Components.HeatEmission.FH_ValidationEmpa
                                                                    FHChars,
        m_flowMin=12*24/3600) "tabs model"
                   annotation (Placement(transformation(extent={{68,2},{88,22}})));
      inner Commons.SimInfoManager sim(redeclare Commons.Meteo.Files.min15
          detail, redeclare Commons.Meteo.Locations.Uccle city)
        annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
      Modelica.Thermal.HeatTransfer.Sources.FixedTemperature
        prescribedTemperature(T=293.15)
        annotation (Placement(transformation(extent={{8,64},{28,84}})));
      IDEAS.Thermal.Components.BaseClasses.HeatedPipe
                            heatedPipe(
        medium=medium,
        m=5,
        TInitial=303.15)
        annotation (Placement(transformation(extent={{0,-16},{20,6}})));
      Modelica.Thermal.HeatTransfer.Components.Convection convection annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={78,46})));
      Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TSet
        annotation (Placement(transformation(extent={{-28,-50},{-8,-30}})));
      Modelica.Blocks.Sources.Pulse pulse(
        period=7200,
        offset=0,
        startTime=0)
                  annotation (Placement(transformation(extent={{-58,30},{-38,50}})));
    equation
      TSet.T = smooth(1, if time < 5*3600 then 273.15+30 else 273.15+20);
      //TSet.T = 273.15+15;
      convection.Gc = 11;

      connect(tabs.flowPort_b, volumeFlow1.flowPort_a)          annotation (Line(
          points={{68,8},{56,8},{56,-60},{-76,-60},{-76,-6},{-36,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(absolutePressure.flowPort, tabs.flowPort_a)          annotation (Line(
          points={{34,-44},{34,-30},{48,-30},{48,16},{68,16}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(volumeFlow1.flowPort_b, heatedPipe.flowPort_a) annotation (Line(
          points={{-16,-6},{-8,-6},{-8,-5},{0,-5}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(heatedPipe.flowPort_b, tabs.flowPort_a) annotation (Line(
          points={{20,-5},{26,-5},{26,-2},{32,-2},{32,16},{68,16}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(tabs.port_a, convection.solid) annotation (Line(
          points={{78,22},{78,36}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(convection.fluid, prescribedTemperature.port) annotation (Line(
          points={{78,56},{50,56},{50,74},{28,74}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(TSet.port, heatedPipe.heatPort) annotation (Line(
          points={{-8,-40},{2,-40},{2,-38},{10,-38},{10,-16}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(tabs.port_b, convection.solid) annotation (Line(
          points={{78,2.2},{78,-8},{98,-8},{98,30},{78,30},{78,36}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(pulse.y, volumeFlow1.m_flowSet) annotation (Line(
          points={{-37,40},{-26,40},{-26,4}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end FloorHeatingValidation;

    model FloorHeatingValidation2
      "Testing the floorheating according to Koschenz, par. 4.6"
      import Commons;

      parameter TME.FHF.Interfaces.Medium medium=TME.FHF.Media.Water();

      IDEAS.Thermal.Components.BaseClasses.AbsolutePressure
                               absolutePressure(medium=medium, p=200000)
        annotation (Placement(transformation(extent={{34,-54},{54,-34}})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                         volumeFlow1(
        medium=medium,
        m=4,
        useInput=true,
        TInitial=303.15,
        m_flowNom=15*24/3600)
        annotation (Placement(transformation(extent={{-36,-16},{-16,4}})));
      IDEAS.Thermal.Components.HeatEmission.Tabs
                      tabs(
        medium=medium,
        S_1=0.1,
        redeclare IDEAS.Thermal.Components.HeatEmission.FH_Standard2
                                                  FHChars,
        S_2=0.2,
        A_Floor=24,
        m_flowMin=15*24/3600,
        lambda_b=1.8,
        n1=3,
        n2=3) "tabs model"
                   annotation (Placement(transformation(extent={{68,2},{88,22}})));
      inner Commons.SimInfoManager sim(redeclare Commons.Meteo.Files.min15
          detail, redeclare Commons.Meteo.Locations.Uccle city)
        annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
      Modelica.Thermal.HeatTransfer.Sources.FixedTemperature
        prescribedTemperature(T=293.15)
        annotation (Placement(transformation(extent={{8,64},{28,84}})));
      IDEAS.Thermal.Components.BaseClasses.HeatedPipe
                            heatedPipe(
        medium=medium,
        m=5,
        TInitial=303.15)
        annotation (Placement(transformation(extent={{0,-16},{20,6}})));
      Modelica.Thermal.HeatTransfer.Components.Convection convection annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={78,46})));
      Modelica.Blocks.Sources.Pulse pulse(
        period=7200,
        startTime=1e7,
        offset=1) annotation (Placement(transformation(extent={{-58,30},{-38,50}})));
      Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow=-24*20)
        annotation (Placement(transformation(extent={{-30,-48},{-10,-28}})));
    equation
      //TSet.T = smooth(1, if time < 5*3600 then 273.15+30 else 273.15+20);
      //TSet.T = 273.15+15;
      convection.Gc = 11;

      connect(tabs.flowPort_b, volumeFlow1.flowPort_a)          annotation (Line(
          points={{68,8},{56,8},{56,-60},{-76,-60},{-76,-6},{-36,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(absolutePressure.flowPort, tabs.flowPort_a)          annotation (Line(
          points={{34,-44},{34,-30},{48,-30},{48,16},{68,16}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(volumeFlow1.flowPort_b, heatedPipe.flowPort_a) annotation (Line(
          points={{-16,-6},{-8,-6},{-8,-5},{0,-5}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(heatedPipe.flowPort_b, tabs.flowPort_a) annotation (Line(
          points={{20,-5},{26,-5},{26,-2},{32,-2},{32,16},{68,16}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(tabs.port_a, convection.solid) annotation (Line(
          points={{78,22},{78,36}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(convection.fluid, prescribedTemperature.port) annotation (Line(
          points={{78,56},{50,56},{50,74},{28,74}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(pulse.y, volumeFlow1.m_flowSet) annotation (Line(
          points={{-37,40},{-26,40},{-26,4}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(fixedHeatFlow.port, heatedPipe.heatPort) annotation (Line(
          points={{-10,-38},{10,-38},{10,-16}},
          color={191,0,0},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end FloorHeatingValidation2;

    model MixingTester2 "Simple mixing tester"
      import Commons;

      IDEAS.Thermal.Components.BaseClasses.Pump
                         volumeFlow1(
        medium=TME.FHF.Media.Water(),
        m=4,
        TInitial=313.15,
        m_flowNom=0.05)
        annotation (Placement(transformation(extent={{76,-86},{56,-66}})));
      IDEAS.Thermal.Components.BaseClasses.HeatedPipe
                            boiler(
        medium=TME.FHF.Media.Water(),
        m=5,
        TInitial=313.15) annotation (Placement(transformation(extent={{-26,-16},{-6,
                4}})));
      IDEAS.Thermal.Components.HeatEmission.Radiator_Old
                          radiator(
        medium=TME.FHF.Media.Water(),
                              QNom=3000) "Hydraulic radiator model"
                   annotation (Placement(transformation(extent={{52,-16},{72,4}})));
      inner Commons.SimInfoManager sim(redeclare Commons.Meteo.Files.min15
          detail, redeclare Commons.Meteo.Locations.Uccle city)
        annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
      Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
        prescribedTemperature
        annotation (Placement(transformation(extent={{32,24},{52,44}})));
      Modelica.Blocks.Sources.Step step(
        height=2,
        offset=291,
        startTime=10000)
        annotation (Placement(transformation(extent={{-4,24},{16,44}})));
      Modelica.Thermal.HeatTransfer.Sources.FixedTemperature
                                                          fixedHeatFlow(T=333.15)
        annotation (Placement(transformation(extent={{-50,-52},{-30,-32}})));

      IDEAS.Thermal.Components.BaseClasses.IdealMixer
                                       idealMixer_NotWorking(mFlowMin=0.01)
        annotation (Placement(transformation(extent={{10,-16},{30,4}})));
      IDEAS.Thermal.Components.BaseClasses.AbsolutePressure
                                  absolutePressure
        annotation (Placement(transformation(extent={{54,-58},{74,-38}})));
    equation
      idealMixer_NotWorking.TMixedSet = 273.15+45;
      connect(volumeFlow1.flowPort_b, boiler.flowPort_a)        annotation (Line(
          points={{56,-76},{-70,-76},{-70,-6},{-26,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(radiator.flowPort_b, volumeFlow1.flowPort_a)      annotation (Line(
          points={{72,-6},{82,-6},{82,-68},{94,-68},{94,-76},{76,-76}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(step.y, prescribedTemperature.T) annotation (Line(
          points={{17,34},{30,34}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));
      connect(prescribedTemperature.port, radiator.heatPortConv) annotation (Line(
          points={{52,34},{59,34},{59,4}},
          color={191,0,0},
          thickness=0.5,
          smooth=Smooth.None));
      connect(prescribedTemperature.port, radiator.heatPortRad) annotation (Line(
          points={{52,34},{67,34},{67,4}},
          color={191,0,0},
          thickness=0.5,
          smooth=Smooth.None));
      connect(fixedHeatFlow.port, boiler.heatPort) annotation (Line(
          points={{-30,-42},{-16,-42},{-16,-16}},
          color={191,0,0},
          thickness=0.5,
          smooth=Smooth.None));
      connect(boiler.flowPort_b, idealMixer_NotWorking.flowPortHot) annotation (
          Line(
          points={{-6,-6},{10,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(idealMixer_NotWorking.flowPortMixed, radiator.flowPort_a) annotation (
         Line(
          points={{30,-6},{52,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(volumeFlow1.flowPort_b, idealMixer_NotWorking.flowPortCold)
        annotation (Line(
          points={{56,-76},{20,-76},{20,-16}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(absolutePressure.flowPort, radiator.flowPort_a) annotation (Line(
          points={{54,-48},{38,-48},{38,-6},{52,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end MixingTester2;

    model TestStratifier
      parameter TME.FHF.Interfaces.Medium medium=TME.FHF.Media.Water()
        "Medium in the tank";
      //parameter Real[5] TInitial =

      IDEAS.Thermal.Components.Storage.StorageTank
                             storageTank(
        medium=medium,
        nbrNodes=5,
        heightTank=2,
        TInitial=  340:-10:300,
        volumeTank=0.2)
        annotation (Placement(transformation(extent={{-2,12},{18,32}})));
      IDEAS.Thermal.Components.Storage.StratifiedInlet
                                 stratifiedInlet(medium=medium, nbrNodes=5, TNodes = storageTank.nodes.T)
        annotation (Placement(transformation(extent={{-58,12},{-38,32}})));
      IDEAS.Thermal.Components.BaseClasses.AbsolutePressure
                                  absolutePressure(medium=medium, p=200000)
        annotation (Placement(transformation(extent={{28,-12},{48,8}})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                      pump(
        medium=medium,
        m=1,
        m_flowNom=0.05,
        useInput=true)
        annotation (Placement(transformation(extent={{-14,-22},{-34,-2}})));
      IDEAS.Thermal.Components.BaseClasses.HeatedPipe
                            heatedPipe(medium=medium, m=2,
        TInitial=278.15)
        annotation (Placement(transformation(extent={{-78,-22},{-58,-2}})));
      Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow=1000)
        annotation (Placement(transformation(extent={{-100,-54},{-80,-34}})));
      Modelica.Blocks.Sources.Pulse pulse(period=300)
        annotation (Placement(transformation(extent={{-46,-66},{-26,-46}})));
    equation
      connect(storageTank.flowPort_b, pump.flowPort_a) annotation (Line(
          points={{8,12},{8,-12},{-14,-12}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(pump.flowPort_b, heatedPipe.flowPort_b) annotation (Line(
          points={{-34,-12},{-58,-12}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(heatedPipe.flowPort_a, stratifiedInlet.flowPort_a) annotation (Line(
          points={{-78,-12},{-88,-12},{-88,22},{-58,22}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(stratifiedInlet.flowPorts, storageTank.flowPorts) annotation (Line(
          points={{-38,22},{-2,22}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(absolutePressure.flowPort, storageTank.flowPort_b) annotation (Line(
          points={{28,-2},{8,-2},{8,12}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(fixedHeatFlow.port, heatedPipe.heatPort) annotation (Line(
          points={{-80,-44},{-68,-44},{-68,-22}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(pulse.y, pump.m_flowSet) annotation (Line(
          points={{-25,-56},{-8,-56},{-8,8},{-24,8},{-24,-2}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end TestStratifier;

    model HPBW_Tester "Identical as the one in FluidHeatFlow_NoPressure"
      import Commons;

      IDEAS.Thermal.Components.BaseClasses.AbsolutePressure
                               absolutePressure(medium=
            TME.FHF.Media.Water(),                p=200000)
        annotation (Placement(transformation(extent={{58,62},{78,82}})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                         volumeFlow1(
        medium=TME.FHF.Media.Water(),
        m=1,
        m_flowNom=0.3,
        useInput=true)
        annotation (Placement(transformation(extent={{-36,-16},{-16,4}})));
      IDEAS.Thermal.Components.BaseClasses.HeatedPipe
                            isolatedPipe1(
        medium=TME.FHF.Media.Water(),
        m=5,
        TInitial=313.15) annotation (Placement(transformation(extent={{12,-16},{32,4}})));
      IDEAS.Thermal.Components.HeatProduction.HP_BW
                          HP(
       medium=TME.FHF.Media.Water(),
       mediumEvap = TME.FHF.Media.Water(),
        TSet=pulse.y,
        tauHeatLoss=3600,
        mWater=10,
        cDry=10000,
        QNom=7000) annotation (Placement(transformation(extent={{52,-16},{72,4}})));
      Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=300)
        annotation (Placement(transformation(extent={{-6,-52},{14,-32}})));
      Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
        annotation (Placement(transformation(extent={{-56,-52},{-36,-32}})));
      inner Commons.SimInfoManager sim(redeclare Commons.Meteo.Files.min15
          detail, redeclare Commons.Meteo.Locations.Uccle city)
        annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
      Modelica.Blocks.Sources.Pulse pulse(
        amplitude=45,
        period=10000,
        offset=273)
        annotation (Placement(transformation(extent={{-30,66},{-10,86}})));
     Real PElLossesInt( start = 0, fixed = true);

     Real QUsefulLossesInt( start = 0, fixed = true);

     Real SPFLosses( start = 0);

      VerticalHeatExchanger.VerticalHeatExchangerModels.BoreHole boreHole(medium = TME.FHF.Media.Water())
        annotation (Placement(transformation(extent={{56,-116},{36,-96}})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                      pump(
        medium=TME.FHF.Media.Water(),
        m=2,
        useInput=false,
        m_flowNom=0.5)
        annotation (Placement(transformation(extent={{66,-96},{86,-76}})));
      IDEAS.Thermal.Components.BaseClasses.AbsolutePressure
                                  absolutePressure1(medium = TME.FHF.Media.Water())
        annotation (Placement(transformation(extent={{2,-158},{22,-138}})));
    equation
      volumeFlow1.m_flowSet = if pulse.y > 300 then 1 else 0;

      der(PElLossesInt) = HP.PEl;
      der(QUsefulLossesInt) =thermalConductor.port_b.Q_flow;
      SPFLosses = if noEvent(PElLossesInt > 0) then QUsefulLossesInt/PElLossesInt else 0;

      connect(volumeFlow1.flowPort_b, isolatedPipe1.flowPort_a) annotation (Line(
          points={{-16,-6},{12,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(isolatedPipe1.flowPort_b, HP.flowPort_a)            annotation (Line(
          points={{32,-6},{52,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(HP.flowPort_b, volumeFlow1.flowPort_a)            annotation (Line(
          points={{72,-6},{82,-6},{82,-62},{-76,-62},{-76,-6},{-36,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(thermalConductor.port_b, isolatedPipe1.heatPort) annotation (Line(
          points={{14,-42},{18,-42},{18,-16},{22,-16}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(fixedTemperature.port, thermalConductor.port_a) annotation (Line(
          points={{-36,-42},{-6,-42}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(absolutePressure.flowPort, HP.flowPort_a)            annotation (Line(
          points={{58,72},{48,72},{48,-6},{52,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(HP.heatPort, fixedTemperature.port) annotation (Line(
          points={{62,4},{114,4},{114,-66},{-36,-66},{-36,-42}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(HP.flowPortEvap_b, pump.flowPort_a) annotation (Line(
          points={{64,-16},{64,-86},{66,-86}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(pump.flowPort_b, boreHole.flowPort_a) annotation (Line(
          points={{86,-86},{92,-86},{92,-106.2},{55.8,-106.2}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(HP.flowPortEvap_a, boreHole.flowPort_b) annotation (Line(
          points={{58,-16},{56,-16},{56,-86},{16,-86},{16,-106},{36.2,-106}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(absolutePressure1.flowPort, boreHole.flowPort_b) annotation (Line(
          points={{2,-148},{-6,-148},{-6,-144},{-10,-144},{-10,-114},{36.2,-114},{36.2,
              -106}},
          color={255,0,0},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-200},
                {100,100}}),
                          graphics),
        experiment(StopTime=25000),
        __Dymola_experimentSetupOutput,
        Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-200},{100,100}})),
        Commands(file="Scripts/Tester_HPBW.mos" "TestModel"));
    end HPBW_Tester;

    model BoilerTester "Identical as the one in FluidHeatFlow_NoPressure"
      import Commons;

      IDEAS.Thermal.Components.BaseClasses.AbsolutePressure
                               absolutePressure(medium=
            TME.FHF.Media.Water(),                p=200000)
        annotation (Placement(transformation(extent={{58,62},{78,82}})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                         volumeFlow1(
        medium=TME.FHF.Media.Water(),
        m=1,
        m_flowNom=1300/3600,
        useInput=true)
        annotation (Placement(transformation(extent={{-36,-16},{-16,4}})));
      IDEAS.Thermal.Components.BaseClasses.HeatedPipe
                            isolatedPipe1(
        medium=TME.FHF.Media.Water(),
        m=5,
        TInitial=313.15) annotation (Placement(transformation(extent={{12,-16},{32,4}})));
      IDEAS.Thermal.Components.HeatProduction.Boiler
                        boiler(
        medium=TME.FHF.Media.Water(),
        QNom=5000,
        TSet=273.15+82,
        tauHeatLoss=3600,
        mWater=10,
        cDry=10000)
                   annotation (Placement(transformation(extent={{54,-16},{74,4}})));
      Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
        annotation (Placement(transformation(extent={{46,-112},{66,-92}})));
      inner Commons.SimInfoManager sim(
                  redeclare Commons.Meteo.Locations.Uccle city, redeclare
          Commons.Meteo.Files.min5 detail)
        annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
      Modelica.Blocks.Sources.TimeTable
                                    pulse(offset=0, table=[0,0; 5000,100; 10000,400;
            15000,700; 20000,1000; 25000,1300; 50000,1300])
        annotation (Placement(transformation(extent={{-68,24},{-48,44}})));
    //  Real PElLossesInt( start = 0, fixed = true);
    //  Real PElNoLossesInt( start = 0, fixed = true);
    //  Real QUsefulLossesInt( start = 0, fixed = true);
    //  Real QUsefulNoLossesInt( start = 0, fixed = true);
    //  Real SPFLosses( start = 0);
    //  Real SPFNoLosses( start = 0);
    //
      Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TReturn
        annotation (Placement(transformation(extent={{-14,-52},{6,-32}})));
      Modelica.Blocks.Sources.Sine sine(
        amplitude=30,
        freqHz=1/5000,
        offset=273.15+50,
        startTime=20000)
        annotation (Placement(transformation(extent={{-66,-52},{-46,-32}})));
    equation
       volumeFlow1.m_flowSet = pulse.y / 1300;
    //   der(PElLossesInt) = HP.PEl;
    //   der(PElNoLossesInt) = HP_NoLosses.PEl;
    //   der(QUsefulLossesInt) =thermalConductor.port_b.Q_flow;
    //   der(QUsefulNoLossesInt) = thermalConductor1.port_b.Q_flow;
    //   SPFLosses = if noEvent(PElLossesInt > 0) then QUsefulLossesInt/PElLossesInt else 0;
    //   SPFNoLosses = if noEvent(PElNoLossesInt > 0) then QUsefulNoLossesInt/PElNoLossesInt else 0;

      connect(volumeFlow1.flowPort_b, isolatedPipe1.flowPort_a) annotation (Line(
          points={{-16,-6},{12,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(isolatedPipe1.flowPort_b, boiler.flowPort_a)        annotation (Line(
          points={{32,-6},{52,-6},{52,-8},{74,-8}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(boiler.flowPort_b, volumeFlow1.flowPort_a)        annotation (Line(
          points={{74,-4},{78,-4},{82,-62},{-76,-62},{-76,-6},{-36,-6}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(absolutePressure.flowPort, boiler.flowPort_a)        annotation (Line(
          points={{58,72},{48,72},{48,-8},{74,-8}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(boiler.heatPort, fixedTemperature.port)
                                                  annotation (Line(
          points={{64,4},{94,4},{94,-102},{66,-102}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(TReturn.port, isolatedPipe1.heatPort)           annotation (Line(
          points={{6,-42},{22,-42},{22,-16}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(sine.y, TReturn.T) annotation (Line(
          points={{-45,-42},{-16,-42}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-200},
                {100,100}}),
                          graphics),
        experiment(StopTime=25000),
        __Dymola_experimentSetupOutput,
        Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-200},{100,100}})),
        Commands(file="Scripts/Tester_Boiler.mos" "TestModel"));
    end BoilerTester;

    model TankLosses "Check the total tank losses to environment"

      IDEAS.Thermal.Components.Storage.StorageTank
                             storageTank(
        medium=TME.FHF.Media.Water(),
        TInitial={273.15 + 60 for i in 1:storageTank.nbrNodes},
        volumeTank=0.3,
        heightTank=1.6,
        U = 0.4,
        preventNaturalDestratification=true)
        annotation (Placement(transformation(extent={{-26,6},{-6,26}})));
      Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
        annotation (Placement(transformation(extent={{-30,50},{-10,70}})));
      Modelica.Blocks.Continuous.Integrator integrator
        annotation (Placement(transformation(extent={{32,-30},{52,-10}})));
      Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlowSensor
        annotation (Placement(transformation(extent={{10,6},{30,26}})));
      IDEAS.Thermal.Components.BaseClasses.AbsolutePressure
                                  absolutePressure(medium=TME.FHF.Media.Water(), p=200000)
        annotation (Placement(transformation(extent={{-74,44},{-54,66}})));

      Real heatLosskWh24h = integrator.y/1e6/3.6;

    equation
      connect(storageTank.heatExchEnv, heatFlowSensor.port_a) annotation (Line(
          points={{-9.8,16},{10,16}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(heatFlowSensor.port_b, fixedTemperature.port) annotation (Line(
          points={{30,16},{38,16},{38,60},{-10,60}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(heatFlowSensor.Q_flow, integrator.u) annotation (Line(
          points={{20,6},{20,-20},{30,-20}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(absolutePressure.flowPort, storageTank.flowPort_a) annotation (Line(
          points={{-74,55},{-80,55},{-80,54},{-84,54},{-84,24},{-16,24},{-16,26}},
          color={255,0,0},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end TankLosses;

    model FloorHeatingComparisonDiscrete "test with instantiated test models"

    //  FloorHeatingTester discDyn2(redeclare Components.HeatEmission.TabsDiscretized
    //                                                                                tabs(
    //    n=22,
    //    redeclare parameter TME.FHF.Components.HeatEmission.FH_Standard2  FHCharsDiscretized))
    //    annotation (Placement(transformation(extent={{-40,48},{-20,68}})));
    //

        FloorHeatingTester discDyn3(redeclare
          Components.HeatEmission.TabsDiscretized                                   tabs(n=3, redeclare parameter
            IDEAS.Thermal.Components.HeatEmission.FH_Standard2
                                                          FHCharsDiscretized))
        annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

      FloorHeatingTester discDyn20(redeclare
          Components.HeatEmission.TabsDiscretized         tabs(n=20, redeclare parameter
            IDEAS.Thermal.Components.HeatEmission.FH_Standard2
                                                          FHCharsDiscretized))
        annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

      FloorHeatingTester nonDiscDyn(redeclare Components.HeatEmission.Tabs tabs)
        annotation (Placement(transformation(extent={{-40,76},{-20,96}})));
      FloorHeatingTester nonDiscFullyDyn(redeclare Components.HeatEmission.Tabs
          tabs(redeclare
            IDEAS.Thermal.Components.HeatEmission.EmbeddedPipeDynSwitch
            embeddedPipe))
        annotation (Placement(transformation(extent={{-40,46},{-20,66}})));
        FloorHeatingTester discFullDyn3(redeclare
          Components.HeatEmission.TabsDiscretized tabs(
          n=3,
          redeclare parameter
            IDEAS.Thermal.Components.HeatEmission.FH_Standard2
            FHCharsDiscretized,
          tabs(redeclare
              IDEAS.Thermal.Components.HeatEmission.EmbeddedPipeDynSwitch
              embeddedPipe)))
        annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
      FloorHeatingTester discFullDyn20(redeclare
          Components.HeatEmission.TabsDiscretized tabs(
          n=20,
          redeclare parameter
            IDEAS.Thermal.Components.HeatEmission.FH_Standard2
            FHCharsDiscretized,
          tabs(redeclare
              IDEAS.Thermal.Components.HeatEmission.EmbeddedPipeDynSwitch
              embeddedPipe)))
        annotation (Placement(transformation(extent={{-40,-88},{-20,-68}})));
    end FloorHeatingComparisonDiscrete;

    model NakedTabsTester "Testing discretisation of the naked tabs"

      IDEAS.Thermal.Components.HeatEmission.NakedTabs
                                        nakedTabs2(n1=2, n2=2)
        annotation (Placement(transformation(extent={{10,26},{30,46}})));
      IDEAS.Thermal.Components.HeatEmission.NakedTabs
                                        nakedTabs50(n1=50, n2=50)
        annotation (Placement(transformation(extent={{10,-28},{30,-8}})));
      Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
        prescribedTemperature
        annotation (Placement(transformation(extent={{-74,-2},{-54,18}})));
      Modelica.Blocks.Sources.Step step(
        height=10,
        offset=293.15,
        startTime=1000)
        annotation (Placement(transformation(extent={{-94,36},{-74,56}})));
       Modelica.Thermal.HeatTransfer.Components.Convection convection
         annotation (Placement(transformation(extent={{10,86},{-10,66}})));
      Modelica.Thermal.HeatTransfer.Sources.FixedTemperature prescribedTemperature1(T=293.15)
                  annotation (Placement(transformation(extent={{-52,66},{-32,86}})));
       Modelica.Thermal.HeatTransfer.Components.Convection convection1
         annotation (Placement(transformation(extent={{62,26},{42,6}})));
      IDEAS.Thermal.Components.HeatEmission.NakedTabsMassiveCore
                                                   nakedTabs2Core(n1=2, n2=2)
        annotation (Placement(transformation(extent={{16,-104},{36,-84}})));
      IDEAS.Thermal.Components.HeatEmission.NakedTabsMassiveCore
                                                   nakedTabs50Core(n1=50, n2=50)
        annotation (Placement(transformation(extent={{16,-158},{36,-138}})));
       Modelica.Thermal.HeatTransfer.Components.Convection convection2
         annotation (Placement(transformation(extent={{14,-50},{-6,-70}})));
       Modelica.Thermal.HeatTransfer.Components.Convection convection3
         annotation (Placement(transformation(extent={{68,-104},{48,-124}})));
      Modelica.Thermal.HeatTransfer.Sources.FixedTemperature prescribedTemperature2(T=293.15)
                  annotation (Placement(transformation(extent={{-62,-68},{-42,-48}})));
      Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=1000)
        annotation (Placement(transformation(extent={{-46,-2},{-26,18}})));
    equation
      convection.Gc = nakedTabs2.FHChars.A_Floor * 11;
      convection1.Gc = nakedTabs2.FHChars.A_Floor * 11;
      convection2.Gc = nakedTabs2.FHChars.A_Floor * 11;
      convection3.Gc = nakedTabs2.FHChars.A_Floor * 11;
      connect(step.y, prescribedTemperature.T) annotation (Line(
          points={{-73,46},{-68,46},{-68,26},{-86,26},{-86,8},{-76,8}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(nakedTabs2.port_a, convection.solid) annotation (Line(
          points={{20,46},{20,78},{10,78},{10,76}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(prescribedTemperature1.port, convection.fluid) annotation (Line(
          points={{-32,76},{-10,76}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(nakedTabs50.port_a, convection1.solid) annotation (Line(
          points={{20,-8},{22,-8},{22,-4},{70,-4},{70,16},{62,16}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(convection1.fluid, prescribedTemperature1.port) annotation (Line(
          points={{42,16},{40,16},{40,94},{-16,94},{-16,76},{-32,76}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(nakedTabs2Core.port_a, convection2.solid)
                                                   annotation (Line(
          points={{26,-84},{26,-60},{14,-60}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(nakedTabs50Core.port_a, convection3.solid)
                                                     annotation (Line(
          points={{26,-138},{28,-138},{28,-134},{76,-134},{76,-114},{68,-114}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(prescribedTemperature2.port, convection2.fluid) annotation (Line(
          points={{-42,-58},{-24,-58},{-24,-60},{-6,-60}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(prescribedTemperature2.port, convection3.fluid) annotation (Line(
          points={{-42,-58},{-36,-58},{-36,-114},{48,-114}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(prescribedTemperature.port, thermalConductor.port_a) annotation (Line(
          points={{-54,8},{-46,8}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(thermalConductor.port_b, nakedTabs2.portCore) annotation (Line(
          points={{-26,8},{-20,8},{-20,36},{10,36}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(thermalConductor.port_b, nakedTabs50.portCore) annotation (Line(
          points={{-26,8},{-20,8},{-20,-18},{10,-18}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(thermalConductor.port_b, nakedTabs2Core.portCore) annotation (Line(
          points={{-26,8},{-20,8},{-20,-94},{16,-94}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(thermalConductor.port_b, nakedTabs50Core.portCore) annotation (Line(
          points={{-26,8},{-20,8},{-20,-148},{16,-148}},
          color={191,0,0},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -200},{100,200}}),
                          graphics), Icon(coordinateSystem(preserveAspectRatio=true,
              extent={{-100,-200},{100,200}})));
    end NakedTabsTester;

    model TestCollector

      parameter TME.FHF.Interfaces.Medium
                                     medium = TME.FHF.Media.Water();

      IDEAS.Thermal.Components.HeatProduction.CollectorG
                                           collectorG(
        medium=medium,
        h_g=2,
        ACol=5,
        nCol=2,
        T0=283.15)
        annotation (Placement(transformation(extent={{-84,-28},{-64,-8}})));
      IDEAS.Thermal.Components.BaseClasses.HeatedPipe
                                    heatedPipe(medium=medium, m=5)
        annotation (Placement(transformation(extent={{-46,-28},{-26,-8}})));
      IDEAS.Thermal.Components.BaseClasses.Pump
                              pump(medium=medium,
        m=0,
        useInput=true,
        m_flowNom=0.08)
        annotation (Placement(transformation(extent={{-10,-28},{10,-8}})));
      IDEAS.Thermal.Components.Storage.StorageTank
                                     storageTank(medium=medium,
        volumeTank=0.5,
        heightTank=2)
        annotation (Placement(transformation(extent={{54,-68},{74,-48}})));
      IDEAS.Thermal.Components.BaseClasses.HeatedPipe
                                    heatedPipe1(medium=medium, m=5)
        annotation (Placement(transformation(extent={{-26,-78},{-46,-58}})));
      IDEAS.Thermal.Components.BaseClasses.AbsolutePressure
                                          absolutePressure(medium=medium, p=300000)
        annotation (Placement(transformation(extent={{6,6},{18,18}})));

      IDEAS.Thermal.Control.SolarThermalControl_DT
                                          solarThermalControl_DT(
       TSafetyMax=363.15)
        annotation (Placement(transformation(extent={{54,44},{34,64}})));
      inner Commons.SimInfoManager sim(redeclare Commons.Meteo.Files.min5 detail,
          redeclare Commons.Meteo.Locations.Uccle city)
        annotation (Placement(transformation(extent={{-92,76},{-72,96}})));
    equation
      solarThermalControl_DT.TTankBot = storageTank.nodes[5].T;
      solarThermalControl_DT.TSafety = storageTank.nodes[3].T;
      connect(collectorG.flowPort_b, heatedPipe.flowPort_a) annotation (Line(
          points={{-64,-18},{-46,-18}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(heatedPipe.flowPort_b, pump.flowPort_a) annotation (Line(
          points={{-26,-18},{-10,-18}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(pump.flowPort_b, storageTank.flowPorts[3]) annotation (Line(
          points={{10,-18},{34,-18},{34,-58.1667},{54,-58.1667}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(storageTank.flowPort_b, heatedPipe1.flowPort_a) annotation (Line(
          points={{64,-68},{-26,-68}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(heatedPipe1.flowPort_b, collectorG.flowPort_a) annotation (Line(
          points={{-46,-68},{-92,-68},{-92,-18},{-84,-18}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(absolutePressure.flowPort, pump.flowPort_a) annotation (Line(
          points={{6,12},{-10,12},{-10,-18}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(solarThermalControl_DT.onOff, pump.m_flowSet) annotation (Line(
          points={{33.4,56},{0,56},{0,-8}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(collectorG.TCol, solarThermalControl_DT.TCollector) annotation (Line(
          points={{-63.6,-24},{-54,-24},{-54,80},{82,80},{82,54},{54.6,54}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end TestCollector;
  annotation (Documentation(info="<HTML>
This package contains test examples:
<ul>
<li>1.SimpleCooling: heat is dissipated through a media flow</li>
<li>2.ParallelCooling: two heat sources dissipate through merged media flows</li>
<li>3.IndirectCooling: heat is disspated through two cooling cycles</li>
<li>4.PumpAndValve: demonstrates usage of an IdealPump and a Valve</li>
<li>5.PumpDropOut: demonstrates shutdown and restart of a pump</li>
<li>6.ParallelPumpDropOut: demonstrates shutdown and restart of a pump in a parallel circuit</li>
<li>7.OneMass: cooling of a mass (thermal capacity) by a coolant flow</li>
<li>8.TwoMass: cooling of two masses (thermal capacities) by two parallel coolant flows</li>
</ul>
<dl>
  <dt><b>Main Authors:</b></dt>
  <dd>
  <p>
  <a href=\"http://www.haumer.at/\">Anton Haumer</a><br>
  Technical Consulting &amp; Electrical Engineering<br>
  A-3423 St.Andrae-Woerdern, Austria<br>
  email: <a href=\"mailto:a.haumer@haumer.at\">a.haumer@haumer.at</a>
</p>
  <p>
  Dr.Christian Kral<br>
  <a href=\"http://www.ait.ac.at/\">Austrian Institute of Technology, AIT</a><br>
  Giefinggasse 2<br>
  A-1210 Vienna, Austria
</p>
  </dd>
</dl>
<p>
Copyright &copy; 1998-2010, Modelica Association, Anton Haumer and Austrian Institute of Technology, AIT.
</p>

<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</HTML>", revisions="<HTML>
  <ul>
  <li> v1.00 2005/02/01 Anton Haumer<br>
       first stable official release</li>
  <li> v1.31 Beta 2005/06/04 Anton Haumer<br>
       <i>new example: PumpAndValve</i><br>
       <i>new example: PumpDropOut</i></li>
  <li> v1.42 Beta 2005/06/18 Anton Haumer<br>
       <i>new test example: ParallelPumpDropOut</i></li>
  <li> v1.43 Beta 2005/06/20 Anton Haumer<br>
       Test of mixing / semiLinear<br>
       <i>new test example: OneMass</i><br>
       <i>new test example: TwoMass</i></li>
  </ul>
</HTML>
"), Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
              100}}), graphics));
  end Examples;

  package Interfaces "Connectors and partial models"
    extends Modelica.Icons.InterfacesPackage;

    connector FlowPort "Connector flow port"

      extends Modelica.Thermal.FluidHeatFlow.Interfaces.FlowPort;
    annotation (Documentation(info="<HTML>
Basic definition of the connector.<br>
<b>Variables:</b>
<ul>
<li>Pressure p</li>
<li>flow MassFlowRate m_flow</li>
<li>Specific Enthalpy h</li>
<li>flow EnthaplyFlowRate H_flow</li>
</ul>
If ports with different media are connected, the simulation is asserted due to the check of parameter.
</HTML>"));
    end FlowPort;

    connector FlowPort_a "Filled flow port (used upstream)"

      extends FlowPort;
    annotation (Documentation(info="<HTML>
Same as FlowPort, but icon allows to differentiate direction of flow.
</HTML>"),
      Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                100}}), graphics={Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={255,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid), Ellipse(
              extent={{-98,98},{98,-98}},
              lineColor={0,0,255},
              fillColor={0,0,255},
              fillPattern=FillPattern.Solid)}),
                                             Diagram(coordinateSystem(
              preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
            graphics={
            Rectangle(
              extent={{-50,50},{50,-50}},
              lineColor={255,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-48,48},{48,-48}},
              lineColor={0,0,255},
              fillColor={0,0,255},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{-100,110},{100,50}},
              lineColor={0,0,255},
              textString="%name")}));
    end FlowPort_a;

    connector FlowPort_b "Hollow flow port (used downstream)"

      extends FlowPort;
    annotation (Documentation(info="<HTML>
Same as FlowPort, but icon allows to differentiate direction of flow.
</HTML>"),
      Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                100}}), graphics={Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={255,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid), Ellipse(extent={{-98,98},{98,-98}},
                lineColor={0,0,255})}),      Diagram(coordinateSystem(
              preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
            graphics={
            Rectangle(
              extent={{-50,50},{50,-50}},
              lineColor={255,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Ellipse(extent={{-48,48},{48,-48}}, lineColor={0,0,255}),
            Text(
              extent={{-100,110},{100,50}},
              lineColor={0,0,255},
              textString="%name")}));
    end FlowPort_b;

    package Partials "Partial models"
      extends Modelica.Icons.Package;

      partial model TwoPort "Partial model of two port"

        parameter TME.FHF.Interfaces.Medium medium=TME.FHF.Interfaces.Medium()
          "Medium in the component"
          annotation(choicesAllMatching=true);
        parameter Modelica.SIunits.Mass m(start=1) "Mass of medium";
        // I remove this parameter completely because it can lead to wrong models!!!
        // See note in evernote of RDC
        //parameter Real tapT(final min=0, final max=1)=1
        //  "Defines temperature of heatPort between inlet and outlet temperature";
        parameter Modelica.SIunits.Temperature TInitial=293.15
          "Initial temperature of all Temperature states";

        Modelica.SIunits.HeatFlowRate Q_flow(start=0)
          "Heat exchange with ambient";
        Modelica.SIunits.Temperature T(start=TInitial)
          "Outlet temperature of medium";
        Modelica.SIunits.Temperature T_a(start=TInitial)=flowPort_a.h/medium.cp
          "Temperature at flowPort_a";
        Modelica.SIunits.Temperature T_b(start=TInitial)=flowPort_b.h/medium.cp
          "Temperature at flowPort_b";

        Modelica.SIunits.TemperatureDifference dT(start=0)=if noEvent(
          flowPort_a.m_flow >= 0) then T - T_a else T_b - T
          "Outlet temperature minus inlet temperature";

        Modelica.SIunits.SpecificEnthalpy h=medium.cp*T
          "Medium's specific enthalpy";

      public
        FlowPort_a flowPort_a(final medium=medium, h(min=1140947, max=1558647))
          annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
                rotation=0)));
        FlowPort_b flowPort_b(final medium=medium, h(min=1140947, max=1558647))
          annotation (Placement(transformation(extent={{90,-10},{110,10}},
                rotation=0)));
      equation
        // mass balance
        flowPort_a.m_flow + flowPort_b.m_flow = 0;

        // no equation about pressure drop here in order to allow pumps to extend from this partial

        // energy balance
        if m>Modelica.Constants.small then
          flowPort_a.H_flow + flowPort_b.H_flow + Q_flow = m*medium.cv*der(T);
        else
          flowPort_a.H_flow + flowPort_b.H_flow + Q_flow = 0;
        end if;
        // massflow a->b mixing rule at a, energy flow at b defined by medium's temperature
        // massflow b->a mixing rule at b, energy flow at a defined by medium's temperature
        flowPort_a.H_flow = semiLinear(flowPort_a.m_flow,flowPort_a.h,h);
        flowPort_b.H_flow = semiLinear(flowPort_b.m_flow,flowPort_b.h,h);
      annotation (Documentation(info="<HTML>
Partial model with two flowPorts.<br>
Possible heat exchange with the ambient is defined by Q_flow; setting this = 0 means no energy exchange.<br>
Setting parameter m (mass of medium within pipe) to zero
leads to neglection of temperature transient cv*m*der(T).<br>
Mixing rule is applied.<br>
Parameter 0 &lt; tapT &lt; 1 defines temperature of heatPort between medium's inlet and outlet temperature.
</HTML>"));
      end TwoPort;

      partial model Ambient "Partial model of ambient"

        parameter TME.FHF.Interfaces.Medium medium=TME.FHF.Interfaces.Medium()
          "Ambient medium"
          annotation(__Dymola_choicesAllMatching=true);
        output Modelica.SIunits.Temperature T "Outlet temperature of medium";
        output Modelica.SIunits.Temperature T_port=flowPort.h/medium.cp
          "Temperature at flowPort_a";
      protected
        Modelica.SIunits.SpecificEnthalpy h = medium.cp*T;
      public
        FlowPort_a flowPort(final medium=medium)
          annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
                rotation=0)));
      equation
        // massflow -> ambient: mixing rule
        // massflow <- ambient: energy flow defined by ambient's temperature
        flowPort.H_flow = semiLinear(flowPort.m_flow,flowPort.h,h);
      annotation (Documentation(info="<HTML>
<p>
Partial model of (Infinite) ambient, defines pressure and temperature.
</p>
</HTML>"),   Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                  {100,100}}), graphics={Ellipse(
                extent={{-90,90},{90,-90}},
                lineColor={255,0,0},
                fillColor={0,0,255},
                fillPattern=FillPattern.Solid), Text(
                extent={{-150,150},{150,90}},
                lineColor={0,0,255},
                textString="%name")}));
      end Ambient;

      partial model AbsoluteSensor "Partial model of absolute sensor"

        parameter TME.FHF.Interfaces.Medium medium=TME.FHF.Interfaces.Medium()
          "Sensor's medium"
          annotation(__Dymola_choicesAllMatching=true);
        FlowPort_a flowPort(final medium=medium)
          annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
                rotation=0)));
        Modelica.Blocks.Interfaces.RealOutput y
          annotation (Placement(transformation(extent={{100,-10},{120,10}},
                rotation=0)));
      equation
        // no mass exchange
        flowPort.m_flow = 0;
        // no energy exchange
        flowPort.H_flow = 0;
      annotation (Documentation(info="<HTML>
Partial model for an absolute sensor (pressure/temperature).<br>
Pressure, mass flow, temperature and enthalpy flow of medium are not affected.
</HTML>"),          Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={
              Ellipse(
                extent={{-70,70},{70,-70}},
                lineColor={0,0,0},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Line(points={{0,70},{0,40}}, color={0,0,0}),
              Line(points={{22.9,32.8},{40.2,57.3}}, color={0,0,0}),
              Line(points={{-22.9,32.8},{-40.2,57.3}}, color={0,0,0}),
              Line(points={{37.6,13.7},{65.8,23.9}}, color={0,0,0}),
              Line(points={{-37.6,13.7},{-65.8,23.9}}, color={0,0,0}),
              Line(points={{0,0},{9.02,28.6}}, color={0,0,0}),
              Polygon(
                points={{-0.48,31.6},{18,26},{18,57.2},{-0.48,31.6}},
                lineColor={0,0,0},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-5,5},{5,-5}},
                lineColor={0,0,0},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid),
              Line(points={{-70,0},{-90,0}}, color={0,0,0}),
              Line(points={{70,0},{100,0}}),
              Text(
                extent={{-150,130},{150,70}},
                lineColor={0,0,255},
                textString="%name")}),
                                Diagram(coordinateSystem(preserveAspectRatio=true,
                         extent={{-100,-100},{100,100}}),
                                        graphics));
      end AbsoluteSensor;

      partial model RelativeSensor "Partial model of relative sensor"

        parameter TME.FHF.Interfaces.Medium medium=TME.FHF.Interfaces.Medium()
          "Sensor's medium"
          annotation(__Dymola_choicesAllMatching=true);
        FlowPort_a flowPort_a(final medium=medium)
          annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
                rotation=0)));
        FlowPort_b flowPort_b(final medium=medium)
          annotation (Placement(transformation(extent={{90,-10},{110,10}},
                rotation=0)));
        Modelica.Blocks.Interfaces.RealOutput y
          annotation (Placement(transformation(
              origin={0,-110},
              extent={{10,-10},{-10,10}},
              rotation=90)));
      equation
        // no mass exchange
        flowPort_a.m_flow = 0;
        flowPort_b.m_flow = 0;
        // no energy exchange
        flowPort_a.H_flow = 0;
        flowPort_b.H_flow = 0;
      annotation (Documentation(info="<HTML>
Partial model for a relative sensor (pressure drop/temperature difference).<br>
Pressure, mass flow, temperature and enthalpy flow of medium are not affected.
</HTML>"),          Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={
              Ellipse(
                extent={{-70,70},{70,-70}},
                lineColor={0,0,0},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Line(points={{0,70},{0,40}}, color={0,0,0}),
              Line(points={{22.9,32.8},{40.2,57.3}}, color={0,0,0}),
              Line(points={{-22.9,32.8},{-40.2,57.3}}, color={0,0,0}),
              Line(points={{37.6,13.7},{65.8,23.9}}, color={0,0,0}),
              Line(points={{-37.6,13.7},{-65.8,23.9}}, color={0,0,0}),
              Line(points={{0,0},{9.02,28.6}}, color={0,0,0}),
              Polygon(
                points={{-0.48,31.6},{18,26},{18,57.2},{-0.48,31.6}},
                lineColor={0,0,0},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-5,5},{5,-5}},
                lineColor={0,0,0},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid),
              Line(points={{-70,0},{-90,0}}, color={0,0,0}),
              Line(points={{70,0},{90,0}}, color={0,0,0}),
              Line(points={{0,-100},{0,-70}}),
              Text(
                extent={{-150,130},{150,70}},
                lineColor={0,0,255},
                textString="%name")}),
                                Diagram(coordinateSystem(preserveAspectRatio=true,
                         extent={{-100,-100},{100,100}}),
                                        graphics));
      end RelativeSensor;

      partial model FlowSensor "Partial model of flow sensor"

        extends TwoPort(final m=0, final T0=0, final tapT=1);
        Modelica.Blocks.Interfaces.RealOutput y
          annotation (Placement(transformation(
              origin={0,-110},
              extent={{10,-10},{-10,10}},
              rotation=90)));
      equation
        // no pressure drop
        dp = 0;
        // no energy exchange
        Q_flow = 0;
      annotation (Documentation(info="<HTML>
Partial model for a flow sensor (mass flow/heat flow).<br>
Pressure, mass flow, temperature and enthalpy flow of medium are not affected, but mixing rule is applied.
</HTML>"),          Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={
              Ellipse(
                extent={{-70,70},{70,-70}},
                lineColor={0,0,0},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Line(points={{0,70},{0,40}}, color={0,0,0}),
              Line(points={{22.9,32.8},{40.2,57.3}}, color={0,0,0}),
              Line(points={{-22.9,32.8},{-40.2,57.3}}, color={0,0,0}),
              Line(points={{37.6,13.7},{65.8,23.9}}, color={0,0,0}),
              Line(points={{-37.6,13.7},{-65.8,23.9}}, color={0,0,0}),
              Line(points={{0,0},{9.02,28.6}}, color={0,0,0}),
              Polygon(
                points={{-0.48,31.6},{18,26},{18,57.2},{-0.48,31.6}},
                lineColor={0,0,0},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-5,5},{5,-5}},
                lineColor={0,0,0},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid),
              Line(points={{-70,0},{-90,0}}, color={0,0,0}),
              Line(points={{70,0},{90,0}}, color={0,0,0}),
              Line(points={{0,-100},{0,-70}}),
              Text(
                extent={{-150,130},{150,70}},
                lineColor={0,0,255},
                textString="%name")}),
                                Diagram(coordinateSystem(preserveAspectRatio=
                  false, extent={{-100,-100},{100,100}}),
                                        graphics));
      end FlowSensor;
    annotation (Documentation(info="<HTML>
This package contains partial models, defining in a very compact way the basic thermodynamic equations used by the different components.<br>
<dl>
  <dt><b>Main Authors:</b></dt>
  <dd>
  <p>
  <a href=\"http://www.haumer.at/\">Anton Haumer</a><br>
  Technical Consulting &amp; Electrical Engineering<br>
  A-3423 St.Andrae-Woerdern, Austria<br>
  email: <a href=\"mailto:a.haumer@haumer.at\">a.haumer@haumer.at</a>
</p>
  <p>
  Dr. Christian Kral<br>
  <a href=\"http://www.ait.ac.at/\">Austrian Institute of Technology, AIT</a><br>
  Giefinggasse 2<br>
  A-1210 Vienna, Austria
</p>
  </dd>
</dl>
<p>
Copyright &copy; 1998-2010, Modelica Association, Anton Haumer and Austrian Institute of Technology, AIT.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</HTML>",revisions="<HTML>
  <ul>
  <li> v1.00 2005/02/01 Anton Haumer<br>
       first stable official release</li>
  <li> v1.10 2005/02/15 Anton Haumer<br>
       moved Partials into Interfaces</li>
  <li> v1.11 2005/02/18 Anton Haumer<br>
       corrected usage of cv and cp</li>
  <li> v1.30 Beta 2005/06/02 Anton Haumer<br>
       friction losses are fed to medium</li>
  <li> v1.31 Beta 2005/06/04 Anton Haumer<br>
       searching solution for problems @ m_flow=0</li>
  <li> v1.33 Beta 2005/06/07 Anton Haumer<br>
       corrected usage of simpleFlow</li>
  <li> v1.43 Beta 2005/06/20 Anton Haumer<br>
       Test of mixing / semiLinear</li>
  <li> v1.50 2005/09/07 Anton Haumer<br>
       semiLinear works fine<br>
       removed test-version of semiLinear</li>
  <li> v1.60 2007/01/23 Anton Haumer<br>
       new parameter tapT defining Temperature of heatPort</li>
  </ul>
</HTML>
"));
    end Partials;
  annotation (Documentation(info="<HTML>
This package contains connectors and partial models:
<ul>
<li>FlowPort: basic definition of the connector.</li>
<li>FlowPort_a &amp; FlowPort_b: same as FlowPort with different icons to differentiate direction of flow</li>
<li>package Partials (defining basic thermodynamic equations)</li>
</ul>
<dl>
  <dt><b>Main Authors:</b></dt>
  <dd>
  <p>
  <a href=\"http://www.haumer.at/\">Anton Haumer</a><br>
  Technical Consulting &amp; Electrical Engineering<br>
  A-3423 St.Andrae-Woerdern, Austria<br>
  email: <a href=\"mailto:a.haumer@haumer.at\">a.haumer@haumer.at</a>
</p>
  <p>
  Dr. Christian Kral<br>
  <a href=\"http://www.ait.ac.at/\">Austrian Institute of Technology, AIT</a><br>
  Giefinggasse 2<br>
  A-1210 Vienna, Austria
</p>
  </dd>
</dl>
<p>
Copyright &copy; 1998-2010, Modelica Association, Anton Haumer and Austrian Institute of Technology, AIT.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</HTML>", revisions="<HTML>
  <ul>
  <li> v1.00 2005/02/01 Anton Haumer<br>
       first stable official release</li>
  <li> v1.10 2005/02/15 Anton Haumer<br>
       moved Partials into Interfaces</li>
  <li> v1.11 2005/02/18 Anton Haumer<br>
       corrected usage of cv and cp</li>
  <li> v1.30 Beta 2005/06/02 Anton Haumer<br>
       friction losses are fed to medium</li>
  <li> v1.33 Beta 2005/06/07 Anton Haumer<br>
       corrected usage of simpleFlow</li>
  <li> v1.43 Beta 2005/06/20 Anton Haumer<br>
       Test of mixing / semiLinear</li>
  <li> v1.50 2005/09/07 Anton Haumer<br>
       semiLinear works fine</li>
  </ul>
</HTML>
"), Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
              100}}), graphics));
  end Interfaces;
end Components;
