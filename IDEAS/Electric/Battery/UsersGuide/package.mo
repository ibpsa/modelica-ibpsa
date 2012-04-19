within IDEAS.Electric.Battery;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;





annotation (__Dymola_DocumentationClass=true, Documentation(info="<html>
<p>The Battery Package implements everything that has to do with a battery system itself.</p>
<p>The possibility exist to charge and discharge the batteries according to a certain strategy (to define) <a href=\"modelica://IDEAS.Electric.Battery.BatterySystemGeneral\">BatterySystemGeneral</a>.</p>
<p>The battery is modeled on system level. The SoC (State of Charge) of the battery is calculated with the energy flows. The models are:</p>
<p><ol>
<li>Battery: Calculation of SoC.</li>
<li>BatteryCtrlGeneral: Depending on the current SoC of the battery system, it may be required to limit the power exchange.</li>
<li>BatterySystemGeneral: Total battery system with connection possibilities to the grid.</li>
</ol></p>
</html>"));
end UsersGuide;
