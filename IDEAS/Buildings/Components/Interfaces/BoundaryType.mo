within IDEAS.Buildings.Components.Interfaces;
type BoundaryType = enumeration(
    BoundaryWall "Boundary wall",
    InternalWall "Internal wall",
    OuterWall "Outer wall",
    SlabOnGround "Slab on ground",
    External "External connection using propsbus",
    BoundaryWallAndWindow "Boundary wall and window",
    InternalWallAndWindow "Internal wall and window",
    OuterWallAndWindow "Outer wall and window",
    ExternalAndWindow "External connection using propsbus and window") "Type of zone boundary conditions that should be considered";
