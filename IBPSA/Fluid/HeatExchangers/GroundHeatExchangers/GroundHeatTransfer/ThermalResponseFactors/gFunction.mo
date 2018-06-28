within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors;
function gFunction "Evaluate the g-function of a bore field"
  extends Modelica.Icons.Function;

  input Integer nbBor "Number of boreholes";
  input Modelica.SIunits.Position cooBor[nbBor, 2] "Coordinates of boreholes";
  input Modelica.SIunits.Height hBor "Borehole length";
  input Modelica.SIunits.Height dBor "Borehole buried depth";
  input Modelica.SIunits.Radius rBor "Borehole radius";
  input Modelica.SIunits.ThermalDiffusivity aSoi "Ground thermal diffusivity used in g-function evaluation";
  input Integer nbSeg "Number of line source segments per borehole";
  input Integer nbTimSho "Number of time steps in short time region";
  input Integer nbTimLon "Number of time steps in long time region";
  input Real ttsMax "Maximum adimensional time for gfunc calculation";
  input Real relTol = 0.02 "Relative tolerance on distance between boreholes";

  output Modelica.SIunits.Time tGFun[nbTimSho+nbTimLon] "Time of g-function evaluation";
  output Real g[nbTimSho+nbTimLon] "g-Function";

protected
  Modelica.SIunits.Time ts = hBor^2/(9*aSoi) "Characteristic time";
  Modelica.SIunits.Time tSho_min = 1 "Minimum time for short time calculations";
  Modelica.SIunits.Time tSho_max = 3600 "Maximum time for short time calculations";
  Modelica.SIunits.Time tLon_min = tSho_max "Minimum time for long time calculations";
  Modelica.SIunits.Time tLon_max = ts*ttsMax "Maximum time for long time calculations";
  Modelica.SIunits.Time tSho[nbTimSho] "Time vector for short time calculations";
  Modelica.SIunits.Time tLon[nbTimLon] "Time vector for long time calculations";
  Modelica.SIunits.Distance dis "Separation distance between boreholes";
  Modelica.SIunits.Distance dis_mn "Separation distance for comparison";
  Real hSegRea[nbSeg] "Real part of the FLS solution";
  Real hSegMir[2*nbSeg-1] "Mirror part of the FLS solution";
  Modelica.SIunits.Height dSeg "Buried depth of borehole segment";
  Integer Done[nbBor, nbBor] "Matrix for tracking of FLS evaluations";
  Real A[nbSeg*nbBor+1, nbSeg*nbBor+1] "Coefficient matrix for system of equations";
  Real B[nbSeg*nbBor+1] "Coefficient vector for system of equations";
  Real X[nbSeg*nbBor+1] "Solution vector for system of equations";
  Real FLS "Finite line source solution";
  Real ILS "Infinite line source solution";
  Real CHS "Cylindrical heat source solution";

