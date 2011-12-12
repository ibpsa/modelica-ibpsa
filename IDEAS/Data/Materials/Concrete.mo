within IDEAS.Data.Materials;
record Concrete = IDEAS.Data.Interfaces.Material (
    k=1.4,
    c=840,
    rho=2100,
    epsLw=0.88,
    epsSw=0.55) "dense cast concrete, also for finishing";
