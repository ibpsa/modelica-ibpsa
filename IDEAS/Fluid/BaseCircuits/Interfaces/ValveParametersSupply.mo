within IDEAS.Fluid.BaseCircuits.Interfaces;
model ValveParametersSupply

  parameter IDEAS.Fluid.Types.CvTypes CvDataSupply=IDEAS.Fluid.Types.CvTypes.OpPoint
    "Selection of flow coefficient"
   annotation(Dialog(group = "Flow Coefficient Supply Valve"));
  parameter Real KvSupply(
    fixed= if CvDataSupply==IDEAS.Fluid.Types.CvTypes.Kv then true else false)
    "Kv (metric) flow coefficient [m3/h/(bar)^(1/2)]"
  annotation(Dialog(group = "Flow Coefficient Supply Valve",
                    enable = (CvDataSupply==IDEAS.Fluid.Types.CvTypes.Kv)));
  parameter Real CvSupply(
    fixed= if CvDataSupply==IDEAS.Fluid.Types.CvTypes.Cv then true else false)
    "Cv (US) flow coefficient [USG/min/(psi)^(1/2)]"
  annotation(Dialog(group = "Flow Coefficient Supply Valve",
                    enable = (CvDataSupply==IDEAS.Fluid.Types.CvTypes.Cv)));
  parameter Modelica.SIunits.Area AvSupply(
    fixed= if CvDataSupply==IDEAS.Fluid.Types.CvTypes.Av then true else false)
    "Av (metric) flow coefficient"
   annotation(Dialog(group = "Flow Coefficient Supply Valve",
                     enable = (CvDataSupply==IDEAS.Fluid.Types.CvTypes.Av)));

  parameter Real deltaMSupply = 0.02
    "Fraction of nominal flow rate where linearization starts, if y=1"
    annotation(Dialog(group="Pressure-flow linearization"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Pressure dpValve_nominalSupply(displayUnit="Pa",
                                                      min=0,
                                                      fixed= if CvDataSupply==IDEAS.Fluid.Types.CvTypes.OpPoint then true else false)
    "Nominal pressure drop of fully open valve, used if CvData=IDEAS.Fluid.Types.CvTypes.OpPoint"
    annotation(Dialog(group="Nominal condition",
               enable = (CvData==IDEAS.Fluid.Types.CvTypes.OpPoint)));

  parameter Modelica.SIunits.Density rhoStdSupply
    "Inlet density for which valve coefficients are defined"
  annotation(Dialog(group="Nominal condition", tab="Advanced"));

protected
  parameter Real Kv_SISupply(
    min=0,
    fixed= false)
    "Flow coefficient for fully open valve in SI units, Kv=m_flow/sqrt(dp) [kg/s/(Pa)^(1/2)]"
  annotation(Dialog(group = "Flow Coefficient Supply Valve",
                    enable = (CvData==IDEAS.Fluid.Types.CvTypes.OpPoint)));

initial equation
  if  CvDataSupply == IDEAS.Fluid.Types.CvTypes.OpPoint then
    Kv_SISupply =           m_flow_nominal/sqrt(dpValve_nominalSupply);
    KvSupply    =           Kv_SISupply/(rhoStdSupply/3600/sqrt(1E5));
    CvSupply    =           Kv_SISupply/(rhoStdSupply*0.0631/1000/sqrt(6895));
    AvSupply    =           Kv_SISupply/sqrt(rhoStdSupply);
  elseif CvDataSupply == IDEAS.Fluid.Types.CvTypes.Kv then
    Kv_SISupply =           KvSupply*rhoStdSupply/3600/sqrt(1E5)
      "Unit conversion m3/(h*sqrt(bar)) to kg/(s*sqrt(Pa))";
    CvSupply    =           Kv_SISupply/(rhoStdSupply*0.0631/1000/sqrt(6895));
    AvSupply    =           Kv_SISupply/sqrt(rhoStdSupply);
    dpValve_nominalSupply =  (m_flow_nominal/Kv_SISupply)^2;
  elseif CvDataSupply == IDEAS.Fluid.Types.CvTypes.Cv then
    Kv_SISupply =           CvSupply*rhoStdSupply*0.0631/1000/sqrt(6895)
      "Unit conversion USG/(min*sqrt(psi)) to kg/(s*sqrt(Pa))";
    KvSupply    =           Kv_SISupply/(rhoStdSupply/3600/sqrt(1E5));
    AvSupply    =           Kv_SISupply/sqrt(rhoStdSupply);
    dpValve_nominalSupply =  (m_flow_nominal/Kv_SISupply)^2;
  else
    assert(CvDataSupply == IDEAS.Fluid.Types.CvTypes.Av, "Invalid value for CvData.
Obtained CvData = " + String(CvDataSupply) + ".");
    Kv_SISupply =           AvSupply*sqrt(rhoStdSupply);
    KvSupply    =           Kv_SISupply/(rhoStdSupply/3600/sqrt(1E5));
    CvSupply    =           Kv_SISupply/(rhoStdSupply*0.0631/1000/sqrt(6895));
    dpValve_nominalSupply =  (m_flow_nominal/Kv_SISupply)^2;
  end if;
end ValveParametersSupply;
