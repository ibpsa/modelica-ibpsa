within IBPSA.Utilities.Clustering;
function KMeans "k-means clustering algorithm"
  extends Modelica.Icons.Function;
  input Real data[n_samples,n_features] "Data to be clustered";
  input Integer n_clusters "Number of clusters to be generated";
  input Integer n_samples "Number of samples";
  input Integer n_features "Number of features";
  input Real relTol=1e-5 "Relative tolerance on cluster positions";
  input Integer max_iter=500 "Maximum number of k-means iterations";
  input Integer n_init=10 "Number of runs with randomized centroid seeds";
  output Real centroids[n_clusters,n_features] "Centroids of the clusters";
  output Integer labels[n_samples] "Cluster label associated with each data point";
  output Integer cluster_size[n_clusters] "Size of the clusters";

protected
  Real old_centroids[n_clusters,n_features] "Previous iteration centroids";
  Real new_centroids[n_clusters,n_features] "Next iteration centroids";
  Real delta_centroids;
  Integer new_labels[n_samples] "Next iteration cluster labels";
  Real new_inertia;
  Real inertia;
  // Integer seed "Arbitrary seed value";
  Integer id "Id of the random integer generator";
  Integer k_iter;
  Real min_dis;
  Real dis;
  Integer n;
  constant Integer seed = 2 "Arbitrary seed value";

algorithm
  // ---- Generate random seed
  // seed := Modelica.Math.Random.Utilities.automaticGlobalSeed();
  id := Modelica.Math.Random.Utilities.initializeImpureRandom(seed);

  // ---- Perform n_init successive runs of the k-means algorithm
 for run in 1:n_init loop
    // ---- Select initial centroids at random
    // Select 3 non-repeated data points in the data set
    n := Modelica.Math.Random.Utilities.impureRandomInteger(id,1,n_samples);
    old_centroids[1,:] := data[n,:];
    for i in 2:n_clusters loop
      n := Modelica.Math.Random.Utilities.impureRandomInteger(id,1,n_samples);
      old_centroids[i,:] := data[n,:];
      min_dis := Modelica.Math.Vectors.norm(old_centroids[i,:]-old_centroids[1,:], p=2)^2;
      while min_dis < Modelica.Constants.eps loop
        n := Modelica.Math.Random.Utilities.impureRandomInteger(id,1,n_samples);
        old_centroids[i,:] := data[n,:];
        min_dis := Modelica.Math.Vectors.norm(old_centroids[i,:]-old_centroids[1,:], p=2)^2;
        for j in 1:i-1 loop
          dis := Modelica.Math.Vectors.norm(old_centroids[j,:]-old_centroids[i,:], p=2)^2;
          min_dis := min(dis, min_dis);
        end for;
      end while;
    end for;

    // ---- k-means iterations
    k_iter := 0;
    delta_centroids := 2*relTol;
    while k_iter < max_iter and delta_centroids > relTol loop
      k_iter := k_iter + 1;

      // Find centroid closest to each data point
      for i in 1:n_samples loop
        new_labels[i] := 1;
        min_dis := Modelica.Math.Vectors.norm(data[i,:]-old_centroids[1,:], p=2)^2;
        for j in 1:n_clusters loop
          dis := Modelica.Math.Vectors.norm(data[i,:]-old_centroids[j,:], p=2)^2;
          if dis < min_dis then
            min_dis := min(dis, min_dis);
            new_labels[i] := j;
          end if;
        end for;
      end for;

      // Re-evaluate position of the centroids
      delta_centroids := 0;
      for j in 1:n_clusters loop
        n := sum(if new_labels[i]==j then 1 else 0 for i in 1:n_samples);
        new_centroids[j,:] := zeros(n_features);
        if n>0 then
          for i in 1:n_samples loop
             if new_labels[i]==j then
               new_centroids[j,:] := new_centroids[j,:] + data[i,:]/n;
             end if;
          end for;
        else
          new_centroids[j,:] := old_centroids[j,:];
        end if;
        delta_centroids := max(delta_centroids, sum((new_centroids[j,:] - old_centroids[j,:])./old_centroids[j,:]));
      end for;
      old_centroids := new_centroids;
    end while;

    // Evaluate inertia
    new_inertia := 0;
    for i in 1:n_samples loop
      dis := Modelica.Math.Vectors.norm(data[i,:]-centroids[new_labels[i],:], p=2)^2;
      new_inertia := inertia + dis;
    end for;

    // Keep run results if inertia is minimum
    if new_inertia < inertia or run == 1 then
      centroids := new_centroids;
      inertia := new_inertia;
      labels := new_labels;
    end if;

   end for;

   // Evaluate cluster sizes
   for j in 1:n_clusters loop
     cluster_size[j] := sum(if labels[i]==j then 1 else 0 for i in 1:n_samples);
   end for;

annotation (
    Documentation(info="<html>
<p>
// fixme: add documentation.
</p>
</html>", revisions="<html>
<ul>
<li>
January 4, 2022 by Massimo Cimmino:<br/>
First Implementation
</li>
</ul>
</html>"));
end KMeans;
