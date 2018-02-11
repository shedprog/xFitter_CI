      SUBROUTINE SIMPS(A1,B1,H1,REPS1,AEPS1,FUNCT,X,AI,AIH,AIABS)
      IMPLICIT REAL*8(A-H,O-Z)
C SIMPS
C A1,B1 -THE LIMITS OF INTEGRATION
C H1    -AN INITIAL STEP OF INTEGRATION
C REPS1,AEPS1 - RELATIVE AND ABSOLUTE PRECISION OF INTEGRATION
C FUNCT -A NAME OF FUNCTION SUBPROGRAM FOR CALCULATION OF INTEGRAND +
C X - AN ARGUMENT OF THE INTEGRAND
C AI - THE VALUE OF INTEGRAL
C AIH- THE VALUE OF INTEGRAL WITH THE STEP OF INTEGRATION
C AIABS- THE VALUE OF INTEGRAL FOR MODULE OF THE INTEGRAND
C THIS SUBROGRAM CALCULATES THE DEFINITE INTEGRAL WITH THE RELATIVE OR
C ABSOLUTE PRECISION BY SIMPSON+S METHOD WITH THE AUTOMATICAL CHOICE
C OF THE STEP OF INTEGRATION
C IF AEPS1    IS VERY SMALL(LIKE 1.E-17),THEN CALCULATION OF INTEGRAL
C WITH REPS1,AND IF REPS1 IS VERY SMALL (LIKE 1.E-10),THEN CALCULATION
C OF INTEGRAL WITH AEPS1
C WHEN  AEPS1=REPS1=0. THEN CALCULATION WITH THE CONSTANT STEP H1
C..
      DIMENSION F(7),P(5)
      EXTERNAL FUNCT
C
      H=DSIGN(H1,B1-A1)
      S=DSIGN(1.D0,H)
      A=A1
      B=B1
      AI=0.D0
      AIH=0.D0
      AIABS=0.D0
      P(2)=4.D0
      P(4)=4.D0
      P(3)=2.D0
      P(5)=1.D0
      IF ((B-A).LT.0) THEN
         GOTO 1
      ELSEIF ((B-A).EQ.0) THEN
         GOTO 2
      ELSEIF ((B-A).GT.0) THEN
         GOTO 1
      ENDIF
    1 REPS=DABS(REPS1)
      AEPS=DABS(AEPS1)
      DO 3 K=1,7
  3   F(K)=10.D16
      X=A
      C=0.D0
      F(1)=FUNCT(X)/3.D0
    4 X0=X
      IF (((X0+4.D0*H-B)*S).LT.0) THEN
         GOTO 5
      ELSEIF (((X0+4.D0*H-B)*S).EQ.0) THEN
         GOTO 5
      ELSEIF (((X0+4.D0*H-B)*S).GT.0) THEN
         GOTO 6
      ENDIF
    6 H=(B-X0)/4.D0
      IF (H.LT.0) THEN
         GOTO 7
      ELSEIF (H.EQ.0) THEN
         GOTO 2
      ELSEIF (H.GT.0) THEN
         GOTO 7
      ENDIF
    7 DO 8 K=2,7
  8   F(K)=10.D16
      C=1.D0
    5 DI2=F(1)
      DI3=DABS(F(1))
      DO 9 K=2,5
      X=X+H
      IF (((X-B)*S).LT.0) THEN
         GOTO 23
      ELSEIF (((X-B)*S).EQ.0) THEN
         GOTO 24
      ELSEIF (((X-B)*S).GT.0) THEN
         GOTO 24
      ENDIF
   24 X=B
   23 CONTINUE
      IF ((F(K)-10.D16).LT.0) THEN
         GOTO 10
      ELSEIF ((F(K)-10.D16).EQ.0) THEN
         GOTO 11
      ELSEIF ((F(K)-10.D16).GT.0) THEN
         GOTO 10
      ENDIF
   11 F(K)=FUNCT(X)/3.D0
   10 DI2=DI2+P(K)*F(K)
    9 DI3=DI3+P(K)*DABS(F(K))
      DI1=(F(1)+4.D0*F(3)+F(5))*2.D0*H
      DI2=DI2*H
      DI3=DI3*H
      IF (REPS.LT.0) THEN
         GOTO 12
      ELSEIF (REPS.EQ.0) THEN
         GOTO 13
      ELSEIF (REPS.GT.0) THEN
         GOTO 12
      ENDIF
   13 CONTINUE
      IF (AEPS.LT.0) THEN
         GOTO 12
      ELSEIF (AEPS.EQ.0) THEN
         GOTO 14
      ELSEIF (AEPS.GT.0) THEN
         GOTO 12
      ENDIF
   12 EPS=DABS((AIABS+DI3)*REPS)
      IF ((EPS-AEPS).LT.0) THEN
         GOTO 15
      ELSEIF ((EPS-AEPS).EQ.0) THEN
         GOTO 16
      ELSEIF ((EPS-AEPS).GT.0) THEN
         GOTO 16
      ENDIF
   15 EPS=AEPS
   16 DELTA=DABS(DI2-DI1)
      IF ((DELTA-EPS).LT.0) THEN
         GOTO 20
      ELSEIF ((DELTA-EPS).EQ.0) THEN
         GOTO 21
      ELSEIF ((DELTA-EPS).GT.0) THEN
         GOTO 21
      ENDIF
   20 CONTINUE
      IF ((DELTA-EPS/8.D0).LT.0) THEN
         GOTO 17
      ELSEIF ((DELTA-EPS/8.D0).EQ.0) THEN
         GOTO 14
      ELSEIF ((DELTA-EPS/8.D0).GT.0) THEN
         GOTO 14
      ENDIF
   17 H=2.D0*H
      F(1)=F(5)
      F(2)=F(6)
      F(3)=F(7)
      DO 19 K=4,7
  19  F(K)=10.D16
      GO TO 18
   14 F(1)=F(5)
      F(3)=F(6)
      F(5)=F(7)
      F(2)=10.D16
      F(4)=10.D16
      F(6)=10.D16
      F(7)=10.D16
   18 DI1=DI2+(DI2-DI1)/15.D0
      AI=AI+DI1
      AIH=AIH+DI2
      AIABS=AIABS+DI3
      GO TO 22
   21 H=H/2.D0
      F(7)=F(5)
      F(6)=F(4)
      F(5)=F(3)
      F(3)=F(2)
      F(2)=10.D16
      F(4)=10.D16
      X=X0
      C=0.D0
      GO TO 5
   22 CONTINUE
      IF (C.LT.0) THEN
         GOTO 2
      ELSEIF (C.EQ.0) THEN
         GOTO 4
      ELSEIF (C.GT.0) THEN
         GOTO 2
      ENDIF
    2 RETURN
         END
