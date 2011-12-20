within IDEAS.Buildings.Data.Materials;
record Glass = IDEAS.Buildings.Data.Interfaces.Material (
    k=1.06,
    c=750,
    rho=2500,
    epsLw=0.84,
    epsSw=0.67,
    nState=1) "Glass";
