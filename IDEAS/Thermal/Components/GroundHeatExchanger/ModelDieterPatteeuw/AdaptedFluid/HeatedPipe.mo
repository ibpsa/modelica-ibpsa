within IDEAS.Thermal.Components.GroundHeatExchanger.ModelDieterPatteeuw.AdaptedFluid;
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
