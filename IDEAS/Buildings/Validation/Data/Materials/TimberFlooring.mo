within IDEAS.Buildings.Validation.Data.Materials;
record TimberFlooring
 extends IDEAS.Buildings.Data.Interfaces.Material(
    final k=0.14,
    final c=1200,
    final rho=650,
    epsLw=0.9,
    epsSw=0.6);
end TimberFlooring;
