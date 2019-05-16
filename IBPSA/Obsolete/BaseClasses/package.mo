within IBPSA.Obsolete;
package BaseClasses "Package with base classes for IBPSA.Obsolete"
  extends Modelica.Icons.BasesPackage;

  partial class ObsoleteModel
    "Icon for classes that are obsolete and will be removed in later versions"

    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={Rectangle(
            extent={{-102,102},{102,-102}},
            lineColor={255,0,0},
            pattern=LinePattern.Dash,
            lineThickness=0.5)}), Documentation(info="<html>
<p>
This partial class is intended to provide a <u>default icon
for an obsolete model</u> that will be removed from the
corresponding library in a future release.
</p>
</html>"));
  end ObsoleteModel;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains base classes that are used to construct the models in
<a href=\"modelica://IBPSA.Obsolete\">IBPSA.Obsolete</a>.
</p>
</html>"));
end BaseClasses;