algorithm

  // Generate geometrically expanding time vectors
  tSho :=
    IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.timeGeometric(
      tSho_min, tSho_max, nbTimSho);
  tLon :=
    IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.timeGeometric(
      tLon_min, tLon_max, nbTimLon);
  // Concatenate the short- and long-term parts
  tGFun := cat(1, {0}, tSho[1:nbTimSho - 1], tLon);

  // -----------------------
  // Short time calculations
  // -----------------------
  Modelica.Utilities.Streams.print(("Evaluation of short time g-function."));
  g[1] := 0.;
  for k in 1:nbTimSho loop
    // Finite line source solution
    FLS :=
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.finiteLineSource(
      tSho[k],
      aSoi,
      rBor,
      hBor,
      dBor,
      hBor,
      dBor);
    // Infinite line source solution
    ILS := 0.5*
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.infiniteLineSource(
      tSho[k],
      aSoi,
      rBor);
    // Cylindrical heat source solution
    CHS := 2*Modelica.Constants.pi*
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.cylindricalHeatSource(
      tSho[k],
      aSoi,
      rBor,
      rBor);
    // Correct finite line source solution for cylindrical geometry
    g[k+1] := FLS + (CHS - ILS);
  end for;

  // ----------------------
  // Long time calculations
  // ----------------------
  Modelica.Utilities.Streams.print(("Evaluation of long time g-function."));
  // Initialize coefficient matrix A
  for m in 1:nbBor loop
    for u in 1:nbSeg loop
      // Tb coefficient in spatial superposition equations
      A[(m-1)*nbSeg+u,nbBor*nbSeg+1] := -1;
      // Q coefficient in heat balance equation
      A[nbBor*nbSeg+1,(m-1)*nbSeg+u] := 1;
    end for;
  end for;
  // Initialize coefficient vector B
  // The total heat extraction rate is constant
  B[nbBor*nbSeg+1] := nbBor*nbSeg;

  // Evaluate thermal response matrix at all times
  for k in 1:nbTimLon-1 loop
    for i in 1:nbBor loop
      for j in i:nbBor loop
        // Distance between boreholes
        if i == j then
          // If same borehole, distance is the radius
          dis := rBor;
        else
          dis := sqrt((cooBor[i,1] - cooBor[j,1])^2 + (cooBor[i,2] - cooBor[j,2])^2);
        end if;
        // Only evaluate the thermal response factors if not already evaluated
        if Done[i,j] < k then
          // Evaluate Real and Mirror parts of FLS solution
          // Real part
          for m in 1:nbSeg loop
            hSegRea[m] :=
              IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.finiteLineSource(
              tLon[k + 1],
              aSoi,
              dis,
              hBor/nbSeg,
              dBor,
              hBor/nbSeg,
              dBor + (m - 1)*hBor/nbSeg,
              includeMirrorSource=false);
          end for;
        // Mirror part
          for m in 1:(2*nbSeg-1) loop
            hSegMir[m] :=
              IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.finiteLineSource(
              tLon[k + 1],
              aSoi,
              dis,
              hBor/nbSeg,
              dBor,
              hBor/nbSeg,
              dBor + (m - 1)*hBor/nbSeg,
              includeRealSource=false);
          end for;
        // Apply to all pairs that have the same separation distance
          for m in 1:nbBor loop
            for n in m:nbBor loop
              if m == n then
                dis_mn := rBor;
              else
                dis_mn := sqrt((cooBor[m,1] - cooBor[n,1])^2 + (cooBor[m,2] - cooBor[n,2])^2);
              end if;
              if abs(dis_mn - dis) < relTol*dis then
                // Add thermal response factor to coefficient matrix A
                for u in 1:nbSeg loop
                  for v in 1:nbSeg loop
                    A[(m-1)*nbSeg+u,(n-1)*nbSeg+v] := hSegRea[abs(u-v)+1] + hSegMir[u+v-1];
                    A[(n-1)*nbSeg+v,(m-1)*nbSeg+u] := hSegRea[abs(u-v)+1] + hSegMir[u+v-1];
                  end for;
                end for;
                // Mark current pair as evaluated
                Done[m,n] := k;
                Done[n,m] := k;
              end if;
            end for;
          end for;
        end if;
      end for;
    end for;
    // Solve the system of equations
    X := Modelica.Math.Matrices.solve(A,B);
    // The g-function is equal to the borehole wall temperature
    g[nbTimSho+k+1] := X[nbBor*nbSeg+1];
  end for;
  // Correct finite line source solution for cylindrical geometry
  for k in 2:nbTimLon loop
    // Infinite line source
    ILS := 0.5*
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.infiniteLineSource(
      tLon[k],
      aSoi,
      rBor);
    // Cylindrical heat source
    CHS := 2*Modelica.Constants.pi*
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors.cylindricalHeatSource(
      tLon[k],
      aSoi,
      rBor,
      rBor);
    g[nbTimSho+k] := g[nbTimSho+k] + (CHS - ILS);
  end for;

end gFunction;
