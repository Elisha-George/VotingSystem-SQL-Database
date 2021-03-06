CREATE DATABASE FINAL_VS

USE FINAL_VS

--ADMIN TABLE
CREATE TABLE SYS_ADMIN
(
A_ID INT NOT NULL IDENTITY(1,1),
A_USERNAME VARCHAR(20) NOT NULL,
A_PASSWORD VARCHAR(20) CHECK (LEN([A_PASSWORD])>(5) AND [A_PASSWORD] LIKE '%[0-9]%' 
AND [A_PASSWORD] <> LOWER([A_PASSWORD]) COLLATE Latin1_General_CS_AI), 
UNIQUE (A_PASSWORD)
)

ALTER TABLE SYS_ADMIN
   ADD CONSTRAINT A_ID
   PRIMARY KEY (A_ID)


INSERT INTO SYS_ADMIN VALUES('UNZILA','All453')
INSERT INTO SYS_ADMIN VALUES('ELISHA','All101')

SELECT * FROM SYS_ADMIN
-------------------------------------------------------------------------------------

--PARTY CANDIDATE TABLE
CREATE TABLE PARTY_CONDIDATE 
(
C_ID INT NOT NULL CHECK (C_ID > 0 AND C_ID < 9999),
C_FNAME VARCHAR(20),
C_LNAME VARCHAR(20) NOT NULL,
C_V_COUNTER INT
)
ALTER TABLE PARTY_CONDIDATE
   ADD CONSTRAINT C_ID
   PRIMARY KEY (C_ID)


UPDATE PARTY_CONDIDATE
SET C_V_COUNTER=6 WHERE  C_ID = 1987
INSERT INTO PARTY_CONDIDATE VALUES(1987, 'IMRAN' , 'KHAN' , 1)
INSERT INTO PARTY_CONDIDATE VALUES(2020, 'BILAWAL' , 'BHUTTO' , 1)
INSERT INTO PARTY_CONDIDATE VALUES(2010, 'NAWAZ' , 'SHAREEF' , 1)
INSERT INTO PARTY_CONDIDATE VALUES(2011, 'SHEIHK' , 'RASHEED' , 0)

SELECT * FROM PARTY_CONDIDATE
---------------------------------------------------------
--PARTY CANDIDATE IDENTIFICATION TABLE
CREATE TABLE PC_IDENTIFICATION
(
C_ID INT,
C_CNIC BIGINT NOT NULL CHECK (LEN([C_CNIC])=(13) AND [C_CNIC] LIKE '%[0-9]%'),
C_AGE INT CHECK (C_AGE>=18), 
C_GENDER VARCHAR (10) CHECK (C_GENDER IN ('FEMALE','MALE')),
)

DROP TABLE PC_IDENTIFICATION
ALTER TABLE PC_IDENTIFICATION
   ADD CONSTRAINT C_CNIC
   PRIMARY KEY (C_CNIC)
   

ALTER TABLE PC_IDENTIFICATION
   ADD CONSTRAINT C_ID_PK
   FOREIGN KEY (C_ID)
   REFERENCES PARTY_CONDIDATE (C_ID)
   ON DELETE SET NULL
   ON UPDATE CASCADE;
   
INSERT INTO PC_IDENTIFICATION VALUES(1987,4230197966911, 41, 'MALE' )
INSERT INTO PC_IDENTIFICATION VALUES(2020,4230197098765, 66, 'MALE' )
INSERT INTO PC_IDENTIFICATION VALUES(2010,4230165021358, 53, 'MALE' )


SELECT * FROM PC_IDENTIFICATION

----------------------------------------------------------------------------------------------------------------
CREATE TABLE INDEPENDENT_CONDIDATE 
(
IC_ID INT NOT NULL CHECK (IC_ID > 0),
IC_FNAME VARCHAR(20), 
IC_LNAME VARCHAR(20) NOT NULL,
IC_V_COUNTER INT,
)

