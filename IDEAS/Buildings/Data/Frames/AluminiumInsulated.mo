within IDEAS.Buildings.Data.Frames;
record AluminiumInsulated "Low U value aluminium frame"
  extends IDEAS.Buildings.Data.Interfaces.Frame(
    U_value=0.7);

                                          annotation (Documentation(info="<html>
<p>From: https://windows.lbl.gov/adv_sys/NTNU-LBNL-EuropeanFramesReport.pdf</p>
</html>"));
end AluminiumInsulated;
