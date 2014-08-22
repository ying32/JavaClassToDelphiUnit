//==============================================================================
// 功能：解析JavaClass文件生成Delphi开发Android单元
//
// 日期：2014-8-2
// 作者：ying32
// QQ  : 396506155
// E-mail: yuanfen3287@vip.qq.com
// MSN : ying_32@live.cn
//
// 注：一个简单的解析java class文件类, 没想要做得太复杂和
//     灵活性, 因为转为Pascal的单元不需要其它一些信息,
//     够用就行, 能读就行啊, 有兴趣的可以自行完善下
//    
//     目前还有不少需要完善, 这个东西去年就想过要写, 但对
//     javaclass文件全然无知, 就一直没动手.
//     手动转换单元太累了, 不过好久都没有碰过Android的开发了
//
//     前两天在网上看到了一个外国人写的一个这样的转换工具
//     不过是收费的, 最便宜也要�90, 于是就重新开始研究
//
// JavaClass文件格式:
//     http://www.mobilefish.com/tutorials/java/java_quickguide_classfile.html
//
// 修改日志:
//
//   2014-8-4 更新和修正参数类型和返回值类型
//==============================================================================
unit JavaClassFile;

interface

uses
  System.Classes,
  System.SysUtils;

type

  TReadConvert = class
  protected
     FStream: TStream;
     procedure ToBigEndian(Value: Pointer; nLen: Integer);
  public
     constructor Create(inStream: TStream); overload;
     function ReadByte: Byte;
     function ReadWord: Word;
     function ReadCardinal: Cardinal;
     function ReadUInt64: UInt64;
     function ReadShortInt: ShortInt;
     function ReadSmallInt: SmallInt;
     function ReadInteger: Integer;
     function ReadInt64: Int64;
     function ReadSingle: Single;
     function ReadDouble: Double;
     function ReadBytes(nLen: Word): TBytes; overload;
     procedure ReadBytes(out Buffer: TBytes; nLen: Word); overload;
     procedure Seek(APosi: Integer);
  end;


  TJavaClassFile = class(TObject)
  public
    type
      PCp_Info = ^TCp_Info;
      TCp_Info = packed record
        Tag: Byte;
        Info: TArray<Byte>;
      end;

      PCONSTANT_Class_info = ^TCONSTANT_Class_info;
      TCONSTANT_Class_info = packed record
        //Tag: Byte;
        Name_Index: Word;
      end;

      PCONSTANT_Fieldref_info = ^TCONSTANT_Fieldref_info;
      TCONSTANT_Fieldref_info = packed record
        //Tag: Byte;
        Class_Index: Word;
        Name_And_Type_Index: Word;
      end;

      PCONSTANT_Methodref_info = ^TCONSTANT_Methodref_info;
      TCONSTANT_Methodref_info = packed record
        //Tag: Byte;
        Class_Index: Word;
        Name_And_Type_Index: Word;
      end;

      PCONSTANT_InterfaceMethodref_info = ^TCONSTANT_InterfaceMethodref_info;
      TCONSTANT_InterfaceMethodref_info = packed record
        //Tag: Byte;
        Class_Index: Word;
        Name_And_Type_Index: Word;
      end;

      PCONSTANT_String_info = ^TCONSTANT_String_info;
      TCONSTANT_String_info = packed record
        //Tag: Byte;
        String_Index: Word;
      end;


      PCONSTANT_Integer_info = ^TCONSTANT_Integer_info;
      TCONSTANT_Integer_info = packed record
        //Tag: Byte;
        Bytes: Cardinal;
      end;

      PCONSTANT_Long_info = ^TCONSTANT_Long_info;
      TCONSTANT_Long_info = packed record
        //Tag: Byte;
        High_Bytes: Cardinal;
        Low_Bytes: Cardinal;
      end;

      PCONSTANT_Double_info = ^TCONSTANT_Double_info;
      TCONSTANT_Double_info = packed record
        //Tag: Byte;
        High_Bytes: Cardinal;
        Low_Bytes: Cardinal;
      end;

      PCONSTANT_NameAndType_info = ^TCONSTANT_NameAndType_info;
      TCONSTANT_NameAndType_info = packed record
        //Tag: Byte;
        Name_Index: Word;
        Descriptor_Index: Word;
      end;

      PCONSTANT_Utf8_info = ^TCONSTANT_Utf8_info;
      TCONSTANT_Utf8_info = packed record
        //Tag: Byte;
        Length: Word;
        Bytes : TArray<Byte>;
      end;

      PCONSTANT_Float_info = ^TCONSTANT_Float_info;
      TCONSTANT_Float_info = packed record
        //Tag: Byte;
        Bytes: Cardinal;
      end;

      PCONSTANT_MethodHandle_info = ^TCONSTANT_MethodHandle_info;
      TCONSTANT_MethodHandle_info = packed record
        //Tag: Byte;
        Reference_Kind: Byte;
        ReferEnce_Index: Word;
      end;

      PCONSTANT_MethodType_info = ^TCONSTANT_MethodType_info;
      TCONSTANT_MethodType_info = packed record
        //Tag: Byte;
        Descriptor_Index: Word;
      end;

      PCONSTANT_InvokeDynamic_info = ^TCONSTANT_InvokeDynamic_info;
      TCONSTANT_InvokeDynamic_info = packed record
        //Tag: Byte;
        Bootstrap_Method_Attr_Index: Word;
        Name_And_Type_Index: Word;
      end;


      PAttribute_Info_Row1 = ^TAttribute_Info_Row1;
      TAttribute_Info_Row1 = packed record
        Start_PC: Word;
        Line_Number: Word;
      end;

      PAttribute_Info_Row2 = ^TAttribute_Info_Row2;
      TAttribute_Info_Row2 = packed record
        Start_PC: Word;
        Length: Word;
        Name_Index: Word;
        Descriptor_Index: Word;
        Index: Word;
      end;

      PAttribute_Info = ^TAttribute_Info;
      TAttribute_Info = packed record
        Attribute_Name_Index: Word;
        Attribute_Length: Cardinal;
        Attribute_Row2: TArray<TAttribute_Info_Row2>;
        case Word of
          0 : (Constant_Value_Index: Word);
          1 : (Line_Number_Table_Length: Word);
          2 : (Local_Variable_Table_Length: Word);
          3 : (SourceFile_Index: Word);
          4 : (Number_Of_Classes: Word);
      end;




      PAttribute_Info2 = ^TAttribute_Info2;
      TAttribute_Info2 = packed record
        Attribute_Name_Index: Word;
        Attribute_Length: Cardinal;
        Max_Stack: Word;
        Max_Locals: Word;
        Code_Length: Cardinal;
        Code: TArray<Byte>;
        Exception_Table_Length: Word;
        Attribute_Count: Word;
        Attr : TArray<TAttribute_Info>;
      end;


      PField_Info = ^TField_Info;
      TField_Info = packed record
        Access_Flags: Word;
        Name_Index: Word;
        Descriptor_Index: Word;
        Attributes_Count: Word;
        Attributes: TArray<TAttribute_Info>;
      end;

      PMethod_Info = ^TMethod_Info;
      TMethod_Info = packed record
        Access_Flags: Word;
        Name_Index: Word;
        Descriptor_Index: Word;
        Attributes_Count: Word;
        Attributes: TArray<TAttribute_Info2>;
      end;

      TClassFile = record
        Magic: Cardinal;
        Minor: Word;
        Major: Word;
        ConstantPoolCount: Word;
        ConstantPool: TArray<TCp_Info>;
        AccessFlags: Word;
        ThisClass: Word;
        SuperClass: Word;
        InterfacesCount: Word;
        Interfaces: TArray<Word>;
        FieldsCount: Word;
        Fields: TArray<TField_Info>;
        MethodsCount: Word;
        Methods: TArray<TMethod_Info>;
        AttributesCount: Word;
        Attributes: TArray<TAttribute_Info>;
      end;





  public const
    MAGIC_CONST = $CAFEBABE;

    //ant types: ANT
    CONSTANT_Utf8               = 1;
    CONSTANT_Integer            = 3;
    CONSTANT_Float              = 4;
    CONSTANT_Long               = 5;
    CONSTANT_Double             = 6;
    CONSTANT_Class              = 7;
    CONSTANT_String             = 8;
    CONSTANT_Fieldref           = 9;
    CONSTANT_Methodref          = 10;
    CONSTANT_InterfaceMethodref = 11;
    CONSTANT_NameAndType        = 12;
    CONSTANT_MethodHandle       = 15;
    CONSTANT_MethodType         = 16;
    CONSTANT_InvokeDynamic      = 18;

    //Access Flags: ACC
    ACC_PUBLIC                  = $0001;
    ACC_PRIVATE                 = $0002;
    ACC_PROTECTED               = $0004;
    ACC_STATIC                  = $0008;
    ACC_FINAL                   = $0010;
    ACC_SYNCHRONIZED            = $0020;
    ACC_SUPER                   = $0020; //Same as ACC_SYNCHRONIZED
    ACC_BRIDGE                  = $0040;
    ACC_VOLATILE                = $0040; //Same as ACC_BRIDGE
    ACC_VARARGS                 = $0080;
    ACC_TRANSIENT               = $0080; //Same as ACC_VARARGS
    ACC_NATIVE                  = $0100;
    ACC_INTERFACE               = $0200;
    ACC_ABSTRACT                = $0400;
    ACC_STRICT                  = $0800;
    ACC_SYNTHETIC               = $1000;
    ACC_ANNOTATION              = $2000;
    ACC_ENUM                    = $4000;

  private
    FClassFile: TClassFile;
    procedure FreeMemory;
    procedure analyzerConstantPool(AData: TReadConvert; AIndex: Integer);
    procedure analyzerFieldPool(AData: TReadConvert; AIndex: Integer);
    procedure analyzerInterfacePool(AData: TReadConvert; AIndex: Integer);
    procedure analyzerMethodPool(AData: TReadConvert; AIndex: Integer);
    procedure analyzerAttributePool(AData: TReadConvert; AIndex: Integer);
    procedure CheckKeywords(var str: string);
    function getUTF8String(ACpInfo: TCP_Info): string;
    function getDataType(const S: string): string; overload;
    function getDataType(ACpInfo: TCP_Info): string; overload;
    function getParamsString(AMethod_Info: TMethod_Info): string;
    function getReturnDataType(const S: string): string;
    function ConvertToDelphiUnit: string;
    function GetClassName(AIndex: Integer): string;
    function GetThisClass: string;
    function GetSuperClass: string;
  public
    constructor Create;
    destructor Destroy; override;
    function Convert(AFileName: string): string;
