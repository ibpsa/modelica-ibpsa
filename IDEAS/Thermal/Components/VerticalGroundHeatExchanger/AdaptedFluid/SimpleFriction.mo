within IDEAS.Thermal.Components.VerticalGroundHeatExchanger.AdaptedFluid;
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
