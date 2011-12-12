within IDEAS.Data.Materials;
record Argon = IDEAS.Data.Interfaces.Material (
    k=0.0162,
    c=519,
    rho=1.70,
    epsSw=0,
    epsLw=0,
    nState=1,
    gas=true,
    mhu=22.9*10e-6);