//    property ThisClass: string read GetThisClass;
  public
//    property ClassFile: TClassFile read FClassFile;
  end;



implementation

{$IFDEF MSWINDOWS}
uses
  Winapi.Windows;
{$ENDIF}

procedure println(Fmtstr: string; Args: array of const);
begin
  {$IFDEF MSWINDOWS}
    OutputDebugString(PChar(Format(Fmtstr, Args)));
  {$ENDIF}
end;


{ TJavaClassFile }

{
  TCONSTANT_Class_info
  TCONSTANT_Fieldref_info
  TCONSTANT_Methodref_info
  TCONSTANT_InterfaceMethodref_info
  TCONSTANT_String_info
  TCONSTANT_Integer_info
  TCONSTANT_Long_info
  TCONSTANT_Double_info
  TCONSTANT_NameAndType_info
  TCONSTANT_Utf8_info
  TCONSTANT_Float_info
  TCONSTANT_MethodHandle_info
  TCONSTANT_MethodType_info
  TCONSTANT_InvokeDynamic_info
  TAttribute_Info
  TField_Info
  TMethod_Info
}

procedure TJavaClassFile.analyzerAttributePool(AData: TReadConvert; AIndex: Integer);
begin
  // 没写．．．．．．有点用不着的样子
end;

procedure TJavaClassFile.analyzerConstantPool(AData: TReadConvert; AIndex: Integer);
var
  LCpInfo: PCp_Info;
  LLen, LWord: Word;
  LU32: Cardinal;
  LFloat: Single;
  LUInt64: UInt64;
  LDouble: Double;
  LBytes: TBytes;
