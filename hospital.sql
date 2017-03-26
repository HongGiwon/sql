CREATE database hospital;
USE hospital;

set foreign_key_checks=0;

CREATE TABLE DEPT_TREAT(
	DEPTNo VARCHAR(3) NOT NULL,
	DEPTName VARCHAR(30) NOT NULL,
	DEPTAvgIncome REAL NOT NULL,
	ManagerNo VARCHAR(3) NOT NULL,
	PRIMARY KEY(DEPTNo),
	UNIQUE(DEPTName),
	FOREIGN KEY(ManagerNo) REFERENCES EMP_DOCT(EMPNo)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);
CREATE TABLE DEPT_TREAT_Phone(
	DEPTNo VARCHAR(3) NOT NULL,
	Phone VARCHAR(10) NOT NULL,
	PRIMARY KEY(DEPTNo, Phone),
	FOREIGN KEY(DEPTNo) REFERENCES DEPT_TREAT(DEPTNo)
		On UPDATE CASCADE
		ON DELETE CASCADE
);
CREATE TABLE DEPT_NURSE(
	DEPTNo VARCHAR(3) NOT NULL,
	DEPTName VARCHAR(30) NOT NULL,
	ManagerNo VARCHAR(3) NOT NULL,
	PRIMARY KEY(DEPTNo),
	FOREIGN KEY(ManagerNo) REFERENCES EMP_NURSE(EMPNo)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	UNIQUE(DEPTName)
);
CREATE TABLE DEPT_NURSE_Phone(
	DEPTNo VARCHAR(3) NOT NULL,
	Phone VARCHAR(10) NOT NULL,
	PRIMARY KEY(DEPTNo, Phone),
	FOREIGN KEY(DEPTNo) REFERENCES DEPT_NURSE(DEPTNo)
		On UPDATE CASCADE
		ON DELETE CASCADE
);
CREATE TABLE EMP_DOCT(
	EMPNo VARCHAR(3) NOT NULL,
	EMPSSN VARCHAR(10) NOT NULL,
	EMPName VARCHAR(10) NOT NULL,
	EMPAge INT,
	EMPWorkYear INT,
	DOCTIncome REAL NOT NULL,
	DEPTNo VARCHAR(3) Not NULL,
	check (EMPAge > EMPWorkYear),
	PRIMARY KEY(EMPNo),
	FOREIGN KEY(DEPTNo) REFERENCES DEPT_TREAT(DEPTNo)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	UNIQUE(EMPSSN)
);
CREATE TABLE EMP_NURSE(
	EMPNo VARCHAR(3) NOT NULL,
	EMPSSN VARCHAR(10) NOT NULL,
	EMPName VARCHAR(10) NOT NULL,
	EMPAge INT,
	EMPWorkYear INT Not NULL,
	DEPTNo VARCHAR(3) NOT NULL,
	check (EMPAge > EMPWorkYear),
	PRIMARY KEY(EMPNo),
	FOREIGN KEY(EMPWorkYear) REFERENCES NURSE_Income(NURSEWorkYear)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY(DEPTNo) REFERENCES DEPT_NURSE(DEPTNo)
		On UPDATE CASCADE
		ON DELETE CASCADE
);
CREATE TABLE EMP_DOCT_Phone(
	EMPNo VARCHAR(3) NOT NULL,
	Phone VARCHAR(10) NOT NULL,
	PRIMARY KEY(EMPNo, Phone),
	FOREIGN KEY(EMPNo) REFERENCES EMP_DOCT(EMPNo)
		On UPDATE CASCADE
		ON DELETE CASCADE
);
CREATE TABLE EMP_NURSE_Phone(
	EMPNo VARCHAR(3) NOT NULL,
	Phone VARCHAR(10) NOT NULL,
	PRIMARY KEY(EMPNo, Phone),
	FOREIGN KEY(EMPNo) REFERENCES EMP_NURSE(EMPNo)
		On UPDATE CASCADE
		ON DELETE CASCADE
);
CREATE TABLE WARD(
	WARDNo VARCHAR(3) NOT NULL,
	WARDName VARCHAR(30) NOT NULL,
	WARDLimit INT NOT NULL,
	DEPTNo VARCHAR(3) NOT NULL,
	PRIMARY KEY(WARDNo),
	FOREIGN KEY(DEPTNo) REFERENCES DEPT_NURSE(DEPTNo)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	UNIQUE(WARDName)
);
CREATE TABLE PATIENT(
	PATNo VARCHAR(3) NOT NULL,
	PATSSN VARCHAR(10) NOT NULL,
	PATAge INT,
	PATName VARCHAR(10) NOT NULL,
 	DOCTNo VARCHAR(3) NOT NULL,
	PRIMARY KEY(PATNo),
	FOREIGN KEY(DOCTNo) REFERENCES EMP_DOCT(EMPNo)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	UNIQUE(PATSSN)
);
CREATE TABLE PATIENT_Phone(
	PATNo VARCHAR(3) NOT NULL,
	Phone VARCHAR(10) NOT NULL,
	PRIMARY KEY(PATNo, Phone),
	FOREIGN KEY(PATNo) REFERENCES PATIENT(PATNo)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);
CREATE TABLE Intern(
	Name VARCHAR(10) NOT NULL,
	Age INT NOT NULL,
	DOCTNo VARCHAR(3) NOT NULL,
	WorkYear INT NOT NULL CHECK (WorkYear <=1),
	PRIMARY KEY(Name, Age, DOCTNo),
	FOREIGN KEY(DOCTNo) REFERENCES EMP_DOCT(EMPNo)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);
CREATE TABLE Resident(
	Name VARCHAR(10) NOT NULL,
	Age INT NOT NULL,
	DOCTNo VARCHAR(3) NOT NULL,
	WorkYear INT NOT NULL CHECK (WorkYear <=4),
	Major VARCHAR(30) NOT NULL,
	PRIMARY KEY(Name, Age, DOCTNo),
	FOREIGN KEY(DOCTNo) REFERENCES EMP_DOCT(EMPNo)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);
CREATE TABLE ADMISSION(
	PATNo VARCHAR(3) NOT NULL,
	WARDNo VARCHAR(3) NOT NULL,
	ADMISSIONSTART INT NOT NULL,
	ADMISSIONEND INT NOT NULL,
	CHECK (ADMISSIONSTART <= ADMISSIONEND),
	PRIMARY KEY(PATNo),
	FOREIGN KEY(PATNo) REFERENCES PATIENT(PATNo)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY(WARDNo) REFERENCES WARD(WARDNo)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);
CREATE TABLE CARE(
	PATNo VARCHAR(3) NOT NULL,
	NURSENo VARCHAR(3) Not NULL,
	PRIMARY KEY(NURSENo, PATNo),
	FOREIGN KEY(NURSENo) REFERENCES EMP_NURSE(EMPNo)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY(PATNo) REFERENCES PATIENT(PATNo)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);
CREATE TABLE PTREAT(
	PATNo VARCHAR(3) NOT NULL,
	TREATNumber VARCHAR(3) NOT NULL,
	TREATName VARCHAR(30),
	TREATDate INT NOT NULL,
	PRIMARY KEY(PATNo, TREATNumber),
	FOREIGN KEY(PATNo) REFERENCES PATIENT(PATNo)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);
CREATE TABLE NURSEIncome(
	NURSEWorkYear INT NOT NULL,
	Income INT NOT NULL,
	CHECK (Income = WorkYear *100 + 2680),
	PRIMARY KEY(NURSEWorkYear)
);

CREATE VIEW DEPT_TREATwithPhone AS
	SELECT *
	FROM DEPT_TREAT NATURAL JOIN DEPT_TREAT_Phone;

CREATE VIEW DEPT_NURSEwithPhone AS
	SELECT *
	FROM DEPT_NURSE NATURAL JOIN DEPT_NURSE_Phone;

CREATE VIEW PATIENTatWARD AS
	SELECT *
	FROM PATIENT NATURAL JOIN ADMISSION;
	
CREATE VIEW DOCTwithIntern AS
	SELECT EMPNo, EMPSSN, EMPName, EMPAge, EMPWorkYear, DEPTNO, Name, Age, WorkYear
	FROM EMP_DOCT JOIN Intern ON EMPNo = DOCTNo;
	
CREATE VIEW DOCTwithResident AS
	SELECT EMPNo, EMPSSN, EMPName, EMPAge, EMPWorkYear, DEPTNO, Name, Age, WorkYear, Major
	FROM EMP_DOCT JOIN Resident ON EMPNo = DOCTNo;
	
CREATE VIEW PATIENTwithPhone AS
	SELECT *
	FROM PATIENT NATURAL JOIN PATIENT_Phone;
	
CREATE VIEW DOCTwithPhone AS
	SELECT *
	FROM EMP_DOCT NATURAL JOIN EMP_DOCT_Phone;
	
CREATE VIEW NURSEwithPhoneAndIncome AS
	SELECT *
	FROM (EMP_NURSE NATURAL JOIN EMP_NURSE_Phone) JOIN NURSEIncome ON EMPWorkYear = NURSEWorkYear;

CREATE VIEW DEPTRunWARD AS
	SELECT *
	FROM DEPT_NURSE NATURAL JOIN WARD;
	
CREATE VIEW NURSE_CARE_PATIENT AS
	SELECT PATNo, PATSSN, PATAge, PATName, DOCTNo, NURSENo, EMPSSN, EMPName, EMPAge, EMPWorkYear, DEPTNo
	FROM (PATIENT NATURAL JOIN CARE) JOIN EMP_NURSE ON NURSENo = EMPNo;
	
CREATE VIEW MANAGERofDEPT_NURSE AS
	SELECT DEPT_NURSE.DEPTNo,EMPNo, EMPSSN, EMPName, EMPAge, EMPWorkYear
	FROM EMP_NURSE JOIN DEPT_NURSE ON EMPNo = ManagerNo;
	
CREATE VIEW MANAGERofDEPT_TREAT AS
	SELECT DEPT_TREAT.DEPTNo,EMPNo, EMPSSN, EMPName, EMPAge, EMPWorkYear, DOCTIncome
	FROM EMP_DOCT JOIN DEPT_TREAT ON EMPNo = ManagerNo;
	
