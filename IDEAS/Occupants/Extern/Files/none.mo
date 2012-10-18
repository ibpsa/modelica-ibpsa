within IDEAS.Occupants.Extern.Files;
model none "No data"
  extends IDEAS.Occupants.Extern.Detail(filNam="..\\Inputs\\User_zeros.txt",
      timestep=60, ending = "none", locNam = "none");
end none;