begin
  LCpInfo := @FClassFile.ConstantPool[AIndex];
  LCpInfo^.Tag := AData.ReadByte;
  case LCpInfo^.Tag of
     CONSTANT_Utf8 :
       begin
         LLen := AData.ReadWord;
         SetLength(LCpInfo^.Info, SizeOf(Word) + LLen);
         LBytes := AData.ReadBytes(LLen);
         Move(LBytes[0], LCpInfo^.Info[2], LLen);
         PCONSTANT_Utf8_info(LCpInfo^.Info)^.Length := LLen;
       end;
     CONSTANT_Integer :
       begin
         LU32 := AData.ReadCardinal;
         SetLength(LCpInfo^.Info, Sizeof(Cardinal));
         Move(LU32, LCpInfo^.Info[0], SizeOf(Cardinal));
       end;
     CONSTANT_Float :
       begin
         LFloat := AData.ReadSingle;
         SetLength(LCpInfo^.Info, Sizeof(Single));
         Move(LFloat, LCpInfo^.Info[0], SizeOf(Single));
       end;
     CONSTANT_Long :
       begin
         LUInt64 := AData.ReadUInt64;
         SetLength(LCpInfo^.Info, Sizeof(UInt64));
         Move(LUint64, LCpInfo^.Info[0], SizeOf(UInt64));
       end;
    CONSTANT_Double :
       begin
         LDouble := AData.ReadDouble;
         SetLength(LCpInfo^.Info, Sizeof(LDouble));
         Move(LDouble, LCpInfo^.Info[0], SizeOf(LDouble));
       end;
    CONSTANT_Class :
       begin
         LWord := AData.ReadWord;
         SetLength(LCpInfo^.Info, Sizeof(Word));
         PCONSTANT_Class_info(LCpInfo^.Info)^.Name_Index :=  LWord;
         //Move(LWord, LCpInfo^.Info[0], SizeOf(Word));
       end;
    CONSTANT_String :
       begin
         LWord := AData.ReadWord;
         SetLength(LCpInfo^.Info, Sizeof(Word));
         PCONSTANT_String_info(LCpInfo^.Info)^.String_Index :=  LWord;
         //Move(LWord, LCpInfo^.Info[0], SizeOf(Word));
       end;
    CONSTANT_Fieldref,
    CONSTANT_Methodref ,
    CONSTANT_InterfaceMethodref :
      begin
         SetLength(LCpInfo^.Info, Sizeof(Cardinal));
         LWord := AData.ReadWord;
         PCONSTANT_Fieldref_info(LCpInfo^.Info)^.Class_Index := LWord;
         LWord := AData.ReadWord;
         PCONSTANT_Fieldref_info(LCpInfo^.Info)^.Name_And_Type_Index := LWord;
      end;
    CONSTANT_NameAndType :
      begin
         SetLength(LCpInfo^.Info, Sizeof(Cardinal));
         LWord := AData.ReadWord;
         PCONSTANT_NameAndType_info(LCpInfo^.Info)^.Name_Index := LWord;
         LWord := AData.ReadWord;
         PCONSTANT_NameAndType_info(LCpInfo^.Info)^.Descriptor_Index := LWord;
      end;
    CONSTANT_MethodHandle :
      begin
         SetLength(LCpInfo^.Info, Sizeof(Cardinal));
         LWord := AData.ReadWord;
         PCONSTANT_MethodHandle_info(LCpInfo^.Info)^.Reference_Kind := LWord;
         LWord := AData.ReadWord;
         PCONSTANT_MethodHandle_info(LCpInfo^.Info)^.ReferEnce_Index := LWord;
      end;
    CONSTANT_MethodType :
      begin
         LWord := AData.ReadWord;
         SetLength(LCpInfo^.Info, Sizeof(Word));
         PCONSTANT_MethodType_info(LCpInfo^.Info)^.Descriptor_Index :=  LWord;
      end;
    CONSTANT_InvokeDynamic :
      begin
         SetLength(LCpInfo^.Info, Sizeof(Cardinal));
         LWord := AData.ReadWord;
         PCONSTANT_InvokeDynamic_info(LCpInfo^.Info)^.Bootstrap_Method_Attr_Index := LWord;
         LWord := AData.ReadWord;
         PCONSTANT_InvokeDynamic_info(LCpInfo^.Info)^.Name_And_Type_Index := LWord;
      end;
  end;