CREATE VIEW DOCTwithTREAT_PATIENT AS
	SELECt PATNO, PATName, PATAge, DOCTNo, EMPName, DEPTNo, TREATName, TREATDate
	FROM (PTREAT NATURAL JOIN PATIENT) JOIN EMP_DOCT ON DOCTNo = EMPNo;

Insert Into DEPT_TREAT value('d01', '가정의학과', '6949', 'e01');
Insert Into DEPT_TREAT value('d02', '류마티스내과', '9050', 'e03');
Insert Into DEPT_TREAT value('d03', '병리과', '8900', 'e05');
Insert Into DEPT_TREAT value('d04', '성형외과', '9614', 'e07');
Insert Into DEPT_TREAT value('d05', '순환기내과', '8950', 'e09');
Insert Into DEPT_TREAT value('d06', '신장내과', '8850', 'e11');
Insert Into DEPT_TREAT value('d07', '외과', '10363', 'e13');
Insert Into DEPT_TREAT value('d08', '재활의학과', '8600', 'e15');
Insert Into DEPT_TREAT value('d09', '중앙혈액내과', '9100', 'e17');
Insert Into DEPT_TREAT value('d10', '진단검사의학과', '9500', 'e19');
Insert Into DEPT_TREAT value('d11', '핵의학과', '9400', 'e21');
Insert Into DEPT_TREAT value('d12', '감염내과', '9300', 'e23');
Insert Into DEPT_TREAT value('d13', '마취통증의학과', '6203', 'e25');
Insert Into DEPT_TREAT value('d14', '비뇨기과', '8274', 'e27');
Insert Into DEPT_TREAT value('d15', '소아청소년과', '9560', 'e29');
Insert Into DEPT_TREAT value('d16', '신경과', '10000', 'e31');
Insert Into DEPT_TREAT value('d17', '안과', '11221', 'e33');
Insert Into DEPT_TREAT value('d18', '응급의학과', '8800', 'e35');
Insert Into DEPT_TREAT value('d19', '정신건강의학과', '7437', 'e37');
Insert Into DEPT_TREAT value('d20', '중환자의학과', '10500', 'e39');
Insert Into DEPT_TREAT value('d21', '치과', '7963', 'e41');
Insert Into DEPT_TREAT value('d22', '호흡기내과', '8800', 'e43');
Insert Into DEPT_TREAT value('d23', '내분비내과', '8900', 'e45');
Insert Into DEPT_TREAT value('d24', '방사선중앙학과', '8027', 'e47');
Insert Into DEPT_TREAT value('d25', '산부인과', '8967', 'e49');
Insert Into DEPT_TREAT value('d26', '소화기내과', '9000', 'e51');
Insert Into DEPT_TREAT value('d27', '신경외과', '10000', 'e53');
Insert Into DEPT_TREAT value('d28', '영상의학과', '8500', 'e55');
Insert Into DEPT_TREAT value('d29', '이비인후과', '7529', 'e57');
Insert Into DEPT_TREAT value('d30', '정형외과', '12000', 'e59');
Insert Into DEPT_TREAT value('d31', '직업환경의학과', '8200', 'e61');
Insert Into DEPT_TREAT value('d32', '피부과', '11151', 'e63');
Insert Into DEPT_TREAT value('d33', '흉부외과', '11500', 'e65');

Insert Into DEPT_NURSE value('d34', '행정1팀', 'n01');
Insert Into DEPT_NURSE value('d35', '행정2팀', 'n03');
Insert Into DEPT_NURSE value('d36', '행정3팀', 'n05');
Insert Into DEPT_NURSE value('d37', '행정4팀', 'n07');
Insert Into DEPT_NURSE value('d38', '행정5팀', 'n09');
Insert Into DEPT_NURSE value('d39', '행정6팀', 'n11');
Insert Into DEPT_NURSE value('d40', '행정7팀', 'n13');
Insert Into DEPT_NURSE value('d41', '행정8팀', 'n15');
Insert Into DEPT_NURSE value('d42', '행정9팀', 'n17');
Insert Into DEPT_NURSE value('d43', '교육1팀', 'n19');
Insert Into DEPT_NURSE value('d44', '교육2팀', 'n21');
Insert Into DEPT_NURSE value('d45', '교육3팀', 'n23');
Insert Into DEPT_NURSE value('d46', '교육4팀', 'n25');
Insert Into DEPT_NURSE value('d47', '교육5팀', 'n27');
Insert Into DEPT_NURSE value('d48', '교육6팀', 'n29');
Insert Into DEPT_NURSE value('d49', '교육7팀', 'n31');
Insert Into DEPT_NURSE value('d50', '교육8팀', 'n33');
Insert Into DEPT_NURSE value('d51', '교육9팀', 'n35');
Insert Into DEPT_NURSE value('d52', '병동1팀', 'n37');
Insert Into DEPT_NURSE value('d53', '병동2팀', 'n39');
Insert Into DEPT_NURSE value('d54', '병동3팀', 'n41');
Insert Into DEPT_NURSE value('d55', '병동4팀', 'n43');
Insert Into DEPT_NURSE value('d56', '병동5팀', 'n45');
Insert Into DEPT_NURSE value('d57', '병동6팀', 'n47');
Insert Into DEPT_NURSE value('d58', '병동7팀', 'n49');
Insert Into DEPT_NURSE value('d59', '병동8팀', 'n51');
Insert Into DEPT_NURSE value('d60', '병동9팀', 'n53');
Insert Into DEPT_NURSE value('d61', '외래1팀', 'n55');
Insert Into DEPT_NURSE value('d62', '외래2팀', 'n57');
Insert Into DEPT_NURSE value('d63', '외래3팀', 'n59');

Insert Into DEPT_TREAT_Phone value('d01', '02-001');
Insert Into DEPT_TREAT_Phone value('d02', '02-002');
Insert Into DEPT_TREAT_Phone value('d03', '02-003');
Insert Into DEPT_TREAT_Phone value('d04', '02-004');
Insert Into DEPT_TREAT_Phone value('d05', '02-005');
Insert Into DEPT_TREAT_Phone value('d06', '02-006');
Insert Into DEPT_TREAT_Phone value('d07', '02-007');
Insert Into DEPT_TREAT_Phone value('d08', '02-008');
Insert Into DEPT_TREAT_Phone value('d09', '02-009');
Insert Into DEPT_TREAT_Phone value('d10', '02-010');
Insert Into DEPT_TREAT_Phone value('d11', '02-011');
Insert Into DEPT_TREAT_Phone value('d12', '02-012');
Insert Into DEPT_TREAT_Phone value('d13', '02-013');
Insert Into DEPT_TREAT_Phone value('d14', '02-014');
Insert Into DEPT_TREAT_Phone value('d15', '02-015');
Insert Into DEPT_TREAT_Phone value('d16', '02-016');
Insert Into DEPT_TREAT_Phone value('d17', '02-017');
Insert Into DEPT_TREAT_Phone value('d18', '02-018');
Insert Into DEPT_TREAT_Phone value('d19', '02-019');
Insert Into DEPT_TREAT_Phone value('d20', '02-020');
Insert Into DEPT_TREAT_Phone value('d21', '02-021');
Insert Into DEPT_TREAT_Phone value('d22', '02-022');
Insert Into DEPT_TREAT_Phone value('d23', '02-023');
Insert Into DEPT_TREAT_Phone value('d24', '02-024');
Insert Into DEPT_TREAT_Phone value('d25', '02-025');
Insert Into DEPT_TREAT_Phone value('d26', '02-026');
Insert Into DEPT_TREAT_Phone value('d27', '02-027');
Insert Into DEPT_TREAT_Phone value('d28', '02-028');
Insert Into DEPT_TREAT_Phone value('d29', '02-029');
Insert Into DEPT_TREAT_Phone value('d30', '02-030');
Insert Into DEPT_TREAT_Phone value('d31', '02-031');
Insert Into DEPT_TREAT_Phone value('d32', '02-032');
Insert Into DEPT_TREAT_Phone value('d33', '02-033');
Insert Into DEPT_TREAT_Phone value('d01', '02-034');
Insert Into DEPT_TREAT_Phone value('d02', '02-035');
Insert Into DEPT_TREAT_Phone value('d03', '02-036');
Insert Into DEPT_TREAT_Phone value('d04', '02-037');
Insert Into DEPT_TREAT_Phone value('d05', '02-038');
Insert Into DEPT_TREAT_Phone value('d06', '02-039');
Insert Into DEPT_TREAT_Phone value('d07', '02-040');
Insert Into DEPT_TREAT_Phone value('d08', '02-041');
Insert Into DEPT_TREAT_Phone value('d09', '02-042');
Insert Into DEPT_TREAT_Phone value('d10', '02-043');
Insert Into DEPT_TREAT_Phone value('d11', '02-044');
Insert Into DEPT_TREAT_Phone value('d12', '02-045');
Insert Into DEPT_TREAT_Phone value('d13', '02-046');
Insert Into DEPT_TREAT_Phone value('d14', '02-047');
Insert Into DEPT_TREAT_Phone value('d15', '02-048');
Insert Into DEPT_TREAT_Phone value('d16', '02-049');
Insert Into DEPT_TREAT_Phone value('d17', '02-050');
Insert Into DEPT_TREAT_Phone value('d18', '02-051');
Insert Into DEPT_TREAT_Phone value('d19', '02-052');
Insert Into DEPT_TREAT_Phone value('d20', '02-053');
Insert Into DEPT_TREAT_Phone value('d21', '02-054');
Insert Into DEPT_TREAT_Phone value('d22', '02-055');
Insert Into DEPT_TREAT_Phone value('d23', '02-056');
Insert Into DEPT_TREAT_Phone value('d24', '02-057');
Insert Into DEPT_TREAT_Phone value('d25', '02-058');
Insert Into DEPT_TREAT_Phone value('d26', '02-059');
Insert Into DEPT_TREAT_Phone value('d27', '02-060');
Insert Into DEPT_TREAT_Phone value('d28', '02-061');
Insert Into DEPT_TREAT_Phone value('d29', '02-062');
Insert Into DEPT_TREAT_Phone value('d30', '02-063');
Insert Into DEPT_TREAT_Phone value('d31', '02-064');
Insert Into DEPT_TREAT_Phone value('d32', '02-065');
Insert Into DEPT_TREAT_Phone value('d33', '02-066');
Insert Into DEPT_TREAT_Phone value('d01', '02-067');
Insert Into DEPT_TREAT_Phone value('d02', '02-068');
Insert Into DEPT_TREAT_Phone value('d03', '02-069');
Insert Into DEPT_TREAT_Phone value('d04', '02-070');
Insert Into DEPT_TREAT_Phone value('d05', '02-071');
Insert Into DEPT_TREAT_Phone value('d06', '02-072');
Insert Into DEPT_TREAT_Phone value('d07', '02-073');
Insert Into DEPT_TREAT_Phone value('d08', '02-074');
Insert Into DEPT_TREAT_Phone value('d09', '02-075');
Insert Into DEPT_TREAT_Phone value('d10', '02-076');
Insert Into DEPT_TREAT_Phone value('d11', '02-077');
Insert Into DEPT_TREAT_Phone value('d12', '02-078');
Insert Into DEPT_TREAT_Phone value('d13', '02-079');
Insert Into DEPT_TREAT_Phone value('d14', '02-080');
Insert Into DEPT_TREAT_Phone value('d15', '02-081');
Insert Into DEPT_TREAT_Phone value('d16', '02-082');
Insert Into DEPT_TREAT_Phone value('d17', '02-083');
Insert Into DEPT_TREAT_Phone value('d18', '02-084');
Insert Into DEPT_TREAT_Phone value('d19', '02-085');
Insert Into DEPT_TREAT_Phone value('d20', '02-086');
Insert Into DEPT_TREAT_Phone value('d21', '02-087');
Insert Into DEPT_TREAT_Phone value('d22', '02-088');
Insert Into DEPT_TREAT_Phone value('d23', '02-089');
Insert Into DEPT_TREAT_Phone value('d24', '02-090');
Insert Into DEPT_TREAT_Phone value('d25', '02-091');
Insert Into DEPT_TREAT_Phone value('d26', '02-092');
Insert Into DEPT_TREAT_Phone value('d27', '02-093');
Insert Into DEPT_TREAT_Phone value('d28', '02-094');
Insert Into DEPT_TREAT_Phone value('d29', '02-095');
Insert Into DEPT_TREAT_Phone value('d30', '02-096');
Insert Into DEPT_TREAT_Phone value('d31', '02-097');
Insert Into DEPT_TREAT_Phone value('d32', '02-098');
Insert Into DEPT_TREAT_Phone value('d33', '02-099');

