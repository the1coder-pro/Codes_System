-- SQL Server schema candidate from the exact-name legacy manifest.
-- Review type and index behavior against a real target before deployment.
-- Unicode text and wide numeric/date types avoid lossy value conversion.

CREATE TABLE [aa] (
  [AccountID] INT,
  [SumOfAmount] FLOAT(53),
  [id] INT
);

CREATE TABLE [Dual] (
  [id] INT,
  PRIMARY KEY ([id])
);

CREATE TABLE [Table1] (
  [ID] INT,
  [AccountID] INT,
  [Amount] FLOAT(53)
);

CREATE TABLE [tblAbsenceDay] (
  [ID] INT,
  [AccountID] INT NOT NULL,
  [AbsenceDate] DATETIME2,
  [AbsenceType] INT,
  [AbsenceDays] INT,
  [AbsenceHours] FLOAT(53),
  [AbsenceNote] NVARCHAR(255),
  [AbsenceDeduct] INT,
  [HospitalNo] INT,
  [SickenStatusNo] INT,
  [MedicamentCost] INT,
  [SendingNo] INT,
  [SupposedReturnDate] DATETIME2,
  [ActuallyReturnDate] DATETIME2,
  [DocumentImagePath] NVARCHAR(MAX),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblAbsenceProcedureRule] (
  [ID] INT,
  [WeeklyLessonsNo] INT,
  [AbsencePercentage] FLOAT(53),
  [AbsenceLessonsNo] INT,
  [AttendanceCaseID] INT,
  [ProcedureTypeID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblAbsenceType] (
  [ID] INT,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255) NOT NULL,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblAccountAccountType] (
  [AccountID] INT NOT NULL,
  [AccountTypeID] INT NOT NULL,
  PRIMARY KEY ([AccountID], [AccountTypeID])
);

CREATE TABLE [tblAccountChildren] (
  [ID] INT,
  [AccountID] INT,
  [CardID] NVARCHAR(255),
  [ChildrenName] NVARCHAR(255),
  [GenderID] INT,
  [EducationLevelID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblAccountChildrenHealthStatus] (
  [AccountChildrenID] INT,
  [DiseaseID] INT,
  [OtherDiseaseName] NVARCHAR(255),
  [StartDate] DATETIME2,
  PRIMARY KEY ([AccountChildrenID], [DiseaseID])
);

CREATE TABLE [tblAccountContact] (
  [AccountID] INT NOT NULL,
  [ContactTypeID] INT NOT NULL,
  [ContactID] NVARCHAR(255) NOT NULL,
  [ContactNote] NVARCHAR(255),
  [ToSend] INT NOT NULL,
  PRIMARY KEY ([AccountID], [ContactTypeID])
);

CREATE TABLE [tblAccountCulturalSide] (
  [ID] INT,
  [AccountID] INT,
  [CulturalName] NVARCHAR(255),
  [CulturalDate] DATETIME2,
  [CulturalSideTypeID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblAccountDocument] (
  [ID] INT,
  [AccountID] INT NOT NULL,
  [DocumentTypeID] INT NOT NULL,
  [DocumentID] NVARCHAR(255),
  [DocumentDate] DATETIME2,
  [DocumentExpDate] DATETIME2,
  [DocumentSource] NVARCHAR(255),
  [DocumentNote] NVARCHAR(255),
  [DocumentImagePath] NVARCHAR(MAX),
  [OtherDocumentTypeName] NVARCHAR(255),
  [UseInReporting] INT NOT NULL,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblAccountExperience] (
  [AccountID] INT,
  [ExperienceTypeID] INT,
  [OtherExperienceTypeName] NVARCHAR(255),
  [StartDate] DATETIME2,
  PRIMARY KEY ([AccountID], [ExperienceTypeID])
);

CREATE TABLE [tblAccountHealthStatus] (
  [AccountID] INT,
  [DiseaseID] INT,
  [OtherDiseaseName] NVARCHAR(255),
  [StartDate] DATETIME2,
  PRIMARY KEY ([AccountID], [DiseaseID])
);

CREATE TABLE [tblAccountItemUseType] (
  [AccountID] INT,
  [UseTypeID] INT,
  [IsUsed] INT NOT NULL,
  PRIMARY KEY ([UseTypeID], [AccountID])
);

CREATE TABLE [tblAccountNote] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [ColorID] INT,
  [ColorCode] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblAccountOldBalance] (
  [AccountID] INT NOT NULL,
  [MoneyTransactionID] NVARCHAR(255) NOT NULL,
  PRIMARY KEY ([AccountID], [MoneyTransactionID])
);

CREATE TABLE [tblAccountPricingGroup] (
  [AccountID] INT NOT NULL,
  [PricingGroupID] INT NOT NULL,
  [AllowDebit] INT NOT NULL,
  [MaximumDebitBalance] FLOAT(53) NOT NULL,
  [Remark] NVARCHAR(MAX),
  PRIMARY KEY ([AccountID])
);

CREATE TABLE [tblAccountRole] (
  [ID] INT,
  [name] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblAccountSide] (
  [ID] INT,
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblAccountStatus] (
  [ID] INT,
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255),
  [Operation] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblAccountSupport] (
  [AccountID] INT,
  PRIMARY KEY ([AccountID])
);

CREATE TABLE [tblAccountSupport1] (
  [AccountID] INT,
  PRIMARY KEY ([AccountID])
);

CREATE TABLE [tblAccountSupport2] (
  [AccountID] INT,
  PRIMARY KEY ([AccountID])
);

CREATE TABLE [tblAccountSupport3] (
  [AccountID] INT,
  PRIMARY KEY ([AccountID])
);

CREATE TABLE [tblAccountType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [StartID] INT,
  [EndID] INT,
  [PersonAccount] INT NOT NULL,
  [NotUsed] INT NOT NULL,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblApprovedCourse] (
  [ID] INT,
  [StudentTypeID] INT,
  [StudyTypeID] INT,
  [StudyLevelID] INT,
  [StudyYearID] INT,
  [TermID] INT,
  [TeacherAccountID] INT,
  [CourseID] INT,
  [StudyBookID] INT,
  [SubjectStartName] NVARCHAR(255),
  [SubjectStartPageNo] NVARCHAR(255),
  [SubjectEndName] NVARCHAR(255),
  [SubjectEndPageNo] NVARCHAR(255),
  [Notes] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblAssayRequest] (
  [ID] INT,
  [RequestDate] DATETIME2,
  [CustomerAccountID] INT,
  [IsClosed] INT NOT NULL,
  [PCID] INT NOT NULL,
  [UserID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblAssayRequestInvoice] (
  [AssayRequestID] INT,
  [InvoiceID] NVARCHAR(255),
  PRIMARY KEY ([AssayRequestID], [InvoiceID])
);

CREATE TABLE [tblAssayRequestProcedure] (
  [ID] INT,
  [AssayRequestID] INT,
  [ProcedureDate] DATETIME2,
  [StartTime] DATETIME2,
  [EndTime] DATETIME2,
  [SendToDelegateAccountID] INT,
  [AssayStatusID] INT,
  [ProcedureNote] NVARCHAR(MAX),
  [PCID] INT NOT NULL,
  [UserID] INT,
  [ExecutedByDelegateAccountID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblAttendanceCase] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblAuthority] (
  [UserGroupID] INT NOT NULL,
  [ObjectID] INT NOT NULL,
  [AllowShow] INT NOT NULL,
  [AllowAddition] INT NOT NULL,
  [AllowEdition] INT NOT NULL,
  [AllowDeletion] INT NOT NULL,
  [AllowPrint] INT NOT NULL,
  PRIMARY KEY ([UserGroupID], [ObjectID])
);

CREATE TABLE [tblAuthorityReportType] (
  [ID] INT,
  [UserGroupID] INT NOT NULL,
  [ObjectID] INT NOT NULL,
  [ReportTypeID] INT,
  [ToPrintDirect] INT NOT NULL,
  [OpenCashDrawer] INT NOT NULL,
  [IsUsed] INT NOT NULL,
  [printerName] NVARCHAR(255),
  [pageSize] NVARCHAR(255),
  [NumberOfCopies] INT,
  [PageMarginLeft] INT,
  [PageMarginRight] INT,
  [PageMarginTop] INT,
  [PageMarginBottom] INT,
  [Landscape] INT NOT NULL,
  [PaperSize] NVARCHAR(255),
  [PaperWidth] INT,
  [PaperHeight] INT,
  [IsCustomPaperSize] INT NOT NULL,
  [PaperSource] NVARCHAR(255),
  [IsFilltered] INT NOT NULL,
  [PCID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblAuthorizer] (
  [ID] INT,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255) NOT NULL,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblBackUp] (
  [BackUpDate] DATETIME2,
  [BackUpPath] NVARCHAR(255)
);

CREATE TABLE [tblBackUpHistory] (
  [BackUpDate] DATETIME2,
  [BackUpPath] NVARCHAR(255),
  [PCID] INT,
  [version] NVARCHAR(255),
  PRIMARY KEY ([PCID], [BackUpPath])
);

CREATE TABLE [tblBalanceSheetGroup] (
  [ID] INT,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255) NOT NULL,
  [PerntID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblBasicDataTables] (
  [ID] INT,
  [TableName] NVARCHAR(255),
  [FormTitleAr] NVARCHAR(255),
  [FormTitleEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblBillCopy] (
  [BillCopyID] INT,
  [CopyNameAr] NVARCHAR(255),
  [CopyNameEn] NVARCHAR(255),
  [BillCopyGroupID] INT,
  PRIMARY KEY ([BillCopyID])
);

CREATE TABLE [tblBillCopyGroup] (
  [ID] INT,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255) NOT NULL,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblBranch] (
  [ID] INT,
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255),
  [Phone] NVARCHAR(255),
  [Fax] NVARCHAR(255),
  [Mobile] NVARCHAR(255),
  [OwnerName] NVARCHAR(255),
  [Address] NVARCHAR(255),
  [POBox] NVARCHAR(255),
  [PO_Code] NVARCHAR(255),
  [Email] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblBuildingType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblCalendarType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblCardClass] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [Price] FLOAT(53),
  [FreePalance] FLOAT(53),
  [IsUsed] INT NOT NULL,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblCarType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblCategory] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblCity] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblClassDistributionTable] (
  [ID] INT,
  [ApprovedCourseID] INT,
  [TermID] INT,
  [WeekDayID] INT,
  [StudyClassID] INT,
  [ClassRoomID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblClient] (
  [ID] INT,
  [Name] NVARCHAR(255),
  [Mobile] NVARCHAR(255),
  [WhatsApp] NVARCHAR(255),
  [Email] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblCode] (
  [ID] INT NOT NULL,
  [Code] NVARCHAR(255) NOT NULL,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblCoding] (
  [ID] INT NOT NULL,
  [CodingGroupID] INT NOT NULL,
  [SortID] INT,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [SubOfCodeingID] INT,
  [ShortNameAr] NVARCHAR(255),
  [ShortNameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblCodingGroup] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblCodingGroupSubCodingGroup] (
  [MainCodingGroupID] INT,
  [SubCodingGroupID] INT,
  PRIMARY KEY ([MainCodingGroupID], [SubCodingGroupID])
);

CREATE TABLE [tblCodingSupport] (
  [ID] INT NOT NULL,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblCompanyDocument] (
  [ID] INT NOT NULL,
  [DocumentTypeID] INT NOT NULL,
  [DocumentID] NVARCHAR(255) NOT NULL,
  [DocumentDate] DATETIME2,
  [DocumentExpDate] DATETIME2,
  [DocumentSource] NVARCHAR(255),
  [DocumentNote] NVARCHAR(255),
  [DocumentImagePath] NVARCHAR(MAX),
  [OtherDocumentTypeName] NVARCHAR(255),
  [UseInReporting] INT NOT NULL,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblConditionClass] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [ConditionAr] NVARCHAR(450) NOT NULL,
  [ConditionEn] NVARCHAR(450),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblConfirmationType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblContactType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblContract] (
  [ID] INT,
  [CustomerID] INT,
  [ContractNameAr] NVARCHAR(255),
  [ContractNameEn] NVARCHAR(255),
  [ContractDate] DATETIME2,
  [ContractAmount] INT,
  [Note] NVARCHAR(MAX),
  [Condition] NVARCHAR(MAX),
  [VATValue] FLOAT(53),
  [VatTypeID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblContractInstalllmentMoneyTransaction] (
  [ContractInstalllmentID] INT,
  [MoneyTransactionID] NVARCHAR(255) NOT NULL,
  [DueDate] DATETIME2,
  PRIMARY KEY ([ContractInstalllmentID], [MoneyTransactionID])
);

CREATE TABLE [tblContractInvoice] (
  [ContractID] INT,
  [InvoiceID] NVARCHAR(255) NOT NULL,
  PRIMARY KEY ([ContractID], [InvoiceID])
);

CREATE TABLE [tblContractReceipt] (
  [ContractID] INT,
  [ReceiptID] NVARCHAR(255) NOT NULL,
  PRIMARY KEY ([ContractID], [ReceiptID])
);

CREATE TABLE [tblCopyFolder] (
  [ID] INT,
  [FolderPath] NVARCHAR(255),
  [PCID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblCountry] (
  [Alpha2Code] NVARCHAR(255) NOT NULL,
  [Alpha3Code] NVARCHAR(255),
  [PhoneCode] NVARCHAR(255),
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([Alpha2Code])
);

CREATE TABLE [tblCourse] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [WeeklyLessonsNo] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblCulturalSideType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblCurrencyBill] (
  [ID] FLOAT(53),
  [CurrencyID] FLOAT(53),
  [Value] FLOAT(53),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblCustomerNoteOnCompany] (
  [ID] INT,
  [NoteDate] DATETIME2,
  [NoteTime] DATETIME2,
  [CustomerAccountID] INT,
  [CustomerNoteTypeOnCompanyID] INT,
  [NoteDetail] NVARCHAR(MAX),
  [PCID] INT NOT NULL,
  [UserID] INT,
  [InvoiceID] NVARCHAR(255),
  [ItemID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblCustomerSourceData] (
  [CustomerID] INT,
  [SourceID] INT,
  [SourceEmployeeID] INT,
  [CityID] INT,
  [RegistrationDate] DATETIME2,
  PRIMARY KEY ([CustomerID])
);

CREATE TABLE [tblDailySchedule] (
  [ID] INT,
  [BranchID] INT NOT NULL,
  [UserID] INT NOT NULL,
  [ScheduleDate] DATETIME2,
  [ScheduleTime] DATETIME2,
  [Subject] NVARCHAR(255),
  [Location] NVARCHAR(255),
  [Remark] NVARCHAR(MAX),
  [ExecutionStatusID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblDay] (
  [DayID] INT,
  PRIMARY KEY ([DayID])
);

CREATE TABLE [tblDisease] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblDividendOperation] (
  [ID] INT,
  [DividendDate] DATETIME2,
  [Note] NVARCHAR(MAX),
  [MoneyTransactionID] NVARCHAR(255) NOT NULL,
  [CurrentNetProfitAndloss] FLOAT(53),
  [InvestorsBeforeDividendTotalBalance] FLOAT(53),
  [ManagementRate] FLOAT(53),
  [InvestorsRate] FLOAT(53),
  [AmanFundRate] FLOAT(53),
  [ManagementRateAmount] FLOAT(53),
  [InvestorsRateAmount] FLOAT(53),
  [AmanFundRateAmount] FLOAT(53),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblDividendOperationInvestors] (
  [DividendOperationID] INT,
  [InvestorID] INT,
  [InvestorBeforeDividendBalance] FLOAT(53),
  [InvestorBeforeDividendBalancePercentage] FLOAT(53),
  [DividendAmount] FLOAT(53),
  [Remark] NVARCHAR(255),
  PRIMARY KEY ([DividendOperationID], [InvestorID])
);

CREATE TABLE [tblDividendOperationMenagment] (
  [DividendOperationID] INT,
  [AccountID] INT,
  [JobID] INT,
  [DividendAmount] FLOAT(53),
  PRIMARY KEY ([DividendOperationID], [AccountID])
);

CREATE TABLE [tblDividendRatios] (
  [ManagementRate] FLOAT(53),
  [InvestorsRate] FLOAT(53),
  [AmanFundRate] FLOAT(53)
);

CREATE TABLE [tblDocumentType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [Code] NVARCHAR(255),
  [UseLevel] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblEducationMajor] (
  [ID] INT,
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblEmployeeAttendance] (
  [ID] INT,
  [AccountID] INT,
  [WorkPeriodID] INT,
  [CheckInTime] DATETIME2,
  [TimeOut] DATETIME2,
  [Notes] NVARCHAR(255),
  [PCID] INT,
  [InputMeansID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblEmployeeContact] (
  [BranchID] INT NOT NULL,
  [EmployeeID] INT NOT NULL,
  [ContactTypeID] INT NOT NULL,
  [ContactID] NVARCHAR(255),
  [ContactNote] NVARCHAR(255),
  PRIMARY KEY ([BranchID], [EmployeeID], [ContactTypeID])
);

CREATE TABLE [tblEmployeeDocument] (
  [BranchID] INT NOT NULL,
  [EmployeeID] INT NOT NULL,
  [DocumentTypeNo] INT NOT NULL,
  [DocumentID] NVARCHAR(255),
  [DocumentDate] DATETIME2,
  [DocumentExpDate] DATETIME2,
  [DocumentSource] NVARCHAR(255),
  [DocumentNote] NVARCHAR(255),
  [DocumentImagePath] NVARCHAR(MAX),
  PRIMARY KEY ([BranchID], [EmployeeID], [DocumentTypeNo])
);

CREATE TABLE [tblEmployeeType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblExamControl] (
  [ExamDistributionTableID] INT,
  [WatcherAccountID] INT,
  [PaperCount] INT,
  [CorrectionFinishDate] NVARCHAR(255),
  [SubjectStartName] NVARCHAR(255),
  [SubjectEndName] NVARCHAR(255),
  [MarkEntered] INT NOT NULL,
  [Revision] INT NOT NULL,
  PRIMARY KEY ([ExamDistributionTableID])
);

CREATE TABLE [tblExamDistributionTable] (
  [ID] INT,
  [ApprovedCourseID] INT,
  [TermID] INT,
  [ExamTypeID] INT,
  [WeekDayID] INT,
  [WeekID] INT,
  [ExamPeriodID] INT,
  [ClassRoomID] INT
);

CREATE TABLE [tblExamLateStudentList] (
  [ExamLateStudentID] INT,
  [StudentAccountID] INT,
  [ApprovedCourseID] INT,
  [Note] NVARCHAR(255),
  PRIMARY KEY ([ExamLateStudentID], [StudentAccountID])
);

CREATE TABLE [tblExamObjection] (
  [ID] INT,
  [ObjectionDate] NVARCHAR(255),
  [StudentAccountID] INT,
  [ExamDistributionTableID] INT NOT NULL,
  [ObjectionTypeID] INT,
  [ObjectionText] NVARCHAR(MAX),
  [ReviewerAccountID] INT,
  [Accepted] INT NOT NULL,
  [Reason] NVARCHAR(MAX),
  [ExaminationUnitNote] NVARCHAR(MAX),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblExamPeriod] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblExamType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblExecutionStatus] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblExperienceType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblGender] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblGeneralGrade] (
  [ID] INT,
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255),
  [LaterAr] NVARCHAR(255),
  [LaterEn] NVARCHAR(255),
  [StartMark] FLOAT(53),
  [EndMark] FLOAT(53),
  [StartMarkIncluded] INT NOT NULL,
  [EndMarkIncluded] INT NOT NULL
);

CREATE TABLE [tblGenralDiscount] (
  [ID] INT,
  [CreationDate] DATETIME2,
  [Discount] INT,
  [StartDate] DATETIME2,
  [EndDate] DATETIME2,
  [Remark] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblGrade] (
  [ID] INT,
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255),
  [LaterAr] NVARCHAR(255),
  [LaterEn] NVARCHAR(255),
  [StartMark] FLOAT(53),
  [EndMark] FLOAT(53),
  [Value] FLOAT(53),
  [StartMarkIncluded] INT NOT NULL,
  [EndMarkIncluded] INT NOT NULL,
  [IsSelected] INT NOT NULL,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblGroupedCategory] (
  [ID] INT NOT NULL,
  [CategoryLater] NVARCHAR(255) NOT NULL,
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255),
  [LeaveStatement] NVARCHAR(MAX),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblHonorDegreeType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblHospital] (
  [ID] INT,
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255),
  [DocumentImagePath] NVARCHAR(MAX),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblHousingType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblIncomeStatementGroup] (
  [ID] INT,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255) NOT NULL,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblInputMeans] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblInstallment] (
  [BranchID] INT NOT NULL,
  [InstallmentPlanID] INT NOT NULL,
  [InstallmentID] INT NOT NULL,
  [InstallmentDate] DATETIME2,
  [InstallmentAmount] FLOAT(53),
  [Remark] NVARCHAR(255),
  PRIMARY KEY ([BranchID], [InstallmentPlanID], [InstallmentID])
);

CREATE TABLE [tblInstallmentPlan] (
  [BranchID] INT NOT NULL,
  [ID] INT,
  [InstallmentPlanTypeID] INT,
  [AccountID] INT,
  [PlanDate] DATETIME2,
  [PlanAmount] FLOAT(53),
  [InstallmentCount] INT,
  [FirstInstallmentDate] DATETIME2,
  [InstallmentPeriodTypeID] INT,
  [Remark] NVARCHAR(MAX),
  [UserID] INT,
  [AuthorizerID] INT,
  [PaymentMethodID] INT,
  [SponsorID] INT,
  [MoneyTransactionID] NVARCHAR(255) NOT NULL,
  [PaidInstallmentCount] INT,
  [PaidAmount] FLOAT(53),
  [LastInstallmentID] INT,
  [LastPaymentDate] DATETIME2,
  [Conditions] NVARCHAR(MAX),
  [ConditionClassID] INT,
  PRIMARY KEY ([ID], [BranchID])
);

CREATE TABLE [tblInsurancePersent] (
  [ICS] FLOAT(53),
  [IES] FLOAT(53),
  [ICNS] FLOAT(53),
  [IENS] FLOAT(53)
);

CREATE TABLE [tblInvoice] (
  [ID] NVARCHAR(255),
  [CodeID] INT NOT NULL,
  [PCID] INT NOT NULL,
  [InvoiceTypeID] INT,
  [CreditorID] INT,
  [DebtorID] INT,
  [InvoiceNo] NVARCHAR(255),
  [InvoiceDate] DATETIME2 NOT NULL,
  [CreditorPersonID] INT,
  [DebitorPersonID] INT,
  [Amount] FLOAT(53),
  [Discount] FLOAT(53),
  [BeforehandSum] FLOAT(53),
  [RetrieveSum] FLOAT(53),
  [PaidSum] FLOAT(53),
  [DueDate] DATETIME2,
  [Remark] NVARCHAR(255),
  [NoteTypeID] INT,
  [GivingDate] DATETIME2,
  [AccountName] NVARCHAR(255),
  [GivingTime] DATETIME2,
  [Pledge] FLOAT(53),
  [PlateQty] INT,
  [ReceivedPlateQty] INT,
  [RemainSum] FLOAT(53),
  [StoreCreditorID] INT,
  [StoreDebtorID] INT,
  [UserID] INT,
  [AuthorizerID] INT,
  [MoneyTransactionID] NVARCHAR(255) NOT NULL,
  [UrgentTypeID] INT,
  [TableID] INT,
  [OrderType] INT,
  [VATValue] FLOAT(53),
  [VatTypeID] INT,
  [VATNo] NVARCHAR(255),
  [InvoiceTime] DATETIME2,
  [ReternedInvoiceID] NVARCHAR(255),
  [VAT] FLOAT(53),
  [IssueDate] DATETIME2,
  [ReturnReason] NVARCHAR(255),
  [SubmissionStatusID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblInvoiceAllowanceChargeReason] (
  [InvoiceID] NVARCHAR(255) NOT NULL,
  [AllowanceChargeReasonCode] NVARCHAR(255),
  [ChargeIndicator] INT NOT NULL,
  [CurrencyID] INT,
  [Amount] FLOAT(53),
  PRIMARY KEY ([InvoiceID], [AllowanceChargeReasonCode])
);

CREATE TABLE [tblInvoiceCancellation] (
  [InvoiceID] NVARCHAR(255),
  [CancellationDate] DATETIME2,
  [CancellationReason] NVARCHAR(255),
  PRIMARY KEY ([InvoiceID])
);

CREATE TABLE [tblInvoiceContact] (
  [InvoiceID] NVARCHAR(255) NOT NULL,
  [ContactTypeID] INT NOT NULL,
  [ContactID] NVARCHAR(255) NOT NULL,
  [ContactNote] NVARCHAR(255),
  [ToSend] INT NOT NULL,
  PRIMARY KEY ([InvoiceID], [ContactTypeID])
);

CREATE TABLE [tblInvoiceCopy] (
  [ID] INT,
  [RecCopyName] NVARCHAR(255),
  [SpentCopyName] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblInvoiceDesignDetails] (
  [InvoiceID] NVARCHAR(255),
  [ShirtL] INT,
  [ShirtS] INT,
  [ShirtC] INT,
  [ShirtW] INT,
  [ShirtF] INT,
  [ShirtCL] INT,
  [PantsL1] INT,
  [PantsW] INT,
  [PantsR] INT,
  [PantsH] INT,
  [PantsM] INT,
  [PantsL2] INT,
  [VestL] INT,
  [VestS] INT,
  [VestC] INT,
  [VestA] INT,
  [DesignNote] NVARCHAR(MAX),
  PRIMARY KEY ([InvoiceID])
);

CREATE TABLE [tblInvoiceItemAccount] (
  [InvoiceID] NVARCHAR(255),
  [ID] INT,
  [AccountID] INT NOT NULL,
  PRIMARY KEY ([InvoiceID], [ID])
);

CREATE TABLE [tblInvoiceItemAllowanceChargeReason] (
  [InvoiceID] NVARCHAR(255) NOT NULL,
  [InvoiceItemID] INT NOT NULL,
  [ChargeIndicator] INT NOT NULL,
  [AllowanceChargeReasonCode] NVARCHAR(255) NOT NULL,
  [CurrencyID] INT,
  [Amount] FLOAT(53),
  PRIMARY KEY ([InvoiceID], [InvoiceItemID])
);

CREATE TABLE [tblInvoiceItemConsumables] (
  [InvoiceID] NVARCHAR(255),
  [ID] INT,
  [ConsumableItemID] INT,
  [Qty] FLOAT(53) NOT NULL,
  [UnitCost] FLOAT(53) NOT NULL,
  PRIMARY KEY ([InvoiceID], [ID], [ConsumableItemID])
);

CREATE TABLE [tblInvoiceItemDataForLaundry] (
  [InvoiceID] NVARCHAR(255),
  [InvoiceItemID] INT,
  [StarchTypeID] INT,
  [BluingTypeID] INT,
  [MerzamTypeID] INT,
  [HaveSpot] INT NOT NULL,
  [Perfuming] INT NOT NULL,
  [Tsfit] INT NOT NULL,
  PRIMARY KEY ([InvoiceID], [InvoiceItemID])
);

CREATE TABLE [tblInvoiceItemDataForRestaurant] (
  [InvoiceID] NVARCHAR(255),
  [InvoiceItemID] INT,
  [SauceTypeID] INT,
  [TahininhTypeID] INT,
  [KetchupTypeID] INT,
  [SaladTypeID] INT,
  [PotatoTypeID] INT,
  [MayonnaiseTypeID] INT,
  PRIMARY KEY ([InvoiceID], [InvoiceItemID])
);

CREATE TABLE [tblInvoiceItemNote] (
  [InvoiceID] NVARCHAR(255),
  [ID] INT,
  [Note] NVARCHAR(MAX),
  PRIMARY KEY ([InvoiceID], [ID])
);

CREATE TABLE [tblInvoiceRealEstate] (
  [InvoiceID] NVARCHAR(255),
  [RealEstateID] INT,
  PRIMARY KEY ([InvoiceID], [RealEstateID])
);

CREATE TABLE [tblInvoiceRealestateUnit] (
  [InvoiceID] NVARCHAR(255),
  [BranchID] INT NOT NULL,
  [UnitID] INT,
  PRIMARY KEY ([InvoiceID], [BranchID], [UnitID])
);

CREATE TABLE [tblInvoiceReportType] (
  [ReportName] NVARCHAR(255),
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ReportName])
);