end;

{
        Access_Flags: Word;
        Name_Index: Word;
        Descriptor_Index: Word;
        Attributes_Count: Word;
        Attributes: TArray<TAttribute_Info>;
}
procedure TJavaClassFile.analyzerFieldPool(AData: TReadConvert; AIndex: Integer);
var
  LField: PField_Info;
  I: Integer;
begin
  LField := @FClassFile.Fields[AIndex];
  LField^.Access_Flags := AData.ReadWord;
  LField^.Name_Index := AData.ReadWord;
  LField^.Descriptor_Index := AData.ReadWord;
  LField^.Attributes_Count := AData.ReadWord;
  if LField^.Attributes_Count > 0 then
  begin
    SetLength(LField^.Attributes, LField^.Attributes_Count);
    for I := 0 to LField^.Attributes_Count - 1 do
    begin
      LField^.Attributes[I].Attribute_Name_Index := AData.ReadWord;
      LField^.Attributes[I].Attribute_Length := AData.ReadCardinal;
      LField^.Attributes[I].Constant_Value_Index := AData.ReadWord;
    end;
  end;
end;

procedure TJavaClassFile.analyzerInterfacePool(AData: TReadConvert; AIndex: Integer);
begin
  FClassFile.Interfaces[AIndex] := AData.ReadWord;
end;

procedure TJavaClassFile.analyzerMethodPool(AData: TReadConvert; AIndex: Integer);
var
  LMethod: PMethod_Info;
  I, J, K: Integer;
