tableextension 51201 "Inbound Sales Header EC ExtTNP" extends "Inbound Sales Header nH"
{
    Description = 'Sales EDI : Sales Order -Solution';

    fields
    {
        field(51200; "EDI Creation Date TNP"; Date)
        {
            Caption = 'EDI Creation Date';
            DataClassification = CustomerContent;
            Description = 'OP38050-217 Sales EDI : Sales Order';
        }
        field(51201; "EDI Creation Time TNP"; Time)
        {
            Caption = 'EDI Creation Time';
            DataClassification = CustomerContent;
            Description = 'OP38050-217 Sales EDI : Sales Order';
        }
        field(51202; "External Document No. TNP"; Code[35])
        {
            Caption = 'External Document No.';
            DataClassification = CustomerContent;
            Description = 'OP38050-217 Sales EDI : Sales Order';
        }
        field(51203; "Your Reference TNP"; Code[35])
        {
            Caption = 'Your Reference';
            DataClassification = CustomerContent;
            Description = 'OP38050-217 Sales EDI : Sales Order';
        }
        field(51204; "EDI Inbound TransactionRef TNP"; Code[20])
        {
            Caption = 'EDI Inbound Transaction Ref';
            DataClassification = CustomerContent;
            Description = 'OP38050-217 Sales EDI : Sales Order';
        }
        field(51205; "Ship-To-Code TNP"; Code[20])
        {
            Caption = 'Ship-To-Code';
            DataClassification = CustomerContent;
            Description = 'OP38050-217 Sales EDI : Sales Order';
        }
        field(51206; "Trading Party Code TNP"; Code[20])
        {
            Caption = 'Trading Party Code';
            DataClassification = CustomerContent;
            Description = 'OP38050-217 Sales EDI : Sales Order';
        }
        field(51207; "SMS Phone No. TNP"; Text[30])
        {
            Caption = 'SMS Phone No.';
            DataClassification = CustomerContent;
            Description = 'OP38050-110 SMS Design : document solution.';
        }
    }
}
