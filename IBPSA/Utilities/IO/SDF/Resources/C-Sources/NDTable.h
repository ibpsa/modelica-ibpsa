#ifndef NDTABLE_H_
#define NDTABLE_H_

#ifdef __cplusplus
extern "C" {
#endif

/*! The maximum number of dimensions */
#define MAX_NDIMS 32

/*! Interpolation methods */
typedef enum {
	NDTABLE_INTERP_HOLD = 1,
	NDTABLE_INTERP_NEAREST,
	NDTABLE_INTERP_LINEAR,
	NDTABLE_INTERP_AKIMA,
	NDTABLE_INTERP_FRITSCH_BUTLAND,
	NDTABLE_INTERP_STEFFEN
} NDTable_InterpMethod_t;

/*! Extrapolation methods */
typedef enum {
    NDTABLE_EXTRAP_HOLD = 1,
	NDTABLE_EXTRAP_LINEAR,
	NDTABLE_EXTRAP_NONE
} NDTable_ExtrapMethod_t;

/*! The structure that holds the data values */
typedef struct {
	int		ndims;			   //!< the number of dimensions of the table
	int		dims[MAX_NDIMS];   //!< extents of the dimensions
	int		numel;			   //!< the number of data values
	int 	offs[MAX_NDIMS];   //!< the index offsets for the dimensions
	double *data;			   //!< the data values
	double *scales[MAX_NDIMS]; //!< array of pointers to the scale values
} NDTable_t;

typedef NDTable_t * NDTable_h;

/*! Interpolation status codes */
typedef enum {
	NDTABLE_INTERPSTATUS_UNKNOWN_METHOD  = -4,
	NDTABLE_INTERPSTATUS_DATASETNOTFOUND = -3,
	NDTABLE_INTERPSTATUS_WRONGNPARAMS    = -2,
	NDTABLE_INTERPSTATUS_OUTOFBOUNS      = -1,
    NDTABLE_INTERPSTATUS_OK              =  0
} NDTable_InterpolationStatus;


/*! Get the last error message
 * 
 * @return		the error message
 */
const char * NDTable_get_error_message();

/*! Evaluate the value of the table at the given sample point using the specified inter- and extrapolation methods
 * 
 * @param [in]	table			the table handle
 * @param [in]	nparams			the number of dimensions
 * @param [in]	params			the sample point
 * @param [in]	interp_method	the interpolation method
 * @param [in]	extrap_method	the extrapolation method
 * @param [out]	value			the value at the sample point  
 * 
 * @return		0 if the value could be evaluated, -1 otherwise
 */
int NDTable_evaluate(NDTable_h table, int nparams, const double params[], NDTable_InterpMethod_t interp_method, NDTable_ExtrapMethod_t extrap_method, double *value);

/*! Evalute the total differential of the table at the given sample point and deltas using the specified inter- and extrapolation methods
 * 
 * @param [in]	table			the table handle
 * @param [in]	nparams			the number of dimensions
 * @param [in]	params			the sample point
 * @param [in]	delta_params	the the deltas
 * @param [in]	interp_method	the interpolation method
 * @param [in]	extrap_method	the extrapolation method
 * @param [out]	value			the total differential at the sample point  
 * 
 * @return		0 if the value could be evaluated, -1 otherwise
 */
int NDTable_evaluate_derivative(NDTable_h table, int nparams, const double params[], const double delta_params[], NDTable_InterpMethod_t interp_method, NDTable_ExtrapMethod_t extrap_method, double *value);

/*! The maximum length of an error message */	
#define MAX_MESSAGE_LENGTH 256

/*! Sets the error message */
void NDTable_set_error_message(const char *msg, ...);

/*! Allocates a new table
 *
 *	@return a pointer to the new table
 */
NDTable_h NDTable_alloc_table();

/*! De-allocates a table
 *
 *	@param [in]	pointer to the table to de-allocate
 */
void NDTable_free_table(NDTable_h table);

/*! Converts index to subscripts
 * 
 * @param [in]	index	the index to convert
 * @param [in]	table	the table for which to convert the index
 * @param [out]	subs	the subscripts
 */
void NDTable_ind2sub(const int index, const NDTable_h table, int *subs);

/*! Converts subscripts to index
 * 
 *	@param [in]		subs	the subscripts to convert
 *	@param [in]		table	the table for which to convert the subscripts
 *	@param [out]	index	the index
 */
void NDTable_sub2ind(const int *subs, const NDTable_h table, int *index);

double NDTable_get_value_subs(const NDTable_h table, const int subs[]);

/*! Helper function to the indices for the interpolation
 *
 *  @param [in]		value		the value to search for 
 *  @param [in]		num_values	the number of values 
 *  @param [in]		values		the values 
 *	@param [out]	index		the smallest index in [0;num_values-2] for which values[index] <= value
 *	@param [out]	t			the weight for the linear interpolation s.t. value == (1-t)*values[index] + t*values[index+1] 
 * 
 *	@return 0
 */
void NDTable_find_index(double value, int num_values, const double values[], int *index, double *t, NDTable_ExtrapMethod_t extrap_method);

int NDTable_evaluate_internal(const NDTable_h table, const double *t, const int *subs, int *nsubs, int dim, NDTable_InterpMethod_t interp_method, NDTable_ExtrapMethod_t extrap_method, double *value, double *derivatives);

NDTable_h NDTable_create_table(int ndims, const int *dims, const double *data, const double **scales);

/*! Calculate the number of offsets from the dimensions
 *
 *  @param [in]		ndims		the number of dimensions
 *  @param [in]		dims		the extent of the dimensions
 *	@param [out]	offs		array to write the offsets
 */
void NDTable_calculate_offsets(int ndims, const int dims[], int offs[]);

/*! Calculate the number of elements from the dimensions
 *
 *  @param [in]		ndims		the number of dimensions
 *  @param [in]		dims		the extent of the dimensions
 * 
 *	@return	the number of elements
 */
int NDTable_calculate_numel(int ndims, const int dims[]);

#ifdef __cplusplus
}
#endif

#endif /*NDTABLE_H_*/