
#ifndef MODELICA_NDTABLE_C
#define MODELICA_NDTABLE_C

#include "ModelicaUtilities.h"

#include "NDTable.h"
#include "NDTable.c"

#define NDTABLE_INTERPSTATUS_OK 0
#include "Interpolation.c"

NDTable_h ModelicaNDTable_open(const int ndims, const double *data, const int size) {

	int rank, i, numel, dims[32];
	const double *scales[32];
	NDTable_h table = NULL;

	if (size < 2) {
		ModelicaError("The number of elements in data must be >= 2");
		return NULL;
	}

	rank = (int)*data++;

	// check the rank
	if (rank < 0 || rank > 32) {
		ModelicaError("The first element in data must be in the range [0;32]");
		return NULL;
	}

	if (rank != ndims) {
		ModelicaFormatError("The first element in data must match the number of inputs. Expected %d but was %d.", ndims, rank);
		return NULL;
	}

	// check the size
	if (size < 1 + rank) {
		ModelicaError("Data has not enough elements for the given number of dimensions");
		return NULL;
	}

	// check the dimensions
	for (i = 0; i < rank; i++) {
		dims[i] = (int)*data++;

		if (dims[i] < 1) {
			ModelicaError("The size of the dimensions must be >= 1");
			return NULL;
		}
	}

	// check the number of elements
	numel = 1;
	
	for (i = 0; i < rank; i++) {
		numel *= dims[i]; // data
	}

	for (i = 0; i < rank; i++) {
		numel += dims[i]; // scales
	}

	numel += rank; // dims
	numel++; // ndims

	if (size != numel) {
		ModelicaFormatError("Data has the wrong number of elements for the given dimensions. Expected %d but was %d.", numel, size);
		return NULL;
	}

	for (i = 0; i < rank; i++) {
		scales[i] = data;
		data += dims[i];
	}

	table = NDTable_create_table(ndims, dims, data, scales);

	if (!table) {
		ModelicaError(NDTable_get_error_message());
	}

	return table;
}


void ModelicaNDTable_close(NDTable_h externalTable) {

	NDTable_free_table(externalTable);

}

double ModelicaNDTable_evaluate(
	NDTable_h table,
	int nparams, 
	const double params[], 
	NDTable_InterpMethod_t interp_method,
	NDTable_ExtrapMethod_t extrap_method) {

	double value;

	if (NDTable_evaluate(table, nparams, params, interp_method, extrap_method, &value)) {
		ModelicaError(NDTable_get_error_message());
	}

	return value;
}

double ModelicaNDTable_evaluate_derivative(
	NDTable_h table,
	int nparams, 
	const double params[],
	NDTable_InterpMethod_t interp_method,
	NDTable_ExtrapMethod_t extrap_method, 
	const double delta_params[]) {

	double value;

	if(NDTable_evaluate_derivative(table, nparams, params, delta_params, interp_method, extrap_method, &value)) {
		ModelicaError(NDTable_get_error_message());
	}

	return value;
}

#endif // MODELICA_NDTABLE_C