begin
  LMethod := @FClassFile.Methods[AIndex];
  LMethod^.Access_Flags := AData.ReadWord;
  LMethod^.Name_Index := AData.ReadWord;
  LMethod^.Descriptor_Index := AData.ReadWord;
  LMethod^.Attributes_Count := AData.ReadWord;
  //println('Index=%d', [AIndex]);
  if LMethod^.Attributes_Count > 0 then
  begin
    SetLength(LMethod^.Attributes, LMethod^.Attributes_Count);
    for I := 0 to LMethod^.Attributes_Count - 1 do
    begin
      LMethod^.Attributes[I].Attribute_Name_Index := AData.ReadWord;
      LMethod^.Attributes[I].Attribute_Length := AData.ReadCardinal;
      //println('aaaaa=%d', [I]);
      // 跳过除代码段的
      if I >= 1 then
      begin
        AData.Seek(LMethod^.Attributes[I].Attribute_Length);
        Continue;
      end;

      LMethod^.Attributes[I].Max_Stack := AData.ReadWord;
      LMethod^.Attributes[I].Max_Locals := AData.ReadWord;
      LMethod^.Attributes[I].Code_Length := AData.ReadCardinal;
      AData.Seek(LMethod^.Attributes[I].Code_Length);
      LMethod^.Attributes[I].Exception_Table_Length := AData.ReadWord;
      LMethod^.Attributes[I].Attribute_Count := AData.ReadWord;

      if LMethod^.Attributes[I].Attribute_Count > 0 then
      begin
        SetLength(LMethod^.Attributes[I].Attr, LMethod^.Attributes[I].Attribute_Count);
        for J := 0 to LMethod^.Attributes[I].Attribute_Count - 1 do
        begin
          //println('bbbbb=%d', [J]);
          LMethod^.Attributes[I].Attr[J].Attribute_Name_Index := AData.ReadWord;
          LMethod^.Attributes[I].Attr[J].Attribute_Length := AData.ReadCardinal;
//          println('AIndex=%d,  属性长度=%d,, I=%d, J=%d', [AIndex, LMethod^.Attributes[I].Attr[J].Attribute_Length, I, J]);
          if J = 0 then
          begin
            AData.Seek(LMethod^.Attributes[I].Attr[J].Attribute_Length);
            Continue;
          end;
          LMethod^.Attributes[I].Attr[J].Local_Variable_Table_Length := AData.ReadWord;
          if LMethod^.Attributes[I].Attr[J].Local_Variable_Table_Length > 0 then
          begin
            SetLength(LMethod^.Attributes[I].Attr[J].Attribute_Row2, LMethod^.Attributes[I].Attr[J].Local_Variable_Table_Length);
            for K := 0 to LMethod^.Attributes[I].Attr[J].Local_Variable_Table_Length - 1 do
            begin
              //println('ddddd=%d', [K]);
              LMethod^.Attributes[I].Attr[J].Attribute_Row2[K].Start_PC := AData.ReadWord;
              LMethod^.Attributes[I].Attr[J].Attribute_Row2[K].Length := AData.ReadWord;
              LMethod^.Attributes[I].Attr[J].Attribute_Row2[K].Name_Index := AData.ReadWord;
              LMethod^.Attributes[I].Attr[J].Attribute_Row2[K].Descriptor_Index := AData.ReadWord;
              LMethod^.Attributes[I].Attr[J].Attribute_Row2[K].Index := AData.ReadWord;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TJavaClassFile.CheckKeywords(var str: string);
const
  KeyWords_: array[0..1] of string = ('in', 'type');
var
  I: Integer;
begin
  for I := 0 to High(KeyWords_) do
    if SameText(KeyWords_[I], Str.ToLower) then
      Str := '_' + Str;
end;

function TJavaClassFile.Convert(AFileName: string): string;
var
  LStream: TFileStream;
  LReadConvert: TReadConvert;
  I: Integer;
begin
  Result := '';
  FillChar(FClassFile, SizeOf(TClassFile), 0);
  LStream := TFileStream.Create(AFileName, fmOpenRead);
  LReadConvert := TReadConvert.Create(LStream);
  try
    FClassFile.Magic := LReadConvert.ReadCardinal;
    if FClassFile.Magic = TJavaClassFile.MAGIC_CONST then
    begin
      FClassFile.Minor := LReadConvert.ReadWord;
      FClassFile.Major := LReadConvert.ReadWord;
      // 分析常量池
      FClassFile.ConstantPoolCount := LReadConvert.ReadWord;
      if FClassFile.ConstantPoolCount > 0 then
      begin
        SetLength(FClassFile.ConstantPool, FClassFile.ConstantPoolCount);
        for I := 1 to FClassFile.ConstantPoolCount - 1 do
          analyzerConstantPool(LReadConvert, I);
      end;
      FClassFile.AccessFlags := LReadConvert.ReadWord;
      FClassFile.ThisClass := LReadConvert.ReadWord;
      FClassFile.SuperClass := LReadConvert.ReadWord;
      // 分析接口
      FClassFile.InterfacesCount := LReadConvert.ReadWord;
      if FClassFile.InterfacesCount > 0 then
      begin
        SetLength(FClassFile.Interfaces, FClassFile.InterfacesCount);
        for I := 0 to FClassFile.InterfacesCount - 1 do
          analyzerInterfacePool(LReadConvert, I);
      end;
      // 分析字段
      FClassFile.FieldsCount := LReadConvert.ReadWord;
      if FClassFile.FieldsCount > 0 then
      begin
        SetLength(FClassFile.Fields, FClassFile.FieldsCount);
        for I := 0 to FClassFile.FieldsCount - 1 do
          analyzerFieldPool(LReadConvert, I);
      end;
      // 分析方法
      FClassFile.MethodsCount := LReadConvert.ReadWord;
      if FClassFile.MethodsCount > 0 then
      begin
        SetLength(FClassFile.Methods, FClassFile.MethodsCount);
        for I := 0 to  FClassFile.MethodsCount - 1 do
          analyzerMethodPool(LReadConvert, I);
      end;
      // 分析属性
      FClassFile.AttributesCount := LReadConvert.ReadWord;
      if FClassFile.AttributesCount > 0 then
      begin
        SetLength(FClassFile.Attributes, FClassFile.AttributesCount);
        for I := 0 to FClassFile.AttributesCount - 1 do
          analyzerAttributePool(LReadConvert, I);
      end;
      Result := ConvertToDelphiUnit;
    end;

  finally
    LStream.Free;
    LReadConvert.Free;
    Self.FreeMemory;
  end;