CREATE TABLE [tblInvoiceStatus] (
  [InvoiceID] NVARCHAR(255),
  [StatusDate] DATETIME2,
  [StatusTypeID] INT,
  [Remark] NVARCHAR(255),
  PRIMARY KEY ([InvoiceID])
);

CREATE TABLE [tblInvoiceType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [CreditorTypeID] INT,
  [DebtorTypeID] INT,
  [StoreCreditorTypeID] INT,
  [StoreDebitorTypeID] INT,
  [Used] INT NOT NULL,
  [ColorCode] NVARCHAR(255),
  [BalnceSign] INT,
  [DiscountPriceCheck] INT NOT NULL,
  [ObjectID] INT,
  [affectsItemCost] INT NOT NULL,
  [personAccountRole] INT,
  [ItemBalanceColumn] NVARCHAR(255),
  [InvoiceTypeCode] NVARCHAR(255),
  [InvoiceSubTypeCode] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblInvoiceTypeItemUseType] (
  [InvoiceTypeID] INT,
  [UseTypeID] INT,
  [IsUsed] INT NOT NULL,
  PRIMARY KEY ([InvoiceTypeID], [UseTypeID])
);

CREATE TABLE [tblInvoiceTypeLink] (
  [ID] INT,
  [InvoiceTypeID] INT,
  [ReturnInvoiceTypeID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblInvoiceTypeObject] (
  [InvoiceTypeID] INT,
  [ObjectID] INT NOT NULL,
  PRIMARY KEY ([InvoiceTypeID])
);

CREATE TABLE [tblItem] (
  [ID] INT,
  [Price] FLOAT(53) NOT NULL,
  [MinimumPrice] FLOAT(53) NOT NULL,
  [WholesalePrice] FLOAT(53) NOT NULL,
  [quickitem] INT NOT NULL,
  [ItemGroupID] INT,
  [WithVatPrice] FLOAT(53),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblItemBalance] (
  [ItemID] INT,
  [StartPeriodBalance] FLOAT(53),
  [PurchaseCount] FLOAT(53),
  [PurchaseReturnCount] FLOAT(53),
  [SalesCount] FLOAT(53),
  [SalesReturnCount] FLOAT(53),
  [SpentCount] FLOAT(53),
  [SpentReturnCount] FLOAT(53),
  [RentalCount] FLOAT(53),
  [RentalReturnCount] FLOAT(53),
  [OrderMinammBalance] FLOAT(53),
  [OrderCount] FLOAT(53),
  [DecayedCount] FLOAT(53),
  [DecayedReturnCount] FLOAT(53),
  [ProductionCount] FLOAT(53),
  [ProductionCancelCount] FLOAT(53),
  [ProductionReturnCount] FLOAT(53),
  [PurchaseOrderCount] FLOAT(53),
  [SalesOrderCount] FLOAT(53),
  [PackingAndUnPackingCount] FLOAT(53),
  [StartPeriodBalanceReturn] FLOAT(53),
  [LastPurchaseDate] DATETIME2,
  [MinPurchasePrice] FLOAT(53),
  [MaxPurchasePrice] FLOAT(53),
  [LastPurchasePrice] FLOAT(53),
  [Qty] FLOAT(53),
  [CostPrice] FLOAT(53),
  [LastSalesDate] DATETIME2,
  [MinSalesPrice] FLOAT(53),
  [MaxSalesPrice] FLOAT(53),
  [LastSalesPrice] FLOAT(53),
  PRIMARY KEY ([ItemID])
);

CREATE TABLE [tblItemBalanceHistory] (
  [PeriodID] INT,
  [ItemID] INT,
  [StartPeriodBalance] FLOAT(53),
  [PurchaseCount] FLOAT(53),
  [PurchaseReturnCount] FLOAT(53),
  [SalesCount] FLOAT(53),
  [SalesReturnCount] FLOAT(53),
  [SpentCount] FLOAT(53),
  [SpentReturnCount] FLOAT(53),
  [RentalCount] FLOAT(53),
  [RentalReturnCount] FLOAT(53),
  [OrderMinammBalance] FLOAT(53),
  [OrderCount] FLOAT(53),
  [DecayedCount] FLOAT(53),
  [DecayedReturnCount] FLOAT(53),
  [ProductionCount] FLOAT(53),
  [ProductionCancelCount] FLOAT(53),
  [ProductionReturnCount] FLOAT(53),
  [PurchaseOrderCount] FLOAT(53),
  [SalesOrderCount] FLOAT(53),
  [PackingAndUnPackingCount] FLOAT(53)
);

CREATE TABLE [tblItemBlancePeriod] (
  [ID] INT,
  [StartDate] DATETIME2,
  [EndDate] DATETIME2,
  [Remark] NVARCHAR(MAX),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblItemCarData] (
  [ItemID] INT,
  [CarCompanyID] INT,
  [CarNameID] INT,
  [ModelFromID] INT,
  [ModelToID] INT,
  [MadeCountryID] INT,
  [ItemCompanyID] INT,
  [EngineSizeID] INT,
  [LocationInCarID] INT,
  [CylinderCountID] INT,
  [GearTypeID] INT,
  [ElectricalTypeID] INT,
  [AgencyNo] NVARCHAR(255),
  [DefrentText] NVARCHAR(255),
  PRIMARY KEY ([ItemID])
);

CREATE TABLE [tblItemConsumables] (
  [ItemID] INT,
  [ConsumableItemID] INT,
  [Qty] FLOAT(53) NOT NULL,
  [InvoiceTypeID] INT,
  PRIMARY KEY ([ItemID], [ConsumableItemID])
);

CREATE TABLE [tblItemGroup] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [ShortName] NVARCHAR(255),
  [VAT] FLOAT(53),
  [NotUsed] INT NOT NULL,
  [UseTypeID] INT,
  [ItemTypeID] INT,
  [FilePath] NVARCHAR(MAX),
  [ItemNote] NVARCHAR(MAX),
  [VaTCategoriesID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblItemOtherData] (
  [ItemID] INT,
  [ColorID] INT,
  [BarcodeNo] NVARCHAR(255),
  [ItemPlaceID] INT,
  [ItemSizeID] INT,
  [UnitCount] FLOAT(53),
  PRIMARY KEY ([ItemID])
);

CREATE TABLE [tblItemPackingAndUnPacking] (
  [ID] NVARCHAR(255) NOT NULL,
  [PackingDate] DATETIME2,
  [UserID] INT,
  [StoreCreditorID] INT NOT NULL,
  [StoreDebtorID] INT NOT NULL,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblItemPackingAndUnPackingDetails] (
  [ItemPackingAndUnPackingID] NVARCHAR(255) NOT NULL,
  [ID] INT NOT NULL,
  [CreditorItemID] INT NOT NULL,
  [CreditorItemCount] FLOAT(53) NOT NULL,
  [CreditorItemPrice] FLOAT(53) NOT NULL,
  [DebtorItemID] INT NOT NULL,
  [DebtorItemCount] FLOAT(53) NOT NULL,
  [DebtorItemPrice] FLOAT(53) NOT NULL,
  PRIMARY KEY ([ItemPackingAndUnPackingID], [ID])
);

CREATE TABLE [tblItemPlace] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblItemType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [ShortNameAr] NVARCHAR(255),
  [ShortNameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblJob] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblJournalEntry] (
  [ID] NVARCHAR(255),
  [CodeID] INT NOT NULL,
  [PCID] INT NOT NULL,
  [EnteryDate] DATETIME2,
  [Remark] NVARCHAR(255),
  [MoneyTransactionID] NVARCHAR(255) NOT NULL,
  [UserID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblJournalEntryCancellation] (
  [JournalEntryID] NVARCHAR(255) NOT NULL,
  [CancellationDate] DATETIME2,
  [CancellationReason] NVARCHAR(255),
  PRIMARY KEY ([JournalEntryID])
);

CREATE TABLE [tblManagement] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblMark] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblMoneyAccountType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblMoneyTransaction] (
  [ID] NVARCHAR(255),
  [CodeID] INT NOT NULL,
  [PCID] INT NOT NULL,
  [TransactionDate] DATETIME2 NOT NULL,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblMoneyTransactionDetails] (
  [ID] INT NOT NULL,
  [MoneyTransactionID] NVARCHAR(255) NOT NULL,
  [AccountSideID] INT NOT NULL,
  [AccountID] INT NOT NULL,
  [Amount] FLOAT(53) NOT NULL,
  [Description] NVARCHAR(255),
  [DescriptionID] INT,
  [MoneyTransactionMethodID] INT NOT NULL,
  [PaidAmount] FLOAT(53),
  [CurrencyID] INT,
  [ToDelete] INT NOT NULL,
  [MoneyTransactionDetailTypeID] INT,
  [AllowanceChargeReasonCode] NVARCHAR(255)
);

CREATE TABLE [tblMoneyTransactionDetailType] (
  [ID] INT,
  [nameAr] NVARCHAR(255),
  [nameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblMoneyTransactionInvoice] (
  [InvoiceID] NVARCHAR(255) NOT NULL,
  [MoneyTransactionID] NVARCHAR(255) NOT NULL,
  [Amount] FLOAT(53) NOT NULL,
  PRIMARY KEY ([InvoiceID])
);

CREATE TABLE [tblMonth] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblNationality] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblNoteOnCompany] (
  [ID] INT,
  [NoteDate] DATETIME2,
  [NoteTime] DATETIME2,
  [CustomerAccountID] INT,
  [NoteTypeID] INT,
  [NoteDetail] NVARCHAR(MAX),
  [InvoiceID] NVARCHAR(255),
  [PCID] INT NOT NULL,
  [UserID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblNoteOnCustomer] (
  [ID] INT,
  [NoteDate] DATETIME2,
  [NoteTime] DATETIME2,
  [CustomerAccountID] INT,
  [CustomerNoteTypeID] INT,
  [NoteDetail] NVARCHAR(MAX),
  [PCID] INT NOT NULL,
  [UserID] INT,
  [InvoiceID] NVARCHAR(255),
  [NoteSourceID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblNoteOnEmployee] (
  [ID] INT,
  [NoteDate] DATETIME2,
  [NoteTime] DATETIME2,
  [CustomerAccountID] INT,
  [NoteTypeID] INT,
  [NoteDetail] NVARCHAR(MAX),
  [InvoiceID] NVARCHAR(255),
  [NoteSourceID] INT,
  [PCID] INT NOT NULL,
  [UserID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblObject] (
  [ID] INT,
  [ObjectName] NVARCHAR(255),
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255),
  [ObjectTypeID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblObjectionType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblObjectType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblOrderExecutionMember] (
  [OrderExecutionID] INT,
  [MemberAccountID] INT,
  [TeamGroupID] INT NOT NULL,
  [MemberShare] FLOAT(53),
  [MemberStatusID] INT,
  PRIMARY KEY ([OrderExecutionID], [MemberAccountID])
);

CREATE TABLE [tblOrderType] (
  [ID] INT,
  [nameAr] NVARCHAR(255),
  [nameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblOwnersEquityGroup] (
  [ID] INT,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255) NOT NULL,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblPaymentMethod] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [MoneyAccountTypeID] INT NOT NULL,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblPaymentPeriodType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [PeriodTypeCode] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblPaymentSubject] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblPCSetting] (
  [PCID] INT NOT NULL,
  [OpenCashDrawer] INT NOT NULL,
  [CashDrawerSettings] NVARCHAR(255),
  [CashDrawerOutput] NVARCHAR(255),
  [CopyNo] NVARCHAR(255),
  [CopyStartDate] DATETIME2,
  [CopyEndDate] DATETIME2,
  [MyDrive] NVARCHAR(255),
  [MyDir] NVARCHAR(255),
  [LastUpdateDate] DATETIME2,
  [AutoDownloadUpdate] INT NOT NULL,
  [TouchScreen] INT NOT NULL,
  [bilingualDisplay] INT NOT NULL,
  [RegistrationID] INT,
  [PrivateKey] VARBINARY(MAX),
  [PublicKey] VARBINARY(MAX),
  [UpdateStatus] INT,
  [ICV] INT,
  [LocationAddress] NVARCHAR(255),
  [InvoiceSubmitTypeCode] NVARCHAR(255),
  [Secret] NVARCHAR(MAX),
  [PIH] NVARCHAR(MAX),
  [RequestID] NVARCHAR(255),
  [BinarySecurityToken] NVARCHAR(MAX),
  PRIMARY KEY ([PCID])
);

CREATE TABLE [tblPeriodType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [DayCount] FLOAT(53),
  [PeriodTypeCode] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblPersonalCategory] (
  [AccountID] INT NOT NULL,
  [CategoryID] INT NOT NULL,
  PRIMARY KEY ([AccountID], [CategoryID])
);

CREATE TABLE [tblPersonalData] (
  [AccountID] INT NOT NULL,
  [GenderID] INT,
  [ReligionID] INT,
  [BirthDate] DATETIME2,
  [BirthPlace] NVARCHAR(255),
  [PersonalStatusID] INT,
  [SonCount] INT,
  [EducationMajorID] INT,
  [EducationLevelID] INT,
  [JobID] INT,
  [StartingDate] DATETIME2,
  [Salary] INT,
  [InsuranceNo] NVARCHAR(255),
  [InsuranceByCompany] INT,
  [InsuranceByEmployee] INT,
  [HousingEquivalent] INT,
  [LiveEquivalent] INT,
  [TransportationEquivalent] INT,
  [EntryNo] NVARCHAR(255),
  [EntryDate] DATETIME2,
  [EntryPortal] NVARCHAR(255),
  [StayPeriodYear] INT,
  [StayPeriodMonth] INT,
  [SponsorID] INT,
  [WorkAsFirstSaid] INT NOT NULL,
  [WorkDayRate] INT,
  [Runaway] INT,
  [RunawayDate] DATETIME2,
  [RunawayDocumentImagePath] NVARCHAR(MAX),
  [EducationDocumentImagePath] NVARCHAR(MAX),
  [SalaryDocumentImagePath] NVARCHAR(MAX),
  [EntryDocumentImagePath] NVARCHAR(MAX),
  [Address] NVARCHAR(255),
  [PresentPost] NVARCHAR(255),
  [WorkPlace] NVARCHAR(255),
  [AccountNoteID] INT,
  [PO_Box] NVARCHAR(255),
  [PO_Code] NVARCHAR(255),
  [TitleID] INT,
  [PlaceID] INT,
  [ToPrint] INT NOT NULL,
  [WivesNo] INT,
  [PersonalPhotoImagePath] NVARCHAR(MAX),
  [ContactPersonID] INT,
  [StudyLevelID] INT,
  [SpecializationID] INT,
  [ManagementID] INT,
  [SectionID] INT,
  [EmployeeTypeID] INT,
  PRIMARY KEY ([AccountID])
);

CREATE TABLE [tblPersonalGroupedCategory] (
  [AccountID] INT NOT NULL,
  [GroupedCategoryID] INT NOT NULL,
  PRIMARY KEY ([AccountID], [GroupedCategoryID])
);

CREATE TABLE [tblPhoneDirectory] (
  [ID] INT,
  [BranchID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [Address] NVARCHAR(255),
  [NationalityID] INT,
  [WorkPlace] NVARCHAR(255),
  [SexID] INT,
  [ToDealing] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblPhoneDirectoryContact] (
  [PhoneDirectoryID] INT NOT NULL,
  [ContactTypeID] INT NOT NULL,
  [ContactID] NVARCHAR(255) NOT NULL,
  [ContactNote] NVARCHAR(255),
  PRIMARY KEY ([PhoneDirectoryID], [ContactTypeID])
);

CREATE TABLE [tblPictureData] (
  [ID] INT,
  [PictureDate] NVARCHAR(255),
  [Title] NVARCHAR(255),
  [Occasion] INT,
  [PlaceID] INT,
  [SourceID] INT,
  [OtherInformation] NVARCHAR(MAX),
  [ImagePath] NVARCHAR(MAX),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblPictureOccasion] (
  [ID] INT,
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255)
);

CREATE TABLE [tblPicturePerson] (
  [PictureID] INT,
  [PersonID] INT,
  [AbouPerson] NVARCHAR(255),
  PRIMARY KEY ([PictureID], [PersonID])
);

CREATE TABLE [tblPicturePlace] (
  [ID] INT,
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255)
);

CREATE TABLE [tblPictureSource] (
  [ID] INT,
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255)
);

CREATE TABLE [tblPoints] (
  [AccountID] INT,
  [CollectedPoint] FLOAT(53),
  [UsedPoint] FLOAT(53),
  [StartDate] DATETIME2,
  [LastPaiedDate] DATETIME2,
  [LastExchangeDate] DATETIME2,
  [ExpireDate] DATETIME2,
  PRIMARY KEY ([AccountID])
);

CREATE TABLE [tblPricingGroup] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [Remark] NVARCHAR(MAX),
  [StartDate] DATETIME2 NOT NULL,
  [EndDate] DATETIME2 NOT NULL,
  [ByFraction] INT NOT NULL,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblPricingGroupItem] (
  [PricingGroupID] INT,
  [ItemID] INT,
  [Price] FLOAT(53) NOT NULL,
  [MinimumPrice] FLOAT(53) NOT NULL,
  PRIMARY KEY ([PricingGroupID], [ItemID])
);

CREATE TABLE [tblPricingGroupItemForLaundry] (
  [PricingGroupID] INT,
  [ItemID] INT,
  [UrgentTypeID] INT,
  [ServiceTypeID] INT,
  [MaterialTypeID] INT,
  [Price] FLOAT(53) NOT NULL,
  [MinimumPrice] FLOAT(53) NOT NULL,
  PRIMARY KEY ([PricingGroupID], [ItemID], [ServiceTypeID], [MaterialTypeID], [UrgentTypeID])
);

CREATE TABLE [tblProcedureType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [GivenGradeID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblProgramObject] (
  [ProgramUseTypeID] INT,
  [ObjectID] INT NOT NULL,
  [IsUsed] INT NOT NULL,
  PRIMARY KEY ([ProgramUseTypeID], [ObjectID])
);

CREATE TABLE [tblProgramReportType] (
  [ProgramUseTypeID] INT,
  [ReportTypeID] INT,
  [IsUsed] INT NOT NULL,
  PRIMARY KEY ([ProgramUseTypeID], [ReportTypeID])
);

CREATE TABLE [tblProgramSetting] (
  [EstablishmentNameAr] NVARCHAR(255),
  [EstablishmentAddressAr] NVARCHAR(MAX),
  [EstablishmentNameEn] NVARCHAR(255),
  [EstablishmentAddressEn] NVARCHAR(MAX),
  [ProgramUseTypeID] INT,
  [UseHijriCalendar] INT NOT NULL,
  [RentLeaseConditionAr] NVARCHAR(MAX),
  [RentLeaseConditionEn] NVARCHAR(MAX),
  [DataPath] NVARCHAR(255),
  [FooterMessage] NVARCHAR(MAX),
  [GottenDiscountAccountID] INT,
  [GivenDiscountAccountID] INT,
  [CollectionCommissionAccountID] INT,
  [OtherDataInLabel] NVARCHAR(255),
  [MarketingCommissionAccountID] INT,
  [MarketingCommission] FLOAT(53),
  [AssayCommissionAccountID] INT,
  [AssayCommission] FLOAT(53),
  [MemberCommissionAccountID] INT,
  [ContractingAccountID] INT,
  [UseMyPoints] INT NOT NULL,
  [MoneyPerPoint] FLOAT(53),
  [MoneyPerDay] FLOAT(53),
  [MaximamDays] FLOAT(53),
  [PointPerMoney] FLOAT(53),
  [UseBell] INT NOT NULL,
  [DailyAvgCount] INT,
  [BellCount] INT,
  [SoundPath] NVARCHAR(255),
  [PicturePath] NVARCHAR(255),
  [OpenCashDrawer] INT NOT NULL,
  [CashDrawerSettings] NVARCHAR(255),
  [CashDrawerOutput] NVARCHAR(255),
  [ZeroAndNegative] INT NOT NULL,
  [ShowNegativeBalance] INT NOT NULL,
  [UseFraction] INT NOT NULL,
  [ContractArabicText] NVARCHAR(MAX),
  [ContractEnglishText] NVARCHAR(MAX),
  [RentAccountID] INT,
  [InsuranceAccountID] INT,
  [HijriCalendarAdjustment] INT,
  [SparePartItemUseTypeID] INT,
  [AmanFundAccountID] INT,
  [ComplexProfitOrLossAccountID] INT,
  [DividendProfitOrLossAccountID] INT,
  [CalendarTypeID] INT,
  [ShareCapitalAccountID] INT,
  [OpenBalanceAccountID] INT,
  [RentTempAccountID] INT,
  [WaterTempAccountID] INT,
  [InsuranceTempAccountID] INT,
  [ClientID] INT,
  [ID] INT,
  [ConsumableCreditorAccountID] INT,
  [ConsumableDebtorAccountID] INT,
  [DefaultBarcodeTypeID] INT,
  [VAT] FLOAT(53),
  [VATAccountID] INT,
  [VatTypeID] INT,
  [VATNo] NVARCHAR(255),
  [StreetNameAr] NVARCHAR(255),
  [StreetNameEn] NVARCHAR(255),
  [CityAr] NVARCHAR(255),
  [CityEn] NVARCHAR(255),
  [CountryAlpha2Code] NVARCHAR(255),
  [BuildingNumber] NVARCHAR(255),
  [DistrictAr] NVARCHAR(255),
  [DistrictEn] NVARCHAR(255),
  [PostalCode] NVARCHAR(255),
  [PostalAdditionalNo] NVARCHAR(255),
  [ZATCAIntegrated] INT NOT NULL,
  [BusinessCategory] NVARCHAR(255),
  [Email] NVARCHAR(255),
  [GroupVATNumber] NVARCHAR(255),
  [ReportingTimerHours] INT,
  [TransactionHistoryLifeTimeDays] INT,
  [ZATCAIntegrationStartDate] DATETIME2
);

CREATE TABLE [tblProgramUseType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [FolderName] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblProgramUseTypeAccountType] (
  [ProgramUseTypeID] INT,
  [AccountTypeID] INT,
  [IsUsed] INT NOT NULL,
  PRIMARY KEY ([ProgramUseTypeID], [AccountTypeID])
);

CREATE TABLE [tblProgramUseTypeCodingGroup] (
  [ProgramUseTypeID] INT NOT NULL,
  [CodingGroupID] INT NOT NULL,
  [IsUsed] INT NOT NULL,
  PRIMARY KEY ([ProgramUseTypeID], [CodingGroupID])
);

CREATE TABLE [tblProgramUseTypeInvoiceType] (
  [ProgramUseTypeID] INT,
  [InvoiceTypeID] INT,
  [IsUsed] INT NOT NULL,
  PRIMARY KEY ([ProgramUseTypeID], [InvoiceTypeID])
);

CREATE TABLE [tblProgramUseTypeReceiptSubject] (
  [ProgramUseTypeID] INT,
  [ReceiptSubjectID] INT,
  [IsUsed] INT NOT NULL,
  PRIMARY KEY ([ProgramUseTypeID], [ReceiptSubjectID])
);

CREATE TABLE [tblQuarter] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [CityID] INT NOT NULL,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblRealEstate] (
  [BranchID] INT NOT NULL,
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [QuarterID] INT,
  [Address] NVARCHAR(255),
  [Phone] NVARCHAR(255),
  [Fax] NVARCHAR(255),
  [UnitsCount] INT,
  [CollectionCommission] FLOAT(53) NOT NULL,
  [OwnerID] INT NOT NULL,
  [OutOfService] INT NOT NULL,
  PRIMARY KEY ([BranchID], [ID])
);

CREATE TABLE [tblRealEstateUnit] (
  [BranchID] INT NOT NULL,
  [ID] INT NOT NULL,
  [RealEstateID] INT NOT NULL,
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255),
  [UnitTypeID] INT NOT NULL,
  [FloorsCount] INT NOT NULL,
  [RoomsCount] INT,
  [BathroomsCount] INT,
  [kitchensCount] INT,
  [IndependentBoard] INT NOT NULL,
  [OtherSpecifications] NVARCHAR(255),
  [AnnualRent] INT,
  [UnitStatusID] INT,
  [Furniture] NVARCHAR(255),
  [ElectricityMeterNo] NVARCHAR(255),
  [SubscriberNo] NVARCHAR(255),
  [HousingTypeID] INT,
  [Comment] NVARCHAR(255),
  PRIMARY KEY ([BranchID], [ID])
);

CREATE TABLE [tblRealEstateUnitAction] (
  [BranchID] INT NOT NULL,
  [ID] INT,
  [UnitID] INT NOT NULL,
  [UnitActionTypeID] INT,
  [StartDate] DATETIME2,
  [EndDate] DATETIME2,
  [Note] NVARCHAR(MAX),
  PRIMARY KEY ([BranchID], [ID])
);

CREATE TABLE [tblRealEstateUnitPrice] (
  [BranchID] INT NOT NULL,
  [UnitID] INT NOT NULL,
  [RentTypeID] INT,
  [NormalPrice] INT,
  [SeasonPrice] INT,
  PRIMARY KEY ([BranchID], [UnitID], [RentTypeID])
);

CREATE TABLE [tblReceiptCancellation] (
  [RecieptID] NVARCHAR(255) NOT NULL,
  [CancellationDate] DATETIME2,
  [CancellationReason] NVARCHAR(255),
  PRIMARY KEY ([RecieptID])
);

CREATE TABLE [tblReceiptInstallment] (
  [ReceiptID] NVARCHAR(255),
  [BranchID] INT,
  [InstallmentPlanID] INT NOT NULL,
  [InstallmentID] INT,
  [Amount] FLOAT(53),
  [Remark] NVARCHAR(255),
  PRIMARY KEY ([ReceiptID], [BranchID], [InstallmentPlanID], [InstallmentID])
);

CREATE TABLE [tblReceiptInvoice] (
  [ReceiptID] NVARCHAR(255) NOT NULL,
  [InvoiceID] NVARCHAR(255) NOT NULL,
  [Amount] FLOAT(53) NOT NULL,
  PRIMARY KEY ([InvoiceID], [ReceiptID])
);

CREATE TABLE [tblReceiptManagementLease] (
  [BranchID] INT NOT NULL,
  [ReceiptID] NVARCHAR(255) NOT NULL,
  [LeaseID] INT NOT NULL,
  [Amount] FLOAT(53) NOT NULL,
  PRIMARY KEY ([BranchID], [ReceiptID], [LeaseID])
);

CREATE TABLE [tblReceiptRentLease] (
  [BranchID] INT NOT NULL,
  [ReceiptID] NVARCHAR(255) NOT NULL,
  [LeaseID] INT NOT NULL,
  [Amount] FLOAT(53),
  PRIMARY KEY ([BranchID], [ReceiptID], [LeaseID])
);

CREATE TABLE [tblReceiptReportType] (
  [ReportName] NVARCHAR(255),
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ReportName])
);

