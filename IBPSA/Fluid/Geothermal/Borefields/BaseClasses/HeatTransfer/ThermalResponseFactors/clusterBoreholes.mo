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

  output Integer labels[nBor] "Cluster label associated with each data point";
  output Integer cluster_size[n_clusters];

protected
  Real TBor[nBor,1] "Steady-state borehole wall temperatures";
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

  // ---- Identify borehole clusters
  (,labels,cluster_size) := IBPSA.Utilities.Clustering.KMeans(
    TBor,
    n_clusters,
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
