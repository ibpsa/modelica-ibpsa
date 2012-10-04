within IDEAS.Occupants.Extern.Files;
model min5 "5-minute data"
  extends IDEAS.Occupants.Extern.Detail(filNam="..\\Inputs\\" + locNam + "_5.txt",
      timestep=300, ending = "_5.text");
end min5;
