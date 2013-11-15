within IDEAS.Buildings.Validation.Data.Insulation;
record foaminsulation = IDEAS.Buildings.Data.Interfaces.Insulation (
    final k=0.040,
    final c=1400,
    final rho=10,
    final epsLw=0.9,
    final epsSw=0.6);
