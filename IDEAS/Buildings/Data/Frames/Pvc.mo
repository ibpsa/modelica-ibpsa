within IDEAS.Buildings.Data.Frames;
record Pvc "Old PVC frame"
  extends IDEAS.Buildings.Data.Interfaces.Frame(
    U_value=1.7);
     annotation (Documentation(info="<html>
<p>Source: Ashrae/LBL Window 7.3 software</p>
</html>"));
end Pvc;
