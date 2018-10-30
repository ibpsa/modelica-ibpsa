IDEAS v2.0
============
[![Build Status](https://travis-ci.org/open-ideas/IDEAS.svg?branch=master)](https://travis-ci.org/open-ideas/IDEAS)

Modelica model environment for Integrated District Energy Assessment Simulations (IDEAS), allowing simultaneous transient simulation of thermal and electrical systems at both building and feeder level.

## Release history
+ September 28th, 2018: IDEAS v2.0 has been released.
+ May 5th, 2017: IDEAS v1.0 has been released.  
   February 16th 2018: A [paper describing IDEAS v1.0](http://www.tandfonline.com/doi/full/10.1080/19401493.2018.1428361) has been published on line.
+ September 2nd, 2015: IDEAS v0.3 has been released.

## Release notes
[This is a link to detailed release notes.](https://github.com/open-ideas/IDEAS/blob/master/ReleaseNotes.md)

## Backwards compatibility:
IDEAS 2.0 is not backwards compatible with IDEAS 1.0, although the required changes should be limited or non-existent for most users.
In the future we hope to provide automated Dymola conversion scripts when making releases.


## License
IDEAS is licensed by [KU Leuven](http://www.kuleuven.be) and [3E](http://www.3e.eu) under a [BSD 3 license](https://htmlpreview.github.io/?https://github.com/open-ideas/IDEAS/blob/master/IDEAS/legal.html).

<!-- ### Development and contribution

1. You may report any bugfixes or suggestions as a [github issue](https://github.com/open-ideas/IDEAS/issues).
2. Contributions in the form of [Pull Requests](https://help.github.com/articles/using-pull-requests) are always welcome. Prior to issuing a pull request, make sure :
    1. your code follows the [Style Guide and Conventions](https://github.com/open-ideas/IDEAS/wiki/Style%20Guide%20and%20GitHub%20Good%20Practice),
    2. you use this **IDEAS** GitHub repository as described in the [GitHub Good Practice Description](https://github.com/open-ideas/IDEAS/wiki/Style%20Guide%20and%20GitHub%20Good%20Practice)
    3. unittests are included for your models, and
    4. the model physics are described in the [Specifications](https://github.com/open-ideas/IDEAS/tree/master/Specifications). -->

## References
### Development of IDEAS
1. F. Jorissen, G. Reynders, R. Baetens, D. Picard, D. Saelens, and L. Helsen. (2018) [Implementation and Verification of the IDEAS Building Energy Simulation Library.](http://www.tandfonline.com/doi/full/10.1080/19401493.2018.1428361) *Journal of Building Performance Simulation*, **11** (6), 669-688, doi: 10.1080/19401493.2018.1428361.
2. R. Baetens, R. De Coninck, F. Jorissen, D. Picard, L. Helsen, D. Saelens (2015). OpenIDEAS - An Open Framework for Integrated District Energy Simulations. In Proceedings of Building Simulation 2015, Hyderabad, 347--354.
3. R. Baetens. (2015) On externalities of heat pump-based low-energy dwellings at the low-voltage distribution grid. PhD thesis, Arenberg Doctoral School, KU Leuven.
4. F. Jorissen, W. Boydens, and L. Helsen. (2017) Validated air handling unit model using indirect evaporative cooling. *Journal of Building Performance Simulation*, **11** (1), 48–64, doi: 10.1080/19401493.2016.1273391
5. R. Baetens, D. Saelens. (2016) Modelling uncertainty in district energy simulations by stochastic residential occupant behaviour. *Journal of Building Performance Simulation* **9** (4), 431–447, doi:10.1080/19401493.2015.1070203.
6. M. Wetter, M. Fuchs, P. Grozman, L. Helsen, F. Jorissen, M. Lauster, M. Dirk, C. Nytsch-geusen, D. Picard, P. Sahlin, and M. Thorade. (2015) IEA EBC Annex 60 Modelica Library - An International Collaboration to Develop a Free Open-Source Model Library for Buildings and Community Energy Systems. In Proceedings of Building Simulation 2015, Hyderabad, 395–402.
7. B. van der Heijde, M. Fuchs,  C. Ribas Tugores, G. Schweiger, K. Sartor, D. Basciotti, D. Müller,C. Nytsch-Geusen, M. Wetter, L. Helsen (2017). Dynamic equation-based thermo-hydraulic pipe model for district heating and cooling systems. *Energy Conversion and Management*, **151**, 158-169.
8. D. Picard, L. Helsen (2014). Advanced Hybrid Model for Borefield Heat Exchanger Performance Evaluation, an Implementation in Modelica. In Proceedings of the 10th International Modelica Conference. Lund, 857-866.
9. D. Picard, L. Helsen (2014). A New Hybrid Model For Borefield Heat Exchangers Performance Evaluation. 2014 ASHRAE ANNUAL CONFERENCE: Vol. 120 (2). ASHRAE: Ground Source Heat Pumps: State of the Art Design, Performance and Research. Seattle, 1-8.
10. Picard D., Jorissen F., Helsen L. (2015). Methodology for Obtaining Linear State Space Building Energy Simulation Models. 11th International Modelica Conference. International Modelica Conference. Paris, 21-23 September 2015 (pp. 51-58).

### Applications of IDEAS
1. D. Picard. (2017) Modeling, optimal control and HVAC design of large buildings using ground source heat pump systems. PhD thesis, Arenberg Doctoral School, KU Leuven.
2. G. Reynders. (2015) Quantifying the impact of building design on the potential of structural storage for active demand response in residential buildings. PhD thesis, Arenberg Doctoral School, KU Leuven.
3. R. De Coninck. (2015) Grey-box based optimal control for thermal systems in buildings - Unlocking energy efficiency and flexibility. PhD thesis, Arenberg Doctoral School, KU Leuven.
4. G. Reynders, T. Nuytten, D. Saelens. (2013) Potential of structural thermal mass for demand-side management in dwellings. *Building and Environment* **64**, 187–199, doi:10.1016/j.buildenv.2013.03.010.
5. R. De Coninck, R. Baetens, D. Saelens, A. Woyte, L. Helsen (2014). Rule-based demand side management of domestic hot water production with heat pumps in zero energy neighbourhoods. *Journal of Building Performance Simulation*, **7** (4), 271-288.
6. R. Baetens, R. De Coninck, J. Van Roy, B. Verbruggen, J. Driesen, L. Helsen, D. Saelens (2012). Assessing electrical bottlenecks at feeder level for residential net zero-energy buildings by integrated system simulation. *Applied Energy*, **96**, 74-83.
7. G. Reynders, J. Diriken, D. Saelens. (2014) Quality of grey-box models and identified parameters as function of the accuracy of input and observation signals. *Energy & Buildings* **82**, 263–274, doi:10.1016/j.enbuild.2014.07.025.
8. F. Jorissen, L. Helsen,  M. Wetter (2015). Simulation Speed Analysis and Improvements of Modelica Models for Building Energy Simulation. In Proceedings of the 11th International Modelica Conference. Paris, 59-69.
9. C. Protopapadaki, G. Reynders, D. Saelens (2014). Bottom-up modeling of the Belgian residential building stock: impact of building stock descriptions. In Proceedings of the 9th International Conference on System Simulation in Buildings. Liège.
10. G. Reynders, J. Diriken, D. Saelens (2014). Bottom-up modeling of the Belgian residential building stock: impact of model complexity. In Proceedings of the 9th International Conference on System Simulation in Buildings. Liège.
11. G. Reynders, J. Diriken, D. Saelens (2015). Impact of the heat emission system on the indentification of grey-box models for residential buildings. *Energy Procedia* **78**, 3300-3305, doi: 10.1016/j.egypro.2015.11.740.
12. I. De Jaeger, G. Reynders, D. Saelens (2017). Impact of spacial accuracy on district energy simulations. *Energy Procedia* **132**, 561-566, doi: 10.1016/j.egypro.2017.09.741
13. G. Reynders, R. Andriamamonjy, R. Klein, D. Saelens (2017). Towards an IFC-Modelica Tool Facilitating Model Complexity Selection for Building Energy Simulation. In Proceedings of the 15th Conference of the International Building Performance Simulation Association. California.
14. G. Reynders, J. Diriken, D. Saelens (2017). Generic characterization method for energy flexibility: Applied to structural thermal storage in residential buildings. *Applied Energy* **198**, 192-202, doi: 10.1016/j.apenergy.2017.04.061
15. F. Jorissen. (2018) Toolchain for optimal control and design of energy systems in buildings. PhD thesis, Arenberg Doctoral School, KU Leuven.
16. Picard D., Sourbron M., Jorissen F., Vana Z., Cigler J., Ferkl L., Helsen L. (2016). Comparison of Model Predictive Control Performance Using Grey-Box and White-Box Controller Models of a Multi-zone Office Building. International High Performance Buildings Conference. International High Performance Buildings Conference. West Lafayette, 11-14 July 2016 (art.nr. 203).


### Bibtex entry for citing IDEAS
Please cite IDEAS using the information below.

```
@article{Jorissen2018ideas,  
author = {Jorissen, Filip and Reynders, Glenn and Baetens, Ruben and Picard, Damien and Saelens, Dirk and Helsen, Lieve},  
journal = {Journal of Building Performance Simulation},    
title = {{Implementation and Verification of the IDEAS Building Energy Simulation Library}},  
volume = {11},
issue = {6},  
pages = {669-688},
doi={10.1080/19401493.2018.1428361},  
year = {2018}  
}
```
