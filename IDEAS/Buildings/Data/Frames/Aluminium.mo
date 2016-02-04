within IDEAS.Buildings.Data.Frames;
record Aluminium "Old aluminium frame"
  extends IDEAS.Buildings.Data.Interfaces.Frame(
    U_value=5.68);
       annotation (Documentation(info="<html>
<p><span style=\"font-family: Sans Serif;\">Source: Ashrae/LBL Window 7.3 software</span></p>
</html>"));

end Aluminium;