ALTER TABLE INDEPENDENT_CONDIDATE
   ADD CONSTRAINT IC_ID_PK
   PRIMARY KEY (IC_ID)

UPDATE INDEPENDENT_CONDIDATE
SET IC_V_COUNTER=6 WHERE  IC_ID = 1909
INSERT INTO INDEPENDENT_CONDIDATE VALUES(1909, 'ALTAF' , 'HUSSAIN' , 0)
INSERT INTO INDEPENDENT_CONDIDATE VALUES(4571, 'SAMANDAR' , 'KHAN' , 0)
INSERT INTO INDEPENDENT_CONDIDATE VALUES(9087, 'KASHMALA' , 'TARIQ' , 0)

SELECT * FROM INDEPENDENT_CONDIDATE

----------------------------------------------------------------------------------------------------------------
CREATE TABLE IC_IDENTIFICATION
(
IC_ID INT ,
IC_CNIC BIGINT NOT NULL CHECK (LEN([IC_CNIC])=(13) AND [IC_CNIC] LIKE '%[0-9]%'),
IC_AGE INT CHECK (IC_AGE>=18),
IC_GENDER VARCHAR (10) CHECK (IC_GENDER IN ('FEMALE','MALE')),

)

--DROP TABLE IC_IDENTIFICATION
ALTER TABLE IC_IDENTIFICATION
   ADD CONSTRAINT IC_CNIC
   PRIMARY KEY (IC_CNIC)
   

ALTER TABLE IC_IDENTIFICATION
   ADD CONSTRAINT PK_IC_ID
   FOREIGN KEY (IC_ID)
   REFERENCES INDEPENDENT_CONDIDATE (IC_ID)
   ON DELETE SET NULL
   ON UPDATE CASCADE;

INSERT INTO IC_IDENTIFICATION VALUES(1909,4230668966911, 77, 'MALE' )
INSERT INTO IC_IDENTIFICATION VALUES(4571,4530197098765, 56, 'MALE' )
INSERT INTO IC_IDENTIFICATION VALUES(9087,4660165021358, 53, 'FEMALE' )


SELECT * FROM IC_IDENTIFICATION

---------------------------------------------------------------------------------------------------------
---SIGN TABLE
CREATE TABLE P_SIGN
(
SYMBOL VARCHAR (20) NOT NULL,
C_ID INT,
IC_ID INT
)
DROP TABLE P_SIGN

ALTER TABLE P_SIGN
   ADD CONSTRAINT PK_SIGN
   PRIMARY KEY (SYMBOL)
   

ALTER TABLE P_SIGN
   ADD CONSTRAINT FK_SIGN1
   FOREIGN KEY (C_ID)
   REFERENCES PARTY_CONDIDATE (C_ID)
   ON DELETE SET NULL
   ON UPDATE CASCADE;

ALTER TABLE P_SIGN
   ADD CONSTRAINT FK_SIGN2
   FOREIGN KEY (IC_ID)
   REFERENCES INDEPENDENT_CONDIDATE (IC_ID)
   ON DELETE SET NULL
   ON UPDATE CASCADE;

INSERT INTO P_SIGN(SYMBOL,C_ID) VALUES('BAT',1987)
INSERT INTO P_SIGN(SYMBOL,C_ID) VALUES('TIGER',2020)
INSERT INTO P_SIGN(SYMBOL,C_ID) VALUES('ELEPHANT',2010)
INSERT INTO P_SIGN(SYMBOL,IC_ID) VALUES('BULLET',1909)
INSERT INTO P_SIGN(SYMBOL,IC_ID) VALUES('PEACE',4571)
INSERT INTO P_SIGN(SYMBOL,IC_ID) VALUES('SWORD',9087)

SELECT *  FROM P_SIGN
-------------------------------------------------------------------------------------------------------
--PARTY TABLE
CREATE TABLE PARTY
(
REG_NO CHAR(10) NOT NULL,
P_NAME VARCHAR(20),
SYMBOL VARCHAR (20),
P_DESC VARCHAR(100),
UNIQUE (P_NAME)
)
DROP TABLE PARTY
ALTER TABLE PARTY
   ADD CONSTRAINT PK_PARTY
   PRIMARY KEY (REG_NO)
   

