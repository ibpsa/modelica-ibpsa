within IDEAS.Buildings.Components.Examples.BaseClasses;
model window "Window with pre-filled in parameters to be used in IDEAS.Buildings.Components.Examples.RectangularZone2 example"
  extends Window(
    redeclare IDEAS.Buildings.Validation.Data.Glazing.GlaBesTest glazing,
    A=12,
    frac=0,
    redeclare IDEAS.Buildings.Components.Shading.None shaType,redeclare IDEAS.Buildings.Data.Frames.None fraType);
end window;
