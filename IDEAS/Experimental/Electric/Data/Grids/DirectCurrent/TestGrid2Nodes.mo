within IDEAS.Electric.Data.Grids.DirectCurrent;
record TestGrid2Nodes "2 Node test grid"
 /*
   Simple 2 nodes grid to test components easily.
 */

   extends Electric.Data.Interfaces.DirectCurrent.GridType(
  nNodes=2,
    nodeMatrix=[-1,0;1,-1],
     LenVec={0,48},
     CabTyp={Electric.Data.Cables.DirectCurrent.PvcAl35(),
                                Electric.Data.Cables.DirectCurrent.PvcAl35()});
end TestGrid2Nodes;
