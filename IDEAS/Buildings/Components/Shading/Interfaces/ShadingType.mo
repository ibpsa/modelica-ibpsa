within IDEAS.Buildings.Components.Shading.Interfaces;
type ShadingType = enumeration(
    None
       "None",
    BuildingShade
                "Buildings shade",
    Overhang
           "Overhang",
    SideFins
           "Side fins",
    Box
      "Box: overhang and side fins",
    Screen
         "Screen",
    OverhangAndScreen
                    "Overhang and screen",
    BoxAndScreen "Box and screen");
