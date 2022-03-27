within IBPSA.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors;
function clusterBoreholes
  "Identify clusters of boreholes with similar heat interactions"
  extends Modelica.Icons.Function;

  input Integer nBor "Number of boreholes";
  input Modelica.Units.SI.Position cooBor[nBor, 2] "Coordinates of boreholes";
  input Modelica.Units.SI.Height hBor "Borehole length";
  input Modelica.Units.SI.Height dBor "Borehole buried depth";
  input Modelica.Units.SI.Radius rBor "Borehole radius";
  input Integer n_clusters "Number of clusters to be generated";
  input Real TTol = 0.001 "Absolute tolerance on the borehole wall temperature for the identification of clusters";

  output Integer labels[nBor] "Cluster label associated with each data point";
  output Integer cluster_size[n_clusters];
  output Integer N "Number of unique clusters";

protected
  Real TBor[nBor,1] "Steady-state borehole wall temperatures";
  Real TBor_Unique[nBor] "Unique borehole wall temperatures under tolerance";
  Real dis "Distance between boreholes";

algorithm
  // ---- Evaluate borehole wall temperatures
  for i in 1:nBor loop
    TBor[i,1] := 0;
    for j in 1:nBor loop
      if i <> j then
        dis := sqrt((cooBor[i,1]-cooBor[j,1])^2 + (cooBor[i,2]-cooBor[j,2])^2);
      else
        dis := rBor;
      end if;
      TBor[i,1] := TBor[i,1] + IBPSA.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_SteadyState(dis, hBor, dBor, hBor, dBor);
    end for;
  end for;

  // ---- Find all unique borehole wall temperatures under tolerance
  // The number of clusters is min(N, n_clusters)
  N := 1;
  TBor_Unique[1] := TBor[1,1];
  if n_clusters > 1 then
    for i in 2:nBor loop
      for j in 1:N loop
        if abs(TBor[i,1] - TBor_Unique[j]) < TTol then
          break;
        elseif j == N then
          TBor_Unique[N+1] := TBor[i,1];
          N := N + 1;
        end if;
      end for;
    end for;
  end if;

  // ---- Identify borehole clusters
  (,labels,cluster_size[1:min(N, n_clusters)]) := IBPSA.Utilities.Clustering.KMeans(
    TBor,
    min(N, n_clusters),
    nBor,
    1);

annotation (
Inline=true,
Documentation(info="<html>
<p>

</p>
</html>", revisions="<html>
<ul>
<li>
January 4, 2022 by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end clusterBoreholes;
