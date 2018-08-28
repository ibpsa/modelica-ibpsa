within IDEAS.Buildings.Components.LightingType.BaseClasses;
partial record PartialLighting
  "Record for defining the type of the lighting"
  extends Modelica.Icons.Record;

  parameter Modelica.SIunits.Area A_zone(min=0)
    "Area of the zone";
  annotation (Documentation(revisions="<html>
<ul>
<li>
August 28, 2018 by Iago Cupeiro:<br/>
First implementation
See <a href=\"https://github.com/open-ideas/IDEAS/issues/879\">#879</a>.
</li>
</li>
</ul>
</html>", info="<html>
<p>
This record allows to use the feature <pre>constrainedby</pre> in the partialZone model for the lighting records
</p>
<p>
For the correct working of the model it is important to keep:

<pre>
<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">
<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">
p, li { white-space: pre-wrap; }
</style></head><body style=\" font-family:'MS Shell Dlg 2'; font-size:7.875pt; font-weight:400; font-style:normal;\">
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'Courier New';\">  </span><span style=\" font-family:'Courier New'; color:#0000ff;\">extends </span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New';\">      </span><span style=\" font-family:'Courier New'; color:#ff0000;\">IDEAS.Buildings.Components.LightingType.LightingGains.OpenOfficeLights</span><span style=\" font-family:'Courier New';\">(</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New';\">      A = A_zone);</span></p>
<p>
in order to propagate correctly the zone area
</p>
</html>
"));
end PartialLighting;
