within IBPSA.Utilities.IO.RESTClient.BaseClasses;
function Round "Round function with adjusted accuracy"
    input Real u "Input";
    input Real accuracy "Accuracy level";
    output Real y "Output";
algorithm
    y :=if (u > 0) then floor(u/accuracy + 0.5)*accuracy else ceil(u/accuracy - 0.5)*accuracy;

  annotation (Documentation(revisions="<html>
</html>", info="<html>
<p>Function that rounds the given input float number based on a given accuracy level.</p>
</html>"));
end Round;
