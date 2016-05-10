within Annex60.Experimental.ThermalZones.ReducedOrder.ReducedOrderZones.BaseClasses;
function splitFacVal
  "Share of vector entries at sum of vector for multiple vectors"

  input Integer nRow "Number of rows";
  input Integer nCol "Number of columns";
  input Modelica.SIunits.Area[:] AArray "Vector of areas";
  input Modelica.SIunits.Area[nCol] AExt "Area of exterior walls";
  input Modelica.SIunits.Area[nCol] AWin "Area of windows";
  output Real[nRow,nCol] splitFacValues "Split factor values for ThermSplitter";
  parameter Modelica.SIunits.Area ATot=sum(AArray) "Total area";
protected
  Integer j=1 "Row counter";
  Integer k=1 "Column counter";
  Integer l=1 "AArray counter";
algorithm
    for A in AArray loop
      if A > 0 then
        k :=1;
        if l == 1 then
          for AWall in AExt loop
            splitFacValues[j,k] :=(A-AWall)/(ATot-AWall-AWin[k]);
            k := k + 1;
          end for;
        elseif l == 2 then
          for AWall in AExt loop
            splitFacValues[j,k] :=(A-AWin[k])/(ATot-AWall-AWin[k]);
            //splitFacValues[j,k] := 0.5;
            k := k + 1;
          end for;
        else
          for AWall in AExt loop
            splitFacValues[j,k] :=A/(ATot-AWall-AWin[k]);
            //splitFacValues[j,k] := 0.5;
            k := k + 1;
          end for;
        end if;
        j :=j + 1;
      end if;
      l :=l + 1;
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
