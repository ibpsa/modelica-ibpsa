#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <stdio.h>
#include <float.h>

#include "NDTable.h"

#ifndef MAX
#define MAX(a,b) (((a) > (b)) ? (a) : (b))
#endif

#ifndef MIN
#define MIN(a,b) (((a) < (b)) ? (a) : (b))
#endif

#ifndef NAN
static const unsigned long __nan[2] = { 0xffffffff, 0x7fffffff };
#define NAN (*(const float *) __nan)
#endif

#ifdef _WIN32
#define ISFINITE(x) _finite(x)
#else
#define ISFINITE(x) isfinite(x)
#endif

/** 
Prototype of an interpolation function

@param  table			[in]		table handle
@param  t				[in]		weights for the interpolation (normalized)
@param  subs			[in]		subscripts of the left sample point
@param  subs			[in,out]	subscripts of the right (next) sample point
@param  dim				[in]		index of the current dimension
@param  interp_method	[in]		index of the current dimension
@param  extrap_method	[in]		index of the current dimension
@param  value			[out]		interpoated value
@param  derivatives		[out]		partial derivatives

@return status code
*/
typedef int(*interp_fun)(const NDTable_h table, const double *t, const int *subs, int *nsubs, int dim, NDTable_InterpMethod_t interp_method, NDTable_ExtrapMethod_t extrap_method, double *value, double derivatives[]);

// forward declare inter- and extrapolation functions
static int interp_hold		      (const NDTable_h table, const double *t, const int *subs, int *nsubs, int dim, NDTable_InterpMethod_t interp_method, NDTable_ExtrapMethod_t extrap_method, double *value, double derivatives[]);
static int interp_nearest	      (const NDTable_h table, const double *t, const int *subs, int *nsubs, int dim, NDTable_InterpMethod_t interp_method, NDTable_ExtrapMethod_t extrap_method, double *value, double derivatives[]);
static int interp_linear	      (const NDTable_h table, const double *t, const int *subs, int *nsubs, int dim, NDTable_InterpMethod_t interp_method, NDTable_ExtrapMethod_t extrap_method, double *value, double derivatives[]);
static int interp_akima		      (const NDTable_h table, const double *t, const int *subs, int *nsubs, int dim, NDTable_InterpMethod_t interp_method, NDTable_ExtrapMethod_t extrap_method, double *value, double derivatives[]);
static int interp_fritsch_butland (const NDTable_h table, const double *t, const int *subs, int *nsubs, int dim, NDTable_InterpMethod_t interp_method, NDTable_ExtrapMethod_t extrap_method, double *value, double derivatives[]);
static int interp_steffen         (const NDTable_h table, const double *t, const int *subs, int *nsubs, int dim, NDTable_InterpMethod_t interp_method, NDTable_ExtrapMethod_t extrap_method, double *value, double derivatives[]);
static int extrap_hold		      (const NDTable_h table, const double *t, const int *subs, int *nsubs, int dim, NDTable_InterpMethod_t interp_method, NDTable_ExtrapMethod_t extrap_method, double *value, double derivatives[]);
static int extrap_linear	      (const NDTable_h table, const double *t, const int *subs, int *nsubs, int dim, NDTable_InterpMethod_t interp_method, NDTable_ExtrapMethod_t extrap_method, double *value, double derivatives[]);


void NDTable_find_index(double value, int nvalues, const double *values, int *index, double *t, NDTable_ExtrapMethod_t extrap_method) {
	int i;
	double a, b;
	double min = values[0];
	double max = values[nvalues - 1];
	double range = max - min;

	if(nvalues < 2) {
		*t = 0.0;
		*index = 0;
		return;
	}

	// estimate the index and make sure that i <= 0 and i <= 2nd last 
	i = MAX(0, MIN((int)(nvalues * (value - min) / range), nvalues - 2));

	// go up until value < values[i+1]
	while (i < nvalues - 2 && value > values[i+1]) { i++; }

	// go down until values[i] < value
	while (i > 0 && value < values[i]) { i--; }

	a = values[i];
	b = values[i+1];

	*t = (value - a) / (b - a);
	
	*index = i;
}

