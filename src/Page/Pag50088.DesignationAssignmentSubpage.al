page 50088 "Designation Assignment Subpage"
{
    PageType = ListPart;
    SourceTable = "Employee Level Designation";
    Caption = 'Designation Assignment Subpage';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee No.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee Name';
                }
                field("Work Assignment Start Date"; Rec."Work Assignment Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Work Assignment Start Date';
                }
                field("Work Assignment End Date"; Rec."Work Assignment End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Work Assignment End Date';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Department';
                }
                field("Reporting To"; Rec."Reporting To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reporting To';
                }

            }
        }

    }
    actions
    {
        area(Processing)
        {
            action("Assign Designation")
            {
                ApplicationArea = All;
                Image = Design;
                Caption = 'Assign Designation';
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Assign Designation action.';
                trigger OnAction()
                var
                    EmployeeLevelDesignationL: Record "Employee Level Designation";
                    EmployeeLevelDesignation2L: Record "Employee Level Designation";
                    DesignationL: Record Designation;
                    PageFilterL: FilterPageBuilder;
                    LineNoL: Integer;
                    FilterRequiredLbl: Label 'You have to provide the valid filter to continue';
                    DesignationAssingedLbl: Label 'Designation assigned to %1: %2';
                    PositionValidationLbl: Label '%1 should be greater then previous %2: %3';
                    WorkAssignmentStartValidationLbl: Label 'Designation: %1 is starting from %2. %3 cannot be earlier than %4';
                    WorkAssignmentEndValidationLbl: Label '%1: %2 cannot be earlier than %3: %4';
                begin
                    Commit();
                    DesignationL.Get(Rec."Designation Code");
                    DesignationL.TestField("Position Assigned", false);
                    DesignationL.TestField(Department);
                    DesignationL.TestField("Reporting To");

                    PageFilterL.AddRecord('Assign Designation Filter', EmployeeLevelDesignationL);
                    PageFilterL.AddField('Assign Designation Filter', EmployeeLevelDesignationL."Employee No.");
                    PageFilterL.AddField('Assign Designation Filter', EmployeeLevelDesignationL."Work Assignment Start Date", Format(DesignationL."Position Start Date"));
                    PageFilterL.AddField('Assign Designation Filter', EmployeeLevelDesignationL."Work Assignment End Date");
                    if PageFilterL.RunModal() then begin
                        EmployeeLevelDesignationL.SetView(PageFilterL.GETVIEW('Assign Designation Filter'));
                        if (EmployeeLevelDesignationL.GetFilter("Employee No.") = '') or
                           (EmployeeLevelDesignationL.GetFilter("Work Assignment Start Date") = '') then
                            Error(FilterRequiredLbl);

                        DesignationL."Position Assigned" := true;
                        DesignationL.Modify();

                        if EmployeeLevelDesignation2L.FindLast() then
                            LineNoL := EmployeeLevelDesignation2L."Line No.";


                        EmployeeLevelDesignation2L.Init();
                        EmployeeLevelDesignation2L."Designation Code" := DesignationL."Designation Code";
                        EmployeeLevelDesignation2L.Description := DesignationL.Description;
                        EmployeeLevelDesignation2L."Line No." := LineNoL + 10000;
                        Evaluate(EmployeeLevelDesignation2L."Employee No.", EmployeeLevelDesignationL.GetFilter("Employee No."));
                        EmployeeLevelDesignation2L.Department := DesignationL.Department;
                        EmployeeLevelDesignation2L."Reporting To" := DesignationL."Reporting To";
                        Evaluate(EmployeeLevelDesignation2L."Work Assignment Start Date", EmployeeLevelDesignationL.GetFilter("Work Assignment Start Date"));
                        Evaluate(EmployeeLevelDesignation2L."Work Assignment End Date", EmployeeLevelDesignationL.GetFilter("Work Assignment End Date"));

                        if (DesignationL."Position Start Date" > 0D) and (EmployeeLevelDesignation2L."Work Assignment Start Date" < DesignationL."Position Start Date") then
                            Error(PositionValidationLbl, Rec.FieldCaption("Work Assignment Start Date"), Rec.FieldCaption("Work Assignment End Date"), DesignationL."Position Start Date");

                        if DesignationL."Start Date" > EmployeeLevelDesignation2L."Work Assignment Start Date" then
                            Error(WorkAssignmentStartValidationLbl, DesignationL."Designation Code", DesignationL."Start Date", Rec.FieldCaption("Work Assignment Start Date"), DesignationL.FieldCaption("Start Date"));

                        if (EmployeeLevelDesignation2L."Work Assignment End Date" > 0D) and (EmployeeLevelDesignation2L."Work Assignment End Date" < EmployeeLevelDesignation2L."Work Assignment Start Date") then
                            Error(WorkAssignmentEndValidationLbl, Rec.FieldCaption("Work Assignment End Date"), EmployeeLevelDesignation2L."Work Assignment End Date", Rec.FieldCaption("Work Assignment Start Date"), EmployeeLevelDesignation2L."Work Assignment Start Date");

                        EmployeeLevelDesignation2L."Position Closed" := false;
                        EmployeeLevelDesignation2L.Insert();

                        Message(DesignationAssingedLbl, Rec.FieldCaption("Employee No."), EmployeeLevelDesignation2L."Employee No.");
                    end;
                end;
            }
            action("Update Designation")
            {
                ApplicationArea = All;
                Image = UpdateDescription;
                Caption = 'Update Designation';
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Update Designation action.';
                trigger OnAction()
                var
                    EmployeeLevelDesignationL: Record "Employee Level Designation";
                    DesignationL: Record Designation;
                    PageFilterL: FilterPageBuilder;
                    FilterRequiredLbl: Label 'You have to provide the valid filter to continue';
                    WorkAssignmentStartValidationLbl: Label 'Designation: %1 is starting from %2. %3 cannot be earlier than %4';
                    WorkAssignmentEndValidationLbl: Label '%1: %2 cannot be earlier than %3: %4';
                    PositionValidationLbl: Label '%1 should be greater then previous %2: %3';
                begin
                    Rec.TestField("Position Closed", false);
                    Rec.TestField("Designation Code");
                    Rec.TestField(Department);
                    Rec.TestField("Reporting To");

                    DesignationL.Get(Rec."Designation Code");
                    DesignationL.TestField("Position Assigned", true);
                    DesignationL.TestField("Designation Code");
                    DesignationL.TestField(Department);
                    DesignationL.TestField("Reporting To");

                    PageFilterL.AddRecord('Assign Designation Filter', EmployeeLevelDesignationL);
                    PageFilterL.AddField('Assign Designation Filter', EmployeeLevelDesignationL."Work Assignment Start Date", Format(Rec."Work Assignment Start Date"));
                    PageFilterL.AddField('Assign Designation Filter', EmployeeLevelDesignationL."Work Assignment End Date", Format(Rec."Work Assignment End Date"));
                    if PageFilterL.RunModal() then begin
                        EmployeeLevelDesignationL.SetView(PageFilterL.GETVIEW('Assign Designation Filter'));
                        if (EmployeeLevelDesignationL.GetFilter("Work Assignment Start Date") = '') then
                            Error(FilterRequiredLbl);

                        Evaluate(Rec."Work Assignment Start Date", EmployeeLevelDesignationL.GetFilter("Work Assignment Start Date"));
                        Evaluate(Rec."Work Assignment End Date", EmployeeLevelDesignationL.GetFilter("Work Assignment End Date"));
                        Rec.Validate("Work Assignment End Date");
                        if (DesignationL."Position Start Date" > 0D) and (Rec."Work Assignment Start Date" < DesignationL."Position Start Date") then
                            Error(PositionValidationLbl, Rec.FieldCaption("Work Assignment Start Date"), Rec.FieldCaption("Work Assignment End Date"), DesignationL."Position Start Date");
                        if DesignationL."Start Date" > Rec."Work Assignment Start Date" then
                            Error(WorkAssignmentStartValidationLbl, DesignationL."Designation Code", DesignationL."Start Date", Rec.FieldCaption("Work Assignment Start Date"), DesignationL.FieldCaption("Start Date"));
                        if (Rec."Work Assignment End Date" > 0D) and (Rec."Work Assignment End Date" < Rec."Work Assignment Start Date") then
                            Error(WorkAssignmentEndValidationLbl, Rec.FieldCaption("Work Assignment End Date"), Rec."Work Assignment End Date", Rec.FieldCaption("Work Assignment Start Date"), Rec."Work Assignment Start Date");
                        Rec.Modify();
                    end;
                end;
            }
        }
    }

}