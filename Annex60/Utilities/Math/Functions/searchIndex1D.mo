within Annex60.Utilities.Math.Functions;
function searchIndex1D
  "Find the index value i in a vector x for the desired abscissa a so that x[i] < a < x[i+1]"
  //fixme: What happens if a = x[i]? At least one inequality must be strong.
  extends Modelica.Icons.Function;

  input Real x[:]
    "Abscissa table vector (strict monotonically increasing values required)";
  input Real xi "Desired abscissa value";
  input Integer iLast=1 "Index used in last search";
  input Boolean ensureMonotonicity=false
    "if true, assert that the vector x is strict monotonically increasing";
  output Integer i "xi is in the interval x[iNew] <= xi < x[iNew+1]";
protected
  Integer nx=size(x, 1);
algorithm
  assert(nx > 0, "The table vectors must have at least 1 entry.");
  if ensureMonotonicity then
    assert(isMonotonic(x), "The input vector x should be monotomic");
  end if;
  if nx == 1 then
    i := 1;
  else
    // Search interval
    i := min(max(iLast, 1), nx - 1);
    if xi >= x[i] then
      // search forward
      while i < nx and xi >= x[i] loop
        i := i + 1;
      end while;
      i := i - 1;
    else
      // search backward
      while i > 1 and xi < x[i] loop
        i := i - 1;
      end while;
    end if;
  end if;
  // fixme: add info and revision section and also unit tests that
  // test the function for different inputs
end searchIndex1D;
