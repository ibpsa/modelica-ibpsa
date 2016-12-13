within IDEAS.Buildings.Data.Materials;
record Glass = IDEAS.Buildings.Data.Interfaces.Material (
    k=0.96,
    c=750,
    rho=2500,
    epsLw=0.84,
    epsSw=0.67) "Glass" annotation (Documentation(info="<html>
<p>
Thermal properties of glass.
</p>
</html>"));