Insert Into DEPT_NURSE_Phone value('d34', '02-100');
Insert Into DEPT_NURSE_Phone value('d35', '02-101');
Insert Into DEPT_NURSE_Phone value('d36', '02-102');
Insert Into DEPT_NURSE_Phone value('d37', '02-103');
Insert Into DEPT_NURSE_Phone value('d38', '02-104');
Insert Into DEPT_NURSE_Phone value('d39', '02-105');
Insert Into DEPT_NURSE_Phone value('d40', '02-106');
Insert Into DEPT_NURSE_Phone value('d41', '02-107');
Insert Into DEPT_NURSE_Phone value('d42', '02-108');
Insert Into DEPT_NURSE_Phone value('d43', '02-109');
Insert Into DEPT_NURSE_Phone value('d44', '02-110');
Insert Into DEPT_NURSE_Phone value('d45', '02-111');
Insert Into DEPT_NURSE_Phone value('d46', '02-112');
Insert Into DEPT_NURSE_Phone value('d47', '02-113');
Insert Into DEPT_NURSE_Phone value('d48', '02-114');
Insert Into DEPT_NURSE_Phone value('d49', '02-115');
Insert Into DEPT_NURSE_Phone value('d50', '02-116');
Insert Into DEPT_NURSE_Phone value('d51', '02-117');
Insert Into DEPT_NURSE_Phone value('d52', '02-118');
Insert Into DEPT_NURSE_Phone value('d53', '02-119');
Insert Into DEPT_NURSE_Phone value('d54', '02-120');
Insert Into DEPT_NURSE_Phone value('d55', '02-121');
Insert Into DEPT_NURSE_Phone value('d56', '02-122');
Insert Into DEPT_NURSE_Phone value('d57', '02-123');
Insert Into DEPT_NURSE_Phone value('d58', '02-124');
Insert Into DEPT_NURSE_Phone value('d59', '02-125');
Insert Into DEPT_NURSE_Phone value('d60', '02-126');
Insert Into DEPT_NURSE_Phone value('d61', '02-127');
Insert Into DEPT_NURSE_Phone value('d62', '02-128');
Insert Into DEPT_NURSE_Phone value('d63', '02-129');
Insert Into DEPT_NURSE_Phone value('d34', '02-130');
Insert Into DEPT_NURSE_Phone value('d35', '02-131');
Insert Into DEPT_NURSE_Phone value('d36', '02-132');
Insert Into DEPT_NURSE_Phone value('d37', '02-133');
Insert Into DEPT_NURSE_Phone value('d38', '02-134');
Insert Into DEPT_NURSE_Phone value('d39', '02-135');
Insert Into DEPT_NURSE_Phone value('d40', '02-136');
Insert Into DEPT_NURSE_Phone value('d41', '02-137');
Insert Into DEPT_NURSE_Phone value('d42', '02-138');
Insert Into DEPT_NURSE_Phone value('d43', '02-139');
Insert Into DEPT_NURSE_Phone value('d44', '02-140');
Insert Into DEPT_NURSE_Phone value('d45', '02-141');
Insert Into DEPT_NURSE_Phone value('d46', '02-142');
Insert Into DEPT_NURSE_Phone value('d47', '02-143');
Insert Into DEPT_NURSE_Phone value('d48', '02-144');
Insert Into DEPT_NURSE_Phone value('d49', '02-145');
Insert Into DEPT_NURSE_Phone value('d50', '02-146');
Insert Into DEPT_NURSE_Phone value('d51', '02-147');
Insert Into DEPT_NURSE_Phone value('d52', '02-148');
Insert Into DEPT_NURSE_Phone value('d53', '02-149');
Insert Into DEPT_NURSE_Phone value('d54', '02-150');
Insert Into DEPT_NURSE_Phone value('d55', '02-151');
Insert Into DEPT_NURSE_Phone value('d56', '02-152');
Insert Into DEPT_NURSE_Phone value('d57', '02-153');
Insert Into DEPT_NURSE_Phone value('d58', '02-154');
Insert Into DEPT_NURSE_Phone value('d59', '02-155');
Insert Into DEPT_NURSE_Phone value('d60', '02-156');
Insert Into DEPT_NURSE_Phone value('d61', '02-157');
Insert Into DEPT_NURSE_Phone value('d62', '02-158');
Insert Into DEPT_NURSE_Phone value('d63', '02-159');
Insert Into DEPT_NURSE_Phone value('d34', '02-160');
Insert Into DEPT_NURSE_Phone value('d35', '02-161');
Insert Into DEPT_NURSE_Phone value('d36', '02-162');
Insert Into DEPT_NURSE_Phone value('d37', '02-163');
Insert Into DEPT_NURSE_Phone value('d38', '02-164');
Insert Into DEPT_NURSE_Phone value('d39', '02-165');
Insert Into DEPT_NURSE_Phone value('d40', '02-166');
Insert Into DEPT_NURSE_Phone value('d41', '02-167');
Insert Into DEPT_NURSE_Phone value('d42', '02-168');
Insert Into DEPT_NURSE_Phone value('d43', '02-169');
Insert Into DEPT_NURSE_Phone value('d44', '02-170');
Insert Into DEPT_NURSE_Phone value('d45', '02-171');
Insert Into DEPT_NURSE_Phone value('d46', '02-172');
Insert Into DEPT_NURSE_Phone value('d47', '02-173');
Insert Into DEPT_NURSE_Phone value('d48', '02-174');
Insert Into DEPT_NURSE_Phone value('d49', '02-175');
Insert Into DEPT_NURSE_Phone value('d50', '02-176');
Insert Into DEPT_NURSE_Phone value('d51', '02-177');
Insert Into DEPT_NURSE_Phone value('d52', '02-178');
Insert Into DEPT_NURSE_Phone value('d53', '02-179');
Insert Into DEPT_NURSE_Phone value('d54', '02-180');
Insert Into DEPT_NURSE_Phone value('d55', '02-181');
Insert Into DEPT_NURSE_Phone value('d56', '02-182');
Insert Into DEPT_NURSE_Phone value('d57', '02-183');
Insert Into DEPT_NURSE_Phone value('d58', '02-184');
Insert Into DEPT_NURSE_Phone value('d59', '02-185');
Insert Into DEPT_NURSE_Phone value('d60', '02-186');
Insert Into DEPT_NURSE_Phone value('d61', '02-187');
Insert Into DEPT_NURSE_Phone value('d62', '02-188');
Insert Into DEPT_NURSE_Phone value('d63', '02-189');

