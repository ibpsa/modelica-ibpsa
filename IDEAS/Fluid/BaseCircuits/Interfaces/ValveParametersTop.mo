within IDEAS.Fluid.BaseCircuits.Interfaces;
model ValveParametersTop

  parameter IDEAS.Fluid.Types.CvTypes CvDataTop=IDEAS.Fluid.Types.CvTypes.OpPoint
    "Selection of flow coefficient"
   annotation(Dialog(group = "Flow Coefficient Top Valve"));
  parameter Real KvTop(
    fixed= if CvDataTop==IDEAS.Fluid.Types.CvTypes.Kv then true else false)
    "Kv (metric) flow coefficient [m3/h/(bar)^(1/2)]"
  annotation(Dialog(group = "Flow Coefficient Top Valve",
                    enable = (CvDataTop==IDEAS.Fluid.Types.CvTypes.Kv)));
  parameter Real CvTop(
    fixed= if CvDataTop==IDEAS.Fluid.Types.CvTypes.Cv then true else false)
    "Cv (US) flow coefficient [USG/min/(psi)^(1/2)]"
  annotation(Dialog(group = "Flow Coefficient Top Valve",
                    enable = (CvDataTop==IDEAS.Fluid.Types.CvTypes.Cv)));
  parameter Modelica.SIunits.Area AvTop(
    fixed= if CvDataTop==IDEAS.Fluid.Types.CvTypes.Av then true else false)
    "Av (metric) flow coefficient"
   annotation(Dialog(group = "Flow Coefficient Top Valve",
                     enable = (CvDataTop==IDEAS.Fluid.Types.CvTypes.Av)));

  parameter Real deltaMTop = 0.02
    "Fraction of nominal flow rate where linearization starts, if y=1"
    annotation(Dialog(group="Pressure-flow linearization"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Pressure dpValve_nominalTop(displayUnit="Pa",
                                                      min=0,
                                                      fixed= if CvDataTop==IDEAS.Fluid.Types.CvTypes.OpPoint then true else false)
    "Nominal pressure drop of fully open valve, used if CvData=IDEAS.Fluid.Types.CvTypes.OpPoint"
    annotation(Dialog(group="Nominal condition",
               enable = (CvData==IDEAS.Fluid.Types.CvTypes.OpPoint)));

  parameter Modelica.SIunits.Density rhoStdTop
    "Inlet density for which valve coefficients are defined"
  annotation(Dialog(group="Nominal condition", tab="Advanced"));

protected
  parameter Real Kv_SITop(
    min=0,
    fixed= false)
    "Flow coefficient for fully open valve in SI units, Kv=m_flow/sqrt(dp) [kg/s/(Pa)^(1/2)]"
  annotation(Dialog(group = "Flow Coefficient Top Valve",
                    enable = (CvData==IDEAS.Fluid.Types.CvTypes.OpPoint)));

initial equation
  if  CvDataTop == IDEAS.Fluid.Types.CvTypes.OpPoint then
    Kv_SITop =           m_flow_nominal/sqrt(dpValve_nominalTop);
    KvTop    =           Kv_SITop/(rhoStdTop/3600/sqrt(1E5));
    CvTop    =           Kv_SITop/(rhoStdTop*0.0631/1000/sqrt(6895));
    AvTop    =           Kv_SITop/sqrt(rhoStdTop);
  elseif CvDataTop == IDEAS.Fluid.Types.CvTypes.Kv then
    Kv_SITop =           KvTop*rhoStdTop/3600/sqrt(1E5)
      "Unit conversion m3/(h*sqrt(bar)) to kg/(s*sqrt(Pa))";
    CvTop    =           Kv_SITop/(rhoStdTop*0.0631/1000/sqrt(6895));
    AvTop    =           Kv_SITop/sqrt(rhoStdTop);
    dpValve_nominalTop =  (m_flow_nominal/Kv_SITop)^2;
  elseif CvDataTop == IDEAS.Fluid.Types.CvTypes.Cv then
    Kv_SITop =           CvTop*rhoStdTop*0.0631/1000/sqrt(6895)
      "Unit conversion USG/(min*sqrt(psi)) to kg/(s*sqrt(Pa))";
    KvTop    =           Kv_SITop/(rhoStdTop/3600/sqrt(1E5));
    AvTop    =           Kv_SITop/sqrt(rhoStdTop);
    dpValve_nominalTop =  (m_flow_nominal/Kv_SITop)^2;
  else
    assert(CvDataTop == IDEAS.Fluid.Types.CvTypes.Av, "Invalid value for CvData.
Obtained CvData = " + String(CvDataTop) + ".");
    Kv_SITop =           AvTop*sqrt(rhoStdTop);
    KvTop    =           Kv_SITop/(rhoStdTop/3600/sqrt(1E5));
    CvTop    =           Kv_SITop/(rhoStdTop*0.0631/1000/sqrt(6895));
    dpValve_nominalTop =  (m_flow_nominal/Kv_SITop)^2;
  end if;
end ValveParametersTop;
