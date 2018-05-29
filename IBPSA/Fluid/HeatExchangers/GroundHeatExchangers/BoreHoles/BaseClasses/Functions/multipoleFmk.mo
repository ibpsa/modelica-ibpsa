within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BaseClasses.Functions;
function multipoleFmk "Complex matrix F_mk from Claesson and Hellstrom (2011)"
  extends Modelica.Icons.Function;

  input Integer nPip "Number of pipes";
  input Integer J "Number of multipoles";
  input Real QPip_flow[nPip](unit="W/m") "Heat flow in pipes";
  input Complex P[nPip,J] "Multipoles";
  input Real rBor "Borehole radius";
  input Real rPip[nPip] "Outter radius of pipes";
  input Complex zPip[nPip] "Position of pipes";
  input Real kGrout "Thermal conductivity of grouting material";
  input Real kSoil "Thermal conductivity of soil material";

  output Complex Fmk[nPip,J] "Multipole coefficients";

protected
  Real pikg=1/(2*Modelica.Constants.pi*kGrout);
  Real sigma=(kGrout - kSoil)/(kGrout + kSoil);
  Complex f;

algorithm

  for m in 1:nPip loop
    for k in 1:J loop
      f := Complex(0, 0);
      for n in 1:nPip loop
        // First term
        if m <> n then
          f := f + QPip_flow[n]*pikg/k*(rPip[m]/(zPip[n] - zPip[m]))^k;
        end if;
        // Second term
        f := f + sigma*QPip_flow[n]*pikg/k*(rPip[m]*Modelica.ComplexMath.conj(
          zPip[n])/(rBor^2 - zPip[m]*Modelica.ComplexMath.conj(zPip[n])))^k;
        for j in 1:J loop
          // Third term
          if m <> n then
            f := f + P[n, j]*BEE.Utilities.Math.Functions.binomial(j + k - 1, j -
              1)*rPip[n]^j*(-rPip[m])^k/(zPip[m] - zPip[n])^(j + k);
          end if;
          //Fourth term
          j_pend := min(k, j);
          for jp in 0:j_pend loop
            f := f + sigma*Modelica.ComplexMath.conj(P[n, j])*
              BEE.Utilities.Math.Functions.binomial(j, jp)*
              BEE.Utilities.Math.Functions.binomial(j + k - jp - 1, j - 1)*
              rPip[n]^j*rPip[m]^k*zPip[m]^(j - jp)*Modelica.ComplexMath.conj(
              zPip[n])^(k - jp)/(rBor^2 - zPip[m]*Modelica.ComplexMath.conj(
              zPip[n]))^(k + j - jp);
          end for;
        end for;
      end for;
      Fmk[m, k] := f;
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
