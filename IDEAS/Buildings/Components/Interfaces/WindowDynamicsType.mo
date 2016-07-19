within IDEAS.Buildings.Components.Interfaces;
type WindowDynamicsType = enumeration(
    None "No dynamics: window glazing and frame are steady state",
    Combined "One state connected to glazing AND frame: non-physical!",
    Two) "Type of dynamics that are used for window models";
