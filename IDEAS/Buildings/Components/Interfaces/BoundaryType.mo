within IDEAS.Buildings.Components.Interfaces;
type BoundaryType = enumeration(
    BoundaryWall "Boundary wall",
    InternalWall "Internal wall",
    OuterWall "Outer wall",
    SlabOnGround "Slab on ground",
    External "External connection using propsbus") "Type of zone boundary conditions that should be considered";