int NDTable_evaluate(NDTable_h table, int nparams, const double params[], NDTable_InterpMethod_t interp_method, NDTable_ExtrapMethod_t extrap_method, double *value) {
	int		 i;
	double	 t	   [MAX_NDIMS]; // the weights for the interpolation
	int		 subs  [MAX_NDIMS];	// the subscripts
	int		 nsubs [MAX_NDIMS];	// the neighboring subscripts
	double	 derivatives [MAX_NDIMS];

	// TODO: add null check

	// if the dataset is scalar return the value
	if (table->ndims == 0) {
		*value = table->data[0];
		return NDTABLE_INTERPSTATUS_OK;
	}

	// find entry point and weights
	for (i = 0; i < table->ndims; i++) {
		NDTable_find_index(params[i], table->dims[i], table->scales[i], &subs[i], &t[i], extrap_method);
	}

	return NDTable_evaluate_internal(table, t, subs, nsubs, 0, interp_method, extrap_method, value, derivatives);
}

int NDTable_evaluate_derivative(NDTable_h table, int nparams, const double params[], const double delta_params[], NDTable_InterpMethod_t interp_method, NDTable_ExtrapMethod_t extrap_method, double *value) {
	int		 i, err;
	double	 t[MAX_NDIMS];		// the weights for the interpolation
	int		 subs[MAX_NDIMS];	// the subscripts
	int		 nsubs[MAX_NDIMS];	// the neighboring subscripts
	double	 derivatives[MAX_NDIMS];

	// TODO: add null check

	// if the dataset is scalar return the value
	if (table->ndims == 0) {
		*value = table->data[0];
		return NDTABLE_INTERPSTATUS_OK;
	}

	// find entry point and weights
	for (i = 0; i < table->ndims; i++) {
		NDTable_find_index(params[i], table->dims[i], table->scales[i], &subs[i], &t[i], extrap_method);
	}

	if ((err = NDTable_evaluate_internal(table, t, subs, nsubs, 0, interp_method, extrap_method, value, derivatives)) != 0) {
		return err;
	}

	*value = 0.0;

	for (i = 0; i < nparams; i++) {
		*value += delta_params[i] * derivatives[i];
	}

	return 0;
}

int NDTable_evaluate_internal(const NDTable_h table, const double *t, const int *subs, int *nsubs, int dim, NDTable_InterpMethod_t interp_method, NDTable_ExtrapMethod_t extrap_method, double *value, double derivatives[]) {

	interp_fun func;

	// check arguments
	if (table == NULL || t == NULL || subs == NULL || nsubs == NULL || value == NULL || derivatives == NULL) {
		return -1;
	}

	if (dim >= table->ndims) {
		*value = NDTable_get_value_subs(table, nsubs);
		return 0;
	}

	// find the right function:
	if(table->dims[dim] < 2) {
		func = interp_hold;
	} else if (t[dim] < 0.0 || t[dim] > 1.0) { 
		// extrapolate
		switch (extrap_method) {
		case NDTABLE_EXTRAP_HOLD:	
			func = extrap_hold; 
			break;
		case NDTABLE_EXTRAP_LINEAR:
			switch (interp_method) {
			case NDTABLE_INTERP_AKIMA:           func = interp_akima;           break;
			case NDTABLE_INTERP_FRITSCH_BUTLAND: func = interp_fritsch_butland; break;
			default:                             func = extrap_linear;			break;
			}
			break;
		default:
			NDTable_set_error_message("Requested value is outside data range");
			return -1;
		}
	} else { 
		// interpolate
		switch (interp_method) {
		case NDTABLE_INTERP_HOLD:	         func = interp_hold;            break;
		case NDTABLE_INTERP_NEAREST:         func = interp_nearest;         break;
		case NDTABLE_INTERP_LINEAR:          func = interp_linear;          break;
		case NDTABLE_INTERP_AKIMA:			 func = interp_akima;           break;
		case NDTABLE_INTERP_FRITSCH_BUTLAND: func = interp_fritsch_butland; break;
		case NDTABLE_INTERP_STEFFEN:         func = interp_steffen;         break;
		default: return -1; // TODO: set error message
		}
	}

	return (*func)(table, t, subs, nsubs, dim, interp_method, extrap_method, value, derivatives);
}

