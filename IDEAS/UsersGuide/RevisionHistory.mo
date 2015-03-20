within IDEAS.UsersGuide;
class RevisionHistory "Revision History"
  extends Modelica.Icons.ReleaseNotes;

  annotation (Documentation(info="<html>
<h4>Version 0.1, 2011-12-11</h4>
<p>This is the first version integrated in the IDEAS tool and made available for the public. </p>
<h4>Version 0.2, 2015-26-01</h4>
<p>The major changes compared to v0.1 are: </p>
<ul>
<li>*.TMY3 is used as default climate file and its reader is adopted from the LBNL Buildings library.</li>
<li>The IDEAS/Buildings/. package is updated so that the building components only require a single connector to be connected with the zone.</li>
<li>All hydronic components in IDEAS/Fluid/. are defined and updated based on the IEA EBC Annex60 models.</li>
</ul>
</html>", revisions=""));
end RevisionHistory;
