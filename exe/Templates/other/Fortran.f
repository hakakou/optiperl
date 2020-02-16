c------------------------------------------------------------------------------|
c                                                                              |
c                                                                              |
c                                                                              |
c                                                                              |
c                                                                              |
c------------------------------------------------------------------------------|

      PROGRAM PROG


      INTEGER MAX, N
      PARAMETER (MAX = 300)

c Function returns random number
      REAL*4 RAN
c NDP Fortran defaults to REAL*4
      DIMENSION X(MAX)

      WRITE (*,100)
      WRITE (*,101) 'Program prompts for array size'
      WRITE (*,101) 'Maximum is 300 - Enter 0 to end'

   10 WRITE (*,100)
      WRITE (*,102)
      READ (*,103) N
      WRITE (*,100)

      IF (N .GT. MAX) THEN
        WRITE (*,104) 'Array size limit is ',MAX
        GOTO 10
      ENDIF
    
      DO 200 I = 1, N
            X(I) = 100.0 * RAN(1.0)
  200 CONTINUE

      END
