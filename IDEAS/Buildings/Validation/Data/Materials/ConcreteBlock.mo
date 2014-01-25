within IDEAS.Buildings.Validation.Data.Materials;
record ConcreteBlock = IDEAS.Buildings.Data.Interfaces.Material (
    final k=0.51,
    final c=1000,
    final rho=1400,
    final epsLw=0.9,
    final epsSw=0.6);
