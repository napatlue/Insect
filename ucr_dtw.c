/******************************************************************************
 *
 * cdtw_dist.c:
 *
 *   This is the C source code for a Matlab executable (MEX) function named
 *   cdtw_dist().  This function returns the Constrained (by Sakoe-Chiba band)
 *   Dynamic Time Warping distance between two time series.  This function has
 *   3 input parameters and 1 return value.
 *
 *     distance = cdtw_dist(query_vector, candidate_vector, radius);
 *
 *   The distance value is the square root of the minimum sum of squared
 *   differences divided by the number of comparisons.  If radius == Inf,
 *   distance is the unconstrained dynamic time warping distance.
 *
 *   Both the time and space complexity of this function are O(mn), where m
 *   is the length of the query_vector and n is the length of the
 *   candidate_vector.
 *
 *   This MEX function was tested using Matlab (R14SP1) for Windows with
 *   Matlab's Lcc C (v2.4).
 *
 *   These Matlab commands were used to compile this function:
 *     mex -setup;
 *     mex cdtw_dist.c;
 *
 *   Dave DeBarr; ddebarr(at)gmu.edu; Sep 17, 2006
 *
 ******************************************************************************/

#include "mex.h"
#include "matrix.h"
#include <stdlib.h>
#include <math.h>
#include <stdio.h>
#include <time.h>

#define min(x,y) ((x)<(y)?(x):(y))
#define max(x,y) ((x)>(y)?(x):(y))
#define dist(x,y) ((x-y)*(x-y))

#define INF 1e20       //Pseudo Infitinte number for this code


/// Data structure for sorting the query
typedef struct Index
    {   double value;
        int    index;
    } Index;

/// Data structure (circular array) for finding minimum and maximum for LB_Keogh envolop
struct deque
{   int *dq;
    int size,capacity;
    int f,r;
};


/// Sorting function for the query, sort by abs(z_norm(q[i])) from high to low
int comp(const void *a, const void* b)
{   Index* x = (Index*)a;
    Index* y = (Index*)b;
    return abs(y->value) - abs(x->value);   // high to low
}

/// Initial the queue at the begining step of envelop calculation
void init(deque* d, int capacity)
{
    d->capacity = capacity;
    d->size = 0;
    d->dq = (int *) malloc(sizeof(int)*d->capacity);
    d->f = 0;
    d->r = d->capacity-1;
}

/// Destroy the queue
void destroy(deque *d)
{
    free(d->dq);
}

/// Insert to the queue at the back
void push_back(struct deque *d, int v)
{
    d->dq[d->r] = v;
    d->r--;
    if (d->r < 0)
        d->r = d->capacity-1;
    d->size++;
}

/// Delete the current (front) element from queue
void pop_front(struct deque *d)
{
    d->f--;
    if (d->f < 0)
        d->f = d->capacity-1;
    d->size--;
}

/// Delete the last element from queue
void pop_back(struct deque *d)
{
    d->r = (d->r+1)%d->capacity;
    d->size--;
}

/// Get the value at the current position of the circular queue
int front(struct deque *d)
{
    int aux = d->f - 1;

    if (aux < 0)
        aux = d->capacity-1;
    return d->dq[aux];
}

/// Get the value at the last position of the circular queueint back(struct deque *d)
int back(struct deque *d)
{
    int aux = (d->r+1)%d->capacity;
    return d->dq[aux];
}

/// Check whether or not the queue is empty
int empty(struct deque *d)
{
    return d->size == 0;
}

/// Finding the envelop of min and max value for LB_Keogh
/// Implementation idea is intoruduced by Danial Lemire in his paper
/// "Faster Retrieval with a Two-Pass Dynamic-Time-Warping Lower Bound", Pattern Recognition 42(9), 2009.
void lower_upper_lemire(double *t, int len, int r, double *l, double *u)
{
    struct deque du, dl;

    init(&du, 2*r+2);
    init(&dl, 2*r+2);

    push_back(&du, 0);
    push_back(&dl, 0);

    for (int i = 1; i < len; i++)
    {
        if (i > r)
        {
            u[i-r-1] = t[front(&du)];
            l[i-r-1] = t[front(&dl)];
        }
        if (t[i] > t[i-1])
        {
            pop_back(&du);
            while (!empty(&du) && t[i] > t[back(&du)])
                pop_back(&du);
        }
        else
        {
            pop_back(&dl);
            while (!empty(&dl) && t[i] < t[back(&dl)])
                pop_back(&dl);
        }
        push_back(&du, i);
        push_back(&dl, i);
        if (i == 2 * r + 1 + front(&du))
            pop_front(&du);
        else if (i == 2 * r + 1 + front(&dl))
            pop_front(&dl);
    }
    for (int i = len; i < len+r+1; i++)
    {
        u[i-r-1] = t[front(&du)];
        l[i-r-1] = t[front(&dl)];
        if (i-front(&du) >= 2 * r + 1)
            pop_front(&du);
        if (i-front(&dl) >= 2 * r + 1)
            pop_front(&dl);
    }
    destroy(&du);
    destroy(&dl);
}

