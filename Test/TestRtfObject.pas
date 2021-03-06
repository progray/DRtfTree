﻿unit TestRtfObject;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit
  being tested.

}

interface

uses
  TestFramework, StrUtils, Classes, SysUtils, DateUtils, UITypes, TestRtfBase,
  RtfTree, RtfClasses, RtfObj;

type

  TTestRtfObject = class(TRtfTestCase)
  strict private
    FRtfTree: TRtfTree;
    FObjectNode: TRtfTreeNode;
    FObject: TRtfEmbeddedObject;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestObjectNode;
    procedure TestObjectHexData;
    procedure TestObjectBinData;
  end;

implementation

procedure TTestRtfObject.SetUp;
begin
  FRtfTree := TRtfTree.Create;
  FRtfTree.IgnoreWhitespace := False;
  FRtfTree.LoadFromFile(AssetPath + 'testdoc3.rtf');
  FObjectNode := FRtfTree.MainGroup.SelectSingleNode('object').ParentNode;
  FObject := TRtfEmbeddedObject.Create(FObjectNode);
end;

procedure TTestRtfObject.TearDown;
begin
  FreeAndNil(FRtfTree);
  FreeAndNil(FObject);
end;

procedure TTestRtfObject.TestObjectNode;
begin
  CheckEquals('objemb', FObject.ObjectType, 'Embedded object type matched');
  CheckEquals('Excel.Sheet.8', FObject.ObjectClass, 'Embedded object class matched');
end;

procedure TTestRtfObject.TestObjectHexData;
begin
  Str.LoadFromFile(AssetPath + 'objhexdata.txt');
  CheckEquals(Str.Text, TStringStream(FObject.HexData).DataString, 'Object hex data is matched');
end;

procedure TTestRtfObject.TestObjectBinData;
var
  Obj1, Obj2: TStringStream;

begin
  Obj1 := TStringStream.Create;
  Obj2 := TStringStream.Create;
  try
    FObject.SaveToFile(AssetPath + 'objbindata-result.dat');
    Obj1.LoadFromFile(AssetPath + 'objbindata-result.dat');
    Obj2.LoadFromFile(AssetPath + 'objbindata.dat');
    CheckEquals(Obj2.DataString, Obj1.DataString, 'Saved object matched');
  finally
    FreeAndNil(Obj1);
    FreeAndNil(Obj2);
  end;
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TTestRtfObject.Suite);

end.