ALTER TABLE PARTY
   ADD CONSTRAINT FK_PARTY
   FOREIGN KEY (SYMBOL)
   REFERENCES P_SIGN (SYMBOL)
   ON DELETE SET NULL
   ON UPDATE CASCADE;
 
INSERT INTO PARTY VALUES('I-313', 'PTI','BAT','BELONGS TO SINDH')
INSERT INTO PARTY VALUES('T-890', 'MMA','TIGER','BELONGS TO SINDH')
INSERT INTO PARTY VALUES('E-666', 'PML','ELEPHANT','BELONGS TO SINDH')
/*INSERT INTO PARTY VALUES('B-786', 'MQM','KITE','BELONGS TO SINDH')
INSERT INTO PARTY VALUES('P-453', 'ANP','FISH','BELONGS TO SINDH')
INSERT INTO PARTY VALUES('I-908', 'PML(Q)','BIKE','BELONGS TO SINDH')*/
select * from party

--------------------------------------------------------------------------------------------------
--VOTER TABLE
CREATE TABLE VOTER 
(
V_ID INT NOT NULL CHECK (V_ID > 0 AND V_ID <9999),
V_FNAME VARCHAR(20),
V_LNAME VARCHAR(20) NOT NULL,
C_ID INT,
IC_ID INT ,

)
ALTER TABLE VOTER
   ADD CONSTRAINT PK_VOTER
   PRIMARY KEY (V_ID)
   

ALTER TABLE VOTER
   ADD CONSTRAINT FK_VOTER1
   FOREIGN KEY (C_ID)
   REFERENCES PARTY_CONDIDATE (C_ID)
   ON DELETE SET NULL
   ON UPDATE CASCADE;

ALTER TABLE VOTER
   ADD CONSTRAINT FK_VOTER2
   FOREIGN KEY (IC_ID)
   REFERENCES INDEPENDENT_CONDIDATE (IC_ID)
   ON DELETE SET NULL
   ON UPDATE CASCADE;

DELETE FROM VOTER
WHERE V_ID=109

UPDATE VOTER
SET V_FNAME='AAMNA' WHERE V_ID=109 

INSERT INTO VOTER(V_ID,V_FNAME,V_LNAME,C_ID) VALUES(109,'AMNA','SHUAKAT' ,2020)
INSERT INTO VOTER(V_ID,V_FNAME,V_LNAME,C_ID) VALUES(101,'UNZILA','SHUAKAT' ,2020)
INSERT INTO VOTER(V_ID,V_FNAME,V_LNAME,IC_ID) VALUES(105,'ELISHA','ALI' ,4571)
INSERT INTO VOTER(V_ID,V_FNAME,V_LNAME,IC_ID) VALUES(106,'RIMSHA','KHAN' ,9087)

select * from VOTER

--------------------------------------------------------------------------------------------------
--VOTER IDENTIFICATION TABLE
CREATE TABLE VOTER_IDENTIFICATION
(
V_ID INT,
V_CNIC BIGINT NOT NULL CHECK (LEN([V_CNIC])>(5) AND [V_CNIC] LIKE '%[0-9]%'),
V_AGE INT CHECK (V_AGE>=18),
V_GENDER VARCHAR (10) CHECK (V_GENDER IN ('FEMALE','MALE')),

)

DROP TABLE VOTER_IDENTIFICATION
ALTER TABLE VOTER_IDENTIFICATION
   ADD CONSTRAINT PK_VOTER_IDENTIFICATION
   PRIMARY KEY (V_CNIC)
   

ALTER TABLE VOTER_IDENTIFICATION
   ADD CONSTRAINT FK_VOTER_IDENTIFICATION
   FOREIGN KEY (V_ID)
   REFERENCES VOTER (V_ID)
   ON DELETE SET NULL
   ON UPDATE CASCADE;