/// Calculate quick lower bound
/// Usually, LB_Kim take time O(m) for finding top,bottom,fist and last.
/// However, because of z-normalization the top and bottom cannot give siginifant benefits.
/// And using the first and last points can be computed in constant time.
/// The prunning power of LB_Kim is non-trivial, especially when the query is not long, say in length 128.
double lb_kim_hierarchy(double *t, double *q, int j, int len, double mean, double std, double bsf = INF)
{
    /// 1 point at front and back
    double d, lb;
    double x0 = (t[j] - mean) / std;
    double y0 = (t[(len-1+j)] - mean) / std;
    lb = dist(x0,q[0]) + dist(y0,q[len-1]);
    if (lb >= bsf)   return lb;

    /// 2 points at front
    double x1 = (t[(j+1)] - mean) / std;
    d = min(dist(x1,q[0]), dist(x0,q[1]));
    d = min(d, dist(x1,q[1]));
    lb += d;
    if (lb >= bsf)   return lb;

    /// 2 points at back
    double y1 = (t[(len-2+j)] - mean) / std;
    d = min(dist(y1,q[len-1]), dist(y0, q[len-2]) );
    d = min(d, dist(y1,q[len-2]));
    lb += d;
    if (lb >= bsf)   return lb;

    /// 3 points at front
    double x2 = (t[(j+2)] - mean) / std;
    d = min(dist(x0,q[2]), dist(x1, q[2]));
    d = min(d, dist(x2,q[2]));
    d = min(d, dist(x2,q[1]));
    d = min(d, dist(x2,q[0]));
    lb += d;
    if (lb >= bsf)   return lb;

    /// 3 points at back
    double y2 = (t[(len-3+j)] - mean) / std;
    d = min(dist(y0,q[len-3]), dist(y1, q[len-3]));
    d = min(d, dist(y2,q[len-3]));
    d = min(d, dist(y2,q[len-2]));
    d = min(d, dist(y2,q[len-1]));
    lb += d;

    return lb;
}

/// LB_Keogh 1: Create Envelop for the query
/// Note that because the query is known, envelop can be created once at the begenining.
///
/// Variable Explanation,
/// order : sorted indices for the query.
/// uo, lo: upper and lower envelops for the query, which already sorted.
/// t     : a circular array keeping the current data.
/// j     : index of the starting location in t
/// cb    : (output) current bound at each position. It will be used later for early abandoning in DTW.
double lb_keogh_cumulative(int* order, double *t, double *uo, double *lo, double *cb, int j, int len, double mean, double std, double best_so_far = INF)
{
    double lb = 0;
    double x, d;

    for (int i = 0; i < len && lb < best_so_far; i++)
    {
        x = (t[(order[i]+j)] - mean) / std;
        d = 0;
        if (x > uo[i])
            d = dist(x,uo[i]);
        else if(x < lo[i])
            d = dist(x,lo[i]);
        lb += d;
        cb[order[i]] = d;
    }
    return lb;
}

/// LB_Keogh 2: Create Envelop for the data
/// Note that the envelops have been created (in main function) when each data point has been read.
///
/// Variable Explanation,
/// tz: Z-normalized data
/// qo: sorted query
/// cb: (output) current bound at each position. Used later for early abandoning in DTW.
/// l,u: lower and upper envelop of the current data
double lb_keogh_data_cumulative(int* order, double *tz, double *qo, double *cb, double *l, double *u, int len, double mean, double std, double best_so_far = INF)
{
    double lb = 0;
    double uu,ll,d;

    for (int i = 0; i < len && lb < best_so_far; i++)
    {
        uu = (u[order[i]]-mean)/std;
        ll = (l[order[i]]-mean)/std;
        d = 0;
        if (qo[i] > uu)
            d = dist(qo[i], uu);
        else
        {   if(qo[i] < ll)
            d = dist(qo[i], ll);
        }
        lb += d;
        cb[order[i]] = d;
    }
    return lb;
}

