within IDEAS.Occupants.Extern.Files;
model min1 "1-minute data"
  extends IDEAS.Occupants.Extern.Detail(filNam="..\\Inputs\\" + locNam + "_1.txt",
      timestep=60, ending = "_1.text");
end min1;
