-- ----------------------------------------------------------
-- MDB Tools - A library for reading MS Access database files
-- Copyright (C) 2000-2011 Brian Bruns and others.
-- Files in libmdb are licensed under LGPL and the utilities under
-- the GPL, see COPYING.LIB and COPYING files respectively.
-- Check out http://mdbtools.sourceforge.net
-- ----------------------------------------------------------

-- That file uses encoding UTF-8

CREATE TABLE aa
 (
	AccountID			INTEGER, 
	SumOfAmount			REAL, 
	id			INTEGER
);

-- CREATE INDEXES ...
CREATE INDEX aa_AccountID_idx ON aa (AccountID);
CREATE INDEX aa_id_idx ON aa (id);

CREATE TABLE Dual
 (
	id			INTEGER
	, PRIMARY KEY (id)
);

-- CREATE INDEXES ...

CREATE TABLE Table1
 (
	ID			INTEGER, 
	AccountID			INTEGER, 
	Amount			REAL
);

-- CREATE INDEXES ...
CREATE INDEX Table1_AccountID_idx ON Table1 (AccountID);
CREATE INDEX Table1_ID_idx ON Table1 (ID);

CREATE TABLE tblAbsenceDay
 (
	ID			INTEGER, 
	AccountID			INTEGER NOT NULL, 
	AbsenceDate			DateTime, 
	AbsenceType			INTEGER, 
	AbsenceDays			INTEGER, 
	AbsenceHours			REAL, 
	AbsenceNote			varchar, 
	AbsenceDeduct			INTEGER, 
	HospitalNo			INTEGER, 
	SickenStatusNo			INTEGER, 
	MedicamentCost			INTEGER, 
	SendingNo			INTEGER, 
	SupposedReturnDate			DateTime, 
	ActuallyReturnDate			DateTime, 
	DocumentImagePath			TEXT
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblAbsenceDay_AbsenceDate_idx ON tblAbsenceDay (AbsenceDate);
CREATE UNIQUE INDEX tblAbsenceDay_AbsenceNo_idx ON tblAbsenceDay (ID);
CREATE INDEX tblAbsenceDay_AbsenceType_idx ON tblAbsenceDay (AbsenceType);
CREATE INDEX tblAbsenceDay_EmployeeNo_idx ON tblAbsenceDay (AccountID);
CREATE UNIQUE INDEX tblAbsenceDay_SendingNo_idx ON tblAbsenceDay (SendingNo);
CREATE INDEX tblAbsenceDay_tblAbsenceDaysHospitalNo_idx ON tblAbsenceDay (HospitalNo);

CREATE TABLE tblAbsenceProcedureRule
 (
	ID			INTEGER, 
	WeeklyLessonsNo			INTEGER, 
	AbsencePercentage			REAL, 
	AbsenceLessonsNo			INTEGER, 
	AttendanceCaseID			INTEGER, 
	ProcedureTypeID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblAbsenceProcedureRule_AttendanceCaseID_idx ON tblAbsenceProcedureRule (AttendanceCaseID);
CREATE INDEX tblAbsenceProcedureRule_ID_idx ON tblAbsenceProcedureRule (ID);
CREATE INDEX tblAbsenceProcedureRule_ProcedureTypeID_idx ON tblAbsenceProcedureRule (ProcedureTypeID);

CREATE TABLE tblAbsenceType
 (
	ID			INTEGER, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar NOT NULL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tblAccountAccountType
 (
	AccountID			INTEGER NOT NULL, 
	AccountTypeID			INTEGER NOT NULL
	, PRIMARY KEY (AccountID, AccountTypeID)
);

-- CREATE INDEXES ...
CREATE INDEX tblAccountAccountType_AccountID_idx ON tblAccountAccountType (AccountID);
CREATE INDEX tblAccountAccountType_AccountTypeID_idx ON tblAccountAccountType (AccountTypeID);

CREATE TABLE tblAccountChildren
 (
	ID			INTEGER, 
	AccountID			INTEGER, 
	CardID			varchar, 
	ChildrenName			varchar, 
	GenderID			INTEGER, 
	EducationLevelID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblAccountChildren_AccountID_idx ON tblAccountChildren (AccountID);
CREATE INDEX tblAccountChildren_CardID_idx ON tblAccountChildren (CardID);
CREATE INDEX tblAccountChildren_EducationLevelID_idx ON tblAccountChildren (EducationLevelID);
CREATE INDEX tblAccountChildren_GenderID_idx ON tblAccountChildren (GenderID);
CREATE INDEX tblAccountChildren_ID_idx ON tblAccountChildren (ID);

CREATE TABLE tblAccountChildrenHealthStatus
 (
	AccountChildrenID			INTEGER, 
	DiseaseID			INTEGER, 
	OtherDiseaseName			varchar, 
	StartDate			DateTime
	, PRIMARY KEY (AccountChildrenID, DiseaseID)
);

-- CREATE INDEXES ...
CREATE INDEX tblAccountChildrenHealthStatus_AccountID_idx ON tblAccountChildrenHealthStatus (AccountChildrenID);
CREATE INDEX tblAccountChildrenHealthStatus_ExperienceTypeID_idx ON tblAccountChildrenHealthStatus (DiseaseID);

CREATE TABLE tblAccountContact
 (
	AccountID			INTEGER NOT NULL, 
	ContactTypeID			INTEGER NOT NULL, 
	ContactID			varchar NOT NULL, 
	ContactNote			varchar, 
	ToSend			INTEGER NOT NULL
	, PRIMARY KEY (AccountID, ContactTypeID)
);

-- CREATE INDEXES ...
CREATE INDEX tblAccountContact_AccountID_idx ON tblAccountContact (AccountID);
CREATE INDEX tblAccountContact_ContactID_idx ON tblAccountContact (ContactID);
CREATE INDEX tblAccountContact_DocumentTypeNo_idx ON tblAccountContact (ContactTypeID);

CREATE TABLE tblAccountCulturalSide
 (
	ID			INTEGER, 
	AccountID			INTEGER, 
	CulturalName			varchar, 
	CulturalDate			DateTime, 
	CulturalSideTypeID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblAccountCulturalSide_AccountID_idx ON tblAccountCulturalSide (AccountID);
CREATE INDEX tblAccountCulturalSide_CulturalSideTypeID_idx ON tblAccountCulturalSide (CulturalSideTypeID);
CREATE INDEX tblAccountCulturalSide_ID_idx ON tblAccountCulturalSide (ID);

CREATE TABLE tblAccountDocument
 (
	ID			INTEGER, 
	AccountID			INTEGER NOT NULL, 
	DocumentTypeID			INTEGER NOT NULL, 
	DocumentID			varchar, 
	DocumentDate			DateTime, 
	DocumentExpDate			DateTime, 
	DocumentSource			varchar, 
	DocumentNote			varchar, 
	DocumentImagePath			TEXT, 
	OtherDocumentTypeName			varchar, 
	UseInReporting			INTEGER NOT NULL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblAccountDocument_DocumentID_idx ON tblAccountDocument (DocumentID);
CREATE INDEX tblAccountDocument_DocumentTypeNo_idx ON tblAccountDocument (DocumentTypeID);
CREATE INDEX tblAccountDocument_EmployeeNo_idx ON tblAccountDocument (AccountID);
CREATE INDEX tblAccountDocument_ID_idx ON tblAccountDocument (ID);

CREATE TABLE tblAccountExperience
 (
	AccountID			INTEGER, 
	ExperienceTypeID			INTEGER, 
	OtherExperienceTypeName			varchar, 
	StartDate			DateTime
	, PRIMARY KEY (AccountID, ExperienceTypeID)
);

-- CREATE INDEXES ...
CREATE INDEX tblAccountExperience_AccountID_idx ON tblAccountExperience (AccountID);
CREATE INDEX tblAccountExperience_ExperienceTypeID_idx ON tblAccountExperience (ExperienceTypeID);

CREATE TABLE tblAccountHealthStatus
 (
	AccountID			INTEGER, 
	DiseaseID			INTEGER, 
	OtherDiseaseName			varchar, 
	StartDate			DateTime
	, PRIMARY KEY (AccountID, DiseaseID)
);

-- CREATE INDEXES ...
CREATE INDEX tblAccountHealthStatus_AccountID_idx ON tblAccountHealthStatus (AccountID);
CREATE INDEX tblAccountHealthStatus_ExperienceTypeID_idx ON tblAccountHealthStatus (DiseaseID);

CREATE TABLE tblAccountItemUseType
 (
	AccountID			INTEGER, 
	UseTypeID			INTEGER, 
	IsUsed			INTEGER NOT NULL
	, PRIMARY KEY (UseTypeID, AccountID)
);

-- CREATE INDEXES ...
CREATE INDEX tblAccountItemUseType_AccountID_idx ON tblAccountItemUseType (AccountID);
CREATE INDEX tblAccountItemUseType_UseTypeID_idx ON tblAccountItemUseType (UseTypeID);

CREATE TABLE tblAccountNote
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	ColorID			INTEGER, 
	ColorCode			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblAccountNote_ColorCode_idx ON tblAccountNote (ColorCode);
CREATE INDEX tblAccountNote_ColorID_idx ON tblAccountNote (ColorID);
CREATE INDEX tblAccountNote_FormID_idx ON tblAccountNote (ID);
CREATE UNIQUE INDEX tblAccountNote_NameAr_idx ON tblAccountNote (NameAr);
CREATE UNIQUE INDEX tblAccountNote_NameEn_idx ON tblAccountNote (NameEn);

CREATE TABLE tblAccountOldBalance
 (
	AccountID			INTEGER NOT NULL, 
	MoneyTransactionID			varchar NOT NULL
	, PRIMARY KEY (AccountID, MoneyTransactionID)
);

-- CREATE INDEXES ...
CREATE INDEX tblAccountOldBalance_ID_idx ON tblAccountOldBalance (AccountID);
CREATE INDEX tblAccountOldBalance_MoneyTransactionID_idx ON tblAccountOldBalance (MoneyTransactionID);

CREATE TABLE tblAccountPricingGroup
 (
	AccountID			INTEGER NOT NULL, 
	PricingGroupID			INTEGER NOT NULL, 
	AllowDebit			INTEGER NOT NULL, 
	MaximumDebitBalance			REAL NOT NULL, 
	Remark			TEXT
	, PRIMARY KEY (AccountID)
);

-- CREATE INDEXES ...
CREATE INDEX tblAccountPricingGroup_AccountID_idx ON tblAccountPricingGroup (AccountID);
CREATE INDEX tblAccountPricingGroup_PricingGroupID_idx ON tblAccountPricingGroup (PricingGroupID);

CREATE TABLE tblAccountRole
 (
	ID			INTEGER, 
	name			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tblAccountSide
 (
	ID			INTEGER, 
	NameAr			varchar, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tblAccountStatus
 (
	ID			INTEGER, 
	NameAr			varchar, 
	NameEn			varchar, 
	Operation			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblAccountStatus_FormID_idx ON tblAccountStatus (ID);

CREATE TABLE tblAccountSupport
 (
	AccountID			INTEGER
	, PRIMARY KEY (AccountID)
);

-- CREATE INDEXES ...

CREATE TABLE tblAccountSupport1
 (
	AccountID			INTEGER
	, PRIMARY KEY (AccountID)
);

-- CREATE INDEXES ...

CREATE TABLE tblAccountSupport2
 (
	AccountID			INTEGER
	, PRIMARY KEY (AccountID)
);

-- CREATE INDEXES ...

CREATE TABLE tblAccountSupport3
 (
	AccountID			INTEGER
	, PRIMARY KEY (AccountID)
);

-- CREATE INDEXES ...

CREATE TABLE tblAccountType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	StartID			INTEGER, 
	EndID			INTEGER, 
	PersonAccount			INTEGER NOT NULL, 
	NotUsed			INTEGER NOT NULL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE UNIQUE INDEX tblAccountType_EndID_idx ON tblAccountType (EndID);
CREATE INDEX tblAccountType_FormID_idx ON tblAccountType (ID);
CREATE UNIQUE INDEX tblAccountType_NameAr_idx ON tblAccountType (NameAr);
CREATE UNIQUE INDEX tblAccountType_NameEn_idx ON tblAccountType (NameEn);
CREATE INDEX tblAccountType_StartID_idx ON tblAccountType (StartID);

CREATE TABLE tblApprovedCourse
 (
	ID			INTEGER, 
	StudentTypeID			INTEGER, 
	StudyTypeID			INTEGER, 
	StudyLevelID			INTEGER, 
	StudyYearID			INTEGER, 
	TermID			INTEGER, 
	TeacherAccountID			INTEGER, 
	CourseID			INTEGER, 
	StudyBookID			INTEGER, 
	SubjectStartName			varchar, 
	SubjectStartPageNo			varchar, 
	SubjectEndName			varchar, 
	SubjectEndPageNo			varchar, 
	Notes			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblApprovedCourse_AccountID_idx ON tblApprovedCourse (TeacherAccountID);
CREATE INDEX tblApprovedCourse_CourseID_idx ON tblApprovedCourse (CourseID);
CREATE INDEX tblApprovedCourse_ID_idx ON tblApprovedCourse (ID);
CREATE INDEX tblApprovedCourse_SemesterID_idx ON tblApprovedCourse (TermID);
CREATE INDEX tblApprovedCourse_StudentTypeID_idx ON tblApprovedCourse (StudentTypeID);
CREATE INDEX tblApprovedCourse_StudyBookID_idx ON tblApprovedCourse (StudyBookID);
CREATE INDEX tblApprovedCourse_StudyLevelID_idx ON tblApprovedCourse (StudyLevelID);
CREATE INDEX tblApprovedCourse_StudyPeriodID_idx ON tblApprovedCourse (StudyTypeID);
CREATE INDEX tblApprovedCourse_StudyYearID_idx ON tblApprovedCourse (StudyYearID);

CREATE TABLE tblAssayRequest
 (
	ID			INTEGER, 
	RequestDate			DateTime, 
	CustomerAccountID			INTEGER, 
	IsClosed			INTEGER NOT NULL, 
	PCID			INTEGER NOT NULL, 
	UserID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblAssayRequest_CustomerAccountID_idx ON tblAssayRequest (CustomerAccountID);
CREATE INDEX tblAssayRequest_ID_idx ON tblAssayRequest (ID);
CREATE INDEX tblAssayRequest_PCID_idx ON tblAssayRequest (PCID);
CREATE INDEX tblAssayRequest_UserID_idx ON tblAssayRequest (UserID);

CREATE TABLE tblAssayRequestInvoice
 (
	AssayRequestID			INTEGER, 
	InvoiceID			varchar
	, PRIMARY KEY (AssayRequestID, InvoiceID)
);

-- CREATE INDEXES ...
CREATE INDEX tblAssayRequestInvoice_ID_idx ON tblAssayRequestInvoice (AssayRequestID);
CREATE INDEX tblAssayRequestInvoice_InvoiceID_idx ON tblAssayRequestInvoice (InvoiceID);

CREATE TABLE tblAssayRequestProcedure
 (
	ID			INTEGER, 
	AssayRequestID			INTEGER, 
	ProcedureDate			DateTime, 
	StartTime			DateTime, 
	EndTime			DateTime, 
	SendToDelegateAccountID			INTEGER, 
	AssayStatusID			INTEGER, 
	ProcedureNote			TEXT, 
	PCID			INTEGER NOT NULL, 
	UserID			INTEGER, 
	ExecutedByDelegateAccountID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblAssayRequestProcedure_AssayRequestID_idx ON tblAssayRequestProcedure (AssayRequestID);
CREATE INDEX tblAssayRequestProcedure_AssayStatusID_idx ON tblAssayRequestProcedure (AssayStatusID);
CREATE INDEX tblAssayRequestProcedure_delegateAccountID_idx ON tblAssayRequestProcedure (SendToDelegateAccountID);
CREATE INDEX tblAssayRequestProcedure_ID_idx ON tblAssayRequestProcedure (ID);
CREATE INDEX tblAssayRequestProcedure_PCID_idx ON tblAssayRequestProcedure (PCID);
CREATE INDEX tblAssayRequestProcedure_ToDelegateAccountID_idx ON tblAssayRequestProcedure (ExecutedByDelegateAccountID);
CREATE INDEX tblAssayRequestProcedure_UserID_idx ON tblAssayRequestProcedure (UserID);

CREATE TABLE tblAttendanceCase
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblAttendanceCase_FormID_idx ON tblAttendanceCase (ID);
CREATE UNIQUE INDEX tblAttendanceCase_NameAr_idx ON tblAttendanceCase (NameAr);
CREATE UNIQUE INDEX tblAttendanceCase_NameEn_idx ON tblAttendanceCase (NameEn);

CREATE TABLE tblAuthority
 (
	UserGroupID			INTEGER NOT NULL, 
	ObjectID			INTEGER NOT NULL, 
	AllowShow			INTEGER NOT NULL, 
	AllowAddition			INTEGER NOT NULL, 
	AllowEdition			INTEGER NOT NULL, 
	AllowDeletion			INTEGER NOT NULL, 
	AllowPrint			INTEGER NOT NULL
	, PRIMARY KEY (UserGroupID, ObjectID)
);

-- CREATE INDEXES ...
CREATE INDEX tblAuthority_ID_idx ON tblAuthority (UserGroupID);
CREATE INDEX tblAuthority_ObjectID_idx ON tblAuthority (ObjectID);

CREATE TABLE tblAuthorityReportType
 (
	ID			INTEGER, 
	UserGroupID			INTEGER NOT NULL, 
	ObjectID			INTEGER NOT NULL, 
	ReportTypeID			INTEGER, 
	ToPrintDirect			INTEGER NOT NULL, 
	OpenCashDrawer			INTEGER NOT NULL, 
	IsUsed			INTEGER NOT NULL, 
	printerName			varchar, 
	pageSize			varchar, 
	NumberOfCopies			INTEGER, 
	PageMarginLeft			INTEGER, 
	PageMarginRight			INTEGER, 
	PageMarginTop			INTEGER, 
	PageMarginBottom			INTEGER, 
	Landscape			INTEGER NOT NULL, 
	PaperSize			varchar, 
	PaperWidth			INTEGER, 
	PaperHeight			INTEGER, 
	IsCustomPaperSize			INTEGER NOT NULL, 
	PaperSource			varchar, 
	IsFilltered			INTEGER NOT NULL, 
	PCID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblAuthorityReportType_PCID_idx ON tblAuthorityReportType (PCID);

CREATE TABLE tblAuthorizer
 (
	ID			INTEGER, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar NOT NULL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tblBackUp
 (
	BackUpDate			DateTime, 
	BackUpPath			varchar
);

-- CREATE INDEXES ...

CREATE TABLE tblBackUpHistory
 (
	BackUpDate			DateTime, 
	BackUpPath			varchar, 
	PCID			INTEGER, 
	version			varchar
	, PRIMARY KEY (PCID, BackUpPath)
);

-- CREATE INDEXES ...
CREATE INDEX tblBackUpHistory_PCID_idx ON tblBackUpHistory (PCID);

CREATE TABLE tblBalanceSheetGroup
 (
	ID			INTEGER, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar NOT NULL, 
	PerntID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tblBasicDataTables
 (
	ID			INTEGER, 
	TableName			varchar, 
	FormTitleAr			varchar, 
	FormTitleEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblBasicDataTables_ID_idx ON tblBasicDataTables (ID);

CREATE TABLE tblBillCopy
 (
	BillCopyID			INTEGER, 
	CopyNameAr			varchar, 
	CopyNameEn			varchar, 
	BillCopyGroupID			INTEGER
	, PRIMARY KEY (BillCopyID)
);

-- CREATE INDEXES ...
CREATE INDEX tblBillCopy_GroupID_idx ON tblBillCopy (BillCopyGroupID);
CREATE INDEX tblBillCopy_ID_idx ON tblBillCopy (BillCopyID);

CREATE TABLE tblBillCopyGroup
 (
	ID			INTEGER, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar NOT NULL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tblBranch
 (
	ID			INTEGER, 
	NameAr			varchar, 
	NameEn			varchar, 
	Phone			varchar, 
	Fax			varchar, 
	Mobile			varchar, 
	OwnerName			varchar, 
	Address			varchar, 
	POBox			varchar, 
	PO_Code			varchar, 
	Email			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblBranch_FormID_idx ON tblBranch (ID);
CREATE INDEX tblBranch_PO_Code_idx ON tblBranch (PO_Code);

CREATE TABLE tblBuildingType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblBuildingType_FormID_idx ON tblBuildingType (ID);
CREATE UNIQUE INDEX tblBuildingType_NameAr_idx ON tblBuildingType (NameAr);
CREATE UNIQUE INDEX tblBuildingType_NameEn_idx ON tblBuildingType (NameEn);

CREATE TABLE tblCalendarType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblCalendarType_FormID_idx ON tblCalendarType (ID);
CREATE UNIQUE INDEX tblCalendarType_NameAr_idx ON tblCalendarType (NameAr);
CREATE UNIQUE INDEX tblCalendarType_NameEn_idx ON tblCalendarType (NameEn);

CREATE TABLE tblCardClass
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	Price			REAL, 
	FreePalance			REAL, 
	IsUsed			INTEGER NOT NULL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblCardClass_FormID_idx ON tblCardClass (ID);
CREATE UNIQUE INDEX tblCardClass_NameAr_idx ON tblCardClass (NameAr);
CREATE UNIQUE INDEX tblCardClass_NameEn_idx ON tblCardClass (NameEn);

CREATE TABLE tblCarType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblCarType_FormID_idx ON tblCarType (ID);
CREATE UNIQUE INDEX tblCarType_NameAr_idx ON tblCarType (NameAr);
CREATE UNIQUE INDEX tblCarType_NameEn_idx ON tblCarType (NameEn);

CREATE TABLE tblCategory
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE UNIQUE INDEX tblCategory_ID_idx ON tblCategory (ID);
CREATE UNIQUE INDEX tblCategory_NameAr_idx ON tblCategory (NameAr);
CREATE UNIQUE INDEX tblCategory_NameEn_idx ON tblCategory (NameEn);

CREATE TABLE tblCity
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblCity_FormID_idx ON tblCity (ID);
CREATE UNIQUE INDEX tblCity_NameAr_idx ON tblCity (NameAr);
CREATE UNIQUE INDEX tblCity_NameEn_idx ON tblCity (NameEn);

CREATE TABLE tblClassDistributionTable
 (
	ID			INTEGER, 
	ApprovedCourseID			INTEGER, 
	TermID			INTEGER, 
	WeekDayID			INTEGER, 
	StudyClassID			INTEGER, 
	ClassRoomID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblClassDistributionTable_ClassID_idx ON tblClassDistributionTable (StudyClassID);
CREATE INDEX tblClassDistributionTable_ClassRoomID_idx ON tblClassDistributionTable (ClassRoomID);
CREATE INDEX tblClassDistributionTable_CourseID_idx ON tblClassDistributionTable (ApprovedCourseID);
CREATE UNIQUE INDEX tblClassDistributionTable_ID_idx ON tblClassDistributionTable (ID);
CREATE INDEX tblClassDistributionTable_TermID_idx ON tblClassDistributionTable (TermID);
CREATE INDEX tblClassDistributionTable_WeekDayID_idx ON tblClassDistributionTable (WeekDayID);

CREATE TABLE tblClient
 (
	ID			INTEGER, 
	Name			varchar, 
	Mobile			varchar, 
	WhatsApp			varchar, 
	Email			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tblCode
 (
	ID			INTEGER NOT NULL, 
	Code			varchar NOT NULL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblCode_FormID_idx ON tblCode (ID);
CREATE UNIQUE INDEX tblCode_NameAr_idx ON tblCode (Code);

CREATE TABLE tblCoding
 (
	ID			INTEGER NOT NULL, 
	CodingGroupID			INTEGER NOT NULL, 
	SortID			INTEGER, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	SubOfCodeingID			INTEGER, 
	ShortNameAr			varchar, 
	ShortNameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblCoding_MainID_idx ON tblCoding (SubOfCodeingID);
CREATE INDEX tblCoding_NameAr_idx ON tblCoding (NameAr);
CREATE INDEX tblCoding_NameEn_idx ON tblCoding (NameEn);
CREATE UNIQUE INDEX tblCoding_SortID_idx ON tblCoding (SortID, CodingGroupID);

CREATE TABLE tblCodingGroup
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblCodingGroup_FormID_idx ON tblCodingGroup (ID);
CREATE UNIQUE INDEX tblCodingGroup_NameAr_idx ON tblCodingGroup (NameAr);
CREATE UNIQUE INDEX tblCodingGroup_NameEn_idx ON tblCodingGroup (NameEn);

CREATE TABLE tblCodingGroupSubCodingGroup
 (
	MainCodingGroupID			INTEGER, 
	SubCodingGroupID			INTEGER
	, PRIMARY KEY (MainCodingGroupID, SubCodingGroupID)
);

-- CREATE INDEXES ...
CREATE INDEX tblCodingGroupSubCodingGroup_SubCodingGroupID_idx ON tblCodingGroupSubCodingGroup (SubCodingGroupID);
CREATE INDEX tblCodingGroupSubCodingGroup_SubCodingGroupID1_idx ON tblCodingGroupSubCodingGroup (MainCodingGroupID);

CREATE TABLE tblCodingSupport
 (
	ID			INTEGER NOT NULL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tblCompanyDocument
 (
	ID			INTEGER NOT NULL, 
	DocumentTypeID			INTEGER NOT NULL, 
	DocumentID			varchar NOT NULL, 
	DocumentDate			DateTime, 
	DocumentExpDate			DateTime, 
	DocumentSource			varchar, 
	DocumentNote			varchar, 
	DocumentImagePath			TEXT, 
	OtherDocumentTypeName			varchar, 
	UseInReporting			INTEGER NOT NULL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblCompanyDocument_DocumentID_idx ON tblCompanyDocument (DocumentID);
CREATE INDEX tblCompanyDocument_DocumentTypeNo_idx ON tblCompanyDocument (DocumentTypeID);
CREATE INDEX tblCompanyDocument_EmployeeNo_idx ON tblCompanyDocument (ID);

CREATE TABLE tblConditionClass
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	ConditionAr			TEXT NOT NULL, 
	ConditionEn			TEXT
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblConditionClass_FormID_idx ON tblConditionClass (ID);
CREATE UNIQUE INDEX tblConditionClass_NameAr_idx ON tblConditionClass (ConditionAr);
CREATE UNIQUE INDEX tblConditionClass_NameAr1_idx ON tblConditionClass (NameAr);
CREATE UNIQUE INDEX tblConditionClass_NameEn_idx ON tblConditionClass (ConditionEn);
CREATE UNIQUE INDEX tblConditionClass_NameEn1_idx ON tblConditionClass (NameEn);

CREATE TABLE tblConfirmationType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblConfirmationType_FormID_idx ON tblConfirmationType (ID);
CREATE UNIQUE INDEX tblConfirmationType_NameAr_idx ON tblConfirmationType (NameAr);
CREATE UNIQUE INDEX tblConfirmationType_NameEn_idx ON tblConfirmationType (NameEn);

CREATE TABLE tblContactType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblContactType_DocumentTypeID_idx ON tblContactType (ID);
CREATE UNIQUE INDEX tblContactType_NameAr_idx ON tblContactType (NameAr);
CREATE UNIQUE INDEX tblContactType_NameEn_idx ON tblContactType (NameEn);

CREATE TABLE tblContract
 (
	ID			INTEGER, 
	CustomerID			INTEGER, 
	ContractNameAr			varchar, 
	ContractNameEn			varchar, 
	ContractDate			DateTime, 
	ContractAmount			INTEGER, 
	Note			TEXT, 
	Condition			TEXT, 
	VATValue			REAL, 
	VatTypeID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblContract_CustomerID_idx ON tblContract (CustomerID);
CREATE INDEX tblContract_ID_idx ON tblContract (ID);

CREATE TABLE tblContractInstalllmentMoneyTransaction
 (
	ContractInstalllmentID			INTEGER, 
	MoneyTransactionID			varchar NOT NULL, 
	DueDate			DateTime
	, PRIMARY KEY (ContractInstalllmentID, MoneyTransactionID)
);

-- CREATE INDEXES ...
CREATE INDEX tblContractInstalllmentMoneyTransaction_MoneyTransactionID_idx ON tblContractInstalllmentMoneyTransaction (MoneyTransactionID);
CREATE INDEX tblContractInstalllmentMoneyTransaction_tblContractInstalllmentID_idx ON tblContractInstalllmentMoneyTransaction (ContractInstalllmentID);

CREATE TABLE tblContractInvoice
 (
	ContractID			INTEGER, 
	InvoiceID			varchar NOT NULL
	, PRIMARY KEY (ContractID, InvoiceID)
);

-- CREATE INDEXES ...
CREATE INDEX tblContractInvoice_ContractID_idx ON tblContractInvoice (ContractID);
CREATE UNIQUE INDEX tblContractInvoice_InvoiceID_idx ON tblContractInvoice (InvoiceID);

CREATE TABLE tblContractReceipt
 (
	ContractID			INTEGER, 
	ReceiptID			varchar NOT NULL
	, PRIMARY KEY (ContractID, ReceiptID)
);

-- CREATE INDEXES ...
CREATE INDEX tblContractReceipt_ContractID_idx ON tblContractReceipt (ContractID);
CREATE INDEX tblContractReceipt_ReceiptID_idx ON tblContractReceipt (ReceiptID);

CREATE TABLE tblCopyFolder
 (
	ID			INTEGER, 
	FolderPath			varchar, 
	PCID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblCopyFolder_PCID_idx ON tblCopyFolder (PCID);

CREATE TABLE tblCountry
 (
	Alpha2Code			varchar NOT NULL, 
	Alpha3Code			varchar, 
	PhoneCode			varchar, 
	NameAr			varchar, 
	NameEn			varchar
	, PRIMARY KEY (Alpha2Code)
);

-- CREATE INDEXES ...

CREATE TABLE tblCourse
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	WeeklyLessonsNo			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblCourse_FormID_idx ON tblCourse (ID);
CREATE UNIQUE INDEX tblCourse_NameAr_idx ON tblCourse (NameAr);
CREATE UNIQUE INDEX tblCourse_NameEn_idx ON tblCourse (NameEn);

CREATE TABLE tblCulturalSideType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblCulturalSideType_FormID_idx ON tblCulturalSideType (ID);
CREATE UNIQUE INDEX tblCulturalSideType_NameAr_idx ON tblCulturalSideType (NameAr);
CREATE UNIQUE INDEX tblCulturalSideType_NameEn_idx ON tblCulturalSideType (NameEn);

CREATE TABLE tblCurrencyBill
 (
	ID			REAL, 
	CurrencyID			REAL, 
	Value			REAL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tblCustomerNoteOnCompany
 (
	ID			INTEGER, 
	NoteDate			DateTime, 
	NoteTime			DateTime, 
	CustomerAccountID			INTEGER, 
	CustomerNoteTypeOnCompanyID			INTEGER, 
	NoteDetail			TEXT, 
	PCID			INTEGER NOT NULL, 
	UserID			INTEGER, 
	InvoiceID			varchar, 
	ItemID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblCustomerNoteOnCompany_AssayProcedureTypeID_idx ON tblCustomerNoteOnCompany (CustomerNoteTypeOnCompanyID);
CREATE INDEX tblCustomerNoteOnCompany_delegateAccountID_idx ON tblCustomerNoteOnCompany (CustomerAccountID);
CREATE INDEX tblCustomerNoteOnCompany_InvoiceID_idx ON tblCustomerNoteOnCompany (InvoiceID);
CREATE INDEX tblCustomerNoteOnCompany_ItemID_idx ON tblCustomerNoteOnCompany (ItemID);
CREATE INDEX tblCustomerNoteOnCompany_PCID_idx ON tblCustomerNoteOnCompany (PCID);
CREATE INDEX tblCustomerNoteOnCompany_UserID_idx ON tblCustomerNoteOnCompany (UserID);

CREATE TABLE tblCustomerSourceData
 (
	CustomerID			INTEGER, 
	SourceID			INTEGER, 
	SourceEmployeeID			INTEGER, 
	CityID			INTEGER, 
	RegistrationDate			DateTime
	, PRIMARY KEY (CustomerID)
);

-- CREATE INDEXES ...
CREATE INDEX tblCustomerSourceData_AccountID_idx ON tblCustomerSourceData (CustomerID);
CREATE INDEX tblCustomerSourceData_CityID_idx ON tblCustomerSourceData (CityID);
CREATE INDEX tblCustomerSourceData_SourceEmployeeID_idx ON tblCustomerSourceData (SourceEmployeeID);
CREATE INDEX tblCustomerSourceData_SourceID_idx ON tblCustomerSourceData (SourceID);

CREATE TABLE tblDailySchedule
 (
	ID			INTEGER, 
	BranchID			INTEGER NOT NULL, 
	UserID			INTEGER NOT NULL, 
	ScheduleDate			DateTime, 
	ScheduleTime			DateTime, 
	Subject			varchar, 
	Location			varchar, 
	Remark			TEXT, 
	ExecutionStatusID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblDailySchedule_BranchID_idx ON tblDailySchedule (BranchID);
CREATE INDEX tblDailySchedule_ExecutionStatusID_idx ON tblDailySchedule (ExecutionStatusID);
CREATE INDEX tblDailySchedule_ID_idx ON tblDailySchedule (ID);
CREATE INDEX tblDailySchedule_UserID_idx ON tblDailySchedule (UserID);

CREATE TABLE tblDay
 (
	DayID			INTEGER
	, PRIMARY KEY (DayID)
);

-- CREATE INDEXES ...
CREATE INDEX tblDay_DayID_idx ON tblDay (DayID);

CREATE TABLE tblDisease
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblDisease_FormID_idx ON tblDisease (ID);
CREATE UNIQUE INDEX tblDisease_NameAr_idx ON tblDisease (NameAr);
CREATE UNIQUE INDEX tblDisease_NameEn_idx ON tblDisease (NameEn);

CREATE TABLE tblDividendOperation
 (
	ID			INTEGER, 
	DividendDate			DateTime, 
	Note			TEXT, 
	MoneyTransactionID			varchar NOT NULL, 
	CurrentNetProfitAndloss			REAL, 
	InvestorsBeforeDividendTotalBalance			REAL, 
	ManagementRate			REAL, 
	InvestorsRate			REAL, 
	AmanFundRate			REAL, 
	ManagementRateAmount			REAL, 
	InvestorsRateAmount			REAL, 
	AmanFundRateAmount			REAL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblDividendOperation_ID_idx ON tblDividendOperation (ID);
CREATE UNIQUE INDEX tblDividendOperation_MoneyTransactionID_idx ON tblDividendOperation (MoneyTransactionID);

CREATE TABLE tblDividendOperationInvestors
 (
	DividendOperationID			INTEGER, 
	InvestorID			INTEGER, 
	InvestorBeforeDividendBalance			REAL, 
	InvestorBeforeDividendBalancePercentage			REAL, 
	DividendAmount			REAL, 
	Remark			varchar
	, PRIMARY KEY (DividendOperationID, InvestorID)
);

-- CREATE INDEXES ...
CREATE INDEX tblDividendOperationInvestors_DividendOperationID_idx ON tblDividendOperationInvestors (DividendOperationID);
CREATE INDEX tblDividendOperationInvestors_ID_idx ON tblDividendOperationInvestors (InvestorID);

CREATE TABLE tblDividendOperationMenagment
 (
	DividendOperationID			INTEGER, 
	AccountID			INTEGER, 
	JobID			INTEGER, 
	DividendAmount			REAL
	, PRIMARY KEY (DividendOperationID, AccountID)
);

-- CREATE INDEXES ...
CREATE INDEX tblDividendOperationMenagment_DividendOperationID_idx ON tblDividendOperationMenagment (DividendOperationID);
CREATE INDEX tblDividendOperationMenagment_ID_idx ON tblDividendOperationMenagment (AccountID);

CREATE TABLE tblDividendRatios
 (
	ManagementRate			REAL, 
	InvestorsRate			REAL, 
	AmanFundRate			REAL
);

-- CREATE INDEXES ...

CREATE TABLE tblDocumentType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	Code			varchar, 
	UseLevel			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblDocumentType_DocumentTypeID_idx ON tblDocumentType (ID);
CREATE UNIQUE INDEX tblDocumentType_NameAr_idx ON tblDocumentType (NameAr);
CREATE UNIQUE INDEX tblDocumentType_NameEn_idx ON tblDocumentType (NameEn);

CREATE TABLE tblEducationMajor
 (
	ID			INTEGER, 
	NameAr			varchar, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tblEmployeeAttendance
 (
	ID			INTEGER, 
	AccountID			INTEGER, 
	WorkPeriodID			INTEGER, 
	CheckInTime			DateTime, 
	TimeOut			DateTime, 
	Notes			varchar, 
	PCID			INTEGER, 
	InputMeansID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblEmployeeAttendance_AccountID_idx ON tblEmployeeAttendance (AccountID);
CREATE INDEX tblEmployeeAttendance_ID_idx ON tblEmployeeAttendance (ID);
CREATE INDEX tblEmployeeAttendance_InputMeansID_idx ON tblEmployeeAttendance (InputMeansID);
CREATE INDEX tblEmployeeAttendance_PCID_idx ON tblEmployeeAttendance (PCID);
CREATE INDEX tblEmployeeAttendance_WorkPeriodID_idx ON tblEmployeeAttendance (WorkPeriodID);

CREATE TABLE tblEmployeeContact
 (
	BranchID			INTEGER NOT NULL, 
	EmployeeID			INTEGER NOT NULL, 
	ContactTypeID			INTEGER NOT NULL, 
	ContactID			varchar, 
	ContactNote			varchar
	, PRIMARY KEY (BranchID, EmployeeID, ContactTypeID)
);

-- CREATE INDEXES ...
CREATE INDEX tblEmployeeContact_BranchID_idx ON tblEmployeeContact (BranchID);
CREATE INDEX tblEmployeeContact_DocumentID_idx ON tblEmployeeContact (ContactID);
CREATE INDEX tblEmployeeContact_DocumentTypeNo_idx ON tblEmployeeContact (ContactTypeID);
CREATE INDEX tblEmployeeContact_TenantID_idx ON tblEmployeeContact (EmployeeID);

CREATE TABLE tblEmployeeDocument
 (
	BranchID			INTEGER NOT NULL, 
	EmployeeID			INTEGER NOT NULL, 
	DocumentTypeNo			INTEGER NOT NULL, 
	DocumentID			varchar, 
	DocumentDate			DateTime, 
	DocumentExpDate			DateTime, 
	DocumentSource			varchar, 
	DocumentNote			varchar, 
	DocumentImagePath			TEXT
	, PRIMARY KEY (BranchID, EmployeeID, DocumentTypeNo)
);

-- CREATE INDEXES ...
CREATE INDEX tblEmployeeDocument_BranchID_idx ON tblEmployeeDocument (BranchID);
CREATE INDEX tblEmployeeDocument_DocumentID_idx ON tblEmployeeDocument (DocumentID);
CREATE INDEX tblEmployeeDocument_DocumentTypeNo_idx ON tblEmployeeDocument (DocumentTypeNo);
CREATE INDEX tblEmployeeDocument_EmployeeNo_idx ON tblEmployeeDocument (EmployeeID);

CREATE TABLE tblEmployeeType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblEmployeeType_FormID_idx ON tblEmployeeType (ID);
CREATE UNIQUE INDEX tblEmployeeType_NameAr_idx ON tblEmployeeType (NameAr);
CREATE UNIQUE INDEX tblEmployeeType_NameEn_idx ON tblEmployeeType (NameEn);

CREATE TABLE tblExamControl
 (
	ExamDistributionTableID			INTEGER, 
	WatcherAccountID			INTEGER, 
	PaperCount			INTEGER, 
	CorrectionFinishDate			varchar, 
	SubjectStartName			varchar, 
	SubjectEndName			varchar, 
	MarkEntered			INTEGER NOT NULL, 
	Revision			INTEGER NOT NULL
	, PRIMARY KEY (ExamDistributionTableID)
);

-- CREATE INDEXES ...
CREATE INDEX tblExamControl_ExamDistributionTableID_idx ON tblExamControl (ExamDistributionTableID);
CREATE INDEX tblExamControl_WatcherAccountID_idx ON tblExamControl (WatcherAccountID);

CREATE TABLE tblExamDistributionTable
 (
	ID			INTEGER, 
	ApprovedCourseID			INTEGER, 
	TermID			INTEGER, 
	ExamTypeID			INTEGER, 
	WeekDayID			INTEGER, 
	WeekID			INTEGER, 
	ExamPeriodID			INTEGER, 
	ClassRoomID			INTEGER
);

-- CREATE INDEXES ...
CREATE INDEX tblExamDistributionTable_ClassID_idx ON tblExamDistributionTable (ExamPeriodID);
CREATE INDEX tblExamDistributionTable_ClassRoomID_idx ON tblExamDistributionTable (ClassRoomID);
CREATE INDEX tblExamDistributionTable_CourseID_idx ON tblExamDistributionTable (ApprovedCourseID);
CREATE INDEX tblExamDistributionTable_ExamTypeID_idx ON tblExamDistributionTable (ExamTypeID);
CREATE UNIQUE INDEX tblExamDistributionTable_PrimaryKey_idx ON tblExamDistributionTable (ID);
CREATE INDEX tblExamDistributionTable_TermID_idx ON tblExamDistributionTable (TermID);
CREATE UNIQUE INDEX tblExamDistributionTable_UniqeKey_idx ON tblExamDistributionTable (ApprovedCourseID, TermID, ExamTypeID);
CREATE INDEX tblExamDistributionTable_WeekDayID_idx ON tblExamDistributionTable (WeekDayID);
CREATE INDEX tblExamDistributionTable_WeekID_idx ON tblExamDistributionTable (WeekID);

CREATE TABLE tblExamLateStudentList
 (
	ExamLateStudentID			INTEGER, 
	StudentAccountID			INTEGER, 
	ApprovedCourseID			INTEGER, 
	Note			varchar
	, PRIMARY KEY (ExamLateStudentID, StudentAccountID)
);

-- CREATE INDEXES ...
CREATE INDEX tblExamLateStudentList_ApprovedCourseID_idx ON tblExamLateStudentList (ApprovedCourseID);
CREATE INDEX tblExamLateStudentList_ID_idx ON tblExamLateStudentList (ExamLateStudentID);
CREATE INDEX tblExamLateStudentList_StudentAccountID_idx ON tblExamLateStudentList (StudentAccountID);

CREATE TABLE tblExamObjection
 (
	ID			INTEGER, 
	ObjectionDate			varchar, 
	StudentAccountID			INTEGER, 
	ExamDistributionTableID			INTEGER NOT NULL, 
	ObjectionTypeID			INTEGER, 
	ObjectionText			TEXT, 
	ReviewerAccountID			INTEGER, 
	Accepted			INTEGER NOT NULL, 
	Reason			TEXT, 
	ExaminationUnitNote			TEXT
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblExamObjection_ExamDistributionTableID_idx ON tblExamObjection (ExamDistributionTableID);
CREATE INDEX tblExamObjection_ID_idx ON tblExamObjection (ID);
CREATE INDEX tblExamObjection_ObjectionTypeID_idx ON tblExamObjection (ObjectionTypeID);
CREATE INDEX tblExamObjection_ReviewerAccountID_idx ON tblExamObjection (ReviewerAccountID);
CREATE INDEX tblExamObjection_StudentAccountID_idx ON tblExamObjection (StudentAccountID);

CREATE TABLE tblExamPeriod
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblExamPeriod_FormID_idx ON tblExamPeriod (ID);
CREATE UNIQUE INDEX tblExamPeriod_NameAr_idx ON tblExamPeriod (NameAr);
CREATE UNIQUE INDEX tblExamPeriod_NameEn_idx ON tblExamPeriod (NameEn);

CREATE TABLE tblExamType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblExamType_FormID_idx ON tblExamType (ID);
CREATE UNIQUE INDEX tblExamType_NameAr_idx ON tblExamType (NameAr);
CREATE UNIQUE INDEX tblExamType_NameEn_idx ON tblExamType (NameEn);

CREATE TABLE tblExecutionStatus
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblExecutionStatus_FormID_idx ON tblExecutionStatus (ID);

CREATE TABLE tblExperienceType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblExperienceType_FormID_idx ON tblExperienceType (ID);
CREATE UNIQUE INDEX tblExperienceType_NameAr_idx ON tblExperienceType (NameAr);
CREATE UNIQUE INDEX tblExperienceType_NameEn_idx ON tblExperienceType (NameEn);

CREATE TABLE tblGender
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblGender_FormID_idx ON tblGender (ID);
CREATE UNIQUE INDEX tblGender_NameAr_idx ON tblGender (NameAr);
CREATE UNIQUE INDEX tblGender_NameEn_idx ON tblGender (NameEn);

CREATE TABLE tblGeneralGrade
 (
	ID			INTEGER, 
	NameAr			varchar, 
	NameEn			varchar, 
	LaterAr			varchar, 
	LaterEn			varchar, 
	StartMark			REAL, 
	EndMark			REAL, 
	StartMarkIncluded			INTEGER NOT NULL, 
	EndMarkIncluded			INTEGER NOT NULL
);

-- CREATE INDEXES ...
CREATE UNIQUE INDEX tblGeneralGrade_ID_idx ON tblGeneralGrade (ID);
CREATE UNIQUE INDEX tblGeneralGrade_NameAr_idx ON tblGeneralGrade (NameAr);

CREATE TABLE tblGenralDiscount
 (
	ID			INTEGER, 
	CreationDate			DateTime, 
	Discount			INTEGER, 
	StartDate			DateTime, 
	EndDate			DateTime, 
	Remark			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblGenralDiscount_ID_idx ON tblGenralDiscount (ID);

CREATE TABLE tblGrade
 (
	ID			INTEGER, 
	NameAr			varchar, 
	NameEn			varchar, 
	LaterAr			varchar, 
	LaterEn			varchar, 
	StartMark			REAL, 
	EndMark			REAL, 
	Value			REAL, 
	StartMarkIncluded			INTEGER NOT NULL, 
	EndMarkIncluded			INTEGER NOT NULL, 
	IsSelected			INTEGER NOT NULL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE UNIQUE INDEX tblGrade_ID_idx ON tblGrade (ID);
CREATE UNIQUE INDEX tblGrade_NameAr_idx ON tblGrade (NameAr);

CREATE TABLE tblGroupedCategory
 (
	ID			INTEGER NOT NULL, 
	CategoryLater			varchar NOT NULL, 
	NameAr			varchar, 
	NameEn			varchar, 
	LeaveStatement			TEXT
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE UNIQUE INDEX tblGroupedCategory_CategoryLater_idx ON tblGroupedCategory (CategoryLater);
CREATE UNIQUE INDEX tblGroupedCategory_ID_idx ON tblGroupedCategory (ID);
CREATE UNIQUE INDEX tblGroupedCategory_NameAr_idx ON tblGroupedCategory (NameAr);
CREATE UNIQUE INDEX tblGroupedCategory_NameEn_idx ON tblGroupedCategory (NameEn);

CREATE TABLE tblHonorDegreeType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblHonorDegreeType_FormID_idx ON tblHonorDegreeType (ID);
CREATE UNIQUE INDEX tblHonorDegreeType_NameAr_idx ON tblHonorDegreeType (NameAr);
CREATE UNIQUE INDEX tblHonorDegreeType_NameEn_idx ON tblHonorDegreeType (NameEn);

CREATE TABLE tblHospital
 (
	ID			INTEGER, 
	NameAr			varchar, 
	NameEn			varchar, 
	DocumentImagePath			TEXT
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tblHousingType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblHousingType_FormID_idx ON tblHousingType (ID);
CREATE UNIQUE INDEX tblHousingType_NameAr_idx ON tblHousingType (NameAr);
CREATE UNIQUE INDEX tblHousingType_NameEn_idx ON tblHousingType (NameEn);

CREATE TABLE tblIncomeStatementGroup
 (
	ID			INTEGER, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar NOT NULL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tblInputMeans
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblInputMeans_FormID_idx ON tblInputMeans (ID);
CREATE UNIQUE INDEX tblInputMeans_NameAr_idx ON tblInputMeans (NameAr);
CREATE UNIQUE INDEX tblInputMeans_NameEn_idx ON tblInputMeans (NameEn);

CREATE TABLE tblInstallment
 (
	BranchID			INTEGER NOT NULL, 
	InstallmentPlanID			INTEGER NOT NULL, 
	InstallmentID			INTEGER NOT NULL, 
	InstallmentDate			DateTime, 
	InstallmentAmount			REAL, 
	Remark			varchar
	, PRIMARY KEY (BranchID, InstallmentPlanID, InstallmentID)
);

-- CREATE INDEXES ...
CREATE INDEX tblInstallment_BranchID_idx ON tblInstallment (BranchID);
CREATE INDEX tblInstallment_InstallmentID_idx ON tblInstallment (InstallmentID);
CREATE INDEX tblInstallment_InstallmentPlanID_idx ON tblInstallment (InstallmentPlanID);

CREATE TABLE tblInstallmentPlan
 (
	BranchID			INTEGER NOT NULL, 
	ID			INTEGER, 
	InstallmentPlanTypeID			INTEGER, 
	AccountID			INTEGER, 
	PlanDate			DateTime, 
	PlanAmount			REAL, 
	InstallmentCount			INTEGER, 
	FirstInstallmentDate			DateTime, 
	InstallmentPeriodTypeID			INTEGER, 
	Remark			TEXT, 
	UserID			INTEGER, 
	AuthorizerID			INTEGER, 
	PaymentMethodID			INTEGER, 
	SponsorID			INTEGER, 
	MoneyTransactionID			varchar NOT NULL, 
	PaidInstallmentCount			INTEGER, 
	PaidAmount			REAL, 
	LastInstallmentID			INTEGER, 
	LastPaymentDate			DateTime, 
	Conditions			TEXT, 
	ConditionClassID			INTEGER
	, PRIMARY KEY (ID, BranchID)
);

-- CREATE INDEXES ...
CREATE INDEX tblInstallmentPlan_AccountID_idx ON tblInstallmentPlan (AccountID);
CREATE INDEX tblInstallmentPlan_BranchID_idx ON tblInstallmentPlan (BranchID);
CREATE INDEX tblInstallmentPlan_ConditionClassID_idx ON tblInstallmentPlan (ConditionClassID);
CREATE INDEX tblInstallmentPlan_ID_idx ON tblInstallmentPlan (ID);
CREATE INDEX tblInstallmentPlan_InstallmentPaymentTypeID_idx ON tblInstallmentPlan (InstallmentPeriodTypeID);
CREATE INDEX tblInstallmentPlan_LastReceivedInstallmentID_idx ON tblInstallmentPlan (LastInstallmentID);
CREATE UNIQUE INDEX tblInstallmentPlan_MoneyTransactionID_idx ON tblInstallmentPlan (MoneyTransactionID);
CREATE INDEX tblInstallmentPlan_PaymentTypeID_idx ON tblInstallmentPlan (PaymentMethodID);
CREATE INDEX tblInstallmentPlan_UserID_idx ON tblInstallmentPlan (UserID);

CREATE TABLE tblInsurancePersent
 (
	ICS			REAL, 
	IES			REAL, 
	ICNS			REAL, 
	IENS			REAL
);

-- CREATE INDEXES ...

CREATE TABLE tblInvoice
 (
	ID			varchar, 
	CodeID			INTEGER NOT NULL, 
	PCID			INTEGER NOT NULL, 
	InvoiceTypeID			INTEGER, 
	CreditorID			INTEGER, 
	DebtorID			INTEGER, 
	InvoiceNo			varchar, 
	InvoiceDate			DateTime NOT NULL, 
	CreditorPersonID			INTEGER, 
	DebitorPersonID			INTEGER, 
	Amount			REAL, 
	Discount			REAL, 
	BeforehandSum			REAL, 
	RetrieveSum			REAL, 
	PaidSum			REAL, 
	DueDate			DateTime, 
	Remark			varchar, 
	NoteTypeID			INTEGER, 
	GivingDate			DateTime, 
	AccountName			varchar, 
	GivingTime			DateTime, 
	Pledge			REAL, 
	PlateQty			INTEGER, 
	ReceivedPlateQty			INTEGER, 
	RemainSum			REAL, 
	StoreCreditorID			INTEGER, 
	StoreDebtorID			INTEGER, 
	UserID			INTEGER, 
	AuthorizerID			INTEGER, 
	MoneyTransactionID			varchar NOT NULL, 
	UrgentTypeID			INTEGER, 
	TableID			INTEGER, 
	OrderType			INTEGER, 
	VATValue			REAL, 
	VatTypeID			INTEGER, 
	VATNo			varchar, 
	InvoiceTime			DateTime, 
	ReternedInvoiceID			varchar, 
	VAT			REAL, 
	IssueDate			DateTime, 
	ReturnReason			varchar, 
	SubmissionStatusID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblInvoice_InvoiceTypeID_idx ON tblInvoice (InvoiceTypeID);
CREATE UNIQUE INDEX tblInvoice_MoneyTransactionID_idx ON tblInvoice (MoneyTransactionID);
CREATE INDEX tblInvoice_SubmissionStatusID_idx ON tblInvoice (SubmissionStatusID);
CREATE INDEX tblInvoice_UserID_idx ON tblInvoice (UserID);

CREATE TABLE tblInvoiceAllowanceChargeReason
 (
	InvoiceID			varchar NOT NULL, 
	AllowanceChargeReasonCode			varchar, 
	ChargeIndicator			INTEGER NOT NULL, 
	CurrencyID			INTEGER, 
	Amount			REAL
	, PRIMARY KEY (InvoiceID, AllowanceChargeReasonCode)
);

-- CREATE INDEXES ...
CREATE INDEX tblInvoiceAllowanceChargeReason_AllowanceChargeReasonCode_idx ON tblInvoiceAllowanceChargeReason (AllowanceChargeReasonCode);

CREATE TABLE tblInvoiceCancellation
 (
	InvoiceID			varchar, 
	CancellationDate			DateTime, 
	CancellationReason			varchar
	, PRIMARY KEY (InvoiceID)
);

-- CREATE INDEXES ...
CREATE INDEX tblInvoiceCancellation_InvoiceID_idx ON tblInvoiceCancellation (InvoiceID);

CREATE TABLE tblInvoiceContact
 (
	InvoiceID			varchar NOT NULL, 
	ContactTypeID			INTEGER NOT NULL, 
	ContactID			varchar NOT NULL, 
	ContactNote			varchar, 
	ToSend			INTEGER NOT NULL
	, PRIMARY KEY (InvoiceID, ContactTypeID)
);

-- CREATE INDEXES ...
CREATE INDEX tblInvoiceContact_ContactID_idx ON tblInvoiceContact (ContactID);
CREATE INDEX tblInvoiceContact_DocumentTypeNo_idx ON tblInvoiceContact (ContactTypeID);
CREATE INDEX tblInvoiceContact_InvoiceID_idx ON tblInvoiceContact (InvoiceID);

CREATE TABLE tblInvoiceCopy
 (
	ID			INTEGER, 
	RecCopyName			varchar, 
	SpentCopyName			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblInvoiceCopy_ID_idx ON tblInvoiceCopy (ID);

CREATE TABLE tblInvoiceDesignDetails
 (
	InvoiceID			varchar, 
	ShirtL			INTEGER, 
	ShirtS			INTEGER, 
	ShirtC			INTEGER, 
	ShirtW			INTEGER, 
	ShirtF			INTEGER, 
	ShirtCL			INTEGER, 
	PantsL1			INTEGER, 
	PantsW			INTEGER, 
	PantsR			INTEGER, 
	PantsH			INTEGER, 
	PantsM			INTEGER, 
	PantsL2			INTEGER, 
	VestL			INTEGER, 
	VestS			INTEGER, 
	VestC			INTEGER, 
	VestA			INTEGER, 
	DesignNote			TEXT
	, PRIMARY KEY (InvoiceID)
);

-- CREATE INDEXES ...
CREATE INDEX tblInvoiceDesignDetails_InvoiceID_idx ON tblInvoiceDesignDetails (InvoiceID);

CREATE TABLE tblInvoiceItemAccount
 (
	InvoiceID			varchar, 
	ID			INTEGER, 
	AccountID			INTEGER NOT NULL
	, PRIMARY KEY (InvoiceID, ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblInvoiceItemAccount_EmployeeAccountID_idx ON tblInvoiceItemAccount (AccountID);
CREATE INDEX tblInvoiceItemAccount_InvoiceID_idx ON tblInvoiceItemAccount (InvoiceID);

CREATE TABLE tblInvoiceItemAllowanceChargeReason
 (
	InvoiceID			varchar NOT NULL, 
	InvoiceItemID			INTEGER NOT NULL, 
	ChargeIndicator			INTEGER NOT NULL, 
	AllowanceChargeReasonCode			varchar NOT NULL, 
	CurrencyID			INTEGER, 
	Amount			REAL
	, PRIMARY KEY (InvoiceID, InvoiceItemID)
);

-- CREATE INDEXES ...
CREATE INDEX tblInvoiceItemAllowanceChargeReason_AllowanceChargeReasonCode_idx ON tblInvoiceItemAllowanceChargeReason (AllowanceChargeReasonCode);

CREATE TABLE tblInvoiceItemConsumables
 (
	InvoiceID			varchar, 
	ID			INTEGER, 
	ConsumableItemID			INTEGER, 
	Qty			REAL NOT NULL, 
	UnitCost			REAL NOT NULL
	, PRIMARY KEY (InvoiceID, ID, ConsumableItemID)
);

-- CREATE INDEXES ...
CREATE INDEX tblInvoiceItemConsumables_ConsumableItemID_idx ON tblInvoiceItemConsumables (ConsumableItemID);
CREATE INDEX tblInvoiceItemConsumables_InvoiceID_idx ON tblInvoiceItemConsumables (InvoiceID);
CREATE INDEX tblInvoiceItemConsumables_tblInvoiceItemConsumablesID_idx ON tblInvoiceItemConsumables (ID);

CREATE TABLE tblInvoiceItemDataForLaundry
 (
	InvoiceID			varchar, 
	InvoiceItemID			INTEGER, 
	StarchTypeID			INTEGER, 
	BluingTypeID			INTEGER, 
	MerzamTypeID			INTEGER, 
	HaveSpot			INTEGER NOT NULL, 
	Perfuming			INTEGER NOT NULL, 
	Tsfit			INTEGER NOT NULL
	, PRIMARY KEY (InvoiceID, InvoiceItemID)
);

-- CREATE INDEXES ...
CREATE INDEX tblInvoiceItemDataForLaundry_BluingTypeID_idx ON tblInvoiceItemDataForLaundry (MerzamTypeID);
CREATE INDEX tblInvoiceItemDataForLaundry_InvoiceID_idx ON tblInvoiceItemDataForLaundry (InvoiceID);
CREATE INDEX tblInvoiceItemDataForLaundry_StarchTypeID_idx ON tblInvoiceItemDataForLaundry (StarchTypeID);
CREATE INDEX tblInvoiceItemDataForLaundry_StarchTypeID1_idx ON tblInvoiceItemDataForLaundry (BluingTypeID);
CREATE INDEX tblInvoiceItemDataForLaundry_tblInvoiceItemDataForLaundryID_idx ON tblInvoiceItemDataForLaundry (InvoiceItemID);

CREATE TABLE tblInvoiceItemDataForRestaurant
 (
	InvoiceID			varchar, 
	InvoiceItemID			INTEGER, 
	SauceTypeID			INTEGER, 
	TahininhTypeID			INTEGER, 
	KetchupTypeID			INTEGER, 
	SaladTypeID			INTEGER, 
	PotatoTypeID			INTEGER, 
	MayonnaiseTypeID			INTEGER
	, PRIMARY KEY (InvoiceID, InvoiceItemID)
);

-- CREATE INDEXES ...
CREATE INDEX tblInvoiceItemDataForRestaurant_InvoiceID_idx ON tblInvoiceItemDataForRestaurant (InvoiceID);
CREATE INDEX tblInvoiceItemDataForRestaurant_StarchTypeID1_idx ON tblInvoiceItemDataForRestaurant (SauceTypeID);
CREATE INDEX tblInvoiceItemDataForRestaurant_tblInvoiceItemDataForLaundryID_idx ON tblInvoiceItemDataForRestaurant (InvoiceItemID);
CREATE INDEX tblInvoiceItemDataForRestaurant_TypeID_idx ON tblInvoiceItemDataForRestaurant (TahininhTypeID);
CREATE INDEX tblInvoiceItemDataForRestaurant_TypeID1_idx ON tblInvoiceItemDataForRestaurant (KetchupTypeID);
CREATE INDEX tblInvoiceItemDataForRestaurant_TypeID2_idx ON tblInvoiceItemDataForRestaurant (SaladTypeID);
CREATE INDEX tblInvoiceItemDataForRestaurant_TypeID3_idx ON tblInvoiceItemDataForRestaurant (PotatoTypeID);
CREATE INDEX tblInvoiceItemDataForRestaurant_TypeID4_idx ON tblInvoiceItemDataForRestaurant (MayonnaiseTypeID);

CREATE TABLE tblInvoiceItemNote
 (
	InvoiceID			varchar, 
	ID			INTEGER, 
	Note			TEXT
	, PRIMARY KEY (InvoiceID, ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblInvoiceItemNote_InvoiceID_idx ON tblInvoiceItemNote (InvoiceID);

CREATE TABLE tblInvoiceRealEstate
 (
	InvoiceID			varchar, 
	RealEstateID			INTEGER
	, PRIMARY KEY (InvoiceID, RealEstateID)
);

-- CREATE INDEXES ...
CREATE INDEX tblInvoiceRealEstate_ID_idx ON tblInvoiceRealEstate (InvoiceID);
CREATE INDEX tblInvoiceRealEstate_RealEstateID_idx ON tblInvoiceRealEstate (RealEstateID);

CREATE TABLE tblInvoiceRealestateUnit
 (
	InvoiceID			varchar, 
	BranchID			INTEGER NOT NULL, 
	UnitID			INTEGER
	, PRIMARY KEY (InvoiceID, BranchID, UnitID)
);

-- CREATE INDEXES ...
CREATE INDEX tblInvoiceRealestateUnit_BranchID_idx ON tblInvoiceRealestateUnit (BranchID);
CREATE INDEX tblInvoiceRealestateUnit_InvoiceID_idx ON tblInvoiceRealestateUnit (InvoiceID);
CREATE INDEX tblInvoiceRealestateUnit_UnitID_idx ON tblInvoiceRealestateUnit (UnitID);

CREATE TABLE tblInvoiceReportType
 (
	ReportName			varchar, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ReportName)
);

-- CREATE INDEXES ...
CREATE UNIQUE INDEX tblInvoiceReportType_NameAr_idx ON tblInvoiceReportType (NameAr);
CREATE UNIQUE INDEX tblInvoiceReportType_NameEn_idx ON tblInvoiceReportType (NameEn);

CREATE TABLE tblInvoiceStatus
 (
	InvoiceID			varchar, 
	StatusDate			DateTime, 
	StatusTypeID			INTEGER, 
	Remark			varchar
	, PRIMARY KEY (InvoiceID)
);

-- CREATE INDEXES ...
CREATE INDEX tblInvoiceStatus_InvoiceID_idx ON tblInvoiceStatus (InvoiceID);
CREATE INDEX tblInvoiceStatus_StatusTypeID_idx ON tblInvoiceStatus (StatusTypeID);

CREATE TABLE tblInvoiceType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	CreditorTypeID			INTEGER, 
	DebtorTypeID			INTEGER, 
	StoreCreditorTypeID			INTEGER, 
	StoreDebitorTypeID			INTEGER, 
	Used			INTEGER NOT NULL, 
	ColorCode			varchar, 
	BalnceSign			INTEGER, 
	DiscountPriceCheck			INTEGER NOT NULL, 
	ObjectID			INTEGER, 
	affectsItemCost			INTEGER NOT NULL, 
	personAccountRole			INTEGER, 
	ItemBalanceColumn			varchar, 
	InvoiceTypeCode			varchar, 
	InvoiceSubTypeCode			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblInvoiceType_ColorCode_idx ON tblInvoiceType (ColorCode);
CREATE INDEX tblInvoiceType_CreditorID_idx ON tblInvoiceType (CreditorTypeID);
CREATE INDEX tblInvoiceType_CreditorPersonID_idx ON tblInvoiceType (StoreCreditorTypeID);
CREATE INDEX tblInvoiceType_DebitorPersonID_idx ON tblInvoiceType (StoreDebitorTypeID);
CREATE INDEX tblInvoiceType_DebtorID_idx ON tblInvoiceType (DebtorTypeID);
CREATE INDEX tblInvoiceType_FormID_idx ON tblInvoiceType (ID);

CREATE TABLE tblInvoiceTypeItemUseType
 (
	InvoiceTypeID			INTEGER, 
	UseTypeID			INTEGER, 
	IsUsed			INTEGER NOT NULL
	, PRIMARY KEY (InvoiceTypeID, UseTypeID)
);

-- CREATE INDEXES ...
CREATE INDEX tblInvoiceTypeItemUseType_InvoiceTypeID_idx ON tblInvoiceTypeItemUseType (InvoiceTypeID);
CREATE INDEX tblInvoiceTypeItemUseType_UseTypeID_idx ON tblInvoiceTypeItemUseType (UseTypeID);

CREATE TABLE tblInvoiceTypeLink
 (
	ID			INTEGER, 
	InvoiceTypeID			INTEGER, 
	ReturnInvoiceTypeID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblInvoiceTypeLink_ID_idx ON tblInvoiceTypeLink (ID);
CREATE INDEX tblInvoiceTypeLink_InvoiceTypeID_idx ON tblInvoiceTypeLink (InvoiceTypeID);
CREATE INDEX tblInvoiceTypeLink_InvoiceTypeID1_idx ON tblInvoiceTypeLink (ReturnInvoiceTypeID);

CREATE TABLE tblInvoiceTypeObject
 (
	InvoiceTypeID			INTEGER, 
	ObjectID			INTEGER NOT NULL
	, PRIMARY KEY (InvoiceTypeID)
);

-- CREATE INDEXES ...
CREATE UNIQUE INDEX tblInvoiceTypeObject_InvoiceTypeID_idx ON tblInvoiceTypeObject (InvoiceTypeID);
CREATE UNIQUE INDEX tblInvoiceTypeObject_ObjectID_idx ON tblInvoiceTypeObject (ObjectID);

CREATE TABLE tblItem
 (
	ID			INTEGER, 
	Price			REAL NOT NULL, 
	MinimumPrice			REAL NOT NULL, 
	WholesalePrice			REAL NOT NULL, 
	quickitem			INTEGER NOT NULL, 
	ItemGroupID			INTEGER, 
	WithVatPrice			REAL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblItem_ID_idx ON tblItem (ID);
CREATE INDEX tblItem_ItemGroupID_idx ON tblItem (ItemGroupID);

CREATE TABLE tblItemBalance
 (
	ItemID			INTEGER, 
	StartPeriodBalance			REAL, 
	PurchaseCount			REAL, 
	PurchaseReturnCount			REAL, 
	SalesCount			REAL, 
	SalesReturnCount			REAL, 
	SpentCount			REAL, 
	SpentReturnCount			REAL, 
	RentalCount			REAL, 
	RentalReturnCount			REAL, 
	OrderMinammBalance			REAL, 
	OrderCount			REAL, 
	DecayedCount			REAL, 
	DecayedReturnCount			REAL, 
	ProductionCount			REAL, 
	ProductionCancelCount			REAL, 
	ProductionReturnCount			REAL, 
	PurchaseOrderCount			REAL, 
	SalesOrderCount			REAL, 
	PackingAndUnPackingCount			REAL, 
	StartPeriodBalanceReturn			REAL, 
	LastPurchaseDate			DateTime, 
	MinPurchasePrice			REAL, 
	MaxPurchasePrice			REAL, 
	LastPurchasePrice			REAL, 
	Qty			REAL, 
	CostPrice			REAL, 
	LastSalesDate			DateTime, 
	MinSalesPrice			REAL, 
	MaxSalesPrice			REAL, 
	LastSalesPrice			REAL
	, PRIMARY KEY (ItemID)
);

-- CREATE INDEXES ...
CREATE INDEX tblItemBalance_ItemID_idx ON tblItemBalance (ItemID);

CREATE TABLE tblItemBalanceHistory
 (
	PeriodID			INTEGER, 
	ItemID			INTEGER, 
	StartPeriodBalance			REAL, 
	PurchaseCount			REAL, 
	PurchaseReturnCount			REAL, 
	SalesCount			REAL, 
	SalesReturnCount			REAL, 
	SpentCount			REAL, 
	SpentReturnCount			REAL, 
	RentalCount			REAL, 
	RentalReturnCount			REAL, 
	OrderMinammBalance			REAL, 
	OrderCount			REAL, 
	DecayedCount			REAL, 
	DecayedReturnCount			REAL, 
	ProductionCount			REAL, 
	ProductionCancelCount			REAL, 
	ProductionReturnCount			REAL, 
	PurchaseOrderCount			REAL, 
	SalesOrderCount			REAL, 
	PackingAndUnPackingCount			REAL
);

-- CREATE INDEXES ...
CREATE INDEX tblItemBalanceHistory_ItemID_idx ON tblItemBalanceHistory (ItemID);
CREATE INDEX tblItemBalanceHistory_PeriodID_idx ON tblItemBalanceHistory (PeriodID);

CREATE TABLE tblItemBlancePeriod
 (
	ID			INTEGER, 
	StartDate			DateTime, 
	EndDate			DateTime, 
	Remark			TEXT
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblItemBlancePeriod_ID_idx ON tblItemBlancePeriod (ID);

CREATE TABLE tblItemCarData
 (
	ItemID			INTEGER, 
	CarCompanyID			INTEGER, 
	CarNameID			INTEGER, 
	ModelFromID			INTEGER, 
	ModelToID			INTEGER, 
	MadeCountryID			INTEGER, 
	ItemCompanyID			INTEGER, 
	EngineSizeID			INTEGER, 
	LocationInCarID			INTEGER, 
	CylinderCountID			INTEGER, 
	GearTypeID			INTEGER, 
	ElectricalTypeID			INTEGER, 
	AgencyNo			varchar, 
	DefrentText			varchar
	, PRIMARY KEY (ItemID)
);

-- CREATE INDEXES ...
CREATE INDEX tblItemCarData_ColorID1_idx ON tblItemCarData (CarCompanyID);
CREATE INDEX tblItemCarData_ColorID2_idx ON tblItemCarData (CarNameID);
CREATE INDEX tblItemCarData_ColorID3_idx ON tblItemCarData (ModelFromID);
CREATE INDEX tblItemCarData_ColorID4_idx ON tblItemCarData (ModelToID);
CREATE INDEX tblItemCarData_ColorID5_idx ON tblItemCarData (MadeCountryID);
CREATE INDEX tblItemCarData_ColorID6_idx ON tblItemCarData (ItemCompanyID);
CREATE INDEX tblItemCarData_ColorID7_idx ON tblItemCarData (EngineSizeID);
CREATE INDEX tblItemCarData_ColorID8_idx ON tblItemCarData (LocationInCarID);
CREATE INDEX tblItemCarData_ColorID9_idx ON tblItemCarData (CylinderCountID);
CREATE INDEX tblItemCarData_CylinderCountID_idx ON tblItemCarData (ElectricalTypeID);
CREATE INDEX tblItemCarData_CylinderCountID1_idx ON tblItemCarData (GearTypeID);
CREATE INDEX tblItemCarData_ItemID_idx ON tblItemCarData (ItemID);

CREATE TABLE tblItemConsumables
 (
	ItemID			INTEGER, 
	ConsumableItemID			INTEGER, 
	Qty			REAL NOT NULL, 
	InvoiceTypeID			INTEGER
	, PRIMARY KEY (ItemID, ConsumableItemID)
);

-- CREATE INDEXES ...
CREATE INDEX tblItemConsumables_ConsumableItemID_idx ON tblItemConsumables (ConsumableItemID);
CREATE INDEX tblItemConsumables_ItemID_idx ON tblItemConsumables (ItemID);

CREATE TABLE tblItemGroup
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	ShortName			varchar, 
	VAT			REAL, 
	NotUsed			INTEGER NOT NULL, 
	UseTypeID			INTEGER, 
	ItemTypeID			INTEGER, 
	FilePath			TEXT, 
	ItemNote			TEXT, 
	VaTCategoriesID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblItemGroup_FormID_idx ON tblItemGroup (ID);
CREATE INDEX tblItemGroup_ItemTypeID_idx ON tblItemGroup (ItemTypeID);
CREATE INDEX tblItemGroup_UseTypeID_idx ON tblItemGroup (UseTypeID);
CREATE INDEX tblItemGroup_VaTCategoriesID_idx ON tblItemGroup (VaTCategoriesID);

CREATE TABLE tblItemOtherData
 (
	ItemID			INTEGER, 
	ColorID			INTEGER, 
	BarcodeNo			varchar, 
	ItemPlaceID			INTEGER, 
	ItemSizeID			INTEGER, 
	UnitCount			REAL
	, PRIMARY KEY (ItemID)
);

-- CREATE INDEXES ...
CREATE UNIQUE INDEX tblItemOtherData_CodeNo_idx ON tblItemOtherData (BarcodeNo);
CREATE INDEX tblItemOtherData_ColorID_idx ON tblItemOtherData (ColorID);
CREATE INDEX tblItemOtherData_ItemID_idx ON tblItemOtherData (ItemID);
CREATE INDEX tblItemOtherData_ItemPlaceID_idx ON tblItemOtherData (ItemPlaceID);
CREATE INDEX tblItemOtherData_ItemSizeID_idx ON tblItemOtherData (ItemSizeID);

CREATE TABLE tblItemPackingAndUnPacking
 (
	ID			varchar NOT NULL, 
	PackingDate			DateTime, 
	UserID			INTEGER, 
	StoreCreditorID			INTEGER NOT NULL, 
	StoreDebtorID			INTEGER NOT NULL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblItemPackingAndUnPacking_MoneyTransactionID_idx ON tblItemPackingAndUnPacking (ID);
CREATE INDEX tblItemPackingAndUnPacking_StoreCreditorID_idx ON tblItemPackingAndUnPacking (StoreCreditorID);
CREATE INDEX tblItemPackingAndUnPacking_UserID_idx ON tblItemPackingAndUnPacking (UserID);

CREATE TABLE tblItemPackingAndUnPackingDetails
 (
	ItemPackingAndUnPackingID			varchar NOT NULL, 
	ID			INTEGER NOT NULL, 
	CreditorItemID			INTEGER NOT NULL, 
	CreditorItemCount			REAL NOT NULL, 
	CreditorItemPrice			REAL NOT NULL, 
	DebtorItemID			INTEGER NOT NULL, 
	DebtorItemCount			REAL NOT NULL, 
	DebtorItemPrice			REAL NOT NULL
	, PRIMARY KEY (ItemPackingAndUnPackingID, ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblItemPackingAndUnPackingDetails_CreditorID_idx ON tblItemPackingAndUnPackingDetails (CreditorItemID);
CREATE INDEX tblItemPackingAndUnPackingDetails_DebtorID_idx ON tblItemPackingAndUnPackingDetails (DebtorItemID);
CREATE INDEX tblItemPackingAndUnPackingDetails_ID_idx ON tblItemPackingAndUnPackingDetails (ID);
CREATE INDEX tblItemPackingAndUnPackingDetails_MoneyTransactionID_idx ON tblItemPackingAndUnPackingDetails (ItemPackingAndUnPackingID);

CREATE TABLE tblItemPlace
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblItemPlace_FormID_idx ON tblItemPlace (ID);
CREATE UNIQUE INDEX tblItemPlace_NameAr_idx ON tblItemPlace (NameAr);
CREATE UNIQUE INDEX tblItemPlace_NameEn_idx ON tblItemPlace (NameEn);

CREATE TABLE tblItemType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	ShortNameAr			varchar, 
	ShortNameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblItemType_FormID_idx ON tblItemType (ID);
CREATE UNIQUE INDEX tblItemType_NameAr_idx ON tblItemType (NameAr);
CREATE UNIQUE INDEX tblItemType_NameEn_idx ON tblItemType (NameEn);

CREATE TABLE tblJob
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblJob_FormID_idx ON tblJob (ID);
CREATE UNIQUE INDEX tblJob_NameAr_idx ON tblJob (NameAr);
CREATE UNIQUE INDEX tblJob_NameEn_idx ON tblJob (NameEn);

CREATE TABLE tblJournalEntry
 (
	ID			varchar, 
	CodeID			INTEGER NOT NULL, 
	PCID			INTEGER NOT NULL, 
	EnteryDate			DateTime, 
	Remark			varchar, 
	MoneyTransactionID			varchar NOT NULL, 
	UserID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblJournalEntry_CodeID_idx ON tblJournalEntry (CodeID);
CREATE UNIQUE INDEX tblJournalEntry_ID2_idx ON tblJournalEntry (ID);
CREATE INDEX tblJournalEntry_MoneyTransactionID_idx ON tblJournalEntry (MoneyTransactionID);
CREATE INDEX tblJournalEntry_PCID_idx ON tblJournalEntry (PCID);
CREATE INDEX tblJournalEntry_UserID_idx ON tblJournalEntry (UserID);

CREATE TABLE tblJournalEntryCancellation
 (
	JournalEntryID			varchar NOT NULL, 
	CancellationDate			DateTime, 
	CancellationReason			varchar
	, PRIMARY KEY (JournalEntryID)
);

-- CREATE INDEXES ...
CREATE INDEX tblJournalEntryCancellation_ID_idx ON tblJournalEntryCancellation (JournalEntryID);

CREATE TABLE tblManagement
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblManagement_FormID_idx ON tblManagement (ID);
CREATE UNIQUE INDEX tblManagement_NameAr_idx ON tblManagement (NameAr);
CREATE UNIQUE INDEX tblManagement_NameEn_idx ON tblManagement (NameEn);

CREATE TABLE tblMark
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblMark_FormID_idx ON tblMark (ID);
CREATE UNIQUE INDEX tblMark_NameAr_idx ON tblMark (NameAr);
CREATE UNIQUE INDEX tblMark_NameEn_idx ON tblMark (NameEn);

CREATE TABLE tblMoneyAccountType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblMoneyAccountType_DocumentTypeID_idx ON tblMoneyAccountType (ID);
CREATE UNIQUE INDEX tblMoneyAccountType_NameAr_idx ON tblMoneyAccountType (NameAr);
CREATE UNIQUE INDEX tblMoneyAccountType_NameEn_idx ON tblMoneyAccountType (NameEn);

CREATE TABLE tblMoneyTransaction
 (
	ID			varchar, 
	CodeID			INTEGER NOT NULL, 
	PCID			INTEGER NOT NULL, 
	TransactionDate			DateTime NOT NULL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblMoneyTransaction_CodeID_idx ON tblMoneyTransaction (CodeID);
CREATE UNIQUE INDEX tblMoneyTransaction_ID_idx ON tblMoneyTransaction (ID);
CREATE INDEX tblMoneyTransaction_PCID_idx ON tblMoneyTransaction (PCID);

CREATE TABLE tblMoneyTransactionDetails
 (
	ID			INTEGER NOT NULL, 
	MoneyTransactionID			varchar NOT NULL, 
	AccountSideID			INTEGER NOT NULL, 
	AccountID			INTEGER NOT NULL, 
	Amount			REAL NOT NULL, 
	Description			varchar, 
	DescriptionID			INTEGER, 
	MoneyTransactionMethodID			INTEGER NOT NULL, 
	PaidAmount			REAL, 
	CurrencyID			INTEGER, 
	ToDelete			INTEGER NOT NULL, 
	MoneyTransactionDetailTypeID			INTEGER, 
	AllowanceChargeReasonCode			varchar
);

-- CREATE INDEXES ...
CREATE INDEX tblMoneyTransactionDetails_AllowanceChargeReasonCode_idx ON tblMoneyTransactionDetails (AllowanceChargeReasonCode);
CREATE INDEX tblMoneyTransactionDetails_AllowanceChargeReasonCode1_idx ON tblMoneyTransactionDetails (AccountID);
CREATE INDEX tblMoneyTransactionDetails_CreditorID_idx ON tblMoneyTransactionDetails (MoneyTransactionID);
CREATE INDEX tblMoneyTransactionDetails_ID_idx ON tblMoneyTransactionDetails (ID);
CREATE INDEX tblMoneyTransactionDetails_ID2_idx ON tblMoneyTransactionDetails (AccountSideID);

CREATE TABLE tblMoneyTransactionDetailType
 (
	ID			INTEGER, 
	nameAr			varchar, 
	nameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tblMoneyTransactionInvoice
 (
	InvoiceID			varchar NOT NULL, 
	MoneyTransactionID			varchar NOT NULL, 
	Amount			REAL NOT NULL
	, PRIMARY KEY (InvoiceID)
);

-- CREATE INDEXES ...
CREATE INDEX tblMoneyTransactionInvoice_ID_idx ON tblMoneyTransactionInvoice (InvoiceID);
CREATE UNIQUE INDEX tblMoneyTransactionInvoice_MoneyTransactionID_idx ON tblMoneyTransactionInvoice (MoneyTransactionID);

CREATE TABLE tblMonth
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblMonth_FormID_idx ON tblMonth (ID);
CREATE UNIQUE INDEX tblMonth_NameAr_idx ON tblMonth (NameAr);
CREATE UNIQUE INDEX tblMonth_NameEn_idx ON tblMonth (NameEn);

CREATE TABLE tblNationality
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblNationality_FormID_idx ON tblNationality (ID);
CREATE UNIQUE INDEX tblNationality_NameAr_idx ON tblNationality (NameAr);
CREATE UNIQUE INDEX tblNationality_NameEn_idx ON tblNationality (NameEn);

CREATE TABLE tblNoteOnCompany
 (
	ID			INTEGER, 
	NoteDate			DateTime, 
	NoteTime			DateTime, 
	CustomerAccountID			INTEGER, 
	NoteTypeID			INTEGER, 
	NoteDetail			TEXT, 
	InvoiceID			varchar, 
	PCID			INTEGER NOT NULL, 
	UserID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblNoteOnCompany_AssayProcedureTypeID_idx ON tblNoteOnCompany (NoteTypeID);
CREATE INDEX tblNoteOnCompany_delegateAccountID_idx ON tblNoteOnCompany (CustomerAccountID);
CREATE INDEX tblNoteOnCompany_InvoiceID_idx ON tblNoteOnCompany (InvoiceID);
CREATE INDEX tblNoteOnCompany_PCID_idx ON tblNoteOnCompany (PCID);
CREATE INDEX tblNoteOnCompany_UserID_idx ON tblNoteOnCompany (UserID);

CREATE TABLE tblNoteOnCustomer
 (
	ID			INTEGER, 
	NoteDate			DateTime, 
	NoteTime			DateTime, 
	CustomerAccountID			INTEGER, 
	CustomerNoteTypeID			INTEGER, 
	NoteDetail			TEXT, 
	PCID			INTEGER NOT NULL, 
	UserID			INTEGER, 
	InvoiceID			varchar, 
	NoteSourceID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblNoteOnCustomer_AssayProcedureTypeID_idx ON tblNoteOnCustomer (CustomerNoteTypeID);
CREATE INDEX tblNoteOnCustomer_delegateAccountID_idx ON tblNoteOnCustomer (CustomerAccountID);
CREATE INDEX tblNoteOnCustomer_InvoiceID_idx ON tblNoteOnCustomer (InvoiceID);
CREATE INDEX tblNoteOnCustomer_NoteSourceID_idx ON tblNoteOnCustomer (NoteSourceID);
CREATE INDEX tblNoteOnCustomer_PCID_idx ON tblNoteOnCustomer (PCID);
CREATE INDEX tblNoteOnCustomer_UserID_idx ON tblNoteOnCustomer (UserID);

CREATE TABLE tblNoteOnEmployee
 (
	ID			INTEGER, 
	NoteDate			DateTime, 
	NoteTime			DateTime, 
	CustomerAccountID			INTEGER, 
	NoteTypeID			INTEGER, 
	NoteDetail			TEXT, 
	InvoiceID			varchar, 
	NoteSourceID			INTEGER, 
	PCID			INTEGER NOT NULL, 
	UserID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblNoteOnEmployee_AssayProcedureTypeID_idx ON tblNoteOnEmployee (NoteTypeID);
CREATE INDEX tblNoteOnEmployee_delegateAccountID_idx ON tblNoteOnEmployee (CustomerAccountID);
CREATE INDEX tblNoteOnEmployee_InvoiceID_idx ON tblNoteOnEmployee (InvoiceID);
CREATE INDEX tblNoteOnEmployee_NoteSourceID_idx ON tblNoteOnEmployee (NoteSourceID);
CREATE INDEX tblNoteOnEmployee_PCID_idx ON tblNoteOnEmployee (PCID);
CREATE INDEX tblNoteOnEmployee_UserID_idx ON tblNoteOnEmployee (UserID);

CREATE TABLE tblObject
 (
	ID			INTEGER, 
	ObjectName			varchar, 
	NameAr			varchar, 
	NameEn			varchar, 
	ObjectTypeID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblObject_FormID_idx ON tblObject (ID);
CREATE INDEX tblObject_ItemTypeID_idx ON tblObject (ObjectTypeID);

CREATE TABLE tblObjectionType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblObjectionType_FormID_idx ON tblObjectionType (ID);
CREATE UNIQUE INDEX tblObjectionType_NameAr_idx ON tblObjectionType (NameAr);
CREATE UNIQUE INDEX tblObjectionType_NameEn_idx ON tblObjectionType (NameEn);

CREATE TABLE tblObjectType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblObjectType_FormID_idx ON tblObjectType (ID);

CREATE TABLE tblOrderExecutionMember
 (
	OrderExecutionID			INTEGER, 
	MemberAccountID			INTEGER, 
	TeamGroupID			INTEGER NOT NULL, 
	MemberShare			REAL, 
	MemberStatusID			INTEGER
	, PRIMARY KEY (OrderExecutionID, MemberAccountID)
);

-- CREATE INDEXES ...
CREATE INDEX tblOrderExecutionMember_ImplementationStatusID_idx ON tblOrderExecutionMember (OrderExecutionID);
CREATE INDEX tblOrderExecutionMember_MemberStatusID_idx ON tblOrderExecutionMember (MemberStatusID);
CREATE INDEX tblOrderExecutionMember_TeamGroupID_idx ON tblOrderExecutionMember (TeamGroupID);

CREATE TABLE tblOrderType
 (
	ID			INTEGER, 
	nameAr			varchar, 
	nameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tblOwnersEquityGroup
 (
	ID			INTEGER, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar NOT NULL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tblPaymentMethod
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	MoneyAccountTypeID			INTEGER NOT NULL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblPaymentMethod_FormID_idx ON tblPaymentMethod (ID);
CREATE INDEX tblPaymentMethod_MoneyAccountTypeID_idx ON tblPaymentMethod (MoneyAccountTypeID);

CREATE TABLE tblPaymentPeriodType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	PeriodTypeCode			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblPaymentPeriodType_FormID_idx ON tblPaymentPeriodType (ID);
CREATE INDEX tblPaymentPeriodType_PeriodTypeCode_idx ON tblPaymentPeriodType (PeriodTypeCode);

CREATE TABLE tblPaymentSubject
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblPaymentSubject_FormID_idx ON tblPaymentSubject (ID);

CREATE TABLE tblPCSetting
 (
	PCID			INTEGER NOT NULL, 
	OpenCashDrawer			INTEGER NOT NULL, 
	CashDrawerSettings			varchar, 
	CashDrawerOutput			varchar, 
	CopyNo			varchar, 
	CopyStartDate			DateTime, 
	CopyEndDate			DateTime, 
	MyDrive			varchar, 
	MyDir			varchar, 
	LastUpdateDate			DateTime, 
	AutoDownloadUpdate			INTEGER NOT NULL, 
	TouchScreen			INTEGER NOT NULL, 
	bilingualDisplay			INTEGER NOT NULL, 
	RegistrationID			INTEGER, 
	PrivateKey			BLOB, 
	PublicKey			BLOB, 
	UpdateStatus			INTEGER, 
	ICV			INTEGER, 
	LocationAddress			varchar, 
	InvoiceSubmitTypeCode			varchar, 
	Secret			TEXT, 
	PIH			TEXT, 
	RequestID			varchar, 
	BinarySecurityToken			TEXT
	, PRIMARY KEY (PCID)
);

-- CREATE INDEXES ...
CREATE UNIQUE INDEX tblPCSetting_FormID_idx ON tblPCSetting (PCID);

CREATE TABLE tblPeriodType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	DayCount			REAL, 
	PeriodTypeCode			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblPeriodType_FormID_idx ON tblPeriodType (ID);
CREATE UNIQUE INDEX tblPeriodType_NameAr_idx ON tblPeriodType (NameAr);
CREATE UNIQUE INDEX tblPeriodType_NameEn_idx ON tblPeriodType (NameEn);
CREATE INDEX tblPeriodType_PeriodTypeCode_idx ON tblPeriodType (PeriodTypeCode);

CREATE TABLE tblPersonalCategory
 (
	AccountID			INTEGER NOT NULL, 
	CategoryID			INTEGER NOT NULL
	, PRIMARY KEY (AccountID, CategoryID)
);

-- CREATE INDEXES ...
CREATE INDEX tblPersonalCategory_AccountID_idx ON tblPersonalCategory (AccountID);
CREATE INDEX tblPersonalCategory_MainCategoryID_idx ON tblPersonalCategory (CategoryID);

CREATE TABLE tblPersonalData
 (
	AccountID			INTEGER NOT NULL, 
	GenderID			INTEGER, 
	ReligionID			INTEGER, 
	BirthDate			DateTime, 
	BirthPlace			varchar, 
	PersonalStatusID			INTEGER, 
	SonCount			INTEGER, 
	EducationMajorID			INTEGER, 
	EducationLevelID			INTEGER, 
	JobID			INTEGER, 
	StartingDate			DateTime, 
	Salary			INTEGER, 
	InsuranceNo			varchar, 
	InsuranceByCompany			INTEGER, 
	InsuranceByEmployee			INTEGER, 
	HousingEquivalent			INTEGER, 
	LiveEquivalent			INTEGER, 
	TransportationEquivalent			INTEGER, 
	EntryNo			varchar, 
	EntryDate			DateTime, 
	EntryPortal			varchar, 
	StayPeriodYear			INTEGER, 
	StayPeriodMonth			INTEGER, 
	SponsorID			INTEGER, 
	WorkAsFirstSaid			INTEGER NOT NULL, 
	WorkDayRate			INTEGER, 
	Runaway			INTEGER, 
	RunawayDate			DateTime, 
	RunawayDocumentImagePath			TEXT, 
	EducationDocumentImagePath			TEXT, 
	SalaryDocumentImagePath			TEXT, 
	EntryDocumentImagePath			TEXT, 
	Address			varchar, 
	PresentPost			varchar, 
	WorkPlace			varchar, 
	AccountNoteID			INTEGER, 
	PO_Box			varchar, 
	PO_Code			varchar, 
	TitleID			INTEGER, 
	PlaceID			INTEGER, 
	ToPrint			INTEGER NOT NULL, 
	WivesNo			INTEGER, 
	PersonalPhotoImagePath			TEXT, 
	ContactPersonID			INTEGER, 
	StudyLevelID			INTEGER, 
	SpecializationID			INTEGER, 
	ManagementID			INTEGER, 
	SectionID			INTEGER, 
	EmployeeTypeID			INTEGER
	, PRIMARY KEY (AccountID)
);

-- CREATE INDEXES ...
CREATE UNIQUE INDEX tblPersonalData_AccountID_idx ON tblPersonalData (AccountID);
CREATE INDEX tblPersonalData_AccountNoteID_idx ON tblPersonalData (AccountNoteID);
CREATE INDEX tblPersonalData_ContactPersonID_idx ON tblPersonalData (ContactPersonID);
CREATE INDEX tblPersonalData_EducationLevelID_idx ON tblPersonalData (EducationLevelID);
CREATE INDEX tblPersonalData_EducationMajorID_idx ON tblPersonalData (EducationMajorID);
CREATE INDEX tblPersonalData_EmployeeTypeID_idx ON tblPersonalData (EmployeeTypeID);
CREATE INDEX tblPersonalData_GenderID_idx ON tblPersonalData (GenderID);
CREATE INDEX tblPersonalData_JobID_idx ON tblPersonalData (JobID);
CREATE INDEX tblPersonalData_ManagementID_idx ON tblPersonalData (ManagementID);
CREATE INDEX tblPersonalData_PersonalStatusID_idx ON tblPersonalData (PersonalStatusID);
CREATE INDEX tblPersonalData_PlaceID_idx ON tblPersonalData (PlaceID);
CREATE INDEX tblPersonalData_PO_Code_idx ON tblPersonalData (PO_Code);
CREATE INDEX tblPersonalData_ReligionID_idx ON tblPersonalData (ReligionID);
CREATE INDEX tblPersonalData_SectionID_idx ON tblPersonalData (SectionID);
CREATE INDEX tblPersonalData_SpecializationID_idx ON tblPersonalData (SpecializationID);
CREATE INDEX tblPersonalData_SponsorID_idx ON tblPersonalData (SponsorID);
CREATE INDEX tblPersonalData_StudyLevelID_idx ON tblPersonalData (StudyLevelID);
CREATE INDEX tblPersonalData_TitleID_idx ON tblPersonalData (TitleID);

CREATE TABLE tblPersonalGroupedCategory
 (
	AccountID			INTEGER NOT NULL, 
	GroupedCategoryID			INTEGER NOT NULL
	, PRIMARY KEY (AccountID, GroupedCategoryID)
);

-- CREATE INDEXES ...
CREATE UNIQUE INDEX tblPersonalGroupedCategory_AccountID_idx ON tblPersonalGroupedCategory (AccountID);
CREATE INDEX tblPersonalGroupedCategory_MainCategoryID_idx ON tblPersonalGroupedCategory (GroupedCategoryID);

CREATE TABLE tblPhoneDirectory
 (
	ID			INTEGER, 
	BranchID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	Address			varchar, 
	NationalityID			INTEGER, 
	WorkPlace			varchar, 
	SexID			INTEGER, 
	ToDealing			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblPhoneDirectory_BranchID_idx ON tblPhoneDirectory (BranchID);
CREATE INDEX tblPhoneDirectory_NationalityID_idx ON tblPhoneDirectory (NationalityID);
CREATE INDEX tblPhoneDirectory_SexID_idx ON tblPhoneDirectory (SexID);

CREATE TABLE tblPhoneDirectoryContact
 (
	PhoneDirectoryID			INTEGER NOT NULL, 
	ContactTypeID			INTEGER NOT NULL, 
	ContactID			varchar NOT NULL, 
	ContactNote			varchar
	, PRIMARY KEY (PhoneDirectoryID, ContactTypeID)
);

-- CREATE INDEXES ...
CREATE INDEX tblPhoneDirectoryContact_DocumentID_idx ON tblPhoneDirectoryContact (ContactID);
CREATE INDEX tblPhoneDirectoryContact_DocumentTypeNo_idx ON tblPhoneDirectoryContact (ContactTypeID);
CREATE INDEX tblPhoneDirectoryContact_TenantID_idx ON tblPhoneDirectoryContact (PhoneDirectoryID);

CREATE TABLE tblPictureData
 (
	ID			INTEGER, 
	PictureDate			varchar, 
	Title			varchar, 
	Occasion			INTEGER, 
	PlaceID			INTEGER, 
	SourceID			INTEGER, 
	OtherInformation			TEXT, 
	ImagePath			TEXT
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblPictureData_ID_idx ON tblPictureData (ID);
CREATE INDEX tblPictureData_PlaceID_idx ON tblPictureData (PlaceID);
CREATE INDEX tblPictureData_SourceID_idx ON tblPictureData (SourceID);

CREATE TABLE tblPictureOccasion
 (
	ID			INTEGER, 
	NameAr			varchar, 
	NameEn			varchar
);

-- CREATE INDEXES ...
CREATE UNIQUE INDEX tblPictureOccasion_ID_idx ON tblPictureOccasion (ID);
CREATE UNIQUE INDEX tblPictureOccasion_NameAr_idx ON tblPictureOccasion (NameAr);

CREATE TABLE tblPicturePerson
 (
	PictureID			INTEGER, 
	PersonID			INTEGER, 
	AbouPerson			varchar
	, PRIMARY KEY (PictureID, PersonID)
);

-- CREATE INDEXES ...
CREATE INDEX tblPicturePerson_PersonID_idx ON tblPicturePerson (PersonID);
CREATE INDEX tblPicturePerson_PictureID_idx ON tblPicturePerson (PictureID);

CREATE TABLE tblPicturePlace
 (
	ID			INTEGER, 
	NameAr			varchar, 
	NameEn			varchar
);

-- CREATE INDEXES ...
CREATE UNIQUE INDEX tblPicturePlace_ID_idx ON tblPicturePlace (ID);
CREATE UNIQUE INDEX tblPicturePlace_NameAr_idx ON tblPicturePlace (NameAr);

CREATE TABLE tblPictureSource
 (
	ID			INTEGER, 
	NameAr			varchar, 
	NameEn			varchar
);

-- CREATE INDEXES ...
CREATE UNIQUE INDEX tblPictureSource_ID_idx ON tblPictureSource (ID);
CREATE UNIQUE INDEX tblPictureSource_NameAr_idx ON tblPictureSource (NameAr);

CREATE TABLE tblPoints
 (
	AccountID			INTEGER, 
	CollectedPoint			REAL, 
	UsedPoint			REAL, 
	StartDate			DateTime, 
	LastPaiedDate			DateTime, 
	LastExchangeDate			DateTime, 
	ExpireDate			DateTime
	, PRIMARY KEY (AccountID)
);

-- CREATE INDEXES ...
CREATE INDEX tblPoints_ID_idx ON tblPoints (AccountID);

CREATE TABLE tblPricingGroup
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	Remark			TEXT, 
	StartDate			DateTime NOT NULL, 
	EndDate			DateTime NOT NULL, 
	ByFraction			INTEGER NOT NULL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tblPricingGroupItem
 (
	PricingGroupID			INTEGER, 
	ItemID			INTEGER, 
	Price			REAL NOT NULL, 
	MinimumPrice			REAL NOT NULL
	, PRIMARY KEY (PricingGroupID, ItemID)
);

-- CREATE INDEXES ...
CREATE INDEX tblPricingGroupItem_ID_idx ON tblPricingGroupItem (ItemID);
CREATE INDEX tblPricingGroupItem_PricingGroupID_idx ON tblPricingGroupItem (PricingGroupID);

CREATE TABLE tblPricingGroupItemForLaundry
 (
	PricingGroupID			INTEGER, 
	ItemID			INTEGER, 
	UrgentTypeID			INTEGER, 
	ServiceTypeID			INTEGER, 
	MaterialTypeID			INTEGER, 
	Price			REAL NOT NULL, 
	MinimumPrice			REAL NOT NULL
	, PRIMARY KEY (PricingGroupID, ItemID, ServiceTypeID, MaterialTypeID, UrgentTypeID)
);

-- CREATE INDEXES ...
CREATE INDEX tblPricingGroupItemForLaundry_ID_idx ON tblPricingGroupItemForLaundry (ItemID);
CREATE INDEX tblPricingGroupItemForLaundry_MaterialTypeID_idx ON tblPricingGroupItemForLaundry (UrgentTypeID);
CREATE INDEX tblPricingGroupItemForLaundry_MerzamTypeID_idx ON tblPricingGroupItemForLaundry (ServiceTypeID);
CREATE INDEX tblPricingGroupItemForLaundry_MerzamTypeID1_idx ON tblPricingGroupItemForLaundry (MaterialTypeID);
CREATE INDEX tblPricingGroupItemForLaundry_PricingGroupID_idx ON tblPricingGroupItemForLaundry (PricingGroupID);

CREATE TABLE tblProcedureType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	GivenGradeID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblProcedureType_DocumentTypeID_idx ON tblProcedureType (ID);
CREATE INDEX tblProcedureType_GivenGradeID_idx ON tblProcedureType (GivenGradeID);
CREATE UNIQUE INDEX tblProcedureType_NameAr_idx ON tblProcedureType (NameAr);
CREATE UNIQUE INDEX tblProcedureType_NameEn_idx ON tblProcedureType (NameEn);

CREATE TABLE tblProgramObject
 (
	ProgramUseTypeID			INTEGER, 
	ObjectID			INTEGER NOT NULL, 
	IsUsed			INTEGER NOT NULL
	, PRIMARY KEY (ProgramUseTypeID, ObjectID)
);

-- CREATE INDEXES ...
CREATE INDEX tblProgramObject_ObjectID_idx ON tblProgramObject (ObjectID);
CREATE INDEX tblProgramObject_ProgramUseTypeID_idx ON tblProgramObject (ProgramUseTypeID);

CREATE TABLE tblProgramReportType
 (
	ProgramUseTypeID			INTEGER, 
	ReportTypeID			INTEGER, 
	IsUsed			INTEGER NOT NULL
	, PRIMARY KEY (ProgramUseTypeID, ReportTypeID)
);

-- CREATE INDEXES ...
CREATE INDEX tblProgramReportType_AccountTypeID_idx ON tblProgramReportType (ReportTypeID);
CREATE INDEX tblProgramReportType_ProgramID_idx ON tblProgramReportType (ProgramUseTypeID);

CREATE TABLE tblProgramSetting
 (
	EstablishmentNameAr			varchar, 
	EstablishmentAddressAr			TEXT, 
	EstablishmentNameEn			varchar, 
	EstablishmentAddressEn			TEXT, 
	ProgramUseTypeID			INTEGER, 
	UseHijriCalendar			INTEGER NOT NULL, 
	RentLeaseConditionAr			TEXT, 
	RentLeaseConditionEn			TEXT, 
	DataPath			varchar, 
	FooterMessage			TEXT, 
	GottenDiscountAccountID			INTEGER, 
	GivenDiscountAccountID			INTEGER, 
	CollectionCommissionAccountID			INTEGER, 
	OtherDataInLabel			varchar, 
	MarketingCommissionAccountID			INTEGER, 
	MarketingCommission			REAL, 
	AssayCommissionAccountID			INTEGER, 
	AssayCommission			REAL, 
	MemberCommissionAccountID			INTEGER, 
	ContractingAccountID			INTEGER, 
	UseMyPoints			INTEGER NOT NULL, 
	MoneyPerPoint			REAL, 
	MoneyPerDay			REAL, 
	MaximamDays			REAL, 
	PointPerMoney			REAL, 
	UseBell			INTEGER NOT NULL, 
	DailyAvgCount			INTEGER, 
	BellCount			INTEGER, 
	SoundPath			varchar, 
	PicturePath			varchar, 
	OpenCashDrawer			INTEGER NOT NULL, 
	CashDrawerSettings			varchar, 
	CashDrawerOutput			varchar, 
	ZeroAndNegative			INTEGER NOT NULL, 
	ShowNegativeBalance			INTEGER NOT NULL, 
	UseFraction			INTEGER NOT NULL, 
	ContractArabicText			TEXT, 
	ContractEnglishText			TEXT, 
	RentAccountID			INTEGER, 
	InsuranceAccountID			INTEGER, 
	HijriCalendarAdjustment			INTEGER, 
	SparePartItemUseTypeID			INTEGER, 
	AmanFundAccountID			INTEGER, 
	ComplexProfitOrLossAccountID			INTEGER, 
	DividendProfitOrLossAccountID			INTEGER, 
	CalendarTypeID			INTEGER, 
	ShareCapitalAccountID			INTEGER, 
	OpenBalanceAccountID			INTEGER, 
	RentTempAccountID			INTEGER, 
	WaterTempAccountID			INTEGER, 
	InsuranceTempAccountID			INTEGER, 
	ClientID			INTEGER, 
	ID			INTEGER, 
	ConsumableCreditorAccountID			INTEGER, 
	ConsumableDebtorAccountID			INTEGER, 
	DefaultBarcodeTypeID			INTEGER, 
	VAT			REAL, 
	VATAccountID			INTEGER, 
	VatTypeID			INTEGER, 
	VATNo			varchar, 
	StreetNameAr			varchar, 
	StreetNameEn			varchar, 
	CityAr			varchar, 
	CityEn			varchar, 
	CountryAlpha2Code			varchar, 
	BuildingNumber			varchar, 
	DistrictAr			varchar, 
	DistrictEn			varchar, 
	PostalCode			varchar, 
	PostalAdditionalNo			varchar, 
	ZATCAIntegrated			INTEGER NOT NULL, 
	BusinessCategory			varchar, 
	Email			varchar, 
	GroupVATNumber			varchar, 
	ReportingTimerHours			INTEGER, 
	TransactionHistoryLifeTimeDays			INTEGER, 
	ZATCAIntegrationStartDate			DateTime
);

-- CREATE INDEXES ...
CREATE INDEX tblProgramSetting_AmanFundAccountID_idx ON tblProgramSetting (ComplexProfitOrLossAccountID);
CREATE INDEX tblProgramSetting_AmanFundِAccountID_idx ON tblProgramSetting (AmanFundAccountID);
CREATE INDEX tblProgramSetting_AssayCommissionAccountID_idx ON tblProgramSetting (MemberCommissionAccountID);
CREATE INDEX tblProgramSetting_ComplexProfitOrLossAccountID1_idx ON tblProgramSetting (ShareCapitalAccountID);
CREATE INDEX tblProgramSetting_ContractingAccountID_idx ON tblProgramSetting (RentAccountID);
CREATE INDEX tblProgramSetting_GivenDiscountAccountID_idx ON tblProgramSetting (GivenDiscountAccountID);
CREATE INDEX tblProgramSetting_GottenDiscountAccountID_idx ON tblProgramSetting (GottenDiscountAccountID);
CREATE INDEX tblProgramSetting_GottenDiscountAccountID1_idx ON tblProgramSetting (CollectionCommissionAccountID);
CREATE INDEX tblProgramSetting_MarketingCommissionAccountID_idx ON tblProgramSetting (MarketingCommissionAccountID);
CREATE INDEX tblProgramSetting_MarketingCommissionAccountID1_idx ON tblProgramSetting (AssayCommissionAccountID);
CREATE INDEX tblProgramSetting_MemberCommissionAccountID_idx ON tblProgramSetting (ContractingAccountID);
CREATE INDEX tblProgramSetting_OwnerRentAccountID_idx ON tblProgramSetting (RentTempAccountID);
CREATE INDEX tblProgramSetting_RentAccountID_idx ON tblProgramSetting (InsuranceAccountID);
CREATE INDEX tblProgramSetting_ShareCapitalAccountID_idx ON tblProgramSetting (OpenBalanceAccountID);
CREATE INDEX tblProgramSetting_SparePartItemUseTypeID_idx ON tblProgramSetting (SparePartItemUseTypeID);
CREATE INDEX tblProgramSetting_tblProgramSettingID_idx ON tblProgramSetting (ID);
CREATE INDEX tblProgramSetting_WaterTempAccountID_idx ON tblProgramSetting (WaterTempAccountID);
CREATE INDEX tblProgramSetting_WaterTempAccountID1_idx ON tblProgramSetting (InsuranceTempAccountID);

CREATE TABLE tblProgramUseType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	FolderName			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblProgramUseType_FormID_idx ON tblProgramUseType (ID);
CREATE UNIQUE INDEX tblProgramUseType_NameAr_idx ON tblProgramUseType (NameAr);
CREATE UNIQUE INDEX tblProgramUseType_NameEn_idx ON tblProgramUseType (NameEn);

CREATE TABLE tblProgramUseTypeAccountType
 (
	ProgramUseTypeID			INTEGER, 
	AccountTypeID			INTEGER, 
	IsUsed			INTEGER NOT NULL
	, PRIMARY KEY (ProgramUseTypeID, AccountTypeID)
);

-- CREATE INDEXES ...
CREATE INDEX tblProgramUseTypeAccountType_AccountTypeID_idx ON tblProgramUseTypeAccountType (AccountTypeID);
CREATE INDEX tblProgramUseTypeAccountType_ProgramID_idx ON tblProgramUseTypeAccountType (ProgramUseTypeID);

CREATE TABLE tblProgramUseTypeCodingGroup
 (
	ProgramUseTypeID			INTEGER NOT NULL, 
	CodingGroupID			INTEGER NOT NULL, 
	IsUsed			INTEGER NOT NULL
	, PRIMARY KEY (ProgramUseTypeID, CodingGroupID)
);

-- CREATE INDEXES ...
CREATE INDEX tblProgramUseTypeCodingGroup_CodingGroupID_idx ON tblProgramUseTypeCodingGroup (CodingGroupID);
CREATE INDEX tblProgramUseTypeCodingGroup_ProgramID_idx ON tblProgramUseTypeCodingGroup (ProgramUseTypeID);

CREATE TABLE tblProgramUseTypeInvoiceType
 (
	ProgramUseTypeID			INTEGER, 
	InvoiceTypeID			INTEGER, 
	IsUsed			INTEGER NOT NULL
	, PRIMARY KEY (ProgramUseTypeID, InvoiceTypeID)
);

-- CREATE INDEXES ...
CREATE INDEX tblProgramUseTypeInvoiceType_AccountTypeID_idx ON tblProgramUseTypeInvoiceType (InvoiceTypeID);
CREATE INDEX tblProgramUseTypeInvoiceType_ProgramID_idx ON tblProgramUseTypeInvoiceType (ProgramUseTypeID);

CREATE TABLE tblProgramUseTypeReceiptSubject
 (
	ProgramUseTypeID			INTEGER, 
	ReceiptSubjectID			INTEGER, 
	IsUsed			INTEGER NOT NULL
	, PRIMARY KEY (ProgramUseTypeID, ReceiptSubjectID)
);

-- CREATE INDEXES ...
CREATE INDEX tblProgramUseTypeReceiptSubject_ProgramID_idx ON tblProgramUseTypeReceiptSubject (ProgramUseTypeID);
CREATE INDEX tblProgramUseTypeReceiptSubject_ReceiptSubjectID_idx ON tblProgramUseTypeReceiptSubject (ReceiptSubjectID);

CREATE TABLE tblQuarter
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	CityID			INTEGER NOT NULL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblQuarter_CityID_idx ON tblQuarter (CityID);
CREATE INDEX tblQuarter_FormID_idx ON tblQuarter (ID);
CREATE UNIQUE INDEX tblQuarter_NameAr_idx ON tblQuarter (NameAr);
CREATE UNIQUE INDEX tblQuarter_NameEn_idx ON tblQuarter (NameEn);

CREATE TABLE tblRealEstate
 (
	BranchID			INTEGER NOT NULL, 
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	QuarterID			INTEGER, 
	Address			varchar, 
	Phone			varchar, 
	Fax			varchar, 
	UnitsCount			INTEGER, 
	CollectionCommission			REAL NOT NULL, 
	OwnerID			INTEGER NOT NULL, 
	OutOfService			INTEGER NOT NULL
	, PRIMARY KEY (BranchID, ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblRealEstate_BranchID_idx ON tblRealEstate (BranchID);
CREATE INDEX tblRealEstate_ID_idx ON tblRealEstate (ID);
CREATE INDEX tblRealEstate_OwnerID_idx ON tblRealEstate (OwnerID);
CREATE INDEX tblRealEstate_QuarterID_idx ON tblRealEstate (QuarterID);

CREATE TABLE tblRealEstateUnit
 (
	BranchID			INTEGER NOT NULL, 
	ID			INTEGER NOT NULL, 
	RealEstateID			INTEGER NOT NULL, 
	NameAr			varchar, 
	NameEn			varchar, 
	UnitTypeID			INTEGER NOT NULL, 
	FloorsCount			INTEGER NOT NULL, 
	RoomsCount			INTEGER, 
	BathroomsCount			INTEGER, 
	kitchensCount			INTEGER, 
	IndependentBoard			INTEGER NOT NULL, 
	OtherSpecifications			varchar, 
	AnnualRent			INTEGER, 
	UnitStatusID			INTEGER, 
	Furniture			varchar, 
	ElectricityMeterNo			varchar, 
	SubscriberNo			varchar, 
	HousingTypeID			INTEGER, 
	Comment			varchar
	, PRIMARY KEY (BranchID, ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblRealEstateUnit_BranchID_idx ON tblRealEstateUnit (BranchID);
CREATE INDEX tblRealEstateUnit_HousingTypeID_idx ON tblRealEstateUnit (HousingTypeID);
CREATE INDEX tblRealEstateUnit_ID_idx ON tblRealEstateUnit (ID);
CREATE INDEX tblRealEstateUnit_RealEstateID_idx ON tblRealEstateUnit (RealEstateID);
CREATE INDEX tblRealEstateUnit_UnitStatusID_idx ON tblRealEstateUnit (UnitStatusID);
CREATE INDEX tblRealEstateUnit_UnitTypeID_idx ON tblRealEstateUnit (UnitTypeID);

CREATE TABLE tblRealEstateUnitAction
 (
	BranchID			INTEGER NOT NULL, 
	ID			INTEGER, 
	UnitID			INTEGER NOT NULL, 
	UnitActionTypeID			INTEGER, 
	StartDate			DateTime, 
	EndDate			DateTime, 
	Note			TEXT
	, PRIMARY KEY (BranchID, ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblRealEstateUnitAction_BranchID_idx ON tblRealEstateUnitAction (BranchID);
CREATE INDEX tblRealEstateUnitAction_ID_idx ON tblRealEstateUnitAction (UnitID);
CREATE INDEX tblRealEstateUnitAction_ID1_idx ON tblRealEstateUnitAction (ID);
CREATE INDEX tblRealEstateUnitAction_UnitActionTypeID_idx ON tblRealEstateUnitAction (UnitActionTypeID);

CREATE TABLE tblRealEstateUnitPrice
 (
	BranchID			INTEGER NOT NULL, 
	UnitID			INTEGER NOT NULL, 
	RentTypeID			INTEGER, 
	NormalPrice			INTEGER, 
	SeasonPrice			INTEGER
	, PRIMARY KEY (BranchID, UnitID, RentTypeID)
);

-- CREATE INDEXES ...
CREATE INDEX tblRealEstateUnitPrice_BranchID_idx ON tblRealEstateUnitPrice (BranchID);
CREATE INDEX tblRealEstateUnitPrice_ID_idx ON tblRealEstateUnitPrice (UnitID);
CREATE INDEX tblRealEstateUnitPrice_RentTypeID_idx ON tblRealEstateUnitPrice (RentTypeID);

CREATE TABLE tblReceiptCancellation
 (
	RecieptID			varchar NOT NULL, 
	CancellationDate			DateTime, 
	CancellationReason			varchar
	, PRIMARY KEY (RecieptID)
);

-- CREATE INDEXES ...
CREATE INDEX tblReceiptCancellation_ID_idx ON tblReceiptCancellation (RecieptID);

CREATE TABLE tblReceiptInstallment
 (
	ReceiptID			varchar, 
	BranchID			INTEGER, 
	InstallmentPlanID			INTEGER NOT NULL, 
	InstallmentID			INTEGER, 
	Amount			REAL, 
	Remark			varchar
	, PRIMARY KEY (ReceiptID, BranchID, InstallmentPlanID, InstallmentID)
);

-- CREATE INDEXES ...
CREATE INDEX tblReceiptInstallment_BranchID_idx ON tblReceiptInstallment (BranchID);
CREATE INDEX tblReceiptInstallment_ID_idx ON tblReceiptInstallment (InstallmentID);
CREATE INDEX tblReceiptInstallment_InstallmentPlanID_idx ON tblReceiptInstallment (InstallmentPlanID);
CREATE INDEX tblReceiptInstallment_ReceiptID_idx ON tblReceiptInstallment (ReceiptID);

CREATE TABLE tblReceiptInvoice
 (
	ReceiptID			varchar NOT NULL, 
	InvoiceID			varchar NOT NULL, 
	Amount			REAL NOT NULL
	, PRIMARY KEY (InvoiceID, ReceiptID)
);

-- CREATE INDEXES ...
CREATE INDEX tblReceiptInvoice_ID_idx ON tblReceiptInvoice (InvoiceID);
CREATE INDEX tblReceiptInvoice_MoneyTransactionID_idx ON tblReceiptInvoice (ReceiptID);

CREATE TABLE tblReceiptManagementLease
 (
	BranchID			INTEGER NOT NULL, 
	ReceiptID			varchar NOT NULL, 
	LeaseID			INTEGER NOT NULL, 
	Amount			REAL NOT NULL
	, PRIMARY KEY (BranchID, ReceiptID, LeaseID)
);

-- CREATE INDEXES ...
CREATE INDEX tblReceiptManagementLease_BranchID_idx ON tblReceiptManagementLease (BranchID);
CREATE INDEX tblReceiptManagementLease_ID1_idx ON tblReceiptManagementLease (ReceiptID);
CREATE INDEX tblReceiptManagementLease_LeaseID_idx ON tblReceiptManagementLease (LeaseID);

CREATE TABLE tblReceiptRentLease
 (
	BranchID			INTEGER NOT NULL, 
	ReceiptID			varchar NOT NULL, 
	LeaseID			INTEGER NOT NULL, 
	Amount			REAL
	, PRIMARY KEY (BranchID, ReceiptID, LeaseID)
);

-- CREATE INDEXES ...
CREATE INDEX tblReceiptRentLease_BranchID_idx ON tblReceiptRentLease (BranchID);
CREATE INDEX tblReceiptRentLease_ID1_idx ON tblReceiptRentLease (ReceiptID);
CREATE INDEX tblReceiptRentLease_LeaseID_idx ON tblReceiptRentLease (LeaseID);

CREATE TABLE tblReceiptReportType
 (
	ReportName			varchar, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ReportName)
);

-- CREATE INDEXES ...
CREATE UNIQUE INDEX tblReceiptReportType_NameAr_idx ON tblReceiptReportType (NameAr);
CREATE UNIQUE INDEX tblReceiptReportType_NameEn_idx ON tblReceiptReportType (NameEn);

CREATE TABLE tblReceiptType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	ObjectID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblReceiptType_FormID_idx ON tblReceiptType (ID);

CREATE TABLE tblReceiptTypeObject
 (
	ObjectID			INTEGER, 
	ReceiptTypeID			INTEGER, 
	dummy			INTEGER
	, PRIMARY KEY (ObjectID)
);

-- CREATE INDEXES ...
CREATE INDEX tblReceiptTypeObject_ObjectID_idx ON tblReceiptTypeObject (ObjectID);
CREATE INDEX tblReceiptTypeObject_ReceiptTypeID_idx ON tblReceiptTypeObject (ReceiptTypeID);

CREATE TABLE tblReceivedOutsideSearchReport
 (
	ID			INTEGER, 
	YearID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblReceivedOutsideSearchReport_ID_idx ON tblReceivedOutsideSearchReport (ID);
CREATE INDEX tblReceivedOutsideSearchReport_YearID_idx ON tblReceivedOutsideSearchReport (YearID);

CREATE TABLE tblReceivedOutsideSearchReportList
 (
	ReceivedOutsideSearchReportID			INTEGER, 
	StudentAccountID			INTEGER NOT NULL, 
	ApprovedCourseID			INTEGER NOT NULL, 
	Notes			varchar, 
	ReceivedDate			DateTime
	, PRIMARY KEY (ReceivedOutsideSearchReportID, StudentAccountID, ApprovedCourseID)
);

-- CREATE INDEXES ...
CREATE INDEX tblReceivedOutsideSearchReportList_ApprovedCourseID_idx ON tblReceivedOutsideSearchReportList (ApprovedCourseID);
CREATE INDEX tblReceivedOutsideSearchReportList_ReceivedOutsideSearchReportID_idx ON tblReceivedOutsideSearchReportList (ReceivedOutsideSearchReportID);
CREATE INDEX tblReceivedOutsideSearchReportList_StudentAccountID_idx ON tblReceivedOutsideSearchReportList (StudentAccountID);

CREATE TABLE tblRegistration
 (
	ID			INTEGER, 
	CPUID			varchar, 
	EstablishmentNameAr			varchar, 
	EstablishmentNameEn			varchar, 
	EstablishmentAddressAr			varchar, 
	EstablishmentAddressEn			varchar, 
	WarrantyStartDate			DateTime, 
	WarrantyPeriod			REAL, 
	BranchID			INTEGER, 
	BranchNameAr			varchar, 
	BranchNameEn			varchar, 
	PCID			INTEGER, 
	PCNameAr			varchar, 
	PCNameEn			varchar, 
	ProgramVersion			varchar, 
	ProgramUseType			varchar, 
	ProgramUseTypeNameAr			varchar, 
	ProgramUseTypeNameEn			varchar, 
	CTITUserID			INTEGER, 
	ClientName			varchar, 
	ClientMobile			varchar, 
	ClientWhatsApp			varchar, 
	ClientEmail			varchar, 
	PaymentMethod			varchar, 
	DistributorName			varchar, 
	PublicKeyBytes			BLOB, 
	CertificateBytes			BLOB
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tblRegistrationStatus
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblRegistrationStatus_FormID_idx ON tblRegistrationStatus (ID);
CREATE UNIQUE INDEX tblRegistrationStatus_NameAr_idx ON tblRegistrationStatus (NameAr);
CREATE UNIQUE INDEX tblRegistrationStatus_NameEn_idx ON tblRegistrationStatus (NameEn);

CREATE TABLE tblRentLease
 (
	BranchID			INTEGER NOT NULL, 
	ID			INTEGER NOT NULL, 
	UnitID			INTEGER NOT NULL, 
	TenantID			INTEGER NOT NULL, 
	LeaseDate			DateTime, 
	StartDate			DateTime NOT NULL, 
	Rent			REAL, 
	Insurance			REAL, 
	Water			REAL, 
	AdditionalConditions			TEXT, 
	LastPaymentDate			DateTime, 
	LastPaymentUntilDate			DateTime, 
	EndDate			DateTime, 
	UnitStatusID			INTEGER, 
	LastPaymentStartDate			DateTime, 
	MoneyTransactionID			varchar, 
	ReservationID			INTEGER, 
	RentTypeID			INTEGER, 
	DurationCount			INTEGER, 
	PaymentMethodID			INTEGER NOT NULL, 
	PaymentPeriodType			INTEGER, 
	PaymentPeriodCount			INTEGER, 
	HousingTypeID			INTEGER, 
	UserID			INTEGER, 
	PaymentsCount			INTEGER NOT NULL, 
	DurationMonthCount			INTEGER, 
	Seeking			REAL, 
	IsRentBeforeManagement			INTEGER NOT NULL, 
	KeepInsuranceWithOwner			INTEGER NOT NULL, 
	CalendarTypeID			INTEGER, 
	SendSMS			INTEGER NOT NULL, 
	VAT			REAL, 
	VATValue			REAL, 
	IsVATed			INTEGER NOT NULL
	, PRIMARY KEY (BranchID, ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblRentLease_BranchID_idx ON tblRentLease (BranchID);
CREATE INDEX tblRentLease_CalendarTypeID_idx ON tblRentLease (CalendarTypeID);
CREATE INDEX tblRentLease_HousingTypeID_idx ON tblRentLease (HousingTypeID);
CREATE INDEX tblRentLease_ID_idx ON tblRentLease (UnitID);
CREATE INDEX tblRentLease_ID1_idx ON tblRentLease (ID);
CREATE INDEX tblRentLease_MoneyTransactionID_idx ON tblRentLease (MoneyTransactionID);
CREATE INDEX tblRentLease_PaymentMethodID_idx ON tblRentLease (PaymentMethodID);
CREATE INDEX tblRentLease_RentTypeID_idx ON tblRentLease (RentTypeID);
CREATE INDEX tblRentLease_ReservationID_idx ON tblRentLease (ReservationID);
CREATE INDEX tblRentLease_TenantID_idx ON tblRentLease (TenantID);
CREATE INDEX tblRentLease_UnitStatusID_idx ON tblRentLease (UnitStatusID);
CREATE INDEX tblRentLease_UserID_idx ON tblRentLease (UserID);

CREATE TABLE tblRentLease_Hotel
 (
	BranchID			INTEGER NOT NULL, 
	ID			INTEGER NOT NULL, 
	UnitID			INTEGER NOT NULL, 
	TenantID			INTEGER NOT NULL, 
	LeaseDate			DateTime, 
	StartDate			DateTime NOT NULL, 
	DurationMonthCount			INTEGER, 
	Rent			REAL, 
	Insurance			REAL, 
	AdditionalConditions			TEXT, 
	LastPaymentDate			DateTime, 
	LastPaymentUntilDate			DateTime, 
	EndDate			DateTime, 
	UnitStatusID			INTEGER, 
	LastPaymentStartDate			DateTime, 
	MoneyTransactionID			varchar, 
	VAT			REAL, 
	VATValue			REAL, 
	VatTypeID			INTEGER
	, PRIMARY KEY (BranchID, ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblRentLease_Hotel_BranchID_idx ON tblRentLease_Hotel (BranchID);
CREATE INDEX tblRentLease_Hotel_ID_idx ON tblRentLease_Hotel (UnitID);
CREATE INDEX tblRentLease_Hotel_ID1_idx ON tblRentLease_Hotel (ID);
CREATE INDEX tblRentLease_Hotel_MoneyTransactionID_idx ON tblRentLease_Hotel (MoneyTransactionID);
CREATE INDEX tblRentLease_Hotel_TenantID_idx ON tblRentLease_Hotel (TenantID);
CREATE INDEX tblRentLease_Hotel_UnitStatusID_idx ON tblRentLease_Hotel (UnitStatusID);

CREATE TABLE tblRentLeaseAttendant
 (
	BranchID			INTEGER NOT NULL, 
	ID			INTEGER NOT NULL, 
	AttendantID			INTEGER NOT NULL
	, PRIMARY KEY (BranchID, ID, AttendantID)
);

-- CREATE INDEXES ...
CREATE INDEX tblRentLeaseAttendant_AttendantID_idx ON tblRentLeaseAttendant (AttendantID);
CREATE INDEX tblRentLeaseAttendant_BranchID_idx ON tblRentLeaseAttendant (BranchID);
CREATE INDEX tblRentLeaseAttendant_ID1_idx ON tblRentLeaseAttendant (ID);

CREATE TABLE tblRentLeaseCancellation
 (
	BranchID			INTEGER NOT NULL, 
	RentLeaseID			INTEGER NOT NULL, 
	CancellationDate			DateTime, 
	CancellationReason			varchar, 
	MoneyTransactionID			varchar NOT NULL
	, PRIMARY KEY (BranchID, RentLeaseID)
);

-- CREATE INDEXES ...
CREATE INDEX tblRentLeaseCancellation_BranchID_idx ON tblRentLeaseCancellation (BranchID);
CREATE INDEX tblRentLeaseCancellation_ID_idx ON tblRentLeaseCancellation (RentLeaseID);
CREATE UNIQUE INDEX tblRentLeaseCancellation_MoneyTransactionID_idx ON tblRentLeaseCancellation (BranchID, MoneyTransactionID);

CREATE TABLE tblRentLeaseRenewal
 (
	BranchID			INTEGER NOT NULL, 
	ID			INTEGER NOT NULL, 
	LeaseID			INTEGER NOT NULL, 
	DurationByMonth			INTEGER NOT NULL, 
	DurationByDay			INTEGER NOT NULL, 
	LastPaymentUntilDate			DateTime, 
	LastPaymentStartDate			DateTime, 
	MoneyTransactionID			varchar NOT NULL, 
	Rent			REAL, 
	Water			REAL, 
	Commission			REAL, 
	RenewalDate			DateTime, 
	DurationCount			INTEGER, 
	PaymentPeriodType			INTEGER, 
	PaymentPeriodCount			INTEGER, 
	VAT			REAL, 
	VATValue			REAL, 
	VatTypeID			INTEGER
	, PRIMARY KEY (BranchID, ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblRentLeaseRenewal_BranchID_idx ON tblRentLeaseRenewal (BranchID);
CREATE INDEX tblRentLeaseRenewal_ID1_idx ON tblRentLeaseRenewal (ID);
CREATE INDEX tblRentLeaseRenewal_LeaseID_idx ON tblRentLeaseRenewal (LeaseID);
CREATE UNIQUE INDEX tblRentLeaseRenewal_MoneyTransactionID_idx ON tblRentLeaseRenewal (MoneyTransactionID, BranchID);

CREATE TABLE tblRentLeaseRenewalCancellation
 (
	BranchID			INTEGER NOT NULL, 
	RentLeaseRenewalID			INTEGER NOT NULL, 
	CancellationDate			DateTime, 
	CancellationReason			varchar
	, PRIMARY KEY (BranchID, RentLeaseRenewalID)
);

-- CREATE INDEXES ...
CREATE INDEX tblRentLeaseRenewalCancellation_BranchID_idx ON tblRentLeaseRenewalCancellation (BranchID);
CREATE INDEX tblRentLeaseRenewalCancellation_ID_idx ON tblRentLeaseRenewalCancellation (RentLeaseRenewalID);

CREATE TABLE tblRentLeaseRenewalPaymentSubject
 (
	BranchID			INTEGER NOT NULL, 
	RentLeaseRenewalID			INTEGER NOT NULL, 
	PaymentSubjectID			INTEGER NOT NULL, 
	Amount			REAL NOT NULL
	, PRIMARY KEY (BranchID, RentLeaseRenewalID, PaymentSubjectID)
);

-- CREATE INDEXES ...
CREATE INDEX tblRentLeaseRenewalPaymentSubject_BranchID_idx ON tblRentLeaseRenewalPaymentSubject (BranchID);
CREATE INDEX tblRentLeaseRenewalPaymentSubject_ID1_idx ON tblRentLeaseRenewalPaymentSubject (RentLeaseRenewalID);
CREATE INDEX tblRentLeaseRenewalPaymentSubject_PaymentTypeID_idx ON tblRentLeaseRenewalPaymentSubject (PaymentSubjectID);

CREATE TABLE tblRentLeaseRenewalPeriodCancellation
 (
	BranchID			INTEGER NOT NULL, 
	RentLeaseRenewalID			INTEGER NOT NULL, 
	CancellationDate			DateTime, 
	CancellationReason			varchar, 
	DurationByMonth			INTEGER NOT NULL, 
	DurationByDay			INTEGER NOT NULL, 
	LastPaymentUntilDate			DateTime, 
	LastPaymentStartDate			DateTime, 
	MoneyTransactionID			varchar NOT NULL, 
	Rent			REAL, 
	Water			REAL, 
	Commission			REAL, 
	ReturnPeriodType			INTEGER, 
	ReturnPeriodCount			INTEGER
	, PRIMARY KEY (BranchID, RentLeaseRenewalID)
);

-- CREATE INDEXES ...
CREATE INDEX tblRentLeaseRenewalPeriodCancellation_BranchID_idx ON tblRentLeaseRenewalPeriodCancellation (BranchID);
CREATE UNIQUE INDEX tblRentLeaseRenewalPeriodCancellation_MoneyTransactionID_idx ON tblRentLeaseRenewalPeriodCancellation (MoneyTransactionID, BranchID);
CREATE INDEX tblRentLeaseRenewalPeriodCancellation_RentLeaseRenewalID_idx ON tblRentLeaseRenewalPeriodCancellation (RentLeaseRenewalID);

CREATE TABLE tblRentType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	DayCount			REAL, 
	PeriodTypeCode			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblRentType_FormID_idx ON tblRentType (ID);
CREATE UNIQUE INDEX tblRentType_NameAr_idx ON tblRentType (NameAr);
CREATE UNIQUE INDEX tblRentType_NameEn_idx ON tblRentType (NameEn);
CREATE INDEX tblRentType_PeriodTypeCode_idx ON tblRentType (PeriodTypeCode);

CREATE TABLE tblReportType
 (
	ID			INTEGER, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	ReportName			varchar, 
	ReportTypeGroupID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblReportType_ID_idx ON tblReportType (ID);
CREATE UNIQUE INDEX tblReportType_NameAr_idx ON tblReportType (NameAr);
CREATE UNIQUE INDEX tblReportType_NameEn_idx ON tblReportType (NameEn);
CREATE INDEX tblReportType_ReportTypeGroupID_idx ON tblReportType (ReportTypeGroupID);

CREATE TABLE tblReportTypeGroup
 (
	ID			INTEGER, 
	NameAr			varchar, 
	NameEn			varchar, 
	ObjecTID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblReportTypeGroup_ID_idx ON tblReportTypeGroup (ID);
CREATE INDEX tblReportTypeGroup_ObjecTID_idx ON tblReportTypeGroup (ObjecTID);

CREATE TABLE tblReportTypeObject
 (
	ReportTypeID			INTEGER, 
	ObjectID			INTEGER, 
	IsUsed			INTEGER NOT NULL
	, PRIMARY KEY (ObjectID, ReportTypeID)
);

-- CREATE INDEXES ...
CREATE INDEX tblReportTypeObject_ObjectID_idx ON tblReportTypeObject (ObjectID);

CREATE TABLE tblRequiredUnit
 (
	BranchID			INTEGER NOT NULL, 
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	UnitTypeID			INTEGER NOT NULL, 
	FloorsCount			INTEGER NOT NULL, 
	RoomsCount			INTEGER, 
	BathroomsCount			INTEGER, 
	kitchensCount			INTEGER, 
	IndependentBoard			INTEGER NOT NULL, 
	OtherSpecifications			varchar, 
	AnnualRentFrom			INTEGER, 
	AnnualRentTo			INTEGER, 
	UnitStatusID			INTEGER, 
	Furniture			varchar, 
	HousingTypeID			INTEGER, 
	Comment			varchar
	, PRIMARY KEY (BranchID, ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblRequiredUnit_BranchID_idx ON tblRequiredUnit (BranchID);
CREATE INDEX tblRequiredUnit_HousingTypeID_idx ON tblRequiredUnit (HousingTypeID);
CREATE INDEX tblRequiredUnit_ID_idx ON tblRequiredUnit (ID);
CREATE INDEX tblRequiredUnit_IndependentBoard_idx ON tblRequiredUnit (IndependentBoard);
CREATE INDEX tblRequiredUnit_UnitStatusID_idx ON tblRequiredUnit (UnitStatusID);
CREATE INDEX tblRequiredUnit_UnitTypeID_idx ON tblRequiredUnit (UnitTypeID);

CREATE TABLE tblRequiredUnitQuarter
 (
	BranchID			INTEGER NOT NULL, 
	RequiredUnitID			INTEGER NOT NULL, 
	QuarterID			INTEGER NOT NULL
	, PRIMARY KEY (BranchID, RequiredUnitID, QuarterID)
);

-- CREATE INDEXES ...
CREATE INDEX tblRequiredUnitQuarter_BranchID_idx ON tblRequiredUnitQuarter (BranchID);
CREATE INDEX tblRequiredUnitQuarter_ID_idx ON tblRequiredUnitQuarter (RequiredUnitID);
CREATE INDEX tblRequiredUnitQuarter_QuarterID_idx ON tblRequiredUnitQuarter (QuarterID);

CREATE TABLE tblReservation
 (
	ID			INTEGER, 
	BranchID			INTEGER NOT NULL, 
	UnitID			INTEGER NOT NULL, 
	ReservationDate			DateTime, 
	RentTypeID			INTEGER, 
	StartDate			DateTime, 
	EndDate			DateTime, 
	RentPrice			REAL, 
	RequiredAdvancedSum			REAL, 
	ConfirmationTypeID			INTEGER, 
	UserID			INTEGER, 
	ReservationStatusID			INTEGER, 
	CustomerID			INTEGER, 
	ReservationTypeID			INTEGER, 
	Note			TEXT
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblReservation_BranchID_idx ON tblReservation (BranchID);
CREATE INDEX tblReservation_ConfirmationTypeID_idx ON tblReservation (ConfirmationTypeID);
CREATE INDEX tblReservation_CustomerID_idx ON tblReservation (CustomerID);
CREATE INDEX tblReservation_ID_idx ON tblReservation (ID);
CREATE INDEX tblReservation_RentTypeID_idx ON tblReservation (RentTypeID);
CREATE INDEX tblReservation_ReservationStatusID_idx ON tblReservation (ReservationStatusID);
CREATE INDEX tblReservation_ReservationTypeID_idx ON tblReservation (ReservationTypeID);
CREATE INDEX tblReservation_UnitID_idx ON tblReservation (UnitID);
CREATE INDEX tblReservation_UserID_idx ON tblReservation (UserID);

CREATE TABLE tblReservationStatus
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblReservationStatus_FormID_idx ON tblReservationStatus (ID);
CREATE UNIQUE INDEX tblReservationStatus_NameAr_idx ON tblReservationStatus (NameAr);
CREATE UNIQUE INDEX tblReservationStatus_NameEn_idx ON tblReservationStatus (NameEn);

CREATE TABLE tblResthouse_RentLease
 (
	BranchID			INTEGER NOT NULL, 
	ID			INTEGER NOT NULL, 
	UnitID			INTEGER NOT NULL, 
	LeaseDate			DateTime, 
	TenantID			INTEGER NOT NULL, 
	HousingTypeID			INTEGER, 
	AdditionalConditions			TEXT, 
	Rent			REAL, 
	Insurance			REAL, 
	ReservationID			INTEGER, 
	UserID			INTEGER, 
	MoneyTransactionID			varchar NOT NULL, 
	VAT			REAL, 
	VATValue			REAL, 
	VatTypeID			INTEGER
	, PRIMARY KEY (BranchID, ID)
);

-- CREATE INDEXES ...
CREATE UNIQUE INDEX tblResthouse_RentLease_MoneyTransactionID_idx ON tblResthouse_RentLease (MoneyTransactionID);
CREATE INDEX tblResthouse_RentLease_tblResthouse_RentLeaseBranchID_idx ON tblResthouse_RentLease (BranchID);
CREATE INDEX tblResthouse_RentLease_tblResthouse_RentLeaseID_idx ON tblResthouse_RentLease (ID);

CREATE TABLE tblResthouse_RentLeaseCancellation
 (
	BranchID			INTEGER NOT NULL, 
	ResthouseRentLeaseID			INTEGER NOT NULL, 
	CancellationDate			DateTime, 
	CancellationReason			varchar, 
	MulctAmount			REAL, 
	MoneyTransactionID			varchar NOT NULL
	, PRIMARY KEY (BranchID, ResthouseRentLeaseID)
);

-- CREATE INDEXES ...
CREATE INDEX tblResthouse_RentLeaseCancellation_BranchID_idx ON tblResthouse_RentLeaseCancellation (BranchID);
CREATE INDEX tblResthouse_RentLeaseCancellation_ID_idx ON tblResthouse_RentLeaseCancellation (ResthouseRentLeaseID);
CREATE UNIQUE INDEX tblResthouse_RentLeaseCancellation_MoneyTransactionID_idx ON tblResthouse_RentLeaseCancellation (BranchID, MoneyTransactionID);

CREATE TABLE tblRestHouse_RentLeaseRentGroup
 (
	ID			INTEGER, 
	BranchID			INTEGER NOT NULL, 
	RestHouseRentLeaseID			INTEGER NOT NULL, 
	RentGroupID			INTEGER NOT NULL, 
	RentDate			DateTime NOT NULL, 
	Price			REAL, 
	VAT			REAL, 
	VATValue			REAL, 
	VatTypeID			INTEGER, 
	StartTime			DateTime, 
	EndTime			DateTime
	, PRIMARY KEY (ID, BranchID)
);

-- CREATE INDEXES ...
CREATE INDEX tblRestHouse_RentLeaseRentGroup_BranchID_idx ON tblRestHouse_RentLeaseRentGroup (BranchID);
CREATE INDEX tblRestHouse_RentLeaseRentGroup_ID_idx ON tblRestHouse_RentLeaseRentGroup (ID);
CREATE INDEX tblRestHouse_RentLeaseRentGroup_RentDate_idx ON tblRestHouse_RentLeaseRentGroup (RentDate);
CREATE INDEX tblRestHouse_RentLeaseRentGroup_RentGroupID_idx ON tblRestHouse_RentLeaseRentGroup (RentGroupID);
CREATE UNIQUE INDEX tblRestHouse_RentLeaseRentGroup_SecandryKey_idx ON tblRestHouse_RentLeaseRentGroup (BranchID, RestHouseRentLeaseID, RentGroupID, RentDate);

CREATE TABLE tblRestHouse_SeasonRentGroup
 (
	ID			INTEGER NOT NULL, 
	SeasonID			INTEGER, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	StartTime			DateTime, 
	EndTime			DateTime, 
	Price			REAL, 
	StartTimeText			varchar, 
	EndTimeText			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblRestHouse_SeasonRentGroup_SeasonID_idx ON tblRestHouse_SeasonRentGroup (SeasonID);
CREATE UNIQUE INDEX tblRestHouse_SeasonRentGroup_SeasonNameAr_idx ON tblRestHouse_SeasonRentGroup (SeasonID, NameAr);
CREATE UNIQUE INDEX tblRestHouse_SeasonRentGroup_SeasonNameEn_idx ON tblRestHouse_SeasonRentGroup (SeasonID, NameEn);

CREATE TABLE tblRestHouse_SeasonRentGroupPeriod
 (
	RestHouseSeasonRentGroupID			INTEGER NOT NULL, 
	RestHouseRentPeriodID			INTEGER
	, PRIMARY KEY (RestHouseSeasonRentGroupID, RestHouseRentPeriodID)
);

-- CREATE INDEXES ...
CREATE INDEX tblRestHouse_SeasonRentGroupPeriod_FormID_idx ON tblRestHouse_SeasonRentGroupPeriod (RestHouseSeasonRentGroupID);
CREATE INDEX tblRestHouse_SeasonRentGroupPeriod_RestHousePeriodId_idx ON tblRestHouse_SeasonRentGroupPeriod (RestHouseRentPeriodID);

CREATE TABLE tblRestHouse_SeasonService
 (
	SeasonID			INTEGER, 
	ServiceTypeID			INTEGER NOT NULL, 
	Price			REAL
	, PRIMARY KEY (SeasonID, ServiceTypeID)
);

-- CREATE INDEXES ...

CREATE TABLE tblRestHouse_Setting
 (
	RentInsurance			REAL, 
	SendMessageInRegistration			INTEGER NOT NULL, 
	SendMessageBefore			INTEGER, 
	MessageText			TEXT, 
	RentLeaseCancellationMulctAccountID			INTEGER, 
	RentLeaseCancellationMulct			REAL, 
	StudySeasonID			INTEGER, 
	WeekendSeasonID			INTEGER
);

-- CREATE INDEXES ...
CREATE INDEX tblRestHouse_Setting_StudySeasonID_idx ON tblRestHouse_Setting (StudySeasonID);
CREATE INDEX tblRestHouse_Setting_StudySeasonID1_idx ON tblRestHouse_Setting (WeekendSeasonID);

CREATE TABLE tblRestHouseRentPeriod
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	StartTime			DateTime, 
	EndTime			DateTime, 
	StartTimeText			varchar, 
	EndTimeText			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblRestHouseRentPeriod_FormID_idx ON tblRestHouseRentPeriod (ID);
CREATE UNIQUE INDEX tblRestHouseRentPeriod_NameAr_idx ON tblRestHouseRentPeriod (NameAr);
CREATE UNIQUE INDEX tblRestHouseRentPeriod_NameEn_idx ON tblRestHouseRentPeriod (NameEn);

CREATE TABLE tblSalary
 (
	AccountID			INTEGER NOT NULL, 
	SalaryYear			INTEGER NOT NULL, 
	SalaryMonth			INTEGER NOT NULL, 
	Salary			INTEGER, 
	SalaryHousingEquivalent			INTEGER, 
	SalaryLiveEquivalent			INTEGER, 
	InsuranceByCompany			INTEGER, 
	InsuranceByEmployee			INTEGER, 
	SalaryTransportationEquivalent			INTEGER, 
	LoanNo			INTEGER, 
	LoanPayment			INTEGER, 
	PolicyNo			varchar, 
	DocumentImagePath			TEXT
	, PRIMARY KEY (AccountID, SalaryYear, SalaryMonth)
);

-- CREATE INDEXES ...
CREATE INDEX tblSalary_EmployeeNo_idx ON tblSalary (AccountID);
CREATE INDEX tblSalary_LoanNo_idx ON tblSalary (LoanNo);
CREATE UNIQUE INDEX tblSalary_PolicyNo_idx ON tblSalary (PolicyNo);
CREATE INDEX tblSalary_SalaryMonth_idx ON tblSalary (SalaryMonth);
CREATE INDEX tblSalary_SalaryYear_idx ON tblSalary (SalaryYear);

CREATE TABLE tblSeason
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	IsUsed			INTEGER NOT NULL, 
	ColorID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tblSeasonPeriod
 (
	ID			INTEGER NOT NULL, 
	SeasonID			INTEGER, 
	StartDate			DateTime, 
	EndDate			DateTime
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblSeasonPeriod_FormID_idx ON tblSeasonPeriod (ID);
CREATE INDEX tblSeasonPeriod_SeasonID_idx ON tblSeasonPeriod (SeasonID);

CREATE TABLE tblSeasonPeriodOLD
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	StartDate			DateTime, 
	EndDate			DateTime
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblSeasonPeriodOLD_FormID_idx ON tblSeasonPeriodOLD (ID);
CREATE UNIQUE INDEX tblSeasonPeriodOLD_NameAr_idx ON tblSeasonPeriodOLD (NameAr);
CREATE UNIQUE INDEX tblSeasonPeriodOLD_NameEn_idx ON tblSeasonPeriodOLD (NameEn);

CREATE TABLE tblSeasonsOfficialWorking
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	StartTime			DateTime, 
	EndTime			DateTime
);

-- CREATE INDEXES ...
CREATE UNIQUE INDEX tblSeasonsOfficialWorking_ID_idx ON tblSeasonsOfficialWorking (ID);
CREATE UNIQUE INDEX tblSeasonsOfficialWorking_NameAr_idx ON tblSeasonsOfficialWorking (NameAr);
CREATE UNIQUE INDEX tblSeasonsOfficialWorking_NameEn_idx ON tblSeasonsOfficialWorking (NameEn);

CREATE TABLE tblSection
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblSection_FormID_idx ON tblSection (ID);
CREATE UNIQUE INDEX tblSection_NameAr_idx ON tblSection (NameAr);
CREATE UNIQUE INDEX tblSection_NameEn_idx ON tblSection (NameEn);

CREATE TABLE tblSetting
 (
	DataBaseName			varchar, 
	ProgramFolderName			varchar, 
	DataBasePath			varchar, 
	LastCopySize			REAL
);

-- CREATE INDEXES ...

CREATE TABLE tblShiftWorkPeriod
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	StartTime			DateTime, 
	EndTime			DateTime
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblShiftWorkPeriod_FormID_idx ON tblShiftWorkPeriod (ID);
CREATE UNIQUE INDEX tblShiftWorkPeriod_NameAr_idx ON tblShiftWorkPeriod (NameAr);
CREATE UNIQUE INDEX tblShiftWorkPeriod_NameEn_idx ON tblShiftWorkPeriod (NameEn);

CREATE TABLE tblSickenStatuse
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar NOT NULL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE UNIQUE INDEX tblSickenStatuse_PationCaseNo_idx ON tblSickenStatuse (ID);

CREATE TABLE tblSMSMessageAccountDocument
 (
	ID			INTEGER, 
	AccountDocumentID			INTEGER, 
	SMSMessageTypeID			INTEGER, 
	SMSMessageRecordID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblSMSMessageAccountDocument_AccountDocumentID_idx ON tblSMSMessageAccountDocument (AccountDocumentID);
CREATE INDEX tblSMSMessageAccountDocument_ID_idx ON tblSMSMessageAccountDocument (ID);
CREATE INDEX tblSMSMessageAccountDocument_SMSMessageTypeID_idx ON tblSMSMessageAccountDocument (SMSMessageTypeID);

CREATE TABLE tblSMSMessageCompanyDocument
 (
	ID			INTEGER, 
	CompanyDocumentID			INTEGER, 
	SMSMessageTypeID			INTEGER, 
	SMSMessageRecordID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblSMSMessageCompanyDocument_AccountDocumentID_idx ON tblSMSMessageCompanyDocument (CompanyDocumentID);
CREATE INDEX tblSMSMessageCompanyDocument_ID_idx ON tblSMSMessageCompanyDocument (ID);
CREATE INDEX tblSMSMessageCompanyDocument_SMSMessageTypeID_idx ON tblSMSMessageCompanyDocument (SMSMessageTypeID);

CREATE TABLE tblSMSMessageHistory
 (
	ID			INTEGER, 
	SentTime			DateTime, 
	MessageStatus			varchar, 
	MessageID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblSMSMessageHistory_ID_idx ON tblSMSMessageHistory (ID);
CREATE INDEX tblSMSMessageHistory_MessageID_idx ON tblSMSMessageHistory (MessageID);

CREATE TABLE tblSMSMessageInstallment
 (
	ID			INTEGER, 
	BranchID			INTEGER NOT NULL, 
	InstallmentPlanID			INTEGER NOT NULL, 
	InstallmentID			INTEGER NOT NULL, 
	SMSMessageTypeID			INTEGER NOT NULL, 
	SMSMessageRecordID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblSMSMessageInstallment_BranchID_idx ON tblSMSMessageInstallment (BranchID);
CREATE INDEX tblSMSMessageInstallment_InstallmentID_idx ON tblSMSMessageInstallment (InstallmentID);
CREATE UNIQUE INDEX tblSMSMessageInstallment_InstallmentMessageTypeID_idx ON tblSMSMessageInstallment (BranchID, InstallmentPlanID, InstallmentID, SMSMessageTypeID);
CREATE INDEX tblSMSMessageInstallment_InstallmentPlanID_idx ON tblSMSMessageInstallment (InstallmentPlanID);
CREATE INDEX tblSMSMessageInstallment_SMSMessageTypeID_idx ON tblSMSMessageInstallment (SMSMessageTypeID);

CREATE TABLE tblSMSMessageRecord
 (
	ID			INTEGER, 
	SenderName			varchar, 
	MessageText			TEXT, 
	NumbersList			TEXT, 
	MessageTime			DateTime, 
	SentTime			DateTime
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblSMSMessageRecord_ID_idx ON tblSMSMessageRecord (ID);
CREATE INDEX tblSMSMessageRecord_NumbersList_idx ON tblSMSMessageRecord (NumbersList);

CREATE TABLE tblSMSMessageRentLeaseRenewal
 (
	ID			INTEGER, 
	BranchID			INTEGER, 
	RentLeaseRenewalID			INTEGER, 
	SMSMessageTypeID			INTEGER, 
	SMSMessageRecordID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblSMSMessageRentLeaseRenewal_AccountDocumentID_idx ON tblSMSMessageRentLeaseRenewal (RentLeaseRenewalID);
CREATE INDEX tblSMSMessageRentLeaseRenewal_BranchID_idx ON tblSMSMessageRentLeaseRenewal (BranchID);
CREATE INDEX tblSMSMessageRentLeaseRenewal_SMSMessageTypeID_idx ON tblSMSMessageRentLeaseRenewal (SMSMessageTypeID);

CREATE TABLE tblSMSMessageSetting
 (
	UserName			varchar, 
	UserPassword			varchar, 
	SenderName			varchar, 
	SMSProviderID			INTEGER, 
	InvoiceSMSText			varchar, 
	FinishedRentPeriodSMSText			varchar, 
	ReceiptSMSText			varchar
);

-- CREATE INDEXES ...

CREATE TABLE tblSMSMessageType
 (
	ID			INTEGER, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar NOT NULL, 
	MessageTextAr			TEXT, 
	MessageTextEn			TEXT, 
	PeriodByDay			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tblSMSProvider
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	ProviderWebSite			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblSMSProvider_FormID_idx ON tblSMSProvider (ID);
CREATE UNIQUE INDEX tblSMSProvider_NameAr_idx ON tblSMSProvider (NameAr);
CREATE UNIQUE INDEX tblSMSProvider_NameEn_idx ON tblSMSProvider (NameEn);

CREATE TABLE tblStage
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblStage_FormID_idx ON tblStage (ID);
CREATE UNIQUE INDEX tblStage_NameAr_idx ON tblStage (NameAr);
CREATE UNIQUE INDEX tblStage_NameEn_idx ON tblStage (NameEn);

CREATE TABLE tblStopType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblStopType_FormID_idx ON tblStopType (ID);
CREATE UNIQUE INDEX tblStopType_NameAr_idx ON tblStopType (NameAr);
CREATE UNIQUE INDEX tblStopType_NameEn_idx ON tblStopType (NameEn);

CREATE TABLE tblStoredItemBalance
 (
	ID			INTEGER, 
	BuyQty			INTEGER, 
	OutQty			INTEGER, 
	CurrentQty			INTEGER, 
	ReturnFromCustomer			INTEGER, 
	ReturnToSupplier			INTEGER, 
	MaximumQty			INTEGER, 
	MinimumQty			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblStoredItemBalance_ID_idx ON tblStoredItemBalance (ID);

CREATE TABLE tblStoreMovement
 (
	ID			varchar, 
	StoreCreditorID			INTEGER NOT NULL, 
	StoreDebtorID			INTEGER NOT NULL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblStoreMovement_CreditorID_idx ON tblStoreMovement (StoreCreditorID);
CREATE INDEX tblStoreMovement_DebtorID_idx ON tblStoreMovement (StoreDebtorID);
CREATE UNIQUE INDEX tblStoreMovement_ID_idx ON tblStoreMovement (ID);

CREATE TABLE tblStudentAttendance
 (
	ID			INTEGER, 
	ApprovedCourseID			INTEGER, 
	AttendanceDate			DateTime, 
	Notes			varchar, 
	PCID			INTEGER, 
	InputMeansID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblStudentAttendance_ApprovedCourseID_idx ON tblStudentAttendance (ApprovedCourseID);
CREATE INDEX tblStudentAttendance_ID_idx ON tblStudentAttendance (ID);
CREATE INDEX tblStudentAttendance_InputMeansID_idx ON tblStudentAttendance (InputMeansID);
CREATE INDEX tblStudentAttendance_PCID_idx ON tblStudentAttendance (PCID);

CREATE TABLE tblStudentAttendanceList
 (
	StudentAttendanceID			INTEGER, 
	StudentAccountID			INTEGER, 
	AttendanceCaseID			INTEGER, 
	Notes			varchar, 
	LateOrLeaveMinutes			INTEGER
	, PRIMARY KEY (StudentAttendanceID, StudentAccountID)
);

-- CREATE INDEXES ...
CREATE INDEX tblStudentAttendanceList_AttendanceCaseID_idx ON tblStudentAttendanceList (AttendanceCaseID);
CREATE INDEX tblStudentAttendanceList_StudentAccountID_idx ON tblStudentAttendanceList (StudentAccountID);
CREATE INDEX tblStudentAttendanceList_StudentAttendanceID_idx ON tblStudentAttendanceList (StudentAttendanceID);

CREATE TABLE tblStudentCourseProcedure
 (
	StudentAccountID			INTEGER NOT NULL, 
	ApprovedCourseID			INTEGER NOT NULL, 
	ProcedureTypeID			INTEGER NOT NULL, 
	ProcedureDate			DateTime NOT NULL, 
	ProcedureReason			TEXT
	, PRIMARY KEY (StudentAccountID, ApprovedCourseID, ProcedureTypeID)
);

-- CREATE INDEXES ...
CREATE INDEX tblStudentCourseProcedure_ApprovedCourseID_idx ON tblStudentCourseProcedure (ApprovedCourseID);
CREATE INDEX tblStudentCourseProcedure_ProcedureTypeID_idx ON tblStudentCourseProcedure (ProcedureTypeID);
CREATE INDEX tblStudentCourseProcedure_StudentAccountID_idx ON tblStudentCourseProcedure (StudentAccountID);

CREATE TABLE tblStudentFinalValuation
 (
	ID			INTEGER, 
	StudentAccountID			INTEGER, 
	ApprovedCourseID			INTEGER, 
	ScientificEducationalValuation			TEXT, 
	ValuationFormID			INTEGER, 
	ValuationDate			DateTime
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblStudentFinalValuation_AccountID_idx ON tblStudentFinalValuation (StudentAccountID);
CREATE INDEX tblStudentFinalValuation_ApprovedCourseID_idx ON tblStudentFinalValuation (ApprovedCourseID);
CREATE INDEX tblStudentFinalValuation_ID_idx ON tblStudentFinalValuation (ID);
CREATE INDEX tblStudentFinalValuation_ValuationFormID_idx ON tblStudentFinalValuation (ValuationFormID);

CREATE TABLE tblStudentFinalValuationList
 (
	StudentFinalValuationID			INTEGER, 
	ValuationFormObjectID			INTEGER, 
	MarkID			INTEGER
	, PRIMARY KEY (StudentFinalValuationID, ValuationFormObjectID)
);

-- CREATE INDEXES ...
CREATE INDEX tblStudentFinalValuationList_ID_idx ON tblStudentFinalValuationList (StudentFinalValuationID);
CREATE INDEX tblStudentFinalValuationList_MarkID_idx ON tblStudentFinalValuationList (MarkID);
CREATE INDEX tblStudentFinalValuationList_ValuationFormObjectID_idx ON tblStudentFinalValuationList (ValuationFormObjectID);

CREATE TABLE tblStudentFinanceRelatedData
 (
	AccountID			INTEGER, 
	HouseTypeID			INTEGER, 
	BuildingTypeID			INTEGER, 
	RoomsNo			INTEGER, 
	WaterMeterNo			varchar, 
	ElectricityMeterNo			varchar, 
	ChildrenNo			INTEGER, 
	GirlsNo			INTEGER, 
	CarTypeID			INTEGER, 
	CarModle			INTEGER, 
	PlateNo			varchar, 
	CarColorID			INTEGER
	, PRIMARY KEY (AccountID)
);

-- CREATE INDEXES ...
CREATE INDEX tblStudentFinanceRelatedData_AccountID_idx ON tblStudentFinanceRelatedData (AccountID);
CREATE INDEX tblStudentFinanceRelatedData_BuildingTypeID_idx ON tblStudentFinanceRelatedData (BuildingTypeID);
CREATE INDEX tblStudentFinanceRelatedData_CarColorID_idx ON tblStudentFinanceRelatedData (CarColorID);
CREATE INDEX tblStudentFinanceRelatedData_CarTypeID_idx ON tblStudentFinanceRelatedData (CarTypeID);
CREATE INDEX tblStudentFinanceRelatedData_HouseTypeID_idx ON tblStudentFinanceRelatedData (HouseTypeID);

CREATE TABLE tblStudentResult
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblStudentResult_FormID_idx ON tblStudentResult (ID);
CREATE UNIQUE INDEX tblStudentResult_NameAr_idx ON tblStudentResult (NameAr);
CREATE UNIQUE INDEX tblStudentResult_NameEn_idx ON tblStudentResult (NameEn);

CREATE TABLE tblStudentType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblStudentType_FormID_idx ON tblStudentType (ID);
CREATE UNIQUE INDEX tblStudentType_NameAr_idx ON tblStudentType (NameAr);
CREATE UNIQUE INDEX tblStudentType_NameEn_idx ON tblStudentType (NameEn);

CREATE TABLE tblStudentWeeklyValuation
 (
	ID			INTEGER, 
	EvaluationDate			DateTime, 
	ApprovedCourseID			INTEGER, 
	SubjectStartName			varchar, 
	SubjectStartPageNo			varchar, 
	SubjectEndName			varchar, 
	SubjectEndPageNo			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblStudentWeeklyValuation_ApprovedCourseID_idx ON tblStudentWeeklyValuation (ApprovedCourseID);
CREATE INDEX tblStudentWeeklyValuation_ID_idx ON tblStudentWeeklyValuation (ID);

CREATE TABLE tblStudyBook
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	AuthorName			varchar, 
	PressDate			varchar, 
	PressNo			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblStudyBook_FormID_idx ON tblStudyBook (ID);
CREATE UNIQUE INDEX tblStudyBook_NameAr_idx ON tblStudyBook (NameAr);
CREATE UNIQUE INDEX tblStudyBook_NameEn_idx ON tblStudyBook (NameEn);

CREATE TABLE tblStudyClass
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	StratTime			DateTime, 
	EndTime			DateTime
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblStudyClass_FormID_idx ON tblStudyClass (ID);
CREATE UNIQUE INDEX tblStudyClass_NameAr_idx ON tblStudyClass (NameAr);
CREATE UNIQUE INDEX tblStudyClass_NameEn_idx ON tblStudyClass (NameEn);

CREATE TABLE tblStudyLevel
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblStudyLevel_FormID_idx ON tblStudyLevel (ID);
CREATE UNIQUE INDEX tblStudyLevel_NameAr_idx ON tblStudyLevel (NameAr);
CREATE UNIQUE INDEX tblStudyLevel_NameEn_idx ON tblStudyLevel (NameEn);

CREATE TABLE tblStudyTermPeriod
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblStudyTermPeriod_FormID_idx ON tblStudyTermPeriod (ID);
CREATE UNIQUE INDEX tblStudyTermPeriod_NameAr_idx ON tblStudyTermPeriod (NameAr);
CREATE UNIQUE INDEX tblStudyTermPeriod_NameEn_idx ON tblStudyTermPeriod (NameEn);

CREATE TABLE tblStudyType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblStudyType_FormID_idx ON tblStudyType (ID);
CREATE UNIQUE INDEX tblStudyType_NameAr_idx ON tblStudyType (NameAr);
CREATE UNIQUE INDEX tblStudyType_NameEn_idx ON tblStudyType (NameEn);

CREATE TABLE tblStudyYear
 (
	ID			INTEGER NOT NULL, 
	StartYearID			INTEGER NOT NULL, 
	EndYearID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblStudyYear_FormID_idx ON tblStudyYear (ID);
CREATE UNIQUE INDEX tblStudyYear_NameAr_idx ON tblStudyYear (StartYearID);
CREATE UNIQUE INDEX tblStudyYear_NameEn_idx ON tblStudyYear (EndYearID);

CREATE TABLE tblSubscriptionCard
 (
	ID			INTEGER, 
	CardNo			INTEGER, 
	CardCode			varchar, 
	AccountID			INTEGER, 
	CardDate			DateTime, 
	CardClassID			INTEGER, 
	Price			REAL, 
	FreePalance			REAL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblSubscriptionCard_AccountID_idx ON tblSubscriptionCard (AccountID);
CREATE INDEX tblSubscriptionCard_CardClassID_idx ON tblSubscriptionCard (CardClassID);
CREATE INDEX tblSubscriptionCard_CardCode_idx ON tblSubscriptionCard (CardCode);
CREATE INDEX tblSubscriptionCard_ID_idx ON tblSubscriptionCard (ID);

CREATE TABLE tblTable
 (
	ID			INTEGER, 
	NameAr			varchar, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tblTeacherFinalValuation
 (
	ID			INTEGER, 
	StudyYearID			INTEGER, 
	TermID			INTEGER, 
	TeacherAccountID			INTEGER, 
	ValuationFormID			INTEGER, 
	ValuationDate			DateTime, 
	StrengthPoint			TEXT, 
	WeakPoint			TEXT, 
	Recommendation			TEXT, 
	ManagerOpinion			TEXT
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblTeacherFinalValuation_ID_idx ON tblTeacherFinalValuation (ID);
CREATE INDEX tblTeacherFinalValuation_StudyYearID_idx ON tblTeacherFinalValuation (StudyYearID);
CREATE INDEX tblTeacherFinalValuation_TeacherAccountID_idx ON tblTeacherFinalValuation (TeacherAccountID);
CREATE INDEX tblTeacherFinalValuation_TermID_idx ON tblTeacherFinalValuation (TermID);
CREATE INDEX tblTeacherFinalValuation_ValuationFormID_idx ON tblTeacherFinalValuation (ValuationFormID);

CREATE TABLE tblTeacherFinalValuationList
 (
	TeacherFinalValuationID			INTEGER, 
	ValuationFormObjectID			INTEGER, 
	MarkID			INTEGER
	, PRIMARY KEY (TeacherFinalValuationID, ValuationFormObjectID)
);

-- CREATE INDEXES ...
CREATE INDEX tblTeacherFinalValuationList_ID_idx ON tblTeacherFinalValuationList (TeacherFinalValuationID);
CREATE INDEX tblTeacherFinalValuationList_MarkID_idx ON tblTeacherFinalValuationList (MarkID);
CREATE INDEX tblTeacherFinalValuationList_ValuationFormObjectID_idx ON tblTeacherFinalValuationList (ValuationFormObjectID);

CREATE TABLE tblTeacherProcedure
 (
	ID			INTEGER, 
	TeacherAccountID			INTEGER, 
	StudyYearID			INTEGER, 
	TermID			INTEGER, 
	TeacherProcedureSubjectID			INTEGER NOT NULL, 
	ProcedureDate			DateTime NOT NULL, 
	StudyTypeID			INTEGER, 
	ApprovedCourseID			INTEGER, 
	TeacherProcedureID			INTEGER, 
	MeetDate			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblTeacherProcedure_ApprovedCourseID_idx ON tblTeacherProcedure (ApprovedCourseID);
CREATE INDEX tblTeacherProcedure_ID_idx ON tblTeacherProcedure (ID);
CREATE INDEX tblTeacherProcedure_StudyTypeID_idx ON tblTeacherProcedure (StudyTypeID);
CREATE INDEX tblTeacherProcedure_StudyYearID_idx ON tblTeacherProcedure (StudyYearID);
CREATE INDEX tblTeacherProcedure_TeacherAccountID_idx ON tblTeacherProcedure (TeacherAccountID);
CREATE INDEX tblTeacherProcedure_TeacherProcedureID_idx ON tblTeacherProcedure (MeetDate);
CREATE INDEX tblTeacherProcedure_TeacherProcedureID1_idx ON tblTeacherProcedure (TeacherProcedureID);
CREATE INDEX tblTeacherProcedure_TeacherProcedureSubjectID_idx ON tblTeacherProcedure (TeacherProcedureSubjectID);
CREATE INDEX tblTeacherProcedure_TermID_idx ON tblTeacherProcedure (TermID);

CREATE TABLE tblTeacherProcedureSubject
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblTeacherProcedureSubject_DocumentTypeID_idx ON tblTeacherProcedureSubject (ID);
CREATE UNIQUE INDEX tblTeacherProcedureSubject_NameAr_idx ON tblTeacherProcedureSubject (NameAr);
CREATE UNIQUE INDEX tblTeacherProcedureSubject_NameEn_idx ON tblTeacherProcedureSubject (NameEn);

CREATE TABLE tblTeacherProcedureType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblTeacherProcedureType_DocumentTypeID_idx ON tblTeacherProcedureType (ID);
CREATE UNIQUE INDEX tblTeacherProcedureType_NameAr_idx ON tblTeacherProcedureType (NameAr);
CREATE UNIQUE INDEX tblTeacherProcedureType_NameEn_idx ON tblTeacherProcedureType (NameEn);

CREATE TABLE tblTeacherValuationByStudent
 (
	ID			INTEGER, 
	StudentAccountID			INTEGER, 
	ApprovedCourseID			INTEGER, 
	StudentSufferanceWithTeacher			TEXT, 
	ValuationFormID			INTEGER, 
	ValuationDate			DateTime
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblTeacherValuationByStudent_AccountID_idx ON tblTeacherValuationByStudent (StudentAccountID);
CREATE INDEX tblTeacherValuationByStudent_ApprovedCourseID_idx ON tblTeacherValuationByStudent (ApprovedCourseID);
CREATE INDEX tblTeacherValuationByStudent_ID_idx ON tblTeacherValuationByStudent (ID);
CREATE INDEX tblTeacherValuationByStudent_ValuationFormID_idx ON tblTeacherValuationByStudent (ValuationFormID);

CREATE TABLE tblTeacherValuationByStudentList
 (
	TeacherValuationByStudentID			INTEGER, 
	ValuationFormObjectID			INTEGER, 
	MarkID			INTEGER
	, PRIMARY KEY (TeacherValuationByStudentID, ValuationFormObjectID)
);

-- CREATE INDEXES ...
CREATE INDEX tblTeacherValuationByStudentList_ID_idx ON tblTeacherValuationByStudentList (TeacherValuationByStudentID);
CREATE INDEX tblTeacherValuationByStudentList_MarkID_idx ON tblTeacherValuationByStudentList (MarkID);
CREATE INDEX tblTeacherValuationByStudentList_ValuationFormObjectID_idx ON tblTeacherValuationByStudentList (ValuationFormObjectID);

CREATE TABLE tblTeacherValuationRecordList
 (
	TeacherValuationRecordID			INTEGER, 
	ValuationFormObjectID			INTEGER, 
	MarkID			INTEGER
	, PRIMARY KEY (TeacherValuationRecordID, ValuationFormObjectID)
);

-- CREATE INDEXES ...
CREATE INDEX tblTeacherValuationRecordList_ID_idx ON tblTeacherValuationRecordList (TeacherValuationRecordID);
CREATE INDEX tblTeacherValuationRecordList_MarkID_idx ON tblTeacherValuationRecordList (MarkID);
CREATE INDEX tblTeacherValuationRecordList_ValuationFormObjectID_idx ON tblTeacherValuationRecordList (ValuationFormObjectID);

CREATE TABLE tblTeacherVisitNo
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblTeacherVisitNo_FormID_idx ON tblTeacherVisitNo (ID);
CREATE UNIQUE INDEX tblTeacherVisitNo_NameAr_idx ON tblTeacherVisitNo (NameAr);
CREATE UNIQUE INDEX tblTeacherVisitNo_NameEn_idx ON tblTeacherVisitNo (NameEn);

CREATE TABLE tblTeamGroup
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	GroupForemanAccountID			INTEGER, 
	CreationDate			DateTime, 
	StopDate			DateTime, 
	GroupStatusID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblTeamGroup_GroupForemanAccountID_idx ON tblTeamGroup (GroupForemanAccountID);
CREATE INDEX tblTeamGroup_GroupStatusID_idx ON tblTeamGroup (GroupStatusID);
CREATE UNIQUE INDEX tblTeamGroup_NameAr_idx ON tblTeamGroup (NameAr);
CREATE UNIQUE INDEX tblTeamGroup_NameEn_idx ON tblTeamGroup (NameEn);

CREATE TABLE tblTeamGroupMember
 (
	ID			INTEGER, 
	TeamGroupID			INTEGER NOT NULL, 
	MemberAccountID			INTEGER, 
	StartDate			DateTime, 
	StopDate			DateTime, 
	StatusID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE UNIQUE INDEX tblTeamGroupMember_MemberAccountID_idx ON tblTeamGroupMember (TeamGroupID, MemberAccountID, StartDate);
CREATE INDEX tblTeamGroupMember_StatusID_idx ON tblTeamGroupMember (StatusID);

CREATE TABLE tblTerm
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblTerm_FormID_idx ON tblTerm (ID);
CREATE UNIQUE INDEX tblTerm_NameAr_idx ON tblTerm (NameAr);
CREATE UNIQUE INDEX tblTerm_NameEn_idx ON tblTerm (NameEn);

CREATE TABLE tblTimeByHalfHour
 (
	TimeHour			INTEGER, 
	TimeHalf			INTEGER, 
	TheTime			DateTime
	, PRIMARY KEY (TheTime)
);

-- CREATE INDEXES ...

CREATE TABLE tblTimeByQuarterHour
 (
	TimeHour			INTEGER, 
	TimeQuarter			INTEGER, 
	TheTime			DateTime
	, PRIMARY KEY (TheTime)
);

-- CREATE INDEXES ...

CREATE TABLE tblTimeHalf
 (
	ID			INTEGER, 
	TimeHalf			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblTimeHalf_ID_idx ON tblTimeHalf (ID);

CREATE TABLE tblTimeHour
 (
	ID			INTEGER, 
	TimeHour			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblTimeHour_ID_idx ON tblTimeHour (ID);

CREATE TABLE tblTitle
 (
	ID			INTEGER, 
	NameAr			varchar, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblTitle_ID_idx ON tblTitle (ID);

CREATE TABLE tblTransactionHistory
 (
	ID			INTEGER, 
	UserID			INTEGER NOT NULL, 
	TransactionTime			DateTime NOT NULL, 
	TransactionTypeID			INTEGER NOT NULL, 
	ObjectID			INTEGER NOT NULL, 
	RecordID			varchar, 
	PCID			INTEGER NOT NULL, 
	RecordData			TEXT, 
	RecordDataAr			TEXT, 
	RecordDataEn			TEXT
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblTransactionHistory_FormID_idx ON tblTransactionHistory (ObjectID);
CREATE INDEX tblTransactionHistory_OperationID_idx ON tblTransactionHistory (ID);
CREATE INDEX tblTransactionHistory_PCID_idx ON tblTransactionHistory (PCID);
CREATE INDEX tblTransactionHistory_RecordID_idx ON tblTransactionHistory (RecordID);
CREATE INDEX tblTransactionHistory_TransactionTypeID_idx ON tblTransactionHistory (TransactionTypeID);
CREATE INDEX tblTransactionHistory_UserID_idx ON tblTransactionHistory (UserID);

CREATE TABLE tblTransactionType
 (
	ID			INTEGER, 
	NameAr			varchar, 
	NameEn			varchar, 
	AuthorityName			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE UNIQUE INDEX tblTransactionType_ID_idx ON tblTransactionType (ID);

CREATE TABLE tblUnitActionType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	Manual			INTEGER NOT NULL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblUnitActionType_FormID_idx ON tblUnitActionType (ID);
CREATE UNIQUE INDEX tblUnitActionType_NameAr_idx ON tblUnitActionType (NameAr);
CREATE UNIQUE INDEX tblUnitActionType_NameEn_idx ON tblUnitActionType (NameEn);

CREATE TABLE tblUnitExpense
 (
	BranchID			INTEGER NOT NULL, 
	ID			INTEGER NOT NULL, 
	UnitID			INTEGER NOT NULL, 
	ExpenseDate			DateTime, 
	ExpenseTypeID			INTEGER NOT NULL, 
	Amount			INTEGER, 
	Remark			varchar, 
	StaffID			INTEGER
	, PRIMARY KEY (BranchID, ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblUnitExpense_BranchID_idx ON tblUnitExpense (BranchID);
CREATE INDEX tblUnitExpense_ExpenseTypeID_idx ON tblUnitExpense (ExpenseTypeID);
CREATE INDEX tblUnitExpense_ID_idx ON tblUnitExpense (ID);
CREATE INDEX tblUnitExpense_StaffID_idx ON tblUnitExpense (StaffID);
CREATE INDEX tblUnitExpense_UnitID_idx ON tblUnitExpense (UnitID);

CREATE TABLE tblUnitStatus
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblUnitStatus_FormID_idx ON tblUnitStatus (ID);
CREATE UNIQUE INDEX tblUnitStatus_NameAr_idx ON tblUnitStatus (NameAr);
CREATE UNIQUE INDEX tblUnitStatus_NameEn_idx ON tblUnitStatus (NameEn);

CREATE TABLE tblUnitTypeCondition
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	ConditionAr			TEXT NOT NULL, 
	ConditionEn			TEXT, 
	ConditionAr1			TEXT, 
	ConditionEn1			TEXT
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblUnitTypeCondition_FormID_idx ON tblUnitTypeCondition (ID);
CREATE UNIQUE INDEX tblUnitTypeCondition_NameAr_idx ON tblUnitTypeCondition (ConditionAr);
CREATE UNIQUE INDEX tblUnitTypeCondition_NameAr1_idx ON tblUnitTypeCondition (NameAr);
CREATE UNIQUE INDEX tblUnitTypeCondition_NameEn_idx ON tblUnitTypeCondition (ConditionEn);
CREATE UNIQUE INDEX tblUnitTypeCondition_NameEn1_idx ON tblUnitTypeCondition (NameEn);

CREATE TABLE tblUpdateStatus
 (
	ID			REAL, 
	NameAr			varchar, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tblUser
 (
	ID			INTEGER, 
	NameAr			varchar, 
	NameEn			varchar, 
	UserName			varchar NOT NULL, 
	Password			varchar, 
	FirstEntry			DateTime, 
	LastEntry			DateTime, 
	UserGroupID			INTEGER NOT NULL, 
	CurrentStatusID			INTEGER NOT NULL, 
	Stopped			INTEGER NOT NULL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE UNIQUE INDEX tblUser_ID_idx ON tblUser (ID);
CREATE INDEX tblUser_Login_idx ON tblUser (CurrentStatusID);
CREATE INDEX tblUser_Stopped_idx ON tblUser (Stopped);
CREATE INDEX tblUser_UserTypeID_idx ON tblUser (UserGroupID);

CREATE TABLE tblUserAccountType
 (
	UserID			INTEGER, 
	AccountTypeID			INTEGER, 
	IsUsed			INTEGER NOT NULL
	, PRIMARY KEY (UserID, AccountTypeID)
);

-- CREATE INDEXES ...
CREATE INDEX tblUserAccountType_AccountID_idx ON tblUserAccountType (AccountTypeID);
CREATE INDEX tblUserAccountType_UserID_idx ON tblUserAccountType (UserID);

CREATE TABLE tblUserGroup
 (
	ID			INTEGER, 
	NameAr			varchar, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblUserGroup_FormID_idx ON tblUserGroup (ID);

CREATE TABLE tblUserMoneyAccount
 (
	UserID			INTEGER, 
	AccountID			INTEGER, 
	IsUsed			INTEGER NOT NULL
	, PRIMARY KEY (UserID, AccountID)
);

-- CREATE INDEXES ...
CREATE INDEX tblUserMoneyAccount_AccountID_idx ON tblUserMoneyAccount (AccountID);
CREATE INDEX tblUserMoneyAccount_UserID_idx ON tblUserMoneyAccount (UserID);

CREATE TABLE tblUserReceiptSubject
 (
	UserID			INTEGER, 
	ReceiptSubjectID			INTEGER, 
	IsUsed			INTEGER NOT NULL
	, PRIMARY KEY (UserID, ReceiptSubjectID)
);

-- CREATE INDEXES ...
CREATE INDEX tblUserReceiptSubject_AccountID_idx ON tblUserReceiptSubject (ReceiptSubjectID);
CREATE INDEX tblUserReceiptSubject_UserID_idx ON tblUserReceiptSubject (UserID);

CREATE TABLE tblUserSetting
 (
	UserID			INTEGER NOT NULL, 
	CodeID			INTEGER, 
	QuickInvoiceTypeID			INTEGER, 
	QuickInvoiceCreditorID			INTEGER, 
	QuickInvoiceDebtorID			INTEGER, 
	QuickInvoiceStoreCreditorID			INTEGER, 
	QuickInvoiceStoreDebtorID			INTEGER, 
	DiscountPercentage			REAL
	, PRIMARY KEY (UserID)
);

-- CREATE INDEXES ...
CREATE INDEX tblUserSetting_CodeID_idx ON tblUserSetting (CodeID);
CREATE UNIQUE INDEX tblUserSetting_FormID_idx ON tblUserSetting (UserID);
CREATE INDEX tblUserSetting_QuickInvoiceCreditorID_idx ON tblUserSetting (QuickInvoiceCreditorID);
CREATE INDEX tblUserSetting_QuickInvoiceCreditorID1_idx ON tblUserSetting (QuickInvoiceDebtorID);
CREATE INDEX tblUserSetting_QuickInvoiceDebtorID_idx ON tblUserSetting (QuickInvoiceStoreCreditorID);
CREATE INDEX tblUserSetting_QuickInvoiceDebtorID1_idx ON tblUserSetting (QuickInvoiceStoreDebtorID);
CREATE INDEX tblUserSetting_QuickInvoiceTypeID_idx ON tblUserSetting (QuickInvoiceTypeID);

CREATE TABLE tblUserStatus
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblUserStatus_FormID_idx ON tblUserStatus (ID);

CREATE TABLE tblUseType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	Counted			INTEGER NOT NULL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblUseType_FormID_idx ON tblUseType (ID);
CREATE UNIQUE INDEX tblUseType_NameAr_idx ON tblUseType (NameAr);
CREATE UNIQUE INDEX tblUseType_NameEn_idx ON tblUseType (NameEn);

CREATE TABLE tblValuationForm
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	ValuationPersonTypeID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblValuationForm_FormID_idx ON tblValuationForm (ID);
CREATE UNIQUE INDEX tblValuationForm_NameAr_idx ON tblValuationForm (NameAr);
CREATE UNIQUE INDEX tblValuationForm_NameEn_idx ON tblValuationForm (NameEn);
CREATE INDEX tblValuationForm_ValuationPersonTypeID_idx ON tblValuationForm (ValuationPersonTypeID);

CREATE TABLE tblValuationFormGroup
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	ValuationFormID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblValuationFormGroup_FormID_idx ON tblValuationFormGroup (ID);
CREATE UNIQUE INDEX tblValuationFormGroup_NameAr_idx ON tblValuationFormGroup (NameAr);
CREATE UNIQUE INDEX tblValuationFormGroup_NameEn_idx ON tblValuationFormGroup (NameEn);
CREATE INDEX tblValuationFormGroup_ValuationFormID_idx ON tblValuationFormGroup (ValuationFormID);

CREATE TABLE tblVaTCategories
 (
	ID			INTEGER NOT NULL, 
	Code			varchar NOT NULL, 
	Description			varchar, 
	TaxExemptionReasonCode			varchar, 
	TaxExemptionReason			varchar, 
	TaxExemptionReasonEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tblVatType
 (
	ID			INTEGER, 
	NameAr			varchar, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tblVersion
 (
	Version			varchar
);

-- CREATE INDEXES ...

CREATE TABLE tblWeek
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar NOT NULL, 
	StartDate			varchar, 
	EndDate			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE UNIQUE INDEX tblWeek_DayNo_idx ON tblWeek (ID);

CREATE TABLE tblWeekDay
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar NOT NULL, 
	IsWeekEnd			INTEGER NOT NULL, 
	WeekDayID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE UNIQUE INDEX tblWeekDay_DayNo_idx ON tblWeekDay (ID);
CREATE INDEX tblWeekDay_SystemID_idx ON tblWeekDay (WeekDayID);

CREATE TABLE tblWorkerRentContract
 (
	ContractNo			INTEGER NOT NULL, 
	ContractDay			INTEGER NOT NULL, 
	ContractDate			DateTime NOT NULL, 
	CustomerID			INTEGER NOT NULL, 
	FirstSideID			INTEGER NOT NULL, 
	StartDate			DateTime, 
	EndDate			DateTime, 
	ContractPeriodMonth			INTEGER, 
	ContractPeriodDay			INTEGER, 
	ContractNote			varchar, 
	UPdatedByID			INTEGER, 
	DocumentImagePath			TEXT
	, PRIMARY KEY (ContractNo)
);

-- CREATE INDEXES ...
CREATE INDEX tblWorkerRentContract_ContractDay_idx ON tblWorkerRentContract (ContractDay);
CREATE INDEX tblWorkerRentContract_CustomerNo_idx ON tblWorkerRentContract (CustomerID);
CREATE INDEX tblWorkerRentContract_FEmployeeNo_idx ON tblWorkerRentContract (FirstSideID);
CREATE INDEX tblWorkerRentContract_FEmployeeNo1_idx ON tblWorkerRentContract (UPdatedByID);

CREATE TABLE tblWorkerRentContractEmployee
 (
	ContractNo			INTEGER NOT NULL, 
	AccountID			INTEGER, 
	Wages			INTEGER NOT NULL, 
	Performance			INTEGER, 
	WorkStartDate			DateTime, 
	ReturnDate			DateTime, 
	EmployeeNote			varchar, 
	FirstWages			INTEGER NOT NULL
	, PRIMARY KEY (ContractNo, AccountID)
);

-- CREATE INDEXES ...
CREATE INDEX tblWorkerRentContractEmployee_ContractNo_idx ON tblWorkerRentContractEmployee (ContractNo);
CREATE INDEX tblWorkerRentContractEmployee_EmployeeNo_idx ON tblWorkerRentContractEmployee (AccountID);

CREATE TABLE tmbNotUsedMoneyTransaction
 (
	ID			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tmbNotUsedMoneyTransaction_ID_idx ON tmbNotUsedMoneyTransaction (ID);

CREATE TABLE tmpAccountBalance
 (
	ID			INTEGER, 
	TheBalance			REAL, 
	OpenBalance			REAL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tmpLastPaymentDate
 (
	ID			INTEGER, 
	LastOfLastPaymentUntilDate			DateTime, 
	LastOfReceiptDate			DateTime, 
	LastOfLastPaymentStartDate			DateTime
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tmpLastRentLeaseRenewal
 (
	BranchID			INTEGER NOT NULL, 
	LeaseID			INTEGER NOT NULL, 
	LastOfLastPaymentUntilDate			DateTime, 
	LastOfLastPaymentStartDate			DateTime, 
	LastOfRenewalDate			DateTime
	, PRIMARY KEY (BranchID, LeaseID)
);

-- CREATE INDEXES ...
CREATE INDEX tmpLastRentLeaseRenewal_BranchID_idx ON tmpLastRentLeaseRenewal (BranchID);
CREATE INDEX tmpLastRentLeaseRenewal_LeaseID_idx ON tmpLastRentLeaseRenewal (LeaseID);

CREATE TABLE tmpMoneyAccountBalance
 (
	ID			INTEGER, 
	TheBalance			REAL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE USysRibbons
 (
	RibbonName			varchar, 
	RibbonXML			TEXT
	, PRIMARY KEY (RibbonName)
);

-- CREATE INDEXES ...


-- CREATE INDEXES ...

CREATE TABLE ss
 (
	ID			INTEGER, 
	a			INTEGER
);

-- CREATE INDEXES ...
CREATE INDEX ss_ID_idx ON ss (ID);

CREATE TABLE tblAccount
 (
	ID			INTEGER NOT NULL, 
	AccountTypeID			INTEGER NOT NULL, 
	NameAr			varchar, 
	NameEn			varchar, 
	OpeningBalance			REAL NOT NULL, 
	CurrentBalance			REAL, 
	AcountNote			TEXT, 
	BranchID			INTEGER NOT NULL, 
	NationalityID			INTEGER, 
	MoneyAccountTypeID			INTEGER, 
	StreetNameAr			varchar, 
	StreetNameEn			varchar, 
	CityAr			varchar, 
	CityEn			varchar, 
	CountryAlpha2Code			varchar, 
	BuildingNumber			varchar, 
	DistrictAr			varchar, 
	DistrictEn			varchar, 
	PostalCode			varchar, 
	PostalAdditionalNo			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tblAccountDiscount
 (
	ID			INTEGER, 
	AccountID			INTEGER, 
	CreationDate			DateTime, 
	Discount			INTEGER, 
	StartDate			DateTime, 
	EndDate			DateTime, 
	Remark			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblAccountDiscount_AccountID_idx ON tblAccountDiscount (AccountID);
CREATE INDEX tblAccountDiscount_ID_idx ON tblAccountDiscount (ID);

CREATE TABLE tblAccountRegistrationStatus
 (
	AccountID			INTEGER, 
	RegistrationStatusID			INTEGER, 
	RegistrationStatusDate			DateTime, 
	StopTypeID			INTEGER, 
	Notes			varchar
	, PRIMARY KEY (AccountID, RegistrationStatusID)
);

-- CREATE INDEXES ...
CREATE INDEX tblAccountRegistrationStatus_AccountID_idx ON tblAccountRegistrationStatus (AccountID);
CREATE INDEX tblAccountRegistrationStatus_ExperienceTypeID_idx ON tblAccountRegistrationStatus (RegistrationStatusID);
CREATE INDEX tblAccountRegistrationStatus_StopTypeID_idx ON tblAccountRegistrationStatus (StopTypeID);

CREATE TABLE tblAllowanceChargeReasons
 (
	Code			varchar NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar NOT NULL, 
	DescriptionAr			TEXT, 
	DescriptionEn			TEXT, 
	ChargeIndicator			INTEGER NOT NULL
	, PRIMARY KEY (Code)
);

-- CREATE INDEXES ...

CREATE TABLE tblAuthorityReportTypeFillterationBy
 (
	AuthorityReportTypeID			INTEGER NOT NULL, 
	ItemFiltrationBy			INTEGER NOT NULL
	, PRIMARY KEY (AuthorityReportTypeID, ItemFiltrationBy)
);

-- CREATE INDEXES ...
CREATE INDEX tblAuthorityReportTypeFillterationBy_AuthorityReportTypeID_idx ON tblAuthorityReportTypeFillterationBy (AuthorityReportTypeID);
CREATE INDEX tblAuthorityReportTypeFillterationBy_ItemFiltrationBy_idx ON tblAuthorityReportTypeFillterationBy (ItemFiltrationBy);

CREATE TABLE tblCalendar
 (
	ID			INTEGER, 
	YearID			INTEGER NOT NULL, 
	MonthID			INTEGER, 
	DayID			INTEGER, 
	TheDate			DateTime NOT NULL, 
	SeasonID			INTEGER
	, PRIMARY KEY (TheDate)
);

-- CREATE INDEXES ...
CREATE INDEX tblCalendar_tblCalendarID_idx ON tblCalendar (ID);
CREATE UNIQUE INDEX tblCalendar_TheDate_idx ON tblCalendar (TheDate);

CREATE TABLE tblClassRoom
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblClassRoom_FormID_idx ON tblClassRoom (ID);
CREATE UNIQUE INDEX tblClassRoom_NameAr_idx ON tblClassRoom (NameAr);
CREATE UNIQUE INDEX tblClassRoom_NameEn_idx ON tblClassRoom (NameEn);

CREATE TABLE tblColor
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	ColorCode			varchar, 
	ShortNameAr			varchar, 
	ShortNameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblColor_ColorCode_idx ON tblColor (ColorCode);
CREATE INDEX tblColor_FormID_idx ON tblColor (ID);
CREATE UNIQUE INDEX tblColor_NameAr_idx ON tblColor (NameAr);
CREATE UNIQUE INDEX tblColor_NameEn_idx ON tblColor (NameEn);

CREATE TABLE tblContractInstalllment
 (
	ID			INTEGER, 
	ContractID			INTEGER, 
	StageID			INTEGER, 
	Amount			INTEGER, 
	Note			TEXT, 
	OfferedStartDate			DateTime, 
	OfferedEndDate			DateTime, 
	ActuallyStartDate			DateTime, 
	ActuallyEndDate			DateTime, 
	FilePath			TEXT, 
	VAT			REAL, 
	VATValue			REAL, 
	VatTypeID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE UNIQUE INDEX tblContractInstalllment_ContractStageID_idx ON tblContractInstalllment (ContractID, StageID);
CREATE INDEX tblContractInstalllment_ID_idx ON tblContractInstalllment (ContractID);
CREATE INDEX tblContractInstalllment_StageID_idx ON tblContractInstalllment (StageID);

CREATE TABLE tblCurrency
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	Rate			REAL, 
	ShortName			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblCurrency_FormID_idx ON tblCurrency (ID);
CREATE UNIQUE INDEX tblCurrency_NameAr_idx ON tblCurrency (NameAr);
CREATE UNIQUE INDEX tblCurrency_NameEn_idx ON tblCurrency (NameEn);

CREATE TABLE tblCustomerWashingSpecifications
 (
	AccountID			INTEGER NOT NULL, 
	ItemID			INTEGER NOT NULL, 
	StarchTypeID			INTEGER, 
	BluingTypeID			INTEGER, 
	MerzamTypeID			INTEGER, 
	Perfuming			INTEGER NOT NULL, 
	Tsfit			INTEGER NOT NULL
	, PRIMARY KEY (AccountID, ItemID)
);

-- CREATE INDEXES ...
CREATE INDEX tblCustomerWashingSpecifications_AccointID_idx ON tblCustomerWashingSpecifications (AccountID);
CREATE INDEX tblCustomerWashingSpecifications_BluingTypeID_idx ON tblCustomerWashingSpecifications (MerzamTypeID);
CREATE INDEX tblCustomerWashingSpecifications_StarchTypeID_idx ON tblCustomerWashingSpecifications (StarchTypeID);
CREATE INDEX tblCustomerWashingSpecifications_StarchTypeID1_idx ON tblCustomerWashingSpecifications (BluingTypeID);
CREATE INDEX tblCustomerWashingSpecifications_tblInvoiceItemDataForLaundryID_idx ON tblCustomerWashingSpecifications (ItemID);

CREATE TABLE tblEducationLevel
 (
	ID			INTEGER, 
	NameAr			varchar, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tblExamLateStudent
 (
	ID			INTEGER, 
	WeekDayID			INTEGER, 
	ExamDate			varchar, 
	ExamPeriodID			INTEGER, 
	ExamTypeID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblExamLateStudent_ExamPeriodID_idx ON tblExamLateStudent (ExamPeriodID);
CREATE INDEX tblExamLateStudent_ExamTypeID_idx ON tblExamLateStudent (ExamTypeID);
CREATE INDEX tblExamLateStudent_ID_idx ON tblExamLateStudent (ID);
CREATE INDEX tblExamLateStudent_WeekDayID_idx ON tblExamLateStudent (WeekDayID);

CREATE TABLE tblFreeInvoice
 (
	InvoiceID			varchar NOT NULL, 
	InvoiceDate			DateTime NOT NULL
	, PRIMARY KEY (InvoiceID)
);

-- CREATE INDEXES ...

CREATE TABLE tblHouseType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblHouseType_FormID_idx ON tblHouseType (ID);
CREATE UNIQUE INDEX tblHouseType_NameAr_idx ON tblHouseType (NameAr);
CREATE UNIQUE INDEX tblHouseType_NameEn_idx ON tblHouseType (NameEn);

CREATE TABLE tblInstallmentPlanType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	CreditorAccountTypeID			INTEGER, 
	DebtorAccountTypeID			INTEGER, 
	CreditorAccountID			INTEGER, 
	DebtorAccountID			INTEGER, 
	SMSMessageText			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblInstallmentPlanType_CreditorAccountID_idx ON tblInstallmentPlanType (DebtorAccountID);
CREATE INDEX tblInstallmentPlanType_CreditorAccountTypeID_idx ON tblInstallmentPlanType (CreditorAccountTypeID);
CREATE INDEX tblInstallmentPlanType_CreditorAccountTypeID1_idx ON tblInstallmentPlanType (CreditorAccountID);
CREATE INDEX tblInstallmentPlanType_DebtorAccountTypeID_idx ON tblInstallmentPlanType (DebtorAccountTypeID);
CREATE INDEX tblInstallmentPlanType_FormID_idx ON tblInstallmentPlanType (ID);
CREATE UNIQUE INDEX tblInstallmentPlanType_NameAr_idx ON tblInstallmentPlanType (NameAr);
CREATE UNIQUE INDEX tblInstallmentPlanType_NameEn_idx ON tblInstallmentPlanType (NameEn);

CREATE TABLE tblInvoiceItem
 (
	InvoiceID			varchar, 
	ID			INTEGER, 
	ItemID			INTEGER, 
	Price			REAL NOT NULL, 
	Qty			REAL NOT NULL, 
	PlateQty			INTEGER, 
	Discount			REAL, 
	DiscountPercent			REAL, 
	UnitCost			REAL NOT NULL, 
	VAT			REAL, 
	ExpireDate			DateTime
	, PRIMARY KEY (InvoiceID, ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblInvoiceItem_InvoiceID_idx ON tblInvoiceItem (InvoiceID);
CREATE INDEX tblInvoiceItem_ItemID_idx ON tblInvoiceItem (ItemID);

CREATE TABLE tblInvoiceNoteType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblInvoiceNoteType_FormID_idx ON tblInvoiceNoteType (ID);
CREATE UNIQUE INDEX tblInvoiceNoteType_NameAr_idx ON tblInvoiceNoteType (NameAr);
CREATE UNIQUE INDEX tblInvoiceNoteType_NameEn_idx ON tblInvoiceNoteType (NameEn);

CREATE TABLE tblInvoiceSubmitType
 (
	Code			varchar NOT NULL, 
	DescriptionAr			varchar, 
	DescriptionEn			varchar
);

-- CREATE INDEXES ...

CREATE TABLE tblItemExpiryDate
 (
	ItemID			INTEGER, 
	ExpiryDate			DateTime, 
	Count			INTEGER
	, PRIMARY KEY (ItemID, ExpiryDate)
);

-- CREATE INDEXES ...

CREATE TABLE tblItemSize
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	Code			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblItemSize_FormID_idx ON tblItemSize (ID);
CREATE UNIQUE INDEX tblItemSize_NameAr_idx ON tblItemSize (NameAr);
CREATE UNIQUE INDEX tblItemSize_NameEn_idx ON tblItemSize (NameEn);

CREATE TABLE tblManagementLease
 (
	BranchID			INTEGER NOT NULL, 
	ID			INTEGER NOT NULL, 
	RealEstateID			INTEGER NOT NULL, 
	OwnerID			INTEGER NOT NULL, 
	LeaseDate			DateTime, 
	StartDate			DateTime NOT NULL, 
	DurationYearCount			INTEGER, 
	PaymentsCount			INTEGER NOT NULL, 
	Rent			INTEGER, 
	PaymentMethodID			INTEGER, 
	AdditionalConditions			TEXT, 
	LastPaymentDate			DateTime, 
	EndDate			DateTime, 
	CollectionCommission			REAL NOT NULL, 
	FirstYearCollectionCommission			REAL NOT NULL
	, PRIMARY KEY (BranchID, ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblManagementLease_BranchID_idx ON tblManagementLease (BranchID);
CREATE INDEX tblManagementLease_ID_idx ON tblManagementLease (ID);
CREATE INDEX tblManagementLease_OwnerID_idx ON tblManagementLease (OwnerID);
CREATE INDEX tblManagementLease_PaymentMethodID_idx ON tblManagementLease (PaymentMethodID);
CREATE INDEX tblManagementLease_RealEstateID_idx ON tblManagementLease (RealEstateID);

CREATE TABLE tblMoneyTransactionMethod
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	AccountTypeID			INTEGER NOT NULL, 
	MoneyAccountTypeID			INTEGER, 
	Code			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblMoneyTransactionMethod_FormID_idx ON tblMoneyTransactionMethod (ID);
CREATE INDEX tblMoneyTransactionMethod_MoneyAccountTypeID_idx ON tblMoneyTransactionMethod (AccountTypeID);

CREATE TABLE tblOrderExecution
 (
	ID			INTEGER, 
	InvoiceID			varchar, 
	InvoiceItemID			INTEGER, 
	TeamGroupID			INTEGER NOT NULL, 
	OrderDate			DateTime, 
	OrderExecutionDate			DateTime, 
	OrderExecutionStartTime			DateTime, 
	OrderExecutionEndTime			DateTime, 
	ExecutionStatusID			INTEGER, 
	ExecutionNote			TEXT, 
	PCID			INTEGER NOT NULL, 
	UserID			INTEGER, 
	MoneyTransactionID			varchar NOT NULL, 
	ID1			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblOrderExecution_ID_idx ON tblOrderExecution (ID);
CREATE INDEX tblOrderExecution_ImplementationStatusID_idx ON tblOrderExecution (ID1);
CREATE INDEX tblOrderExecution_InvoiceID_idx ON tblOrderExecution (InvoiceID);
CREATE UNIQUE INDEX tblOrderExecution_MoneyTransactionID_idx ON tblOrderExecution (MoneyTransactionID);
CREATE INDEX tblOrderExecution_PCID_idx ON tblOrderExecution (PCID);
CREATE INDEX tblOrderExecution_StatusID_idx ON tblOrderExecution (ExecutionStatusID);
CREATE INDEX tblOrderExecution_TeamGroupID_idx ON tblOrderExecution (TeamGroupID);
CREATE INDEX tblOrderExecution_UserID_idx ON tblOrderExecution (UserID);

CREATE TABLE tblPC
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	BranchID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblPC_BranchID_idx ON tblPC (BranchID);
CREATE INDEX tblPC_FormID_idx ON tblPC (ID);
CREATE UNIQUE INDEX tblPC_NameAr_idx ON tblPC (NameAr);
CREATE UNIQUE INDEX tblPC_NameEn_idx ON tblPC (NameEn);

CREATE TABLE tblPersonalStatus
 (
	ID			INTEGER, 
	NameAr			varchar, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tblPlace
 (
	ID			INTEGER, 
	NameAr			varchar, 
	NameEn			varchar, 
	CityID			INTEGER NOT NULL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblPlace_CityID_idx ON tblPlace (CityID);
CREATE UNIQUE INDEX tblPlace_ID_idx ON tblPlace (ID);
CREATE UNIQUE INDEX tblPlace_NameAr_idx ON tblPlace (NameAr);

CREATE TABLE tblProgramUseTypeBasicDataTable
 (
	ProgramUseTypeID			INTEGER, 
	BasicDataTableID			INTEGER, 
	IsUsed			INTEGER NOT NULL
	, PRIMARY KEY (ProgramUseTypeID, BasicDataTableID)
);

-- CREATE INDEXES ...
CREATE INDEX tblProgramUseTypeBasicDataTable_BasicDataTableID_idx ON tblProgramUseTypeBasicDataTable (BasicDataTableID);
CREATE INDEX tblProgramUseTypeBasicDataTable_ProgramID_idx ON tblProgramUseTypeBasicDataTable (ProgramUseTypeID);

CREATE TABLE tblReceipt
 (
	ID			varchar, 
	CodeID			INTEGER NOT NULL, 
	PCID			INTEGER NOT NULL, 
	ReceiptTypeID			INTEGER NOT NULL, 
	ReceiptDate			DateTime, 
	Amount			REAL NOT NULL, 
	Remark			varchar, 
	ReceptName			varchar, 
	MoneyTransactionMethodID			INTEGER NOT NULL, 
	CheckNo			varchar, 
	CheckBank			varchar, 
	CheckDate			DateTime, 
	CreditorID			INTEGER, 
	DebtorID			INTEGER NOT NULL, 
	MoneyTransactionID			varchar NOT NULL, 
	ReceiptSubjectID			INTEGER, 
	HandlyReceiptBy			varchar, 
	HandlyReceiptCode			varchar, 
	HandlyReceiptNo			INTEGER, 
	UserID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblReceipt_AccountID_idx ON tblReceipt (CreditorID);
CREATE INDEX tblReceipt_CodeID_idx ON tblReceipt (CodeID);
CREATE INDEX tblReceipt_DebtorID_idx ON tblReceipt (DebtorID);
CREATE INDEX tblReceipt_DescriptionID_idx ON tblReceipt (ReceiptSubjectID);
CREATE INDEX tblReceipt_HandlyReceiptCode_idx ON tblReceipt (HandlyReceiptCode);
CREATE INDEX tblReceipt_ID_idx ON tblReceipt (ReceiptTypeID);
CREATE UNIQUE INDEX tblReceipt_ID2_idx ON tblReceipt (ID);
CREATE INDEX tblReceipt_MoneyTransactionID_idx ON tblReceipt (MoneyTransactionID);
CREATE INDEX tblReceipt_MoneyTransactionMethodID_idx ON tblReceipt (MoneyTransactionMethodID);
CREATE INDEX tblReceipt_PCID_idx ON tblReceipt (PCID);
CREATE INDEX tblReceipt_UserID_idx ON tblReceipt (UserID);

CREATE TABLE tblReceiptSubject
 (
	ID			INTEGER, 
	DescriptionAr			varchar, 
	DescriptionEn			varchar, 
	AccountTypeID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblReceiptSubject_DebitAccountTypeID1_idx ON tblReceiptSubject (AccountTypeID);
CREATE INDEX tblReceiptSubject_ID_idx ON tblReceiptSubject (ID);

CREATE TABLE tblReligion
 (
	ID			INTEGER, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar NOT NULL
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE UNIQUE INDEX tblReligion_ReligionName_idx ON tblReligion (NameAr);
CREATE UNIQUE INDEX tblReligion_ReligionName1_idx ON tblReligion (NameEn);

CREATE TABLE tblRentLeaseRentGroupService
 (
	RentLeaseRentGroupID			INTEGER NOT NULL, 
	BranchID			INTEGER NOT NULL, 
	ServiceTypeID			INTEGER NOT NULL, 
	Price			REAL, 
	VAT			REAL, 
	VATValue			REAL, 
	VatTypeID			INTEGER
	, PRIMARY KEY (BranchID, RentLeaseRentGroupID, ServiceTypeID)
);

-- CREATE INDEXES ...
CREATE INDEX tblRentLeaseRentGroupService_BranchID_idx ON tblRentLeaseRentGroupService (BranchID);
CREATE INDEX tblRentLeaseRentGroupService_RentLeaseRentGroupID_idx ON tblRentLeaseRentGroupService (RentLeaseRentGroupID);
CREATE INDEX tblRentLeaseRentGroupService_ServiceTypeID_idx ON tblRentLeaseRentGroupService (ServiceTypeID);

CREATE TABLE tblResthouse_RentedOut
 (
	BranchID			INTEGER NOT NULL, 
	ResthouseRentLeaseID			INTEGER NOT NULL, 
	RentedOutDate			DateTime, 
	MoneyTransactionID			varchar NOT NULL
	, PRIMARY KEY (BranchID, ResthouseRentLeaseID)
);

-- CREATE INDEXES ...
CREATE INDEX tblResthouse_RentedOut_BranchID_idx ON tblResthouse_RentedOut (BranchID);
CREATE INDEX tblResthouse_RentedOut_ID_idx ON tblResthouse_RentedOut (ResthouseRentLeaseID);
CREATE UNIQUE INDEX tblResthouse_RentedOut_MoneyTransactionID_idx ON tblResthouse_RentedOut (BranchID, MoneyTransactionID);

CREATE TABLE tblRestHouse_UserGroupSetting
 (
	UserGroupID			INTEGER, 
	CancellationAllowBefore			INTEGER, 
	CanBookedWithin			INTEGER
	, PRIMARY KEY (UserGroupID)
);

-- CREATE INDEXES ...
CREATE INDEX tblRestHouse_UserGroupSetting_UserGroupID_idx ON tblRestHouse_UserGroupSetting (UserGroupID);

CREATE TABLE tblSMSMessageRentLeaseRentGroup
 (
	ID			INTEGER, 
	BranchID			INTEGER NOT NULL, 
	RentLeaseRentGroupID			INTEGER NOT NULL, 
	SMSMessageTypeID			INTEGER, 
	SMSMessageRecordID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblSMSMessageRentLeaseRentGroup_BranchID_idx ON tblSMSMessageRentLeaseRentGroup (BranchID);
CREATE INDEX tblSMSMessageRentLeaseRentGroup_RentLeaseRentGroupID_idx ON tblSMSMessageRentLeaseRentGroup (RentLeaseRentGroupID);
CREATE UNIQUE INDEX tblSMSMessageRentLeaseRentGroup_RentLeaseRentGroupMessageTypeID_idx ON tblSMSMessageRentLeaseRentGroup (BranchID, RentLeaseRentGroupID, SMSMessageTypeID);
CREATE INDEX tblSMSMessageRentLeaseRentGroup_SMSMessageTypeID_idx ON tblSMSMessageRentLeaseRentGroup (SMSMessageTypeID);

CREATE TABLE tblSpecialization
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblSpecialization_FormID_idx ON tblSpecialization (ID);
CREATE UNIQUE INDEX tblSpecialization_NameAr_idx ON tblSpecialization (NameAr);
CREATE UNIQUE INDEX tblSpecialization_NameEn_idx ON tblSpecialization (NameEn);

CREATE TABLE tblStudentCourse
 (
	StudentAccountID			INTEGER, 
	ApprovedCourseID			INTEGER, 
	MidTermMark			REAL, 
	FinalMark			REAL
	, PRIMARY KEY (StudentAccountID, ApprovedCourseID)
);

-- CREATE INDEXES ...
CREATE INDEX tblStudentCourse_ApprovedCourseID_idx ON tblStudentCourse (ApprovedCourseID);
CREATE INDEX tblStudentCourse_StudentAccountID_idx ON tblStudentCourse (StudentAccountID);

CREATE TABLE tblStudentWeeklyValuationList
 (
	StudentWeeklyValuationID			INTEGER, 
	StudentAccountID			INTEGER, 
	Mark			REAL, 
	Note			varchar
	, PRIMARY KEY (StudentWeeklyValuationID, StudentAccountID)
);

-- CREATE INDEXES ...
CREATE INDEX tblStudentWeeklyValuationList_ApprovedCourseID_idx ON tblStudentWeeklyValuationList (StudentWeeklyValuationID);
CREATE INDEX tblStudentWeeklyValuationList_StudentAccountID_idx ON tblStudentWeeklyValuationList (StudentAccountID);

CREATE TABLE tblSubmissionStatus
 (
	ID			INTEGER NOT NULL, 
	Description			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...

CREATE TABLE tblTeacherValuationRecord
 (
	ID			INTEGER, 
	StudyYearID			INTEGER, 
	TeacherVisitID			INTEGER, 
	TermID			INTEGER, 
	TeacherAccountID			INTEGER, 
	ValuationFormID			INTEGER, 
	ValuationDate			DateTime
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblTeacherValuationRecord_ID_idx ON tblTeacherValuationRecord (ID);
CREATE INDEX tblTeacherValuationRecord_StudyYearID_idx ON tblTeacherValuationRecord (StudyYearID);
CREATE INDEX tblTeacherValuationRecord_TeacherAccountID_idx ON tblTeacherValuationRecord (TeacherAccountID);
CREATE INDEX tblTeacherValuationRecord_TeacherVisitID_idx ON tblTeacherValuationRecord (TeacherVisitID);
CREATE INDEX tblTeacherValuationRecord_TermID_idx ON tblTeacherValuationRecord (TermID);
CREATE INDEX tblTeacherValuationRecord_ValuationFormID_idx ON tblTeacherValuationRecord (ValuationFormID);
CREATE UNIQUE INDEX tblTeacherValuationRecord_YearlyVisit_idx ON tblTeacherValuationRecord (TeacherAccountID, StudyYearID, TeacherVisitID);

CREATE TABLE tblTimeQuarter
 (
	ID			INTEGER, 
	TimeQuarter			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblTimeQuarter_ID_idx ON tblTimeQuarter (ID);

CREATE TABLE tblUnitType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar, 
	UnitTypeConditionID			INTEGER
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblUnitType_FormID_idx ON tblUnitType (ID);
CREATE UNIQUE INDEX tblUnitType_NameAr_idx ON tblUnitType (NameAr);
CREATE UNIQUE INDEX tblUnitType_NameEn_idx ON tblUnitType (NameEn);
CREATE INDEX tblUnitType_UnitTypeConditionID_idx ON tblUnitType (UnitTypeConditionID);

CREATE TABLE tblUserGroupAccount
 (
	UserGroupID			INTEGER, 
	AccountID			INTEGER, 
	IsUsed			INTEGER NOT NULL
	, PRIMARY KEY (UserGroupID, AccountID)
);

-- CREATE INDEXES ...
CREATE INDEX tblUserGroupAccount_AccountID_idx ON tblUserGroupAccount (AccountID);
CREATE INDEX tblUserGroupAccount_UserID_idx ON tblUserGroupAccount (UserGroupID);

CREATE TABLE tblValuationPersonType
 (
	ID			INTEGER NOT NULL, 
	NameAr			varchar NOT NULL, 
	NameEn			varchar
	, PRIMARY KEY (ID)
);

-- CREATE INDEXES ...
CREATE INDEX tblValuationPersonType_FormID_idx ON tblValuationPersonType (ID);
CREATE UNIQUE INDEX tblValuationPersonType_NameAr_idx ON tblValuationPersonType (NameAr);
CREATE UNIQUE INDEX tblValuationPersonType_NameEn_idx ON tblValuationPersonType (NameEn);

CREATE TABLE tblYear
 (
	YearID			INTEGER NOT NULL
	, PRIMARY KEY (YearID)
);

-- CREATE INDEXES ...
CREATE INDEX tblYear_FormID_idx ON tblYear (YearID);


