within IDEAS.Buildings.Data.Interfaces;
record Glazing

  extends Modelica.Icons.MaterialProperty;

  parameter Integer nLay(min=1)
    "Number of layers of the glazing, including gaps";
  parameter IDEAS.Buildings.Data.Interfaces.Material[nLay] mats
    "Array of materials";
  parameter Real[:, nLay + 1] SwAbs
    "Absorbed solar radiation for each layer as function of angle of incidence";
  parameter Real[:, 2] SwTrans
    "Transmitted solar radiation as function of angle of incidence";
  parameter Real[nLay] SwAbsDif
    "Absorbed solar radiation for each layer as function of angle of incidence";
  parameter Real SwTransDif
    "Transmitted solar radiation as function of angle of incidence";

  parameter Real U_value "U-value";
  parameter Real g_value "g-value";

  annotation (Documentation(info="<html>
  <p>
  The <code>Glazing.mo</code> partial describes the material data 
  required for glazing construction modelling.
  </p>
  <p>
  The correct parameter values for your type of glazing can be 
  generated using the 
  <a href=\"http://windows.lbl.gov/software/window/window.html\">Window software from LBNL</a>. 
  In the software open the &QUOT;glazing system&QUOT; library. 
  On this page choose the number of layers (typical two or three) and 
  fill in the glazing types. Make sure to &QUOT;flip&QUOT; the glass sheet 
  when necessary so that the coating is on the correct side of the glass. 
  Press calc to calculate the parameters.
  </p>
  <p>
  The resulting parameters can be filled in as follows. 
  </p>
  <p>
  In result tab &QUOT;Center of Glass Results&QUOT; copy <code>Ufactor</code>
  to <code>U_value</code>. In result tab &QUOT;Angular data&QUOT; open 
  &QUOT;Angular data&QUOT;. Fill in the values of <code>Tsol</code> 
  (0-90 degrees) in <code>SwTrans</code>. The last value (Hemis) is filled 
  in under <code>SwTransDif</code>. Fill in the values under <code>Abs1</code>, 
  <code>Abs2</code>, <code>Abs3</code> in into <code>SwAbs</code> and 
  <code>SwAbsDif</code> in a similar fashion. Parameter <code>g_value</code> 
  does not need to be filled in. 
  </p>
</html>"));
end Glazing;
