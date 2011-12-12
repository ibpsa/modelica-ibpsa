within IDEAS.Thermal;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  class Implementation "Implementation notes"
    extends Modelica.Icons.Information;

    annotation (Documentation(info="<html>
<p>
This class summarizes general information about the implementation which is not stated elsewhere.
</p>
<ol>
<li>The <code>&lt;caption&gt;</code> tag is currently not supported in some tools.</li>
<li>The <code>&amp;sim;</code> symbol (i.e., '&sim;' ) is currently not supported in some tools.</li>
<li>The <code>&amp;prop;</code> symbol (i.e., '&prop;' ) is currently not supported in some tools.</li>
</ol>
</html>"));
  end Implementation;

  class References "References"
    extends Modelica.Icons.References;

    annotation (Documentation(info="<html>

<ol>
<li> Citation formats should be unified according to IEEE Transactions style.</li>
<li> Reference should be formated as tables with two columns.</li>
</ol>

<p>In the following the reference formats will be explained based on five examples:</p>

<ul>
<li> Journal (or conference) [Gao2008] </li>
<li> Book [Andronov1973]</li>
<li> Master's thesis [Woehrnschimmel1998]</li>
<li> PhD thesis [Farnleitner1999]</li>
<li> Technical report [Marlino2005]</li>
</ul>

<p>The <a href=\"modelica://Modelica.UsersGuide.Conventions.Documentation.Format.References\">citation</a> is also explained.</p>

<h4>Example</h4>

<pre>
&lt;table border=\"0\" cellspacing=\"0\" cellpadding=\"2\"&gt;
    &lt;tr&gt;
      &lt;td valign=\"top\"&gt;[Gao2008]&lt;/td&gt;
      &lt;td valign=\"top\"&gt;Z. Gao, T. G. Habetler, R. G. Harley, and R. S. Colby,
        &quot;A sensorless  rotor temperature estimator for induction
                 machines based on a current harmonic spectral
                 estimation scheme,&quot;
        &lt;i&gt;IEEE Transactions on Industrial Electronics&lt;/i&gt;,
        vol. 55, no. 1, pp. 407-416, Jan. 2008.&lt;/td&gt;
    &lt;/tr&gt;
    &lt;tr&gt;
      &lt;td valign=\"top\"&gt;[Andronov1973]&lt;/td&gt;
      &lt;td valign=\"top\"&gt;A. Andronov, E. Leontovich, I. Gordon, and A. Maier,
        &lt;i&gt;Theory of  Bifurcations of Dynamic Systems on a plane&lt;/i&gt;,
        1st ed. New York: J. Wiley &amp; Sons, 1973.&lt;/td&gt;
    &lt;/tr&gt;
    &lt;tr&gt;
      &lt;td valign=\"top\"&gt;[Woehrnschimmel1998]&lt;/td&gt;
      &lt;td valign=\"top\"&gt;R. W&ouml;hrnschimmel,
        &quot;Simulation, modeling and fault detection for vector
              controlled induction machines,&quot;
        Master&#39;;s thesis, Vienna University of Technology,
        Vienna, Austria, 1998.&lt;/td&gt;
    &lt;/tr&gt;
    &lt;tr&gt;
      &lt;td valign=\"top\"&gt;[Farnleitner1999]&lt;/td&gt;
      &lt;td valign=\"top\"&gt;E. Farnleitner,
        &quot;Computational ?uid dynamics analysis for rotating
              electrical machinery,&quot;
        Ph.D. dissertation, University of Leoben,
        Department  of Applied Mathematics, Leoben, Austria, 1999.&lt;/td&gt;
    &lt;/tr&gt;
    &lt;tr&gt;
      &lt;td valign=\"top\"&gt;[Marlino2005]&lt;/td&gt;
      &lt;td valign=\"top\"&gt;L. D. Marlino,
        &quot;Oak ridge national laboratory annual progress report for the
              power electronics and electric machinery program,&quot;
      Oak Ridge National Laboratory, prepared for the U.S. Department of Energy,
      Tennessee, USA, Tech. Rep. FY2004 Progress Report, January 2005.&lt;/td&gt;
    &lt;/tr&gt;
&lt;/table&gt;</pre>

<p>appears as</p>

<table border=\"0\" cellspacing=\"0\" cellpadding=\"2\">
    <tr>
      <td valign=\"top\">[Gao08]</td>
      <td valign=\"top\">Z. Gao, T. G. Habetler, R. G. Harley, and R. S. Colby,
        &quot;A sensorless  rotor temperature estimator for induction
                 machines based on a current harmonic spectral
                 estimation scheme,&quot;
        <i>IEEE Transactions on Industrial Electronics</i>,
        vol. 55, no. 1, pp. 407-416, Jan. 2008.</td>
    </tr>
    <tr>
      <td valign=\"top\">[Andronov1973]</td>
      <td valign=\"top\">A. Andronov, E. Leontovich, I. Gordon, and A. Maier,
        <i>Theory of  Bifurcations of Dynamic Systems on a plane</i>,
        1st ed. New York: J. Wiley &amp; Sons, 1973.</td>
    </tr>
    <tr>
      <td valign=\"top\">[Woehrnschimmel1998]</td>
      <td valign=\"top\">R. W&ouml;hrnschimmel,
        &quot;Simulation, modeling and fault detection for vector
              controlled induction machines,&quot;
        Master&#39;;s thesis, Vienna University of Technology,
        Vienna, Austria, 1998.</td>
    </tr>
    <tr>
      <td valign=\"top\">[Farnleitner1999]</td>
      <td valign=\"top\">E. Farnleitner,
        &quot;Computational Fluid dynamics analysis for rotating
              electrical machinery,&quot;
        Ph.D. dissertation, University of Leoben,
        Department  of Applied Mathematics, Leoben, Austria, 1999.</td>
    </tr>
    <tr>
      <td valign=\"top\">[Marlino2005]</td>
      <td valign=\"top\">L. D. Marlino,
        &quot;Oak ridge national laboratory annual progress report for the
              power electronics and electric machinery program,&quot;
      Oak Ridge National Laboratory, prepared for the U.S. Department of Energy,
      Tennessee, USA, Tech. Rep. FY2004 Progress Report, January 2005.</td>
    </tr>
</table>

</html>"));
  end References;

  class Contact "Contact"
    extends Modelica.Icons.Contact;

    annotation (Documentation(info="<html>
<p>This package is developed an maintained by the following contributors </p>
<table cellspacing=\"0\" cellpadding=\"2\" border=\"1\"><tr>
<td></td>
<td><p>Name</p></td>
<td><p>Affiliation</p></td>
</tr>
<tr>
<td valign=\"top\"><p>Library officer</p></td>
<td valign=\"top\"><p><a href=\"mailto:roel.deconinck@mech.kuleuven.be\">R. De Coninck</a> </p></td>
<td valign=\"top\"><p><a href=\"http://www.mech.kuleuven.be/en/tme/research/thermal_systems/\">KU Leuven - University of Leuven</a></p><p>Applied Mechanics and Energy Conversion, Department of Mechanical Engineering, KU Leuven, Celestijnenlaan 300a bus 2421, BE-3001 Leuven (Heverlee) Belgium </p></td>
</tr>
<tr>
<td valign=\"top\"><p>Contributor</p></td>
<td valign=\"top\"><p><a href=\"mailto:lieve.helsen@mech.kuleuven.be\">L. Helsen</a> </p></td>
<td valign=\"top\"><p><a href=\"http://www.mech.kuleuven.be/en/tme/research/thermal_systems/\">KU Leuven - University of Leuven</a></p><p>Applied Mechanics and Energy Conversion, Department of Mechanical Engineering, KU Leuven, Celestijnenlaan 300a bus 2421, BE-3001 Leuven (Heverlee) Belgium </p></td>
</tr>
</table>
</html>"));
  end Contact;

  class RevisionHistory "Revision History"
    extends Modelica.Icons.ReleaseNotes;

    annotation (Documentation(info="<html>

<ol>
<li> The revision history needs to answer the question:
     What has changed and what are the improvements over the previous versions and revision.</li>
<li> The revision history includes the documentation of the development history of each class and/or package.</li>
<li> Version number, revision number, date, author and comments shall be included.</li>
</ol>

<h5>Example</h5>

<pre>
&lt;table border=\"1\" cellspacing=\"0\" cellpadding=\"2\"&gt;
    &lt;tr&gt;
      &lt;th&gt;Version&lt;/th&gt;
      &lt;th&gt;Revision&lt;/th&gt;
      &lt;th&gt;Date&lt;/th&gt;
      &lt;th&gt;Author&lt;/th&gt;
      &lt;th&gt;Comment&lt;/th&gt;
    &lt;/tr&gt;
    ...
    &lt;tr&gt;
      &lt;td valign=\"top\"&gt;1.0.1&lt;/td&gt;
      &lt;td valign=\"top\"&gt;828&lt;/td&gt;
      &lt;td valign=\"top\"&gt;2008-05-26&lt;/td&gt;
      &lt;td valign=\"top\"&gt;A. Haumer&lt;br&gt;C. Kral&lt;/td&gt;
      &lt;td valign=\"top\"&gt;Fixed bug in documentation&lt;/td&gt;
    &lt;/tr&gt;
    &lt;tr&gt;
      &lt;td valign=\"top\"&gt;1.0.0&lt;/td&gt;
      &lt;td valign=\"top\"&gt;821&lt;/td&gt;
      &lt;td valign=\"top\"&gt;2008-05-21&lt;/td&gt;
      &lt;td valign=\"top\"&gt;A. Haumer&lt;/td&gt;
      &lt;td valign=\"top\"&gt;&lt;/td&gt;
    &lt;/tr&gt;
&lt;/table&gt;</pre>

<p>This code appears then as in the \"Revisions\" section below.</p>

</html>",
  revisions="<html>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
    <tr>
      <th>Version</th>
      <th>Revision</th>
      <th>Date</th>
      <th>Author</th>
      <th>Comment</th>
    </tr>
    <tr>
      <td valign=\"top\">1.1.0</td>
      <td valign=\"top\"></td>
      <td valign=\"top\">2010-04-22</td>
      <td valign=\"top\">C. Kral</td>
      <td valign=\"top\">Migrated Conventions to UsersGuide of MSL</td>
    </tr>
    <tr>
      <td valign=\"top\">1.0.5</td>
      <td valign=\"top\">3540</td>
      <td valign=\"top\">2010-03-11</td>
      <td valign=\"top\">D. Winkler</td>
      <td valign=\"top\">Updated image links guide to new 'modelica://' URIs, added contact details</td>
    </tr>
    <tr>
      <td valign=\"top\">1.0.4</td>
      <td valign=\"top\">2960</td>
      <td valign=\"top\">2009-09-28</td>
      <td valign=\"top\">C. Kral</td>
      <td valign=\"top\">Applied new rules for equations as discussed on the 63rd Modelica Design Meeting</td>
    </tr>
    <tr>
      <td valign=\"top\">1.0.3</td>
      <td valign=\"top\">2579</td>
      <td valign=\"top\">2008-05-26</td>
      <td valign=\"top\">D. Winkler</td>
      <td valign=\"top\">Layout fixes and enhancements</td>
    </tr>
    <tr>
      <td valign=\"top\">1.0.1</td>
      <td valign=\"top\">828</td>
      <td valign=\"top\">2008-05-26</td>
      <td valign=\"top\">A. Haumer<br>C. Kral</td>
      <td valign=\"top\">Fixed bug in documentation</td>
    </tr>
    <tr>
      <td valign=\"top\">1.0.0</td>
      <td valign=\"top\">821</td>
      <td valign=\"top\">2008-05-21</td>
      <td valign=\"top\">A. Haumer</td>
      <td valign=\"top\"></td>
    </tr>
</table>
</html>"));
  end RevisionHistory;

annotation (__Dymola_DocumentationClass=true, Documentation(info="<html>
<p>The UsersGuide of each package should consist of the following classes</p>
<ol>
<li> <a href=\"modelica://Modelica.UsersGuide.Conventions.UsersGuide.Contact\">Contact</a> information of
     the library officer and the co-authors </li>
<li> Optional <a href=\"modelica://Modelica.UsersGuide.Conventions.UsersGuide.Implementation\">Implementation Notes</a> to give general information about the implementation
<li> <a href=\"modelica://Modelica.UsersGuide.Conventions.UsersGuide.References\">References</a> for summarizing the literature of the package</li>
<li> <a href=\"modelica://Modelica.UsersGuide.Conventions.UsersGuide.RevisionHistory\">Revision history </a> to summarize the most important changes and improvements of the package</li>
</ol>
</html>"));
end UsersGuide;
