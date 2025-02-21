within IBPSA.Utilities.IO.SDF.Types;
type InterpolationMethod = enumeration(
    Hold "Hold the last value",
    Nearest "Take the nearest value",
    Linear "Linear interpolation",
    Akima "Akima spline interpolation",
    FritschButland "Fritsch-Butland spline interpolation",
    Steffen "Steffen spline interpolation");