end;

constructor TJavaClassFile.Create;
begin
  inherited Create;
end;

destructor TJavaClassFile.Destroy;
begin
  inherited;
end;

procedure TJavaClassFile.FreeMemory;
begin
  SetLength(FClassFile.ConstantPool, 0);
  SetLength(FClassFile.Interfaces, 0);
  SetLength(FClassFile.Fields, 0);
  SetLength(FClassFile.Methods, 0);
  SetLength(FClassFile.Attributes, 0);
end;

function TJavaClassFile.GetClassName(AIndex: Integer): string;
var
  P: TCp_Info;
begin
  Result := '';
  P := FClassFile.ConstantPool[AIndex];
  if P.Tag = CONSTANT_Class then
  begin
    P := FClassFile.ConstantPool[PCONSTANT_Class_info(P.Info).Name_Index];
    if P.Tag = CONSTANT_Utf8 then
      Result := getUTF8String(P);
  end;
end;

function TJavaClassFile.getDataType(ACpInfo: TCP_Info): string;
begin
  Result := getDataType(getUTF8String(ACpInfo))
end;

function TJavaClassFile.getDataType(const S: string): string;
  function getJavaClass(const S:string): string;
  begin
    Result := 'J' + S.Substring(S.LastDelimiter('/') + 1).Replace('$', '_').Replace(';', '');
  end;
begin
  Result := S.Trim;
  case Result[1] of
    'B' : Result := 'Byte';
    'C' : Result := 'Char';
    'D' : Result := 'Double';
    'F' : Result := 'Single';
    'I' : Result := 'Integer';
    'J' : Result := 'Int64';
    'S' : Result := 'Word';
    'Z' : Result := 'Boolean';
    'V' : Result := '';
    'L' : Result := getJavaClass(Result);
    '[' :
      begin
        case Result[2] of
          'B' : Result := 'TArray<Byte>';
          'C' : Result := 'TArray<Char>';
          'D' : Result := 'TArray<Double>';
          'F' : Result := 'TArray<Single>';
          'I' : Result := 'TArray<Integer>';
          'J' : Result := 'TArray<Int64>';
          'L' : Result := Format('TArray<%s>', [getJavaClass(Result)]);
          'S' : Result := 'TArray<Word>';
          'Z' : Result := 'TArray<Boolean>';
          'V' : Result := '';
        end;
      end;
  end;
end;

function TJavaClassFile.getParamsString(AMethod_Info: TMethod_Info): string;
var
  I: Integer;
  LParamName: string;
  LParamType: string;
begin
  Result := '';
  if AMethod_Info.Attributes_Count > 0 then
     if AMethod_Info.Attributes[0].Attribute_Count > 1 then
       if AMethod_Info.Attributes[0].Attr[1].Local_Variable_Table_Length > 1 then
         for I := 1 to High(AMethod_Info.Attributes[0].Attr[1].Attribute_Row2) do
         begin
           LParamName := getUTF8String(FClassFile.ConstantPool[AMethod_Info.Attributes[0].Attr[1].Attribute_Row2[I].Name_Index]);
           LParamType := getDataType(FClassFile.ConstantPool[AMethod_Info.Attributes[0].Attr[1].Attribute_Row2[I].Descriptor_Index]);
           CheckKeywords(LParamName);
           Result := Result + LParamName + ': ' + LParamType + '; ';
         end;
  Result := Result.Substring(0, Result.LastDelimiter(';') - 1);
         //Delete(Result, Length(Result) - 1, 2);
end;

function TJavaClassFile.getReturnDataType(const S: string): string;
begin
  Result := getDataType(S.Substring(S.LastDelimiter(')')+1, S.Length - S.LastDelimiter(')')-1)).Trim;
end;

function TJavaClassFile.GetSuperClass: string;
begin
  Result := GetClassName(FClassFile.SuperClass);
end;

function TJavaClassFile.GetThisClass: string;
begin
  Result := GetClassName(FClassFile.ThisClass);
end;