INSERT INTO VOTER_IDENTIFICATION VALUES(101,4456768966911, 21, 'FEMALE' )
INSERT INTO VOTER_IDENTIFICATION VALUES(105,4531234098765, 24, 'MALE' )
INSERT INTO VOTER_IDENTIFICATION VALUES(106,4660987621358, 25, 'FEMALE' )

select * from VOTER_IDENTIFICATION
---------------------------------------------------------------------------------------------------------
--NON VOTER TABLE
CREATE TABLE NON_VOTER 
(
C_ID INT ,
IC_ID INT ,
NV_ID INT NOT NULL CHECK (NV_ID > 0),
NV_FNAME VARCHAR(20),
NV_LNAME VARCHAR(20) NOT NULL,

)
ALTER TABLE NON_VOTER
   ADD CONSTRAINT PK_NON_VOTER
   PRIMARY KEY (NV_ID)
   

ALTER TABLE NON_VOTER
   ADD CONSTRAINT FK_NON_VOTER1
   FOREIGN KEY (C_ID)
   REFERENCES PARTY_CONDIDATE (C_ID)
   ON DELETE SET NULL
   ON UPDATE CASCADE;

ALTER TABLE NON_VOTER
   ADD CONSTRAINT FK_NON_VOTER2
   FOREIGN KEY (IC_ID)
   REFERENCES INDEPENDENT_CONDIDATE (IC_ID)
   ON DELETE SET NULL
   ON UPDATE CASCADE;

INSERT INTO NON_VOTER(NV_ID,NV_FNAME,NV_LNAME,C_ID) VALUES(102,'JOHN','SMITH' ,1987)
INSERT INTO NON_VOTER(NV_ID,NV_FNAME,NV_LNAME,C_ID) VALUES(103,'RUTHER','FORD' ,2010)
INSERT INTO NON_VOTER(NV_ID,NV_FNAME,NV_LNAME,IC_ID) VALUES(104,'SAIF','KHAN' ,1909)


select * from NON_VOTER
---------------------------------------------------------------------------------------------------------
--NON VOTER IDENTIFICATION TABLE
CREATE TABLE NON_VOTER_IDENTIFICATION
(
NV_ID INT ,
NV_CNIC BIGINT NOT NULL CHECK (LEN([NV_CNIC])>(5) AND [NV_CNIC] LIKE '%[0-9]%'),
NV_AGE INT CHECK (NV_AGE>=18),
NV_GENDER VARCHAR (10) CHECK (NV_GENDER IN ('FEMALE','MALE')),

)
ALTER TABLE NON_VOTER_IDENTIFICATION
   ADD CONSTRAINT PK_NON_VOTER_IDENTIFICATION
   PRIMARY KEY (NV_CNIC)
   

ALTER TABLE NON_VOTER_IDENTIFICATION
   ADD CONSTRAINT FK_NON_VOTER_IDENTIFICATION
   FOREIGN KEY (NV_ID)
   REFERENCES NON_VOTER (NV_ID)
   ON DELETE SET NULL
   ON UPDATE CASCADE;

INSERT INTO NON_VOTER_IDENTIFICATION VALUES(102,4456768962211, 41, 'MALE' )
INSERT INTO NON_VOTER_IDENTIFICATION VALUES(103,4531231238765, 24, 'MALE' )
INSERT INTO NON_VOTER_IDENTIFICATION VALUES(104,4789987621358, 35, 'MALE' )

SELECT * FROM NON_VOTER_IDENTIFICATION

------------------------------------------------------------------------------------------------
--CITIZEN TABLE
CREATE TABLE CITIZEN 
(
V_ID INT ,
NV_ID INT ,
CIT_ID CHAR(20) NOT NULL,
CIT_FNAME VARCHAR(20),
CIT_LNAME VARCHAR(20) NOT NULL,
)


ALTER TABLE CITIZEN
ADD CONSTRAINT PK_CITIZEN
PRIMARY KEY (CIT_ID)