Insert Into EMP_DOCT_Phone value('e01', '010-0001');
Insert Into EMP_DOCT_Phone value('e02', '010-0002');
Insert Into EMP_DOCT_Phone value('e03', '010-0003');
Insert Into EMP_DOCT_Phone value('e04', '010-0004');
Insert Into EMP_DOCT_Phone value('e05', '010-0005');
Insert Into EMP_DOCT_Phone value('e06', '010-0006');
Insert Into EMP_DOCT_Phone value('e07', '010-0007');
Insert Into EMP_DOCT_Phone value('e08', '010-0008');
Insert Into EMP_DOCT_Phone value('e09', '010-0009');
Insert Into EMP_DOCT_Phone value('e10', '010-0010');
Insert Into EMP_DOCT_Phone value('e11', '010-0011');
Insert Into EMP_DOCT_Phone value('e12', '010-0012');
Insert Into EMP_DOCT_Phone value('e13', '010-0013');
Insert Into EMP_DOCT_Phone value('e14', '010-0014');
Insert Into EMP_DOCT_Phone value('e15', '010-0015');
Insert Into EMP_DOCT_Phone value('e16', '010-0016');
Insert Into EMP_DOCT_Phone value('e17', '010-0017');
Insert Into EMP_DOCT_Phone value('e18', '010-0018');
Insert Into EMP_DOCT_Phone value('e19', '010-0019');
Insert Into EMP_DOCT_Phone value('e20', '010-0020');
Insert Into EMP_DOCT_Phone value('e21', '010-0021');
Insert Into EMP_DOCT_Phone value('e22', '010-0022');
Insert Into EMP_DOCT_Phone value('e23', '010-0023');
Insert Into EMP_DOCT_Phone value('e24', '010-0024');
Insert Into EMP_DOCT_Phone value('e25', '010-0025');
Insert Into EMP_DOCT_Phone value('e26', '010-0026');
Insert Into EMP_DOCT_Phone value('e27', '010-0027');
Insert Into EMP_DOCT_Phone value('e28', '010-0028');
Insert Into EMP_DOCT_Phone value('e29', '010-0029');
Insert Into EMP_DOCT_Phone value('e30', '010-0030');
Insert Into EMP_DOCT_Phone value('e31', '010-0031');
Insert Into EMP_DOCT_Phone value('e32', '010-0032');
Insert Into EMP_DOCT_Phone value('e33', '010-0033');
Insert Into EMP_DOCT_Phone value('e34', '010-0034');
Insert Into EMP_DOCT_Phone value('e35', '010-0035');
Insert Into EMP_DOCT_Phone value('e36', '010-0036');
Insert Into EMP_DOCT_Phone value('e37', '010-0037');
Insert Into EMP_DOCT_Phone value('e38', '010-0038');
Insert Into EMP_DOCT_Phone value('e39', '010-0039');
Insert Into EMP_DOCT_Phone value('e40', '010-0040');
Insert Into EMP_DOCT_Phone value('e41', '010-0041');
Insert Into EMP_DOCT_Phone value('e42', '010-0042');
Insert Into EMP_DOCT_Phone value('e43', '010-0043');
Insert Into EMP_DOCT_Phone value('e44', '010-0044');
Insert Into EMP_DOCT_Phone value('e45', '010-0045');
Insert Into EMP_DOCT_Phone value('e46', '010-0046');
Insert Into EMP_DOCT_Phone value('e47', '010-0047');
Insert Into EMP_DOCT_Phone value('e48', '010-0048');
Insert Into EMP_DOCT_Phone value('e49', '010-0049');
Insert Into EMP_DOCT_Phone value('e50', '010-0050');
Insert Into EMP_DOCT_Phone value('e51', '010-0051');
Insert Into EMP_DOCT_Phone value('e52', '010-0052');
Insert Into EMP_DOCT_Phone value('e53', '010-0053');
Insert Into EMP_DOCT_Phone value('e54', '010-0054');
Insert Into EMP_DOCT_Phone value('e55', '010-0055');
Insert Into EMP_DOCT_Phone value('e56', '010-0056');
Insert Into EMP_DOCT_Phone value('e57', '010-0057');
Insert Into EMP_DOCT_Phone value('e58', '010-0058');
Insert Into EMP_DOCT_Phone value('e59', '010-0059');
Insert Into EMP_DOCT_Phone value('e60', '010-0060');
Insert Into EMP_DOCT_Phone value('e61', '010-0061');
Insert Into EMP_DOCT_Phone value('e62', '010-0062');
Insert Into EMP_DOCT_Phone value('e63', '010-0063');
Insert Into EMP_DOCT_Phone value('e64', '010-0064');
Insert Into EMP_DOCT_Phone value('e65', '010-0065');
Insert Into EMP_DOCT_Phone value('e66', '010-0066');
Insert Into EMP_DOCT_Phone value('e01', '010-0067');
Insert Into EMP_DOCT_Phone value('e02', '010-0068');
Insert Into EMP_DOCT_Phone value('e03', '010-0069');
Insert Into EMP_DOCT_Phone value('e06', '010-0070');
Insert Into EMP_DOCT_Phone value('e07', '010-0071');
Insert Into EMP_DOCT_Phone value('e08', '010-0072');
Insert Into EMP_DOCT_Phone value('e09', '010-0073');
Insert Into EMP_DOCT_Phone value('e10', '010-0074');
Insert Into EMP_DOCT_Phone value('e11', '010-0075');
Insert Into EMP_DOCT_Phone value('e12', '010-0076');
Insert Into EMP_DOCT_Phone value('e13', '010-0077');
Insert Into EMP_DOCT_Phone value('e17', '010-0078');
Insert Into EMP_DOCT_Phone value('e18', '010-0079');
Insert Into EMP_DOCT_Phone value('e19', '010-0080');
Insert Into EMP_DOCT_Phone value('e24', '010-0081');
Insert Into EMP_DOCT_Phone value('e25', '010-0082');
Insert Into EMP_DOCT_Phone value('e26', '010-0083');
Insert Into EMP_DOCT_Phone value('e27', '010-0084');
Insert Into EMP_DOCT_Phone value('e28', '010-0085');
Insert Into EMP_DOCT_Phone value('e29', '010-0086');
Insert Into EMP_DOCT_Phone value('e30', '010-0087');
Insert Into EMP_DOCT_Phone value('e31', '010-0088');
Insert Into EMP_DOCT_Phone value('e32', '010-0089');
Insert Into EMP_DOCT_Phone value('e33', '010-0090');
Insert Into EMP_DOCT_Phone value('e34', '010-0091');
Insert Into EMP_DOCT_Phone value('e35', '010-0092');
Insert Into EMP_DOCT_Phone value('e39', '010-0093');
Insert Into EMP_DOCT_Phone value('e40', '010-0094');
Insert Into EMP_DOCT_Phone value('e41', '010-0095');
Insert Into EMP_DOCT_Phone value('e42', '010-0096');
Insert Into EMP_DOCT_Phone value('e43', '010-0097');
Insert Into EMP_DOCT_Phone value('e44', '010-0098');
Insert Into EMP_DOCT_Phone value('e45', '010-0099');
Insert Into EMP_DOCT_Phone value('e46', '010-0100');
Insert Into EMP_DOCT_Phone value('e47', '010-0101');
Insert Into EMP_DOCT_Phone value('e48', '010-0102');
Insert Into EMP_DOCT_Phone value('e49', '010-0103');
Insert Into EMP_DOCT_Phone value('e50', '010-0104');
Insert Into EMP_DOCT_Phone value('e51', '010-0105');
Insert Into EMP_DOCT_Phone value('e52', '010-0106');
Insert Into EMP_DOCT_Phone value('e53', '010-0107');
Insert Into EMP_DOCT_Phone value('e54', '010-0108');
Insert Into EMP_DOCT_Phone value('e55', '010-0109');

