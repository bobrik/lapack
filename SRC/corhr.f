*> \brief \b CORHR
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download CORHR + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/corhr.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/corhr.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/corhr.f">
*> [TXT]</a>
*>
*  Definition:
*  ===========
*
*       SUBROUTINE CORHR( M, N, MB1, NB1, A, LDA, T1, LDT1, NB2, T2,
*      $                  LDT2, D, WORK, LWORK, INFO )
*
*       .. Scalar Arguments ..
*       INTEGER           INFO, LDA, LDT1, LDT2, LWORK, M, N, MB1,
*      $                  NB1, NB2
*       ..
*       .. Array Arguments ..
*       COMPLEX           A( LDA, * ), D( * ), T1( LDT1, * ),
*      $                  T2( LDT2, * ), WORK( * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> CORHR performs Householder reconstruction from the orthogonal
*> M-by-M matrix Q_in stored in an implicit form in the matrices
*> A and T1 computed by the tall-skinny QR factorization routine
*> CLATSQR. The reconstructed orthogonal M-by-M matrix Q_out is
*> stored in a different implicit form in the matrices A and T2.
*> This implicit output format in A and T2 is the same as the output
*> in A and T from the QR factorization routine CGEQRT. CORHR is
*> a high-level routine that uses a single one-dimensional work array
*> WORK of dimension LWORK. CORHR tests the input parameters, allocates
*> workspace and calls the auxiliary low-level routine CLAORHR to do
*> the computation. See Further Details section.
*>
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] M
*> \verbatim
*>          M is INTEGER
*>          The number of rows of the matrix A.  M >= 0.
*> \endverbatim
*>
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The number of columns of the matrix A. M >= N >= 0.
*> \endverbatim
*>
*> \param[in] MB1
*> \verbatim
*>          MB1 is INTEGER
*>          The row block size used by CLATSQR to compute the input
*>          arrays A and T1 (MB1 is called MB in CLATSQR,
*>          see Further Details). MB1 > N.
*>          (Note that if MB1 > M, then M is used instead of MB1
*>          as the row block size).
*> \endverbatim
*>
*> \param[in] NB1
*> \verbatim
*>          NB1 is INTEGER
*>          The column block size used by CLATSQR to compute the input
*>          arrays A and T1 (NB1 is called NB in CLATSQR,
*>          see Further Details). NB1 >= 1.
*>          (Note that if NB1 > N, then N is used instead of NB1
*>          as the column block size).
*> \endverbatim
*>
*> \param[in,out] A
*> \verbatim
*>          A is COMPLEX array, dimension (LDA,N)
*>
*>          The elements on and above the diagonal:
*>
*>             On entry, the elements on and above the diagonal
*>             contain the N-by-N upper-triangular matrix R_in
*>             computed by CLATSQR. See Further Details.
*>
*>             On exit, the elements on and above the diagonal
*>             contain the N-by-N upper-triangular matrix R_out
*>             reconstructed by this routine. See Further Details.
*>
*>             NOTE: In general R_in is not equal to R_out element-wise.
*>
*>
*>          The elements below the diagonal:
*>
*>             On entry, the elements below the diagonal represent
*>             the M-by-M matrix Q_in in implicit form by the columns
*>             of blocked matrix V computed by CLATSQR
*>             (same format as the output A in CLATSQR).
*>             See Further Details.
*>
*>             On exit, the elements below the diagonal represent
*>             the unit lower-trapezoidal M-by-N NB2-size column-blocked
*>             matrix Y, where the subdiagonal elements are the column
*>             vectors Y(i). The unit entries along the diagonal of Y
*>             are not stored in A. The matrix Y along with the matrix
*>             T2 defines Q_out. The vectors Y(i) define the elementary
*>             reflectors (same format as the output A in CGEQRT).
*>             See Further Details.
*> \endverbatim
*>
*> \param[in] LDA
*> \verbatim
*>          LDA is INTEGER
*>          The leading dimension of the array A.  LDA >= max(1,M).
*> \endverbatim
*>
*> \param[in] T1
*> \verbatim
*>          T1 is COMPLEX array, dimension (LDT1, N * NIRB),
*>
*>          where NIRB = Number_of_input_row_blocks
*>                     = max( 1, CEIL((M-N)/(MB1-N)) )
*>          Let NICB = Number_of_input_col_blocks
*>                   = CEIL(N/NB1)
*>
*>          The upper-triangular block reflectors used to define
*>          Q_in stored in compact form in NIRB block reflector
*>          sequences. Each of NIRB block reflector sequences is stored
*>          in a larger NB1-by-N column block of T1 and consists of NICB
*>          smaller NB1-by-NB1 upper-triangular column blocks.
*>          (same format as the output T in CLATSQR).
*>          The matrix T1 and the matrix V stored in A define Q_in.
*>          See Further Details.
*> \endverbatim
*>
*> \param[in] LDT1
*> \verbatim
*>          LDT1 is INTEGER
*>          The leading dimension of the array T1.
*>          LDT1 >= max(1,min(NB1,N)).
*> \endverbatim
*>
*> \param[in] NB2
*> \verbatim
*>          NB2 is INTEGER
*>          The column block size to be used in the blocked Householder
*>          QR output of this routine in the array A and array T2.
*>          NB2 can be chosen independently of NB1. NB2 >= 1.
*>          (Note that if NB2 > N, then N is used instead of NB2
*>          as the column block size.)
*> \endverbatim
*>
*> \param[out] T2
*> \verbatim
*>          T2 is COMPLEX array, dimension (LDT2, N)
*>
*>          Let NOCB = Number_of_output_col_blocks
*>                   = CEIL(N/NB2)
*>
*>          On exit, T2(1:NB2, 1:N) contains NOCB upper-triangular
*>          block reflectors used to define Q_out stored in compact
*>          form as a sequence of upper-triangular NB2-by-NB2 column
*>          blocks (same format as the output T in CGEQRT).
*>          The matrix T2 and the matrix Y stored in A define Q_out.
*>          See Further Details.
*> \endverbatim
*>
*> \param[in] LDT2
*> \verbatim
*>          LDT2 is INTEGER
*>          The leading dimension of the array T2.
*>          LDT2 >= max(1,min(NB2,N)).
*> \endverbatim
*>
*> \param[out] D
*> \verbatim
*>          D is COMPLEX array, dimension min(M,N)
*>          The elements can be only ( +1.0, 0.0 ) or (-1.0, 0.0 ).
*>
*>          D(i) is constructed as D(i)=-SIGN(Q1_in_i(i,i)), where
*>          1 <= i <= min(M,N), Q1_in is the left M-by-N
*>          submatrix of the input orthogonal M-by-M matrix Q_in
*>          implicitly defined by the matrix A and the matrix T1 on
*>          entry. Q1_in_i is the value after performing i-1 steps
*>          of "modified" Gaussian elimination. See Further Details.
*> \endverbatim
*>
*> \param[out] WORK
*> \verbatim
*>          WORK is (workspace) COMPLEX array,
*>          dimension (max(2,LWORK))
*>          On exit, if INFO = 0, WORK(1) returns the optimal LWORK.
*> \endverbatim
*>
*> \param[in] LWORK
*> \verbatim
*>          The dimension of the array WORK.  LWORK >= (M+NB1)*N.
*>          If LWORK = -1, then a workspace query is assumed.
*>          The routine only calculates the optimal size of the WORK
*>          array, returns this value as the first entry of the WORK
*>          array, and no error message related to LWORK is issued
*>          by XERBLA.
*> \endverbatim
*>
*> \param[out] INFO
*> \verbatim
*>          INFO is INTEGER
*>          = 0:  successful exit
*>          < 0:  if INFO = -i, the i-th argument had an illegal value
*> \endverbatim
*>
*> \par Further Details:
*  =====================
*>
*> \verbatim
*>
*> For Further Details see Further Details in the documentation
*> for CLAORHR.
*>
*> \endverbatim
*>
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date June 2019
*
*> \ingroup complexGEcomputational
*
*> \par Contributors:
*  ==================
*>
*> \verbatim
*>
*> June 2019, Igor Kozachenko,
*>            Computer Science Division,
*>            University of California, Berkeley
*>
*> \endverbatim
*
*  =====================================================================
      SUBROUTINE CORHR( M, N, MB1, NB1, A, LDA, T1, LDT1, NB2, T2,
     $                  LDT2, D, WORK, LWORK, INFO )
      IMPLICIT NONE