static int interp_hold(const NDTable_h table, const double *t, const int *subs, int *nsubs, int dim, NDTable_InterpMethod_t interp_method, NDTable_ExtrapMethod_t extrap_method, double *value, double der_values[]) {
	nsubs[dim] = subs[dim]; // always take the left sample value
	der_values[dim] = 0;
	return NDTable_evaluate_internal(table, t, subs, nsubs, dim + 1, interp_method, extrap_method, value, der_values);
}

static int interp_nearest(const NDTable_h table, const double *t, const int *subs, int *nsubs, int dim, NDTable_InterpMethod_t interp_method, NDTable_ExtrapMethod_t extrap_method, double *value, double der_values[]) {
	int err;
	nsubs[dim] = t[dim] < 0.5 ? subs[dim] : subs[dim] + 1;
	der_values[dim] = 0;

	if ((err = NDTable_evaluate_internal(table, t, subs, nsubs, dim + 1, interp_method, extrap_method, value, der_values)) != 0) {
		return err;
	}
	
	// if the value is not finite return NAN
	if (!ISFINITE(*value)) {
		*value = NAN;
		der_values[dim] = NAN;
	}

	return 0;
}

static int interp_linear(const NDTable_h table, const double *t, const int *subs, int *nsubs, int dim, NDTable_InterpMethod_t interp_method, NDTable_ExtrapMethod_t extrap_method, double *value, double der_values[]) {
	int err;
	double a, b;

	// get the left value
	nsubs[dim] = subs[dim];
	if ((err = NDTable_evaluate_internal(table, t, subs, nsubs, dim + 1, interp_method, extrap_method, &a, der_values)) != 0) {
		return err;
	}

	// get the right value
	nsubs[dim] = subs[dim] + 1;
	if ((err = NDTable_evaluate_internal(table, t, subs, nsubs, dim + 1, interp_method, extrap_method, &b, der_values)) != 0) {
		return err;
	}

	// if any of the values is not finite return NAN
	if (!ISFINITE(a) || !ISFINITE(b)) {
		*value = NAN;
		der_values[dim] = NAN;
		return 0;
	}

	// calculate the interpolated value
	*value = (1 - t[dim]) * a + t[dim] * b;

	// calculate the derivative
	der_values[dim] = (b - a) / (table->scales[dim][subs[dim] + 1] - table->scales[dim][subs[dim]]);

	return 0;
}

static void cubic_hermite_spline(const double x0, const double x1, const double y0, const double y1, const double t, const double c[4], double *value, double *derivative) {
	
	double v;
	
	if (t < 0) { // extrapolate left
		
		*value = y0 + c[2] * ((x1 - x0) * t);
		*derivative = c[2];

	} else if (t <= 1) { // interpolate
		
		v = (x1 - x0) * t;
		*value = ((c[0] * v + c[1]) * v + c[2]) * v + c[3];
		*derivative = (3 * c[0] * v + (2 * c[1])) * v + c[2];

	} else { // extrapolate right 
		
		v = x1 - x0;
		*value = y1 +   ((3 * c[0] * v + 2 * c[1]) * v + c[2]) * (v * (t - 1));
		*derivative = (3 * c[0] * v + 2 * c[1]) * v + c[2];
	}
}

