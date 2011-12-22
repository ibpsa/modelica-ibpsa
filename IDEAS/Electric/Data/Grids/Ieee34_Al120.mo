within IDEAS.Electric.Data.Grids;
record Ieee34_AL120
  "IEEE 34 Bus Grid District 1 (AL120,AL70,Al35) - freestanding"
  /*
    This uses 1 phase for distribution (impedance is for 1 phase)... to make it the equivalent of a 3 phase,
    impedances could be divided by 3
  */
   extends IDEAS.Electric.Data.Interfaces.GridType(
  Pha=IDEAS.Electric.Data.Layouts.Ieee34.Pha,n=IDEAS.Electric.Data.Layouts.Ieee34.n,
    T_matrix=IDEAS.Electric.Data.Layouts.Ieee34.T_matrix,
     LenVec={0,48,16,16,40,32,16,16,16,16,16,16,32,32,16,32,32,32,48,48,32,32,16,16,16,16,16,32,32,16,32,16,16,16},
     CabTyp={IDEAS.Electric.Data.Cables.PvcAl120(),
                                 IDEAS.Electric.Data.Cables.PvcAl120(),
                                                     IDEAS.Electric.Data.Cables.PvcAl120(),
              IDEAS.Electric.Data.Cables.PvcAl120(),
                                  IDEAS.Electric.Data.Cables.PvcAl120(),
                                                      IDEAS.Electric.Data.Cables.PvcAl120(),
              IDEAS.Electric.Data.Cables.PvcAl120(),
                                  IDEAS.Electric.Data.Cables.PvcAl120(),
                                                      IDEAS.Electric.Data.Cables.PvcAl120(),
              IDEAS.Electric.Data.Cables.PvcAl120(),
                                  IDEAS.Electric.Data.Cables.PvcAl120(),
                                                      IDEAS.Electric.Data.Cables.PvcAl120(),
              IDEAS.Electric.Data.Cables.PvcAl120(),
                                  IDEAS.Electric.Data.Cables.PvcAl120(),
                                                      IDEAS.Electric.Data.Cables.PvcAl120(),
              IDEAS.Electric.Data.Cables.PvcAl120(),
                                  IDEAS.Electric.Data.Cables.PvcAl70(),
                                                     IDEAS.Electric.Data.Cables.PvcAl70(),
              IDEAS.Electric.Data.Cables.PvcAl35(),
                                 IDEAS.Electric.Data.Cables.PvcAl35(),
                                                    IDEAS.Electric.Data.Cables.PvcAl35(),
              IDEAS.Electric.Data.Cables.PvcAl35(),
                                 IDEAS.Electric.Data.Cables.PvcAl35(),
                                                    IDEAS.Electric.Data.Cables.PvcAl35(),
              IDEAS.Electric.Data.Cables.PvcAl35(),
                                 IDEAS.Electric.Data.Cables.PvcAl120(),
                                                     IDEAS.Electric.Data.Cables.PvcAl70(),
              IDEAS.Electric.Data.Cables.PvcAl70(),
                                 IDEAS.Electric.Data.Cables.PvcAl70(),
                                                    IDEAS.Electric.Data.Cables.PvcAl70(),
              IDEAS.Electric.Data.Cables.PvcAl70(),
                                 IDEAS.Electric.Data.Cables.PvcAl35(),
                                                    IDEAS.Electric.Data.Cables.PvcAl35(),
              IDEAS.Electric.Data.Cables.PvcAl70()});
end Ieee34_AL120;