*
*  -- LAPACK computational routine (version 3.9.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     June 2019
*
*     .. Scalar Arguments ..
      INTEGER           INFO, LDA, LDT1, LDT2, LWORK, M, N, MB1,
     $                  NB1, NB2
*     ..
*     .. Array Arguments ..
      COMPLEX           A( LDA, * ), D( * ), T1( LDT1, * ),
     $                  T2( LDT2, * ), WORK( * )
*     ..
*
*  =====================================================================
*
*     ..
*     .. Local Scalars ..
      LOGICAL            LQUERY
      INTEGER            IINFO, LDW, LW, LW1, LW2, NB1LOCAL, NB2LOCAL
*     ..
*     .. External Subroutines ..
      EXTERNAL           CLAMTSQR, CLAORHR, XERBLA
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          CMPLX, INT, MAX, MIN
*     ..
*     .. Executable Statements ..
*
*     Test the input parameters
*
      LQUERY  = LWORK.EQ.-1
      INFO = 0
      IF( M.LT.0 ) THEN
         INFO = -1
      ELSE IF( N.LT.0 .OR. M.LT.N ) THEN
         INFO = -2
      ELSE IF( MB1.LE.N ) THEN
         INFO = -3
      ELSE IF( NB1.LT.1 ) THEN
         INFO = -4
      ELSE IF( LDA.LT.MAX( 1, M ) ) THEN
         INFO = -6
      ELSE IF( LDT1.LT.MAX( 1, MIN( NB1, N ) ) ) THEN
         INFO = -8
      ELSE IF( NB2.LT.1 ) THEN
         INFO = -9
      ELSE IF( LDT2.LT.MAX( 1, MIN( NB2, N ) ) ) THEN
         INFO = -11
      ELSE
*
*        Test the input LWORK for the dimension of the array WORK
*        and determine allocation space for work arrays in CLAORHR.
*
         IF( LWORK.LT.2 .AND. (.NOT.LQUERY) ) THEN
            INFO = -14
         ELSE
*
*           Set block sizes for column blocks
*
            NB1LOCAL = MIN( NB1, N )
            NB2LOCAL = MIN( NB2, N )
*
*           LWORK = -1, then set the size for the work array W(LDW,N)
*           in CLAORHR, and query the optimal size of the work array
*           WORK(LWORK) in CLAORHR, WORK in CLAORHR is only used
*           to call CLAMTSQR from CLAORHR.
*
            LDW = M
            LW1 = LDW*N
            CALL CLAMTSQR( 'L', 'N', M, N, N, MB1, NB1LOCAL,
     $                      A, LDA, T1, LDT1, WORK, LDW,
     $                      WORK(2), -1, IINFO )
            LW2 = INT( WORK( 2 ) )
*
            LW = LW1+LW2
*
            IF( ( LWORK.LT.MAX( 1, LW ) ) .AND. (.NOT.LQUERY) ) THEN
               INFO = -14
            END IF
         END IF
*
      END IF
*
*     Handle error in the input parameters and return workspace query.
*
      IF( INFO.NE.0 ) THEN
         CALL XERBLA( 'CORHR', -INFO )
         RETURN
      ELSE IF ( LQUERY ) THEN
         WORK( 1 ) = CMPLX( LW )
         RETURN
      END IF
*
*     Quick return if possible
*
      IF( MIN( M, N ).EQ.0 ) THEN
         WORK( 1 ) = CMPLX( LW )
         RETURN
      END IF
*
      CALL CLAORHR( M, N, MB1, NB1LOCAL, A, LDA, T1, LDT1,
     $              NB2LOCAL, T2, LDT2, D, WORK, LDW,
     $              WORK(LW1+1), LW2, IINFO )

      WORK( 1 ) = CMPLX( LW )
      RETURN
*
*     End of CORHR
*
      END