static int interp_akima(const NDTable_h table, const double *t, const int *subs, int *nsubs, int dim, NDTable_InterpMethod_t interp_method, NDTable_ExtrapMethod_t extrap_method, double *value, double der_values[]) {
	
	double x[6] = { 0, 0, 0, 0, 0, 0};
	double y[6] = { 0, 0, 0, 0, 0, 0};
	double c[4] = { 0, 0, 0, 0 };	   // spline coefficients
    double d[5] = { 0, 0, 0, 0, 0 };   // divided differences 
    double c2   = 0;
	double dx   = 0;
	double a    = 0;
	double v    = 0;

	int n = table->dims[dim]; // extent of the current dimension
	int sub = subs[dim];      // subscript of current dimension
	int err, i, idx;

	for (i = 0; i < 6; i++) {
		idx = sub - 2 + i;

		if (idx >= 0 && idx < n) {
			x[i] = table->scales[dim][idx];

			nsubs[dim] = idx;
			if ((err = NDTable_evaluate_internal(table, t, subs, nsubs, dim + 1, interp_method, extrap_method, &y[i], der_values)) != 0) {
				return err;
			}
		}
	}

	// if any of the values is not finite return NAN
	for (i = 0; i < 6; i++) {
		if (!ISFINITE(y[i])) {
			*value = NAN;
			der_values[dim] = NAN;
			return 0;
		}
	}

	// calculate the divided differences
	for (i = MAX(0, 2 - sub); i < MIN(5, 1 + n - sub); i++) {
		d[i] = (y[i + 1] - y[i]) / (x[i + 1] - x[i]);
	}

	// pad left
	if (sub < 2) {
		if (sub < 1) {
			d[1] = 2.0 * d[2] - d[3];
		}
		d[0] = 2.0 * d[1] - d[2];
	}

	// pad right
	if (sub > n - 4) {
		if (sub > n - 3) {
			d[3] = 2.0 * d[2] - d[1];
		}
		d[4] = 2.0 * d[3] - d[2];
	}

    // initialize the left boundary slope
    c2 = fabs(d[3] - d[2]) + fabs(d[1] - d[0]);
        
	if (c2 > 0) {
        a = fabs(d[1] - d[0]) / c2;
        c2 = (1 - a) * d[1] + a * d[2];
    } else {
        c2 = 0.5 * d[1] + 0.5 * d[2];
    }

    // calculate the coefficients
	dx = x[3] - x[2];

    c[2] = c2;
    c2 = fabs(d[4] - d[3]) + fabs(d[2] - d[1]);
            
	if (c2 > 0) {
        a = fabs(d[2] - d[1]) / c2;
        c2 = (1 - a) * d[2] + a * d[3];
    } else {
        c2 = 0.5 * d[2] + 0.5 * d[3];
    }

	c[1] = (3 * d[2] - 2 * c[2] - c2) / dx;
	c[0] = (c[2] + c2 - 2 * d[2]) / (dx * dx);
    
	c[3] = y[2];

	cubic_hermite_spline(x[2], x[3], y[2], y[3], t[dim], c, value, &der_values[dim]);

	return 0;
}

