USE FINAL_VS

------********************FUNCTIONS*****************------------------------

----ADMIN

---1>    SCALAR FUNCTION
---CALCULATE THE PERCENTAGE OF VOTERS VOTING IN ELECTIONS

/* VOTER RATIO  (function)
the given function will give the admin all the details about how many 
voters voted in the Election and their respective percentages 
formula used
 */

GO
CREATE FUNCTION CIT_VOTER_RATIO()
RETURNS FLOAT
AS
BEGIN
RETURN (
SELECT COUNT(V_ID) * 100.0 / COUNT(CIT_ID) FROM CITIZEN)
END

--SELECT COUNT(V_ID) AS 'TOTAL VOTER' FROM CITIZEN


SELECT DBO.CIT_VOTER_RATIO()  AS 'VOTER RATIO'

---------------------------------------------------------------------------

-----2>     

---CALCULATE THE PERCENTAGE OF NON VOTERS IN ELECTIONS

/* NON-VOTER RATIO (function)
this function will detect those who voted from the total percentage to give the
ratio of those wo didn't woted in the elections
*/

GO
CREATE FUNCTION CIT_NON_VOTER_RATIO()
RETURNS FLOAT
AS
BEGIN
RETURN (100-[DBO].[CIT_VOTER_RATIO]())
END


SELECT DBO.CIT_NON_VOTER_RATIO()  AS 'NON VOTER RATIO'

---3
---CALCULATE GIVEN CAN VOTES

/* CAN_VOTE_COUNT (function)
this function returns the total no of votes achieved by an indivisual party candidate. 
this belongs to the admin user
*/
GO
ALTER FUNCTION CAN_VOTE_COUNT (@CAND_ID INT)
RETURNS INT
AS
BEGIN
RETURN (SELECT SUM(C_V_COUNTER) FROM PARTY_CONDIDATE WHERE C_ID =@CAND_ID)
END



SELECT DBO.CAN_VOTE_COUNT(1987)  AS 'CANDIDATE TOTAL VOTES'

---4
---CALCULATE GIVEN IND CAN VOTES
/* IC_VOTE_COUNT (function)
this function returns the total no of votes achieved by an indivisual 
independantcandidate. this belongs to the admin user*/

GO
CREATE FUNCTION IC_VOTE_COUNT(@INDCAND_ID INT)
RETURNS INT
AS
BEGIN
RETURN (SELECT SUM(IC_V_COUNTER) FROM INDEPENDENT_CONDIDATE WHERE IC_ID =@INDCAND_ID)
END


SELECT DBO.IC_VOTE_COUNT(1909)  AS 'IND CANDIDATE TOTAL VOTES'
---------------------------------------------------------PROCEDURE---------------------------

----CAN FULL LIST WITH VOTES -----
/* CAND_VISE_VOTE:  (procedure)
this procedure belongs to the Admin (user) which will provide the admin with all PARTYcandidates
and their total votes along with their party symbol and candidate id.  */
GO
ALTER PROCEDURE CAN_VISE_VOTE
AS
BEGIN
SELECT P.C_ID,S.SYMBOL, P.C_FNAME, SUM(P.C_V_COUNTER) AS 'TOTAL VOTES' FROM PARTY_CONDIDATE P INNER JOIN
P_SIGN S ON P.C_ID=S.C_ID GROUP BY P.C_FNAME,P.C_ID,S.SYMBOL
END

EXEC CAN_VISE_VOTE


----IND CAN FULL LIST WITH VOTES -----
/* IND_CAND_VISE_VOTE: (procedure)
this procedure belongs to the Admin (user) which will provide the admin with all INDIPENDENT 
candidates and their total votes along with their party symbol and candidate id. */
GO
CREATE PROCEDURE INDCAN_VISE_VOTE
AS
BEGIN
SELECT I.IC_ID,S.SYMBOL, I.IC_FNAME, SUM(I.IC_V_COUNTER) AS 'TOTAL VOTES' FROM INDEPENDENT_CONDIDATE I INNER JOIN
P_SIGN S ON I.IC_ID=S.IC_ID GROUP BY I.IC_FNAME,I.IC_ID,S.SYMBOL
END

EXEC INDCAN_VISE_VOTE

-------------------------------------------------------------------------------------------------------



--------------------------------VOTER -------------------------------------------

--1
/* VOTES @P_CAN_ID INT (procedure)
this procedure will make an increment of 1 when indivisual voter will vote for
his/her favourite party candidate, this belongs to the voter
*/
GO
CREATE PROCEDURE C_VOTES(@CAND_ID INT)
AS
 BEGIN
 UPDATE PARTY_CONDIDATE