/// Calculate Dynamic Time Wrapping distance
/// A,B: data and query, respectively
/// cb : cummulative bound used for early abandoning
/// r  : size of Sakoe-Chiba warpping band
double dtw(double* A, double* B, double *cb, int m, int r, double bsf = INF)
{

    double *cost;
    double *cost_prev;
    double *cost_tmp;
    int i,j,k;
    double x,y,z,min_cost;

    /// Instead of using matrix of size O(m^2) or O(mr), we will reuse two array of size O(r).
    cost = (double*)malloc(sizeof(double)*(2*r+1));
    for(k=0; k<2*r+1; k++)    cost[k]=INF;

    cost_prev = (double*)malloc(sizeof(double)*(2*r+1));
    for(k=0; k<2*r+1; k++)    cost_prev[k]=INF;

    for (i=0; i<m; i++)
    {
        k = max(0,r-i);
        min_cost = INF;

        for(j=max(0,i-r); j<=min(m-1,i+r); j++, k++)
        {
            /// Initialize all row and column
            if ((i==0)&&(j==0))
            {
                cost[k]=dist(A[0],B[0]);
                min_cost = cost[k];
                continue;
            }

            if ((j-1<0)||(k-1<0))     y = INF;
            else                      y = cost[k-1];
            if ((i-1<0)||(k+1>2*r))   x = INF;
            else                      x = cost_prev[k+1];
            if ((i-1<0)||(j-1<0))     z = INF;
            else                      z = cost_prev[k];

            /// Classic DTW calculation
            cost[k] = min( min( x, y) , z) + dist(A[i],B[j]);

            /// Find minimum cost in row for early abandoning (possibly to use column instead of row).
            if (cost[k] < min_cost)
            {   min_cost = cost[k];
            }
        }

        /// We can abandon early if the current cummulative distace with lower bound together are larger than bsf
        if (i+r < m-1 && min_cost + cb[i+r+1] >= bsf)
        {   free(cost);
            free(cost_prev);
            return min_cost + cb[i+r+1];
        }

        /// Move current array to previous array.
        cost_tmp = cost;
        cost = cost_prev;
        cost_prev = cost_tmp;
    }
    k--;

    /// the DTW distance is in the last cell in the matrix of size O(m^2) or at the middle of our array.
    double final_dtw = cost_prev[k];
    free(cost);
    free(cost_prev);
    return final_dtw;
}

/// Print function for debugging
void printArray(double *x, int len)
{   for(int i=0; i<len; i++)
        printf(" %6.2lf",x[i]);
    printf("\n");
}

/// If expected error happens, teminated the program.
void error(int id)
{
    if(id==1)
        printf("ERROR : Memory can't be allocated!!!\n\n");
    else if ( id == 2 )
        printf("ERROR : File not Found!!!\n\n");
    else if ( id == 3 )
        printf("ERROR : Can't create Output File!!!\n\n");
    else if ( id == 4 )
    {
        printf("ERROR : Invalid Number of Arguments!!!\n");
        printf("Command Usage:  UCR_DTW.exe  data-file  query-file   m   R\n\n");
        printf("For example  :  UCR_DTW.exe  data.txt   query.txt   128  0.05\n");
    }
    exit(1);
}




