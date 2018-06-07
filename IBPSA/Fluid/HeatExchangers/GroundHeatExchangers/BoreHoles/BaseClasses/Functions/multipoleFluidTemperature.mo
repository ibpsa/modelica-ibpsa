within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BaseClasses.Functions;
function multipoleFluidTemperature "Fluid temperatures from multipole solution"
  extends Modelica.Icons.Function;

  input Integer nPip "Number of pipes";
  input Integer J "Number of multipoles";
  input Real xPip[nPip] "x-Coordinates of pipes";
  input Real yPip[nPip] "y-Coordinates of pipes";
  input Real QPip_flow[nPip] "Heat flow in pipes";
  input Real TBor "Average borehole wall temperature";
  input Real rBor "Borehole radius";
  input Real rPip[nPip] "Outter radius of pipes";
  input Real kGrout "Thermal conductivity of grouting material";
  input Real kSoil "Thermal conductivity of soil material";
  input Real Rfp[nPip] "Fluid to pipe wall thermal resistances";
  input Real eps=1.0e-5 "Iteration relative accuracy";
  input Real it_max=100 "Maximum number of iterations";

  output Real TFlu[nPip] "Fluid temperature in pipes";

protected
  Real pikg=1/(2*Modelica.Constants.pi*kGrout);
  Real sigma=(kGrout - kSoil)/(kGrout + kSoil);
  Real betaPip[nPip]=2*Modelica.Constants.pi*kGrout*Rfp;
  Complex zPip_i;
  Complex zPip_j;
  Complex P_nj;
  Real PRea[nPip,J];
  Real PIma[nPip,J];
  Complex P_nj_new;
  Real PRea_new[nPip,J];
  Real PIma_new[nPip,J];
  Complex F_mk;
  Real FRea[nPip,J];
  Real FIma[nPip,J];
  Real R0[nPip,nPip];
  Complex deltaTFlu;
  Complex deltaT;
  Real rbm;
  Real dz;
  Real coeff[nPip,J];
  Real diff;
  Real diff_max;
  Real diff_min;
  Real diff0;
  Integer it;
  Real eps_max;

algorithm
  // Thermal resistance matrix from 0th order multipole
  for i in 1:nPip loop
    zPip_i := Complex(xPip[i], yPip[i]);
    rbm := rBor^2/(rBor^2 - Modelica.ComplexMath.'abs'(zPip_i)^2);
    R0[i, i] := pikg*(log(rBor/rPip[i]) + betaPip[i] + sigma*log(rbm));
    for j in 1:nPip loop
      zPip_j := Complex(xPip[j], yPip[j]);
      if i <> j then
        dz := Modelica.ComplexMath.'abs'(zPip_i - zPip_j);
        rbm := rBor^2/Modelica.ComplexMath.'abs'(rBor^2 - zPip_j*
          Modelica.ComplexMath.conj(zPip_i));
        R0[i, j] := pikg*(log(rBor/dz) + sigma*log(rbm));
      end if;
    end for;
  end for;

  // Initialize maximum error and iteration counter
  eps_max := 1.0e99;
  it := 0;
  // Multipoles
  if J > 0 then
    for m in 1:nPip loop
      for k in 1:J loop
        coeff[m, k] := -(1 - k*betaPip[m])/(1 + k*betaPip[m]);
        PRea[m, k] := 0;
        PIma[m, k] := 0;
      end for;
    end for;
    while eps_max > eps and it < it_max loop
      it := it + 1;
      (FRea, FIma) :=
        IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BaseClasses.Functions.multipoleFmk(
        nPip,
        J,
        QPip_flow,
        PRea,
        PIma,
        rBor,
        rPip,
        xPip,
        yPip,
        kGrout,
        kSoil);
      for m in 1:nPip loop
        for k in 1:J loop
          F_mk := Complex(FRea[m, k], FIma[m, k]);
          P_nj_new := coeff[m, k]*Modelica.ComplexMath.conj(F_mk);
          PRea_new[m, k] := Modelica.ComplexMath.real(P_nj_new);
          PIma_new[m, k] := Modelica.ComplexMath.imag(P_nj_new);
        end for;
      end for;
      diff_max := 0;
      diff_min := 1e99;
      for m in 1:nPip loop
        for k in 1:J loop
          P_nj := Complex(PRea[m, k], PIma[m, k]);
          P_nj_new := Complex(PRea_new[m, k], PIma_new[m, k]);
          diff_max := max(diff_max,
                           Modelica.ComplexMath.'abs'(P_nj_new - P_nj));
          diff_min := min(diff_min,
                           Modelica.ComplexMath.'abs'(P_nj_new - P_nj));
        end for;
      end for;
      diff := diff_max - diff_min;
      if it == 1 then
        diff0 :=diff;
      end if;
      eps_max := diff/diff0;
      PRea := PRea_new;
      PIma := PIma_new;
    end while;
  end if;

  // Fluid Temperatures
  TFlu := TBor .+ R0*QPip_flow;
  if J > 0 then
    for m in 1:nPip loop
      zPip_i :=Complex(xPip[m], yPip[m]);
      deltaTFlu := Complex(0, 0);
      for n in 1:nPip loop
        zPip_j :=Complex(xPip[n], yPip[n]);
        for j in 1:J loop
          P_nj := Complex(PRea[n, j], PIma[n, j]);
          if n <> m then
            // Second term
            deltaTFlu := deltaTFlu + P_nj*(rPip[n]/(zPip_i - zPip_j))^j;
          end if;
          // Third term
          deltaTFlu := deltaTFlu + sigma*P_nj*(rPip[n]*
            Modelica.ComplexMath.conj(zPip_i)/(rBor^2 - zPip_j*
            Modelica.ComplexMath.conj(zPip_i)))^j;
        end for;
      end for;
      TFlu[m] := TFlu[m] + Modelica.ComplexMath.real(deltaTFlu);
    end for;
  end if;

  annotation (Documentation(info="<html>
<p> Evaluate the Fluid temperatures using the multipole method of Claesson and Hellstrom (2011).
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
end multipoleFluidTemperature;