SET C_V_COUNTER=C_V_COUNTER+1 WHERE C_ID=@CAND_ID
END

SELECT * FROM PARTY_CONDIDATE
EXEC C_VOTES '2020' 

--2

/* VOTES @IND_CAN_ID INT (procedure)
this function will make an increment of 1 when indivisual voter will vote for his/her
favourite indipendent candidate, this belongs to the voter
*/

GO
CREATE PROCEDURE IC_VOTES(@IND_CAND_ID INT)
AS
 BEGIN
 UPDATE INDEPENDENT_CONDIDATE
SET IC_V_COUNTER=IC_V_COUNTER+1 WHERE IC_ID=@IND_CAND_ID
END


EXEC IC_VOTES '1909' 

SELECT * FROM INDEPENDENT_CONDIDATE


SELECT * FROM INDEPENDENT_CONDIDATE
-------------------------------------------------
/*VOTE_CENTER:  (procedure): 
this procedure is all about displaying the full data of the voting center
alog with their locations so that in case any voter can not vote online can vote through the ballot box*/

GO
CREATE PROCEDURE CENTER_INFO_A
AS
BEGIN
SELECT C.VC_ID, C.VC_DutyOfArmedForces ,L.VC_ADDRESS,L.VC_CITY,L.VC_AREA FROM VC_LOCATION L INNER JOIN
VOTING_CENTER C ON L.VC_ADDRESS=C.VC_ADDRESS
END

EXEC CENTER_INFO_A
----------------------------TRIGGER------------------------------------------------
/* ADDING_ VOTER:
the purpose of making this trigger is that when the Admin will add a voter in the voter 
list thid trigger will pop uo with a confermation message and will tell the total number
of voters after adding the current one
*/
GO
ALTER TRIGGER ADDING_VOTER
ON VOTER
AFTER INSERT, DELETE
AS 
DECLARE @COUNT INT =( SELECT COUNT(V_ID) FROM VOTER)
BEGIN
IF  @COUNT<=10 
BEGIN

IF EXISTS(SELECT * FROM DELETED)
	BEGIN
		PRINT 'RECORD DELETED SUCCESSFULLY....!!!!  ' 
	END
ELSE IF EXISTS(SELECT * FROM INSERTED)
	BEGIN
		PRINT 'RECORD INSERTED SUCCESSFULLY.....!!!!  || TOTOAL NO OF VOTER NOW ARE...' + CAST(@COUNT AS VARCHAR(100))   
	END
END
END
-------------------------------------------------------------------------------
/* ADD PARTY_ CANDIDATE:

the purpose of making this trigger is that when the Admin will add a PARTY CANIDIDATE in
the candidatelist thid trigger will pop uo with a confermation message and will tell the
total number of candidate after adding the current one
AND
this will give an exception if admin tries to add more than 10 party candidate because a
restriction has been imposed on the admin table that the no of candidate shoul not exceed 
total of 10 */


GO
CREATE TRIGGER ADDING_P_CANDIDATE
ON PARTY_CONDIDATE
AFTER INSERT, DELETE
AS 
DECLARE @COUNT INT =( SELECT COUNT(C_ID) FROM PARTY_CONDIDATE)
BEGIN
IF  @COUNT<=10 
BEGIN
IF EXISTS(SELECT * FROM DELETED)
	BEGIN
		PRINT 'RECORD DELETED SUCCESSFULLY....!!!!  ' 
	END
ELSE IF EXISTS(SELECT * FROM INSERTED)
	BEGIN
		PRINT 'RECORD INSERTED SUCCESSFULLY.....!!!!  || TOTOAL NO OF CANDIDATES NOW ARE...' + CAST(@COUNT AS VARCHAR(100))   
	END
END
ELSE
BEGIN
RAISERROR ('NOT MORE THAN 10 CANDIDATE CAN BE INSERTED',10,1)
    ROLLBACK TRANSACTION
	END
END
-------------------------------------------------------------------------------
/* ADD INDEPENDANT_CANDIDATE:

the purpose of making this trigger is that when the Admin will add a INDEPENDENT 
CANIDIDATE in the candidatelist thid trigger will pop uo with a confermation message
and will tell the total number of candidate after adding the current one
AND
this will give an exception if admin tries to add more than 10 party candidate because
a restriction has been imposed on the admin table that the no of candidate shoul not exceed
total of 10
*/
GO
CREATE TRIGGER ADDING_ID_CANDIDATE
ON INDEPENDENT_CONDIDATE
AFTER INSERT, DELETE
AS 
DECLARE @COUNT INT =( SELECT COUNT(IC_ID) FROM INDEPENDENT_CONDIDATE)
BEGIN
IF  @COUNT<=10 
BEGIN
IF EXISTS(SELECT * FROM DELETED)
	BEGIN
		PRINT 'RECORD DELETED SUCCESSFULLY....!!!!  ' 
	END
