within Annex60.Experimental.ThermalZones.ReducedOrder.ROM.BaseClasses;
function splitFacVal "Share of vector entries at sum of vector"

  input Integer dimension "Dimension of output vector";
  input Modelica.SIunits.Area[:] AArray "Vector of areas";
  output Real[dimension] splitFacValues "Shares of areas at total area";
  parameter Modelica.SIunits.Area ATot=sum(AArray) "Total area";
protected
  Integer j=1;
algorithm
    for A in AArray loop
      if A > 0 then
        splitFacValues[j] :=A/ATot;
        j :=j + 1;
      end if;
    end for;

  annotation (Documentation(info="<html>
  <p>Calculates the share of a surface area of a wall on the total wall area #
  for a zone if the area of the wall is not zero.</p>
</html>", revisions="<html>
<ul>
<li>December 15, 2015 by Moritz 
Lauster:<br>First Implementation. </li>
</ul>
</html>"));
end splitFacVal;
