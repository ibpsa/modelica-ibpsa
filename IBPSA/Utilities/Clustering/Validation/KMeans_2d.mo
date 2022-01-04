within IBPSA.Utilities.Clustering.Validation;
model KMeans_2d "Model that verifies the k-means clustering function"
  extends Modelica.Icons.Example;

  // Test strings
  parameter Integer k = 3;
  parameter Real data[:,:]=
    [ 1, 1;
      1, 2;
      2, 1;
      2, 1.2;
      3, 0;
      4, 0]
    "First test data";

  parameter Integer nDat = size(data,1);
  parameter Integer nDim = size(data,2);
  parameter Real[k,nDim] centroids(fixed=false);
  parameter Integer[nDat] labels(fixed=false);
  parameter Integer[k] cluster_size(fixed=false);

initial equation

  (centroids, labels, cluster_size) = IBPSA.Utilities.Clustering.KMeans(data, k, nDat, nDim);

  // fixme : Add .mos script
  annotation(experiment(Tolerance=1e-6, StopTime=1.0),
      Documentation(info="<html>
<p>

</p>
</html>",
revisions="<html>
<ul>
<li>
January 4, 2022, by Massimo Cimmino<br/>
First implementation.
</li>
</ul>
</html>"));
end KMeans_2d;