Insert Into EMP_NURSE_Phone value('n01', '010-0110');
Insert Into EMP_NURSE_Phone value('n02', '010-0111');
Insert Into EMP_NURSE_Phone value('n03', '010-0112');
Insert Into EMP_NURSE_Phone value('n04', '010-0113');
Insert Into EMP_NURSE_Phone value('n05', '010-0114');
Insert Into EMP_NURSE_Phone value('n06', '010-0115');
Insert Into EMP_NURSE_Phone value('n07', '010-0116');
Insert Into EMP_NURSE_Phone value('n08', '010-0117');
Insert Into EMP_NURSE_Phone value('n09', '010-0118');
Insert Into EMP_NURSE_Phone value('n10', '010-0119');
Insert Into EMP_NURSE_Phone value('n11', '010-0120');
Insert Into EMP_NURSE_Phone value('n12', '010-0121');
Insert Into EMP_NURSE_Phone value('n13', '010-0122');
Insert Into EMP_NURSE_Phone value('n14', '010-0123');
Insert Into EMP_NURSE_Phone value('n15', '010-0124');
Insert Into EMP_NURSE_Phone value('n16', '010-0125');
Insert Into EMP_NURSE_Phone value('n17', '010-0126');
Insert Into EMP_NURSE_Phone value('n18', '010-0127');
Insert Into EMP_NURSE_Phone value('n19', '010-0128');
Insert Into EMP_NURSE_Phone value('n20', '010-0129');
Insert Into EMP_NURSE_Phone value('n21', '010-0130');
Insert Into EMP_NURSE_Phone value('n22', '010-0131');
Insert Into EMP_NURSE_Phone value('n23', '010-0132');
Insert Into EMP_NURSE_Phone value('n24', '010-0133');
Insert Into EMP_NURSE_Phone value('n25', '010-0134');
Insert Into EMP_NURSE_Phone value('n26', '010-0135');
Insert Into EMP_NURSE_Phone value('n27', '010-0136');
Insert Into EMP_NURSE_Phone value('n28', '010-0137');
Insert Into EMP_NURSE_Phone value('n29', '010-0138');
Insert Into EMP_NURSE_Phone value('n30', '010-0139');
Insert Into EMP_NURSE_Phone value('n31', '010-0140');
Insert Into EMP_NURSE_Phone value('n32', '010-0141');
Insert Into EMP_NURSE_Phone value('n33', '010-0142');
Insert Into EMP_NURSE_Phone value('n34', '010-0143');
Insert Into EMP_NURSE_Phone value('n35', '010-0144');
Insert Into EMP_NURSE_Phone value('n36', '010-0145');
Insert Into EMP_NURSE_Phone value('n37', '010-0146');
Insert Into EMP_NURSE_Phone value('n38', '010-0147');
Insert Into EMP_NURSE_Phone value('n39', '010-0148');
Insert Into EMP_NURSE_Phone value('n40', '010-0149');
Insert Into EMP_NURSE_Phone value('n41', '010-0150');
Insert Into EMP_NURSE_Phone value('n42', '010-0151');
Insert Into EMP_NURSE_Phone value('n43', '010-0152');
Insert Into EMP_NURSE_Phone value('n44', '010-0153');
Insert Into EMP_NURSE_Phone value('n45', '010-0154');
Insert Into EMP_NURSE_Phone value('n46', '010-0155');
Insert Into EMP_NURSE_Phone value('n47', '010-0156');
Insert Into EMP_NURSE_Phone value('n48', '010-0157');
Insert Into EMP_NURSE_Phone value('n49', '010-0158');
Insert Into EMP_NURSE_Phone value('n50', '010-0159');
Insert Into EMP_NURSE_Phone value('n51', '010-0160');
Insert Into EMP_NURSE_Phone value('n52', '010-0161');
Insert Into EMP_NURSE_Phone value('n53', '010-0162');
Insert Into EMP_NURSE_Phone value('n54', '010-0163');
Insert Into EMP_NURSE_Phone value('n55', '010-0164');
Insert Into EMP_NURSE_Phone value('n56', '010-0165');
Insert Into EMP_NURSE_Phone value('n57', '010-0166');
Insert Into EMP_NURSE_Phone value('n58', '010-0167');
Insert Into EMP_NURSE_Phone value('n59', '010-0168');
Insert Into EMP_NURSE_Phone value('n60', '010-0169');
Insert Into EMP_NURSE_Phone value('n01', '010-0170');
Insert Into EMP_NURSE_Phone value('n02', '010-0171');
Insert Into EMP_NURSE_Phone value('n03', '010-0172');
Insert Into EMP_NURSE_Phone value('n04', '010-0173');
Insert Into EMP_NURSE_Phone value('n05', '010-0174');
Insert Into EMP_NURSE_Phone value('n06', '010-0175');
Insert Into EMP_NURSE_Phone value('n07', '010-0176');
Insert Into EMP_NURSE_Phone value('n08', '010-0177');
Insert Into EMP_NURSE_Phone value('n09', '010-0178');
Insert Into EMP_NURSE_Phone value('n13', '010-0179');
Insert Into EMP_NURSE_Phone value('n14', '010-0180');
Insert Into EMP_NURSE_Phone value('n15', '010-0181');
Insert Into EMP_NURSE_Phone value('n16', '010-0182');
Insert Into EMP_NURSE_Phone value('n17', '010-0183');
Insert Into EMP_NURSE_Phone value('n18', '010-0184');
Insert Into EMP_NURSE_Phone value('n19', '010-0185');
Insert Into EMP_NURSE_Phone value('n20', '010-0186');
Insert Into EMP_NURSE_Phone value('n21', '010-0187');
Insert Into EMP_NURSE_Phone value('n22', '010-0188');
Insert Into EMP_NURSE_Phone value('n23', '010-0189');
Insert Into EMP_NURSE_Phone value('n24', '010-0190');
Insert Into EMP_NURSE_Phone value('n35', '010-0191');
Insert Into EMP_NURSE_Phone value('n36', '010-0192');
Insert Into EMP_NURSE_Phone value('n37', '010-0193');
Insert Into EMP_NURSE_Phone value('n44', '010-0194');
Insert Into EMP_NURSE_Phone value('n45', '010-0195');
Insert Into EMP_NURSE_Phone value('n46', '010-0196');
Insert Into EMP_NURSE_Phone value('n47', '010-0197');
Insert Into EMP_NURSE_Phone value('n48', '010-0198');
Insert Into EMP_NURSE_Phone value('n49', '010-0199');
Insert Into EMP_NURSE_Phone value('n50', '010-0200');
Insert Into EMP_NURSE_Phone value('n51', '010-0201');

Insert Into PATIENT_Phone value('p01', '010-0202');
Insert Into PATIENT_Phone value('p02', '010-0203');
Insert Into PATIENT_Phone value('p03', '010-0204');
Insert Into PATIENT_Phone value('p04', '010-0205');
Insert Into PATIENT_Phone value('p05', '010-0206');
Insert Into PATIENT_Phone value('p06', '010-0207');
Insert Into PATIENT_Phone value('p07', '010-0208');
Insert Into PATIENT_Phone value('p08', '010-0209');
Insert Into PATIENT_Phone value('p09', '010-0210');
Insert Into PATIENT_Phone value('p10', '010-0211');
Insert Into PATIENT_Phone value('p11', '010-0212');
Insert Into PATIENT_Phone value('p12', '010-0213');
Insert Into PATIENT_Phone value('p13', '010-0214');
Insert Into PATIENT_Phone value('p14', '010-0215');
Insert Into PATIENT_Phone value('p15', '010-0216');
Insert Into PATIENT_Phone value('p16', '010-0217');
Insert Into PATIENT_Phone value('p17', '010-0218');
Insert Into PATIENT_Phone value('p18', '010-0219');
Insert Into PATIENT_Phone value('p19', '010-0220');
Insert Into PATIENT_Phone value('p20', '010-0221');
Insert Into PATIENT_Phone value('p21', '010-0222');
Insert Into PATIENT_Phone value('p22', '010-0223');
Insert Into PATIENT_Phone value('p23', '010-0224');
Insert Into PATIENT_Phone value('p24', '010-0225');
Insert Into PATIENT_Phone value('p25', '010-0226');
Insert Into PATIENT_Phone value('p26', '010-0227');
Insert Into PATIENT_Phone value('p27', '010-0228');
Insert Into PATIENT_Phone value('p28', '010-0229');
Insert Into PATIENT_Phone value('p29', '010-0230');
Insert Into PATIENT_Phone value('p30', '010-0231');
Insert Into PATIENT_Phone value('p31', '010-0245');
Insert Into PATIENT_Phone value('p32', '010-0246');
Insert Into PATIENT_Phone value('p33', '010-0247');
Insert Into PATIENT_Phone value('p34', '010-0248');
Insert Into PATIENT_Phone value('p35', '010-0249');
Insert Into PATIENT_Phone value('p01', '010-0232');
Insert Into PATIENT_Phone value('p02', '010-0233');
Insert Into PATIENT_Phone value('p03', '010-0234');
Insert Into PATIENT_Phone value('p04', '010-0235');
Insert Into PATIENT_Phone value('p05', '010-0236');
Insert Into PATIENT_Phone value('p06', '010-0237');
Insert Into PATIENT_Phone value('p11', '010-0238');
Insert Into PATIENT_Phone value('p16', '010-0239');
Insert Into PATIENT_Phone value('p26', '010-0240');
Insert Into PATIENT_Phone value('p27', '010-0241');
Insert Into PATIENT_Phone value('p28', '010-0242');
Insert Into PATIENT_Phone value('p29', '010-0243');
Insert Into PATIENT_Phone value('p30', '010-0244');

