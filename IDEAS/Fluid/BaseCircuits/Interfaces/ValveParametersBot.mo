within IDEAS.Fluid.BaseCircuits.Interfaces;
model ValveParametersBot

  parameter IDEAS.Fluid.Types.CvTypes CvDataBot=IDEAS.Fluid.Types.CvTypes.Kv
    "Selection of flow coefficient"
   annotation(Dialog(group = "Flow Coefficient Bot Valve"));
  parameter Real KvBot(
    fixed= if CvDataBot==IDEAS.Fluid.Types.CvTypes.Kv then true else false)
    "Kv (metric) flow coefficient [m3/h/(bar)^(1/2)]"
  annotation(Dialog(group = "Flow Coefficient Bot Valve",
                    enable = (CvDataBot==IDEAS.Fluid.Types.CvTypes.Kv)));
  parameter Real CvBot(
    fixed= if CvDataBot==IDEAS.Fluid.Types.CvTypes.Cv then true else false)
    "Cv (US) flow coefficient [USG/min/(psi)^(1/2)]"
  annotation(Dialog(group = "Flow Coefficient Bot Valve",
                    enable = (CvDataBot==IDEAS.Fluid.Types.CvTypes.Cv)));
  parameter Modelica.SIunits.Area AvBot(
    fixed= if CvDataBot==IDEAS.Fluid.Types.CvTypes.Av then true else false)
    "Av (metric) flow coefficient"
   annotation(Dialog(group = "Flow Coefficient Bot Valve",
                     enable = (CvDataBot==IDEAS.Fluid.Types.CvTypes.Av)));

  parameter Real deltaMBot = 0.02
    "Fraction of nominal flow rate where linearization starts, if y=1"
    annotation(Dialog(group="Pressure-flow linearization"));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";

  parameter Modelica.SIunits.Pressure dpValve_nominalBot(displayUnit="Pa",
                                                      min=0,
                                                      fixed= if CvDataBot==IDEAS.Fluid.Types.CvTypes.OpPoint then true else false)
    "Nominal pressure drop of fully open valve, used if CvData=IDEAS.Fluid.Types.CvTypes.OpPoint"
    annotation(Dialog(group="Nominal condition",
               enable = (CvData==IDEAS.Fluid.Types.CvTypes.OpPoint)));

  parameter Modelica.SIunits.Density rhoStdBot
    "Inlet density for which valve coefficients are defined"
  annotation(Dialog(group="Nominal condition", tab="Advanced"));

protected
  parameter Real Kv_SIBot(
    min=0,
    fixed= false)
    "Flow coefficient for fully open valve in SI units, Kv=m_flow/sqrt(dp) [kg/s/(Pa)^(1/2)]"
  annotation(Dialog(group = "Flow Coefficient Bot Valve",
                    enable = (CvData==IDEAS.Fluid.Types.CvTypes.OpPoint)));

initial equation

  if  CvDataBot == IDEAS.Fluid.Types.CvTypes.OpPoint then
    Kv_SIBot =           m_flow_nominal/sqrt(dpValve_nominalBot);
    KvBot    =           Kv_SIBot/(rhoStdBot/3600/sqrt(1E5));
    CvBot    =           Kv_SIBot/(rhoStdBot*0.0631/1000/sqrt(6895));
    AvBot    =           Kv_SIBot/sqrt(rhoStdBot);
  elseif CvDataBot == IDEAS.Fluid.Types.CvTypes.Kv then
    Kv_SIBot =           KvBot*rhoStdBot/3600/sqrt(1E5)
      "Unit conversion m3/(h*sqrt(bar)) to kg/(s*sqrt(Pa))";
    CvBot    =           Kv_SIBot/(rhoStdBot*0.0631/1000/sqrt(6895));
    AvBot    =           Kv_SIBot/sqrt(rhoStdBot);
    dpValve_nominalBot =  (m_flow_nominal/Kv_SIBot)^2;
  elseif CvDataBot == IDEAS.Fluid.Types.CvTypes.Cv then
    Kv_SIBot =           CvBot*rhoStdBot*0.0631/1000/sqrt(6895)
      "Unit conversion USG/(min*sqrt(psi)) to kg/(s*sqrt(Pa))";
    KvBot    =           Kv_SIBot/(rhoStdBot/3600/sqrt(1E5));
    AvBot    =           Kv_SIBot/sqrt(rhoStdBot);
    dpValve_nominalBot =  (m_flow_nominal/Kv_SIBot)^2;
  else
    assert(CvDataBot == IDEAS.Fluid.Types.CvTypes.Av, "Invalid value for CvData.
Obtained CvData = " + String(CvDataBot) + ".");
    Kv_SIBot =           AvBot*sqrt(rhoStdBot);
    KvBot    =           Kv_SIBot/(rhoStdBot/3600/sqrt(1E5));
    CvBot    =           Kv_SIBot/(rhoStdBot*0.0631/1000/sqrt(6895));
    dpValve_nominalBot =  (m_flow_nominal/Kv_SIBot)^2;
  end if;

end ValveParametersBot;
