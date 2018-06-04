within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BaseClasses.Functions;
function multipoleFmk "Complex matrix F_mk from Claesson and Hellstrom (2011)"
  extends Modelica.Icons.Function;

  input Integer nPip "Number of pipes";
  input Integer J "Number of multipoles";
  input Real QPip_flow[nPip](unit="W/m") "Heat flow in pipes";
  input Real PRea[nPip,J] "Multipoles (Real part)";
  input Real PIma[nPip,J] "Multipoles (Imaginary part)";
  input Real rBor "Borehole radius";
  input Real rPip[nPip] "Outter radius of pipes";
  input Real xPip[nPip] "x-Coordinates of pipes";
  input Real yPip[nPip] "y-Coordinates of pipes";
  input Real kGrout "Thermal conductivity of grouting material";
  input Real kSoil "Thermal conductivity of soil material";

  output Real FRea[nPip,J] "Multipole coefficients";
  output Real FIma[nPip,J] "Multipole coefficients";

protected
  Complex zPip_i;
  Complex zPip_j;
  Complex P_nj;
  Real pikg=1/(2*Modelica.Constants.pi*kGrout);
  Real sigma=(kGrout - kSoil)/(kGrout + kSoil);
  Complex f;
  Integer j_pend;

algorithm

  for m in 1:nPip loop
    zPip_i := Complex(xPip[m], yPip[m]);
    for k in 1:J loop
      f := Complex(0, 0);
      for n in 1:nPip loop
        zPip_j := Complex(xPip[n], yPip[n]);
        // First term
        if m <> n then
          f := f + QPip_flow[n]*pikg/k*(rPip[m]/(zPip_j - zPip_i))^k;
        end if;
        // Second term
        f := f + sigma*QPip_flow[n]*pikg/k*(rPip[m]*Modelica.ComplexMath.conj(
          zPip_j)/(rBor^2 - zPip_i*Modelica.ComplexMath.conj(zPip_j)))^k;
        for j in 1:J loop
          P_nj := Complex(PRea[n, j], PIma[n, j]);
          // Third term
          if m <> n then
            f := f + P_nj*IBPSA.Utilities.Math.Functions.binomial(j + k - 1, j -
              1)*rPip[n]^j*(-rPip[m])^k/(zPip_i - zPip_j)^(j + k);
          end if;
          //Fourth term
          j_pend := min(k, j);
          for jp in 0:j_pend loop
            f := f + sigma*Modelica.ComplexMath.conj(P_nj)*
              IBPSA.Utilities.Math.Functions.binomial(j, jp)*
              IBPSA.Utilities.Math.Functions.binomial(j + k - jp - 1, j - 1)*
              rPip[n]^j*rPip[m]^k*zPip_i^(j - jp)*Modelica.ComplexMath.conj(
              zPip_j)^(k - jp)/(rBor^2 - zPip_i*Modelica.ComplexMath.conj(
              zPip_j))^(k + j - jp);
          end for;
        end for;
      end for;
      FRea[m, k] := Modelica.ComplexMath.real(f);
      FIma[m, k] := Modelica.ComplexMath.imag(f);
    end for;
  end for;

  annotation (Documentation(info="<html>
<p> Evaluate the complex coefficient matrix F_mk from Claesson and Hellstrom (2011).
</p>
<h4>References</h4>
<p>J. Claesson and G. Hellstrom. 
<i>Multipole method to calculate borehole thermal resistances in a borehole heat exchanger. 
</i>
HVAC&R Research,
17(6): 895-911, 2011.</p>
</html>", revisions="<html>
<ul>
<li>
February 12, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end multipoleFmk;