Insert Into EMP_DOCT value('e01', '000-000', '서미소', '30', '4', '7000', 'd01');
Insert Into EMP_DOCT value('e02', '000-001', '황선우', '40', '10', '6900', 'd01');
Insert Into EMP_DOCT value('e03', '000-002', '강소영', '35', '3', '9000', 'd02');
Insert Into EMP_DOCT value('e04', '000-003', '조예준', '34', '3', '9050', 'd02');
Insert Into EMP_DOCT value('e05', '000-004', '장예상', '32', '5', '8910', 'd03');
Insert Into EMP_DOCT value('e06', '000-005', '서은혜', '54', '12', '8999', 'd03');
Insert Into EMP_DOCT value('e07', '000-006', '김수애', '43', '5', '9590', 'd04');
Insert Into EMP_DOCT value('e08', '000-007', '조윤구', '34', '8', '9670', 'd04');
Insert Into EMP_DOCT value('e09', '000-008', '하수빈', '53', '13', '9020', 'd05');
Insert Into EMP_DOCT value('e10', '000-009', '장한성', '43', '13', '9100', 'd05');
Insert Into EMP_DOCT value('e11', '000-010', '정한흠', '42', '14', '8890', 'd06');
Insert Into EMP_DOCT value('e12', '000-011', '홍수호', '31', '6', '8700', 'd06');
Insert Into EMP_DOCT value('e13', '000-012', '상소민', '47', '5', '11000', 'd07');
Insert Into EMP_DOCT value('e14', '000-013', '김채윤', '53', '16', '10000', 'd07');
Insert Into EMP_DOCT value('e15', '000-014', '하주은', '54', '15', '8800', 'd08');
Insert Into EMP_DOCT value('e16', '000-015', '하정임', '43', '3', '8400', 'd08');
Insert Into EMP_DOCT value('e17', '000-016', '정연석', '27', '1', '9150', 'd09');
Insert Into EMP_DOCT value('e18', '000-017', '윤영재', '28', '2', '9050', 'd09');
Insert Into EMP_DOCT value('e19', '000-018', '하수민', '34', '6', '9720', 'd10');
Insert Into EMP_DOCT value('e20', '000-019', '황정진', '31', '5', '9420', 'd10');
Insert Into EMP_DOCT value('e21', '000-020', '서세영', '29', '4', '9320', 'd11');
Insert Into EMP_DOCT value('e22', '000-021', '윤현윤', '32', '5', '9340', 'd11');
Insert Into EMP_DOCT value('e23', '000-022', '최아솔', '54', '13', '9222', 'd12');
Insert Into EMP_DOCT value('e24', '000-023', '고나연', '34', '6', '9224', 'd12');
Insert Into EMP_DOCT value('e25', '000-024', '윤우진', '35', '12', '6205', 'd13');
Insert Into EMP_DOCT value('e26', '000-025', '조연진', '54', '16', '6203', 'd13');
Insert Into EMP_DOCT value('e27', '000-026', '최희섭', '35', '6', '8270', 'd14');
Insert Into EMP_DOCT value('e28', '000-027', '김노아', '65', '23', '8220', 'd14');
Insert Into EMP_DOCT value('e29', '000-028', '하재민', '32', '8', '9600', 'd15');
Insert Into EMP_DOCT value('e30', '000-029', '최아준', '43', '7', '9650', 'd15');
Insert Into EMP_DOCT value('e31', '000-030', '하장현', '43', '7', '10800', 'd16');
Insert Into EMP_DOCT value('e32', '000-031', '사효리', '56', '21', '9900', 'd16');
Insert Into EMP_DOCT value('e33', '000-032', '이원영', '65', '30', '11230', 'd17');
Insert Into EMP_DOCT value('e34', '000-033', '이대윤', '43', '9', '11410', 'd17');
Insert Into EMP_DOCT value('e35', '000-034', '고라영', '32', '9', '8860', 'd18');
Insert Into EMP_DOCT value('e36', '000-035', '윤영익', '53', '21', '8830', 'd18');
Insert Into EMP_DOCT value('e37', '000-036', '양현진', '54', '23', '7500', 'd19');
Insert Into EMP_DOCT value('e38', '000-037', '장연섭', '34', '1', '7300', 'd19');
Insert Into EMP_DOCT value('e39', '000-038', '이영일', '27', '2', '10500', 'd20');
Insert Into EMP_DOCT value('e40', '000-039', '서세인', '53', '23', '11300', 'd20');
Insert Into EMP_DOCT value('e41', '000-040', '양우재', '34', '3', '7963', 'd21');
Insert Into EMP_DOCT value('e42', '000-041', '하주희', '53', '26', '7900', 'd21');
Insert Into EMP_DOCT value('e43', '000-042', '김노아', '43', '6', '8870', 'd22');
Insert Into EMP_DOCT value('e44', '000-043', '이우진', '28', '1', '8860', 'd22');
Insert Into EMP_DOCT value('e45', '000-044', '장하재', '28', '1', '8760', 'd23');
Insert Into EMP_DOCT value('e46', '000-045', '이영선', '54', '12', '8730', 'd23');
Insert Into EMP_DOCT value('e47', '000-046', '황조윤', '33', '2', '8025', 'd24');
Insert Into EMP_DOCT value('e48', '000-047', '하주아', '34', '5', '8200', 'd24');
Insert Into EMP_DOCT value('e49', '000-048', '상준희', '30', '6', '9000', 'd25');
Insert Into EMP_DOCT value('e50', '000-049', '양희영', '40', '10', '9100', 'd25');
Insert Into EMP_DOCT value('e51', '000-050', '조하완', '34', '4', '8800', 'd26');
Insert Into EMP_DOCT value('e52', '000-051', '심지민', '45', '3', '8900', 'd26');
Insert Into EMP_DOCT value('e53', '000-052', '이우엽', '65', '35', '10900', 'd27');
Insert Into EMP_DOCT value('e54', '000-053', '김명채', '61', '36', '9500', 'd27');
Insert Into EMP_DOCT value('e55', '000-054', '하차희', '27', '1', '9000', 'd28');
Insert Into EMP_DOCT value('e56', '000-055', '하진주', '53', '32', '9100', 'd28');
Insert Into EMP_DOCT value('e57', '000-056', '강규림', '48', '2', '7530', 'd29');
Insert Into EMP_DOCT value('e58', '000-057', '심다원', '57', '31', '7500', 'd29');
Insert Into EMP_DOCT value('e59', '000-058', '홍재하', '38', '1', '12100', 'd30');
Insert Into EMP_DOCT value('e60', '000-059', '서초아', '39', '10', '13000', 'd30');
Insert Into EMP_DOCT value('e61', '000-060', '강남영', '40', '6', '8230', 'd31');
Insert Into EMP_DOCT value('e62', '000-061', '이채원', '50', '21', '8103', 'd31');
Insert Into EMP_DOCT value('e63', '000-062', '박희원', '45', '10', '11100', 'd32');
Insert Into EMP_DOCT value('e64', '000-063', '김아름', '31', '4', '11200', 'd32');
Insert Into EMP_DOCT value('e65', '000-064', '조문익', '32', '2', '12000', 'd33');
Insert Into EMP_DOCT value('e66', '000-065', '박재영', '27', '1', '12300', 'd33');

Insert Into EMP_NURSE value('n01', '000-066', '윤연후', '31', '4', 'd34');
Insert Into EMP_NURSE value('n02', '000-067', '황누리', '65', '28', 'd34');
Insert Into EMP_NURSE value('n03', '000-068', '이윤제', '34', '1', 'd35');
Insert Into EMP_NURSE value('n04', '000-069', '공손율', '27', '1', 'd35');
Insert Into EMP_NURSE value('n05', '000-070', '김채혁', '53', '23', 'd36');
Insert Into EMP_NURSE value('n06', '000-071', '조송이', '28', '2', 'd36');
Insert Into EMP_NURSE value('n07', '000-072', '최시아', '32', '10', 'd37');
Insert Into EMP_NURSE value('n08', '000-073', '이예슬', '32', '9', 'd37');
Insert Into EMP_NURSE value('n09', '000-074', '한소이', '27', '6', 'd38');
Insert Into EMP_NURSE value('n10', '000-075', '김준규', '32', '8', 'd38');
Insert Into EMP_NURSE value('n11', '000-076', '원세인', '28', '7', 'd39');
Insert Into EMP_NURSE value('n12', '000-077', '백하영', '35', '6', 'd39');
Insert Into EMP_NURSE value('n13', '000-078', '황로영', '28', '3', 'd40');
Insert Into EMP_NURSE value('n14', '000-079', '최지민', '43', '21', 'd40');
Insert Into EMP_NURSE value('n15', '000-080', '윤호일', '54', '27', 'd41');
Insert Into EMP_NURSE value('n16', '000-081', '원준희', '33', '10', 'd41');
Insert Into EMP_NURSE value('n17', '000-082', '이민교', '35', '3', 'd42');
Insert Into EMP_NURSE value('n18', '000-083', '공진설', '43', '20', 'd42');
Insert Into EMP_NURSE value('n19', '000-084', '백준규', '53', '27', 'd43');
Insert Into EMP_NURSE value('n20', '000-085', '원지민', '54', '28', 'd43');
Insert Into EMP_NURSE value('n21', '000-086', '오창하', '53', '32', 'd44');
Insert Into EMP_NURSE value('n22', '000-087', '조초아', '54', '30', 'd44');
Insert Into EMP_NURSE value('n23', '000-088', '원나래', '43', '21', 'd45');
Insert Into EMP_NURSE value('n24', '000-089', '이치범', '43', '12', 'd45');
Insert Into EMP_NURSE value('n25', '000-090', '김초훈', '27', '6', 'd46');
Insert Into EMP_NURSE value('n26', '000-091', '임채연', '56', '20', 'd46');
Insert Into EMP_NURSE value('n27', '000-092', '장영호', '34', '8', 'd47');
Insert Into EMP_NURSE value('n28', '000-093', '송설민', '31', '6', 'd47');
Insert Into EMP_NURSE value('n29', '000-094', '김조문', '32', '8', 'd48');
Insert Into EMP_NURSE value('n30', '000-095', '오윤도', '39', '12', 'd48');
Insert Into EMP_NURSE value('n31', '000-096', '이치민', '40', '10', 'd49');
Insert Into EMP_NURSE value('n32', '000-097', '오찬을', '38', '9', 'd49');
Insert Into EMP_NURSE value('n33', '000-098', '공나래', '56', '7', 'd50');
Insert Into EMP_NURSE value('n34', '000-099', '하차빈', '32', '8', 'd50');
Insert Into EMP_NURSE value('n35', '000-100', '임차인', '35', '10', 'd51');
Insert Into EMP_NURSE value('n36', '000-101', '윤아섭', '34', '10', 'd51');
Insert Into EMP_NURSE value('n37', '000-102', '이창혁', '34', '12', 'd52');
Insert Into EMP_NURSE value('n38', '000-103', '장채승', '65', '41', 'd52');
Insert Into EMP_NURSE value('n39', '000-104', '문주성', '30', '10', 'd53');
Insert Into EMP_NURSE value('n40', '000-105', '문창용', '40', '12', 'd53');
Insert Into EMP_NURSE value('n41', '000-106', '함예손', '54', '31', 'd54');
Insert Into EMP_NURSE value('n42', '000-107', '임다혜', '53', '20', 'd54');
Insert Into EMP_NURSE value('n43', '000-108', '임지민', '54', '21', 'd55');
Insert Into EMP_NURSE value('n44', '000-109', '홍윤섭', '35', '4', 'd55');
Insert Into EMP_NURSE value('n45', '000-110', '강주하', '34', '6', 'd56');
Insert Into EMP_NURSE value('n46', '000-111', '하지율', '32', '7', 'd56');
Insert Into EMP_NURSE value('n47', '000-112', '유병호', '53', '15', 'd57');
Insert Into EMP_NURSE value('n48', '000-113', '한준아', '65', '32', 'd57');
Insert Into EMP_NURSE value('n49', '000-114', '송진영', '53', '16', 'd58');
Insert Into EMP_NURSE value('n50', '000-115', '함윤고', '34', '10', 'd58');
Insert Into EMP_NURSE value('n51', '000-116', '임규미', '57', '21', 'd59');
Insert Into EMP_NURSE value('n52', '000-117', '문재성', '50', '21', 'd59');
Insert Into EMP_NURSE value('n53', '000-118', '오영택', '43', '21', 'd60');
Insert Into EMP_NURSE value('n54', '000-119', '문종후', '34', '1', 'd60');
Insert Into EMP_NURSE value('n55', '000-120', '장예완', '43', '14', 'd61');
Insert Into EMP_NURSE value('n56', '000-121', '송차윤', '45', '10', 'd61');
Insert Into EMP_NURSE value('n57', '000-122', '홍청하', '42', '23', 'd62');
Insert Into EMP_NURSE value('n58', '000-123', '송나리', '54', '26', 'd62');
Insert Into EMP_NURSE value('n59', '000-124', '하동훈', '54', '31', 'd63');
Insert Into EMP_NURSE value('n60', '000-125', '유휘제', '43', '10', 'd63');

