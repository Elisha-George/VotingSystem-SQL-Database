USE FINAL_VS

----------------------------------USER AND LOGIN-------------------

CREATE LOGIN ADMIN_L0GIN WITH PASSWORD= 'ELECTION@1234'
CREATE USER  ADMIN_A FOR LOGIN ADMIN_L0GIN

CREATE LOGIN VOTER_LOGIN WITH PASSWORD= 'VOTER@1234'
CREATE USER  VOTER FOR LOGIN VOTER_LOGIN 

CREATE LOGIN CANDIDATE_L0GIN WITH PASSWORD= 'CANDIDATE@1234'
CREATE USER  CANDIDATE FOR LOGIN CANDIDATE_L0GIN 

----------------------------- GRANT PERMISSIONS AND ROLES ---------------------- 

			   ---------------------------ADMIN ------------------------

GRANT CONNECT TO ADMIN_A 

GRANT ALL ON VOTER TO ADMIN_A --(ADMIN)

GRANT ALL ON PARTY_CONDIDATE TO ADMIN_A
GRANT ALL ON PC_IDENTIFICATION TO ADMIN_A

GRANT ALL ON INDEPENDENT_CONDIDATE TO ADMIN_A
GRANT ALL ON IC_IDENTIFICATIONTO TO ADMIN_A

GRANT ALL ON VOTING_CENTER TO ADMIN_A
GRANT ALL ON VOTING_CENTER TO ADMIN_A

GRANT ALL ON VC_LOCATION TO ADMIN_A

GRANT SELECT ON VOTE_COUNTING TO ADMIN_A

GRANT SELECT ON RESULT TO ADMIN_A

--------------ROLE
EXEC SP_ADDROLEMEMBER 'PROCESS ADMIN', ADMIN_A

			   ------------------------VOTER ------------------------

GRANT CONNECT TO VOTER 


GRANT SELECT ON VOTER TO VOTER --(USER)

GRANT SELECT ON PARTY_CONDIDATE TO VOTER
GRANT SELECT ON PC_IDENTIFICATION TO VOTER

GRANT SELECT ON INDEPENDENT_CONDIDATE TO VOTER
GRANT SELECT ON IC_IDENTIFICATIONTO TO VOTER

GRANT SELECT ON VOTING_CENTER TO VOTER

GRANT SELECT ON VC_LOCATION TO VOTER

GRANT SELECT ON RESULT TO VOTER

--------------ROLE
EXEC SP_ADDROLEMEMBER 'VOTER', VOTER





			------------------------CANDIDATE ------------------------

GRANT CONNECT TO CANDIDATE 


GRANT SELECT ON VOTER TO CANDIDATE --(USER)

GRANT SELECT ON PARTY_CONDIDATE TO CANDIDATE
GRANT SELECT ON PC_IDENTIFICATION TO CANDIDATE

GRANT SELECT ON INDEPENDENT_CONDIDATE TO CANDIDATE
GRANT SELECT ON IC_IDENTIFICATIONTO TO CANDIDATE

GRANT SELECT ON VOTING_CENTER TO CANDIDATE

GRANT SELECT ON VC_LOCATION TO CANDIDATE

GRANT SELECT ON RESULT TO CANDIDATE

--------------ROLE
EXEC SP_ADDROLEMEMBER 'NOMINEE', VOTER