CREATE TABLE [tblReceiptType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [ObjectID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblReceiptTypeObject] (
  [ObjectID] INT,
  [ReceiptTypeID] INT,
  [dummy] INT,
  PRIMARY KEY ([ObjectID])
);

CREATE TABLE [tblReceivedOutsideSearchReport] (
  [ID] INT,
  [YearID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblReceivedOutsideSearchReportList] (
  [ReceivedOutsideSearchReportID] INT,
  [StudentAccountID] INT NOT NULL,
  [ApprovedCourseID] INT NOT NULL,
  [Notes] NVARCHAR(255),
  [ReceivedDate] DATETIME2,
  PRIMARY KEY ([ReceivedOutsideSearchReportID], [StudentAccountID], [ApprovedCourseID])
);

CREATE TABLE [tblRegistration] (
  [ID] INT,
  [CPUID] NVARCHAR(255),
  [EstablishmentNameAr] NVARCHAR(255),
  [EstablishmentNameEn] NVARCHAR(255),
  [EstablishmentAddressAr] NVARCHAR(255),
  [EstablishmentAddressEn] NVARCHAR(255),
  [WarrantyStartDate] DATETIME2,
  [WarrantyPeriod] FLOAT(53),
  [BranchID] INT,
  [BranchNameAr] NVARCHAR(255),
  [BranchNameEn] NVARCHAR(255),
  [PCID] INT,
  [PCNameAr] NVARCHAR(255),
  [PCNameEn] NVARCHAR(255),
  [ProgramVersion] NVARCHAR(255),
  [ProgramUseType] NVARCHAR(255),
  [ProgramUseTypeNameAr] NVARCHAR(255),
  [ProgramUseTypeNameEn] NVARCHAR(255),
  [CTITUserID] INT,
  [ClientName] NVARCHAR(255),
  [ClientMobile] NVARCHAR(255),
  [ClientWhatsApp] NVARCHAR(255),
  [ClientEmail] NVARCHAR(255),
  [PaymentMethod] NVARCHAR(255),
  [DistributorName] NVARCHAR(255),
  [PublicKeyBytes] VARBINARY(MAX),
  [CertificateBytes] VARBINARY(MAX),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblRegistrationStatus] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblRentLease] (
  [BranchID] INT NOT NULL,
  [ID] INT NOT NULL,
  [UnitID] INT NOT NULL,
  [TenantID] INT NOT NULL,
  [LeaseDate] DATETIME2,
  [StartDate] DATETIME2 NOT NULL,
  [Rent] FLOAT(53),
  [Insurance] FLOAT(53),
  [Water] FLOAT(53),
  [AdditionalConditions] NVARCHAR(MAX),
  [LastPaymentDate] DATETIME2,
  [LastPaymentUntilDate] DATETIME2,
  [EndDate] DATETIME2,
  [UnitStatusID] INT,
  [LastPaymentStartDate] DATETIME2,
  [MoneyTransactionID] NVARCHAR(255),
  [ReservationID] INT,
  [RentTypeID] INT,
  [DurationCount] INT,
  [PaymentMethodID] INT NOT NULL,
  [PaymentPeriodType] INT,
  [PaymentPeriodCount] INT,
  [HousingTypeID] INT,
  [UserID] INT,
  [PaymentsCount] INT NOT NULL,
  [DurationMonthCount] INT,
  [Seeking] FLOAT(53),
  [IsRentBeforeManagement] INT NOT NULL,
  [KeepInsuranceWithOwner] INT NOT NULL,
  [CalendarTypeID] INT,
  [SendSMS] INT NOT NULL,
  [VAT] FLOAT(53),
  [VATValue] FLOAT(53),
  [IsVATed] INT NOT NULL,
  PRIMARY KEY ([BranchID], [ID])
);

CREATE TABLE [tblRentLease_Hotel] (
  [BranchID] INT NOT NULL,
  [ID] INT NOT NULL,
  [UnitID] INT NOT NULL,
  [TenantID] INT NOT NULL,
  [LeaseDate] DATETIME2,
  [StartDate] DATETIME2 NOT NULL,
  [DurationMonthCount] INT,
  [Rent] FLOAT(53),
  [Insurance] FLOAT(53),
  [AdditionalConditions] NVARCHAR(MAX),
  [LastPaymentDate] DATETIME2,
  [LastPaymentUntilDate] DATETIME2,
  [EndDate] DATETIME2,
  [UnitStatusID] INT,
  [LastPaymentStartDate] DATETIME2,
  [MoneyTransactionID] NVARCHAR(255),
  [VAT] FLOAT(53),
  [VATValue] FLOAT(53),
  [VatTypeID] INT,
  PRIMARY KEY ([BranchID], [ID])
);

CREATE TABLE [tblRentLeaseAttendant] (
  [BranchID] INT NOT NULL,
  [ID] INT NOT NULL,
  [AttendantID] INT NOT NULL,
  PRIMARY KEY ([BranchID], [ID], [AttendantID])
);

CREATE TABLE [tblRentLeaseCancellation] (
  [BranchID] INT NOT NULL,
  [RentLeaseID] INT NOT NULL,
  [CancellationDate] DATETIME2,
  [CancellationReason] NVARCHAR(255),
  [MoneyTransactionID] NVARCHAR(255) NOT NULL,
  PRIMARY KEY ([BranchID], [RentLeaseID])
);

CREATE TABLE [tblRentLeaseRenewal] (
  [BranchID] INT NOT NULL,
  [ID] INT NOT NULL,
  [LeaseID] INT NOT NULL,
  [DurationByMonth] INT NOT NULL,
  [DurationByDay] INT NOT NULL,
  [LastPaymentUntilDate] DATETIME2,
  [LastPaymentStartDate] DATETIME2,
  [MoneyTransactionID] NVARCHAR(255) NOT NULL,
  [Rent] FLOAT(53),
  [Water] FLOAT(53),
  [Commission] FLOAT(53),
  [RenewalDate] DATETIME2,
  [DurationCount] INT,
  [PaymentPeriodType] INT,
  [PaymentPeriodCount] INT,
  [VAT] FLOAT(53),
  [VATValue] FLOAT(53),
  [VatTypeID] INT,
  PRIMARY KEY ([BranchID], [ID])
);

CREATE TABLE [tblRentLeaseRenewalCancellation] (
  [BranchID] INT NOT NULL,
  [RentLeaseRenewalID] INT NOT NULL,
  [CancellationDate] DATETIME2,
  [CancellationReason] NVARCHAR(255),
  PRIMARY KEY ([BranchID], [RentLeaseRenewalID])
);

CREATE TABLE [tblRentLeaseRenewalPaymentSubject] (
  [BranchID] INT NOT NULL,
  [RentLeaseRenewalID] INT NOT NULL,
  [PaymentSubjectID] INT NOT NULL,
  [Amount] FLOAT(53) NOT NULL,
  PRIMARY KEY ([BranchID], [RentLeaseRenewalID], [PaymentSubjectID])
);

CREATE TABLE [tblRentLeaseRenewalPeriodCancellation] (
  [BranchID] INT NOT NULL,
  [RentLeaseRenewalID] INT NOT NULL,
  [CancellationDate] DATETIME2,
  [CancellationReason] NVARCHAR(255),
  [DurationByMonth] INT NOT NULL,
  [DurationByDay] INT NOT NULL,
  [LastPaymentUntilDate] DATETIME2,
  [LastPaymentStartDate] DATETIME2,
  [MoneyTransactionID] NVARCHAR(255) NOT NULL,
  [Rent] FLOAT(53),
  [Water] FLOAT(53),
  [Commission] FLOAT(53),
  [ReturnPeriodType] INT,
  [ReturnPeriodCount] INT,
  PRIMARY KEY ([BranchID], [RentLeaseRenewalID])
);

CREATE TABLE [tblRentType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [DayCount] FLOAT(53),
  [PeriodTypeCode] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblReportType] (
  [ID] INT,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [ReportName] NVARCHAR(255),
  [ReportTypeGroupID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblReportTypeGroup] (
  [ID] INT,
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255),
  [ObjecTID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblReportTypeObject] (
  [ReportTypeID] INT,
  [ObjectID] INT,
  [IsUsed] INT NOT NULL,
  PRIMARY KEY ([ObjectID], [ReportTypeID])
);

CREATE TABLE [tblRequiredUnit] (
  [BranchID] INT NOT NULL,
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [UnitTypeID] INT NOT NULL,
  [FloorsCount] INT NOT NULL,
  [RoomsCount] INT,
  [BathroomsCount] INT,
  [kitchensCount] INT,
  [IndependentBoard] INT NOT NULL,
  [OtherSpecifications] NVARCHAR(255),
  [AnnualRentFrom] INT,
  [AnnualRentTo] INT,
  [UnitStatusID] INT,
  [Furniture] NVARCHAR(255),
  [HousingTypeID] INT,
  [Comment] NVARCHAR(255),
  PRIMARY KEY ([BranchID], [ID])
);

CREATE TABLE [tblRequiredUnitQuarter] (
  [BranchID] INT NOT NULL,
  [RequiredUnitID] INT NOT NULL,
  [QuarterID] INT NOT NULL,
  PRIMARY KEY ([BranchID], [RequiredUnitID], [QuarterID])
);

CREATE TABLE [tblReservation] (
  [ID] INT,
  [BranchID] INT NOT NULL,
  [UnitID] INT NOT NULL,
  [ReservationDate] DATETIME2,
  [RentTypeID] INT,
  [StartDate] DATETIME2,
  [EndDate] DATETIME2,
  [RentPrice] FLOAT(53),
  [RequiredAdvancedSum] FLOAT(53),
  [ConfirmationTypeID] INT,
  [UserID] INT,
  [ReservationStatusID] INT,
  [CustomerID] INT,
  [ReservationTypeID] INT,
  [Note] NVARCHAR(MAX),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblReservationStatus] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblResthouse_RentLease] (
  [BranchID] INT NOT NULL,
  [ID] INT NOT NULL,
  [UnitID] INT NOT NULL,
  [LeaseDate] DATETIME2,
  [TenantID] INT NOT NULL,
  [HousingTypeID] INT,
  [AdditionalConditions] NVARCHAR(MAX),
  [Rent] FLOAT(53),
  [Insurance] FLOAT(53),
  [ReservationID] INT,
  [UserID] INT,
  [MoneyTransactionID] NVARCHAR(255) NOT NULL,
  [VAT] FLOAT(53),
  [VATValue] FLOAT(53),
  [VatTypeID] INT,
  PRIMARY KEY ([BranchID], [ID])
);

CREATE TABLE [tblResthouse_RentLeaseCancellation] (
  [BranchID] INT NOT NULL,
  [ResthouseRentLeaseID] INT NOT NULL,
  [CancellationDate] DATETIME2,
  [CancellationReason] NVARCHAR(255),
  [MulctAmount] FLOAT(53),
  [MoneyTransactionID] NVARCHAR(255) NOT NULL,
  PRIMARY KEY ([BranchID], [ResthouseRentLeaseID])
);

CREATE TABLE [tblRestHouse_RentLeaseRentGroup] (
  [ID] INT,
  [BranchID] INT NOT NULL,
  [RestHouseRentLeaseID] INT NOT NULL,
  [RentGroupID] INT NOT NULL,
  [RentDate] DATETIME2 NOT NULL,
  [Price] FLOAT(53),
  [VAT] FLOAT(53),
  [VATValue] FLOAT(53),
  [VatTypeID] INT,
  [StartTime] DATETIME2,
  [EndTime] DATETIME2,
  PRIMARY KEY ([ID], [BranchID])
);

CREATE TABLE [tblRestHouse_SeasonRentGroup] (
  [ID] INT NOT NULL,
  [SeasonID] INT,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [StartTime] DATETIME2,
  [EndTime] DATETIME2,
  [Price] FLOAT(53),
  [StartTimeText] NVARCHAR(255),
  [EndTimeText] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblRestHouse_SeasonRentGroupPeriod] (
  [RestHouseSeasonRentGroupID] INT NOT NULL,
  [RestHouseRentPeriodID] INT,
  PRIMARY KEY ([RestHouseSeasonRentGroupID], [RestHouseRentPeriodID])
);

CREATE TABLE [tblRestHouse_SeasonService] (
  [SeasonID] INT,
  [ServiceTypeID] INT NOT NULL,
  [Price] FLOAT(53),
  PRIMARY KEY ([SeasonID], [ServiceTypeID])
);

CREATE TABLE [tblRestHouse_Setting] (
  [RentInsurance] FLOAT(53),
  [SendMessageInRegistration] INT NOT NULL,
  [SendMessageBefore] INT,
  [MessageText] NVARCHAR(MAX),
  [RentLeaseCancellationMulctAccountID] INT,
  [RentLeaseCancellationMulct] FLOAT(53),
  [StudySeasonID] INT,
  [WeekendSeasonID] INT
);

CREATE TABLE [tblRestHouseRentPeriod] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [StartTime] DATETIME2,
  [EndTime] DATETIME2,
  [StartTimeText] NVARCHAR(255),
  [EndTimeText] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblSalary] (
  [AccountID] INT NOT NULL,
  [SalaryYear] INT NOT NULL,
  [SalaryMonth] INT NOT NULL,
  [Salary] INT,
  [SalaryHousingEquivalent] INT,
  [SalaryLiveEquivalent] INT,
  [InsuranceByCompany] INT,
  [InsuranceByEmployee] INT,
  [SalaryTransportationEquivalent] INT,
  [LoanNo] INT,
  [LoanPayment] INT,
  [PolicyNo] NVARCHAR(255),
  [DocumentImagePath] NVARCHAR(MAX),
  PRIMARY KEY ([AccountID], [SalaryYear], [SalaryMonth])
);

CREATE TABLE [tblSeason] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [IsUsed] INT NOT NULL,
  [ColorID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblSeasonPeriod] (
  [ID] INT NOT NULL,
  [SeasonID] INT,
  [StartDate] DATETIME2,
  [EndDate] DATETIME2,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblSeasonPeriodOLD] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [StartDate] DATETIME2,
  [EndDate] DATETIME2,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblSeasonsOfficialWorking] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [StartTime] DATETIME2,
  [EndTime] DATETIME2
);

CREATE TABLE [tblSection] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblSetting] (
  [DataBaseName] NVARCHAR(255),
  [ProgramFolderName] NVARCHAR(255),
  [DataBasePath] NVARCHAR(255),
  [LastCopySize] FLOAT(53)
);

CREATE TABLE [tblShiftWorkPeriod] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [StartTime] DATETIME2,
  [EndTime] DATETIME2,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblSickenStatuse] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255) NOT NULL,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblSMSMessageAccountDocument] (
  [ID] INT,
  [AccountDocumentID] INT,
  [SMSMessageTypeID] INT,
  [SMSMessageRecordID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblSMSMessageCompanyDocument] (
  [ID] INT,
  [CompanyDocumentID] INT,
  [SMSMessageTypeID] INT,
  [SMSMessageRecordID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblSMSMessageHistory] (
  [ID] INT,
  [SentTime] DATETIME2,
  [MessageStatus] NVARCHAR(255),
  [MessageID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblSMSMessageInstallment] (
  [ID] INT,
  [BranchID] INT NOT NULL,
  [InstallmentPlanID] INT NOT NULL,
  [InstallmentID] INT NOT NULL,
  [SMSMessageTypeID] INT NOT NULL,
  [SMSMessageRecordID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblSMSMessageRecord] (
  [ID] INT,
  [SenderName] NVARCHAR(255),
  [MessageText] NVARCHAR(MAX),
  [NumbersList] NVARCHAR(450),
  [MessageTime] DATETIME2,
  [SentTime] DATETIME2,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblSMSMessageRentLeaseRenewal] (
  [ID] INT,
  [BranchID] INT,
  [RentLeaseRenewalID] INT,
  [SMSMessageTypeID] INT,
  [SMSMessageRecordID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblSMSMessageSetting] (
  [UserName] NVARCHAR(255),
  [UserPassword] NVARCHAR(255),
  [SenderName] NVARCHAR(255),
  [SMSProviderID] INT,
  [InvoiceSMSText] NVARCHAR(255),
  [FinishedRentPeriodSMSText] NVARCHAR(255),
  [ReceiptSMSText] NVARCHAR(255)
);

CREATE TABLE [tblSMSMessageType] (
  [ID] INT,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255) NOT NULL,
  [MessageTextAr] NVARCHAR(MAX),
  [MessageTextEn] NVARCHAR(MAX),
  [PeriodByDay] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblSMSProvider] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [ProviderWebSite] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblStage] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblStopType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblStoredItemBalance] (
  [ID] INT,
  [BuyQty] INT,
  [OutQty] INT,
  [CurrentQty] INT,
  [ReturnFromCustomer] INT,
  [ReturnToSupplier] INT,
  [MaximumQty] INT,
  [MinimumQty] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblStoreMovement] (
  [ID] NVARCHAR(255),
  [StoreCreditorID] INT NOT NULL,
  [StoreDebtorID] INT NOT NULL,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblStudentAttendance] (
  [ID] INT,
  [ApprovedCourseID] INT,
  [AttendanceDate] DATETIME2,
  [Notes] NVARCHAR(255),
  [PCID] INT,
  [InputMeansID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblStudentAttendanceList] (
  [StudentAttendanceID] INT,
  [StudentAccountID] INT,
  [AttendanceCaseID] INT,
  [Notes] NVARCHAR(255),
  [LateOrLeaveMinutes] INT,
  PRIMARY KEY ([StudentAttendanceID], [StudentAccountID])
);

CREATE TABLE [tblStudentCourseProcedure] (
  [StudentAccountID] INT NOT NULL,
  [ApprovedCourseID] INT NOT NULL,
  [ProcedureTypeID] INT NOT NULL,
  [ProcedureDate] DATETIME2 NOT NULL,
  [ProcedureReason] NVARCHAR(MAX),
  PRIMARY KEY ([StudentAccountID], [ApprovedCourseID], [ProcedureTypeID])
);

CREATE TABLE [tblStudentFinalValuation] (
  [ID] INT,
  [StudentAccountID] INT,
  [ApprovedCourseID] INT,
  [ScientificEducationalValuation] NVARCHAR(MAX),
  [ValuationFormID] INT,
  [ValuationDate] DATETIME2,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblStudentFinalValuationList] (
  [StudentFinalValuationID] INT,
  [ValuationFormObjectID] INT,
  [MarkID] INT,
  PRIMARY KEY ([StudentFinalValuationID], [ValuationFormObjectID])
);

CREATE TABLE [tblStudentFinanceRelatedData] (
  [AccountID] INT,
  [HouseTypeID] INT,
  [BuildingTypeID] INT,
  [RoomsNo] INT,
  [WaterMeterNo] NVARCHAR(255),
  [ElectricityMeterNo] NVARCHAR(255),
  [ChildrenNo] INT,
  [GirlsNo] INT,
  [CarTypeID] INT,
  [CarModle] INT,
  [PlateNo] NVARCHAR(255),
  [CarColorID] INT,
  PRIMARY KEY ([AccountID])
);

CREATE TABLE [tblStudentResult] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblStudentType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblStudentWeeklyValuation] (
  [ID] INT,
  [EvaluationDate] DATETIME2,
  [ApprovedCourseID] INT,
  [SubjectStartName] NVARCHAR(255),
  [SubjectStartPageNo] NVARCHAR(255),
  [SubjectEndName] NVARCHAR(255),
  [SubjectEndPageNo] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblStudyBook] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [AuthorName] NVARCHAR(255),
  [PressDate] NVARCHAR(255),
  [PressNo] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblStudyClass] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [StratTime] DATETIME2,
  [EndTime] DATETIME2,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblStudyLevel] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblStudyTermPeriod] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblStudyType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblStudyYear] (
  [ID] INT NOT NULL,
  [StartYearID] INT NOT NULL,
  [EndYearID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblSubscriptionCard] (
  [ID] INT,
  [CardNo] INT,
  [CardCode] NVARCHAR(255),
  [AccountID] INT,
  [CardDate] DATETIME2,
  [CardClassID] INT,
  [Price] FLOAT(53),
  [FreePalance] FLOAT(53),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblTable] (
  [ID] INT,
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblTeacherFinalValuation] (
  [ID] INT,
  [StudyYearID] INT,
  [TermID] INT,
  [TeacherAccountID] INT,
  [ValuationFormID] INT,
  [ValuationDate] DATETIME2,
  [StrengthPoint] NVARCHAR(MAX),
  [WeakPoint] NVARCHAR(MAX),
  [Recommendation] NVARCHAR(MAX),
  [ManagerOpinion] NVARCHAR(MAX),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblTeacherFinalValuationList] (
  [TeacherFinalValuationID] INT,
  [ValuationFormObjectID] INT,
  [MarkID] INT,
  PRIMARY KEY ([TeacherFinalValuationID], [ValuationFormObjectID])
);

CREATE TABLE [tblTeacherProcedure] (
  [ID] INT,
  [TeacherAccountID] INT,
  [StudyYearID] INT,
  [TermID] INT,
  [TeacherProcedureSubjectID] INT NOT NULL,
  [ProcedureDate] DATETIME2 NOT NULL,
  [StudyTypeID] INT,
  [ApprovedCourseID] INT,
  [TeacherProcedureID] INT,
  [MeetDate] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblTeacherProcedureSubject] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblTeacherProcedureType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblTeacherValuationByStudent] (
  [ID] INT,
  [StudentAccountID] INT,
  [ApprovedCourseID] INT,
  [StudentSufferanceWithTeacher] NVARCHAR(MAX),
  [ValuationFormID] INT,
  [ValuationDate] DATETIME2,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblTeacherValuationByStudentList] (
  [TeacherValuationByStudentID] INT,
  [ValuationFormObjectID] INT,
  [MarkID] INT,
  PRIMARY KEY ([TeacherValuationByStudentID], [ValuationFormObjectID])
);

CREATE TABLE [tblTeacherValuationRecordList] (
  [TeacherValuationRecordID] INT,
  [ValuationFormObjectID] INT,
  [MarkID] INT,
  PRIMARY KEY ([TeacherValuationRecordID], [ValuationFormObjectID])
);

CREATE TABLE [tblTeacherVisitNo] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblTeamGroup] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [GroupForemanAccountID] INT,
  [CreationDate] DATETIME2,
  [StopDate] DATETIME2,
  [GroupStatusID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblTeamGroupMember] (
  [ID] INT,
  [TeamGroupID] INT NOT NULL,
  [MemberAccountID] INT,
  [StartDate] DATETIME2,
  [StopDate] DATETIME2,
  [StatusID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblTerm] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblTimeByHalfHour] (
  [TimeHour] INT,
  [TimeHalf] INT,
  [TheTime] DATETIME2,
  PRIMARY KEY ([TheTime])
);

CREATE TABLE [tblTimeByQuarterHour] (
  [TimeHour] INT,
  [TimeQuarter] INT,
  [TheTime] DATETIME2,
  PRIMARY KEY ([TheTime])
);

CREATE TABLE [tblTimeHalf] (
  [ID] INT,
  [TimeHalf] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblTimeHour] (
  [ID] INT,
  [TimeHour] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblTitle] (
  [ID] INT,
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblTransactionHistory] (
  [ID] INT,
  [UserID] INT NOT NULL,
  [TransactionTime] DATETIME2 NOT NULL,
  [TransactionTypeID] INT NOT NULL,
  [ObjectID] INT NOT NULL,
  [RecordID] NVARCHAR(255),
  [PCID] INT NOT NULL,
  [RecordData] NVARCHAR(MAX),
  [RecordDataAr] NVARCHAR(MAX),
  [RecordDataEn] NVARCHAR(MAX),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblTransactionType] (
  [ID] INT,
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255),
  [AuthorityName] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblUnitActionType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [Manual] INT NOT NULL,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblUnitExpense] (
  [BranchID] INT NOT NULL,
  [ID] INT NOT NULL,
  [UnitID] INT NOT NULL,
  [ExpenseDate] DATETIME2,
  [ExpenseTypeID] INT NOT NULL,
  [Amount] INT,
  [Remark] NVARCHAR(255),
  [StaffID] INT,
  PRIMARY KEY ([BranchID], [ID])
);

CREATE TABLE [tblUnitStatus] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblUnitTypeCondition] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [ConditionAr] NVARCHAR(450) NOT NULL,
  [ConditionEn] NVARCHAR(450),
  [ConditionAr1] NVARCHAR(MAX),
  [ConditionEn1] NVARCHAR(MAX),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblUpdateStatus] (
  [ID] FLOAT(53),
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblUser] (
  [ID] INT,
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255),
  [UserName] NVARCHAR(255) NOT NULL,
  [Password] NVARCHAR(255),
  [FirstEntry] DATETIME2,
  [LastEntry] DATETIME2,
  [UserGroupID] INT NOT NULL,
  [CurrentStatusID] INT NOT NULL,
  [Stopped] INT NOT NULL,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblUserAccountType] (
  [UserID] INT,
  [AccountTypeID] INT,
  [IsUsed] INT NOT NULL,
  PRIMARY KEY ([UserID], [AccountTypeID])
);

CREATE TABLE [tblUserGroup] (
  [ID] INT,
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblUserMoneyAccount] (
  [UserID] INT,
  [AccountID] INT,
  [IsUsed] INT NOT NULL,
  PRIMARY KEY ([UserID], [AccountID])
);

CREATE TABLE [tblUserReceiptSubject] (
  [UserID] INT,
  [ReceiptSubjectID] INT,
  [IsUsed] INT NOT NULL,
  PRIMARY KEY ([UserID], [ReceiptSubjectID])
);

CREATE TABLE [tblUserSetting] (
  [UserID] INT NOT NULL,
  [CodeID] INT,
  [QuickInvoiceTypeID] INT,
  [QuickInvoiceCreditorID] INT,
  [QuickInvoiceDebtorID] INT,
  [QuickInvoiceStoreCreditorID] INT,
  [QuickInvoiceStoreDebtorID] INT,
  [DiscountPercentage] FLOAT(53),
  PRIMARY KEY ([UserID])
);

CREATE TABLE [tblUserStatus] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblUseType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [Counted] INT NOT NULL,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblValuationForm] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [ValuationPersonTypeID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblValuationFormGroup] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [ValuationFormID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblVaTCategories] (
  [ID] INT NOT NULL,
  [Code] NVARCHAR(255) NOT NULL,
  [Description] NVARCHAR(255),
  [TaxExemptionReasonCode] NVARCHAR(255),
  [TaxExemptionReason] NVARCHAR(255),
  [TaxExemptionReasonEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblVatType] (
  [ID] INT,
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblVersion] (
  [Version] NVARCHAR(255)
);

CREATE TABLE [tblWeek] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255) NOT NULL,
  [StartDate] NVARCHAR(255),
  [EndDate] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblWeekDay] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255) NOT NULL,
  [IsWeekEnd] INT NOT NULL,
  [WeekDayID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblWorkerRentContract] (
  [ContractNo] INT NOT NULL,
  [ContractDay] INT NOT NULL,
  [ContractDate] DATETIME2 NOT NULL,
  [CustomerID] INT NOT NULL,
  [FirstSideID] INT NOT NULL,
  [StartDate] DATETIME2,
  [EndDate] DATETIME2,
  [ContractPeriodMonth] INT,
  [ContractPeriodDay] INT,
  [ContractNote] NVARCHAR(255),
  [UPdatedByID] INT,
  [DocumentImagePath] NVARCHAR(MAX),
  PRIMARY KEY ([ContractNo])
);

CREATE TABLE [tblWorkerRentContractEmployee] (
  [ContractNo] INT NOT NULL,
  [AccountID] INT,
  [Wages] INT NOT NULL,
  [Performance] INT,
  [WorkStartDate] DATETIME2,
  [ReturnDate] DATETIME2,
  [EmployeeNote] NVARCHAR(255),
  [FirstWages] INT NOT NULL,
  PRIMARY KEY ([ContractNo], [AccountID])
);

CREATE TABLE [tmbNotUsedMoneyTransaction] (
  [ID] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tmpAccountBalance] (
  [ID] INT,
  [TheBalance] FLOAT(53),
  [OpenBalance] FLOAT(53),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tmpLastPaymentDate] (
  [ID] INT,
  [LastOfLastPaymentUntilDate] DATETIME2,
  [LastOfReceiptDate] DATETIME2,
  [LastOfLastPaymentStartDate] DATETIME2,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tmpLastRentLeaseRenewal] (
  [BranchID] INT NOT NULL,
  [LeaseID] INT NOT NULL,
  [LastOfLastPaymentUntilDate] DATETIME2,
  [LastOfLastPaymentStartDate] DATETIME2,
  [LastOfRenewalDate] DATETIME2,
  PRIMARY KEY ([BranchID], [LeaseID])
);

CREATE TABLE [tmpMoneyAccountBalance] (
  [ID] INT,
  [TheBalance] FLOAT(53),
  PRIMARY KEY ([ID])
);

CREATE TABLE [USysRibbons] (
  [RibbonName] NVARCHAR(255),
  [RibbonXML] NVARCHAR(MAX),
  PRIMARY KEY ([RibbonName])
);

