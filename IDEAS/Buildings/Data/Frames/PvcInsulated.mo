within IDEAS.Buildings.Data.Frames;
record PvcInsulated "Low U value PVC frame"
    extends IDEAS.Buildings.Data.Interfaces.Frame(
    U_value=0.75);
      annotation (Documentation(info="<html>
<p>From: https://windows.lbl.gov/adv_sys/NTNU-LBNL-EuropeanFramesReport.pdf</p>
</html>"));
end PvcInsulated;
