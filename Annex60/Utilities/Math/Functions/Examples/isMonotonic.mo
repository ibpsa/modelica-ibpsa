within Annex60.Utilities.Math.Functions.Examples;
model isMonotonic
  "Tests the correct implementation of the function isMonotonic"
  extends Modelica.Icons.Example;
equation
// Tests with weak monotonicity
    //strictly increasing
assert(Annex60.Utilities.Math.Functions.isMonotonic({0, 1, 2}, strict=false),
   "Error. Function should have returned true.");
     //not monotonic
assert(false == Annex60.Utilities.Math.Functions.isMonotonic({0, 3, 2}, strict=false),
   "Error. Function should have returned true.");
     //weakly increasing
assert(Annex60.Utilities.Math.Functions.isMonotonic({0, 1, 1, 2}, strict=false),
   "Error. Function should have returned true.");
     //not weakly monotonic
assert(false == Annex60.Utilities.Math.Functions.isMonotonic({0, 3, 3, 2}, strict=false),
   "Error. Function should have returned true.");

    //strictly decreasing
assert(Annex60.Utilities.Math.Functions.isMonotonic({2.5, 2, 0.1}, strict=false),
   "Error. Function should have returned true.");
     //weakly decreasing
assert(Annex60.Utilities.Math.Functions.isMonotonic({3, 1, 1, 0.5}, strict=false),
   "Error. Function should have returned true.");

// Tests with strict monotonicity
    //strictly increasing
assert(Annex60.Utilities.Math.Functions.isMonotonic({0, 1, 2}, strict=true),
   "Error. Function should have returned true.");
     //not monotonic
assert(false == Annex60.Utilities.Math.Functions.isMonotonic({0, 3, 2}, strict=true),
   "Error. Function should have returned true.");
     //weakly increasing
assert(false == Annex60.Utilities.Math.Functions.isMonotonic({0, 1, 1, 2}, strict=true),
   "Error. Function should have returned true.");
     //not weakly monotonic
assert(false == Annex60.Utilities.Math.Functions.isMonotonic({0, 3, 3, 2}, strict=true),
   "Error. Function should have returned true.");

    //strictly decreasing
assert(Annex60.Utilities.Math.Functions.isMonotonic({2.5, 2, 0.1}, strict=true),
   "Error. Function should have returned true.");
     //weakly decreasing
assert(false == Annex60.Utilities.Math.Functions.isMonotonic({3, 1, 1, 0.5}, strict=true),
   "Error. Function should have returned true.");

  annotation (Documentation(revisions="<html>
<ul>
<li>
January 8, 2014, by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>"));
end isMonotonic;