CREATE TABLE [ss] (
  [ID] INT,
  [a] INT
);

CREATE TABLE [tblAccount] (
  [ID] INT NOT NULL,
  [AccountTypeID] INT NOT NULL,
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255),
  [OpeningBalance] FLOAT(53) NOT NULL,
  [CurrentBalance] FLOAT(53),
  [AcountNote] NVARCHAR(MAX),
  [BranchID] INT NOT NULL,
  [NationalityID] INT,
  [MoneyAccountTypeID] INT,
  [StreetNameAr] NVARCHAR(255),
  [StreetNameEn] NVARCHAR(255),
  [CityAr] NVARCHAR(255),
  [CityEn] NVARCHAR(255),
  [CountryAlpha2Code] NVARCHAR(255),
  [BuildingNumber] NVARCHAR(255),
  [DistrictAr] NVARCHAR(255),
  [DistrictEn] NVARCHAR(255),
  [PostalCode] NVARCHAR(255),
  [PostalAdditionalNo] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblAccountDiscount] (
  [ID] INT,
  [AccountID] INT,
  [CreationDate] DATETIME2,
  [Discount] INT,
  [StartDate] DATETIME2,
  [EndDate] DATETIME2,
  [Remark] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblAccountRegistrationStatus] (
  [AccountID] INT,
  [RegistrationStatusID] INT,
  [RegistrationStatusDate] DATETIME2,
  [StopTypeID] INT,
  [Notes] NVARCHAR(255),
  PRIMARY KEY ([AccountID], [RegistrationStatusID])
);

CREATE TABLE [tblAllowanceChargeReasons] (
  [Code] NVARCHAR(255) NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255) NOT NULL,
  [DescriptionAr] NVARCHAR(MAX),
  [DescriptionEn] NVARCHAR(MAX),
  [ChargeIndicator] INT NOT NULL,
  PRIMARY KEY ([Code])
);

CREATE TABLE [tblAuthorityReportTypeFillterationBy] (
  [AuthorityReportTypeID] INT NOT NULL,
  [ItemFiltrationBy] INT NOT NULL,
  PRIMARY KEY ([AuthorityReportTypeID], [ItemFiltrationBy])
);

CREATE TABLE [tblCalendar] (
  [ID] INT,
  [YearID] INT NOT NULL,
  [MonthID] INT,
  [DayID] INT,
  [TheDate] DATETIME2 NOT NULL,
  [SeasonID] INT,
  PRIMARY KEY ([TheDate])
);

CREATE TABLE [tblClassRoom] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblColor] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [ColorCode] NVARCHAR(255),
  [ShortNameAr] NVARCHAR(255),
  [ShortNameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblContractInstalllment] (
  [ID] INT,
  [ContractID] INT,
  [StageID] INT,
  [Amount] INT,
  [Note] NVARCHAR(MAX),
  [OfferedStartDate] DATETIME2,
  [OfferedEndDate] DATETIME2,
  [ActuallyStartDate] DATETIME2,
  [ActuallyEndDate] DATETIME2,
  [FilePath] NVARCHAR(MAX),
  [VAT] FLOAT(53),
  [VATValue] FLOAT(53),
  [VatTypeID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblCurrency] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [Rate] FLOAT(53),
  [ShortName] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblCustomerWashingSpecifications] (
  [AccountID] INT NOT NULL,
  [ItemID] INT NOT NULL,
  [StarchTypeID] INT,
  [BluingTypeID] INT,
  [MerzamTypeID] INT,
  [Perfuming] INT NOT NULL,
  [Tsfit] INT NOT NULL,
  PRIMARY KEY ([AccountID], [ItemID])
);

CREATE TABLE [tblEducationLevel] (
  [ID] INT,
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblExamLateStudent] (
  [ID] INT,
  [WeekDayID] INT,
  [ExamDate] NVARCHAR(255),
  [ExamPeriodID] INT,
  [ExamTypeID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblFreeInvoice] (
  [InvoiceID] NVARCHAR(255) NOT NULL,
  [InvoiceDate] DATETIME2 NOT NULL,
  PRIMARY KEY ([InvoiceID])
);

CREATE TABLE [tblHouseType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblInstallmentPlanType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [CreditorAccountTypeID] INT,
  [DebtorAccountTypeID] INT,
  [CreditorAccountID] INT,
  [DebtorAccountID] INT,
  [SMSMessageText] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblInvoiceItem] (
  [InvoiceID] NVARCHAR(255),
  [ID] INT,
  [ItemID] INT,
  [Price] FLOAT(53) NOT NULL,
  [Qty] FLOAT(53) NOT NULL,
  [PlateQty] INT,
  [Discount] FLOAT(53),
  [DiscountPercent] FLOAT(53),
  [UnitCost] FLOAT(53) NOT NULL,
  [VAT] FLOAT(53),
  [ExpireDate] DATETIME2,
  PRIMARY KEY ([InvoiceID], [ID])
);

CREATE TABLE [tblInvoiceNoteType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblInvoiceSubmitType] (
  [Code] NVARCHAR(255) NOT NULL,
  [DescriptionAr] NVARCHAR(255),
  [DescriptionEn] NVARCHAR(255)
);

CREATE TABLE [tblItemExpiryDate] (
  [ItemID] INT,
  [ExpiryDate] DATETIME2,
  [Count] INT,
  PRIMARY KEY ([ItemID], [ExpiryDate])
);

CREATE TABLE [tblItemSize] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [Code] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblManagementLease] (
  [BranchID] INT NOT NULL,
  [ID] INT NOT NULL,
  [RealEstateID] INT NOT NULL,
  [OwnerID] INT NOT NULL,
  [LeaseDate] DATETIME2,
  [StartDate] DATETIME2 NOT NULL,
  [DurationYearCount] INT,
  [PaymentsCount] INT NOT NULL,
  [Rent] INT,
  [PaymentMethodID] INT,
  [AdditionalConditions] NVARCHAR(MAX),
  [LastPaymentDate] DATETIME2,
  [EndDate] DATETIME2,
  [CollectionCommission] FLOAT(53) NOT NULL,
  [FirstYearCollectionCommission] FLOAT(53) NOT NULL,
  PRIMARY KEY ([BranchID], [ID])
);

CREATE TABLE [tblMoneyTransactionMethod] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [AccountTypeID] INT NOT NULL,
  [MoneyAccountTypeID] INT,
  [Code] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblOrderExecution] (
  [ID] INT,
  [InvoiceID] NVARCHAR(255),
  [InvoiceItemID] INT,
  [TeamGroupID] INT NOT NULL,
  [OrderDate] DATETIME2,
  [OrderExecutionDate] DATETIME2,
  [OrderExecutionStartTime] DATETIME2,
  [OrderExecutionEndTime] DATETIME2,
  [ExecutionStatusID] INT,
  [ExecutionNote] NVARCHAR(MAX),
  [PCID] INT NOT NULL,
  [UserID] INT,
  [MoneyTransactionID] NVARCHAR(255) NOT NULL,
  [ID1] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblPC] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [BranchID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblPersonalStatus] (
  [ID] INT,
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblPlace] (
  [ID] INT,
  [NameAr] NVARCHAR(255),
  [NameEn] NVARCHAR(255),
  [CityID] INT NOT NULL,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblProgramUseTypeBasicDataTable] (
  [ProgramUseTypeID] INT,
  [BasicDataTableID] INT,
  [IsUsed] INT NOT NULL,
  PRIMARY KEY ([ProgramUseTypeID], [BasicDataTableID])
);

