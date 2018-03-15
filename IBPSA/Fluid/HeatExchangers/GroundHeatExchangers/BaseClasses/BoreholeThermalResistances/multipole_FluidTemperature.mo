within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.BoreholeThermalResistances;
function multipole_FluidTemperature
  "Fluid temperatures from multipole solution"
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
  Complex zPip[nPip]={Complex(xPip[m], yPip[m]) for m in 1:nPip};
  Complex P[nPip,J];
  Complex P_new[nPip,J];
  Complex F[nPip,J];
  Real R0[nPip,nPip];
  Complex deltaTFlu;
  Complex deltaT;
  Real rbm;
  Real dz;
  Real coeff[nPip,J];
  Real diff;
  Real diff0;
  Integer it;
  Real eps_max;

algorithm
  // Thermal resistance matrix from 0th order multipole
  for i in 1:nPip loop
    rbm := rBor^2/(rBor^2 - Modelica.ComplexMath.'abs'(zPip[i])^2);
    R0[i, i] := pikg*(log(rBor/rPip[i]) + betaPip[i] + sigma*log(rbm));
    for j in 1:nPip loop
      if i <> j then
        dz := Modelica.ComplexMath.'abs'(zPip[i] - zPip[j]);
        rbm := rBor^2/Modelica.ComplexMath.'abs'(rBor^2 - zPip[j]*
          Modelica.ComplexMath.conj(zPip[i]));
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
        P[m, k] := Complex(0, 0);
      end for;
    end for;
    while eps_max > eps and it < it_max loop
      it := it + 1;
      F :=
        IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.BoreholeThermalResistances.multipole_Fmk(
        nPip,
        J,
        QPip_flow,
        P,
        rBor,
        rPip,
        zPip,
        kGrout,
        kSoil);
      for m in 1:nPip loop
        for k in 1:J loop
          P_new[m, k] := coeff[m, k]*Modelica.ComplexMath.conj(F[m, k]);
        end for;
      end for;
      if it == 1 then
        diff0 := max(Modelica.ComplexMath.'abs'(P_new[:, :] - P[:, :])) - min(
          Modelica.ComplexMath.'abs'(P_new[:, :] - P[:, :]));
      end if;
      diff := max(Modelica.ComplexMath.'abs'(P_new[:, :] - P[:, :])) - min(
        Modelica.ComplexMath.'abs'(P_new[:, :] - P[:, :]));
      eps_max := diff/diff0;
      P := P_new;
    end while;
  end if;

  // Fluid Temperatures
  TFlu := TBor .+ R0*QPip_flow;
  if J > 0 then
    for m in 1:nPip loop
      deltaTFlu := Complex(0, 0);
      for n in 1:nPip loop
        for j in 1:J loop
          if n <> m then
            // Second term
            deltaTFlu := deltaTFlu + P[n, j]*(rPip[n]/(zPip[m] - zPip[n]))^j;
          end if;
          // Third term
          deltaTFlu := deltaTFlu + sigma*P[n, j]*(rPip[n]*
            Modelica.ComplexMath.conj(zPip[m])/(rBor^2 - zPip[n]*
            Modelica.ComplexMath.conj(zPip[m])))^j;
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
end multipole_FluidTemperature;
