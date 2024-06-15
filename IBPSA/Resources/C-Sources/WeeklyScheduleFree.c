/*

  This code implements a weekly schedule.

  Changelog:
    April 9, 2024 by Filip Jorissen, Builtwins
          Revisions for #1869 to remove a header requirement that contains the number of rows/columns.
    March 30, 2024 by Filip Jorissen, Builtwins
          Revisions for #1860 to avoid memory leaks when calling ModelicaFormatError.
    May 25, 2022 by Michael Wetter, LBNL
          Refactored to comply with C89.
    March 9, 2022 by Filip Jorissen, KU Leuven
         Initial version.
    April 10, 2022 by Filip Jorissen, KU Leuven
        Added tableOnFile option.

*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "WeeklySchedule.h"
#include "ModelicaUtilities.h"

#ifndef WEEKCALFREE_c
#define WEEKCALFREE_c


void weeklyScheduleFree(void * ID) {
  int i;
  WeeklySchedule* scheduleID = (WeeklySchedule*)ID;

  if (ID == NULL) /* Otherwise OM segfaults when IBPSA.Utilities.IO.Files.Examples.WeeklySchedule triggers an error */
    return;

  for (i = 0; i < scheduleID->n_allocatedRulesData; ++i) {
    free(scheduleID->rules[i]->data);
  }
 
  for (i = 0; i < scheduleID->n_allocatedRules; ++i) {
    free(scheduleID->rules[i]);
  }

  if (scheduleID->rules != NULL)
    free(scheduleID->rules);

  free(ID);
  ID = NULL;
}

#endif