CREATE TABLE [tblReceipt] (
  [ID] NVARCHAR(255),
  [CodeID] INT NOT NULL,
  [PCID] INT NOT NULL,
  [ReceiptTypeID] INT NOT NULL,
  [ReceiptDate] DATETIME2,
  [Amount] FLOAT(53) NOT NULL,
  [Remark] NVARCHAR(255),
  [ReceptName] NVARCHAR(255),
  [MoneyTransactionMethodID] INT NOT NULL,
  [CheckNo] NVARCHAR(255),
  [CheckBank] NVARCHAR(255),
  [CheckDate] DATETIME2,
  [CreditorID] INT,
  [DebtorID] INT NOT NULL,
  [MoneyTransactionID] NVARCHAR(255) NOT NULL,
  [ReceiptSubjectID] INT,
  [HandlyReceiptBy] NVARCHAR(255),
  [HandlyReceiptCode] NVARCHAR(255),
  [HandlyReceiptNo] INT,
  [UserID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblReceiptSubject] (
  [ID] INT,
  [DescriptionAr] NVARCHAR(255),
  [DescriptionEn] NVARCHAR(255),
  [AccountTypeID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblReligion] (
  [ID] INT,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255) NOT NULL,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblRentLeaseRentGroupService] (
  [RentLeaseRentGroupID] INT NOT NULL,
  [BranchID] INT NOT NULL,
  [ServiceTypeID] INT NOT NULL,
  [Price] FLOAT(53),
  [VAT] FLOAT(53),
  [VATValue] FLOAT(53),
  [VatTypeID] INT,
  PRIMARY KEY ([BranchID], [RentLeaseRentGroupID], [ServiceTypeID])
);

CREATE TABLE [tblResthouse_RentedOut] (
  [BranchID] INT NOT NULL,
  [ResthouseRentLeaseID] INT NOT NULL,
  [RentedOutDate] DATETIME2,
  [MoneyTransactionID] NVARCHAR(255) NOT NULL,
  PRIMARY KEY ([BranchID], [ResthouseRentLeaseID])
);

CREATE TABLE [tblRestHouse_UserGroupSetting] (
  [UserGroupID] INT,
  [CancellationAllowBefore] INT,
  [CanBookedWithin] INT,
  PRIMARY KEY ([UserGroupID])
);

CREATE TABLE [tblSMSMessageRentLeaseRentGroup] (
  [ID] INT,
  [BranchID] INT NOT NULL,
  [RentLeaseRentGroupID] INT NOT NULL,
  [SMSMessageTypeID] INT,
  [SMSMessageRecordID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblSpecialization] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblStudentCourse] (
  [StudentAccountID] INT,
  [ApprovedCourseID] INT,
  [MidTermMark] FLOAT(53),
  [FinalMark] FLOAT(53),
  PRIMARY KEY ([StudentAccountID], [ApprovedCourseID])
);

CREATE TABLE [tblStudentWeeklyValuationList] (
  [StudentWeeklyValuationID] INT,
  [StudentAccountID] INT,
  [Mark] FLOAT(53),
  [Note] NVARCHAR(255),
  PRIMARY KEY ([StudentWeeklyValuationID], [StudentAccountID])
);

CREATE TABLE [tblSubmissionStatus] (
  [ID] INT NOT NULL,
  [Description] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblTeacherValuationRecord] (
  [ID] INT,
  [StudyYearID] INT,
  [TeacherVisitID] INT,
  [TermID] INT,
  [TeacherAccountID] INT,
  [ValuationFormID] INT,
  [ValuationDate] DATETIME2,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblTimeQuarter] (
  [ID] INT,
  [TimeQuarter] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblUnitType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  [UnitTypeConditionID] INT,
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblUserGroupAccount] (
  [UserGroupID] INT,
  [AccountID] INT,
  [IsUsed] INT NOT NULL,
  PRIMARY KEY ([UserGroupID], [AccountID])
);

CREATE TABLE [tblValuationPersonType] (
  [ID] INT NOT NULL,
  [NameAr] NVARCHAR(255) NOT NULL,
  [NameEn] NVARCHAR(255),
  PRIMARY KEY ([ID])
);

CREATE TABLE [tblYear] (
  [YearID] INT NOT NULL,
  PRIMARY KEY ([YearID])
);

CREATE INDEX [aa_AccountID_idx] ON [aa] ([AccountID]);
CREATE INDEX [aa_id_idx] ON [aa] ([id]);
CREATE INDEX [Table1_AccountID_idx] ON [Table1] ([AccountID]);
CREATE INDEX [Table1_ID_idx] ON [Table1] ([ID]);
CREATE INDEX [tblAbsenceDay_AbsenceDate_idx] ON [tblAbsenceDay] ([AbsenceDate]);
CREATE UNIQUE INDEX [tblAbsenceDay_AbsenceNo_idx] ON [tblAbsenceDay] ([ID]);
CREATE INDEX [tblAbsenceDay_AbsenceType_idx] ON [tblAbsenceDay] ([AbsenceType]);
CREATE INDEX [tblAbsenceDay_EmployeeNo_idx] ON [tblAbsenceDay] ([AccountID]);
CREATE UNIQUE INDEX [tblAbsenceDay_SendingNo_idx] ON [tblAbsenceDay] ([SendingNo]);
CREATE INDEX [tblAbsenceDay_tblAbsenceDaysHospitalNo_idx] ON [tblAbsenceDay] ([HospitalNo]);
CREATE INDEX [tblAbsenceProcedureRule_AttendanceCaseID_idx] ON [tblAbsenceProcedureRule] ([AttendanceCaseID]);
CREATE INDEX [tblAbsenceProcedureRule_ID_idx] ON [tblAbsenceProcedureRule] ([ID]);
CREATE INDEX [tblAbsenceProcedureRule_ProcedureTypeID_idx] ON [tblAbsenceProcedureRule] ([ProcedureTypeID]);
CREATE INDEX [tblAccountAccountType_AccountID_idx] ON [tblAccountAccountType] ([AccountID]);
CREATE INDEX [tblAccountAccountType_AccountTypeID_idx] ON [tblAccountAccountType] ([AccountTypeID]);
CREATE INDEX [tblAccountChildren_AccountID_idx] ON [tblAccountChildren] ([AccountID]);
CREATE INDEX [tblAccountChildren_CardID_idx] ON [tblAccountChildren] ([CardID]);
CREATE INDEX [tblAccountChildren_EducationLevelID_idx] ON [tblAccountChildren] ([EducationLevelID]);
CREATE INDEX [tblAccountChildren_GenderID_idx] ON [tblAccountChildren] ([GenderID]);
CREATE INDEX [tblAccountChildren_ID_idx] ON [tblAccountChildren] ([ID]);
CREATE INDEX [tblAccountChildrenHealthStatus_AccountID_idx] ON [tblAccountChildrenHealthStatus] ([AccountChildrenID]);
CREATE INDEX [tblAccountChildrenHealthStatus_ExperienceTypeID_idx] ON [tblAccountChildrenHealthStatus] ([DiseaseID]);
CREATE INDEX [tblAccountContact_AccountID_idx] ON [tblAccountContact] ([AccountID]);
CREATE INDEX [tblAccountContact_ContactID_idx] ON [tblAccountContact] ([ContactID]);
CREATE INDEX [tblAccountContact_DocumentTypeNo_idx] ON [tblAccountContact] ([ContactTypeID]);
CREATE INDEX [tblAccountCulturalSide_AccountID_idx] ON [tblAccountCulturalSide] ([AccountID]);
CREATE INDEX [tblAccountCulturalSide_CulturalSideTypeID_idx] ON [tblAccountCulturalSide] ([CulturalSideTypeID]);
CREATE INDEX [tblAccountCulturalSide_ID_idx] ON [tblAccountCulturalSide] ([ID]);
CREATE INDEX [tblAccountDocument_DocumentID_idx] ON [tblAccountDocument] ([DocumentID]);
CREATE INDEX [tblAccountDocument_DocumentTypeNo_idx] ON [tblAccountDocument] ([DocumentTypeID]);
CREATE INDEX [tblAccountDocument_EmployeeNo_idx] ON [tblAccountDocument] ([AccountID]);
CREATE INDEX [tblAccountDocument_ID_idx] ON [tblAccountDocument] ([ID]);
CREATE INDEX [tblAccountExperience_AccountID_idx] ON [tblAccountExperience] ([AccountID]);
CREATE INDEX [tblAccountExperience_ExperienceTypeID_idx] ON [tblAccountExperience] ([ExperienceTypeID]);
CREATE INDEX [tblAccountHealthStatus_AccountID_idx] ON [tblAccountHealthStatus] ([AccountID]);
CREATE INDEX [tblAccountHealthStatus_ExperienceTypeID_idx] ON [tblAccountHealthStatus] ([DiseaseID]);
CREATE INDEX [tblAccountItemUseType_AccountID_idx] ON [tblAccountItemUseType] ([AccountID]);
CREATE INDEX [tblAccountItemUseType_UseTypeID_idx] ON [tblAccountItemUseType] ([UseTypeID]);
CREATE INDEX [tblAccountNote_ColorCode_idx] ON [tblAccountNote] ([ColorCode]);
CREATE INDEX [tblAccountNote_ColorID_idx] ON [tblAccountNote] ([ColorID]);
CREATE INDEX [tblAccountNote_FormID_idx] ON [tblAccountNote] ([ID]);
CREATE UNIQUE INDEX [tblAccountNote_NameAr_idx] ON [tblAccountNote] ([NameAr]);
CREATE UNIQUE INDEX [tblAccountNote_NameEn_idx] ON [tblAccountNote] ([NameEn]);
CREATE INDEX [tblAccountOldBalance_ID_idx] ON [tblAccountOldBalance] ([AccountID]);
CREATE INDEX [tblAccountOldBalance_MoneyTransactionID_idx] ON [tblAccountOldBalance] ([MoneyTransactionID]);
CREATE INDEX [tblAccountPricingGroup_AccountID_idx] ON [tblAccountPricingGroup] ([AccountID]);
CREATE INDEX [tblAccountPricingGroup_PricingGroupID_idx] ON [tblAccountPricingGroup] ([PricingGroupID]);
CREATE INDEX [tblAccountStatus_FormID_idx] ON [tblAccountStatus] ([ID]);
CREATE UNIQUE INDEX [tblAccountType_EndID_idx] ON [tblAccountType] ([EndID]);
CREATE INDEX [tblAccountType_FormID_idx] ON [tblAccountType] ([ID]);
CREATE UNIQUE INDEX [tblAccountType_NameAr_idx] ON [tblAccountType] ([NameAr]);
CREATE UNIQUE INDEX [tblAccountType_NameEn_idx] ON [tblAccountType] ([NameEn]);
CREATE INDEX [tblAccountType_StartID_idx] ON [tblAccountType] ([StartID]);
CREATE INDEX [tblApprovedCourse_AccountID_idx] ON [tblApprovedCourse] ([TeacherAccountID]);
CREATE INDEX [tblApprovedCourse_CourseID_idx] ON [tblApprovedCourse] ([CourseID]);
CREATE INDEX [tblApprovedCourse_ID_idx] ON [tblApprovedCourse] ([ID]);
CREATE INDEX [tblApprovedCourse_SemesterID_idx] ON [tblApprovedCourse] ([TermID]);
CREATE INDEX [tblApprovedCourse_StudentTypeID_idx] ON [tblApprovedCourse] ([StudentTypeID]);
CREATE INDEX [tblApprovedCourse_StudyBookID_idx] ON [tblApprovedCourse] ([StudyBookID]);
CREATE INDEX [tblApprovedCourse_StudyLevelID_idx] ON [tblApprovedCourse] ([StudyLevelID]);
CREATE INDEX [tblApprovedCourse_StudyPeriodID_idx] ON [tblApprovedCourse] ([StudyTypeID]);
CREATE INDEX [tblApprovedCourse_StudyYearID_idx] ON [tblApprovedCourse] ([StudyYearID]);
CREATE INDEX [tblAssayRequest_CustomerAccountID_idx] ON [tblAssayRequest] ([CustomerAccountID]);
CREATE INDEX [tblAssayRequest_ID_idx] ON [tblAssayRequest] ([ID]);
CREATE INDEX [tblAssayRequest_PCID_idx] ON [tblAssayRequest] ([PCID]);
CREATE INDEX [tblAssayRequest_UserID_idx] ON [tblAssayRequest] ([UserID]);
CREATE INDEX [tblAssayRequestInvoice_ID_idx] ON [tblAssayRequestInvoice] ([AssayRequestID]);
CREATE INDEX [tblAssayRequestInvoice_InvoiceID_idx] ON [tblAssayRequestInvoice] ([InvoiceID]);
CREATE INDEX [tblAssayRequestProcedure_AssayRequestID_idx] ON [tblAssayRequestProcedure] ([AssayRequestID]);
CREATE INDEX [tblAssayRequestProcedure_AssayStatusID_idx] ON [tblAssayRequestProcedure] ([AssayStatusID]);
CREATE INDEX [tblAssayRequestProcedure_delegateAccountID_idx] ON [tblAssayRequestProcedure] ([SendToDelegateAccountID]);
CREATE INDEX [tblAssayRequestProcedure_ID_idx] ON [tblAssayRequestProcedure] ([ID]);
CREATE INDEX [tblAssayRequestProcedure_PCID_idx] ON [tblAssayRequestProcedure] ([PCID]);
CREATE INDEX [tblAssayRequestProcedure_ToDelegateAccountID_idx] ON [tblAssayRequestProcedure] ([ExecutedByDelegateAccountID]);
CREATE INDEX [tblAssayRequestProcedure_UserID_idx] ON [tblAssayRequestProcedure] ([UserID]);
CREATE INDEX [tblAttendanceCase_FormID_idx] ON [tblAttendanceCase] ([ID]);
CREATE UNIQUE INDEX [tblAttendanceCase_NameAr_idx] ON [tblAttendanceCase] ([NameAr]);
CREATE UNIQUE INDEX [tblAttendanceCase_NameEn_idx] ON [tblAttendanceCase] ([NameEn]);
CREATE INDEX [tblAuthority_ID_idx] ON [tblAuthority] ([UserGroupID]);
CREATE INDEX [tblAuthority_ObjectID_idx] ON [tblAuthority] ([ObjectID]);
CREATE INDEX [tblAuthorityReportType_PCID_idx] ON [tblAuthorityReportType] ([PCID]);
CREATE INDEX [tblBackUpHistory_PCID_idx] ON [tblBackUpHistory] ([PCID]);
CREATE INDEX [tblBasicDataTables_ID_idx] ON [tblBasicDataTables] ([ID]);
CREATE INDEX [tblBillCopy_GroupID_idx] ON [tblBillCopy] ([BillCopyGroupID]);
CREATE INDEX [tblBillCopy_ID_idx] ON [tblBillCopy] ([BillCopyID]);
CREATE INDEX [tblBranch_FormID_idx] ON [tblBranch] ([ID]);
CREATE INDEX [tblBranch_PO_Code_idx] ON [tblBranch] ([PO_Code]);
CREATE INDEX [tblBuildingType_FormID_idx] ON [tblBuildingType] ([ID]);
CREATE UNIQUE INDEX [tblBuildingType_NameAr_idx] ON [tblBuildingType] ([NameAr]);
CREATE UNIQUE INDEX [tblBuildingType_NameEn_idx] ON [tblBuildingType] ([NameEn]);
CREATE INDEX [tblCalendarType_FormID_idx] ON [tblCalendarType] ([ID]);
CREATE UNIQUE INDEX [tblCalendarType_NameAr_idx] ON [tblCalendarType] ([NameAr]);
CREATE UNIQUE INDEX [tblCalendarType_NameEn_idx] ON [tblCalendarType] ([NameEn]);
CREATE INDEX [tblCardClass_FormID_idx] ON [tblCardClass] ([ID]);
CREATE UNIQUE INDEX [tblCardClass_NameAr_idx] ON [tblCardClass] ([NameAr]);
CREATE UNIQUE INDEX [tblCardClass_NameEn_idx] ON [tblCardClass] ([NameEn]);
CREATE INDEX [tblCarType_FormID_idx] ON [tblCarType] ([ID]);
CREATE UNIQUE INDEX [tblCarType_NameAr_idx] ON [tblCarType] ([NameAr]);
CREATE UNIQUE INDEX [tblCarType_NameEn_idx] ON [tblCarType] ([NameEn]);
CREATE UNIQUE INDEX [tblCategory_ID_idx] ON [tblCategory] ([ID]);
CREATE UNIQUE INDEX [tblCategory_NameAr_idx] ON [tblCategory] ([NameAr]);
CREATE UNIQUE INDEX [tblCategory_NameEn_idx] ON [tblCategory] ([NameEn]);
CREATE INDEX [tblCity_FormID_idx] ON [tblCity] ([ID]);
CREATE UNIQUE INDEX [tblCity_NameAr_idx] ON [tblCity] ([NameAr]);
CREATE UNIQUE INDEX [tblCity_NameEn_idx] ON [tblCity] ([NameEn]);
CREATE INDEX [tblClassDistributionTable_ClassID_idx] ON [tblClassDistributionTable] ([StudyClassID]);
CREATE INDEX [tblClassDistributionTable_ClassRoomID_idx] ON [tblClassDistributionTable] ([ClassRoomID]);
CREATE INDEX [tblClassDistributionTable_CourseID_idx] ON [tblClassDistributionTable] ([ApprovedCourseID]);
CREATE UNIQUE INDEX [tblClassDistributionTable_ID_idx] ON [tblClassDistributionTable] ([ID]);
CREATE INDEX [tblClassDistributionTable_TermID_idx] ON [tblClassDistributionTable] ([TermID]);
CREATE INDEX [tblClassDistributionTable_WeekDayID_idx] ON [tblClassDistributionTable] ([WeekDayID]);
CREATE INDEX [tblCode_FormID_idx] ON [tblCode] ([ID]);
CREATE UNIQUE INDEX [tblCode_NameAr_idx] ON [tblCode] ([Code]);
CREATE INDEX [tblCoding_MainID_idx] ON [tblCoding] ([SubOfCodeingID]);
CREATE INDEX [tblCoding_NameAr_idx] ON [tblCoding] ([NameAr]);
CREATE INDEX [tblCoding_NameEn_idx] ON [tblCoding] ([NameEn]);
CREATE UNIQUE INDEX [tblCoding_SortID_idx] ON [tblCoding] ([SortID], [CodingGroupID]);
CREATE INDEX [tblCodingGroup_FormID_idx] ON [tblCodingGroup] ([ID]);
CREATE UNIQUE INDEX [tblCodingGroup_NameAr_idx] ON [tblCodingGroup] ([NameAr]);
CREATE UNIQUE INDEX [tblCodingGroup_NameEn_idx] ON [tblCodingGroup] ([NameEn]);
CREATE INDEX [tblCodingGroupSubCodingGroup_SubCodingGroupID_idx] ON [tblCodingGroupSubCodingGroup] ([SubCodingGroupID]);
CREATE INDEX [tblCodingGroupSubCodingGroup_SubCodingGroupID1_idx] ON [tblCodingGroupSubCodingGroup] ([MainCodingGroupID]);
CREATE INDEX [tblCompanyDocument_DocumentID_idx] ON [tblCompanyDocument] ([DocumentID]);
CREATE INDEX [tblCompanyDocument_DocumentTypeNo_idx] ON [tblCompanyDocument] ([DocumentTypeID]);
CREATE INDEX [tblCompanyDocument_EmployeeNo_idx] ON [tblCompanyDocument] ([ID]);
CREATE INDEX [tblConditionClass_FormID_idx] ON [tblConditionClass] ([ID]);
CREATE UNIQUE INDEX [tblConditionClass_NameAr_idx] ON [tblConditionClass] ([ConditionAr]);
CREATE UNIQUE INDEX [tblConditionClass_NameAr1_idx] ON [tblConditionClass] ([NameAr]);
CREATE UNIQUE INDEX [tblConditionClass_NameEn_idx] ON [tblConditionClass] ([ConditionEn]);
CREATE UNIQUE INDEX [tblConditionClass_NameEn1_idx] ON [tblConditionClass] ([NameEn]);
CREATE INDEX [tblConfirmationType_FormID_idx] ON [tblConfirmationType] ([ID]);
CREATE UNIQUE INDEX [tblConfirmationType_NameAr_idx] ON [tblConfirmationType] ([NameAr]);
CREATE UNIQUE INDEX [tblConfirmationType_NameEn_idx] ON [tblConfirmationType] ([NameEn]);
CREATE INDEX [tblContactType_DocumentTypeID_idx] ON [tblContactType] ([ID]);
CREATE UNIQUE INDEX [tblContactType_NameAr_idx] ON [tblContactType] ([NameAr]);
CREATE UNIQUE INDEX [tblContactType_NameEn_idx] ON [tblContactType] ([NameEn]);
CREATE INDEX [tblContract_CustomerID_idx] ON [tblContract] ([CustomerID]);
CREATE INDEX [tblContract_ID_idx] ON [tblContract] ([ID]);
CREATE INDEX [tblContractInstalllmentMoneyTransaction_MoneyTransactionID_idx] ON [tblContractInstalllmentMoneyTransaction] ([MoneyTransactionID]);
CREATE INDEX [tblContractInstalllmentMoneyTransaction_tblContractInstalllmentID_idx] ON [tblContractInstalllmentMoneyTransaction] ([ContractInstalllmentID]);
CREATE INDEX [tblContractInvoice_ContractID_idx] ON [tblContractInvoice] ([ContractID]);
CREATE UNIQUE INDEX [tblContractInvoice_InvoiceID_idx] ON [tblContractInvoice] ([InvoiceID]);
CREATE INDEX [tblContractReceipt_ContractID_idx] ON [tblContractReceipt] ([ContractID]);
CREATE INDEX [tblContractReceipt_ReceiptID_idx] ON [tblContractReceipt] ([ReceiptID]);
CREATE INDEX [tblCopyFolder_PCID_idx] ON [tblCopyFolder] ([PCID]);
CREATE INDEX [tblCourse_FormID_idx] ON [tblCourse] ([ID]);
CREATE UNIQUE INDEX [tblCourse_NameAr_idx] ON [tblCourse] ([NameAr]);
CREATE UNIQUE INDEX [tblCourse_NameEn_idx] ON [tblCourse] ([NameEn]);
CREATE INDEX [tblCulturalSideType_FormID_idx] ON [tblCulturalSideType] ([ID]);
CREATE UNIQUE INDEX [tblCulturalSideType_NameAr_idx] ON [tblCulturalSideType] ([NameAr]);
CREATE UNIQUE INDEX [tblCulturalSideType_NameEn_idx] ON [tblCulturalSideType] ([NameEn]);
CREATE INDEX [tblCustomerNoteOnCompany_AssayProcedureTypeID_idx] ON [tblCustomerNoteOnCompany] ([CustomerNoteTypeOnCompanyID]);
CREATE INDEX [tblCustomerNoteOnCompany_delegateAccountID_idx] ON [tblCustomerNoteOnCompany] ([CustomerAccountID]);
CREATE INDEX [tblCustomerNoteOnCompany_InvoiceID_idx] ON [tblCustomerNoteOnCompany] ([InvoiceID]);
CREATE INDEX [tblCustomerNoteOnCompany_ItemID_idx] ON [tblCustomerNoteOnCompany] ([ItemID]);
CREATE INDEX [tblCustomerNoteOnCompany_PCID_idx] ON [tblCustomerNoteOnCompany] ([PCID]);
CREATE INDEX [tblCustomerNoteOnCompany_UserID_idx] ON [tblCustomerNoteOnCompany] ([UserID]);
CREATE INDEX [tblCustomerSourceData_AccountID_idx] ON [tblCustomerSourceData] ([CustomerID]);
CREATE INDEX [tblCustomerSourceData_CityID_idx] ON [tblCustomerSourceData] ([CityID]);
CREATE INDEX [tblCustomerSourceData_SourceEmployeeID_idx] ON [tblCustomerSourceData] ([SourceEmployeeID]);
CREATE INDEX [tblCustomerSourceData_SourceID_idx] ON [tblCustomerSourceData] ([SourceID]);
CREATE INDEX [tblDailySchedule_BranchID_idx] ON [tblDailySchedule] ([BranchID]);
CREATE INDEX [tblDailySchedule_ExecutionStatusID_idx] ON [tblDailySchedule] ([ExecutionStatusID]);
CREATE INDEX [tblDailySchedule_ID_idx] ON [tblDailySchedule] ([ID]);
CREATE INDEX [tblDailySchedule_UserID_idx] ON [tblDailySchedule] ([UserID]);
CREATE INDEX [tblDay_DayID_idx] ON [tblDay] ([DayID]);
CREATE INDEX [tblDisease_FormID_idx] ON [tblDisease] ([ID]);
CREATE UNIQUE INDEX [tblDisease_NameAr_idx] ON [tblDisease] ([NameAr]);
CREATE UNIQUE INDEX [tblDisease_NameEn_idx] ON [tblDisease] ([NameEn]);
CREATE INDEX [tblDividendOperation_ID_idx] ON [tblDividendOperation] ([ID]);
CREATE UNIQUE INDEX [tblDividendOperation_MoneyTransactionID_idx] ON [tblDividendOperation] ([MoneyTransactionID]);
CREATE INDEX [tblDividendOperationInvestors_DividendOperationID_idx] ON [tblDividendOperationInvestors] ([DividendOperationID]);
CREATE INDEX [tblDividendOperationInvestors_ID_idx] ON [tblDividendOperationInvestors] ([InvestorID]);
CREATE INDEX [tblDividendOperationMenagment_DividendOperationID_idx] ON [tblDividendOperationMenagment] ([DividendOperationID]);
CREATE INDEX [tblDividendOperationMenagment_ID_idx] ON [tblDividendOperationMenagment] ([AccountID]);
CREATE INDEX [tblDocumentType_DocumentTypeID_idx] ON [tblDocumentType] ([ID]);
CREATE UNIQUE INDEX [tblDocumentType_NameAr_idx] ON [tblDocumentType] ([NameAr]);
CREATE UNIQUE INDEX [tblDocumentType_NameEn_idx] ON [tblDocumentType] ([NameEn]);
CREATE INDEX [tblEmployeeAttendance_AccountID_idx] ON [tblEmployeeAttendance] ([AccountID]);
CREATE INDEX [tblEmployeeAttendance_ID_idx] ON [tblEmployeeAttendance] ([ID]);
CREATE INDEX [tblEmployeeAttendance_InputMeansID_idx] ON [tblEmployeeAttendance] ([InputMeansID]);
CREATE INDEX [tblEmployeeAttendance_PCID_idx] ON [tblEmployeeAttendance] ([PCID]);
CREATE INDEX [tblEmployeeAttendance_WorkPeriodID_idx] ON [tblEmployeeAttendance] ([WorkPeriodID]);
CREATE INDEX [tblEmployeeContact_BranchID_idx] ON [tblEmployeeContact] ([BranchID]);
CREATE INDEX [tblEmployeeContact_DocumentID_idx] ON [tblEmployeeContact] ([ContactID]);
CREATE INDEX [tblEmployeeContact_DocumentTypeNo_idx] ON [tblEmployeeContact] ([ContactTypeID]);
CREATE INDEX [tblEmployeeContact_TenantID_idx] ON [tblEmployeeContact] ([EmployeeID]);
CREATE INDEX [tblEmployeeDocument_BranchID_idx] ON [tblEmployeeDocument] ([BranchID]);
CREATE INDEX [tblEmployeeDocument_DocumentID_idx] ON [tblEmployeeDocument] ([DocumentID]);
CREATE INDEX [tblEmployeeDocument_DocumentTypeNo_idx] ON [tblEmployeeDocument] ([DocumentTypeNo]);
CREATE INDEX [tblEmployeeDocument_EmployeeNo_idx] ON [tblEmployeeDocument] ([EmployeeID]);
CREATE INDEX [tblEmployeeType_FormID_idx] ON [tblEmployeeType] ([ID]);
CREATE UNIQUE INDEX [tblEmployeeType_NameAr_idx] ON [tblEmployeeType] ([NameAr]);
CREATE UNIQUE INDEX [tblEmployeeType_NameEn_idx] ON [tblEmployeeType] ([NameEn]);
CREATE INDEX [tblExamControl_ExamDistributionTableID_idx] ON [tblExamControl] ([ExamDistributionTableID]);
CREATE INDEX [tblExamControl_WatcherAccountID_idx] ON [tblExamControl] ([WatcherAccountID]);
CREATE INDEX [tblExamDistributionTable_ClassID_idx] ON [tblExamDistributionTable] ([ExamPeriodID]);
CREATE INDEX [tblExamDistributionTable_ClassRoomID_idx] ON [tblExamDistributionTable] ([ClassRoomID]);
CREATE INDEX [tblExamDistributionTable_CourseID_idx] ON [tblExamDistributionTable] ([ApprovedCourseID]);
CREATE INDEX [tblExamDistributionTable_ExamTypeID_idx] ON [tblExamDistributionTable] ([ExamTypeID]);
CREATE UNIQUE INDEX [tblExamDistributionTable_PrimaryKey_idx] ON [tblExamDistributionTable] ([ID]);
CREATE INDEX [tblExamDistributionTable_TermID_idx] ON [tblExamDistributionTable] ([TermID]);
CREATE UNIQUE INDEX [tblExamDistributionTable_UniqeKey_idx] ON [tblExamDistributionTable] ([ApprovedCourseID], [TermID], [ExamTypeID]);
CREATE INDEX [tblExamDistributionTable_WeekDayID_idx] ON [tblExamDistributionTable] ([WeekDayID]);
CREATE INDEX [tblExamDistributionTable_WeekID_idx] ON [tblExamDistributionTable] ([WeekID]);
CREATE INDEX [tblExamLateStudentList_ApprovedCourseID_idx] ON [tblExamLateStudentList] ([ApprovedCourseID]);
CREATE INDEX [tblExamLateStudentList_ID_idx] ON [tblExamLateStudentList] ([ExamLateStudentID]);
CREATE INDEX [tblExamLateStudentList_StudentAccountID_idx] ON [tblExamLateStudentList] ([StudentAccountID]);
CREATE INDEX [tblExamObjection_ExamDistributionTableID_idx] ON [tblExamObjection] ([ExamDistributionTableID]);
CREATE INDEX [tblExamObjection_ID_idx] ON [tblExamObjection] ([ID]);
CREATE INDEX [tblExamObjection_ObjectionTypeID_idx] ON [tblExamObjection] ([ObjectionTypeID]);
CREATE INDEX [tblExamObjection_ReviewerAccountID_idx] ON [tblExamObjection] ([ReviewerAccountID]);
CREATE INDEX [tblExamObjection_StudentAccountID_idx] ON [tblExamObjection] ([StudentAccountID]);
CREATE INDEX [tblExamPeriod_FormID_idx] ON [tblExamPeriod] ([ID]);
CREATE UNIQUE INDEX [tblExamPeriod_NameAr_idx] ON [tblExamPeriod] ([NameAr]);
CREATE UNIQUE INDEX [tblExamPeriod_NameEn_idx] ON [tblExamPeriod] ([NameEn]);
CREATE INDEX [tblExamType_FormID_idx] ON [tblExamType] ([ID]);
CREATE UNIQUE INDEX [tblExamType_NameAr_idx] ON [tblExamType] ([NameAr]);
CREATE UNIQUE INDEX [tblExamType_NameEn_idx] ON [tblExamType] ([NameEn]);
CREATE INDEX [tblExecutionStatus_FormID_idx] ON [tblExecutionStatus] ([ID]);
CREATE INDEX [tblExperienceType_FormID_idx] ON [tblExperienceType] ([ID]);
CREATE UNIQUE INDEX [tblExperienceType_NameAr_idx] ON [tblExperienceType] ([NameAr]);
CREATE UNIQUE INDEX [tblExperienceType_NameEn_idx] ON [tblExperienceType] ([NameEn]);
CREATE INDEX [tblGender_FormID_idx] ON [tblGender] ([ID]);
CREATE UNIQUE INDEX [tblGender_NameAr_idx] ON [tblGender] ([NameAr]);
CREATE UNIQUE INDEX [tblGender_NameEn_idx] ON [tblGender] ([NameEn]);
CREATE UNIQUE INDEX [tblGeneralGrade_ID_idx] ON [tblGeneralGrade] ([ID]);
CREATE UNIQUE INDEX [tblGeneralGrade_NameAr_idx] ON [tblGeneralGrade] ([NameAr]);
CREATE INDEX [tblGenralDiscount_ID_idx] ON [tblGenralDiscount] ([ID]);
CREATE UNIQUE INDEX [tblGrade_ID_idx] ON [tblGrade] ([ID]);
CREATE UNIQUE INDEX [tblGrade_NameAr_idx] ON [tblGrade] ([NameAr]);
CREATE UNIQUE INDEX [tblGroupedCategory_CategoryLater_idx] ON [tblGroupedCategory] ([CategoryLater]);
CREATE UNIQUE INDEX [tblGroupedCategory_ID_idx] ON [tblGroupedCategory] ([ID]);
CREATE UNIQUE INDEX [tblGroupedCategory_NameAr_idx] ON [tblGroupedCategory] ([NameAr]);
CREATE UNIQUE INDEX [tblGroupedCategory_NameEn_idx] ON [tblGroupedCategory] ([NameEn]);
CREATE INDEX [tblHonorDegreeType_FormID_idx] ON [tblHonorDegreeType] ([ID]);
CREATE UNIQUE INDEX [tblHonorDegreeType_NameAr_idx] ON [tblHonorDegreeType] ([NameAr]);
CREATE UNIQUE INDEX [tblHonorDegreeType_NameEn_idx] ON [tblHonorDegreeType] ([NameEn]);
CREATE INDEX [tblHousingType_FormID_idx] ON [tblHousingType] ([ID]);
CREATE UNIQUE INDEX [tblHousingType_NameAr_idx] ON [tblHousingType] ([NameAr]);
CREATE UNIQUE INDEX [tblHousingType_NameEn_idx] ON [tblHousingType] ([NameEn]);
CREATE INDEX [tblInputMeans_FormID_idx] ON [tblInputMeans] ([ID]);
CREATE UNIQUE INDEX [tblInputMeans_NameAr_idx] ON [tblInputMeans] ([NameAr]);
CREATE UNIQUE INDEX [tblInputMeans_NameEn_idx] ON [tblInputMeans] ([NameEn]);
CREATE INDEX [tblInstallment_BranchID_idx] ON [tblInstallment] ([BranchID]);
CREATE INDEX [tblInstallment_InstallmentID_idx] ON [tblInstallment] ([InstallmentID]);
CREATE INDEX [tblInstallment_InstallmentPlanID_idx] ON [tblInstallment] ([InstallmentPlanID]);
CREATE INDEX [tblInstallmentPlan_AccountID_idx] ON [tblInstallmentPlan] ([AccountID]);
CREATE INDEX [tblInstallmentPlan_BranchID_idx] ON [tblInstallmentPlan] ([BranchID]);
CREATE INDEX [tblInstallmentPlan_ConditionClassID_idx] ON [tblInstallmentPlan] ([ConditionClassID]);
CREATE INDEX [tblInstallmentPlan_ID_idx] ON [tblInstallmentPlan] ([ID]);
CREATE INDEX [tblInstallmentPlan_InstallmentPaymentTypeID_idx] ON [tblInstallmentPlan] ([InstallmentPeriodTypeID]);
CREATE INDEX [tblInstallmentPlan_LastReceivedInstallmentID_idx] ON [tblInstallmentPlan] ([LastInstallmentID]);
CREATE UNIQUE INDEX [tblInstallmentPlan_MoneyTransactionID_idx] ON [tblInstallmentPlan] ([MoneyTransactionID]);
CREATE INDEX [tblInstallmentPlan_PaymentTypeID_idx] ON [tblInstallmentPlan] ([PaymentMethodID]);
CREATE INDEX [tblInstallmentPlan_UserID_idx] ON [tblInstallmentPlan] ([UserID]);
CREATE INDEX [tblInvoice_InvoiceTypeID_idx] ON [tblInvoice] ([InvoiceTypeID]);
CREATE UNIQUE INDEX [tblInvoice_MoneyTransactionID_idx] ON [tblInvoice] ([MoneyTransactionID]);
CREATE INDEX [tblInvoice_SubmissionStatusID_idx] ON [tblInvoice] ([SubmissionStatusID]);
CREATE INDEX [tblInvoice_UserID_idx] ON [tblInvoice] ([UserID]);
CREATE INDEX [tblInvoiceAllowanceChargeReason_AllowanceChargeReasonCode_idx] ON [tblInvoiceAllowanceChargeReason] ([AllowanceChargeReasonCode]);
CREATE INDEX [tblInvoiceCancellation_InvoiceID_idx] ON [tblInvoiceCancellation] ([InvoiceID]);
CREATE INDEX [tblInvoiceContact_ContactID_idx] ON [tblInvoiceContact] ([ContactID]);
CREATE INDEX [tblInvoiceContact_DocumentTypeNo_idx] ON [tblInvoiceContact] ([ContactTypeID]);
CREATE INDEX [tblInvoiceContact_InvoiceID_idx] ON [tblInvoiceContact] ([InvoiceID]);
CREATE INDEX [tblInvoiceCopy_ID_idx] ON [tblInvoiceCopy] ([ID]);
CREATE INDEX [tblInvoiceDesignDetails_InvoiceID_idx] ON [tblInvoiceDesignDetails] ([InvoiceID]);
CREATE INDEX [tblInvoiceItemAccount_EmployeeAccountID_idx] ON [tblInvoiceItemAccount] ([AccountID]);
CREATE INDEX [tblInvoiceItemAccount_InvoiceID_idx] ON [tblInvoiceItemAccount] ([InvoiceID]);
CREATE INDEX [tblInvoiceItemAllowanceChargeReason_AllowanceChargeReasonCode_idx] ON [tblInvoiceItemAllowanceChargeReason] ([AllowanceChargeReasonCode]);
CREATE INDEX [tblInvoiceItemConsumables_ConsumableItemID_idx] ON [tblInvoiceItemConsumables] ([ConsumableItemID]);
CREATE INDEX [tblInvoiceItemConsumables_InvoiceID_idx] ON [tblInvoiceItemConsumables] ([InvoiceID]);
CREATE INDEX [tblInvoiceItemConsumables_tblInvoiceItemConsumablesID_idx] ON [tblInvoiceItemConsumables] ([ID]);
CREATE INDEX [tblInvoiceItemDataForLaundry_BluingTypeID_idx] ON [tblInvoiceItemDataForLaundry] ([MerzamTypeID]);
CREATE INDEX [tblInvoiceItemDataForLaundry_InvoiceID_idx] ON [tblInvoiceItemDataForLaundry] ([InvoiceID]);
CREATE INDEX [tblInvoiceItemDataForLaundry_StarchTypeID_idx] ON [tblInvoiceItemDataForLaundry] ([StarchTypeID]);
CREATE INDEX [tblInvoiceItemDataForLaundry_StarchTypeID1_idx] ON [tblInvoiceItemDataForLaundry] ([BluingTypeID]);
CREATE INDEX [tblInvoiceItemDataForLaundry_tblInvoiceItemDataForLaundryID_idx] ON [tblInvoiceItemDataForLaundry] ([InvoiceItemID]);
CREATE INDEX [tblInvoiceItemDataForRestaurant_InvoiceID_idx] ON [tblInvoiceItemDataForRestaurant] ([InvoiceID]);
CREATE INDEX [tblInvoiceItemDataForRestaurant_StarchTypeID1_idx] ON [tblInvoiceItemDataForRestaurant] ([SauceTypeID]);
CREATE INDEX [tblInvoiceItemDataForRestaurant_tblInvoiceItemDataForLaundryID_idx] ON [tblInvoiceItemDataForRestaurant] ([InvoiceItemID]);
CREATE INDEX [tblInvoiceItemDataForRestaurant_TypeID_idx] ON [tblInvoiceItemDataForRestaurant] ([TahininhTypeID]);
CREATE INDEX [tblInvoiceItemDataForRestaurant_TypeID1_idx] ON [tblInvoiceItemDataForRestaurant] ([KetchupTypeID]);
CREATE INDEX [tblInvoiceItemDataForRestaurant_TypeID2_idx] ON [tblInvoiceItemDataForRestaurant] ([SaladTypeID]);
CREATE INDEX [tblInvoiceItemDataForRestaurant_TypeID3_idx] ON [tblInvoiceItemDataForRestaurant] ([PotatoTypeID]);
CREATE INDEX [tblInvoiceItemDataForRestaurant_TypeID4_idx] ON [tblInvoiceItemDataForRestaurant] ([MayonnaiseTypeID]);
CREATE INDEX [tblInvoiceItemNote_InvoiceID_idx] ON [tblInvoiceItemNote] ([InvoiceID]);
CREATE INDEX [tblInvoiceRealEstate_ID_idx] ON [tblInvoiceRealEstate] ([InvoiceID]);
CREATE INDEX [tblInvoiceRealEstate_RealEstateID_idx] ON [tblInvoiceRealEstate] ([RealEstateID]);
CREATE INDEX [tblInvoiceRealestateUnit_BranchID_idx] ON [tblInvoiceRealestateUnit] ([BranchID]);
CREATE INDEX [tblInvoiceRealestateUnit_InvoiceID_idx] ON [tblInvoiceRealestateUnit] ([InvoiceID]);
CREATE INDEX [tblInvoiceRealestateUnit_UnitID_idx] ON [tblInvoiceRealestateUnit] ([UnitID]);
CREATE UNIQUE INDEX [tblInvoiceReportType_NameAr_idx] ON [tblInvoiceReportType] ([NameAr]);
CREATE UNIQUE INDEX [tblInvoiceReportType_NameEn_idx] ON [tblInvoiceReportType] ([NameEn]);
CREATE INDEX [tblInvoiceStatus_InvoiceID_idx] ON [tblInvoiceStatus] ([InvoiceID]);
CREATE INDEX [tblInvoiceStatus_StatusTypeID_idx] ON [tblInvoiceStatus] ([StatusTypeID]);
CREATE INDEX [tblInvoiceType_ColorCode_idx] ON [tblInvoiceType] ([ColorCode]);
CREATE INDEX [tblInvoiceType_CreditorID_idx] ON [tblInvoiceType] ([CreditorTypeID]);
CREATE INDEX [tblInvoiceType_CreditorPersonID_idx] ON [tblInvoiceType] ([StoreCreditorTypeID]);
CREATE INDEX [tblInvoiceType_DebitorPersonID_idx] ON [tblInvoiceType] ([StoreDebitorTypeID]);
CREATE INDEX [tblInvoiceType_DebtorID_idx] ON [tblInvoiceType] ([DebtorTypeID]);
CREATE INDEX [tblInvoiceType_FormID_idx] ON [tblInvoiceType] ([ID]);
CREATE INDEX [tblInvoiceTypeItemUseType_InvoiceTypeID_idx] ON [tblInvoiceTypeItemUseType] ([InvoiceTypeID]);
CREATE INDEX [tblInvoiceTypeItemUseType_UseTypeID_idx] ON [tblInvoiceTypeItemUseType] ([UseTypeID]);
CREATE INDEX [tblInvoiceTypeLink_ID_idx] ON [tblInvoiceTypeLink] ([ID]);
CREATE INDEX [tblInvoiceTypeLink_InvoiceTypeID_idx] ON [tblInvoiceTypeLink] ([InvoiceTypeID]);
CREATE INDEX [tblInvoiceTypeLink_InvoiceTypeID1_idx] ON [tblInvoiceTypeLink] ([ReturnInvoiceTypeID]);
CREATE UNIQUE INDEX [tblInvoiceTypeObject_InvoiceTypeID_idx] ON [tblInvoiceTypeObject] ([InvoiceTypeID]);
CREATE UNIQUE INDEX [tblInvoiceTypeObject_ObjectID_idx] ON [tblInvoiceTypeObject] ([ObjectID]);
CREATE INDEX [tblItem_ID_idx] ON [tblItem] ([ID]);
CREATE INDEX [tblItem_ItemGroupID_idx] ON [tblItem] ([ItemGroupID]);
CREATE INDEX [tblItemBalance_ItemID_idx] ON [tblItemBalance] ([ItemID]);
CREATE INDEX [tblItemBalanceHistory_ItemID_idx] ON [tblItemBalanceHistory] ([ItemID]);
CREATE INDEX [tblItemBalanceHistory_PeriodID_idx] ON [tblItemBalanceHistory] ([PeriodID]);
CREATE INDEX [tblItemBlancePeriod_ID_idx] ON [tblItemBlancePeriod] ([ID]);
CREATE INDEX [tblItemCarData_ColorID1_idx] ON [tblItemCarData] ([CarCompanyID]);
CREATE INDEX [tblItemCarData_ColorID2_idx] ON [tblItemCarData] ([CarNameID]);
CREATE INDEX [tblItemCarData_ColorID3_idx] ON [tblItemCarData] ([ModelFromID]);
CREATE INDEX [tblItemCarData_ColorID4_idx] ON [tblItemCarData] ([ModelToID]);
CREATE INDEX [tblItemCarData_ColorID5_idx] ON [tblItemCarData] ([MadeCountryID]);
CREATE INDEX [tblItemCarData_ColorID6_idx] ON [tblItemCarData] ([ItemCompanyID]);
CREATE INDEX [tblItemCarData_ColorID7_idx] ON [tblItemCarData] ([EngineSizeID]);
CREATE INDEX [tblItemCarData_ColorID8_idx] ON [tblItemCarData] ([LocationInCarID]);
CREATE INDEX [tblItemCarData_ColorID9_idx] ON [tblItemCarData] ([CylinderCountID]);
CREATE INDEX [tblItemCarData_CylinderCountID_idx] ON [tblItemCarData] ([ElectricalTypeID]);
CREATE INDEX [tblItemCarData_CylinderCountID1_idx] ON [tblItemCarData] ([GearTypeID]);
CREATE INDEX [tblItemCarData_ItemID_idx] ON [tblItemCarData] ([ItemID]);
CREATE INDEX [tblItemConsumables_ConsumableItemID_idx] ON [tblItemConsumables] ([ConsumableItemID]);
CREATE INDEX [tblItemConsumables_ItemID_idx] ON [tblItemConsumables] ([ItemID]);
CREATE INDEX [tblItemGroup_FormID_idx] ON [tblItemGroup] ([ID]);
CREATE INDEX [tblItemGroup_ItemTypeID_idx] ON [tblItemGroup] ([ItemTypeID]);
CREATE INDEX [tblItemGroup_UseTypeID_idx] ON [tblItemGroup] ([UseTypeID]);
CREATE INDEX [tblItemGroup_VaTCategoriesID_idx] ON [tblItemGroup] ([VaTCategoriesID]);
CREATE UNIQUE INDEX [tblItemOtherData_CodeNo_idx] ON [tblItemOtherData] ([BarcodeNo]);
CREATE INDEX [tblItemOtherData_ColorID_idx] ON [tblItemOtherData] ([ColorID]);
CREATE INDEX [tblItemOtherData_ItemID_idx] ON [tblItemOtherData] ([ItemID]);
CREATE INDEX [tblItemOtherData_ItemPlaceID_idx] ON [tblItemOtherData] ([ItemPlaceID]);
CREATE INDEX [tblItemOtherData_ItemSizeID_idx] ON [tblItemOtherData] ([ItemSizeID]);
CREATE INDEX [tblItemPackingAndUnPacking_MoneyTransactionID_idx] ON [tblItemPackingAndUnPacking] ([ID]);
CREATE INDEX [tblItemPackingAndUnPacking_StoreCreditorID_idx] ON [tblItemPackingAndUnPacking] ([StoreCreditorID]);
CREATE INDEX [tblItemPackingAndUnPacking_UserID_idx] ON [tblItemPackingAndUnPacking] ([UserID]);
CREATE INDEX [tblItemPackingAndUnPackingDetails_CreditorID_idx] ON [tblItemPackingAndUnPackingDetails] ([CreditorItemID]);
CREATE INDEX [tblItemPackingAndUnPackingDetails_DebtorID_idx] ON [tblItemPackingAndUnPackingDetails] ([DebtorItemID]);
CREATE INDEX [tblItemPackingAndUnPackingDetails_ID_idx] ON [tblItemPackingAndUnPackingDetails] ([ID]);
CREATE INDEX [tblItemPackingAndUnPackingDetails_MoneyTransactionID_idx] ON [tblItemPackingAndUnPackingDetails] ([ItemPackingAndUnPackingID]);
CREATE INDEX [tblItemPlace_FormID_idx] ON [tblItemPlace] ([ID]);
CREATE UNIQUE INDEX [tblItemPlace_NameAr_idx] ON [tblItemPlace] ([NameAr]);
CREATE UNIQUE INDEX [tblItemPlace_NameEn_idx] ON [tblItemPlace] ([NameEn]);
CREATE INDEX [tblItemType_FormID_idx] ON [tblItemType] ([ID]);
CREATE UNIQUE INDEX [tblItemType_NameAr_idx] ON [tblItemType] ([NameAr]);
CREATE UNIQUE INDEX [tblItemType_NameEn_idx] ON [tblItemType] ([NameEn]);
CREATE INDEX [tblJob_FormID_idx] ON [tblJob] ([ID]);
CREATE UNIQUE INDEX [tblJob_NameAr_idx] ON [tblJob] ([NameAr]);
CREATE UNIQUE INDEX [tblJob_NameEn_idx] ON [tblJob] ([NameEn]);
CREATE INDEX [tblJournalEntry_CodeID_idx] ON [tblJournalEntry] ([CodeID]);
CREATE UNIQUE INDEX [tblJournalEntry_ID2_idx] ON [tblJournalEntry] ([ID]);
CREATE INDEX [tblJournalEntry_MoneyTransactionID_idx] ON [tblJournalEntry] ([MoneyTransactionID]);
CREATE INDEX [tblJournalEntry_PCID_idx] ON [tblJournalEntry] ([PCID]);
CREATE INDEX [tblJournalEntry_UserID_idx] ON [tblJournalEntry] ([UserID]);
CREATE INDEX [tblJournalEntryCancellation_ID_idx] ON [tblJournalEntryCancellation] ([JournalEntryID]);
CREATE INDEX [tblManagement_FormID_idx] ON [tblManagement] ([ID]);
CREATE UNIQUE INDEX [tblManagement_NameAr_idx] ON [tblManagement] ([NameAr]);
CREATE UNIQUE INDEX [tblManagement_NameEn_idx] ON [tblManagement] ([NameEn]);
CREATE INDEX [tblMark_FormID_idx] ON [tblMark] ([ID]);
CREATE UNIQUE INDEX [tblMark_NameAr_idx] ON [tblMark] ([NameAr]);
CREATE UNIQUE INDEX [tblMark_NameEn_idx] ON [tblMark] ([NameEn]);
CREATE INDEX [tblMoneyAccountType_DocumentTypeID_idx] ON [tblMoneyAccountType] ([ID]);
CREATE UNIQUE INDEX [tblMoneyAccountType_NameAr_idx] ON [tblMoneyAccountType] ([NameAr]);
CREATE UNIQUE INDEX [tblMoneyAccountType_NameEn_idx] ON [tblMoneyAccountType] ([NameEn]);
CREATE INDEX [tblMoneyTransaction_CodeID_idx] ON [tblMoneyTransaction] ([CodeID]);
CREATE UNIQUE INDEX [tblMoneyTransaction_ID_idx] ON [tblMoneyTransaction] ([ID]);
CREATE INDEX [tblMoneyTransaction_PCID_idx] ON [tblMoneyTransaction] ([PCID]);
CREATE INDEX [tblMoneyTransactionDetails_AllowanceChargeReasonCode_idx] ON [tblMoneyTransactionDetails] ([AllowanceChargeReasonCode]);
CREATE INDEX [tblMoneyTransactionDetails_AllowanceChargeReasonCode1_idx] ON [tblMoneyTransactionDetails] ([AccountID]);
CREATE INDEX [tblMoneyTransactionDetails_CreditorID_idx] ON [tblMoneyTransactionDetails] ([MoneyTransactionID]);
CREATE INDEX [tblMoneyTransactionDetails_ID_idx] ON [tblMoneyTransactionDetails] ([ID]);
CREATE INDEX [tblMoneyTransactionDetails_ID2_idx] ON [tblMoneyTransactionDetails] ([AccountSideID]);
CREATE INDEX [tblMoneyTransactionInvoice_ID_idx] ON [tblMoneyTransactionInvoice] ([InvoiceID]);
CREATE UNIQUE INDEX [tblMoneyTransactionInvoice_MoneyTransactionID_idx] ON [tblMoneyTransactionInvoice] ([MoneyTransactionID]);
CREATE INDEX [tblMonth_FormID_idx] ON [tblMonth] ([ID]);
CREATE UNIQUE INDEX [tblMonth_NameAr_idx] ON [tblMonth] ([NameAr]);
CREATE UNIQUE INDEX [tblMonth_NameEn_idx] ON [tblMonth] ([NameEn]);
CREATE INDEX [tblNationality_FormID_idx] ON [tblNationality] ([ID]);
CREATE UNIQUE INDEX [tblNationality_NameAr_idx] ON [tblNationality] ([NameAr]);
CREATE UNIQUE INDEX [tblNationality_NameEn_idx] ON [tblNationality] ([NameEn]);
CREATE INDEX [tblNoteOnCompany_AssayProcedureTypeID_idx] ON [tblNoteOnCompany] ([NoteTypeID]);
CREATE INDEX [tblNoteOnCompany_delegateAccountID_idx] ON [tblNoteOnCompany] ([CustomerAccountID]);
CREATE INDEX [tblNoteOnCompany_InvoiceID_idx] ON [tblNoteOnCompany] ([InvoiceID]);
CREATE INDEX [tblNoteOnCompany_PCID_idx] ON [tblNoteOnCompany] ([PCID]);
CREATE INDEX [tblNoteOnCompany_UserID_idx] ON [tblNoteOnCompany] ([UserID]);
CREATE INDEX [tblNoteOnCustomer_AssayProcedureTypeID_idx] ON [tblNoteOnCustomer] ([CustomerNoteTypeID]);
CREATE INDEX [tblNoteOnCustomer_delegateAccountID_idx] ON [tblNoteOnCustomer] ([CustomerAccountID]);
CREATE INDEX [tblNoteOnCustomer_InvoiceID_idx] ON [tblNoteOnCustomer] ([InvoiceID]);
CREATE INDEX [tblNoteOnCustomer_NoteSourceID_idx] ON [tblNoteOnCustomer] ([NoteSourceID]);
CREATE INDEX [tblNoteOnCustomer_PCID_idx] ON [tblNoteOnCustomer] ([PCID]);
CREATE INDEX [tblNoteOnCustomer_UserID_idx] ON [tblNoteOnCustomer] ([UserID]);
CREATE INDEX [tblNoteOnEmployee_AssayProcedureTypeID_idx] ON [tblNoteOnEmployee] ([NoteTypeID]);
CREATE INDEX [tblNoteOnEmployee_delegateAccountID_idx] ON [tblNoteOnEmployee] ([CustomerAccountID]);
CREATE INDEX [tblNoteOnEmployee_InvoiceID_idx] ON [tblNoteOnEmployee] ([InvoiceID]);
CREATE INDEX [tblNoteOnEmployee_NoteSourceID_idx] ON [tblNoteOnEmployee] ([NoteSourceID]);
CREATE INDEX [tblNoteOnEmployee_PCID_idx] ON [tblNoteOnEmployee] ([PCID]);
CREATE INDEX [tblNoteOnEmployee_UserID_idx] ON [tblNoteOnEmployee] ([UserID]);
CREATE INDEX [tblObject_FormID_idx] ON [tblObject] ([ID]);
CREATE INDEX [tblObject_ItemTypeID_idx] ON [tblObject] ([ObjectTypeID]);
CREATE INDEX [tblObjectionType_FormID_idx] ON [tblObjectionType] ([ID]);
CREATE UNIQUE INDEX [tblObjectionType_NameAr_idx] ON [tblObjectionType] ([NameAr]);
CREATE UNIQUE INDEX [tblObjectionType_NameEn_idx] ON [tblObjectionType] ([NameEn]);
CREATE INDEX [tblObjectType_FormID_idx] ON [tblObjectType] ([ID]);
CREATE INDEX [tblOrderExecutionMember_ImplementationStatusID_idx] ON [tblOrderExecutionMember] ([OrderExecutionID]);
CREATE INDEX [tblOrderExecutionMember_MemberStatusID_idx] ON [tblOrderExecutionMember] ([MemberStatusID]);
CREATE INDEX [tblOrderExecutionMember_TeamGroupID_idx] ON [tblOrderExecutionMember] ([TeamGroupID]);
CREATE INDEX [tblPaymentMethod_FormID_idx] ON [tblPaymentMethod] ([ID]);
CREATE INDEX [tblPaymentMethod_MoneyAccountTypeID_idx] ON [tblPaymentMethod] ([MoneyAccountTypeID]);
CREATE INDEX [tblPaymentPeriodType_FormID_idx] ON [tblPaymentPeriodType] ([ID]);
CREATE INDEX [tblPaymentPeriodType_PeriodTypeCode_idx] ON [tblPaymentPeriodType] ([PeriodTypeCode]);
CREATE INDEX [tblPaymentSubject_FormID_idx] ON [tblPaymentSubject] ([ID]);
CREATE UNIQUE INDEX [tblPCSetting_FormID_idx] ON [tblPCSetting] ([PCID]);
CREATE INDEX [tblPeriodType_FormID_idx] ON [tblPeriodType] ([ID]);
CREATE UNIQUE INDEX [tblPeriodType_NameAr_idx] ON [tblPeriodType] ([NameAr]);
CREATE UNIQUE INDEX [tblPeriodType_NameEn_idx] ON [tblPeriodType] ([NameEn]);
CREATE INDEX [tblPeriodType_PeriodTypeCode_idx] ON [tblPeriodType] ([PeriodTypeCode]);
CREATE INDEX [tblPersonalCategory_AccountID_idx] ON [tblPersonalCategory] ([AccountID]);
CREATE INDEX [tblPersonalCategory_MainCategoryID_idx] ON [tblPersonalCategory] ([CategoryID]);
CREATE UNIQUE INDEX [tblPersonalData_AccountID_idx] ON [tblPersonalData] ([AccountID]);
CREATE INDEX [tblPersonalData_AccountNoteID_idx] ON [tblPersonalData] ([AccountNoteID]);
CREATE INDEX [tblPersonalData_ContactPersonID_idx] ON [tblPersonalData] ([ContactPersonID]);
CREATE INDEX [tblPersonalData_EducationLevelID_idx] ON [tblPersonalData] ([EducationLevelID]);
CREATE INDEX [tblPersonalData_EducationMajorID_idx] ON [tblPersonalData] ([EducationMajorID]);
CREATE INDEX [tblPersonalData_EmployeeTypeID_idx] ON [tblPersonalData] ([EmployeeTypeID]);
CREATE INDEX [tblPersonalData_GenderID_idx] ON [tblPersonalData] ([GenderID]);
CREATE INDEX [tblPersonalData_JobID_idx] ON [tblPersonalData] ([JobID]);
CREATE INDEX [tblPersonalData_ManagementID_idx] ON [tblPersonalData] ([ManagementID]);
CREATE INDEX [tblPersonalData_PersonalStatusID_idx] ON [tblPersonalData] ([PersonalStatusID]);
CREATE INDEX [tblPersonalData_PlaceID_idx] ON [tblPersonalData] ([PlaceID]);
CREATE INDEX [tblPersonalData_PO_Code_idx] ON [tblPersonalData] ([PO_Code]);
CREATE INDEX [tblPersonalData_ReligionID_idx] ON [tblPersonalData] ([ReligionID]);
CREATE INDEX [tblPersonalData_SectionID_idx] ON [tblPersonalData] ([SectionID]);
CREATE INDEX [tblPersonalData_SpecializationID_idx] ON [tblPersonalData] ([SpecializationID]);
CREATE INDEX [tblPersonalData_SponsorID_idx] ON [tblPersonalData] ([SponsorID]);
CREATE INDEX [tblPersonalData_StudyLevelID_idx] ON [tblPersonalData] ([StudyLevelID]);
CREATE INDEX [tblPersonalData_TitleID_idx] ON [tblPersonalData] ([TitleID]);
CREATE UNIQUE INDEX [tblPersonalGroupedCategory_AccountID_idx] ON [tblPersonalGroupedCategory] ([AccountID]);
CREATE INDEX [tblPersonalGroupedCategory_MainCategoryID_idx] ON [tblPersonalGroupedCategory] ([GroupedCategoryID]);
CREATE INDEX [tblPhoneDirectory_BranchID_idx] ON [tblPhoneDirectory] ([BranchID]);
CREATE INDEX [tblPhoneDirectory_NationalityID_idx] ON [tblPhoneDirectory] ([NationalityID]);
CREATE INDEX [tblPhoneDirectory_SexID_idx] ON [tblPhoneDirectory] ([SexID]);
CREATE INDEX [tblPhoneDirectoryContact_DocumentID_idx] ON [tblPhoneDirectoryContact] ([ContactID]);
CREATE INDEX [tblPhoneDirectoryContact_DocumentTypeNo_idx] ON [tblPhoneDirectoryContact] ([ContactTypeID]);
CREATE INDEX [tblPhoneDirectoryContact_TenantID_idx] ON [tblPhoneDirectoryContact] ([PhoneDirectoryID]);
CREATE INDEX [tblPictureData_ID_idx] ON [tblPictureData] ([ID]);
CREATE INDEX [tblPictureData_PlaceID_idx] ON [tblPictureData] ([PlaceID]);
CREATE INDEX [tblPictureData_SourceID_idx] ON [tblPictureData] ([SourceID]);
CREATE UNIQUE INDEX [tblPictureOccasion_ID_idx] ON [tblPictureOccasion] ([ID]);
CREATE UNIQUE INDEX [tblPictureOccasion_NameAr_idx] ON [tblPictureOccasion] ([NameAr]);
CREATE INDEX [tblPicturePerson_PersonID_idx] ON [tblPicturePerson] ([PersonID]);
CREATE INDEX [tblPicturePerson_PictureID_idx] ON [tblPicturePerson] ([PictureID]);
CREATE UNIQUE INDEX [tblPicturePlace_ID_idx] ON [tblPicturePlace] ([ID]);
CREATE UNIQUE INDEX [tblPicturePlace_NameAr_idx] ON [tblPicturePlace] ([NameAr]);
CREATE UNIQUE INDEX [tblPictureSource_ID_idx] ON [tblPictureSource] ([ID]);
CREATE UNIQUE INDEX [tblPictureSource_NameAr_idx] ON [tblPictureSource] ([NameAr]);
CREATE INDEX [tblPoints_ID_idx] ON [tblPoints] ([AccountID]);
CREATE INDEX [tblPricingGroupItem_ID_idx] ON [tblPricingGroupItem] ([ItemID]);
CREATE INDEX [tblPricingGroupItem_PricingGroupID_idx] ON [tblPricingGroupItem] ([PricingGroupID]);
CREATE INDEX [tblPricingGroupItemForLaundry_ID_idx] ON [tblPricingGroupItemForLaundry] ([ItemID]);
CREATE INDEX [tblPricingGroupItemForLaundry_MaterialTypeID_idx] ON [tblPricingGroupItemForLaundry] ([UrgentTypeID]);
CREATE INDEX [tblPricingGroupItemForLaundry_MerzamTypeID_idx] ON [tblPricingGroupItemForLaundry] ([ServiceTypeID]);
CREATE INDEX [tblPricingGroupItemForLaundry_MerzamTypeID1_idx] ON [tblPricingGroupItemForLaundry] ([MaterialTypeID]);
CREATE INDEX [tblPricingGroupItemForLaundry_PricingGroupID_idx] ON [tblPricingGroupItemForLaundry] ([PricingGroupID]);
CREATE INDEX [tblProcedureType_DocumentTypeID_idx] ON [tblProcedureType] ([ID]);
CREATE INDEX [tblProcedureType_GivenGradeID_idx] ON [tblProcedureType] ([GivenGradeID]);
CREATE UNIQUE INDEX [tblProcedureType_NameAr_idx] ON [tblProcedureType] ([NameAr]);
CREATE UNIQUE INDEX [tblProcedureType_NameEn_idx] ON [tblProcedureType] ([NameEn]);
CREATE INDEX [tblProgramObject_ObjectID_idx] ON [tblProgramObject] ([ObjectID]);
CREATE INDEX [tblProgramObject_ProgramUseTypeID_idx] ON [tblProgramObject] ([ProgramUseTypeID]);
CREATE INDEX [tblProgramReportType_AccountTypeID_idx] ON [tblProgramReportType] ([ReportTypeID]);
CREATE INDEX [tblProgramReportType_ProgramID_idx] ON [tblProgramReportType] ([ProgramUseTypeID]);
CREATE INDEX [tblProgramSetting_AmanFundAccountID_idx] ON [tblProgramSetting] ([ComplexProfitOrLossAccountID]);
CREATE INDEX [tblProgramSetting_AmanFundِAccountID_idx] ON [tblProgramSetting] ([AmanFundAccountID]);
CREATE INDEX [tblProgramSetting_AssayCommissionAccountID_idx] ON [tblProgramSetting] ([MemberCommissionAccountID]);
CREATE INDEX [tblProgramSetting_ComplexProfitOrLossAccountID1_idx] ON [tblProgramSetting] ([ShareCapitalAccountID]);
CREATE INDEX [tblProgramSetting_ContractingAccountID_idx] ON [tblProgramSetting] ([RentAccountID]);
CREATE INDEX [tblProgramSetting_GivenDiscountAccountID_idx] ON [tblProgramSetting] ([GivenDiscountAccountID]);
CREATE INDEX [tblProgramSetting_GottenDiscountAccountID_idx] ON [tblProgramSetting] ([GottenDiscountAccountID]);
CREATE INDEX [tblProgramSetting_GottenDiscountAccountID1_idx] ON [tblProgramSetting] ([CollectionCommissionAccountID]);
CREATE INDEX [tblProgramSetting_MarketingCommissionAccountID_idx] ON [tblProgramSetting] ([MarketingCommissionAccountID]);
CREATE INDEX [tblProgramSetting_MarketingCommissionAccountID1_idx] ON [tblProgramSetting] ([AssayCommissionAccountID]);
CREATE INDEX [tblProgramSetting_MemberCommissionAccountID_idx] ON [tblProgramSetting] ([ContractingAccountID]);
CREATE INDEX [tblProgramSetting_OwnerRentAccountID_idx] ON [tblProgramSetting] ([RentTempAccountID]);
CREATE INDEX [tblProgramSetting_RentAccountID_idx] ON [tblProgramSetting] ([InsuranceAccountID]);
CREATE INDEX [tblProgramSetting_ShareCapitalAccountID_idx] ON [tblProgramSetting] ([OpenBalanceAccountID]);
CREATE INDEX [tblProgramSetting_SparePartItemUseTypeID_idx] ON [tblProgramSetting] ([SparePartItemUseTypeID]);
CREATE INDEX [tblProgramSetting_tblProgramSettingID_idx] ON [tblProgramSetting] ([ID]);
CREATE INDEX [tblProgramSetting_WaterTempAccountID_idx] ON [tblProgramSetting] ([WaterTempAccountID]);
CREATE INDEX [tblProgramSetting_WaterTempAccountID1_idx] ON [tblProgramSetting] ([InsuranceTempAccountID]);
CREATE INDEX [tblProgramUseType_FormID_idx] ON [tblProgramUseType] ([ID]);
CREATE UNIQUE INDEX [tblProgramUseType_NameAr_idx] ON [tblProgramUseType] ([NameAr]);
CREATE UNIQUE INDEX [tblProgramUseType_NameEn_idx] ON [tblProgramUseType] ([NameEn]);
CREATE INDEX [tblProgramUseTypeAccountType_AccountTypeID_idx] ON [tblProgramUseTypeAccountType] ([AccountTypeID]);
CREATE INDEX [tblProgramUseTypeAccountType_ProgramID_idx] ON [tblProgramUseTypeAccountType] ([ProgramUseTypeID]);
CREATE INDEX [tblProgramUseTypeCodingGroup_CodingGroupID_idx] ON [tblProgramUseTypeCodingGroup] ([CodingGroupID]);
CREATE INDEX [tblProgramUseTypeCodingGroup_ProgramID_idx] ON [tblProgramUseTypeCodingGroup] ([ProgramUseTypeID]);
CREATE INDEX [tblProgramUseTypeInvoiceType_AccountTypeID_idx] ON [tblProgramUseTypeInvoiceType] ([InvoiceTypeID]);
CREATE INDEX [tblProgramUseTypeInvoiceType_ProgramID_idx] ON [tblProgramUseTypeInvoiceType] ([ProgramUseTypeID]);
CREATE INDEX [tblProgramUseTypeReceiptSubject_ProgramID_idx] ON [tblProgramUseTypeReceiptSubject] ([ProgramUseTypeID]);
CREATE INDEX [tblProgramUseTypeReceiptSubject_ReceiptSubjectID_idx] ON [tblProgramUseTypeReceiptSubject] ([ReceiptSubjectID]);
CREATE INDEX [tblQuarter_CityID_idx] ON [tblQuarter] ([CityID]);
CREATE INDEX [tblQuarter_FormID_idx] ON [tblQuarter] ([ID]);
CREATE UNIQUE INDEX [tblQuarter_NameAr_idx] ON [tblQuarter] ([NameAr]);
CREATE UNIQUE INDEX [tblQuarter_NameEn_idx] ON [tblQuarter] ([NameEn]);
CREATE INDEX [tblRealEstate_BranchID_idx] ON [tblRealEstate] ([BranchID]);
CREATE INDEX [tblRealEstate_ID_idx] ON [tblRealEstate] ([ID]);
CREATE INDEX [tblRealEstate_OwnerID_idx] ON [tblRealEstate] ([OwnerID]);
CREATE INDEX [tblRealEstate_QuarterID_idx] ON [tblRealEstate] ([QuarterID]);
CREATE INDEX [tblRealEstateUnit_BranchID_idx] ON [tblRealEstateUnit] ([BranchID]);
CREATE INDEX [tblRealEstateUnit_HousingTypeID_idx] ON [tblRealEstateUnit] ([HousingTypeID]);
CREATE INDEX [tblRealEstateUnit_ID_idx] ON [tblRealEstateUnit] ([ID]);
CREATE INDEX [tblRealEstateUnit_RealEstateID_idx] ON [tblRealEstateUnit] ([RealEstateID]);
CREATE INDEX [tblRealEstateUnit_UnitStatusID_idx] ON [tblRealEstateUnit] ([UnitStatusID]);
CREATE INDEX [tblRealEstateUnit_UnitTypeID_idx] ON [tblRealEstateUnit] ([UnitTypeID]);
CREATE INDEX [tblRealEstateUnitAction_BranchID_idx] ON [tblRealEstateUnitAction] ([BranchID]);
CREATE INDEX [tblRealEstateUnitAction_ID_idx] ON [tblRealEstateUnitAction] ([UnitID]);
CREATE INDEX [tblRealEstateUnitAction_ID1_idx] ON [tblRealEstateUnitAction] ([ID]);
CREATE INDEX [tblRealEstateUnitAction_UnitActionTypeID_idx] ON [tblRealEstateUnitAction] ([UnitActionTypeID]);
CREATE INDEX [tblRealEstateUnitPrice_BranchID_idx] ON [tblRealEstateUnitPrice] ([BranchID]);
CREATE INDEX [tblRealEstateUnitPrice_ID_idx] ON [tblRealEstateUnitPrice] ([UnitID]);
CREATE INDEX [tblRealEstateUnitPrice_RentTypeID_idx] ON [tblRealEstateUnitPrice] ([RentTypeID]);
CREATE INDEX [tblReceiptCancellation_ID_idx] ON [tblReceiptCancellation] ([RecieptID]);
CREATE INDEX [tblReceiptInstallment_BranchID_idx] ON [tblReceiptInstallment] ([BranchID]);
CREATE INDEX [tblReceiptInstallment_ID_idx] ON [tblReceiptInstallment] ([InstallmentID]);
CREATE INDEX [tblReceiptInstallment_InstallmentPlanID_idx] ON [tblReceiptInstallment] ([InstallmentPlanID]);
CREATE INDEX [tblReceiptInstallment_ReceiptID_idx] ON [tblReceiptInstallment] ([ReceiptID]);
CREATE INDEX [tblReceiptInvoice_ID_idx] ON [tblReceiptInvoice] ([InvoiceID]);
CREATE INDEX [tblReceiptInvoice_MoneyTransactionID_idx] ON [tblReceiptInvoice] ([ReceiptID]);
CREATE INDEX [tblReceiptManagementLease_BranchID_idx] ON [tblReceiptManagementLease] ([BranchID]);
CREATE INDEX [tblReceiptManagementLease_ID1_idx] ON [tblReceiptManagementLease] ([ReceiptID]);
CREATE INDEX [tblReceiptManagementLease_LeaseID_idx] ON [tblReceiptManagementLease] ([LeaseID]);
CREATE INDEX [tblReceiptRentLease_BranchID_idx] ON [tblReceiptRentLease] ([BranchID]);
CREATE INDEX [tblReceiptRentLease_ID1_idx] ON [tblReceiptRentLease] ([ReceiptID]);
CREATE INDEX [tblReceiptRentLease_LeaseID_idx] ON [tblReceiptRentLease] ([LeaseID]);
CREATE UNIQUE INDEX [tblReceiptReportType_NameAr_idx] ON [tblReceiptReportType] ([NameAr]);
CREATE UNIQUE INDEX [tblReceiptReportType_NameEn_idx] ON [tblReceiptReportType] ([NameEn]);
CREATE INDEX [tblReceiptType_FormID_idx] ON [tblReceiptType] ([ID]);
CREATE INDEX [tblReceiptTypeObject_ObjectID_idx] ON [tblReceiptTypeObject] ([ObjectID]);
CREATE INDEX [tblReceiptTypeObject_ReceiptTypeID_idx] ON [tblReceiptTypeObject] ([ReceiptTypeID]);
CREATE INDEX [tblReceivedOutsideSearchReport_ID_idx] ON [tblReceivedOutsideSearchReport] ([ID]);
CREATE INDEX [tblReceivedOutsideSearchReport_YearID_idx] ON [tblReceivedOutsideSearchReport] ([YearID]);
CREATE INDEX [tblReceivedOutsideSearchReportList_ApprovedCourseID_idx] ON [tblReceivedOutsideSearchReportList] ([ApprovedCourseID]);
CREATE INDEX [tblReceivedOutsideSearchReportList_ReceivedOutsideSearchReportID_idx] ON [tblReceivedOutsideSearchReportList] ([ReceivedOutsideSearchReportID]);
CREATE INDEX [tblReceivedOutsideSearchReportList_StudentAccountID_idx] ON [tblReceivedOutsideSearchReportList] ([StudentAccountID]);
CREATE INDEX [tblRegistrationStatus_FormID_idx] ON [tblRegistrationStatus] ([ID]);
CREATE UNIQUE INDEX [tblRegistrationStatus_NameAr_idx] ON [tblRegistrationStatus] ([NameAr]);
CREATE UNIQUE INDEX [tblRegistrationStatus_NameEn_idx] ON [tblRegistrationStatus] ([NameEn]);
CREATE INDEX [tblRentLease_BranchID_idx] ON [tblRentLease] ([BranchID]);
CREATE INDEX [tblRentLease_CalendarTypeID_idx] ON [tblRentLease] ([CalendarTypeID]);
CREATE INDEX [tblRentLease_HousingTypeID_idx] ON [tblRentLease] ([HousingTypeID]);
CREATE INDEX [tblRentLease_ID_idx] ON [tblRentLease] ([UnitID]);
CREATE INDEX [tblRentLease_ID1_idx] ON [tblRentLease] ([ID]);
CREATE INDEX [tblRentLease_MoneyTransactionID_idx] ON [tblRentLease] ([MoneyTransactionID]);
CREATE INDEX [tblRentLease_PaymentMethodID_idx] ON [tblRentLease] ([PaymentMethodID]);
CREATE INDEX [tblRentLease_RentTypeID_idx] ON [tblRentLease] ([RentTypeID]);
CREATE INDEX [tblRentLease_ReservationID_idx] ON [tblRentLease] ([ReservationID]);
CREATE INDEX [tblRentLease_TenantID_idx] ON [tblRentLease] ([TenantID]);
CREATE INDEX [tblRentLease_UnitStatusID_idx] ON [tblRentLease] ([UnitStatusID]);
CREATE INDEX [tblRentLease_UserID_idx] ON [tblRentLease] ([UserID]);
CREATE INDEX [tblRentLease_Hotel_BranchID_idx] ON [tblRentLease_Hotel] ([BranchID]);
CREATE INDEX [tblRentLease_Hotel_ID_idx] ON [tblRentLease_Hotel] ([UnitID]);
CREATE INDEX [tblRentLease_Hotel_ID1_idx] ON [tblRentLease_Hotel] ([ID]);
CREATE INDEX [tblRentLease_Hotel_MoneyTransactionID_idx] ON [tblRentLease_Hotel] ([MoneyTransactionID]);
CREATE INDEX [tblRentLease_Hotel_TenantID_idx] ON [tblRentLease_Hotel] ([TenantID]);
CREATE INDEX [tblRentLease_Hotel_UnitStatusID_idx] ON [tblRentLease_Hotel] ([UnitStatusID]);
CREATE INDEX [tblRentLeaseAttendant_AttendantID_idx] ON [tblRentLeaseAttendant] ([AttendantID]);
CREATE INDEX [tblRentLeaseAttendant_BranchID_idx] ON [tblRentLeaseAttendant] ([BranchID]);
CREATE INDEX [tblRentLeaseAttendant_ID1_idx] ON [tblRentLeaseAttendant] ([ID]);
CREATE INDEX [tblRentLeaseCancellation_BranchID_idx] ON [tblRentLeaseCancellation] ([BranchID]);
CREATE INDEX [tblRentLeaseCancellation_ID_idx] ON [tblRentLeaseCancellation] ([RentLeaseID]);
CREATE UNIQUE INDEX [tblRentLeaseCancellation_MoneyTransactionID_idx] ON [tblRentLeaseCancellation] ([BranchID], [MoneyTransactionID]);
CREATE INDEX [tblRentLeaseRenewal_BranchID_idx] ON [tblRentLeaseRenewal] ([BranchID]);
CREATE INDEX [tblRentLeaseRenewal_ID1_idx] ON [tblRentLeaseRenewal] ([ID]);
CREATE INDEX [tblRentLeaseRenewal_LeaseID_idx] ON [tblRentLeaseRenewal] ([LeaseID]);
CREATE UNIQUE INDEX [tblRentLeaseRenewal_MoneyTransactionID_idx] ON [tblRentLeaseRenewal] ([MoneyTransactionID], [BranchID]);
CREATE INDEX [tblRentLeaseRenewalCancellation_BranchID_idx] ON [tblRentLeaseRenewalCancellation] ([BranchID]);
CREATE INDEX [tblRentLeaseRenewalCancellation_ID_idx] ON [tblRentLeaseRenewalCancellation] ([RentLeaseRenewalID]);
CREATE INDEX [tblRentLeaseRenewalPaymentSubject_BranchID_idx] ON [tblRentLeaseRenewalPaymentSubject] ([BranchID]);
CREATE INDEX [tblRentLeaseRenewalPaymentSubject_ID1_idx] ON [tblRentLeaseRenewalPaymentSubject] ([RentLeaseRenewalID]);
CREATE INDEX [tblRentLeaseRenewalPaymentSubject_PaymentTypeID_idx] ON [tblRentLeaseRenewalPaymentSubject] ([PaymentSubjectID]);
CREATE INDEX [tblRentLeaseRenewalPeriodCancellation_BranchID_idx] ON [tblRentLeaseRenewalPeriodCancellation] ([BranchID]);
CREATE UNIQUE INDEX [tblRentLeaseRenewalPeriodCancellation_MoneyTransactionID_idx] ON [tblRentLeaseRenewalPeriodCancellation] ([MoneyTransactionID], [BranchID]);
CREATE INDEX [tblRentLeaseRenewalPeriodCancellation_RentLeaseRenewalID_idx] ON [tblRentLeaseRenewalPeriodCancellation] ([RentLeaseRenewalID]);
CREATE INDEX [tblRentType_FormID_idx] ON [tblRentType] ([ID]);
CREATE UNIQUE INDEX [tblRentType_NameAr_idx] ON [tblRentType] ([NameAr]);
CREATE UNIQUE INDEX [tblRentType_NameEn_idx] ON [tblRentType] ([NameEn]);
CREATE INDEX [tblRentType_PeriodTypeCode_idx] ON [tblRentType] ([PeriodTypeCode]);
CREATE INDEX [tblReportType_ID_idx] ON [tblReportType] ([ID]);
CREATE UNIQUE INDEX [tblReportType_NameAr_idx] ON [tblReportType] ([NameAr]);
CREATE UNIQUE INDEX [tblReportType_NameEn_idx] ON [tblReportType] ([NameEn]);
CREATE INDEX [tblReportType_ReportTypeGroupID_idx] ON [tblReportType] ([ReportTypeGroupID]);
CREATE INDEX [tblReportTypeGroup_ID_idx] ON [tblReportTypeGroup] ([ID]);
CREATE INDEX [tblReportTypeGroup_ObjecTID_idx] ON [tblReportTypeGroup] ([ObjecTID]);
CREATE INDEX [tblReportTypeObject_ObjectID_idx] ON [tblReportTypeObject] ([ObjectID]);
CREATE INDEX [tblRequiredUnit_BranchID_idx] ON [tblRequiredUnit] ([BranchID]);
CREATE INDEX [tblRequiredUnit_HousingTypeID_idx] ON [tblRequiredUnit] ([HousingTypeID]);
CREATE INDEX [tblRequiredUnit_ID_idx] ON [tblRequiredUnit] ([ID]);
CREATE INDEX [tblRequiredUnit_IndependentBoard_idx] ON [tblRequiredUnit] ([IndependentBoard]);
CREATE INDEX [tblRequiredUnit_UnitStatusID_idx] ON [tblRequiredUnit] ([UnitStatusID]);
CREATE INDEX [tblRequiredUnit_UnitTypeID_idx] ON [tblRequiredUnit] ([UnitTypeID]);
CREATE INDEX [tblRequiredUnitQuarter_BranchID_idx] ON [tblRequiredUnitQuarter] ([BranchID]);
CREATE INDEX [tblRequiredUnitQuarter_ID_idx] ON [tblRequiredUnitQuarter] ([RequiredUnitID]);
CREATE INDEX [tblRequiredUnitQuarter_QuarterID_idx] ON [tblRequiredUnitQuarter] ([QuarterID]);
CREATE INDEX [tblReservation_BranchID_idx] ON [tblReservation] ([BranchID]);
CREATE INDEX [tblReservation_ConfirmationTypeID_idx] ON [tblReservation] ([ConfirmationTypeID]);
CREATE INDEX [tblReservation_CustomerID_idx] ON [tblReservation] ([CustomerID]);
CREATE INDEX [tblReservation_ID_idx] ON [tblReservation] ([ID]);
CREATE INDEX [tblReservation_RentTypeID_idx] ON [tblReservation] ([RentTypeID]);
CREATE INDEX [tblReservation_ReservationStatusID_idx] ON [tblReservation] ([ReservationStatusID]);
CREATE INDEX [tblReservation_ReservationTypeID_idx] ON [tblReservation] ([ReservationTypeID]);
CREATE INDEX [tblReservation_UnitID_idx] ON [tblReservation] ([UnitID]);
CREATE INDEX [tblReservation_UserID_idx] ON [tblReservation] ([UserID]);
CREATE INDEX [tblReservationStatus_FormID_idx] ON [tblReservationStatus] ([ID]);
CREATE UNIQUE INDEX [tblReservationStatus_NameAr_idx] ON [tblReservationStatus] ([NameAr]);
CREATE UNIQUE INDEX [tblReservationStatus_NameEn_idx] ON [tblReservationStatus] ([NameEn]);
CREATE UNIQUE INDEX [tblResthouse_RentLease_MoneyTransactionID_idx] ON [tblResthouse_RentLease] ([MoneyTransactionID]);
CREATE INDEX [tblResthouse_RentLease_tblResthouse_RentLeaseBranchID_idx] ON [tblResthouse_RentLease] ([BranchID]);
CREATE INDEX [tblResthouse_RentLease_tblResthouse_RentLeaseID_idx] ON [tblResthouse_RentLease] ([ID]);
CREATE INDEX [tblResthouse_RentLeaseCancellation_BranchID_idx] ON [tblResthouse_RentLeaseCancellation] ([BranchID]);
CREATE INDEX [tblResthouse_RentLeaseCancellation_ID_idx] ON [tblResthouse_RentLeaseCancellation] ([ResthouseRentLeaseID]);
CREATE UNIQUE INDEX [tblResthouse_RentLeaseCancellation_MoneyTransactionID_idx] ON [tblResthouse_RentLeaseCancellation] ([BranchID], [MoneyTransactionID]);
CREATE INDEX [tblRestHouse_RentLeaseRentGroup_BranchID_idx] ON [tblRestHouse_RentLeaseRentGroup] ([BranchID]);
CREATE INDEX [tblRestHouse_RentLeaseRentGroup_ID_idx] ON [tblRestHouse_RentLeaseRentGroup] ([ID]);
CREATE INDEX [tblRestHouse_RentLeaseRentGroup_RentDate_idx] ON [tblRestHouse_RentLeaseRentGroup] ([RentDate]);
CREATE INDEX [tblRestHouse_RentLeaseRentGroup_RentGroupID_idx] ON [tblRestHouse_RentLeaseRentGroup] ([RentGroupID]);
CREATE UNIQUE INDEX [tblRestHouse_RentLeaseRentGroup_SecandryKey_idx] ON [tblRestHouse_RentLeaseRentGroup] ([BranchID], [RestHouseRentLeaseID], [RentGroupID], [RentDate]);
CREATE INDEX [tblRestHouse_SeasonRentGroup_SeasonID_idx] ON [tblRestHouse_SeasonRentGroup] ([SeasonID]);
CREATE UNIQUE INDEX [tblRestHouse_SeasonRentGroup_SeasonNameAr_idx] ON [tblRestHouse_SeasonRentGroup] ([SeasonID], [NameAr]);
CREATE UNIQUE INDEX [tblRestHouse_SeasonRentGroup_SeasonNameEn_idx] ON [tblRestHouse_SeasonRentGroup] ([SeasonID], [NameEn]);
CREATE INDEX [tblRestHouse_SeasonRentGroupPeriod_FormID_idx] ON [tblRestHouse_SeasonRentGroupPeriod] ([RestHouseSeasonRentGroupID]);
CREATE INDEX [tblRestHouse_SeasonRentGroupPeriod_RestHousePeriodId_idx] ON [tblRestHouse_SeasonRentGroupPeriod] ([RestHouseRentPeriodID]);
CREATE INDEX [tblRestHouse_Setting_StudySeasonID_idx] ON [tblRestHouse_Setting] ([StudySeasonID]);
CREATE INDEX [tblRestHouse_Setting_StudySeasonID1_idx] ON [tblRestHouse_Setting] ([WeekendSeasonID]);
CREATE INDEX [tblRestHouseRentPeriod_FormID_idx] ON [tblRestHouseRentPeriod] ([ID]);
CREATE UNIQUE INDEX [tblRestHouseRentPeriod_NameAr_idx] ON [tblRestHouseRentPeriod] ([NameAr]);
CREATE UNIQUE INDEX [tblRestHouseRentPeriod_NameEn_idx] ON [tblRestHouseRentPeriod] ([NameEn]);
CREATE INDEX [tblSalary_EmployeeNo_idx] ON [tblSalary] ([AccountID]);
CREATE INDEX [tblSalary_LoanNo_idx] ON [tblSalary] ([LoanNo]);
CREATE UNIQUE INDEX [tblSalary_PolicyNo_idx] ON [tblSalary] ([PolicyNo]);
CREATE INDEX [tblSalary_SalaryMonth_idx] ON [tblSalary] ([SalaryMonth]);
CREATE INDEX [tblSalary_SalaryYear_idx] ON [tblSalary] ([SalaryYear]);
CREATE INDEX [tblSeasonPeriod_FormID_idx] ON [tblSeasonPeriod] ([ID]);
CREATE INDEX [tblSeasonPeriod_SeasonID_idx] ON [tblSeasonPeriod] ([SeasonID]);
CREATE INDEX [tblSeasonPeriodOLD_FormID_idx] ON [tblSeasonPeriodOLD] ([ID]);
CREATE UNIQUE INDEX [tblSeasonPeriodOLD_NameAr_idx] ON [tblSeasonPeriodOLD] ([NameAr]);
CREATE UNIQUE INDEX [tblSeasonPeriodOLD_NameEn_idx] ON [tblSeasonPeriodOLD] ([NameEn]);
CREATE UNIQUE INDEX [tblSeasonsOfficialWorking_ID_idx] ON [tblSeasonsOfficialWorking] ([ID]);
CREATE UNIQUE INDEX [tblSeasonsOfficialWorking_NameAr_idx] ON [tblSeasonsOfficialWorking] ([NameAr]);
CREATE UNIQUE INDEX [tblSeasonsOfficialWorking_NameEn_idx] ON [tblSeasonsOfficialWorking] ([NameEn]);
CREATE INDEX [tblSection_FormID_idx] ON [tblSection] ([ID]);
CREATE UNIQUE INDEX [tblSection_NameAr_idx] ON [tblSection] ([NameAr]);
CREATE UNIQUE INDEX [tblSection_NameEn_idx] ON [tblSection] ([NameEn]);
CREATE INDEX [tblShiftWorkPeriod_FormID_idx] ON [tblShiftWorkPeriod] ([ID]);
CREATE UNIQUE INDEX [tblShiftWorkPeriod_NameAr_idx] ON [tblShiftWorkPeriod] ([NameAr]);
CREATE UNIQUE INDEX [tblShiftWorkPeriod_NameEn_idx] ON [tblShiftWorkPeriod] ([NameEn]);
CREATE UNIQUE INDEX [tblSickenStatuse_PationCaseNo_idx] ON [tblSickenStatuse] ([ID]);
CREATE INDEX [tblSMSMessageAccountDocument_AccountDocumentID_idx] ON [tblSMSMessageAccountDocument] ([AccountDocumentID]);
CREATE INDEX [tblSMSMessageAccountDocument_ID_idx] ON [tblSMSMessageAccountDocument] ([ID]);
CREATE INDEX [tblSMSMessageAccountDocument_SMSMessageTypeID_idx] ON [tblSMSMessageAccountDocument] ([SMSMessageTypeID]);
CREATE INDEX [tblSMSMessageCompanyDocument_AccountDocumentID_idx] ON [tblSMSMessageCompanyDocument] ([CompanyDocumentID]);
CREATE INDEX [tblSMSMessageCompanyDocument_ID_idx] ON [tblSMSMessageCompanyDocument] ([ID]);
CREATE INDEX [tblSMSMessageCompanyDocument_SMSMessageTypeID_idx] ON [tblSMSMessageCompanyDocument] ([SMSMessageTypeID]);
CREATE INDEX [tblSMSMessageHistory_ID_idx] ON [tblSMSMessageHistory] ([ID]);
CREATE INDEX [tblSMSMessageHistory_MessageID_idx] ON [tblSMSMessageHistory] ([MessageID]);
CREATE INDEX [tblSMSMessageInstallment_BranchID_idx] ON [tblSMSMessageInstallment] ([BranchID]);
CREATE INDEX [tblSMSMessageInstallment_InstallmentID_idx] ON [tblSMSMessageInstallment] ([InstallmentID]);
CREATE UNIQUE INDEX [tblSMSMessageInstallment_InstallmentMessageTypeID_idx] ON [tblSMSMessageInstallment] ([BranchID], [InstallmentPlanID], [InstallmentID], [SMSMessageTypeID]);
CREATE INDEX [tblSMSMessageInstallment_InstallmentPlanID_idx] ON [tblSMSMessageInstallment] ([InstallmentPlanID]);
CREATE INDEX [tblSMSMessageInstallment_SMSMessageTypeID_idx] ON [tblSMSMessageInstallment] ([SMSMessageTypeID]);
CREATE INDEX [tblSMSMessageRecord_ID_idx] ON [tblSMSMessageRecord] ([ID]);
CREATE INDEX [tblSMSMessageRecord_NumbersList_idx] ON [tblSMSMessageRecord] ([NumbersList]);
CREATE INDEX [tblSMSMessageRentLeaseRenewal_AccountDocumentID_idx] ON [tblSMSMessageRentLeaseRenewal] ([RentLeaseRenewalID]);
CREATE INDEX [tblSMSMessageRentLeaseRenewal_BranchID_idx] ON [tblSMSMessageRentLeaseRenewal] ([BranchID]);
CREATE INDEX [tblSMSMessageRentLeaseRenewal_SMSMessageTypeID_idx] ON [tblSMSMessageRentLeaseRenewal] ([SMSMessageTypeID]);
CREATE INDEX [tblSMSProvider_FormID_idx] ON [tblSMSProvider] ([ID]);
CREATE UNIQUE INDEX [tblSMSProvider_NameAr_idx] ON [tblSMSProvider] ([NameAr]);
CREATE UNIQUE INDEX [tblSMSProvider_NameEn_idx] ON [tblSMSProvider] ([NameEn]);
CREATE INDEX [tblStage_FormID_idx] ON [tblStage] ([ID]);
CREATE UNIQUE INDEX [tblStage_NameAr_idx] ON [tblStage] ([NameAr]);
CREATE UNIQUE INDEX [tblStage_NameEn_idx] ON [tblStage] ([NameEn]);
CREATE INDEX [tblStopType_FormID_idx] ON [tblStopType] ([ID]);
CREATE UNIQUE INDEX [tblStopType_NameAr_idx] ON [tblStopType] ([NameAr]);
CREATE UNIQUE INDEX [tblStopType_NameEn_idx] ON [tblStopType] ([NameEn]);
CREATE INDEX [tblStoredItemBalance_ID_idx] ON [tblStoredItemBalance] ([ID]);
CREATE INDEX [tblStoreMovement_CreditorID_idx] ON [tblStoreMovement] ([StoreCreditorID]);
CREATE INDEX [tblStoreMovement_DebtorID_idx] ON [tblStoreMovement] ([StoreDebtorID]);
CREATE UNIQUE INDEX [tblStoreMovement_ID_idx] ON [tblStoreMovement] ([ID]);
CREATE INDEX [tblStudentAttendance_ApprovedCourseID_idx] ON [tblStudentAttendance] ([ApprovedCourseID]);
CREATE INDEX [tblStudentAttendance_ID_idx] ON [tblStudentAttendance] ([ID]);
CREATE INDEX [tblStudentAttendance_InputMeansID_idx] ON [tblStudentAttendance] ([InputMeansID]);
CREATE INDEX [tblStudentAttendance_PCID_idx] ON [tblStudentAttendance] ([PCID]);
CREATE INDEX [tblStudentAttendanceList_AttendanceCaseID_idx] ON [tblStudentAttendanceList] ([AttendanceCaseID]);
CREATE INDEX [tblStudentAttendanceList_StudentAccountID_idx] ON [tblStudentAttendanceList] ([StudentAccountID]);
CREATE INDEX [tblStudentAttendanceList_StudentAttendanceID_idx] ON [tblStudentAttendanceList] ([StudentAttendanceID]);
CREATE INDEX [tblStudentCourseProcedure_ApprovedCourseID_idx] ON [tblStudentCourseProcedure] ([ApprovedCourseID]);
CREATE INDEX [tblStudentCourseProcedure_ProcedureTypeID_idx] ON [tblStudentCourseProcedure] ([ProcedureTypeID]);
CREATE INDEX [tblStudentCourseProcedure_StudentAccountID_idx] ON [tblStudentCourseProcedure] ([StudentAccountID]);
CREATE INDEX [tblStudentFinalValuation_AccountID_idx] ON [tblStudentFinalValuation] ([StudentAccountID]);
CREATE INDEX [tblStudentFinalValuation_ApprovedCourseID_idx] ON [tblStudentFinalValuation] ([ApprovedCourseID]);
CREATE INDEX [tblStudentFinalValuation_ID_idx] ON [tblStudentFinalValuation] ([ID]);
CREATE INDEX [tblStudentFinalValuation_ValuationFormID_idx] ON [tblStudentFinalValuation] ([ValuationFormID]);
CREATE INDEX [tblStudentFinalValuationList_ID_idx] ON [tblStudentFinalValuationList] ([StudentFinalValuationID]);
CREATE INDEX [tblStudentFinalValuationList_MarkID_idx] ON [tblStudentFinalValuationList] ([MarkID]);
CREATE INDEX [tblStudentFinalValuationList_ValuationFormObjectID_idx] ON [tblStudentFinalValuationList] ([ValuationFormObjectID]);
CREATE INDEX [tblStudentFinanceRelatedData_AccountID_idx] ON [tblStudentFinanceRelatedData] ([AccountID]);
CREATE INDEX [tblStudentFinanceRelatedData_BuildingTypeID_idx] ON [tblStudentFinanceRelatedData] ([BuildingTypeID]);
CREATE INDEX [tblStudentFinanceRelatedData_CarColorID_idx] ON [tblStudentFinanceRelatedData] ([CarColorID]);
CREATE INDEX [tblStudentFinanceRelatedData_CarTypeID_idx] ON [tblStudentFinanceRelatedData] ([CarTypeID]);
CREATE INDEX [tblStudentFinanceRelatedData_HouseTypeID_idx] ON [tblStudentFinanceRelatedData] ([HouseTypeID]);
CREATE INDEX [tblStudentResult_FormID_idx] ON [tblStudentResult] ([ID]);
CREATE UNIQUE INDEX [tblStudentResult_NameAr_idx] ON [tblStudentResult] ([NameAr]);
CREATE UNIQUE INDEX [tblStudentResult_NameEn_idx] ON [tblStudentResult] ([NameEn]);
CREATE INDEX [tblStudentType_FormID_idx] ON [tblStudentType] ([ID]);
CREATE UNIQUE INDEX [tblStudentType_NameAr_idx] ON [tblStudentType] ([NameAr]);
CREATE UNIQUE INDEX [tblStudentType_NameEn_idx] ON [tblStudentType] ([NameEn]);
CREATE INDEX [tblStudentWeeklyValuation_ApprovedCourseID_idx] ON [tblStudentWeeklyValuation] ([ApprovedCourseID]);
CREATE INDEX [tblStudentWeeklyValuation_ID_idx] ON [tblStudentWeeklyValuation] ([ID]);
CREATE INDEX [tblStudyBook_FormID_idx] ON [tblStudyBook] ([ID]);
CREATE UNIQUE INDEX [tblStudyBook_NameAr_idx] ON [tblStudyBook] ([NameAr]);
CREATE UNIQUE INDEX [tblStudyBook_NameEn_idx] ON [tblStudyBook] ([NameEn]);
CREATE INDEX [tblStudyClass_FormID_idx] ON [tblStudyClass] ([ID]);
CREATE UNIQUE INDEX [tblStudyClass_NameAr_idx] ON [tblStudyClass] ([NameAr]);
CREATE UNIQUE INDEX [tblStudyClass_NameEn_idx] ON [tblStudyClass] ([NameEn]);
CREATE INDEX [tblStudyLevel_FormID_idx] ON [tblStudyLevel] ([ID]);
CREATE UNIQUE INDEX [tblStudyLevel_NameAr_idx] ON [tblStudyLevel] ([NameAr]);
CREATE UNIQUE INDEX [tblStudyLevel_NameEn_idx] ON [tblStudyLevel] ([NameEn]);
CREATE INDEX [tblStudyTermPeriod_FormID_idx] ON [tblStudyTermPeriod] ([ID]);
CREATE UNIQUE INDEX [tblStudyTermPeriod_NameAr_idx] ON [tblStudyTermPeriod] ([NameAr]);
CREATE UNIQUE INDEX [tblStudyTermPeriod_NameEn_idx] ON [tblStudyTermPeriod] ([NameEn]);
CREATE INDEX [tblStudyType_FormID_idx] ON [tblStudyType] ([ID]);
CREATE UNIQUE INDEX [tblStudyType_NameAr_idx] ON [tblStudyType] ([NameAr]);
CREATE UNIQUE INDEX [tblStudyType_NameEn_idx] ON [tblStudyType] ([NameEn]);
CREATE INDEX [tblStudyYear_FormID_idx] ON [tblStudyYear] ([ID]);
CREATE UNIQUE INDEX [tblStudyYear_NameAr_idx] ON [tblStudyYear] ([StartYearID]);
CREATE UNIQUE INDEX [tblStudyYear_NameEn_idx] ON [tblStudyYear] ([EndYearID]);
CREATE INDEX [tblSubscriptionCard_AccountID_idx] ON [tblSubscriptionCard] ([AccountID]);
CREATE INDEX [tblSubscriptionCard_CardClassID_idx] ON [tblSubscriptionCard] ([CardClassID]);
CREATE INDEX [tblSubscriptionCard_CardCode_idx] ON [tblSubscriptionCard] ([CardCode]);
CREATE INDEX [tblSubscriptionCard_ID_idx] ON [tblSubscriptionCard] ([ID]);
CREATE INDEX [tblTeacherFinalValuation_ID_idx] ON [tblTeacherFinalValuation] ([ID]);
CREATE INDEX [tblTeacherFinalValuation_StudyYearID_idx] ON [tblTeacherFinalValuation] ([StudyYearID]);
CREATE INDEX [tblTeacherFinalValuation_TeacherAccountID_idx] ON [tblTeacherFinalValuation] ([TeacherAccountID]);
CREATE INDEX [tblTeacherFinalValuation_TermID_idx] ON [tblTeacherFinalValuation] ([TermID]);
CREATE INDEX [tblTeacherFinalValuation_ValuationFormID_idx] ON [tblTeacherFinalValuation] ([ValuationFormID]);
CREATE INDEX [tblTeacherFinalValuationList_ID_idx] ON [tblTeacherFinalValuationList] ([TeacherFinalValuationID]);
CREATE INDEX [tblTeacherFinalValuationList_MarkID_idx] ON [tblTeacherFinalValuationList] ([MarkID]);
CREATE INDEX [tblTeacherFinalValuationList_ValuationFormObjectID_idx] ON [tblTeacherFinalValuationList] ([ValuationFormObjectID]);
CREATE INDEX [tblTeacherProcedure_ApprovedCourseID_idx] ON [tblTeacherProcedure] ([ApprovedCourseID]);
CREATE INDEX [tblTeacherProcedure_ID_idx] ON [tblTeacherProcedure] ([ID]);
CREATE INDEX [tblTeacherProcedure_StudyTypeID_idx] ON [tblTeacherProcedure] ([StudyTypeID]);
CREATE INDEX [tblTeacherProcedure_StudyYearID_idx] ON [tblTeacherProcedure] ([StudyYearID]);
CREATE INDEX [tblTeacherProcedure_TeacherAccountID_idx] ON [tblTeacherProcedure] ([TeacherAccountID]);
CREATE INDEX [tblTeacherProcedure_TeacherProcedureID_idx] ON [tblTeacherProcedure] ([MeetDate]);
CREATE INDEX [tblTeacherProcedure_TeacherProcedureID1_idx] ON [tblTeacherProcedure] ([TeacherProcedureID]);
CREATE INDEX [tblTeacherProcedure_TeacherProcedureSubjectID_idx] ON [tblTeacherProcedure] ([TeacherProcedureSubjectID]);
CREATE INDEX [tblTeacherProcedure_TermID_idx] ON [tblTeacherProcedure] ([TermID]);
CREATE INDEX [tblTeacherProcedureSubject_DocumentTypeID_idx] ON [tblTeacherProcedureSubject] ([ID]);
CREATE UNIQUE INDEX [tblTeacherProcedureSubject_NameAr_idx] ON [tblTeacherProcedureSubject] ([NameAr]);
CREATE UNIQUE INDEX [tblTeacherProcedureSubject_NameEn_idx] ON [tblTeacherProcedureSubject] ([NameEn]);
CREATE INDEX [tblTeacherProcedureType_DocumentTypeID_idx] ON [tblTeacherProcedureType] ([ID]);
CREATE UNIQUE INDEX [tblTeacherProcedureType_NameAr_idx] ON [tblTeacherProcedureType] ([NameAr]);
CREATE UNIQUE INDEX [tblTeacherProcedureType_NameEn_idx] ON [tblTeacherProcedureType] ([NameEn]);
CREATE INDEX [tblTeacherValuationByStudent_AccountID_idx] ON [tblTeacherValuationByStudent] ([StudentAccountID]);
CREATE INDEX [tblTeacherValuationByStudent_ApprovedCourseID_idx] ON [tblTeacherValuationByStudent] ([ApprovedCourseID]);
CREATE INDEX [tblTeacherValuationByStudent_ID_idx] ON [tblTeacherValuationByStudent] ([ID]);
CREATE INDEX [tblTeacherValuationByStudent_ValuationFormID_idx] ON [tblTeacherValuationByStudent] ([ValuationFormID]);
CREATE INDEX [tblTeacherValuationByStudentList_ID_idx] ON [tblTeacherValuationByStudentList] ([TeacherValuationByStudentID]);
CREATE INDEX [tblTeacherValuationByStudentList_MarkID_idx] ON [tblTeacherValuationByStudentList] ([MarkID]);
CREATE INDEX [tblTeacherValuationByStudentList_ValuationFormObjectID_idx] ON [tblTeacherValuationByStudentList] ([ValuationFormObjectID]);
CREATE INDEX [tblTeacherValuationRecordList_ID_idx] ON [tblTeacherValuationRecordList] ([TeacherValuationRecordID]);
CREATE INDEX [tblTeacherValuationRecordList_MarkID_idx] ON [tblTeacherValuationRecordList] ([MarkID]);
CREATE INDEX [tblTeacherValuationRecordList_ValuationFormObjectID_idx] ON [tblTeacherValuationRecordList] ([ValuationFormObjectID]);
CREATE INDEX [tblTeacherVisitNo_FormID_idx] ON [tblTeacherVisitNo] ([ID]);
CREATE UNIQUE INDEX [tblTeacherVisitNo_NameAr_idx] ON [tblTeacherVisitNo] ([NameAr]);
CREATE UNIQUE INDEX [tblTeacherVisitNo_NameEn_idx] ON [tblTeacherVisitNo] ([NameEn]);
CREATE INDEX [tblTeamGroup_GroupForemanAccountID_idx] ON [tblTeamGroup] ([GroupForemanAccountID]);
CREATE INDEX [tblTeamGroup_GroupStatusID_idx] ON [tblTeamGroup] ([GroupStatusID]);
CREATE UNIQUE INDEX [tblTeamGroup_NameAr_idx] ON [tblTeamGroup] ([NameAr]);
CREATE UNIQUE INDEX [tblTeamGroup_NameEn_idx] ON [tblTeamGroup] ([NameEn]);
CREATE UNIQUE INDEX [tblTeamGroupMember_MemberAccountID_idx] ON [tblTeamGroupMember] ([TeamGroupID], [MemberAccountID], [StartDate]);
CREATE INDEX [tblTeamGroupMember_StatusID_idx] ON [tblTeamGroupMember] ([StatusID]);
CREATE INDEX [tblTerm_FormID_idx] ON [tblTerm] ([ID]);
CREATE UNIQUE INDEX [tblTerm_NameAr_idx] ON [tblTerm] ([NameAr]);
CREATE UNIQUE INDEX [tblTerm_NameEn_idx] ON [tblTerm] ([NameEn]);
CREATE INDEX [tblTimeHalf_ID_idx] ON [tblTimeHalf] ([ID]);
CREATE INDEX [tblTimeHour_ID_idx] ON [tblTimeHour] ([ID]);
CREATE INDEX [tblTitle_ID_idx] ON [tblTitle] ([ID]);
CREATE INDEX [tblTransactionHistory_FormID_idx] ON [tblTransactionHistory] ([ObjectID]);
CREATE INDEX [tblTransactionHistory_OperationID_idx] ON [tblTransactionHistory] ([ID]);
CREATE INDEX [tblTransactionHistory_PCID_idx] ON [tblTransactionHistory] ([PCID]);
CREATE INDEX [tblTransactionHistory_RecordID_idx] ON [tblTransactionHistory] ([RecordID]);
CREATE INDEX [tblTransactionHistory_TransactionTypeID_idx] ON [tblTransactionHistory] ([TransactionTypeID]);
CREATE INDEX [tblTransactionHistory_UserID_idx] ON [tblTransactionHistory] ([UserID]);
CREATE UNIQUE INDEX [tblTransactionType_ID_idx] ON [tblTransactionType] ([ID]);
CREATE INDEX [tblUnitActionType_FormID_idx] ON [tblUnitActionType] ([ID]);
CREATE UNIQUE INDEX [tblUnitActionType_NameAr_idx] ON [tblUnitActionType] ([NameAr]);
CREATE UNIQUE INDEX [tblUnitActionType_NameEn_idx] ON [tblUnitActionType] ([NameEn]);
CREATE INDEX [tblUnitExpense_BranchID_idx] ON [tblUnitExpense] ([BranchID]);
CREATE INDEX [tblUnitExpense_ExpenseTypeID_idx] ON [tblUnitExpense] ([ExpenseTypeID]);
CREATE INDEX [tblUnitExpense_ID_idx] ON [tblUnitExpense] ([ID]);
CREATE INDEX [tblUnitExpense_StaffID_idx] ON [tblUnitExpense] ([StaffID]);
CREATE INDEX [tblUnitExpense_UnitID_idx] ON [tblUnitExpense] ([UnitID]);
CREATE INDEX [tblUnitStatus_FormID_idx] ON [tblUnitStatus] ([ID]);
CREATE UNIQUE INDEX [tblUnitStatus_NameAr_idx] ON [tblUnitStatus] ([NameAr]);
CREATE UNIQUE INDEX [tblUnitStatus_NameEn_idx] ON [tblUnitStatus] ([NameEn]);
CREATE INDEX [tblUnitTypeCondition_FormID_idx] ON [tblUnitTypeCondition] ([ID]);
CREATE UNIQUE INDEX [tblUnitTypeCondition_NameAr_idx] ON [tblUnitTypeCondition] ([ConditionAr]);
CREATE UNIQUE INDEX [tblUnitTypeCondition_NameAr1_idx] ON [tblUnitTypeCondition] ([NameAr]);
CREATE UNIQUE INDEX [tblUnitTypeCondition_NameEn_idx] ON [tblUnitTypeCondition] ([ConditionEn]);
CREATE UNIQUE INDEX [tblUnitTypeCondition_NameEn1_idx] ON [tblUnitTypeCondition] ([NameEn]);
CREATE UNIQUE INDEX [tblUser_ID_idx] ON [tblUser] ([ID]);
CREATE INDEX [tblUser_Login_idx] ON [tblUser] ([CurrentStatusID]);
CREATE INDEX [tblUser_Stopped_idx] ON [tblUser] ([Stopped]);
CREATE INDEX [tblUser_UserTypeID_idx] ON [tblUser] ([UserGroupID]);
CREATE INDEX [tblUserAccountType_AccountID_idx] ON [tblUserAccountType] ([AccountTypeID]);
CREATE INDEX [tblUserAccountType_UserID_idx] ON [tblUserAccountType] ([UserID]);
CREATE INDEX [tblUserGroup_FormID_idx] ON [tblUserGroup] ([ID]);
CREATE INDEX [tblUserMoneyAccount_AccountID_idx] ON [tblUserMoneyAccount] ([AccountID]);
CREATE INDEX [tblUserMoneyAccount_UserID_idx] ON [tblUserMoneyAccount] ([UserID]);
CREATE INDEX [tblUserReceiptSubject_AccountID_idx] ON [tblUserReceiptSubject] ([ReceiptSubjectID]);
CREATE INDEX [tblUserReceiptSubject_UserID_idx] ON [tblUserReceiptSubject] ([UserID]);
CREATE INDEX [tblUserSetting_CodeID_idx] ON [tblUserSetting] ([CodeID]);
CREATE UNIQUE INDEX [tblUserSetting_FormID_idx] ON [tblUserSetting] ([UserID]);
CREATE INDEX [tblUserSetting_QuickInvoiceCreditorID_idx] ON [tblUserSetting] ([QuickInvoiceCreditorID]);
CREATE INDEX [tblUserSetting_QuickInvoiceCreditorID1_idx] ON [tblUserSetting] ([QuickInvoiceDebtorID]);
CREATE INDEX [tblUserSetting_QuickInvoiceDebtorID_idx] ON [tblUserSetting] ([QuickInvoiceStoreCreditorID]);
CREATE INDEX [tblUserSetting_QuickInvoiceDebtorID1_idx] ON [tblUserSetting] ([QuickInvoiceStoreDebtorID]);
CREATE INDEX [tblUserSetting_QuickInvoiceTypeID_idx] ON [tblUserSetting] ([QuickInvoiceTypeID]);
CREATE INDEX [tblUserStatus_FormID_idx] ON [tblUserStatus] ([ID]);
CREATE INDEX [tblUseType_FormID_idx] ON [tblUseType] ([ID]);
CREATE UNIQUE INDEX [tblUseType_NameAr_idx] ON [tblUseType] ([NameAr]);
CREATE UNIQUE INDEX [tblUseType_NameEn_idx] ON [tblUseType] ([NameEn]);
CREATE INDEX [tblValuationForm_FormID_idx] ON [tblValuationForm] ([ID]);
CREATE UNIQUE INDEX [tblValuationForm_NameAr_idx] ON [tblValuationForm] ([NameAr]);
CREATE UNIQUE INDEX [tblValuationForm_NameEn_idx] ON [tblValuationForm] ([NameEn]);
CREATE INDEX [tblValuationForm_ValuationPersonTypeID_idx] ON [tblValuationForm] ([ValuationPersonTypeID]);
CREATE INDEX [tblValuationFormGroup_FormID_idx] ON [tblValuationFormGroup] ([ID]);
CREATE UNIQUE INDEX [tblValuationFormGroup_NameAr_idx] ON [tblValuationFormGroup] ([NameAr]);
CREATE UNIQUE INDEX [tblValuationFormGroup_NameEn_idx] ON [tblValuationFormGroup] ([NameEn]);
CREATE INDEX [tblValuationFormGroup_ValuationFormID_idx] ON [tblValuationFormGroup] ([ValuationFormID]);
CREATE UNIQUE INDEX [tblWeek_DayNo_idx] ON [tblWeek] ([ID]);
CREATE UNIQUE INDEX [tblWeekDay_DayNo_idx] ON [tblWeekDay] ([ID]);
CREATE INDEX [tblWeekDay_SystemID_idx] ON [tblWeekDay] ([WeekDayID]);
CREATE INDEX [tblWorkerRentContract_ContractDay_idx] ON [tblWorkerRentContract] ([ContractDay]);
CREATE INDEX [tblWorkerRentContract_CustomerNo_idx] ON [tblWorkerRentContract] ([CustomerID]);
CREATE INDEX [tblWorkerRentContract_FEmployeeNo_idx] ON [tblWorkerRentContract] ([FirstSideID]);
CREATE INDEX [tblWorkerRentContract_FEmployeeNo1_idx] ON [tblWorkerRentContract] ([UPdatedByID]);
CREATE INDEX [tblWorkerRentContractEmployee_ContractNo_idx] ON [tblWorkerRentContractEmployee] ([ContractNo]);
CREATE INDEX [tblWorkerRentContractEmployee_EmployeeNo_idx] ON [tblWorkerRentContractEmployee] ([AccountID]);
CREATE INDEX [tmbNotUsedMoneyTransaction_ID_idx] ON [tmbNotUsedMoneyTransaction] ([ID]);
CREATE INDEX [tmpLastRentLeaseRenewal_BranchID_idx] ON [tmpLastRentLeaseRenewal] ([BranchID]);
CREATE INDEX [tmpLastRentLeaseRenewal_LeaseID_idx] ON [tmpLastRentLeaseRenewal] ([LeaseID]);
CREATE INDEX [ss_ID_idx] ON [ss] ([ID]);
CREATE INDEX [tblAccountDiscount_AccountID_idx] ON [tblAccountDiscount] ([AccountID]);
CREATE INDEX [tblAccountDiscount_ID_idx] ON [tblAccountDiscount] ([ID]);
CREATE INDEX [tblAccountRegistrationStatus_AccountID_idx] ON [tblAccountRegistrationStatus] ([AccountID]);
CREATE INDEX [tblAccountRegistrationStatus_ExperienceTypeID_idx] ON [tblAccountRegistrationStatus] ([RegistrationStatusID]);
CREATE INDEX [tblAccountRegistrationStatus_StopTypeID_idx] ON [tblAccountRegistrationStatus] ([StopTypeID]);
CREATE INDEX [tblAuthorityReportTypeFillterationBy_AuthorityReportTypeID_idx] ON [tblAuthorityReportTypeFillterationBy] ([AuthorityReportTypeID]);
CREATE INDEX [tblAuthorityReportTypeFillterationBy_ItemFiltrationBy_idx] ON [tblAuthorityReportTypeFillterationBy] ([ItemFiltrationBy]);
CREATE INDEX [tblCalendar_tblCalendarID_idx] ON [tblCalendar] ([ID]);
CREATE UNIQUE INDEX [tblCalendar_TheDate_idx] ON [tblCalendar] ([TheDate]);
CREATE INDEX [tblClassRoom_FormID_idx] ON [tblClassRoom] ([ID]);
CREATE UNIQUE INDEX [tblClassRoom_NameAr_idx] ON [tblClassRoom] ([NameAr]);
CREATE UNIQUE INDEX [tblClassRoom_NameEn_idx] ON [tblClassRoom] ([NameEn]);
CREATE INDEX [tblColor_ColorCode_idx] ON [tblColor] ([ColorCode]);
CREATE INDEX [tblColor_FormID_idx] ON [tblColor] ([ID]);
CREATE UNIQUE INDEX [tblColor_NameAr_idx] ON [tblColor] ([NameAr]);
CREATE UNIQUE INDEX [tblColor_NameEn_idx] ON [tblColor] ([NameEn]);
CREATE UNIQUE INDEX [tblContractInstalllment_ContractStageID_idx] ON [tblContractInstalllment] ([ContractID], [StageID]);
CREATE INDEX [tblContractInstalllment_ID_idx] ON [tblContractInstalllment] ([ContractID]);
CREATE INDEX [tblContractInstalllment_StageID_idx] ON [tblContractInstalllment] ([StageID]);
CREATE INDEX [tblCurrency_FormID_idx] ON [tblCurrency] ([ID]);
CREATE UNIQUE INDEX [tblCurrency_NameAr_idx] ON [tblCurrency] ([NameAr]);
CREATE UNIQUE INDEX [tblCurrency_NameEn_idx] ON [tblCurrency] ([NameEn]);
CREATE INDEX [tblCustomerWashingSpecifications_AccointID_idx] ON [tblCustomerWashingSpecifications] ([AccountID]);
CREATE INDEX [tblCustomerWashingSpecifications_BluingTypeID_idx] ON [tblCustomerWashingSpecifications] ([MerzamTypeID]);
CREATE INDEX [tblCustomerWashingSpecifications_StarchTypeID_idx] ON [tblCustomerWashingSpecifications] ([StarchTypeID]);
CREATE INDEX [tblCustomerWashingSpecifications_StarchTypeID1_idx] ON [tblCustomerWashingSpecifications] ([BluingTypeID]);
CREATE INDEX [tblCustomerWashingSpecifications_tblInvoiceItemDataForLaundryID_idx] ON [tblCustomerWashingSpecifications] ([ItemID]);
CREATE INDEX [tblExamLateStudent_ExamPeriodID_idx] ON [tblExamLateStudent] ([ExamPeriodID]);
CREATE INDEX [tblExamLateStudent_ExamTypeID_idx] ON [tblExamLateStudent] ([ExamTypeID]);
CREATE INDEX [tblExamLateStudent_ID_idx] ON [tblExamLateStudent] ([ID]);
CREATE INDEX [tblExamLateStudent_WeekDayID_idx] ON [tblExamLateStudent] ([WeekDayID]);
CREATE INDEX [tblHouseType_FormID_idx] ON [tblHouseType] ([ID]);
CREATE UNIQUE INDEX [tblHouseType_NameAr_idx] ON [tblHouseType] ([NameAr]);
CREATE UNIQUE INDEX [tblHouseType_NameEn_idx] ON [tblHouseType] ([NameEn]);
CREATE INDEX [tblInstallmentPlanType_CreditorAccountID_idx] ON [tblInstallmentPlanType] ([DebtorAccountID]);
CREATE INDEX [tblInstallmentPlanType_CreditorAccountTypeID_idx] ON [tblInstallmentPlanType] ([CreditorAccountTypeID]);
CREATE INDEX [tblInstallmentPlanType_CreditorAccountTypeID1_idx] ON [tblInstallmentPlanType] ([CreditorAccountID]);
CREATE INDEX [tblInstallmentPlanType_DebtorAccountTypeID_idx] ON [tblInstallmentPlanType] ([DebtorAccountTypeID]);
CREATE INDEX [tblInstallmentPlanType_FormID_idx] ON [tblInstallmentPlanType] ([ID]);
CREATE UNIQUE INDEX [tblInstallmentPlanType_NameAr_idx] ON [tblInstallmentPlanType] ([NameAr]);
CREATE UNIQUE INDEX [tblInstallmentPlanType_NameEn_idx] ON [tblInstallmentPlanType] ([NameEn]);
CREATE INDEX [tblInvoiceItem_InvoiceID_idx] ON [tblInvoiceItem] ([InvoiceID]);
CREATE INDEX [tblInvoiceItem_ItemID_idx] ON [tblInvoiceItem] ([ItemID]);
CREATE INDEX [tblInvoiceNoteType_FormID_idx] ON [tblInvoiceNoteType] ([ID]);
CREATE UNIQUE INDEX [tblInvoiceNoteType_NameAr_idx] ON [tblInvoiceNoteType] ([NameAr]);
CREATE UNIQUE INDEX [tblInvoiceNoteType_NameEn_idx] ON [tblInvoiceNoteType] ([NameEn]);
CREATE INDEX [tblItemSize_FormID_idx] ON [tblItemSize] ([ID]);
CREATE UNIQUE INDEX [tblItemSize_NameAr_idx] ON [tblItemSize] ([NameAr]);
CREATE UNIQUE INDEX [tblItemSize_NameEn_idx] ON [tblItemSize] ([NameEn]);
CREATE INDEX [tblManagementLease_BranchID_idx] ON [tblManagementLease] ([BranchID]);
CREATE INDEX [tblManagementLease_ID_idx] ON [tblManagementLease] ([ID]);
CREATE INDEX [tblManagementLease_OwnerID_idx] ON [tblManagementLease] ([OwnerID]);
CREATE INDEX [tblManagementLease_PaymentMethodID_idx] ON [tblManagementLease] ([PaymentMethodID]);
CREATE INDEX [tblManagementLease_RealEstateID_idx] ON [tblManagementLease] ([RealEstateID]);
CREATE INDEX [tblMoneyTransactionMethod_FormID_idx] ON [tblMoneyTransactionMethod] ([ID]);
CREATE INDEX [tblMoneyTransactionMethod_MoneyAccountTypeID_idx] ON [tblMoneyTransactionMethod] ([AccountTypeID]);
CREATE INDEX [tblOrderExecution_ID_idx] ON [tblOrderExecution] ([ID]);
CREATE INDEX [tblOrderExecution_ImplementationStatusID_idx] ON [tblOrderExecution] ([ID1]);
CREATE INDEX [tblOrderExecution_InvoiceID_idx] ON [tblOrderExecution] ([InvoiceID]);
CREATE UNIQUE INDEX [tblOrderExecution_MoneyTransactionID_idx] ON [tblOrderExecution] ([MoneyTransactionID]);
CREATE INDEX [tblOrderExecution_PCID_idx] ON [tblOrderExecution] ([PCID]);
CREATE INDEX [tblOrderExecution_StatusID_idx] ON [tblOrderExecution] ([ExecutionStatusID]);
CREATE INDEX [tblOrderExecution_TeamGroupID_idx] ON [tblOrderExecution] ([TeamGroupID]);
CREATE INDEX [tblOrderExecution_UserID_idx] ON [tblOrderExecution] ([UserID]);
CREATE INDEX [tblPC_BranchID_idx] ON [tblPC] ([BranchID]);
CREATE INDEX [tblPC_FormID_idx] ON [tblPC] ([ID]);
CREATE UNIQUE INDEX [tblPC_NameAr_idx] ON [tblPC] ([NameAr]);
CREATE UNIQUE INDEX [tblPC_NameEn_idx] ON [tblPC] ([NameEn]);
CREATE INDEX [tblPlace_CityID_idx] ON [tblPlace] ([CityID]);
CREATE UNIQUE INDEX [tblPlace_ID_idx] ON [tblPlace] ([ID]);
CREATE UNIQUE INDEX [tblPlace_NameAr_idx] ON [tblPlace] ([NameAr]);
CREATE INDEX [tblProgramUseTypeBasicDataTable_BasicDataTableID_idx] ON [tblProgramUseTypeBasicDataTable] ([BasicDataTableID]);
CREATE INDEX [tblProgramUseTypeBasicDataTable_ProgramID_idx] ON [tblProgramUseTypeBasicDataTable] ([ProgramUseTypeID]);
CREATE INDEX [tblReceipt_AccountID_idx] ON [tblReceipt] ([CreditorID]);
CREATE INDEX [tblReceipt_CodeID_idx] ON [tblReceipt] ([CodeID]);
CREATE INDEX [tblReceipt_DebtorID_idx] ON [tblReceipt] ([DebtorID]);
CREATE INDEX [tblReceipt_DescriptionID_idx] ON [tblReceipt] ([ReceiptSubjectID]);
CREATE INDEX [tblReceipt_HandlyReceiptCode_idx] ON [tblReceipt] ([HandlyReceiptCode]);
CREATE INDEX [tblReceipt_ID_idx] ON [tblReceipt] ([ReceiptTypeID]);
CREATE UNIQUE INDEX [tblReceipt_ID2_idx] ON [tblReceipt] ([ID]);
CREATE INDEX [tblReceipt_MoneyTransactionID_idx] ON [tblReceipt] ([MoneyTransactionID]);
CREATE INDEX [tblReceipt_MoneyTransactionMethodID_idx] ON [tblReceipt] ([MoneyTransactionMethodID]);
CREATE INDEX [tblReceipt_PCID_idx] ON [tblReceipt] ([PCID]);
CREATE INDEX [tblReceipt_UserID_idx] ON [tblReceipt] ([UserID]);
CREATE INDEX [tblReceiptSubject_DebitAccountTypeID1_idx] ON [tblReceiptSubject] ([AccountTypeID]);
CREATE INDEX [tblReceiptSubject_ID_idx] ON [tblReceiptSubject] ([ID]);
CREATE UNIQUE INDEX [tblReligion_ReligionName_idx] ON [tblReligion] ([NameAr]);
CREATE UNIQUE INDEX [tblReligion_ReligionName1_idx] ON [tblReligion] ([NameEn]);
CREATE INDEX [tblRentLeaseRentGroupService_BranchID_idx] ON [tblRentLeaseRentGroupService] ([BranchID]);
CREATE INDEX [tblRentLeaseRentGroupService_RentLeaseRentGroupID_idx] ON [tblRentLeaseRentGroupService] ([RentLeaseRentGroupID]);
CREATE INDEX [tblRentLeaseRentGroupService_ServiceTypeID_idx] ON [tblRentLeaseRentGroupService] ([ServiceTypeID]);
CREATE INDEX [tblResthouse_RentedOut_BranchID_idx] ON [tblResthouse_RentedOut] ([BranchID]);
CREATE INDEX [tblResthouse_RentedOut_ID_idx] ON [tblResthouse_RentedOut] ([ResthouseRentLeaseID]);
CREATE UNIQUE INDEX [tblResthouse_RentedOut_MoneyTransactionID_idx] ON [tblResthouse_RentedOut] ([BranchID], [MoneyTransactionID]);
CREATE INDEX [tblRestHouse_UserGroupSetting_UserGroupID_idx] ON [tblRestHouse_UserGroupSetting] ([UserGroupID]);
CREATE INDEX [tblSMSMessageRentLeaseRentGroup_BranchID_idx] ON [tblSMSMessageRentLeaseRentGroup] ([BranchID]);
CREATE INDEX [tblSMSMessageRentLeaseRentGroup_RentLeaseRentGroupID_idx] ON [tblSMSMessageRentLeaseRentGroup] ([RentLeaseRentGroupID]);
CREATE UNIQUE INDEX [tblSMSMessageRentLeaseRentGroup_RentLeaseRentGroupMessageTypeID_idx] ON [tblSMSMessageRentLeaseRentGroup] ([BranchID], [RentLeaseRentGroupID], [SMSMessageTypeID]);
CREATE INDEX [tblSMSMessageRentLeaseRentGroup_SMSMessageTypeID_idx] ON [tblSMSMessageRentLeaseRentGroup] ([SMSMessageTypeID]);
CREATE INDEX [tblSpecialization_FormID_idx] ON [tblSpecialization] ([ID]);
CREATE UNIQUE INDEX [tblSpecialization_NameAr_idx] ON [tblSpecialization] ([NameAr]);
CREATE UNIQUE INDEX [tblSpecialization_NameEn_idx] ON [tblSpecialization] ([NameEn]);
CREATE INDEX [tblStudentCourse_ApprovedCourseID_idx] ON [tblStudentCourse] ([ApprovedCourseID]);
CREATE INDEX [tblStudentCourse_StudentAccountID_idx] ON [tblStudentCourse] ([StudentAccountID]);
CREATE INDEX [tblStudentWeeklyValuationList_ApprovedCourseID_idx] ON [tblStudentWeeklyValuationList] ([StudentWeeklyValuationID]);
CREATE INDEX [tblStudentWeeklyValuationList_StudentAccountID_idx] ON [tblStudentWeeklyValuationList] ([StudentAccountID]);
CREATE INDEX [tblTeacherValuationRecord_ID_idx] ON [tblTeacherValuationRecord] ([ID]);
CREATE INDEX [tblTeacherValuationRecord_StudyYearID_idx] ON [tblTeacherValuationRecord] ([StudyYearID]);
CREATE INDEX [tblTeacherValuationRecord_TeacherAccountID_idx] ON [tblTeacherValuationRecord] ([TeacherAccountID]);
CREATE INDEX [tblTeacherValuationRecord_TeacherVisitID_idx] ON [tblTeacherValuationRecord] ([TeacherVisitID]);
CREATE INDEX [tblTeacherValuationRecord_TermID_idx] ON [tblTeacherValuationRecord] ([TermID]);
CREATE INDEX [tblTeacherValuationRecord_ValuationFormID_idx] ON [tblTeacherValuationRecord] ([ValuationFormID]);
CREATE UNIQUE INDEX [tblTeacherValuationRecord_YearlyVisit_idx] ON [tblTeacherValuationRecord] ([TeacherAccountID], [StudyYearID], [TeacherVisitID]);
CREATE INDEX [tblTimeQuarter_ID_idx] ON [tblTimeQuarter] ([ID]);
CREATE INDEX [tblUnitType_FormID_idx] ON [tblUnitType] ([ID]);
CREATE UNIQUE INDEX [tblUnitType_NameAr_idx] ON [tblUnitType] ([NameAr]);
CREATE UNIQUE INDEX [tblUnitType_NameEn_idx] ON [tblUnitType] ([NameEn]);
CREATE INDEX [tblUnitType_UnitTypeConditionID_idx] ON [tblUnitType] ([UnitTypeConditionID]);
CREATE INDEX [tblUserGroupAccount_AccountID_idx] ON [tblUserGroupAccount] ([AccountID]);
CREATE INDEX [tblUserGroupAccount_UserID_idx] ON [tblUserGroupAccount] ([UserGroupID]);
CREATE INDEX [tblValuationPersonType_FormID_idx] ON [tblValuationPersonType] ([ID]);
CREATE UNIQUE INDEX [tblValuationPersonType_NameAr_idx] ON [tblValuationPersonType] ([NameAr]);
CREATE UNIQUE INDEX [tblValuationPersonType_NameEn_idx] ON [tblValuationPersonType] ([NameEn]);
CREATE INDEX [tblYear_FormID_idx] ON [tblYear] ([YearID]);
