DROP DATABASE IF EXISTS PaceWSN;
CREATE DATABASE PaceWSN;
USE PaceWSN;

CREATE TABLE NODE_TYPE(

	NType CHAR(5) NOT NULL,
	Manufacturer CHAR(50) NOT NULL,
	Cost DECIMAL(10,2)NOT NULL,
	ServiceLife INT NOT NULL,
	CostLifeRatio DECIMAL(10,2) GENERATED ALWAYS AS (Cost/ServiceLife) STORED,
	CONSTRAINT P1 PRIMARY KEY(NType) 
);

CREATE TABLE NODE(

	IDNumber VARCHAR(20) NOT NULL ,
	NType CHAR(5) NOT NULL ,
	Location_X INT NOT NULL,
	Location_Y INT NOT NULL,
	NStatus ENUM ('Online','Offline') DEFAULT 'Online' NOT NULL,
	AccessDistance DECIMAL(10,2) GENERATED ALWAYS AS (SQRT((POW((100-Location_X),2)) + (POW((100-Location_Y),2)))) NOT NULL,
	CONSTRAINT P2 PRIMARY KEY (IDNumber),
	CONSTRAINT F1 FOREIGN KEY (NType) REFERENCES NODE_TYPE(NType)
);

CREATE TABLE NODE_NETWORK(

	IDNumber VARCHAR(15) NOT NULL, 
	Network_A ENUM('C','N') NOT NULL,
	Network_B ENUM('C','N') NOT NULL,
	Network_C ENUM('C','N') NOT NULL,
	CONSTRAINT P3 PRIMARY KEY (IDNumber),
	CONSTRAINT F6 FOREIGN KEY(IDNumber) REFERENCES NODE(IDNumber)  

);

CREATE TABLE  NETWORKS(

	Name CHAR(5) NOT NULL,
	NET_Type CHAR(50) NOT NULL,
	CONSTRAINT P4 PRIMARY KEY (Name),
	CONSTRAINT U1 UNIQUE KEY(NET_Type) 


);


CREATE TABLE NETWORK_GATEWAY(

	Network_Name CHAR(5) NOT NULL,
	NET_Type VARCHAR(50) NOT NULL,
	CONSTRAINT P5 PRIMARY KEY (Network_Name),
	CONSTRAINT F2 FOREIGN KEY (NET_Type) REFERENCES NETWORKS(NET_Type),
	CONSTRAINT F3 FOREIGN KEY (NET_Type) REFERENCES NODE(IDNumber)

);

CREATE TABLE NODE_BATTERY(

	NType CHAR(5) NOT NULL,
	Battery CHAR(50) NOT NULL,
	CONSTRAINT P6 PRIMARY KEY(NType),
	CONSTRAINT F7 FOREIGN KEY (NType) REFERENCES NODE(IDNumber)

);

CREATE TABLE NETWORK_TRANSMISSION (

	Name CHAR(5) NOT NULL,
	Link_Band VARCHAR(10) NOT NULL,
	Link_Type CHAR(10) NOT NULL,
	CONSTRAINT P7 PRIMARY KEY(Name),
	CONSTRAINT F4 FOREIGN KEY (Name) REFERENCES NETWORKS(NType)


);
 
source D:\populatePaceWSN.sql



Q.1

SELECT 
					(SELECT COUNT(*) FROM NODE WHERE NStatus= 'Offline') /
					
					(SELECT COUNT(*) FROM NODE WHERE NStatus='Online')
				 
			
AS "Offline-online ratio"

Q.2


SELECT 
			IDNumber, Network_A, Network_C 

FROM 
			NODE_NETWORK

WHERE 
			Network_A = 'C' AND Network_C = 'N'; 

Q.3


SELECT 
			NN.IDNumber, NN.Network_A AS "Connected to netwrok A", N.NStatus AS "Current Node Status"
FROM 
			NODE_NETWORK NN, NODE N
WHERE 
			Network_A = 'C' AND NStatus = 'Offline'
AND 
			NN.IDNumber = N.IDNumber;


Q.4


SELECT DISTINCT N.IDNumber AS "Node ID", 
				N.NType AS "Node Type", 
				NT.Manufacturer AS "Built By", 
				NN.Network_A AS "Connected to A", 
				N.NSTATUS AS "Status of Node"

FROM NODE_TYPE NT, NODE N, NODE_NETWORK NN

WHERE NT.NType = N.NType AND NT.NType = 'A' AND NN.Network_A = 'C' AND NT.Manufacturer = 'General Dynamics';

Q.5



SELECT 
		N.IDNumber AS "Node ID", N.NType AS "Node Type",
		CONCAT(N.Location_X , '-' , N.Location_Y )AS "COORDINATES", 
		N.AccessDistance, NB.Battery
FROM 
		NODE N, NODE_BATTERY NB

WHERE 
		N.NType = NB.NType AND NB.Battery = 'Magnesium' AND N.AccessDistance BETWEEN 120 AND 135;



