within IBPSA.Electrical.Data.PV;
record SingleDiodeSolibroSL2CIGS110 "Single-diode: record also used for validation"
   extends IBPSA.Electrical.Data.PV.SingleDiodeData(
    n_ser=150,
    n_par=1,
    A_cel=((V_mp0*I_mp0)/(1000*eta_0))/n_ser,
    A_mod=0.7895*1.190,
    eta_0=0.116,
    V_oc0=93.3,
    I_sc0=1.69,
    V_mp0=72.4,
    I_mp0=1.52,
    P_mp0=110,
    TCoeff_Isc=0.000676,
    TCoeff_Voc=-0.27,
    gamma_Pmp=-0.0038,
    T_NOCT=51 + 273.15,
    Eg0 = 1.107,
    C=0.0002677);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SingleDiodeSolibroSL2CIGS110;