/*
  Data Structures:  [A] = array;  [M] = matrix; [S] = scalar
    q  = [A] query time series
    c  = [A] candidate time series
    r  = [S] radius constraint
    d  = [S] dynamic time warping distance
    D  = [M] distance values (with one extra row and column)
    L  = [M] length   values (with one extra row and column)
    sd = [S] squared difference value
    nv = [A] neighboring values
    ql = [S] length of query time series
    cl = [S] length of candidate time series
    qi = [S] index for query time series (rows)
    ci = [S] index for candidate time series (columns)
    i  = [S] index for matrix
    p  = [A] permitted position end points
    ni = [A] neighboring index values
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    double *q, *c, *r, *d, *D, *L, sd, nv[3];
    int ql, cl, qi, ci, i, p[2], ni[3];

    /* check number of inputs and outputs */
    if (nrhs != 3) {
        mexErrMsgTxt("This function requires 3 input arguments.");
    } else if (nlhs > 1) {
        mexErrMsgTxt("This function only returns 1 output value.");
    }

    /* retrieve input arguments */
    q = mxGetPr(prhs[0]);    /* pointer to real values of first  argument  */
    c = mxGetPr(prhs[1]);    /* pointer to real values of second argument */
    r = mxGetPr(prhs[2]);    /* pointer to real value  of third  argument   */

    /* check series lengths */
    ql = mxGetNumberOfElements(prhs[0]);
    cl = mxGetNumberOfElements(prhs[1]);
    if (abs(ql - cl) > r[0]) {
        mexErrMsgTxt("Actual distance falls outside radius constraint.");
    }

    /* allocate memory for the return value */
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    d = mxGetPr(plhs[0]);    /* pointer to Matlab managed memory for result */

    /* initialize the distance and length matrices */
    D = (double *)mxMalloc((ql + 1) * (cl + 1) * sizeof(double));
    L = (double *)mxMalloc((ql + 1) * (cl + 1) * sizeof(double));
    i = INDEX(cl + 1, 0, 0);
    D[i] = 0;
    L[i] = 0;
    /* initialize the first row */
    for (qi = 1; qi <= ql; qi++) {
        i = INDEX(cl + 1, qi, 0);
        D[i] = DBL_MAX;
        L[i] = DBL_MAX;
    }
    /* initialize the first column */
    for (ci = 1; ci <= cl; ci++) {
        i = INDEX(cl + 1, 0, ci);
        D[i] = DBL_MAX;
        L[i] = DBL_MAX;
    }

    /* compute distance values */
    for (qi = 1; qi <= ql; qi++) {
        p[0] = MAX( 1, qi - r[0]);    /* minimum permitted position */
        p[1] = MIN(cl, qi + r[0]);    /* maximum permitted position */

        /* initialize values that precede permitted positions */
        for (ci = 1; ci < p[0]; ci++) {
            i = INDEX(cl + 1, qi, ci);
            D[i] = DBL_MAX;
            L[i] = DBL_MAX;
        }

        /* store distances for permitted positions */
        for (ci = p[0]; ci <= p[1]; ci++) {
            i     = INDEX(cl + 1, qi    , ci    );
            ni[0] = INDEX(cl + 1, qi - 1, ci - 1);    /* neighbor diagonal */
            ni[1] = INDEX(cl + 1, qi - 1, ci    );    /* neighbor above    */
            ni[2] = INDEX(cl + 1, qi    , ci - 1);    /* neighbor left     */
            sd    = (q[qi - 1] - c[ci - 1]) * (q[qi - 1] - c[ci - 1]);
            nv[0] = D[ni[0]];
            nv[1] = D[ni[1]];
            nv[2] = D[ni[2]];
            if (nv[0] < nv[1]) {
                if (nv[0] < nv[2]) {           /* min so far is diagonal   */
                    D[i] = sd + nv[0];
                    L[i] = L[ni[0]] + 1;
                } else if (nv[0] > nv[2]) {    /* min so far is left       */
                    D[i] = sd + nv[2];
                    L[i] = L[ni[2]] + 1;
                } else {                       /* diagonal or left         */
                    D[i] = sd + nv[0];
                    L[i] = MIN(L[ni[0]], L[ni[2]]) + 1;
                }
            } else if (nv[0] > nv[1]) {
                if (nv[1] < nv[2]) {           /* min so far is above      */
                    D[i] = sd + nv[1];
                    L[i] = L[ni[1]] + 1;
                } else if (nv[1] > nv[2]) {    /* min so far is left       */
                    D[i] = sd + nv[2];
                    L[i] = L[ni[2]] + 1;
                } else {                       /* above or left            */
                    D[i] = sd + nv[1];
                    L[i] = MIN(L[ni[1]], L[ni[2]]) + 1;
                }
            } else {
                if (nv[0] < nv[2]) {           /* diagonal or above        */
                    D[i] = sd + nv[0];
                    L[i] = MIN(L[ni[0]], L[ni[1]]) + 1;
                } else if (nv[0] > nv[2]) {    /* min so far is left       */
                    D[i] = sd + nv[2];
                    L[i] = L[ni[2]] + 1;
                } else {                       /* diagonal, left, or above */
                    D[i] = sd + nv[0];
                    L[i] = MIN(MIN(L[ni[0]], L[ni[1]]), L[ni[2]]) + 1;
                }
            }
        }

        /* initialize values that succeed permitted positions */
        for (ci = p[1] + 1; ci <= cl; ci++) {
            i = INDEX(cl + 1, qi, ci);
            D[i] = DBL_MAX;
            L[i] = DBL_MAX;
        }
    }

    /* store the normalized square root of the minimum distance */
    i = INDEX(cl + 1, ql, cl);
    d[0] = sqrt(D[i]) / L[i];
    mxFree(D);
    mxFree(L);
}
