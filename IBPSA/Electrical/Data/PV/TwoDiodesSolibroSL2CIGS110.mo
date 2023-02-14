within IBPSA.Electrical.Data.PV;
record TwoDiodesSolibroSL2CIGS110
  "Solibro SL2 CIG S110 record"
   extends IBPSA.Electrical.Data.PV.TwoDiodesData(
    n_ser=150,
    n_par=1,
    //eta_0 = ((V_mp0*I_mp0)/(1000*A_cel*n_ser))
    eta_0 = 1, // dummy value
    //A_cel=((V_mp0*I_mp0)/(1000*eta_0))/n_ser,
    A_cel=1.0 // dummy value;
    T_NOCT=47.5 + 273.15, // dummy value
    A_mod=0.7895*1.190,
    Eg = 1.107,
    RPar = 500.0,
    RSer = 0.027484527,
    c1 = 0.0011962052,
    c2 = 0.001542755,
    cs1 = 9.490919,
    cs2 = 0.007634368);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TwoDiodesSolibroSL2CIGS110;
