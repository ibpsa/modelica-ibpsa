within IDEAS.Thermal.Components.Emission;
model EmbeddedPipe_prEN15377
  "Static embedded pipe model according to prEN 15377 and (Koschenz, 2000)"

  /*
  This model is identical to the norm prEN 15377 and corresponding background as developed in (Koschenz, 2000).  
  Nomenclature from EN 15377.
  
  ATTENTION: this model is problematic when there is no flowrate. Actually, I did not solve this issue so 
  do not use this model if the flowrate can become zero. 
  
  */

  extends IDEAS.Thermal.Components.Emission.Interfaces.Partial_EmbeddedPipe;

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
  Real m_flowSp = flowPort_a.m_flow/FHChars.A_Floor "in kg/s.m2";
  Real m_flowMinSp = m_flowMin / FHChars.A_Floor "in kg/s.m2";
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
  Thermal.Components.BaseClasses.VariableThermalConductor resistance_w
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={2,0})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature theta_v
    "Average temperature in the pipe" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-64,0})));

  Thermal.Components.BaseClasses.VariableThermalConductor resistance_z
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

  connect(resistance_x.port_b, heatPortEmb) annotation (Line(
      points={{78,-1.22465e-015},{82,-1.22465e-015},{82,0},{84,0},{84,52},{-50,
          52},{-50,58}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end EmbeddedPipe_prEN15377;
