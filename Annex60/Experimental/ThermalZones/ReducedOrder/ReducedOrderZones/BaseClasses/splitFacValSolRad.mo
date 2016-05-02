within Annex60.Experimental.ThermalZones.ReducedOrder.ReducedOrderZones.BaseClasses;
function splitFacValSolRad
  "Share of column entries at sum of column for a matrix"

  input Integer dimensionCol "Dimension of output columns";
  input Integer dimensionRow "Dimension of output rows";
  input Modelica.SIunits.Area[:] AArray "Vector of areas";
  input Modelica.SIunits.Area ASep[:] "Area that should not be considered";
  output Real[dimensionCol, dimensionRow] splitFacValues
    "Shares of areas at total area";
  parameter Modelica.SIunits.Area ATot=sum(AArray) "Total area";
protected
  Integer j=1 "First counter";
  Integer k=1 "Second counter";
algorithm
    for A in AArray loop
      if A > 0 then
        for APart in ASep loop
          splitFacValues[j,k] :=(A-APart)/(ATot-APart);
          k := k + 1;
        end for;
        j :=j + 1;
        k := 1;
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
end splitFacValSolRad;