ALTER TABLE CITIZEN
ADD CONSTRAINT FK_CITIZEN1 FOREIGN KEY
(V_ID) REFERENCES VOTER(V_ID)
ON DELETE SET NULL
ON UPDATE CASCADE

ALTER TABLE CITIZEN
ADD CONSTRAINT FK_CITIZEN2 FOREIGN KEY
(NV_ID) REFERENCES NON_VOTER(NV_ID)
ON DELETE SET NULL




INSERT INTO CITIZEN(V_ID,CIT_ID,CIT_FNAME,CIT_LNAME) VALUES(101,'A-007','UNZILA','SHUAKAT' )
INSERT INTO CITIZEN(NV_ID,CIT_ID,CIT_FNAME,CIT_LNAME) VALUES(103,'E-187','RUTHER','FORD')
INSERT INTO CITIZEN(NV_ID,CIT_ID,CIT_FNAME,CIT_LNAME) VALUES(104,'T-986','SAIF','KHAN' )

SELECT * FROM CITIZEN

---------------------------------------------------------------------------------------------------
----CITIZEN IDENTIFICATION TABLE
CREATE TABLE CITIZEN_IDENTIFICATION
(
CIT_ID CHAR(20) ,
CIT_CNIC BIGINT NOT NULL CHECK (LEN([CIT_CNIC])>(5) AND [CIT_CNIC] LIKE '%[0-9]%'),
CIT_AGE INT CHECK (CIT_AGE>=18),
CIT_GENDER VARCHAR (10) CHECK (CIT_GENDER IN ('FEMALE','MALE')),

)
 ALTER TABLE CITIZEN_IDENTIFICATION
 ADD CONSTRAINT PK_CITIZEN_IDENTIFICATION 
 PRIMARY KEY (CIT_CNIC)

ALTER TABLE CITIZEN_IDENTIFICATION
ADD CONSTRAINT FK_CITIZEN_IDENTIFICATION FOREIGN KEY
(CIT_ID) REFERENCES CITIZEN(CIT_ID)
ON DELETE SET NULL
ON UPDATE CASCADE



INSERT INTO CITIZEN_IDENTIFICATION VALUES('A-007',4457768962211, 21, 'FEMALE' )
INSERT INTO CITIZEN_IDENTIFICATION VALUES('E-187',2531231238765, 24, 'MALE' )
INSERT INTO CITIZEN_IDENTIFICATION VALUES('T-986',4119987621358, 35, 'MALE' )

SELECT * FROM CITIZEN_IDENTIFICATION

--------------------------------------------------------------------------------------
--VOTE COUNTING TABLE

CREATE TABLE VOTE_COUNTING
(
C_ID INT,
IC_ID INT, 
BELONGING_PARTY VARCHAR(20),
CAN_TYPE VARCHAR(20)
)

ALTER TABLE VOTE_COUNTING
ADD CONSTRAINT FK_VOTE_COUNTING1 FOREIGN KEY
(C_ID) REFERENCES PARTY_CONDIDATE(C_ID)
ON DELETE SET NULL
ON UPDATE CASCADE


ALTER TABLE VOTE_COUNTING
ADD CONSTRAINT FK_VOTE_COUNTING2 FOREIGN KEY
(IC_ID) REFERENCES INDEPENDENT_CONDIDATE(IC_ID)
ON DELETE SET NULL
ON UPDATE CASCADE



SELECT * FROM VOTE_COUNTING

