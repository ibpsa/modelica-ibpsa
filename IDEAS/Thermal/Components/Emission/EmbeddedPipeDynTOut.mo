within IDEAS.Thermal.Components.Emission;
model EmbeddedPipeDynTOut
  "Embedded pipe model based on prEN 15377 and (Koschenz, 2000), water capacity lumped to TOut"

  extends Thermal.Components.Emission.Auxiliaries.Partial_EmbeddedPipe;

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
  Thermal.Components.BaseClasses.VariableThermalConductor resistance_w
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
