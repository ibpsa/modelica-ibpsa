within IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical;
type PVType = enumeration(
    MonoSI
      "Single-crystalline Silicon PV technology",
    PolySI "Poly-crystalline Silicon PV technology",
    ThinFilmSI
      "Thin film Silicon PV technology",
    ThreeJuncAmorphous "Three-junction amorphous PV technology")
 "Enumeration to define definition of the PV technology"
  annotation(Documentation(info="<html>
<p>
Enumeration to define the PV material type used in the PV models.
</p>
</html>",
        revisions="<html>
<ul>
<li>
Oct 6, 2023, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
