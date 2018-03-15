within IBPSA.Utilities.Math.Functions;
function besselY1 "Bessel function of the second kind of order 1, Y1"

  input Real x "Independent variable";
  output Real Y1 "Bessel function J1(x)";

protected
  Real P[5] = {1.0,
            0.183105e-2,
            -0.3516396496e-4,
            0.2457520174e-5,
            -0.240337019e-6};
  Real Q[5] = {0.04687499995,
            -0.2002690873e-3,
            0.8449199096e-5,
            -0.88228987e-6,
            0.105787412e-6};
  Real R[6] = {-0.4900604943e13,
            0.1275274390e13,
            -0.5153438139e11,
            0.7349264551e9,
            -0.4237922726e7,
            0.8511937935e4};
  Real S[7] = {0.2499580570e14,
            0.4244419664e12,
            0.3733650367e10,
            0.2245904002e8,
            0.1020426050e6,
            0.3549632885e3,
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
    coeff2 := S[6] + y*S[7];
    for i in 1:5 loop
      coeff1 := R[6-i] + y*coeff1;
      coeff2 := S[6-i] + y*coeff2;
    end for;
    Y1 := x*coeff1/coeff2 + 0.636619772*(IBPSA.Utilities.Math.Functions.besselJ1(x)*log(x) - 1.0/x);
  else
    y := z^2;
    xx := ax - 2.356194491;
    coeff1 := P[5];
    coeff2 := Q[5];
    for i in 1:4 loop
      coeff1 := P[5-i] + y*coeff1;
      coeff2 := Q[5-i] + y*coeff2;
    end for;
    Y1 := sqrt(0.636619772/ax)*(sin(xx)*coeff1 + z*cos(xx)*coeff2)*sign(x);
  end if;

end besselY1;
