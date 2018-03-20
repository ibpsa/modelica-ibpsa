within IBPSA.Utilities.Math.Functions;
function besselY0 "Bessel function of the second kind of order 0, Y0"
  extends Modelica.Icons.Function;

  input Real x "Independent variable";
  output Real Y0 "Bessel function Y0(x)";

protected
  Real P[5] = {1.0,
            -0.1098628627e-2,
            0.2734510407e-4,
            -0.2073370639e-5,
            0.2093887211e-6};
  Real Q[5] = {-0.1562499995e-1,
            0.1430488765e-3,
            -0.6911147651e-5,
            0.7621095161e-6,
            -0.934945152e-7};
  Real R[6] = {-2957821389.0,
            7062834065.0,
            -512359803.6,
            10879881.29,
            -86327.92757,
            228.5622733};
  Real S[6] = {40076544269.0,
            745249964.8,
            7189466.438,
            47447.26470,
            226.1030244,
            1.0};
  Real ax = abs(x);
  Real xx;
  Real y;
  Real z = 8/ax;
  Real coeff1;
  Real coeff2;

algorithm

  if ax < 8.0 then
    y := x^2;
    coeff1 := R[6];
    coeff2 := S[6];
    for i in 1:5 loop
      coeff1 := R[6-i] + y*coeff1;
      coeff2 := S[6-i] + y*coeff2;
    end for;
    Y0 := coeff1/coeff2 + 0.636619772*IBPSA.Utilities.Math.Functions.besselJ0(x)*log(x);
  else
    y := z^2;
    xx := ax - 0.785398164;
    coeff1 := P[5];
    coeff2 := Q[5];
    for i in 1:4 loop
      coeff1 := P[5-i] + y*coeff1;
      coeff2 := Q[5-i] + y*coeff2;
    end for;
    Y0 := sqrt(0.636619772/ax)*(sin(xx)*coeff1 + z*cos(xx)*coeff2);
  end if;

end besselY0;
