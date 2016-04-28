within Annex60.Experimental.ThermalZones.ReducedOrder.ReducedOrderZones.BaseClasses;
function splitFacVal "Share of vector entries at sum of vector"

  input Integer dimension "Dimension of output vector";
  input Modelica.SIunits.Area[:] AArray "Vector of areas";
  input Modelica.SIunits.Area ASep "Area that should not be considered";
  output Real[dimension] splitFacValues "Shares of areas at total area";
  parameter Modelica.SIunits.Area ATot=sum(AArray) "Total area";
protected
  Integer j=1 "Counter";
algorithm
    for A in AArray loop
      if A > 0 then
        splitFacValues[j] :=(A-ASep)/(ATot-ASep);
        j :=j + 1;
      end if;
    end for;

  annotation (Documentation(info="<html>
  <p>Calculates the ratio of the surface areas of a wall to the total wall area,
  unless the area is zero.
  </p>
  </html>", revisions="<html>
  <ul>
  <li>December 15, 2015 by Moritz
  Lauster:<br>First Implementation. </li>
  </ul>
  </html>"));
end splitFacVal;
