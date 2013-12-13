within IDEAS.Buildings.Validation.Data.Materials;
record Roofdeck = IDEAS.Buildings.Data.Interfaces.Material (
    final k=0.14,
    final c=900,
    final rho=530,
    final epsLw=0.9,
    final epsSw=0.6);
