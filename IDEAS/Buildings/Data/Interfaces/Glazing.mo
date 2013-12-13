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
<p><h4><font color=\"#008000\">General description</font></h4></p>
<p><h5>Goal</h5></p>
<p>The <code>Glazing.mo</code> partial describes the material data required for glazing construction modelling.</p>
<p><h4><font color=\"#008000\">Validation </font></h4></p>
<p>No validation required.</p>
</html>"));
end Glazing;
