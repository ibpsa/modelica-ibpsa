within IBPSA.Electrical.Data.PV;
record TwoDiodesSolibroSL2CIGS110
  "Solibro SL2 CIG S110 record"
   extends IBPSA.Electrical.Data.PV.TwoDiodesData(
    n_ser=150,
    n_par=1,
    eta_0 = 1,
    A_cel=1.0,
    A_mod=0.7895*1.190,
    Eg = 1.2,
    RPar = 500.0,
    RSer = 0.027484527,
    c1 = 0.0011962052,
    c2 = 0.001542755,
    cs1 = 9.490919,
    cs2 = 0.007634368,
    T_NOCT=51 + 273.15);
    //Eg = 1.107,
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TwoDiodesSolibroSL2CIGS110;
