/*

  This code implements a weekly schedule. Input text example:

#some comment
double  tab1(3,5) # another comment
# blabla
mon:0:0:10              -       3       1       -
tue,thu:20:30:59        123     -       45      -
wed,sat,sun             12      1       4       -


	License: BSD3

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 Changelog:
 		March 9, 2022 by Filip Jorissen, KU Leuven
 				Initial version.


*/


#ifndef WEEKCAL_h
#define WEEKCAL_h

typedef struct TimeDataTuple {
	double time;	/* Time relative to monday midnight. */
	double *data; /* Corresponding column data */
} TimeDataTuple;


typedef struct WeeklySchedule {


	double t_offset;	/* Time offset for monday, midnight. */
	int n_rows_in;	/* Number of input rows */
	int n_cols_in; /* Number of input columns */
	int n_rowsUnpacked;	/* Number of rows: number of rows after unpacking the date */

	double previousTimestamp;	/* Time where the schedule was called the previous time */
	int previousIndex; 				/* Index where the schedule was called the previous time */

	struct TimeDataTuple ** schedule;


} WeeklySchedule;



void *weeklyScheduleInit(const char* name, const double t_offset);

void weeklyScheduleFree(void * ID);

double getScheduleValue(void * ID, const int column, const double time);

#endif
