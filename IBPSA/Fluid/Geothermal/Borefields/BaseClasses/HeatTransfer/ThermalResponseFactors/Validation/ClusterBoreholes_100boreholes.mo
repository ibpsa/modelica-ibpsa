within IBPSA.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.Validation;
model ClusterBoreholes_100boreholes
  "Clustering of a field of 100 boreholes"
  extends Modelica.Icons.Example;

  parameter Integer nBor = 100 "Number of boreholes";
  parameter Modelica.Units.SI.Position cooBor[nBor, 2] = {{7.5*mod(i-1,10), 7.5*floor((i-1)/10)} for i in 1:nBor}
    "Coordinates of boreholes";
  parameter Modelica.Units.SI.Height hBor=150 "Borehole length";
  parameter Modelica.Units.SI.Height dBor=4 "Borehole buried depth";
  parameter Modelica.Units.SI.Radius rBor=0.075 "Borehole radius";
  parameter Integer k=4 "Number of clusters to be generated";

  parameter Integer labels[nBor](each fixed=false) "Cluster label associated with each data point";
  parameter Integer cluster_size[k](each fixed=false);

initial equation
  (labels, cluster_size) = IBPSA.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.clusterBoreholes(nBor,cooBor,hBor,dBor,rBor,k);

  // fixme : Add .mos script
   annotation(experiment(Tolerance=1e-6, StopTime=1),
      Documentation(info="<html>
<p>

</p>
</html>",
revisions="<html>
<ul>
<li>
January 4, 2022, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end ClusterBoreholes_100boreholes;