static int interp_fritsch_butland(const NDTable_h table, const double *t, const int *subs, int *nsubs, int dim, NDTable_InterpMethod_t interp_method, NDTable_ExtrapMethod_t extrap_method, double *value, double der_values[]) {
	
	double x [4] = { 0, 0, 0, 0 };
	double y [4] = { 0, 0, 0, 0 };
	double dx[3] = { 0, 0, 0 };
	double d [3] = { 0, 0, 0 };    // divided differences 
    double c [4] = { 0, 0, 0, 0 }; // spline coefficients
    double c2    = 0;
	double v     = 0;

	int n = table->dims[dim]; // extent of the current dimension
	int sub = subs[dim];      // subscript of current dimension
	int err, i, idx;

	for (i = 0; i < 4; i++) {
		idx = sub - 1 + i;

		if (idx >= 0 && idx < n) {
			x[i] = table->scales[dim][idx];

			nsubs[dim] = idx;
			if ((err = NDTable_evaluate_internal(table, t, subs, nsubs, dim + 1, interp_method, extrap_method, &y[i], der_values)) != 0) {
				return err;
			}
		}
	}

	// if any of the values is not finite return NAN
	for (i = 0; i < 4; i++) {
		if (!ISFINITE(y[i])) {
			*value = NAN;
			der_values[dim] = NAN;
			return 0;
		}
	}

	// calculate the divided differences
	//for (i = MAX(0, 1 - sub); i < MIN(3, n - 1 - sub); i++) {
	for (i = 0; i < 3; i++) {
		dx[i] = x[i + 1] - x[i];
		d[i] = (y[i + 1] - y[i]) / dx[i];
	}

    // initialize the left boundary slope
	
    // calculate the coefficients

	if (sub == 0) {
        c2 = d[1];
    } else if (d[0] == 0 || d[1] == 0 || (d[0] < 0 && d[1] > 0) || (d[0] > 0 && d[1] < 0)) {
        c2 = 0;
     } else {
 		c2 = 3 * (dx[0] + dx[1]) / ((dx[0] + 2 * dx[1]) / d[0] + (dx[1] + 2 * dx[0]) / d[1]);
 	}

    c[2] = c2;

    if (sub == n - 2) {
        c2 = d[1];
    } else if (d[1] == 0 || d[2] == 0 || (d[1] < 0 && d[2] > 0) || (d[1] > 0 && d[2] < 0)) {
        c2 = 0;
     } else {
 		c2 = 3 * (dx[1] + dx[2]) / ((dx[1] + 2 * dx[2]) / d[1] + (dx[2] + 2 * dx[1]) / d[2]);
 	}

    c[1] = (3 * d[1] - 2 * c[2] - c2) / dx[1];
    c[0] = (c[2] + c2 - 2 * d[1]) / (dx[1] * dx[1]);

    c[3] = y[1];

	cubic_hermite_spline(x[1], x[2], y[1], y[2], t[dim], c, value, &der_values[dim]);

	return 0;
}