function TJavaClassFile.getUTF8String(ACpInfo: TCP_Info): string;
var
  Len: Word;
  LBytes: TBytes;
begin
  Result := '';
  if ACpInfo.Tag <> CONSTANT_Utf8 then Exit;
  Len := PCONSTANT_Utf8_info(ACpInfo.Info)^.Length;
  SetLength(LBytes, Len);
  Move(ACpInfo.Info[2], LBytes[0], Len);
  Result := StringOf(LBytes);
end;

function TJavaClassFile.ConvertToDelphiUnit: string;
var
  I: Integer;
  LFuncName, LDataType: string;
  StrList: TStringList;

  LJavaClass: string;
  LThisClass: string;
  LUnitName: string;

  procedure addstr(str: string);
  begin
    StrList.Add(str);
  end;

  function getJavaClass(str: string): string;
  begin
    Result := str.Substring(str.LastDelimiter('/') + 1, str.Length - str.LastDelimiter('/'));
  end;
begin
  StrList := TStringList.Create;
  try
    LThisClass := GetThisClass;
    LJavaClass := getJavaClass(LThisClass);
    LUnitName := 'Androidapi.JNI.' + LThisClass.Substring(LThisClass.IndexOf('/') + 1, LThisClass.Length - LThisClass.IndexOf('/')).Replace('/', '.');

    addstr('//====================================================');
    addstr('//');
    addstr('//  转换来自JavaClassToDelphiUnit');
    addstr('//  时间：' + DateTimeToStr(Now));
    addstr('//  作者：ying32');
    addstr('//  QQ: 1444386932');
    addstr('//      396506155');
    addstr('//  Email：yuanfen3287@vip.qq.com');
    addstr('//  个人小站：http://www.ying32.com');
    addstr('//  博客：http://blog.csdn.net/zyjying520');
    addstr('//');
    addstr('//====================================================');
    addstr(Format('unit %s;', [LUnitName]));
    addstr('');
    addstr('interface');
    addstr('');
    addstr('uses');      // 引用文件，还没弄　
    addstr('  Androidapi.JNIBridge,');
    addstr('  Androidapi.JNI.JavaTypes;');
    addstr('');
    addstr('');
    addstr('type');
    addstr(Format('  J%s = interface; // %s', [LJavaClass, LThisClass.Replace('/', '.')]));
    addstr('');
    addstr(Format('  J%sClass = interface(J%sClass)', [LJavaClass, getJavaClass(GetSuperClass)]));  //　这里还有接口了, 枚举了？？？？
    addstr(Format('  [''%s'']', [TGUID.NewGuid.ToString]));
    addstr('    { Property Methods }');

    for I := 0 to FClassFile.FieldsCount - 1 do
    begin
      LFuncName := getUTF8String(FClassFile.ConstantPool[FClassFile.Fields[I].Name_Index]);
      LDataType :=  getDataType(FClassFile.ConstantPool[FClassFile.Fields[I].Descriptor_Index]);
      addstr(Format('    function _GET%s: %s;', [LFuncName, LDataType]));
    end;
    addstr('');
    addstr('    { static Methods }');
    for I := 0 to FClassFile.MethodsCount - 1 do
    begin
      LFuncName := getUTF8String(FClassFile.ConstantPool[FClassFile.Methods[I].Name_Index]);
      LDataType :=  getDataType(FClassFile.ConstantPool[FClassFile.Methods[I].Descriptor_Index]);
      if SameText(LFuncName, '<init>') then
        addstr(Format('    function init(%s): J%s; cdecl;', [getParamsString(FClassFile.Methods[I]), LJavaClass])); // 方法的重载标识没添加
      // public static
      if FClassFile.Methods[I].Access_Flags = 9 then
        addstr(Format('    function %s(%s): J%s; cdecl;', [LFuncName, getParamsString(FClassFile.Methods[I]), LJavaClass]));
    end;
    addstr('');
    addstr('    { Property }');
    for I := 0 to FClassFile.FieldsCount - 1 do
    begin
      LFuncName := getUTF8String(FClassFile.ConstantPool[FClassFile.Fields[I].Name_Index]);
      LDataType :=  getDataType(FClassFile.ConstantPool[FClassFile.Fields[I].Descriptor_Index]);

      addstr(Format('    property %s: %s read _GET%s;', [LFuncName, LDataType, LFuncName]));
    end;

    addstr('  end;');
    addstr('');
    addstr(Format('  [JavaSignature(''%s'')]', [LThisClass]));
    addstr(Format('  J%s = interface(J%s)', [LJavaClass,  getJavaClass(GetSuperClass)]));
    addstr(Format('  [''%s'']', [TGUID.NewGuid.ToString]));
    addstr('    { methods }');
    for I := 0 to FClassFile.MethodsCount - 1 do
    begin
      LFuncName := getUTF8String(FClassFile.ConstantPool[FClassFile.Methods[I].Name_Index]);
      // public 其它还有，自行搞定
      if (FClassFile.Methods[I].Access_Flags = ACC_PUBLIC) and (not SameText('<init>', LFuncName)) then
      begin
        LDataType :=  getDataType(FClassFile.ConstantPool[FClassFile.Methods[I].Descriptor_Index]);
        if getReturnDataType(LDataType).Length = 0 then
          addstr(Format('    procedure %s(%s); cdecl;', [LFuncName, getParamsString(FClassFile.Methods[I])]))
        else
          addstr(Format('    function %s(%s): %s; cdecl;', [LFuncName, getParamsString(FClassFile.Methods[I]), getReturnDataType(LDataType)]));
      end;
    end;

    addstr('  end;');

    addstr('');
    addstr(Format('  TJ%s = class(TJavaGenericImport<J%sClass, J%s>) end;', [LJavaClass, LJavaClass, LJavaClass]));
    addstr('');
    addstr('implementation');
    addstr('');
    addstr('end.');
    Result := StrList.Text;
    StrList.SaveToFile(ExtractFilePath(ParamStr(0)) + LUnitName + '.pas');
  finally
    StrList.Free;
  end;
