-- These stored procedures assume that you have already run DEMOBLD7.SQL


create or replace package Employee as
 type NUMARRAY is table of NUMBER  index by BINARY_INTEGER;   --Define EMPNOS array
 type VCHAR2ARRAY is table of VARCHAR2(10)  index by BINARY_INTEGER;   --Define ENAMES array
 PROCEDURE GetEmpNamesInArray (ArraySize IN INTEGER, inEmpnos IN NUMARRAY, outEmpNames OUT VCHAR2ARRAY);
 PROCEDURE GetEmpName (inEmpno IN NUMBER, outEmpName OUT VARCHAR2);
 FUNCTION GetEmpSal (inEmpno IN NUMBER)  RETURN NUMBER;

end Employee;
/


create or replace package body Employee as

PROCEDURE GetEmpNamesInArray (ArraySize IN INTEGER, inEmpnos IN NUMARRAY, outEmpNames OUT VCHAR2ARRAY) is
--ArrIndex INTEGER;
BEGIN 
FOR I in 1..ArraySize loop   
    SELECT ENAME into outEmpNames(I) from EMP WHERE EMPNO = inEmpNos(I);
        INSERT INTO part_nos(partno, description) VALUES (inEmpNos(I), outEmpNames(I));
END LOOP; 
END;


PROCEDURE GetEmpName (inEmpno IN NUMBER, outEmpName OUT VARCHAR2) is 
BEGIN 
 SELECT ENAME into outEmpName from EMP WHERE EMPNO = inEmpNo;
END;

FUNCTION GetEmpSal (inEmpno IN NUMBER)
RETURN NUMBER is 
  outEmpsal NUMBER(7,2);
BEGIN 
  SELECT SAL into outEmpsal from EMP WHERE EMPNO = inEmpno;
  RETURN (outEmpsal);
END;

end Employee;
/