within Annex60.Experimental.ThermalZones.ReducedOrder;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;


annotation (Documentation(info="<html>
<p>Put here brief description of general theory for ROM and why we need the different packages and what they are for.</p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">This package contains models for reduced building physics of thermal zones, reduced by means of number of wall elements and number of RC-elements per wall. Such a reduction leads to a reduced order by means of state variables. Reduced order models are commonly used when simulating multiple buildings (e.g. district scale) or for model predictive control, where simulation speed outweighs high dynamic accuracy. However, you can choose between models with one and four wall elements and you can define the number of RC-elements per wall for each wall and model.</span></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">Explain parameterizsation and link to TEASER.</span></p>
</html>"));
end UsersGuide;