ELSE IF EXISTS(SELECT * FROM INSERTED)
	BEGIN
		PRINT 'RECORD INSERTED SUCCESSFULLY.....!!!!  || TOTOAL NO OF IND CANDIDATES NOW ARE...' + CAST(@COUNT AS VARCHAR(100))   
	END
END
ELSE
BEGIN
RAISERROR ('NOT MORE THAN 10 IND CANDIDATE CAN BE INSERTED',10,1)
    ROLLBACK TRANSACTION
	END
END
-------------------------------------------------VIEWS-------------------------------------------------------------

/*PC_INFO
 this view will fetch values of party candidate from different tables so that tables remain
 secure and proper abstraction remains in the database and the important information about 
 the candidate does't leak..*/


CREATE VIEW PC_INFO
AS
SELECT S.SYMBOL, P.C_FNAME,P.C_LNAME, SUM(P.C_V_COUNTER) AS 'TOTAL VOTES' FROM PARTY_CONDIDATE P INNER JOIN
P_SIGN S ON P.C_ID=S.C_ID GROUP BY P.C_FNAME,P.C_ID,S.SYMBOL,P.C_LNAME

SELECT * FROM PC_INFO

/*IC_INFO
 this view will fetch values of party candidate from different tables so that tables 
 remain secure and proper abstraction remains in the database and the important information 
 about the candidate does't leak..*/

CREATE VIEW IC_INFO
AS
SELECT I.IC_FNAME,I.IC_LNAME,S.SYMBOL, SUM(I.IC_V_COUNTER) AS 'TOTAL VOTES' FROM INDEPENDENT_CONDIDATE I INNER JOIN
P_SIGN S ON I.IC_ID=S.IC_ID GROUP BY I.IC_FNAME,I.IC_ID,S.SYMBOL,I.IC_LNAME


SELECT * FROM IC_INFO

--------------------------ADMIN VIEWS-----------------------------------------------
/*FULL_INFO_PC
 this view will fetch all the values of party candidate from different tables for the admin
 so that tables remain secure and proper abstraction remains becasue every coulm's real name 
 is changes and have given a new name for the user ..*/


CREATE VIEW FULL_INFO_OF_PC
AS
SELECT P.C_ID AS 'CAN ID' ,CONCAT(P.C_FNAME,' ' ,P.C_LNAME) AS 'CANDIDATE NAME' ,P.C_V_COUNTER AS 'TOTAL VOTES',
I.C_CNIC AS 'CNIC' ,I.C_AGE AS'AGE' ,I.C_GENDER AS'GENDER' FROM PARTY_CONDIDATE P INNER JOIN PC_IDENTIFICATION I
ON P.C_ID=I.C_ID 


SELECT * FROM FULL_INFO_OF_PC

/*FULL_INFO_IC
this view will fetch all the values of independent candidate from different tables for the admin 
so that tables remain secure and proper abstraction remains becasue every coulm's real name is 
changes and have given a new name for the user ..*/

CREATE VIEW FULL_INFO_OF_IC
AS
SELECT P.IC_ID AS 'IND CAN ID' ,CONCAT(P.IC_FNAME,' ' ,P.IC_LNAME) AS 'IND CANDIDATE NAME' ,P.IC_V_COUNTER AS 'TOTAL VOTES',
I.IC_CNIC AS 'CNIC' ,I.IC_AGE AS'AGE' ,I.IC_GENDER AS'GENDER' FROM INDEPENDENT_CONDIDATE P INNER JOIN IC_IDENTIFICATION I
ON P.IC_ID=I.IC_ID 


SELECT * FROM FULL_INFO_OF_IC

-----------------------------------------
/*CITIZEN_INFO

this view will display all the information of a citizen with hiding their original database
name from the user so  that tables remain secure and proper abstraction remains becasue 
every coulm's real name is changes and have given a new name for the user*/

CREATE VIEW CITIZEN_INFO
AS
SELECT C.CIT_ID AS 'PORTAL ID', C.CIT_FNAME AS 'FIRST NAME', C.CIT_LNAME AS 'LAST NAME', I.CIT_CNIC AS 'CINC',
I.CIT_AGE AS 'AGE', I.CIT_GENDER AS 'GENDER' FROM CITIZEN AS C
INNER JOIN CITIZEN_IDENTIFICATION AS I ON
C.CIT_ID=I.CIT_ID


SELECT * FROM CITIZEN_INFO

-------------------------------------------




