within Annex60.Experimental.ThermalZones.ReducedOrder.BaseClasses;
function splitFacVal "Values for splitFactor in ROM"

  input Integer dimension;
  input Modelica.SIunits.Area[:] AArray;
  output Real[dimension] splitFacValues;
  parameter Modelica.SIunits.Area ATot=sum(AArray);
protected
  Integer j=1;
algorithm
    for A in AArray loop
      if A > 0 then
        splitFacValues[j] :=A/ATot;
        j :=j + 1;
      end if;
    end for;

end splitFacVal;
