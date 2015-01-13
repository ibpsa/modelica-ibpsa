within IDEAS.Fluid.BaseCircuits.Interfaces;
model ValveParametersReturn

  parameter IDEAS.Fluid.Types.CvTypes CvDataReturn=IDEAS.Fluid.Types.CvTypes.Kv
    "Selection of flow coefficient"
   annotation(Dialog(group = "Flow Coefficient Return Valve"));
  parameter Real KvReturn(
    fixed= if CvDataReturn==IDEAS.Fluid.Types.CvTypes.Kv then true else false)
    "Kv (metric) flow coefficient [m3/h/(bar)^(1/2)]"
  annotation(Dialog(group = "Flow Coefficient Return Valve",
                    enable = (CvDataReturn==IDEAS.Fluid.Types.CvTypes.Kv)));
  parameter Real CvReturn(
    fixed= if CvDataReturn==IDEAS.Fluid.Types.CvTypes.Cv then true else false)
    "Cv (US) flow coefficient [USG/min/(psi)^(1/2)]"
  annotation(Dialog(group = "Flow Coefficient Return Valve",
                    enable = (CvDataReturn==IDEAS.Fluid.Types.CvTypes.Cv)));
  parameter Modelica.SIunits.Area AvReturn(
    fixed= if CvDataReturn==IDEAS.Fluid.Types.CvTypes.Av then true else false)
    "Av (metric) flow coefficient"
   annotation(Dialog(group = "Flow Coefficient Return Valve",
                     enable = (CvDataReturn==IDEAS.Fluid.Types.CvTypes.Av)));

  parameter Real deltaMReturn = 0.02
    "Fraction of nominal flow rate where linearization starts, if y=1"
    annotation(Dialog(group="Pressure-flow linearization"));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";

  parameter Modelica.SIunits.Pressure dpValve_nominalReturn(displayUnit="Pa",
                                                      min=0,
                                                      fixed= if CvDataReturn==IDEAS.Fluid.Types.CvTypes.OpPoint then true else false)
    "Nominal pressure drop of fully open valve, used if CvData=IDEAS.Fluid.Types.CvTypes.OpPoint"
    annotation(Dialog(group="Nominal condition",
               enable = (CvData==IDEAS.Fluid.Types.CvTypes.OpPoint)));

  parameter Modelica.SIunits.Density rhoStdReturn
    "Inlet density for which valve coefficients are defined"
  annotation(Dialog(group="Nominal condition", tab="Advanced"));

protected
  parameter Real Kv_SIReturn(
    min=0,
    fixed= false)
    "Flow coefficient for fully open valve in SI units, Kv=m_flow/sqrt(dp) [kg/s/(Pa)^(1/2)]"
  annotation(Dialog(group = "Flow Coefficient Return Valve",
                    enable = (CvData==IDEAS.Fluid.Types.CvTypes.OpPoint)));

initial equation

  if  CvDataReturn == IDEAS.Fluid.Types.CvTypes.OpPoint then
    Kv_SIReturn =           m_flow_nominal/sqrt(dpValve_nominalReturn);
    KvReturn    =           Kv_SIReturn/(rhoStdReturn/3600/sqrt(1E5));
    CvReturn    =           Kv_SIReturn/(rhoStdReturn*0.0631/1000/sqrt(6895));
    AvReturn    =           Kv_SIReturn/sqrt(rhoStdReturn);
  elseif CvDataReturn == IDEAS.Fluid.Types.CvTypes.Kv then
    Kv_SIReturn =           KvReturn*rhoStdReturn/3600/sqrt(1E5)
      "Unit conversion m3/(h*sqrt(bar)) to kg/(s*sqrt(Pa))";
    CvReturn    =           Kv_SIReturn/(rhoStdReturn*0.0631/1000/sqrt(6895));
    AvReturn    =           Kv_SIReturn/sqrt(rhoStdReturn);
    dpValve_nominalReturn =  (m_flow_nominal/Kv_SIReturn)^2;
  elseif CvDataReturn == IDEAS.Fluid.Types.CvTypes.Cv then
    Kv_SIReturn =           CvReturn*rhoStdReturn*0.0631/1000/sqrt(6895)
      "Unit conversion USG/(min*sqrt(psi)) to kg/(s*sqrt(Pa))";
    KvReturn    =           Kv_SIReturn/(rhoStdReturn/3600/sqrt(1E5));
    AvReturn    =           Kv_SIReturn/sqrt(rhoStdReturn);
    dpValve_nominalReturn =  (m_flow_nominal/Kv_SIReturn)^2;
  else
    assert(CvDataReturn == IDEAS.Fluid.Types.CvTypes.Av, "Invalid value for CvData.
Obtained CvData = " + String(CvDataReturn) + ".");
    Kv_SIReturn =           AvReturn*sqrt(rhoStdReturn);
    KvReturn    =           Kv_SIReturn/(rhoStdReturn/3600/sqrt(1E5));
    CvReturn    =           Kv_SIReturn/(rhoStdReturn*0.0631/1000/sqrt(6895));
    dpValve_nominalReturn =  (m_flow_nominal/Kv_SIReturn)^2;
  end if;

end ValveParametersReturn;
