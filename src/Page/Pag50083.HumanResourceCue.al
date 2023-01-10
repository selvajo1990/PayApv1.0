page 50083 "Human Resource Cue"
{
    PageType = CardPart;
    SourceTable = "Human Resource Cue";
    RefreshOnActivate = true;
    ShowFilter = false;
    Caption = ' ';
    layout
    {
        area(Content)
        {
            cuegroup("EmployeeInfo")
            {
                Caption = 'Employee Information';
                field("Total Employees"; Rec."Total Employees")
                {
                    ApplicationArea = All;
                    Image = People;
                    DrillDownPageId = "Employee List";
                    ToolTip = 'Specifies the value of the Total Employees';
                }
                field("New Joiners"; "New Joiners")
                {
                    ApplicationArea = All;
                    Image = People;
                    DrillDownPageId = "Employee List";
                    ToolTip = 'Specifies the value of the New Joiners';
                    trigger OnDrillDown()
                    begin
                        Page.RunModal(Page::"Employee List", TempEmployee3)
                    end;
                }
                field("Active Employees"; Rec."Active Employees")
                {
                    ApplicationArea = All;
                    Image = People;
                    DrillDownPageId = "Employee List";
                    ToolTip = 'Specifies the value of the Active Employees';
                }
                field("Leave Request"; Rec."Leave Request")
                {
                    Caption = 'Pending Leave Request';
                    ToolTip = 'Pending Leave Request';
                    Image = Library;
                    ApplicationArea = All;
                    DrillDownPageId = "Leave Request List";
                }
                field("End of Service"; Rec."End of Service")
                {
                    Caption = 'End of Service';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End of Service';
                    trigger OnDrillDown()
                    begin
                        Page.RunModal(Page::"End of Service List", EndOfService);
                    end;
                }
                field("Document Expiry"; Rec."Document Expiry")
                {
                    Caption = 'Document Expiry';
                    Image = Document;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Expiry';
                    trigger OnDrillDown()
                    begin
                        Page.RunModal(Page::"Document Expiry List", TempEmployeeLevelIdentificationG);
                    end;
                }
                field("Employee Birthday"; Rec."Employee Birthday")
                {
                    Caption = 'Birthday';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Birthday';
                    trigger OnDrillDown()
                    begin
                        Page.RunModal(Page::"Employee List", TempEmployee);
                    end;
                }
                field("Employee Anniversary"; Rec."Employee Anniversary")
                {
                    Caption = 'Anniversary';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Anniversary';
                    trigger OnDrillDown()
                    begin
                        Page.RunModal(Page::"Employee List", TempEmployee2);
                    end;
                }
            }
            // cuegroup(Recruitment) // Start #15 - 12/05/2019 - 103
            // {
            //     Caption = 'Recruitment';
            //     field("Total Applicants"; Rec."Total Applicants")
            //     {
            //         Caption = 'Total Applicants';
            //         ApplicationArea = All;
            //         Image = People;
            //         DrillDownPageId = "Applicant";
            //         ToolTip = 'Specifies the value of the Total Applicants';
            //     }
            //     field("Total Candidates"; Rec."Total Candidates")
            //     {
            //         Caption = 'Total Candidates';
            //         ApplicationArea = All;
            //         Image = People;
            //         DrillDownPageId = CandidateList;
            //         ToolTip = 'Specifies the value of the Total Candidates';
            //     }
            //     field("Interview Candidates"; Rec."Interview Candidates")
            //     {
            //         Caption = 'Interview/s for Tomorrow';
            //         ApplicationArea = All;
            //         Image = People;
            //         DrillDownPageId = "Candidate Lines";
            //         ToolTip = 'Specifies the value of the Interview/s for Tomorrow';
            //         trigger OnDrillDown()
            //         begin
            //             Page.RunModal(Page::"Candidate Lines", TempCandidateLine);
            //         end;
            //     }
            // } // Stop #15 - 12/05/2019 - 103
        }
    }
    actions
    {
        area(processing)
        {
            action("Set Up Cues")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Set Up Cues';
                Image = Setup;
                ToolTip = 'Set up the cues (status tiles) related to the role.';

                trigger OnAction()
                var
                    CueRecordRef: RecordRef;
                begin
                    CueRecordRef.GETTABLE(Rec);
                    CueSetup.OpenCustomizePageForCurrentUser(CueRecordRef.NUMBER());
                end;
            }
        }
    }

    var
        // TempCandidateLine: Record "Candidate Line" temporary; // Start #15 - 12/05/2019 - 103
        TempEmployeeLevelIdentificationG: Record "Employee Level Identification" temporary;
        TempEmployee: Record Employee temporary;
        TempEmployee2: Record Employee temporary;
        EndOfService: Record "End of Service";
        HrmsManagementG: Codeunit "HRMS Management";
        CueSetup: Codeunit "Cues And KPIs";
        DateFormulaG: DateFormula;
        TempEmployee3: Record Employee temporary;

    trigger OnOpenPage();
    begin
        Rec.RESET();
        if not Rec.Get() then begin
            Rec.INIT();
            Rec.INSERT();
        end;

        Rec."Document Expiry" := HrmsManagementG.FindExpiryDocument(TempEmployeeLevelIdentificationG, DateFormulaG);
        Rec."End of Service" := HrmsManagementG.FindEndofService(EndOfService);
        Rec."Employee Birthday" := HrmsManagementG.FindBirthday(TempEmployee);
        Rec."Employee Anniversary" := HrmsManagementG.FindAnniversary(TempEmployee2);
        Rec."New Joiners" := HrmsManagementG.FindNewJoiners(TempEmployee3);
        //  Rec."Interview Candidates" := HrmsManagementG.FindInterviewCandidates(TempCandidateLine); // Start #15 - 12/05/2019 - 103 
        Rec.Modify();
    end;

}