static int interp_steffen(const NDTable_h table, const double *t, const int *subs, int *nsubs, int dim, NDTable_InterpMethod_t interp_method, NDTable_ExtrapMethod_t extrap_method, double *value, double der_values[]) {
	
	double x [4] = { 0, 0, 0, 0 };
	double y [4] = { 0, 0, 0, 0 };
	double dx[3] = { 0, 0, 0 };
	double d [3] = { 0, 0, 0 };    // divided differences 
    double c [4] = { 0, 0, 0, 0 }; // spline coefficients
    double c2    = 0;
	double v     = 0;

	const int n   = table->dims[dim]; // extent of the current dimension
	const int sub = subs[dim];      // subscript of current dimension
	int err, i, idx;

	for (i = 0; i < 4; i++) {
		idx = sub - 1 + i;

		if (idx >= 0 && idx < n) {
			x[i] = table->scales[dim][idx];

			nsubs[dim] = idx;
			if ((err = NDTable_evaluate_internal(table, t, subs, nsubs, dim + 1, interp_method, extrap_method, &y[i], der_values)) != 0) {
				return err;
			}
		}
	}

	// if any of the values is not finite return NAN
	for (i = 0; i < 4; i++) {
		if (!ISFINITE(y[i])) {
			*value = NAN;
			der_values[dim] = NAN;
			return 0;
		}
	}

	// calculate the divided differences
	for (i = 0; i < 3; i++) {
		dx[i] = x[i + 1] - x[i];
		d[i] = (y[i + 1] - y[i]) / dx[i];
	}

	// calculate the coefficients
	if (sub == 0) {
        c2 = d[1];
    } else if (d[0] == 0 || d[1] == 0 || (d[0] < 0 && d[1] > 0) || (d[0] > 0 && d[1] < 0)) {
        c2 = 0;
    } else {
        double half_abs_c2, abs_di, abs_di1;
        c2 = (d[0] * dx[1] + d[1] * dx[0]) / (dx[0] + dx[1]);
        half_abs_c2 = 0.5 * fabs(c2);
        abs_di = fabs(d[0]);
        abs_di1 = fabs(d[1]);
        if (half_abs_c2 > abs_di || half_abs_c2 > abs_di1) {
            const double two_a = d[0] > 0 ? 2 : -2;
            c2 = two_a*(abs_di < abs_di1 ? abs_di : abs_di1);
        }
    }

    c[2] = c2;
    
	if (sub == n - 2) {
        c2 = d[1];
    } else if (d[1] == 0 || d[2] == 0 || (d[1] < 0 && d[2] > 0) || (d[1] > 0 && d[2] < 0)) {
        c2 = 0;
    } else {
        double half_abs_c2, abs_di, abs_di1;
        c2 = (d[1] * dx[2] + d[2] * dx[1]) / (dx[1] + dx[2]);
        half_abs_c2 = 0.5 * fabs(c2);
        abs_di = fabs(d[1]);
        abs_di1 = fabs(d[2]);
        if (half_abs_c2 > abs_di || half_abs_c2 > abs_di1) {
            const double two_a = d[1] > 0 ? 2 : -2;
            c2 = two_a*(abs_di < abs_di1 ? abs_di : abs_di1);
        }
    }

    c[1] = (3 * d[1] - 2 * c[2] - c2) / dx[1];
    c[0] = (c[2] + c2 - 2 * d[1]) / (dx[1] * dx[1]);
    c[3] = y[1];

	cubic_hermite_spline(x[1], x[2], y[1], y[2], t[dim], c, value, &der_values[dim]);

	return 0;
}

static int extrap_hold(const NDTable_h table, const double *t, const int *subs, int *nsubs, int dim, NDTable_InterpMethod_t interp_method, NDTable_ExtrapMethod_t extrap_method, double *value, double der_values[]) {
	int err;
	nsubs[dim] = t[dim] < 0.0 ? subs[dim] : subs[dim] + 1;
	der_values[dim] = 0;
	
	if ((err = NDTable_evaluate_internal(table, t, subs, nsubs, dim + 1, interp_method, extrap_method, value, der_values)) != 0) {
		return err;
	}
	
	// if the value is not finite return NAN
	if (!ISFINITE(*value)) {
		*value = NAN;
		der_values[dim] = NAN;
	}

	return 0;
}

static int extrap_linear(const NDTable_h table, const double *t, const int *subs, int *nsubs, int dim, NDTable_InterpMethod_t interp_method, NDTable_ExtrapMethod_t extrap_method, double *value, double der_values[]) {
	int err;
	double a, b;

	nsubs[dim] = subs[dim];
	if ((err = NDTable_evaluate_internal(table, t, subs, nsubs, dim + 1, interp_method, extrap_method, &a, der_values)) != 0) {
		return err;
	}

	nsubs[dim] = subs[dim] + 1;
	if ((err = NDTable_evaluate_internal(table, t, subs, nsubs, dim + 1, interp_method, extrap_method, &b, der_values)) != 0) {
		return err;
	}

	// if any of the values is not finite return NAN
	if (!ISFINITE(a) || !ISFINITE(b)) {
		*value = NAN;
		der_values[dim] = NAN;
		return 0;
	}

	// calculate the extrapolated value
	*value = (1 - t[dim]) * a + t[dim] * b;

	// calculate the derivative
	der_values[dim] = (b - a) / (table->scales[dim][subs[dim] + 1] - table->scales[dim][subs[dim]]);

	return 0;
}