Insert Into PATIENT value('p01', '000-126', '43', '이설빈', 'e01');
Insert Into PATIENT value('p02', '000-127', '53', '김현영', 'e01');
Insert Into PATIENT value('p03', '000-128', '54', '심유나', 'e02');
Insert Into PATIENT value('p04', '000-129', '53', '최희솔', 'e02');
Insert Into PATIENT value('p05', '000-130', '54', '홍율우', 'e02');
Insert Into PATIENT value('p06', '000-131', '43', '함유리', 'e03');
Insert Into PATIENT value('p07', '000-132', '43', '이시하', 'e05');
Insert Into PATIENT value('p08', '000-133', '53', '서노아', 'e05');
Insert Into PATIENT value('p09', '000-134', '34', '김여솔', 'e06');
Insert Into PATIENT value('p10', '000-135', '57', '최채희', 'e06');
Insert Into PATIENT value('p11', '000-136', '50', '오수연', 'e07');
Insert Into PATIENT value('p12', '000-137', '43', '김세영', 'e07');
Insert Into PATIENT value('p13', '000-138', '34', '하시영', 'e08');
Insert Into PATIENT value('p14', '000-139', '43', '황지민', 'e09');
Insert Into PATIENT value('p15', '000-140', '65', '이정아', 'e10');
Insert Into PATIENT value('p16', '000-141', '30', '오주이', 'e10');
Insert Into PATIENT value('p17', '000-142', '40', '이재빈', 'e10');
Insert Into PATIENT value('p18', '000-143', '54', '황나리', 'e11');
Insert Into PATIENT value('p19', '000-144', '53', '김채이', 'e11');
Insert Into PATIENT value('p20', '000-145', '54', '이지혜', 'e13');
Insert Into PATIENT value('p21', '000-146', '35', '이채희', 'e14');
Insert Into PATIENT value('p22', '000-147', '34', '조시하', 'e15');
Insert Into PATIENT value('p23', '000-148', '32', '송초영', 'e16');
Insert Into PATIENT value('p24', '000-149', '53', '이정은', 'e16');
Insert Into PATIENT value('p25', '000-150', '65', '송정임', 'e17');
Insert Into PATIENT value('p26', '000-151', '53', '장준아', 'e19');
Insert Into PATIENT value('p27', '000-152', '34', '하차빈', 'e23');
Insert Into PATIENT value('p28', '000-153', '57', '김진설', 'e33');
Insert Into PATIENT value('p29', '000-154', '54', '지준아', 'e34');
Insert Into PATIENT value('p30', '000-155', '54', '이지민', 'e34');
Insert Into PATIENT value('p31', '000-156', '50', '하상훈', 'e35');
Insert Into PATIENT value('p32', '000-157', '43', '이채희', 'e36');
Insert Into PATIENT value('p33', '000-158', '34', '양진호', 'e37');
Insert Into PATIENT value('p34', '000-159', '43', '오지하', 'e38');
Insert Into PATIENT value('p35', '000-160', '65', '홍채하', 'e39');

Insert Into Resident value('김채이', '28', 'e01', '0', '피부과');
Insert Into Resident value('이지혜', '32', 'e03', '4', '산부인과');
Insert Into Resident value('이채희', '32', 'e03', '3', '성형외과');
Insert Into Resident value('조시하', '27', 'e06', '4', '외과');
Insert Into Resident value('송초영', '32', 'e06', '0', '안과');
Insert Into Resident value('김초훈', '28', 'e08', '2', '성혀외과');
Insert Into Resident value('임채연', '35', 'e08', '2', '내과');
Insert Into Resident value('장영호', '28', 'e10', '0', '외과');
Insert Into Resident value('송설민', '32', 'e11', '1', '안과');
Insert Into Resident value('김조문', '35', 'e12', '4', '마취통증의학과');
Insert Into Resident value('황선우', '34', 'e13', '0', '소아과');
Insert Into Resident value('강소영', '34', 'e15', '3', '재활의학과');
Insert Into Resident value('조예준', '28', 'e17', '1', '흉부외과');
Insert Into Resident value('장예상', '32', 'e19', '0', '영상의학과');
Insert Into Resident value('서은혜', '32', 'e19', '4', '내과');
Insert Into Resident value('김수애', '28', 'e19', '0', '이비인후과');
Insert Into Resident value('조윤구', '32', 'e20', '0', '신경과');
Insert Into Resident value('하수빈', '35', 'e21', '1', '응급의학과');
Insert Into Resident value('장한성', '34', 'e22', '0', '신경과');
Insert Into Resident value('정한흠', '27', 'e26', '3', '핵의학과');
Insert Into Resident value('홍수호', '21', 'e27', '1', '산부인과');
Insert Into Resident value('상소민', '24', 'e29', '0', '정형외과');
Insert Into Resident value('하시영', '31', 'e31', '2', '재활의학과');
Insert Into Resident value('황지민', '23', 'e40', '0', '정신과');
Insert Into Resident value('이정아', '38', 'e40', '0', '비뇨기과');
Insert Into Resident value('오주이', '31', 'e42', '0', '방사선과');
Insert Into Resident value('이재빈', '29', 'e42', '2', '소아과');
Insert Into Resident value('황나리', '30', 'e46', '0', '병리학과');
Insert Into Resident value('김채이', '34', 'e60', '1', '가정의학과');
Insert Into Resident value('김여솔', '23', 'e60', '1', '피부과');

Insert Into WARD value('w01', '병동1', '30', 'd52');
Insert Into WARD value('w02', '병동2', '30', 'd52');
Insert Into WARD value('w03', '병동3', '30', 'd52');
Insert Into WARD value('w04', '병동4', '30', 'd52');
Insert Into WARD value('w05', '병동5', '30', 'd52');
Insert Into WARD value('w06', '병동6', '30', 'd52');
Insert Into WARD value('w07', '병동7', '30', 'd53');
Insert Into WARD value('w08', '병동8', '30', 'd53');
Insert Into WARD value('w09', '병동9', '30', 'd53');
Insert Into WARD value('w10', '병동10', '40', 'd54');
Insert Into WARD value('w11', '병동11', '40', 'd54');
Insert Into WARD value('w12', '병동12', '40', 'd55');
Insert Into WARD value('w13', '병동13', '40', 'd55');
Insert Into WARD value('w14', '병동14', '40', 'd56');
Insert Into WARD value('w15', '병동15', '40', 'd56');
Insert Into WARD value('w16', '병동16', '40', 'd56');
Insert Into WARD value('w17', '병동17', '40', 'd56');
Insert Into WARD value('w18', '병동18', '40', 'd57');
Insert Into WARD value('w19', '병동19', '40', 'd57');
Insert Into WARD value('w20', '병동20', '40', 'd57');
Insert Into WARD value('w21', '병동21', '40', 'd57');
Insert Into WARD value('w22', '병동22', '40', 'd57');
Insert Into WARD value('w23', '병동23', '40', 'd57');
Insert Into WARD value('w24', '병동24', '40', 'd57');
Insert Into WARD value('w25', '병동25', '40', 'd57');
Insert Into WARD value('w26', '병동26', '40', 'd58');
Insert Into WARD value('w27', '병동27', '40', 'd58');
Insert Into WARD value('w28', '병동28', '40', 'd59');
Insert Into WARD value('w29', '병동29', '40', 'd60');
Insert Into WARD value('w30', '병동30', '40', 'd60');

Insert Into Intern value('황나리', '21', 'e40', '1');
Insert Into Intern value('김채이', '22', 'e41', '0');
Insert Into Intern value('김채이', '20', 'e42', '0');
Insert Into Intern value('이지혜', '24', 'e43', '1');
Insert Into Intern value('이채희', '23', 'e44', '0');
Insert Into Intern value('조시하', '27', 'e44', '1');
Insert Into Intern value('송초영', '26', 'e44', '0');
Insert Into Intern value('장영호', '27', 'e44', '1');
Insert Into Intern value('송설민', '26', 'e45', '0');
Insert Into Intern value('임채연', '28', 'e46', '0');
Insert Into Intern value('장영호', '21', 'e49', '1');
Insert Into Intern value('송설민', '23', 'e49', '0');
Insert Into Intern value('김조문', '27', 'e50', '1');
Insert Into Intern value('황선우', '23', 'e51', '1');
Insert Into Intern value('홍율우', '23', 'e51', '0');
Insert Into Intern value('오윤도', '29', 'e51', '0');
Insert Into Intern value('이치민', '25', 'e52', '1');
Insert Into Intern value('송초영', '26', 'e52', '0');
Insert Into Intern value('김현영', '25', 'e54', '1');
Insert Into Intern value('심유나', '22', 'e54', '0');
Insert Into Intern value('최희솔', '27', 'e56', '1');
Insert Into Intern value('홍율우', '21', 'e56', '0');
Insert Into Intern value('오윤도', '22', 'e57', '1');
Insert Into Intern value('이치민', '26', 'e58', '1');
Insert Into Intern value('오찬을', '27', 'e59', '1');
Insert Into Intern value('공나래', '23', 'e59', '0');
Insert Into Intern value('하차빈', '27', 'e59', '0');
Insert Into Intern value('임차인', '21', 'e60', '1');
Insert Into Intern value('윤아섭', '22', 'e60', '0');
Insert Into Intern value('이창혁', '21', 'e60', '0');

