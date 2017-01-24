within IDEAS.Electric.BaseClasses.Types;
record ComplexCharacteristicImpedance = Complex (redeclare
      CharacteristicResistance re,                                  redeclare
      CharacteristicReactance im) "Complex Characterisitc impedance";