INSERT INTO VOTE_COUNTING (C_ID,BELONGING_PARTY,CAN_TYPE) VALUES (2020,'MMA','PARTY CONDIDATE')
INSERT INTO VOTE_COUNTING (C_ID,BELONGING_PARTY,CAN_TYPE) VALUES (1987,'PTI','PARTY CONDIDATE')
INSERT INTO VOTE_COUNTING (C_ID,BELONGING_PARTY,CAN_TYPE) VALUES (2010,'PML','PARTY CONDIDATE')
INSERT INTO VOTE_COUNTING (IC_ID,BELONGING_PARTY,CAN_TYPE) VALUES (1909,'MQM','PARTY CONDIDATE')
INSERT INTO VOTE_COUNTING (IC_ID,BELONGING_PARTY,CAN_TYPE) VALUES (4571,'ANP','PARTY CONDIDATE')
INSERT INTO VOTE_COUNTING (IC_ID,BELONGING_PARTY,CAN_TYPE) VALUES (9087,'PML(Q)','PARTY CONDIDATE')

---------------------------------------------------------------------------------------
--VOTING CENTER LOCATION TABLE
CREATE TABLE VC_LOCATION
(
VC_CITY VARCHAR(50),
VC_AREA VARCHAR(50),
VC_ADDRESS VARCHAR(100) NOT NULL,

)
DROP TABLE VC_LOCATION

ALTER TABLE VC_LOCATION
ADD CONSTRAINT PK_VC_ADDRESS
PRIMARY KEY (VC_ADDRESS)


INSERT INTO VC_LOCATION VALUES('KARACHI','GULSHAN','GULSHAN HADEED PHASE 2')
INSERT INTO VC_LOCATION VALUES('KARACHI','MALIR','MALIR CANTT CHECK POST 2')
INSERT INTO VC_LOCATION VALUES('KARACHI','STAR GATE','CAA CLUB')
INSERT INTO VC_LOCATION VALUES('KARACHI','CLIFTON','CLIFTON PHASE 5')

SELECT * FROM VC_LOCATION

-------------------------------------------------------------------------
CREATE TABLE VOTING_CENTER
(
VC_ID CHAR(10),
VC_DutyOfArmedForces VARCHAR(50),
VC_ADDRESS VARCHAR(100) ,---1 to M (WHEN PARENT IS MANDATORY)
)
DROP TABLE VOTING_CENTER

ALTER TABLE VOTING_CENTER
ADD CONSTRAINT FK_VOTING_CENTER 
FOREIGN KEY (VC_ADDRESS)
REFERENCES VC_LOCATION(VC_ADDRESS) 
ON DELETE SET NULL
ON UPDATE CASCADE


INSERT INTO VOTING_CENTER VALUES('V-101','RANGER','MALIR CANTT CHECK POST 2')
INSERT INTO VOTING_CENTER VALUES('G-191','ARMY','GULSHAN HADEED PHASE 2')
INSERT INTO VOTING_CENTER VALUES('S-200','RANGER','CAA CLUB')
INSERT INTO VOTING_CENTER VALUES('C-432','ARMY','CLIFTON PHASE 5')

SELECT * FROM VOTING_CENTER

--------------------------------------------------------------------------------------------------------
CREATE TABLE RESULT
(
C_ID INT ,
IC_ID INT ,
SYMBOL VARCHAR (20),
)
DROP TABLE RESULT
ALTER TABLE RESULT
ADD CONSTRAINT FK_RESULT1 
FOREIGN KEY (C_ID)
 REFERENCES PARTY_CONDIDATE(C_ID)
 ON DELETE SET NULL
ON UPDATE CASCADE

ALTER TABLE RESULT
ADD CONSTRAINT FK_RESULT2 
FOREIGN KEY (IC_ID)
REFERENCES INDEPENDENT_CONDIDATE(IC_ID)
ON DELETE SET NULL
ON UPDATE CASCADE


INSERT INTO RESULT(SYMBOL,C_ID) VALUES('TIGER',2020)
INSERT INTO RESULT(SYMBOL,C_ID) VALUES('ELEPHANT',2010)
INSERT INTO RESULT(SYMBOL,IC_ID) VALUES('BULLET',1909)
INSERT INTO RESULT(SYMBOL,IC_ID) VALUES('PEACE',4571)
INSERT INTO RESULT(SYMBOL,IC_ID) VALUES('SWORD',9087)


SELECT * FROM RESULT