Insert Into ADMISSION value('p01', 'w01', '20100928', '20110801');
Insert Into ADMISSION value('p02', 'w01', '20110706', '20110830');
Insert Into ADMISSION value('p03', 'w02', '20130403', '20131010');
Insert Into ADMISSION value('p04', 'w03', '20090424', '20101206');
Insert Into ADMISSION value('p05', 'w05', '20010201', '20011218');
Insert Into ADMISSION value('p06', 'w07', '19990227', '20000102');
Insert Into ADMISSION value('p07', 'w07', '20100305', '20130106');
Insert Into ADMISSION value('p08', 'w08', '20120801', '20130720');
Insert Into ADMISSION value('p09', 'w10', '20130830', '20160609');
Insert Into ADMISSION value('p10', 'w11', '20111010', '20120310');
Insert Into ADMISSION value('p11', 'w11', '20120102', '20120615');
Insert Into ADMISSION value('p12', 'w12', '20140106', '20150601');
Insert Into ADMISSION value('p13', 'w13', '20150720', '20160102');
Insert Into ADMISSION value('p14', 'w14', '20160609', '20160801');
Insert Into ADMISSION value('p17', 'w14', '19980823', '20000603');
Insert Into ADMISSION value('p18', 'w14', '19960127', '19961012');
Insert Into ADMISSION value('p19', 'w14', '20030907', '20041201');
Insert Into ADMISSION value('p20', 'w16', '20000403', '20010105');
Insert Into ADMISSION value('p21', 'w16', '20080408', '20090130');
Insert Into ADMISSION value('p22', 'w17', '20060201', '20071130');
Insert Into ADMISSION value('p23', 'w17', '20070227', '20071107');
Insert Into ADMISSION value('p24', 'w18', '20150305', '20150605');
Insert Into ADMISSION value('p25', 'w18', '20000801', '20010701');
Insert Into ADMISSION value('p27', 'w19', '20150830', '20160403');
Insert Into ADMISSION value('p28', 'w20', '20121010', '20160424');
Insert Into ADMISSION value('p29', 'w20', '20151206', '20160201');
Insert Into ADMISSION value('p30', 'w21', '20131218', '20150227');
Insert Into ADMISSION value('p31', 'w21', '20000102', '20001206');
Insert Into ADMISSION value('p32', 'w23', '20150106', '20151218');
Insert Into ADMISSION value('p33', 'w23', '20090823', '20120102');

Insert Into PTREAT value('p01', '1', 'C01', '20041201');
Insert Into PTREAT value('p01', '2', 'C02', '20150830');
Insert Into PTREAT value('p02', '1', 'C01', '20101206');
Insert Into PTREAT value('p03', '1', 'C03', '20011218');
Insert Into PTREAT value('p04', '1', 'C04', '20000102');
Insert Into PTREAT value('p05', '1', 'C04', '20130106');
Insert Into PTREAT value('p06', '1', 'C05', '20130720');
Insert Into PTREAT value('p07', '1', 'C06', '20101206');
Insert Into PTREAT value('p08', '1', 'C03', '20011218');
Insert Into PTREAT value('p09', '1', 'C01', '20000102');
Insert Into PTREAT value('p10', '1', 'C02', '20131010');
Insert Into PTREAT value('p11', '1', 'C07', '20101206');
Insert Into PTREAT value('p12', '1', 'C02', '20011218');
Insert Into PTREAT value('p13', '1', 'C04', '20000102');
Insert Into PTREAT value('p14', '1', 'C01', '20120801');
Insert Into PTREAT value('p15', '1', 'C07', '20130830');
Insert Into PTREAT value('p16', '1', 'C10', '20111010');
Insert Into PTREAT value('p16', '2', 'C12', '20111010');
Insert Into PTREAT value('p16', '3', 'C02', '20131010');
Insert Into PTREAT value('p17', '1', 'C07', '20101206');
Insert Into PTREAT value('p17', '2', 'C05', '20011218');
Insert Into PTREAT value('p18', '1', 'C09', '20000102');
Insert Into PTREAT value('p19', '1', 'C02', '20150305');
Insert Into PTREAT value('p20', '1', 'C10', '20000801');
Insert Into PTREAT value('p21', '1', 'C15', '20150830');
Insert Into PTREAT value('p22', '1', 'C18', '20000801');
Insert Into PTREAT value('p23', '1', 'C19', '20150830');
Insert Into PTREAT value('p24', '1', 'C20', '20000403');
Insert Into PTREAT value('p25', '1', 'C02', '20080408');
Insert Into PTREAT value('p25', '2', 'C08', '20060201');
Insert Into PTREAT value('p26', '1', 'C20', '20070227');
Insert Into PTREAT value('p26', '2', 'C21', '20150305');
Insert Into PTREAT value('p27', '1', 'C15', '20000801');
Insert Into PTREAT value('p28', '1', 'C01', '20000801');
Insert Into PTREAT value('p29', '1', 'C03', '20160102');
Insert Into PTREAT value('p29', '2', 'C12', '20160801');
Insert Into PTREAT value('p30', '1', 'C14', '20000603');
Insert Into PTREAT value('p31', '1', 'C25', '19961012');
Insert Into PTREAT value('p32', '1', 'C21', '20041201');
Insert Into PTREAT value('p33', '1', 'C06', '20010105');
Insert Into PTREAT value('p34', '1', 'C19', '20130403');
Insert Into PTREAT value('p35', '1', 'C10', '20090424');

Insert Into CARE value('p01', 'n01');
Insert Into CARE value('p02', 'n01');
Insert Into CARE value('p02', 'n02');
Insert Into CARE value('p03', 'n02');
Insert Into CARE value('p04', 'n03');
Insert Into CARE value('p04', 'n04');
Insert Into CARE value('p05', 'n05');
Insert Into CARE value('p06', 'n06');
Insert Into CARE value('p06', 'n07');
Insert Into CARE value('p06', 'n08');
Insert Into CARE value('p07', 'n09');
Insert Into CARE value('p08', 'n10');
Insert Into CARE value('p09', 'n11');
Insert Into CARE value('p10', 'n12');
Insert Into CARE value('p11', 'n13');
Insert Into CARE value('p11', 'n14');
Insert Into CARE value('p11', 'n15');
Insert Into CARE value('p12', 'n16');
Insert Into CARE value('p13', 'n16');
Insert Into CARE value('p14', 'n16');
Insert Into CARE value('p15', 'n17');
Insert Into CARE value('p16', 'n18');
Insert Into CARE value('p17', 'n18');
Insert Into CARE value('p18', 'n18');
Insert Into CARE value('p19', 'n18');
Insert Into CARE value('p19', 'n19');
Insert Into CARE value('p20', 'n19');
Insert Into CARE value('p20', 'n20');
Insert Into CARE value('p21', 'n20');
Insert Into CARE value('p22', 'n20');
Insert Into CARE value('p22', 'n21');
Insert Into CARE value('p22', 'n22');
Insert Into CARE value('p23', 'n21');
Insert Into CARE value('p24', 'n21');
Insert Into CARE value('p25', 'n22');
Insert Into CARE value('p26', 'n23');
Insert Into CARE value('p27', 'n24');
Insert Into CARE value('p28', 'n25');
Insert Into CARE value('p29', 'n26');
Insert Into CARE value('p30', 'n27');
Insert Into CARE value('p30', 'n28');
Insert Into CARE value('p31', 'n27');
Insert Into CARE value('p32', 'n28');
Insert Into CARE value('p33', 'n28');
Insert Into CARE value('p34', 'n29');
Insert Into CARE value('p35', 'n30');

Insert Into NURSEIncome value('1', '2780');
Insert Into NURSEIncome value('2', '2880');
Insert Into NURSEIncome value('3', '2980');
Insert Into NURSEIncome value('4', '3080');
Insert Into NURSEIncome value('5', '3180');
Insert Into NURSEIncome value('6', '3280');
Insert Into NURSEIncome value('7', '3380');
Insert Into NURSEIncome value('8', '3480');
Insert Into NURSEIncome value('9', '3580');
Insert Into NURSEIncome value('10', '3680');
Insert Into NURSEIncome value('12', '3880');
Insert Into NURSEIncome value('13', '3980');
Insert Into NURSEIncome value('14', '4080');
Insert Into NURSEIncome value('15', '4180');
Insert Into NURSEIncome value('16', '4280');
Insert Into NURSEIncome value('21', '4780');
Insert Into NURSEIncome value('22', '4880');
Insert Into NURSEIncome value('23', '4980');
Insert Into NURSEIncome value('26', '5280');
Insert Into NURSEIncome value('31', '5780');
Insert Into NURSEIncome value('35', '6180');

SELECT count(EMPNo) AS 총직원수 FROM(
	SELECT EMPNo
	FROM EMP_DOCT
	UNION
	SELECT EMPNo
	FROM EMP_NURSE) AS S;
	
SELECT *
FROM EMP_DOCT
WHERE EMPNO in(
	SELECT DOCTNo
	FROM PATIENT
	WHERE PATNo in(
		SELECT PATNo
		FROM PATIENTwithPhone
		WHERE Phone = '010-0220'));

SELECT *
FROM NURSEwithPhoneAndIncome
ORDER BY Income;

SELECT Name AS 레지던트이름, Age, WorkYear, Major
FROM DOCTwithResident
WHERE DEPTNo in(
	SELECT DEPTNo
	FROM DEPT_TREAT
	WHERE DEPTName = '치과');

SELECT *
FROM EMP_DOCT
WHERE EMPNo IN (SELECT EMPNo FROM DOCTwithIntern)
	AND EMPNo IN (SELECT EMPNo FROM DOCTwithResident)
	AND EMPNo IN (SELECT DOCTNo FROM PATIENT);
	
SELECT EMPNo, EMPSSN, EMPName, EMPAge, EMPWorkYear, DEPTNo AS 관리부서
FROM MANAGERofDEPT_NURSE
WHERE EMPAge >= 30;

SELECT COUNT(*)
FROM ADMISSION
WHERE (ADMISSIONSTART >= 20000101) AND (ADMISSIONEND <= 20151231);

SELECT count(EMPNo) AS 해고대상
FROM EMP_DOCT
WHERE EMPNo NOT IN (SELECT EMPNo FROM DOCTwithIntern)
	AND EMPNo NOT IN (SELECT EMPNo FROM DOCTwithResident)
	AND EMPNo NOT IN (SELECT DOCTNo FROM PATIENT);
	
SELECT major, COUNT(*) AS 레지던트수
FROM Resident
GROUP BY major;

SELECT SUM(DOCTIncome) AS 연봉의합
FROM EMP_DOCT
WHERE EMPNo IN (
	SELECT DOCTNo
	FROM PATIENTatWARD
	WHERE WARDNo IN(
		SELECT WARDNo
		FROM WARD
		WHERE WARDName = '병동7'
	)
);

SELECT PATNo, PATName AS 환자이름, PATAge, COUNT(PATNO) AS 간호사수
FROM PATIENT NATURAL JOIN CARE
GROUP BY PATNo;
	
set foreign_key_checks=1;