end;

{ TReadConvert }

constructor TReadConvert.Create(inStream: TStream);
begin
  FStream := inStream;
  FStream.Position := 0;
end;

function TReadConvert.ReadByte: Byte;
begin
  FStream.Read(Result, 1);
end;

procedure TReadConvert.ReadBytes(out Buffer: TBytes; nLen: Word);
begin
  if Buffer <> nil then FStream.Read(Buffer, nLen);
end;

function TReadConvert.ReadBytes(nLen: Word): TBytes;
begin
  SetLength(Result, nLen);
  FStream.Read(Result[0], nLen);
end;

function TReadConvert.ReadCardinal: Cardinal;
begin
  FStream.Read(Result, 4);
  ToBigEndian(@Result, 4);
end;

function TReadConvert.ReadDouble: Double;
begin
  FStream.Read(Result, 8);
  ToBigEndian(@Result, 8);
end;

function TReadConvert.ReadInt64: Int64;
begin
  FStream.Read(Result, 8);
  ToBigEndian(@Result, 8);
end;

function TReadConvert.ReadInteger: Integer;
begin
  FStream.Read(Result, 4);
  ToBigEndian(@Result, 4);
end;

function TReadConvert.ReadShortInt: ShortInt;
begin
  FStream.Read(Result, 1);
end;

function TReadConvert.ReadSingle: Single;
begin
  FStream.Read(Result, 4);
  ToBigEndian(@Result, 4);
end;

function TReadConvert.ReadSmallInt: SmallInt;
begin
  FStream.Read(Result, 2);
  ToBigEndian(@Result, 2);
end;

function TReadConvert.ReadUInt64: UInt64;
begin
  FStream.Read(Result, 8);
  ToBigEndian(@Result, 8);
end;

function TReadConvert.ReadWord: Word;
begin
  FStream.Read(Result, 2);
  ToBigEndian(@Result, 2);
end;

procedure TReadConvert.Seek(APosi: Integer);
begin
  FStream.Position := FStream.Position + APosi;
end;

procedure TReadConvert.ToBigEndian(Value: Pointer; nLen: Integer);
var
  LWord: Word;
  LCardinal: Cardinal;
  LUInt64: UInt64;
begin
  case nLen of
    2 :
      begin
        LWord := (Word(PByte(Value)^) shl 8) + Word(PByte(Cardinal(Value) + 1)^);
        PWord(Value)^ := LWord;
      end;
    4 :
      begin
        LCardinal :=
           (Cardinal(PByte(Value)^) shl 24) +
           (Cardinal(PByte(Cardinal(Value) + 1)^) shl 16) +
           (Cardinal(PByte(Cardinal(Value) + 2)^) shl 8)  +
            Cardinal(PByte(Cardinal(Value) + 3)^);
        PCardinal(Value)^ := LCardinal;
      end;
    8 :
      begin
        LUInt64 :=
          (UInt64(PByte(Cardinal(Value) + 1)^) shl 56) +
          (UInt64(PByte(Value)^) shl 48) +
          (UInt64(PByte(Cardinal(Value) + 1)^) shl 40) +
          (UInt64(PByte(Cardinal(Value) + 2)^) shl 32) +
          (UInt64(PByte(Value)^) shl 24) +
          (UInt64(PByte(Cardinal(Value) + 1)^) shl 16) +
          (UInt64(PByte(Cardinal(Value) + 2)^) shl 8)  +
           UInt64(PByte(Cardinal(Value) + 3)^);
        PUInt64(Value)^ := LUInt64;
      end;
  end;
end;



end.
