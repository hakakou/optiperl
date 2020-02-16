object ParsersMod: TParsersMod
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 316
  Top = 188
  Height = 547
  Width = 548
  object HeadParser: TSyntaxParser
    Tag = 1
    SyntaxScheme.Name = 'Def'
    SyntaxScheme.SyntaxBlocks = <
      item
        Name = 'Default'
        ID = 0
        UseMetaSymbol = True
        UseMetaToWrapLines = True
        MetaSymbol = ';'
        FIText = 0
        FIIntNum = 1
        FIFloatNum = 2
        FIHexNum = 3
        FIDirective = 4
        FISymbol = 10
        UseSymbols = True
        UseComments = True
        UseSingleLineComments = True
        UseFullLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UsePrefixedSuffixedIdentifiers = True
        UseKeywords = True
        BlockDelimiters = <>
        SingleLineCommentDelimiters = <
          item
            FontID = 6
            LeftDelimiter = ':'
          end>
        FullLineCommentDelimiters = <
          item
            FontID = 13
            LeftDelimiter = '<'
          end
          item
            FontID = 5
            LeftDelimiter = '*'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 8
            LeftDelimiter = #39
            RightDelimiter = #39
          end
          item
            FontID = 9
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end>
        IdentPrefixesSuffixes = <
          item
            LeftDelimiter = '.'
            RightDelimiter = '.'
          end>
        KeywordSets = <
          item
            FontID = 14
            Name = 'reserved'
            Keywords = 'GET,HEAD,POST'
          end>
      end>
    SyntaxScheme.FontTable = <
      item
        FontID = 0
        GlobalAttrID = 'Whitespace'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 1
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 2
        GlobalAttrID = 'Float'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 3
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 4
        GlobalAttrID = 'Defines'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 8
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 9
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 14
        GlobalAttrID = 'Reserved words'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 10
        GlobalAttrID = 'Delimiters'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 13
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 5
        GlobalAttrID = 'Search Match'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        BackColor = clAqua
        UseDefBack = False
      end
      item
        FontID = 6
        GlobalAttrID = 'Delimiters'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end>
    SyntaxScheme.SyntaxVersion = 3
    DefaultAttr.Font.Charset = DEFAULT_CHARSET
    DefaultAttr.Font.Color = clWindowText
    DefaultAttr.Font.Height = -13
    DefaultAttr.Font.Name = 'Courier New'
    DefaultAttr.Font.Style = []
    DefaultAttr.UseDefFont = True
    DefaultAttr.UseDefBack = True
    Left = 328
    Top = 352
  end
  object None: TSyntaxParser
    SyntaxScheme.SyntaxBlocks = <
      item
        Name = 'Default'
        ID = 0
        FIText = 1
        BlockDelimiters = <>
      end>
    SyntaxScheme.FontTable = <
      item
        FontID = 1
        GlobalAttrID = 'Whitespace'
        Font.Charset = SHIFTJIS_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end>
    SyntaxScheme.SyntaxVersion = 3
    DefaultAttr.Font.Charset = DEFAULT_CHARSET
    DefaultAttr.Font.Color = clWindowText
    DefaultAttr.Font.Height = -13
    DefaultAttr.Font.Name = 'Courier New'
    DefaultAttr.Font.Style = []
    DefaultAttr.UseDefFont = True
    DefaultAttr.UseDefBack = True
    Left = 104
    Top = 16
  end
  object ASP: TSyntaxParser
    SyntaxScheme.Name = 'Active Server Page'
    SyntaxScheme.SyntaxBlocks = <
      item
        Name = 'Default'
        ID = 0
        FIText = 14
        BlockDelimiters = <>
      end
      item
        Name = 'ASP (VBS)'
        ID = 1
        ParentID = 0
        FIText = 0
        FIIntNum = 1
        FIFloatNum = 2
        FIHexNum = 3
        FISymbol = 24
        UseSymbols = True
        UseComments = True
        UseSingleLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UseKeywords = True
        BlockDelimiters = <
          item
            LeftDelimiter = '<%'
            RightDelimiter = '%>'
            DelimitersArePartOfBlock = True
          end>
        SingleLineCommentDelimiters = <
          item
            FontID = 4
            LeftDelimiter = #39
          end
          item
            FontID = 5
            LeftDelimiter = 'rem'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 6
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end>
        KeywordSets = <
          item
            FontID = 7
            Name = 'reserved'
            Keywords = 
              'And,As,Attribute,Base,ByVal,Call,Case,Compare,Const,Date,Declare' +
              ',Dim,Do,Each,Else,Elseif,Empty,end,Error,Exit,Explicit,False,For' +
              ',friend,Function,get,If,Is,let,Loop,Mod,Next,Not,Nothing,Null,On' +
              ',Option,Or,Private,property,Public,ReDim,Rem,Select,Set,String,S' +
              'ub,Then,To,True,Type,Wend,While,With,Xor'
          end>
      end
      item
        Name = 'HTML'
        ID = 2
        ParentID = 0
        FIText = 15
        FIIntNum = 16
        FIFloatNum = 17
        FIHexNum = 18
        UseComments = True
        UseMultiLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UsePrefixedNumbers = True
        UseSuffixedNumbers = True
        UseMultipleNumSuffixes = False
        UsePrefixedIdentifiers = True
        BlockDelimiters = <
          item
            LeftDelimiter = '<'
            RightDelimiter = '>'
            DelimitersArePartOfBlock = True
          end>
        MultiLineCommentDelimiters = <
          item
            FontID = 19
            LeftDelimiter = '<!--'
            RightDelimiter = '-->'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 20
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end
          item
            FontID = 21
            LeftDelimiter = #39
            RightDelimiter = #39
          end>
        NumPrefixes = <
          item
            LeftDelimiter = '#'
          end>
        NumSuffixes = <
          item
            LeftDelimiter = '%'
          end>
        IdentPrefixes = <
          item
            LeftDelimiter = '/'
          end>
      end
      item
        Name = 'ASP (VBS)'
        ID = 3
        ParentID = 2
        FIText = 8
        FIIntNum = 9
        FIFloatNum = 10
        FIHexNum = 11
        FISymbol = 25
        UseSymbols = True
        UseComments = True
        UseSingleLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UseKeywords = True
        BlockDelimiters = <
          item
            LeftDelimiter = '<%'
            RightDelimiter = '%>'
            DelimitersArePartOfBlock = True
          end>
        SingleLineCommentDelimiters = <
          item
            FontID = 26
            LeftDelimiter = #39
          end
          item
            FontID = 13
            LeftDelimiter = 'rem'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 22
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end>
        KeywordSets = <
          item
            FontID = 23
            Name = 'reserved'
            Keywords = 
              'And,As,Attribute,Base,ByVal,Call,Case,Compare,Const,Date,Declare' +
              ',Dim,Do,Each,Else,Elseif,Empty,end,Error,Exit,Explicit,False,For' +
              ',friend,Function,get,If,Is,let,Loop,Mod,Next,Not,Nothing,Null,On' +
              ',Option,Or,Private,property,Public,ReDim,Rem,Select,Set,String,S' +
              'ub,Then,To,True,Type,Wend,While,With,Xor'
          end>
      end>
    SyntaxScheme.FontTable = <
      item
        FontID = 0
        GlobalAttrID = 'Script Whitespace'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 1
        GlobalAttrID = 'Script Number'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 2
        GlobalAttrID = 'Script Number'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 3
        GlobalAttrID = 'Script Number'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 4
        GlobalAttrID = 'Script Comment'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 5
        GlobalAttrID = 'Script Comment'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 6
        GlobalAttrID = 'Script String'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 7
        GlobalAttrID = 'Script ResWord'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 14
        GlobalAttrID = 'Whitespace'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 15
        GlobalAttrID = 'Html tags'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 16
        GlobalAttrID = 'Integer'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 17
        GlobalAttrID = 'Float'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 18
        GlobalAttrID = 'Integer'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 19
        GlobalAttrID = 'Comment'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 20
        GlobalAttrID = 'String'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 21
        GlobalAttrID = 'String'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 8
        GlobalAttrID = 'Script Whitespace'
        BlockID = 3
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 9
        GlobalAttrID = 'Script Number'
        BlockID = 3
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 10
        GlobalAttrID = 'Script Number'
        BlockID = 3
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 11
        GlobalAttrID = 'Script Number'
        BlockID = 3
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 26
        GlobalAttrID = 'Script Comment'
        BlockID = 3
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 13
        GlobalAttrID = 'Script Comment'
        BlockID = 3
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 22
        GlobalAttrID = 'Script String'
        BlockID = 3
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 23
        GlobalAttrID = 'Script ResWord'
        BlockID = 3
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 24
        GlobalAttrID = 'Script Delimiters'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 25
        GlobalAttrID = 'Script Delimiters'
        BlockID = 3
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end>
    SyntaxScheme.SyntaxVersion = 3
    DefaultAttr.Font.Charset = DEFAULT_CHARSET
    DefaultAttr.Font.Color = clWindowText
    DefaultAttr.Font.Height = -13
    DefaultAttr.Font.Name = 'Courier New'
    DefaultAttr.Font.Style = []
    DefaultAttr.UseDefFont = True
    DefaultAttr.UseDefBack = True
    Left = 65512
    Top = 80
  end
  object Assembler: TSyntaxParser
    SyntaxScheme.Name = 'Assembler'
    SyntaxScheme.SyntaxBlocks = <
      item
        Name = 'Default'
        ID = 0
        FIText = 0
        FIIntNum = 1
        FIFloatNum = 2
        FIHexNum = 3
        FISymbol = 10
        UseSymbols = True
        UseComments = True
        UseSingleLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UseSuffixedNumbers = True
        UseMultipleNumSuffixes = False
        UseKeywords = True
        BlockDelimiters = <>
        SingleLineCommentDelimiters = <
          item
            FontID = 4
            LeftDelimiter = ';'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 5
            LeftDelimiter = #39
            RightDelimiter = #39
          end
          item
            FontID = 6
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end>
        NumSuffixes = <
          item
            LeftDelimiter = 'h'
          end>
        KeywordSets = <
          item
            FontID = 7
            Name = 'OpCodes'
            Keywords = 
              'AAA,AAD,AAM,AAS,ADC,ADD,AND,ARPL,BOUND,BSF,BSR,BSWAP,BT,BTC,BTR,' +
              'BTS,CALL,CBW,CDQ,CLC,CLD,CLI,CLTS,CMC,CMP,CMPS,CMPSB,CMPSD,CMPSW' +
              ',CMPXCHG,CWD,CWDE,DAA,DAS,DEC,DIV,ENTER,ESC,F2XM1,FABS,FADD,FADD' +
              'P,FBLD,FBSTP,FCHS,FCLEX,FCOM,FCOMP,FCOMPP,FCOS,FDECSTP,FDISI,FDI' +
              'V,FDIVP,FDIVR,FDIVRP,FENI,FFREE,FIADD,FICOM,FICOMP,FIDIV,FIDIVR,' +
              'FILD,FIMUL,FINCSTP,FINIT,FIST,FISTP,FISUB,FISUBR,FLD,FLD1,FLDCW,' +
              'FLDENV,FLDL2E,FLDL2T,FLDLG2,FLDLN2,FLDPI,FLDZ,FMUL,FMULP,FNCLEX,' +
              'FNDISI,FNENI,FNINIT,FNOP,FNSAVE,FNSTCW,FNSTENV,FNSTSW,FPATAN,FPR' +
              'EM,FPREM1,FPTAN,FRNDINT,FRSTOR,FSAVE,FSCALE,FSETPM,FSIN,FSINCOS,' +
              'FSQRT,FST,FSTCW,FSTENV,FSTP,FSTSW,FSUB,FSUBP,FSUBR,FSUBRP,FTST,F' +
              'UCOM,FUCOMP,FUCOMPP,FWAIT,FXAM,FXCH,FXTRACT,FYL2X,FYL2XP1,HLT,ID' +
              'IV,IMUL,IN,INC,INSB,INSD,INSW,INT,INTO,INVD,INVLPG,IRET,IRETD,JA' +
              ',JAE,JB,JBE,JC,JCXZ,JE,JECXZ,JG,JGE,JL,JLE,JMP,JNA,JNAE,JNB,JNBE' +
              ',JNC,JNE,JNG,JNGE,JNL,JNLE,JNO,JNP,JNS,JNZ,JO,JP,JPE,JPO,JS,JZ,L' +
              'AHF,LAR,LDS,LEA,LEAVE,LES,LFS,LGDT,LGS,LIDT,LLDT,LMSW,LOCK,LODS,' +
              'LODSB,LODSD,LODSW,LOOP,LOOPD,LOOPDE,LOOPDNE,LOOPDNZ,LOOPDZ,LOOPE' +
              ',LOOPNE,LOOPNZ,LOOPZ,LSL,LSS,LTR,MOV,MOVS,MOVSB,MOVSD,MOVSW,MOVS' +
              'X,MOVZX,MUL,NEG,NOP,NOT,OR,OUT,OUTSB,OUTSD,OUTSW,POP,POPA,POPAD,' +
              'POPF,POPFD,PUSH,PUSHA,PUSHAD,PUSHF,PUSHFD,RCL,RCR,REP,REPE,REPNE' +
              ',REPNZ,REPZ,RET,RETF,RETN,ROL,ROR,SAHF,SAL,SAR,SBB,SCAS,SCASB,SC' +
              'ASD,SCASW,SEGCS,SEGDS,SEGES,SEGFS,SEGGS,SEGSS,SETA,SETAE,SETB,SE' +
              'TBE,SETC,SETE,SETG,SETGE,SETL,SETLE,SETNA,SETNAE,SETNB,SETNBE,SE' +
              'TNC,SETNE,SETNG,SETNGE,SETNL,SETNLE,SETNO,SETNP,SETNS,SETNZ,SETO' +
              ',SETP,SETPE,SETPO,SETS,SETZ,SGDT,SHL,SHLD,SHR,SHRD,SIDT,SLDT,SMS' +
              'W,STC,STD,STI,STOS,STOSB,STOSD,STOSW,STR,SUB,TEST,VERR,VERW,WAIT' +
              ',WBINVD,XADD,XCHG,XLAT,XOR'
          end
          item
            FontID = 8
            Name = 'Operands'
            Keywords = 
              'AH,AL,AND,AX,BH,BL,BP,BX,BYTE,CH,CL,CS,CX,DH,DI,DL,DS,DWORD,DX,E' +
              'AX,EBP,EBX,ECX,EDI,EDX,EIP,ES,ESI,ESP,FS,GS,HIGH,LOW,MOD,NOT,OFF' +
              'SET,OR,PTR,QWORD,SHL,SHR,SI,SP,SS,ST,TBYTE,TYPE,WORD,XOR'
          end
          item
            FontID = 9
            Name = 'Directives'
            Keywords = 
              'ASSUME,COMMENT,DB,DD,DQ,DT,DW,END,ENDM,ENDP,ENDS,EQ,EQU,EXITM,EX' +
              'TRN,FAR,GE,GROUP,GT,INCLUDE,LABEL,LARGE,LE,LENGTH,LOCAL,LT,MACRO' +
              ',MASK,NAME,NEAR,ORG,PAGE,PROC,PUBLIC,PURGE,RECORD,REPT,SEG,SEGME' +
              'NT,SHORT,SIZE,SMALL,STRUC,SUBTTL,SYMTYPE,THIS,TITLE,WIDTH'
          end>
      end>
    SyntaxScheme.FontTable = <
      item
        FontID = 0
        GlobalAttrID = 'Whitespace'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 1
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 2
        GlobalAttrID = 'Float'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 3
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 4
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 5
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 6
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 7
        GlobalAttrID = 'Reserved words'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 8
        GlobalAttrID = 'Reserved words'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 9
        GlobalAttrID = 'Reserved words'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 10
        GlobalAttrID = 'Delimiters'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end>
    SyntaxScheme.SyntaxVersion = 3
    DefaultAttr.Font.Charset = DEFAULT_CHARSET
    DefaultAttr.Font.Color = clWindowText
    DefaultAttr.Font.Height = -13
    DefaultAttr.Font.Name = 'Courier New'
    DefaultAttr.Font.Style = []
    DefaultAttr.UseDefFont = True
    DefaultAttr.UseDefBack = True
    Left = 416
    Top = 352
  end
  object Awk: TSyntaxParser
    SyntaxScheme.Name = 'AWK Script'
    SyntaxScheme.SyntaxBlocks = <
      item
        Name = 'Default'
        ID = 0
        UseMetaSymbol = True
        UseMetaToWrapLines = True
        MetaSymbol = '\'
        FIText = 0
        FIIntNum = 1
        FIFloatNum = 2
        FIHexNum = 3
        FISymbol = 9
        UseSymbols = True
        UseComments = True
        UseSingleLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UseKeywords = True
        BlockDelimiters = <>
        SingleLineCommentDelimiters = <
          item
            FontID = 4
            LeftDelimiter = '#'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 5
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end>
        KeywordSets = <
          item
            FontID = 6
            Name = 'Statements'
            Keywords = 
              'BEGIN,break,continue,do,else,END,exit,for,function,if,in,pattern' +
              ',return,while'
          end
          item
            FontID = 7
            Name = 'Built-in Variables'
            Keywords = 
              'ARGC,ARGIND,ARGV,CONVFMT,ENVIRON,ERRNO,FIELDWIDTHS,FILENAME,FNR,' +
              'FS,IGNORECASE,NF,NR,OFMT,OFS,ORS,RLENGTH,RS,RSTART,RT,SUBSEP'
          end
          item
            FontID = 8
            Name = 'Internal Functions'
            Keywords = 
              'atan2,close,cos,exp,fflush,gensub,getline,gsub,index,int,length,' +
              'log,match,next,nextfile,print,printf,rand,sin,split,sprintf,sqrt' +
              ',srand,strftime,sub,substr,system,systime,tolower,toupper'
          end>
      end>
    SyntaxScheme.FontTable = <
      item
        FontID = 0
        GlobalAttrID = 'Whitespace'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 1
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 2
        GlobalAttrID = 'Float'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 3
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 4
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 5
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 6
        GlobalAttrID = 'Reserved words'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 7
        GlobalAttrID = 'System Variable'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 8
        GlobalAttrID = 'System Variable'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 9
        GlobalAttrID = 'Delimiters'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end>
    SyntaxScheme.SyntaxVersion = 3
    DefaultAttr.Font.Charset = DEFAULT_CHARSET
    DefaultAttr.Font.Color = clWindowText
    DefaultAttr.Font.Height = -13
    DefaultAttr.Font.Name = 'Courier New'
    DefaultAttr.Font.Style = []
    DefaultAttr.UseDefFont = True
    DefaultAttr.UseDefBack = True
    Left = 416
    Top = 160
  end
  object C: TCPPParser
    CaseSensitive = True
    Left = 408
    Top = 96
  end
  object Clipper: TSyntaxParser
    SyntaxScheme.Name = 'Clipper'
    SyntaxScheme.SyntaxBlocks = <
      item
        Name = 'Default'
        ID = 0
        UseMetaSymbol = True
        UseMetaToWrapLines = True
        MetaSymbol = ';'
        FIText = 0
        FIIntNum = 1
        FIFloatNum = 2
        FIHexNum = 3
        FIDirective = 4
        FISymbol = 10
        UseSymbols = True
        UseLineDirectives = True
        UseComments = True
        UseSingleLineComments = True
        UseMultiLineComments = True
        UseFullLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UsePrefixedSuffixedIdentifiers = True
        UseKeywords = True
        BlockDelimiters = <>
        LineDirectivePrefix = '#'
        SingleLineCommentDelimiters = <
          item
            FontID = 5
            LeftDelimiter = '//'
          end
          item
            FontID = 15
            LeftDelimiter = '&&'
          end>
        MultiLineCommentDelimiters = <
          item
            FontID = 6
            LeftDelimiter = '/*'
            RightDelimiter = '*/'
          end>
        FullLineCommentDelimiters = <
          item
            FontID = 7
            LeftDelimiter = '*'
          end
          item
            FontID = 16
            LeftDelimiter = 'note'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 8
            LeftDelimiter = #39
            RightDelimiter = #39
          end
          item
            FontID = 9
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end>
        IdentPrefixesSuffixes = <
          item
            LeftDelimiter = '.'
            RightDelimiter = '.'
          end>
        KeywordSets = <
          item
            FontID = 14
            Name = 'reserved'
            Keywords = 
              '.and.,.f.,.not.,.or.,.t.,announce,begin,break,case,class,continu' +
              'e,declare,do,else,elseif,end,endcase,endclass,enddo,endif,endseq' +
              'uence,exit,exported,field,for,function,hidden,if,in,init,local,m' +
              'emvar,method,next,nil,note,otherwise,parameters,private,procedur' +
              'e,protected,public,recover,request,return,self,sequence,static,s' +
              'tep,then,to,using,var,while'
          end>
      end>
    SyntaxScheme.FontTable = <
      item
        FontID = 0
        GlobalAttrID = 'Whitespace'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 1
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 2
        GlobalAttrID = 'Float'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 3
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 4
        GlobalAttrID = 'Defines'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 5
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 6
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 7
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 8
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 9
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 14
        GlobalAttrID = 'Reserved words'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 15
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 16
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 10
        GlobalAttrID = 'Delimiters'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end>
    SyntaxScheme.SyntaxVersion = 3
    DefaultAttr.Font.Charset = DEFAULT_CHARSET
    DefaultAttr.Font.Color = clWindowText
    DefaultAttr.Font.Height = -13
    DefaultAttr.Font.Name = 'Courier New'
    DefaultAttr.Font.Style = []
    DefaultAttr.UseDefFont = True
    DefaultAttr.UseDefBack = True
    Left = 112
    Top = 160
  end
  object CSS1: TSyntaxParser
    SyntaxScheme.Name = 'CSS, level 1'
    SyntaxScheme.SyntaxBlocks = <
      item
        Name = 'Default'
        ID = 0
        FIText = 16
        FISymbol = 8
        UseSymbols = True
        UseComments = True
        UseMultiLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        BlockDelimiters = <>
        MultiLineCommentDelimiters = <
          item
            FontID = 17
            LeftDelimiter = '/*'
            RightDelimiter = '*/'
          end
          item
            FontID = 11
            LeftDelimiter = '<!--'
            RightDelimiter = '-->'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 10
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end>
      end
      item
        Name = 'Style'
        ID = 1
        ParentID = 0
        UseMetaSymbol = True
        UseMetaToWrapLines = False
        MetaSymbol = '\'
        FIText = 0
        FIIntNum = 1
        FIFloatNum = 2
        FIHexNum = 3
        FISymbol = 9
        UseSymbols = True
        UseComments = True
        UseMultiLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UsePrefixedNumbers = True
        UseSuffixedNumbers = True
        UseMultipleNumSuffixes = False
        UseKeywords = True
        BlockDelimiters = <
          item
            LeftDelimiter = '{'
            RightDelimiter = '}'
            DelimitersArePartOfBlock = True
          end>
        MultiLineCommentDelimiters = <
          item
            FontID = 4
            LeftDelimiter = '/*'
            RightDelimiter = '*/'
          end
          item
            FontID = 13
            LeftDelimiter = '<!--'
            RightDelimiter = '-->'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 5
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end
          item
            FontID = 6
            LeftDelimiter = #39
            RightDelimiter = #39
          end>
        NumPrefixes = <
          item
            LeftDelimiter = '#'
          end>
        NumSuffixes = <
          item
            LeftDelimiter = '%'
          end
          item
            LeftDelimiter = 'em'
          end
          item
            LeftDelimiter = 'ex'
          end
          item
            LeftDelimiter = 'px'
          end
          item
            LeftDelimiter = 'in'
          end
          item
            LeftDelimiter = 'cm'
          end
          item
            LeftDelimiter = 'mm'
          end
          item
            LeftDelimiter = 'pt'
          end
          item
            LeftDelimiter = 'pc'
          end
          item
            LeftDelimiter = 'p'
          end>
        KeywordSets = <
          item
            FontID = 7
            Name = 'properties'
            Keywords = 
              'align,attachment,auto,background,border,bottom,clear,color,decor' +
              'ation,display,family,float,font,height,image,indent,left,letter,' +
              'line,list,margin,padding,position,repeat,right,size,space,spacin' +
              'g,style,text,through,top,transform,type,variant,vertical,weight,' +
              'white,width,word'
          end>
      end>
    SyntaxScheme.FontTable = <
      item
        FontID = 0
        GlobalAttrID = 'Whitespace'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 1
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 2
        GlobalAttrID = 'Float'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 3
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 4
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 5
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 6
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 7
        GlobalAttrID = 'Reserved words'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 16
        GlobalAttrID = 'Emphasis'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 17
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 10
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 11
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 13
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 8
        GlobalAttrID = 'Emphasis'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 9
        GlobalAttrID = 'Delimiters'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end>
    SyntaxScheme.SyntaxVersion = 3
    DefaultAttr.Font.Charset = DEFAULT_CHARSET
    DefaultAttr.Font.Color = clWindowText
    DefaultAttr.Font.Height = -13
    DefaultAttr.Font.Name = 'Courier New'
    DefaultAttr.Font.Style = []
    DefaultAttr.UseDefFont = True
    DefaultAttr.UseDefBack = True
    Left = 184
    Top = 160
  end
  object CSS2: TSyntaxParser
    SyntaxScheme.Name = 'CSS, level 2'
    SyntaxScheme.SyntaxBlocks = <
      item
        Name = 'Default'
        ID = 0
        UseMetaSymbol = True
        UseMetaToWrapLines = True
        MetaSymbol = '\'
        FIText = 16
        FISymbol = 8
        UseSymbols = True
        UseComments = True
        UseMultiLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        BlockDelimiters = <>
        MultiLineCommentDelimiters = <
          item
            FontID = 17
            LeftDelimiter = '/*'
            RightDelimiter = '*/'
          end
          item
            FontID = 11
            LeftDelimiter = '<!--'
            RightDelimiter = '-->'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 10
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end>
      end
      item
        Name = 'Style'
        ID = 1
        ParentID = 0
        UseMetaSymbol = True
        UseMetaToWrapLines = False
        MetaSymbol = '\'
        FIText = 0
        FIIntNum = 1
        FIFloatNum = 2
        FIHexNum = 3
        FISymbol = 9
        UseSymbols = True
        UseComments = True
        UseMultiLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UsePrefixedNumbers = True
        UseSuffixedNumbers = True
        UseMultipleNumSuffixes = False
        UseKeywords = True
        BlockDelimiters = <
          item
            LeftDelimiter = '{'
            RightDelimiter = '}'
            DelimitersArePartOfBlock = True
          end>
        MultiLineCommentDelimiters = <
          item
            FontID = 4
            LeftDelimiter = '/*'
            RightDelimiter = '*/'
          end
          item
            FontID = 13
            LeftDelimiter = '<!--'
            RightDelimiter = '-->'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 5
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end
          item
            FontID = 6
            LeftDelimiter = #39
            RightDelimiter = #39
          end>
        NumPrefixes = <
          item
            LeftDelimiter = '#'
          end>
        NumSuffixes = <
          item
            LeftDelimiter = '%'
          end
          item
            LeftDelimiter = 'em'
          end
          item
            LeftDelimiter = 'ex'
          end
          item
            LeftDelimiter = 'px'
          end
          item
            LeftDelimiter = 'in'
          end
          item
            LeftDelimiter = 'cm'
          end
          item
            LeftDelimiter = 'mm'
          end
          item
            LeftDelimiter = 'pt'
          end
          item
            LeftDelimiter = 'pc'
          end
          item
            LeftDelimiter = 'deg'
          end
          item
            LeftDelimiter = 'grad'
          end
          item
            LeftDelimiter = 'rad'
          end
          item
            LeftDelimiter = 'ms'
          end
          item
            LeftDelimiter = 's'
          end
          item
            LeftDelimiter = 'Hz'
          end
          item
            LeftDelimiter = 'kHz'
          end
          item
            LeftDelimiter = 'p'
          end>
        KeywordSets = <
          item
            FontID = 7
            Name = 'properties'
            Keywords = 
              'align,attachment,auto,background,border,bottom,clear,color,decor' +
              'ation,display,family,float,font,height,image,indent,left,letter,' +
              'line,list,margin,padding,position,repeat,right,size,space,spacin' +
              'g,style,text,through,top,transform,type,variant,vertical,weight,' +
              'white,width,word'
          end>
      end>
    SyntaxScheme.FontTable = <
      item
        FontID = 0
        GlobalAttrID = 'Whitespace'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 1
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 2
        GlobalAttrID = 'Float'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 3
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 4
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 5
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 6
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 7
        GlobalAttrID = 'Reserved words'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 16
        GlobalAttrID = 'Emphasis'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 17
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 10
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 11
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 13
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 8
        GlobalAttrID = 'Emphasis'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 9
        GlobalAttrID = 'Delimiters'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end>
    SyntaxScheme.SyntaxVersion = 3
    DefaultAttr.Font.Charset = DEFAULT_CHARSET
    DefaultAttr.Font.Color = clWindowText
    DefaultAttr.Font.Height = -13
    DefaultAttr.Font.Name = 'Courier New'
    DefaultAttr.Font.Style = []
    DefaultAttr.UseDefFont = True
    DefaultAttr.UseDefBack = True
    Left = 256
    Top = 160
  end
  object Fortran: TSyntaxParser
    SyntaxScheme.Name = 'Fortran'
    SyntaxScheme.SyntaxBlocks = <
      item
        Name = 'Default'
        ID = 0
        FIText = 0
        FIIntNum = 1
        FIFloatNum = 2
        FIHexNum = 3
        FIDirective = 4
        FISymbol = 13
        UseSymbols = True
        UseLineDirectives = True
        UseComments = True
        UseSingleLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UsePrefixedNumbers = True
        UsePrefixedSuffixedIdentifiers = True
        UseKeywords = True
        BlockDelimiters = <>
        LineDirectivePrefix = '$'
        SingleLineCommentDelimiters = <
          item
            FontID = 5
            LeftDelimiter = '!'
          end
          item
            FontID = 6
            LeftDelimiter = 'c'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 7
            LeftDelimiter = #39
            RightDelimiter = #39
          end
          item
            FontID = 8
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end>
        NumPrefixes = <
          item
            LeftDelimiter = '#'
          end>
        IdentPrefixesSuffixes = <
          item
            LeftDelimiter = '.'
            RightDelimiter = '.'
          end>
        KeywordSets = <
          item
            FontID = 9
            Name = 'statements'
            Keywords = 
              'ALIAS,ALLOCATE,ASSIGN,AUTOMATIC,BACKSPACE,BLOCK,BYTE,C,CALL,CASE' +
              ',CHARACTER,CLOSE,COMMON,COMPLEX,CONTINUE,CYCLE,DATA,DEALLOCATE,D' +
              'IMENSION,DO,DOUBLE,ELSE,END,ENDFILE,ENTRY,EQUIVALENCE,EXIT,EXTER' +
              'NAL,FORMAT,FUNCTION,GOTO,IF,IMPLICIT,INCLUDE,INQUIRE,INTEGER,INT' +
              'RINSIC,LOCKING,LOGICAL,MAP,NAMELIST,OPEN,PARAMETER,PAUSE,PRECISI' +
              'ON,PRINT,PROGRAM,READ,REAL,RECORD,REFERENCE,RETURN,REWIND,SAVE,S' +
              'ELECT,STDCALL,STOP,STRUCTURE,SUBROUTINE,TO,UNION,VALUE,VARYING,W' +
              'HILE,WRITE'
          end
          item
            FontID = 10
            Name = 'directives'
            Keywords = 
              'ALIAS,ATTRIBUTES,DECLARE,DEFINE,DEFINED,ELSE,ELSEIF,ENDIF,FIXEDF' +
              'ORMLINESIZE,FREEFORM,IDENT,IF,INTEGER,MESSAGE,NODECLARE,NOFREEFO' +
              'RM,NOSTRICT,OBJCOMMENT,OPTIONS,PACK,PSECT,REAL,STRICT,SUBTITLE,T' +
              'ITLE,UNDEFINE'
          end
          item
            FontID = 11
            Name = 'logical'
            Keywords = 
              '.AND.,.EQ.,.EQV.,.FALSE.,.GT.,.LT.,.NEQV.,.NOT.,.OR.,.TRUE.,.XOR' +
              '.'
          end>
      end>
    SyntaxScheme.FontTable = <
      item
        FontID = 0
        GlobalAttrID = 'Whitespace'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 1
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 2
        GlobalAttrID = 'Float'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 3
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 4
        GlobalAttrID = 'Defines'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 5
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 6
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 7
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 8
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 9
        GlobalAttrID = 'Reserved words'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 10
        GlobalAttrID = 'Reserved words'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 11
        GlobalAttrID = 'Reserved words'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 13
        GlobalAttrID = 'Delimiters'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end>
    SyntaxScheme.SyntaxVersion = 3
    DefaultAttr.Font.Charset = DEFAULT_CHARSET
    DefaultAttr.Font.Color = clWindowText
    DefaultAttr.Font.Height = -13
    DefaultAttr.Font.Name = 'Courier New'
    DefaultAttr.Font.Style = []
    DefaultAttr.UseDefFont = True
    DefaultAttr.UseDefBack = True
    Left = 40
    Top = 224
  end
  object FoxPro: TSyntaxParser
    SyntaxScheme.Name = 'FoxPro'
    SyntaxScheme.SyntaxBlocks = <
      item
        Name = 'Default'
        ID = 0
        FIText = 0
        FIIntNum = 1
        FIFloatNum = 2
        FIHexNum = 3
        FIDirective = 4
        FISymbol = 14
        UseSymbols = True
        UseLineDirectives = True
        UseComments = True
        UseSingleLineComments = True
        UseFullLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UseSuffixedNumbers = True
        UseMultipleNumSuffixes = False
        UsePrefixedSuffixedIdentifiers = True
        UseKeywords = True
        BlockDelimiters = <>
        LineDirectivePrefix = '#'
        SingleLineCommentDelimiters = <
          item
            FontID = 5
            LeftDelimiter = '&&'
          end>
        FullLineCommentDelimiters = <
          item
            FontID = 6
            LeftDelimiter = '*'
          end
          item
            FontID = 7
            LeftDelimiter = 'c'
          end
          item
            FontID = 8
            LeftDelimiter = '/'
          end
          item
            FontID = 9
            LeftDelimiter = '???'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 10
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end
          item
            FontID = 11
            LeftDelimiter = #39
            RightDelimiter = #39
          end>
        NumSuffixes = <
          item
            LeftDelimiter = 'f'
          end>
        IdentPrefixesSuffixes = <
          item
            LeftDelimiter = '.'
            RightDelimiter = '.'
          end>
        KeywordSets = <
          item
            FontID = 15
            Name = 'Commands'
            Keywords = 
              'ACCEPT,ACTIVATE,ADD,ALL,ALTER,ALTERNATE,ANSI,APLABOUT,APP,APPEND' +
              ',ARRAY,AS,ASSIST,AUTOSAVE,AVERAGE,BAR,BEGIN,BELL,BLANK,BLINK,BLO' +
              'CKSIZE,BORDER,BOX,BROWSE,BRSTATUS,BUILD,CALCULATE,CALL,CANCEL,CA' +
              'RRY,CASE,CD,CENTURY,CHANGE,CHDIR,CLASS,CLASSLIB,CLEAR,CLOCK,CLOS' +
              'E,COLLATE,COLOR,COMMAND,COMPATIBLE,COMPILE,CONFIRM,CONNECTION,CO' +
              'NNECTIONS,CONSOLE,CONTINUE,COPY,COUNT,CPCOMPILE,CPDIALOG,CREATE,' +
              'CURRENCY,CURSOR,DATA,DATABASE,DATABASES,DATASESSION,DATE,DEACTIV' +
              'ATE,DEBUG,DECIMALS,DECLARE,DEFAULT,DEFINE,DELETE,DELETED,DELIMIT' +
              'ERS,DEVELOPMENT,DEVICE,DIMENSION,DIR,DIRECTORY,DISPLAY,DLLS,DO,D' +
              'OHISTORY,ECHO,EDIT,EJECT,ELSE,END,ENDCASE,ENDDEFINE,ENDDO,ENDFOR' +
              ',ENDFUNC,ENDIF,ENDPRINTJOB,ENDPROC,ENDSCAN,ENDWITH,ERASE,ERROR,E' +
              'SCAPE,EVENTS,EXACT,EXCLUSIVE,EXE,EXIT,EXPORT,EXTENDED,EXTERNAL,F' +
              'DOW,FIELDS,FILE,FILER,FILES,FILTER,FIND,FIXED,FLUSH,FOR,FORM,FOR' +
              'MAT,FREE,FROM,FULLPATH,FUNCTION,FWEEK,GATHER,GENERAL,GET,GETEXPR' +
              ',GETS,GO,GOTO,HEADINGS,HELP,HELPFILTER,HIDE,HOURS,ID,IF,IMPORT,I' +
              'NDEX,INDEXES,INPUT,INSERT,INTENSITY,JOIN,KEY,KEYBOARD,KEYCOMP,LA' +
              'BEL,LIBRARY,LIST,LOAD,LOCAL,LOCATE,LOCK,LOGERRORS,LPARAMETERS,MA' +
              'CDESKTOP,MACHELP,MACKEY,MACRO,MACROS,MARGIN,MARK,MD,MEMO,MEMORY,' +
              'MEMOWIDTH,MENU,MENUS,MESSAGE,MKDIR,MODIFY,MODULE,MOUSE,MOVE,MULT' +
              'ILOCKS,NEAR,NOCPTRANS,NOTE,NOTIFY,NULL,OBJECT,OBJECTS,ODOMETER,O' +
              'F,OFF,OLEOBJECT,ON,OPEN,OPTIMIZE,or,ORDER,OTHERWISE,PACK,PAD,PAG' +
              'E,PALETTE,PARAMETERS,PATH,PDSETUP,PLAY,POINT,POP,POPUP,POPUPS,PR' +
              'INTER,PRINTJOB,PRIVATE,PROCEDURE,PROCEDURES,PROJECT,PUBLIC,PUSH,' +
              'QUERY,QUIT,RD,READ,READBORDER,READERROR,RECALL,REFRESH,REGIONAL,' +
              'REINDEX,RELATION,RELEASE,REMOVE,RENAME,REPLACE,REPORT,REPROCESS,' +
              'RESOURCE,RESTORE,RESUME,RETRY,RETURN,RMDIR,ROLLBACK,RUN,RUNSCRIP' +
              'T,s,SAFETY,SAVE,SCAN,SCATTER,SCHEME,SCOREBOARD,SCREEN,SCROLL,SEC' +
              'ONDS,SEEK,SELECT,SELECTION,SEPARATOR,SET,SHADOWS,SHOW,SHUTDOWN,S' +
              'IZE,SKIP,SORT,SPACE,SQL,STATUS,STEP,STICKY,STORE,string$,STRUCTU' +
              'RE,SUM,SUSPEND,SYSFORMATS,SYSMENU,TABLE,TABLES,TAG,TALK,TEXTMERG' +
              'E,TO,TOPIC,TOTAL,TRANSACTION,TRBETWEEN,TRIGGER,TYPE,TYPEAHEAD,UD' +
              'FPARMS,UNIQUE,UNLOCK,UPDATE,USE,VALIDATE,VIEW,VIEWS,VOLUME,WAIT,' +
              'WHILE,WINDOW,WINDOWS,WITH,XCMDFILE,ZAP,ZOOM'
          end
          item
            FontID = 13
            Name = 'Logical'
            Keywords = '.AND.,.F.,.N.,.NOT.,.NULL.,.OR.,.T.,.Y.'
          end>
      end>
    SyntaxScheme.FontTable = <
      item
        FontID = 0
        GlobalAttrID = 'Whitespace'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 1
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 2
        GlobalAttrID = 'Float'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 3
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 4
        GlobalAttrID = 'Defines'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 5
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 6
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 7
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 8
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clPurple
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 9
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clPurple
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 10
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 11
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 15
        GlobalAttrID = 'Reserved words'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 13
        GlobalAttrID = 'Reserved words'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 14
        GlobalAttrID = 'Delimiters'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end>
    SyntaxScheme.SyntaxVersion = 3
    DefaultAttr.Font.Charset = DEFAULT_CHARSET
    DefaultAttr.Font.Color = clWindowText
    DefaultAttr.Font.Height = -13
    DefaultAttr.Font.Name = 'Courier New'
    DefaultAttr.Font.Style = []
    DefaultAttr.UseDefFont = True
    DefaultAttr.UseDefBack = True
    Left = 112
    Top = 224
  end
  object HTML: THTMLParser
    Left = 168
    Top = 88
  end
  object Ini: TSyntaxParser
    SyntaxScheme.Name = 'INI files'
    SyntaxScheme.SyntaxBlocks = <
      item
        Name = 'Default'
        ID = 0
        FIText = 0
        FISymbol = 4
        UseSymbols = True
        UseComments = True
        UseSingleLineComments = True
        UseFullLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        BlockDelimiters = <>
        SingleLineCommentDelimiters = <
          item
            FontID = 1
            LeftDelimiter = '='
          end>
        FullLineCommentDelimiters = <
          item
            FontID = 2
            LeftDelimiter = ';'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 3
            LeftDelimiter = '['
            RightDelimiter = ']'
          end>
      end>
    SyntaxScheme.FontTable = <
      item
        FontID = 0
        GlobalAttrID = 'Reserved words'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 1
        GlobalAttrID = 'Whitespace'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 2
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 3
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 4
        GlobalAttrID = 'Delimiters'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end>
    SyntaxScheme.SyntaxVersion = 3
    DefaultAttr.Font.Charset = DEFAULT_CHARSET
    DefaultAttr.Font.Color = clWindowText
    DefaultAttr.Font.Height = -13
    DefaultAttr.Font.Name = 'Courier New'
    DefaultAttr.Font.Style = []
    DefaultAttr.UseDefFont = True
    DefaultAttr.UseDefBack = True
    Left = 184
    Top = 224
  end
  object Java: TSyntaxParser
    SyntaxScheme.Name = 'Java'
    SyntaxScheme.SyntaxBlocks = <
      item
        Name = 'Default'
        ID = 0
        CaseSensitive = True
        UseMetaSymbol = True
        UseMetaToWrapLines = True
        MetaSymbol = '\'
        FIText = 0
        FIIntNum = 1
        FIFloatNum = 2
        FIHexNum = 3
        FISymbol = 9
        UseSymbols = True
        UseComments = True
        UseSingleLineComments = True
        UseMultiLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UsePrefixedNumbers = True
        UseSuffixedNumbers = True
        UseMultipleNumSuffixes = False
        UsePrefixedSuffixedNumbers = True
        UsePSNumComposition = True
        UseKeywords = True
        BlockDelimiters = <>
        SingleLineCommentDelimiters = <
          item
            FontID = 4
            LeftDelimiter = '//'
          end>
        MultiLineCommentDelimiters = <
          item
            FontID = 5
            LeftDelimiter = '/*'
            RightDelimiter = '*/'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 6
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end
          item
            FontID = 7
            LeftDelimiter = #39
            RightDelimiter = #39
          end>
        NumPrefixes = <
          item
            LeftDelimiter = '0x'
          end
          item
            LeftDelimiter = '0X'
          end>
        NumSuffixes = <
          item
            LeftDelimiter = 'l'
          end
          item
            LeftDelimiter = 'L'
          end
          item
            LeftDelimiter = 'f'
          end
          item
            LeftDelimiter = 'F'
          end
          item
            LeftDelimiter = 'd'
          end
          item
            LeftDelimiter = 'D'
          end>
        NumPrefixesSuffixes = <>
        KeywordSets = <
          item
            FontID = 8
            Name = 'keywords'
            Keywords = 
              'abstract,boolean,break,byte,case,catch,char,class,const,continue' +
              ',default,do,double,else,extends,false,final,finally,float,for,go' +
              'to,if,implements,import,instanceof,int,interface,long,native,new' +
              ',null,package,private,protected,public,return,short,static,super' +
              ',switch,synchronized,this,throw,throws,transient,true,try,void,v' +
              'olatile,while'
          end>
      end>
    SyntaxScheme.FontTable = <
      item
        FontID = 0
        GlobalAttrID = 'Whitespace'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 1
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 2
        GlobalAttrID = 'Float'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 3
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 4
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 5
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 6
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 7
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 8
        GlobalAttrID = 'Reserved words'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 9
        GlobalAttrID = 'Delimiters'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end>
    SyntaxScheme.SyntaxVersion = 3
    DefaultAttr.Font.Charset = DEFAULT_CHARSET
    DefaultAttr.Font.Color = clWindowText
    DefaultAttr.Font.Height = -13
    DefaultAttr.Font.Name = 'Courier New'
    DefaultAttr.Font.Style = []
    DefaultAttr.UseDefFont = True
    DefaultAttr.UseDefBack = True
    Left = 256
    Top = 224
  end
  object JavaScriptHTML: TSyntaxParser
    SyntaxScheme.Name = 'JavaScript in HTML'
    SyntaxScheme.SyntaxBlocks = <
      item
        Name = 'Default'
        ID = 0
        FIText = 16
        BlockDelimiters = <>
      end
      item
        Name = 'JS'
        ID = 1
        ParentID = 0
        CaseSensitive = True
        UseMetaSymbol = True
        UseMetaToWrapLines = True
        MetaSymbol = '\'
        FIText = 0
        FIIntNum = 1
        FIFloatNum = 2
        FIHexNum = 3
        FIDirective = 4
        FISymbol = 10
        UseSymbols = True
        UseComments = True
        UseSingleLineComments = True
        UseMultiLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UsePrefixedNumbers = True
        UseKeywords = True
        BlockDelimiters = <
          item
            LeftDelimiter = '<script language="jscript">'
            RightDelimiter = '</script>'
          end
          item
            LeftDelimiter = '<script language="javascript">'
            RightDelimiter = '</script>'
          end
          item
            LeftDelimiter = '<script language=javascript>'
            RightDelimiter = '</script>'
          end
          item
            LeftDelimiter = '<script language=jscript>'
            RightDelimiter = '</script>'
          end>
        SingleLineCommentDelimiters = <
          item
            FontID = 5
            LeftDelimiter = '//'
          end>
        MultiLineCommentDelimiters = <
          item
            FontID = 6
            LeftDelimiter = '/*'
            RightDelimiter = '*/'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 7
            LeftDelimiter = #39
            RightDelimiter = #39
          end
          item
            FontID = 8
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end>
        NumPrefixes = <
          item
            LeftDelimiter = '0x'
          end
          item
            LeftDelimiter = '0X'
          end>
        KeywordSets = <
          item
            FontID = 9
            Name = 'reserved'
            Keywords = 
              'break,case,catch,class,const,continue,debugger,default,delete,do' +
              ',else,enum,export,extends,false,finally,for,function,if,import,i' +
              'n,new,null,return,super,switch,this,throw,true,try,typeof,var,vo' +
              'id,while,with'
          end>
      end
      item
        Name = 'HTML'
        ID = 2
        ParentID = 0
        FIText = 33
        FIIntNum = 34
        FIFloatNum = 35
        FIHexNum = 36
        UseComments = True
        UseMultiLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UsePrefixedNumbers = True
        UseSuffixedNumbers = True
        UseMultipleNumSuffixes = False
        UsePrefixedIdentifiers = True
        BlockDelimiters = <
          item
            LeftDelimiter = '<'
            RightDelimiter = '>'
            DelimitersArePartOfBlock = True
          end>
        MultiLineCommentDelimiters = <
          item
            FontID = 37
            LeftDelimiter = '<!--'
            RightDelimiter = '-->'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 38
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end
          item
            FontID = 39
            LeftDelimiter = #39
            RightDelimiter = #39
          end>
        NumPrefixes = <
          item
            LeftDelimiter = '#'
          end>
        NumSuffixes = <
          item
            LeftDelimiter = '%'
          end>
        IdentPrefixes = <
          item
            LeftDelimiter = '/'
          end>
      end>
    SyntaxScheme.FontTable = <
      item
        FontID = 0
        GlobalAttrID = 'Script Whitespace'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 1
        GlobalAttrID = 'Script Number'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 2
        GlobalAttrID = 'Script Number'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 3
        GlobalAttrID = 'Script Number'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 4
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 5
        GlobalAttrID = 'Script Comment'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 6
        GlobalAttrID = 'Script Comment'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 7
        GlobalAttrID = 'Script String'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 8
        GlobalAttrID = 'Script String'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 9
        GlobalAttrID = 'Script ResWord'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 16
        GlobalAttrID = 'Whitespace'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 33
        GlobalAttrID = 'Html tags'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 34
        GlobalAttrID = 'Integer'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 35
        GlobalAttrID = 'Float'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 36
        GlobalAttrID = 'Integer'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 37
        GlobalAttrID = 'Comment'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 38
        GlobalAttrID = 'String'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 39
        GlobalAttrID = 'String'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 10
        GlobalAttrID = 'Script Delimiters'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end>
    SyntaxScheme.SyntaxVersion = 3
    DefaultAttr.Font.Charset = DEFAULT_CHARSET
    DefaultAttr.Font.Color = clWindowText
    DefaultAttr.Font.Height = -13
    DefaultAttr.Font.Name = 'Courier New'
    DefaultAttr.Font.Style = []
    DefaultAttr.UseDefFont = True
    DefaultAttr.UseDefBack = True
    Left = 328
    Top = 224
  end
  object MicrosoftIDL: TSyntaxParser
    SyntaxScheme.Name = 'Microsoft IDL'
    SyntaxScheme.SyntaxBlocks = <
      item
        Name = 'Default'
        ID = 0
        CaseSensitive = True
        FIText = 0
        FIIntNum = 1
        FIFloatNum = 2
        FIHexNum = 3
        FIDirective = 4
        FISymbol = 7
        UseSymbols = True
        UseLineDirectives = True
        UseComments = True
        UseSingleLineComments = True
        UseMultiLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UsePrefixedNumbers = True
        UseKeywords = True
        BlockDelimiters = <>
        LineDirectivePrefix = '#'
        SingleLineCommentDelimiters = <
          item
            FontID = 5
            LeftDelimiter = '//'
          end>
        MultiLineCommentDelimiters = <
          item
            FontID = 6
            LeftDelimiter = '/*'
            RightDelimiter = '*/'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 8
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end
          item
            FontID = 9
            LeftDelimiter = 'uuid('
            RightDelimiter = ')'
          end
          item
            FontID = 9
            LeftDelimiter = 'uuid ('
            RightDelimiter = ')'
          end>
        NumPrefixes = <
          item
            LeftDelimiter = '0x'
          end
          item
            LeftDelimiter = '0X'
          end>
        KeywordSets = <
          item
            FontID = 10
            Name = 'reserved'
            Keywords = 
              '__int3264,__int64,aggregatable,allocate,appobject,arrays,async,a' +
              'sync_uuid,auto_handle,bindable,boolean,broadcast,byte,byte_count' +
              ',call_as,callback,char,coclass,code,comm_status,const,context_ha' +
              'ndle,context_handle_noserialize,context_handle_serialize,control' +
              ',cpp_quote,custom,decode,default,defaultbind,defaultcollelem,def' +
              'aultvalue,defaultvtable,dispinterface,displaybind,dllname,double' +
              ',dual,enable_allocate,encode,endpoint,entry,enum,error_status_t,' +
              'explicit_handle,fault_status,first_is,float,handle,handle_t,heap' +
              ',helpcontext,helpfile,helpstring,helpstringcontext,helpstringdll' +
              ',hidden,hyper,id,idempotent,ignore,iid_is,immediatebind,implicit' +
              '_handle,import,importlib,in,in_line,include,int,interface,last_i' +
              's,lcid,length_is,library,licensed,local,long,max_is,maybe,messag' +
              'e,midl_pragma,midl_user_allocate,midl_user_free,min_is,module,ms' +
              '_union,ncacn_at_dsp,ncacn_dnet_nsp,ncacn_http,ncacn_ip_tcp,ncacn' +
              '_nb_ipx,ncacn_nb_nb,ncacn_nb_tcp,ncacn_np,ncacn_spx,ncacn_vns_sp' +
              'p,ncadg_ip_udp,ncadg_ipx,ncadg_mq,ncalrpc,nocode,nonbrowsable,no' +
              'ncreatable,nonextensible,notify,object,odl,oleautomation,optimiz' +
              'e,optional,out,out_of_line,pipe,pointer_default,propget,propput,' +
              'propputref,ptr,public,range,readonly,ref,represent_as,requestedi' +
              't,restricted,retval,shape,short,signed,size_is,small,source,stri' +
              'ct_context_handle,string,struct,switch,switch_is,switch_type,tra' +
              'nsmit_as,typedef,uidefault,union,unique,unsigned,user_marshal,us' +
              'esgetlasterror,uuid,v1_enum,vararg,version,void,warning,wchar_t,' +
              'wire_marshal'
          end>
      end>
    SyntaxScheme.FontTable = <
      item
        FontID = 0
        GlobalAttrID = 'Whitespace'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 1
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 2
        GlobalAttrID = 'Float'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 3
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 4
        GlobalAttrID = 'Defines'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 5
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 6
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 8
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 10
        GlobalAttrID = 'Reserved words'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 9
        GlobalAttrID = 'Reserved words'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 7
        GlobalAttrID = 'Delimiters'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end>
    SyntaxScheme.SyntaxVersion = 3
    DefaultAttr.Font.Charset = DEFAULT_CHARSET
    DefaultAttr.Font.Color = clWindowText
    DefaultAttr.Font.Height = -13
    DefaultAttr.Font.Name = 'Courier New'
    DefaultAttr.Font.Style = []
    DefaultAttr.UseDefFont = True
    DefaultAttr.UseDefBack = True
    Left = 40
    Top = 296
  end
  object Modula2: TSyntaxParser
    SyntaxScheme.Name = 'Modula-2'
    SyntaxScheme.SyntaxBlocks = <
      item
        Name = 'Default'
        ID = 0
        CaseSensitive = True
        FIText = 0
        FIIntNum = 1
        FIFloatNum = 2
        FIHexNum = 3
        FISymbol = 16
        UseSymbols = True
        UseComments = True
        UseMultiLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UseSuffixedNumbers = True
        UseMultipleNumSuffixes = False
        UseKeywords = True
        BlockDelimiters = <>
        MultiLineCommentDelimiters = <
          item
            FontID = 4
            LeftDelimiter = '(*'
            RightDelimiter = '*)'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 5
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end>
        NumSuffixes = <
          item
            LeftDelimiter = 'X'
          end
          item
            LeftDelimiter = 'L'
          end>
        KeywordSets = <
          item
            FontID = 6
            Name = 'reserved'
            Keywords = 
              'ARRAY,ASM,BEGIN,BOOLEAN,BY,CARDINAL,CASE,CHAR,CLASS,CONST,DEFINI' +
              'TION,DESTROY,DIV,DO,ELSE,ELSIF,END,EXIT,EXPORT,FOR,FOREIGN,FROM,' +
              'IF,IMPLEMENTATION,IMPORT,INHERIT,INIT,INLINE,INTEGER,LONGCARD,LO' +
              'NGINT,LONGREAL,LOOP,MOD,MODULE,NIL,OF,POINTER,PROCEDURE,REAL,REC' +
              'ORD,REPEAT,RETURN,SET,THEN,TO,TYPE,UNTIL,VAR,WHILE,WITH'
          end>
      end
      item
        Name = 'Assembler'
        ID = 1
        ParentID = 0
        CaseSensitive = True
        FIText = 7
        FIIntNum = 8
        FIFloatNum = 9
        FIHexNum = 10
        UseComments = True
        UseMultiLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UseSuffixedNumbers = True
        UseMultipleNumSuffixes = False
        UsePrefixedIdentifiers = True
        UseKeywords = True
        BlockDelimiters = <
          item
            LeftDelimiter = 'ASM'
            RightDelimiter = 'END'
          end>
        MultiLineCommentDelimiters = <
          item
            FontID = 11
            LeftDelimiter = '(*'
            RightDelimiter = '*)'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 17
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end>
        NumSuffixes = <
          item
            LeftDelimiter = 'X'
          end
          item
            LeftDelimiter = 'L'
          end>
        IdentPrefixes = <
          item
            LeftDelimiter = '@'
          end>
        KeywordSets = <
          item
            FontID = 13
            Name = 'OpCodes'
            Keywords = 
              'AAA,AAD,AAM,AAS,ADC,ADD,AND,ARPL,BOUND,BSF,BSR,BSWAP,BT,BTC,BTR,' +
              'BTS,CALL,CBW,CDQ,CLC,CLD,CLI,CLTS,CMC,CMP,CMPS,CMPSB,CMPSD,CMPSW' +
              ',CMPXCHG,CWD,CWDE,DAA,DAS,DEC,DIV,ENTER,ESC,F2XM1,FABS,FADD,FADD' +
              'P,FBLD,FBSTP,FCHS,FCLEX,FCOM,FCOMP,FCOMPP,FCOS,FDECSTP,FDISI,FDI' +
              'V,FDIVP,FDIVR,FDIVRP,FENI,FFREE,FIADD,FICOM,FICOMP,FIDIV,FIDIVR,' +
              'FILD,FIMUL,FINCSTP,FINIT,FIST,FISTP,FISUB,FISUBR,FLD,FLD1,FLDCW,' +
              'FLDENV,FLDL2E,FLDL2T,FLDLG2,FLDLN2,FLDPI,FLDZ,FMUL,FMULP,FNCLEX,' +
              'FNDISI,FNENI,FNINIT,FNOP,FNSAVE,FNSTCW,FNSTENV,FNSTSW,FPATAN,FPR' +
              'EM,FPREM1,FPTAN,FRNDINT,FRSTOR,FSAVE,FSCALE,FSETPM,FSIN,FSINCOS,' +
              'FSQRT,FST,FSTCW,FSTENV,FSTP,FSTSW,FSUB,FSUBP,FSUBR,FSUBRP,FTST,F' +
              'UCOM,FUCOMP,FUCOMPP,FWAIT,FXAM,FXCH,FXTRACT,FYL2X,FYL2XP1,HLT,ID' +
              'IV,IMUL,IN,INC,INSB,INSD,INSW,INT,INTO,INVD,INVLPG,IRET,IRETD,JA' +
              ',JAE,JB,JBE,JC,JCXZ,JE,JECXZ,JG,JGE,JL,JLE,JMP,JNA,JNAE,JNB,JNBE' +
              ',JNC,JNE,JNG,JNGE,JNL,JNLE,JNO,JNP,JNS,JNZ,JO,JP,JPE,JPO,JS,JZ,L' +
              'AHF,LAR,LDS,LEA,LEAVE,LES,LFS,LGDT,LGS,LIDT,LLDT,LMSW,LOCK,LODS,' +
              'LODSB,LODSD,LODSW,LOOP,LOOPD,LOOPDE,LOOPDNE,LOOPDNZ,LOOPDZ,LOOPE' +
              ',LOOPNE,LOOPNZ,LOOPZ,LSL,LSS,LTR,MOV,MOVS,MOVSB,MOVSD,MOVSW,MOVS' +
              'X,MOVZX,MUL,NEG,NOP,NOT,OR,OUT,OUTSB,OUTSD,OUTSW,POP,POPA,POPAD,' +
              'POPF,POPFD,PUSH,PUSHA,PUSHAD,PUSHF,PUSHFD,RCL,RCR,REP,REPE,REPNE' +
              ',REPNZ,REPZ,RET,RETF,RETN,ROL,ROR,SAHF,SAL,SAR,SBB,SCAS,SCASB,SC' +
              'ASD,SCASW,SEGCS,SEGDS,SEGES,SEGFS,SEGGS,SEGSS,SETA,SETAE,SETB,SE' +
              'TBE,SETC,SETE,SETG,SETGE,SETL,SETLE,SETNA,SETNAE,SETNB,SETNBE,SE' +
              'TNC,SETNE,SETNG,SETNGE,SETNL,SETNLE,SETNO,SETNP,SETNS,SETNZ,SETO' +
              ',SETP,SETPE,SETPO,SETS,SETZ,SGDT,SHL,SHLD,SHR,SHRD,SIDT,SLDT,SMS' +
              'W,STC,STD,STI,STOS,STOSB,STOSD,STOSW,STR,SUB,TEST,VERR,VERW,WAIT' +
              ',WBINVD,XADD,XCHG,XLAT,XOR'
          end
          item
            FontID = 14
            Name = 'Operands'
            Keywords = 
              'AH,AL,AND,AX,BH,BL,BP,BX,BYTE,CH,CL,CS,CX,DH,DI,DL,DS,DWORD,DX,E' +
              'AX,EBP,EBX,ECX,EDI,EDX,EIP,ES,ESI,ESP,FS,GS,HIGH,LOW,MOD,NOT,OFF' +
              'SET,OR,PTR,QWORD,SHL,SHR,SI,SP,SS,ST,TBYTE,TYPE,WORD,XOR'
          end
          item
            FontID = 15
            Name = 'Directives'
            Keywords = 'DB,DD,DW'
          end>
      end>
    SyntaxScheme.FontTable = <
      item
        FontID = 0
        GlobalAttrID = 'Whitespace'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 1
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 2
        GlobalAttrID = 'Float'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 3
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 4
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 5
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 6
        GlobalAttrID = 'Reserved words'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 7
        GlobalAttrID = 'Assembler'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 8
        GlobalAttrID = 'Assembler'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 9
        GlobalAttrID = 'Assembler'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 10
        GlobalAttrID = 'Assembler'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 11
        GlobalAttrID = 'Comment'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 17
        GlobalAttrID = 'String'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 13
        GlobalAttrID = 'Assembler'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 14
        GlobalAttrID = 'Assembler'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 15
        GlobalAttrID = 'Assembler'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 16
        GlobalAttrID = 'Delimiters'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end>
    SyntaxScheme.SyntaxVersion = 3
    DefaultAttr.Font.Charset = DEFAULT_CHARSET
    DefaultAttr.Font.Color = clWindowText
    DefaultAttr.Font.Height = -13
    DefaultAttr.Font.Name = 'Courier New'
    DefaultAttr.Font.Style = []
    DefaultAttr.UseDefFont = True
    DefaultAttr.UseDefBack = True
    Left = 112
    Top = 296
  end
  object MSDOSBat: TSyntaxParser
    SyntaxScheme.Name = 'MS-DOS Batch Language'
    SyntaxScheme.SyntaxBlocks = <
      item
        Name = 'Default'
        ID = 0
        FIText = 0
        FIIntNum = 1
        FIFloatNum = 2
        FIHexNum = 3
        FISymbol = 8
        UseSymbols = True
        UseComments = True
        UseSingleLineComments = True
        UseFullLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UseKeywords = True
        BlockDelimiters = <>
        SingleLineCommentDelimiters = <
          item
            FontID = 4
            LeftDelimiter = 'rem'
          end>
        FullLineCommentDelimiters = <
          item
            FontID = 5
            LeftDelimiter = ':'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 7
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end>
        KeywordSets = <
          item
            FontID = 6
            Name = 'commands'
            Keywords = 
              'call,do,echo,errorlevel,exist,for,goto,if,in,not,pause,rem,set,s' +
              'hift'
          end>
      end>
    SyntaxScheme.FontTable = <
      item
        FontID = 0
        GlobalAttrID = 'Whitespace'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 1
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 2
        GlobalAttrID = 'Float'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 3
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 4
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 5
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 6
        GlobalAttrID = 'Reserved words'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 7
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 8
        GlobalAttrID = 'Delimiters'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end>
    SyntaxScheme.SyntaxVersion = 3
    DefaultAttr.Font.Charset = DEFAULT_CHARSET
    DefaultAttr.Font.Color = clWindowText
    DefaultAttr.Font.Height = -13
    DefaultAttr.Font.Name = 'Courier New'
    DefaultAttr.Font.Style = []
    DefaultAttr.UseDefFont = True
    DefaultAttr.UseDefBack = True
    Left = 40
    Top = 160
  end
  object Oberon: TSyntaxParser
    SyntaxScheme.Name = 'Oberon'
    SyntaxScheme.SyntaxBlocks = <
      item
        Name = 'Default'
        ID = 0
        CaseSensitive = True
        FIText = 0
        FIIntNum = 3
        FIFloatNum = 4
        FIHexNum = 5
        FISymbol = 7
        UseSymbols = True
        UseComments = True
        UseMultiLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UseSuffixedNumbers = True
        UseMultipleNumSuffixes = False
        UseKeywords = True
        BlockDelimiters = <>
        MultiLineCommentDelimiters = <
          item
            FontID = 1
            LeftDelimiter = '(*'
            RightDelimiter = '*)'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 2
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end>
        NumSuffixes = <
          item
            LeftDelimiter = 'H'
          end
          item
            LeftDelimiter = 'X'
          end>
        KeywordSets = <
          item
            FontID = 6
            Name = 'reserved'
            Keywords = 
              'ARRAY,BEGIN,CASE,CONST,DIV,DO,ELSE,ELSIF,END,EXIT,IF,IMPORT,IN,I' +
              'S,LOOP,MOD,MODULE,NIL,OF,OR,POINTER,PROCEDURE,RECORD,REPEAT,RETU' +
              'RN,THEN,TO,TYPE,UNTIL,VAR,WHILE,WITH'
          end>
      end>
    SyntaxScheme.FontTable = <
      item
        FontID = 0
        GlobalAttrID = 'Whitespace'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 1
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 2
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 3
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 4
        GlobalAttrID = 'Float'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 5
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 6
        GlobalAttrID = 'Reserved words'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 7
        GlobalAttrID = 'Delimiters'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end>
    SyntaxScheme.SyntaxVersion = 3
    DefaultAttr.Font.Charset = DEFAULT_CHARSET
    DefaultAttr.Font.Color = clWindowText
    DefaultAttr.Font.Height = -13
    DefaultAttr.Font.Name = 'Courier New'
    DefaultAttr.Font.Style = []
    DefaultAttr.UseDefFont = True
    DefaultAttr.UseDefBack = True
    Left = 184
    Top = 296
  end
  object Pascal: TDelphiParser
    Left = 248
    Top = 88
  end
  object Perl: THKPerlParser
    HTMLParser = HTML
    Left = 32
    Top = 16
  end
  object PHP: TSyntaxParser
    SyntaxScheme.Name = 'PHP in HTML'
    SyntaxScheme.SyntaxBlocks = <
      item
        Name = 'Default'
        ID = 0
        FIText = 17
        BlockDelimiters = <>
      end
      item
        Name = 'PHP'
        ID = 1
        ParentID = 0
        CaseSensitive = True
        UseMetaSymbol = True
        UseMetaToWrapLines = True
        MetaSymbol = '\'
        FIText = 0
        FIIntNum = 1
        FIFloatNum = 2
        FIHexNum = 3
        FISymbol = 11
        UseSymbols = True
        UseComments = True
        UseSingleLineComments = True
        UseMultiLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UsePrefixedNumbers = True
        UseKeywords = True
        BlockDelimiters = <
          item
            LeftDelimiter = '<?'
            RightDelimiter = '?>'
            DelimitersArePartOfBlock = True
          end
          item
            LeftDelimiter = '<%'
            RightDelimiter = '%>'
            DelimitersArePartOfBlock = True
          end
          item
            LeftDelimiter = '<script language="php">'
            RightDelimiter = '</script>'
          end>
        SingleLineCommentDelimiters = <
          item
            FontID = 4
            LeftDelimiter = '//'
          end
          item
            FontID = 5
            LeftDelimiter = '#'
          end>
        MultiLineCommentDelimiters = <
          item
            FontID = 6
            LeftDelimiter = '/*'
            RightDelimiter = '*/'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 7
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end
          item
            FontID = 8
            LeftDelimiter = #39
            RightDelimiter = #39
          end
          item
            FontID = 9
            LeftDelimiter = '`'
            RightDelimiter = '`'
          end>
        NumPrefixes = <
          item
            LeftDelimiter = '0x'
          end>
        KeywordSets = <
          item
            FontID = 10
            Name = 'keywords'
            Keywords = 
              'break,case,class,continue,default,do,else,elseif,endfor,endif,en' +
              'dswitch,endwhile,extends,for,function,global,if,int,old_function' +
              ',pval,return,static,string,switch,var,void,while'
          end>
      end
      item
        Name = 'HTML'
        ID = 2
        ParentID = 0
        FIText = 36
        FIIntNum = 37
        FIFloatNum = 38
        FIHexNum = 39
        UseComments = True
        UseMultiLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UsePrefixedNumbers = True
        UseSuffixedNumbers = True
        UseMultipleNumSuffixes = False
        UsePrefixedIdentifiers = True
        BlockDelimiters = <
          item
            LeftDelimiter = '<'
            RightDelimiter = '>'
            DelimitersArePartOfBlock = True
          end>
        MultiLineCommentDelimiters = <
          item
            FontID = 40
            LeftDelimiter = '<!--'
            RightDelimiter = '-->'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 41
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end
          item
            FontID = 42
            LeftDelimiter = #39
            RightDelimiter = #39
          end>
        NumPrefixes = <
          item
            LeftDelimiter = '#'
          end>
        NumSuffixes = <
          item
            LeftDelimiter = '%'
          end>
        IdentPrefixes = <
          item
            LeftDelimiter = '/'
          end>
      end>
    SyntaxScheme.FontTable = <
      item
        FontID = 0
        GlobalAttrID = 'Script Whitespace'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 1
        GlobalAttrID = 'Script Number'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 2
        GlobalAttrID = 'Script Number'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 3
        GlobalAttrID = 'Script Number'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 4
        GlobalAttrID = 'Script Comment'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 5
        GlobalAttrID = 'Script Comment'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 6
        GlobalAttrID = 'Script Comment'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 7
        GlobalAttrID = 'Script String'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 8
        GlobalAttrID = 'Script String'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 9
        GlobalAttrID = 'Script String'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 10
        GlobalAttrID = 'Script ResWord'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 17
        GlobalAttrID = 'Whitespace'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 36
        GlobalAttrID = 'Html tags'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 37
        GlobalAttrID = 'Integer'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 38
        GlobalAttrID = 'Float'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 39
        GlobalAttrID = 'Integer'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 40
        GlobalAttrID = 'Comment'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 41
        GlobalAttrID = 'String'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 42
        GlobalAttrID = 'String'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 11
        GlobalAttrID = 'Script Delimiters'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end>
    SyntaxScheme.SyntaxVersion = 3
    DefaultAttr.Font.Charset = DEFAULT_CHARSET
    DefaultAttr.Font.Color = clWindowText
    DefaultAttr.Font.Height = -13
    DefaultAttr.Font.Name = 'Courier New'
    DefaultAttr.Font.Style = []
    DefaultAttr.UseDefFont = True
    DefaultAttr.UseDefBack = True
    Left = 256
    Top = 296
  end
  object Python: TPythonParser
    Left = 104
    Top = 88
  end
  object RC: TSyntaxParser
    SyntaxScheme.Name = 'Resource .RC Files'
    SyntaxScheme.SyntaxBlocks = <
      item
        Name = 'Default'
        ID = 0
        FIText = 0
        FIIntNum = 1
        FIFloatNum = 2
        FIHexNum = 3
        FIDirective = 4
        FISymbol = 10
        UseSymbols = True
        UseLineDirectives = True
        UseComments = True
        UseSingleLineComments = True
        UseMultiLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UsePrefixedNumbers = True
        UseSuffixedNumbers = True
        UseMultipleNumSuffixes = False
        UsePrefixedSuffixedNumbers = True
        UsePSNumComposition = True
        UseKeywords = True
        BlockDelimiters = <>
        LineDirectivePrefix = '#'
        SingleLineCommentDelimiters = <
          item
            FontID = 9
            LeftDelimiter = '//'
          end>
        MultiLineCommentDelimiters = <
          item
            FontID = 5
            LeftDelimiter = '/*'
            RightDelimiter = '*/'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 6
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end
          item
            FontID = 7
            LeftDelimiter = #39
            RightDelimiter = #39
          end>
        NumPrefixes = <
          item
            LeftDelimiter = '0x'
          end>
        NumSuffixes = <
          item
            LeftDelimiter = 'L'
          end>
        NumPrefixesSuffixes = <>
        KeywordSets = <
          item
            FontID = 8
            Name = 'reserved'
            Keywords = 
              'ACCELERATORS,ALT,ASCII,AUTO3STATE,AUTOCHECKBOX,AUTORADIOBUTTON,B' +
              'ITMAP,BLOCK,CAPTION,CHARACTERISTICS,CHECKBOX,CHECKED,CLASS,COMBO' +
              'BOX,CONTROL,CTEXT,CURSOR,DEFPUSHBUTTON,DIALOG,DIALOGEX,DISCARDAB' +
              'LE,DLGINIT,EDITTEXT,EXSTYLE,FILEFLAGS,FILEFLAGSMASK,FILEOS,FILES' +
              'UBTYPE,FILETYPE,FILEVERSION,FIXED,FONT,GRAYED,GROUPBOX,HELP,ICON' +
              ',IMPURE,INACTIVE,LANGUAGE,LISTBOX,LOADONCALL,LTEXT,MENU,MENUBARB' +
              'REAK,MENUBREAK,MENUEX,MENUITEM,MESSAGETABLE,MOVEABLE,NOINVERT,NO' +
              'NDISCARDABLE,NONSHARED,POPUP,PRELOAD,PRODUCTVERSION,PURE,PUSHBOX' +
              ',PUSHBUTTON,RADIOBUTTON,RCDATA,RTEXT,SCROLLBAR,SEPARATOR,SHARED,' +
              'SHIFT,STATE3,STRINGTABLE,STYLE,USERBUTTON,VALUE,VERSION,VERSIONI' +
              'NFO,VIRTKEY'
          end>
      end>
    SyntaxScheme.FontTable = <
      item
        FontID = 0
        GlobalAttrID = 'Whitespace'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 1
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 2
        GlobalAttrID = 'Float'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 3
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 4
        GlobalAttrID = 'Defines'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 5
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 6
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 7
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 8
        GlobalAttrID = 'Reserved words'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 9
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 10
        GlobalAttrID = 'Delimiters'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end>
    SyntaxScheme.SyntaxVersion = 3
    DefaultAttr.Font.Charset = DEFAULT_CHARSET
    DefaultAttr.Font.Color = clWindowText
    DefaultAttr.Font.Height = -13
    DefaultAttr.Font.Name = 'Courier New'
    DefaultAttr.Font.Style = []
    DefaultAttr.UseDefFont = True
    DefaultAttr.UseDefBack = True
    Left = 40
    Top = 352
  end
  object Sql: TSqlParser
    Left = 40
    Top = 88
  end
  object TclTK: TSyntaxParser
    SyntaxScheme.Name = 'Tcl/Tk'
    SyntaxScheme.SyntaxBlocks = <
      item
        Name = 'Default'
        ID = 0
        UseMetaSymbol = True
        UseMetaToWrapLines = True
        MetaSymbol = '\'
        FIText = 0
        FIIntNum = 1
        FIFloatNum = 2
        FIHexNum = 3
        FISymbol = 7
        UseSymbols = True
        UseComments = True
        UseFullLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UseSuffixedNumbers = True
        UseMultipleNumSuffixes = False
        UsePrefixedIdentifiers = True
        UseKeywords = True
        BlockDelimiters = <>
        FullLineCommentDelimiters = <
          item
            FontID = 4
            LeftDelimiter = '#'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 5
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end>
        NumSuffixes = <
          item
            LeftDelimiter = 'c'
          end
          item
            LeftDelimiter = 'i'
          end
          item
            LeftDelimiter = 'm'
          end>
        IdentPrefixes = <
          item
            LeftDelimiter = '$'
          end>
        KeywordSets = <
          item
            FontID = 6
            Name = 'commands'
            Keywords = 
              'AFTER,APPEND,ARRAY,BELL,BGERROR,BINARY,BIND,BINDIDPROC,BINDPROC,' +
              'BINDTAGS,BITMAP,BREAK,BUTTON,CANVAS,CATCH,CD,CHECKBUTTON,CLIPBOA' +
              'RD,CLOCK,CLOSE,CONCAT,CONTINUE,DESTROY,ELSE,ENTRY,EOF,ERROR,EVAL' +
              ',EVENT,EXEC,EXIT,EXPR,FBLOCKED,FCONFIGURE,FCOPY,FILE,FILEEVENT,F' +
              'ILENAME,FLUSH,FOCUS,FONT,FOR,FOREACH,FORMAT,FRAME,GETS,GLOB,GLOB' +
              'AL,GRAB,GRID,HISTORY,HTTP,IF,IMAGE,INCR,INFO,INTERP,JOIN,LABEL,L' +
              'APPEND,LIBRARY,LINDEX,LINSERT,LIST,LISTBOX,LLENGTH,LOAD,LOADTK,L' +
              'OWER,LRANGE,LREPLACE,LSEARCH,LSORT,MENU,MESSAGE,NAMESPACE,NAMESP' +
              'UPD,OPEN,OPTION,OPTIONS,PACK,PACKAGE,PHOTO,PID,PKG_MKINDEX,PLACE' +
              ',PROC,PUTS,PWD,RADIOBUTTON,RAISE,READ,REGEXP,REGISTRY,REGSUB,REN' +
              'AME,RESOURCE,RETURN,RGB,SAFEBASE,SCALE,SCAN,SEEK,SELECTION,SEND,' +
              'SENDOUT,SET,SOCKET,SOURCE,SPLIT,STRING,SUBST,SWITCH,TCL,TCLVARS,' +
              'TELL,TEXT,THEN,TIME,TK,TK_BISQUE,TK_CHOOSECOLOR,TK_DIALOG,TK_FOC' +
              'USFOLLOWSMOUSE,TK_FOCUSNEXT,TK_FOCUSPREV,TK_GETOPENFILE,TK_GETSA' +
              'VEFILE,TK_MESSAGEBOX,TK_OPTIONMENU,TK_POPUP,TK_SETPALETTE,TKERRO' +
              'R,TKVARS,TKWAIT,TOPLEVEL,TRACE,UNKNOWN,UNSET,UPDATE,UPLEVEL,UPVA' +
              'R,VARIABLE,VWAIT,WHILE,WINFO,WM'
          end>
        OtherIdentChars = '.0-9A-Z_a-z'
      end>
    SyntaxScheme.FontTable = <
      item
        FontID = 0
        GlobalAttrID = 'Whitespace'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 1
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 2
        GlobalAttrID = 'Float'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 3
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 4
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 5
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 6
        GlobalAttrID = 'Reserved words'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 7
        GlobalAttrID = 'Delimiters'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end>
    SyntaxScheme.SyntaxVersion = 3
    DefaultAttr.Font.Charset = DEFAULT_CHARSET
    DefaultAttr.Font.Color = clWindowText
    DefaultAttr.Font.Height = -13
    DefaultAttr.Font.Name = 'Courier New'
    DefaultAttr.Font.Style = []
    DefaultAttr.UseDefFont = True
    DefaultAttr.UseDefBack = True
    Left = 184
    Top = 352
  end
  object VBScriptHTML: TSyntaxParser
    SyntaxScheme.Name = 'VBScript in HTML'
    SyntaxScheme.SyntaxBlocks = <
      item
        Name = 'Default'
        ID = 0
        FIText = 14
        BlockDelimiters = <>
      end
      item
        Name = 'VBS'
        ID = 1
        ParentID = 0
        FIText = 0
        FIIntNum = 1
        FIFloatNum = 2
        FIHexNum = 3
        FISymbol = 8
        UseSymbols = True
        UseComments = True
        UseSingleLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UseKeywords = True
        BlockDelimiters = <
          item
            LeftDelimiter = '<script language="vbscript">'
            RightDelimiter = '</script>'
          end>
        SingleLineCommentDelimiters = <
          item
            FontID = 4
            LeftDelimiter = #39
          end
          item
            FontID = 5
            LeftDelimiter = 'rem'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 6
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end>
        KeywordSets = <
          item
            FontID = 7
            Name = 'reserved'
            Keywords = 
              'And,As,Attribute,Base,ByVal,Call,Case,Compare,Const,Date,Declare' +
              ',Dim,Do,Each,Else,Elseif,Empty,end,Error,Exit,Explicit,False,For' +
              ',friend,Function,get,If,Is,let,Loop,Mod,Next,Not,Nothing,Null,On' +
              ',Option,Or,Private,property,Public,ReDim,Rem,Select,Set,String,S' +
              'ub,Then,To,True,Type,Wend,While,With,Xor'
          end>
      end
      item
        Name = 'HTML'
        ID = 2
        ParentID = 0
        FIText = 34
        FIIntNum = 35
        FIFloatNum = 36
        FIHexNum = 37
        UseComments = True
        UseMultiLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UsePrefixedNumbers = True
        UseSuffixedNumbers = True
        UseMultipleNumSuffixes = False
        UsePrefixedIdentifiers = True
        BlockDelimiters = <
          item
            LeftDelimiter = '<'
            RightDelimiter = '>'
            DelimitersArePartOfBlock = True
          end>
        MultiLineCommentDelimiters = <
          item
            FontID = 38
            LeftDelimiter = '<!--'
            RightDelimiter = '-->'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 39
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end
          item
            FontID = 40
            LeftDelimiter = #39
            RightDelimiter = #39
          end>
        NumPrefixes = <
          item
            LeftDelimiter = '#'
          end>
        NumSuffixes = <
          item
            LeftDelimiter = '%'
          end>
        IdentPrefixes = <
          item
            LeftDelimiter = '/'
          end>
      end>
    SyntaxScheme.FontTable = <
      item
        FontID = 0
        GlobalAttrID = 'Script Whitespace'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 1
        GlobalAttrID = 'Script Number'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 2
        GlobalAttrID = 'Script Number'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 3
        GlobalAttrID = 'Script Number'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 4
        GlobalAttrID = 'Script Comment'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 5
        GlobalAttrID = 'Script Comment'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 6
        GlobalAttrID = 'Script String'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 7
        GlobalAttrID = 'Script ResWord'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 14
        GlobalAttrID = 'Whitespace'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 34
        GlobalAttrID = 'Html tags'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 35
        GlobalAttrID = 'Integer'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 36
        GlobalAttrID = 'Float'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 37
        GlobalAttrID = 'Integer'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 38
        GlobalAttrID = 'Comment'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 39
        GlobalAttrID = 'String'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 40
        GlobalAttrID = 'String'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 8
        GlobalAttrID = 'Script Delimiters'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end>
    SyntaxScheme.SyntaxVersion = 3
    DefaultAttr.Font.Charset = DEFAULT_CHARSET
    DefaultAttr.Font.Color = clWindowText
    DefaultAttr.Font.Height = -13
    DefaultAttr.Font.Name = 'Courier New'
    DefaultAttr.Font.Style = []
    DefaultAttr.UseDefFont = True
    DefaultAttr.UseDefBack = True
    Left = 416
    Top = 296
  end
  object VBScript: TVBScriptParser
    Left = 344
    Top = 88
  end
  object VisualBasic: TSyntaxParser
    SyntaxScheme.Name = 'Visual Basic'
    SyntaxScheme.SyntaxBlocks = <
      item
        Name = 'Default'
        ID = 0
        FIText = 0
        FIIntNum = 1
        FIFloatNum = 2
        FIHexNum = 3
        FIDirective = 4
        FISymbol = 9
        UseSymbols = True
        UseLineDirectives = True
        UseComments = True
        UseSingleLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UseSuffixedIdentifiers = True
        UseKeywords = True
        BlockDelimiters = <>
        LineDirectivePrefix = '#'
        SingleLineCommentDelimiters = <
          item
            FontID = 5
            LeftDelimiter = #39
          end
          item
            FontID = 6
            LeftDelimiter = 'rem'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 7
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end>
        IdentSuffixes = <
          item
            LeftDelimiter = '$'
          end>
        KeywordSets = <
          item
            FontID = 8
            Name = 'reserved'
            Keywords = 
              'addressof,and,appactivate,as,base,beep,binary,byref,byval,call,c' +
              'ase,chdir,chdrive,close,compare,const,date,declare,deftype,delet' +
              'esetting,dim,do,each,else,empty,end,enum,eqv,erase,error,event,e' +
              'xit,explicit,false,filecopy,for,friend,function,get,gosub,goto,i' +
              'f,imp,implements,input,is,kill,len,let,like,line,load,lock,loop,' +
              'lset,me,mid,mkdir,mod,name,new,next,not,nothing,null,on,open,opt' +
              'ion,optional,or,paramarray,print,private,property,public,put,rai' +
              'seevent,randomize,redim,rem,reset,resume,return,rmdir,rset,savep' +
              'icture,savesetting,seek,select,sendkeys,set,setattr,static,step,' +
              'stop,string,sub,then,time,to,true,type,unload,unlock,wend,while,' +
              'width,with,withevents,write,xor'
          end>
      end>
    SyntaxScheme.FontTable = <
      item
        FontID = 0
        GlobalAttrID = 'Whitespace'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 1
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 2
        GlobalAttrID = 'Float'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 3
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 4
        GlobalAttrID = 'Defines'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 5
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 6
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 7
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 8
        GlobalAttrID = 'Reserved words'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 9
        GlobalAttrID = 'Delimiters'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end>
    SyntaxScheme.SyntaxVersion = 3
    DefaultAttr.Font.Charset = DEFAULT_CHARSET
    DefaultAttr.Font.Color = clWindowText
    DefaultAttr.Font.Height = -13
    DefaultAttr.Font.Name = 'Courier New'
    DefaultAttr.Font.Style = []
    DefaultAttr.UseDefFont = True
    DefaultAttr.UseDefBack = True
    Left = 328
    Top = 160
  end
  object UnixShell: TSyntaxParser
    SyntaxScheme.Name = 'Unix Shell'
    SyntaxScheme.SyntaxBlocks = <
      item
        Name = 'Default'
        ID = 0
        CaseSensitive = True
        UseMetaSymbol = True
        UseMetaToWrapLines = True
        MetaSymbol = '\'
        FIText = 1
        FIIntNum = 7
        FIFloatNum = 8
        FIHexNum = 9
        FISymbol = 2
        UseSymbols = True
        UseComments = True
        UseSingleLineComments = True
        UseMultiLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UsePrefixedNumbers = True
        UsePrefixedIdentifiers = True
        UseKeywords = True
        BlockDelimiters = <>
        SingleLineCommentDelimiters = <
          item
            FontID = 3
            LeftDelimiter = '#'
          end>
        MultiLineCommentDelimiters = <
          item
            FontID = 11
            LeftDelimiter = '<<EOF'
            RightDelimiter = 'EOF'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 4
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end
          item
            FontID = 5
            LeftDelimiter = #39
            RightDelimiter = #39
          end
          item
            FontID = 6
            LeftDelimiter = '`'
            RightDelimiter = '`'
          end>
        NumPrefixes = <
          item
            LeftDelimiter = '0x'
          end
          item
            LeftDelimiter = '0X'
          end>
        IdentPrefixes = <
          item
            LeftDelimiter = '$'
          end>
        KeywordSets = <
          item
            FontID = 10
            Name = 'reserved'
            Keywords = 
              'alias,bg,bind,break,builtin,case,cd,command,continue,declare,dir' +
              's,disown,do,done,echo,elif,else,enable,esac,eval,exec,exit,expor' +
              't,fc,fg,fi,for,function,getopts,hash,help,history,if,in,jobs,kil' +
              'l,let,local,logout,popd,printf,pushd,pwd,read,readonly,return,se' +
              'lect,set,shift,shopt,suspend,test,then,time,times,trap,type,type' +
              'set,ulimit,umask,unalias,unset,until,wait,while'
          end>
        FirstIdentChars = '.-/A-Z_a-z~'
        OtherIdentChars = '.-9A-Z_a-z~'
      end>
    SyntaxScheme.FontTable = <
      item
        FontID = 1
        GlobalAttrID = 'Whitespace'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 2
        GlobalAttrID = 'Delimiters'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 3
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 4
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 5
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 6
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 7
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 8
        GlobalAttrID = 'Float'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 9
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 10
        GlobalAttrID = 'Reserved words'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 11
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end>
    SyntaxScheme.SyntaxVersion = 3
    DefaultAttr.Font.Charset = DEFAULT_CHARSET
    DefaultAttr.Font.Color = clWindowText
    DefaultAttr.Font.Height = -13
    DefaultAttr.Font.Name = 'Courier New'
    DefaultAttr.Font.Style = []
    DefaultAttr.UseDefFont = True
    DefaultAttr.UseDefBack = True
    Left = 112
    Top = 352
  end
  object XML: TSyntaxParser
    SyntaxScheme.Name = 'XML'
    SyntaxScheme.SyntaxBlocks = <
      item
        Name = 'Default'
        ID = 0
        FIText = 0
        BlockDelimiters = <>
      end
      item
        Name = 'SpecialTags'
        ID = 2
        ParentID = 0
        FIText = 8
        BlockDelimiters = <
          item
            LeftDelimiter = '<?'
            RightDelimiter = '?>'
            DelimitersArePartOfBlock = True
          end
          item
            LeftDelimiter = '<![CDATA['
            RightDelimiter = ']]>'
            DelimitersArePartOfBlock = True
          end>
      end
      item
        Name = 'Tags'
        ID = 1
        ParentID = 0
        FIText = 1
        FIIdentifier = 7
        UseComments = True
        UseMultiLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        BlockDelimiters = <
          item
            LeftDelimiter = '<'
            RightDelimiter = '>'
            DelimitersArePartOfBlock = True
          end>
        MultiLineCommentDelimiters = <
          item
            FontID = 5
            LeftDelimiter = '<!--'
            RightDelimiter = '-->'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 6
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end>
      end>
    SyntaxScheme.FontTable = <
      item
        FontID = 0
        GlobalAttrID = 'Whitespace'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 1
        GlobalAttrID = 'Html tags'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 5
        GlobalAttrID = 'Comment'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 6
        GlobalAttrID = 'String'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 7
        GlobalAttrID = 'Identifier'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 8
        GlobalAttrID = 'Html tags'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end>
    SyntaxScheme.SyntaxVersion = 3
    DefaultAttr.Font.Charset = DEFAULT_CHARSET
    DefaultAttr.Font.Color = clWindowText
    DefaultAttr.Font.Height = -13
    DefaultAttr.Font.Name = 'Courier New'
    DefaultAttr.Font.Style = []
    DefaultAttr.UseDefFont = True
    DefaultAttr.UseDefBack = True
    Left = 256
    Top = 352
  end
  object XMLScripts: TSyntaxParser
    SyntaxScheme.Name = 'XML with Scripts'
    SyntaxScheme.SyntaxBlocks = <
      item
        Name = 'Default'
        ID = 0
        FIText = 0
        BlockDelimiters = <>
      end
      item
        Name = 'CDATA'
        ID = 2
        ParentID = 0
        FIText = 8
        BlockDelimiters = <
          item
            LeftDelimiter = '<![CDATA['
            RightDelimiter = ']]>'
            DelimitersArePartOfBlock = True
          end>
      end
      item
        Name = 'Text'
        ID = 3
        ParentID = 2
        FIText = 11
        BlockDelimiters = <
          item
            LeftDelimiter = '<![CDATA['
            RightDelimiter = ']]>'
          end>
      end
      item
        Name = 'JS'
        ID = 6
        ParentID = 0
        CaseSensitive = True
        UseMetaSymbol = True
        UseMetaToWrapLines = True
        MetaSymbol = '\'
        FIText = 31
        FIIntNum = 32
        FIFloatNum = 33
        FIHexNum = 34
        FISymbol = 45
        UseSymbols = True
        UseComments = True
        UseSingleLineComments = True
        UseMultiLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UsePrefixedNumbers = True
        UseKeywords = True
        BlockDelimiters = <
          item
            LeftDelimiter = '<script language="jscript">'
            RightDelimiter = '</script>'
          end
          item
            LeftDelimiter = '<script language="javascript">'
            RightDelimiter = '</script>'
          end>
        SingleLineCommentDelimiters = <
          item
            FontID = 36
            LeftDelimiter = '//'
          end>
        MultiLineCommentDelimiters = <
          item
            FontID = 37
            LeftDelimiter = '/*'
            RightDelimiter = '*/'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 38
            LeftDelimiter = #39
            RightDelimiter = #39
          end
          item
            FontID = 39
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end>
        NumPrefixes = <
          item
            LeftDelimiter = '0x'
          end
          item
            LeftDelimiter = '0X'
          end>
        KeywordSets = <
          item
            FontID = 40
            Name = 'reserved'
            Keywords = 
              'break,case,catch,class,const,continue,debugger,default,delete,do' +
              ',else,enum,export,extends,false,finally,for,function,if,import,i' +
              'n,new,null,return,super,switch,this,throw,true,try,typeof,var,vo' +
              'id,while,with'
          end>
      end
      item
        Name = 'VBS'
        ID = 5
        ParentID = 0
        FIText = 23
        FIIntNum = 24
        FIFloatNum = 25
        FIHexNum = 26
        FISymbol = 44
        UseSymbols = True
        UseComments = True
        UseSingleLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UseKeywords = True
        BlockDelimiters = <
          item
            LeftDelimiter = '<script language="vbscript">'
            RightDelimiter = '</script>'
          end
          item
            LeftDelimiter = '<%'
            RightDelimiter = '%>'
            DelimitersArePartOfBlock = True
          end>
        SingleLineCommentDelimiters = <
          item
            FontID = 27
            LeftDelimiter = #39
          end
          item
            FontID = 28
            LeftDelimiter = 'rem'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 29
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end>
        KeywordSets = <
          item
            FontID = 30
            Name = 'reserved'
            Keywords = 
              'And,As,Attribute,Base,ByVal,Call,Case,Compare,Const,Date,Declare' +
              ',Dim,Do,Each,Else,Elseif,Empty,end,Error,Exit,Explicit,False,For' +
              ',friend,Function,get,If,Is,let,Loop,Mod,Next,Not,Nothing,Null,On' +
              ',Option,Or,Private,property,Public,ReDim,Rem,Select,Set,String,S' +
              'ub,Then,To,True,Type,Wend,While,With,Xor'
          end>
      end
      item
        Name = 'PHP'
        ID = 4
        ParentID = 0
        CaseSensitive = True
        UseMetaSymbol = True
        UseMetaToWrapLines = True
        MetaSymbol = '\'
        FIText = 3
        FIIntNum = 13
        FIFloatNum = 14
        FIHexNum = 15
        FISymbol = 43
        UseSymbols = True
        UseComments = True
        UseSingleLineComments = True
        UseMultiLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UsePrefixedNumbers = True
        UseKeywords = True
        BlockDelimiters = <
          item
            LeftDelimiter = '<?php'
            RightDelimiter = '?>'
            DelimitersArePartOfBlock = True
          end
          item
            LeftDelimiter = '<script language="php">'
            RightDelimiter = '</script>'
          end>
        SingleLineCommentDelimiters = <
          item
            FontID = 16
            LeftDelimiter = '//'
          end
          item
            FontID = 17
            LeftDelimiter = '#'
          end>
        MultiLineCommentDelimiters = <
          item
            FontID = 18
            LeftDelimiter = '/*'
            RightDelimiter = '*/'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 19
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end
          item
            FontID = 20
            LeftDelimiter = #39
            RightDelimiter = #39
          end
          item
            FontID = 21
            LeftDelimiter = '`'
            RightDelimiter = '`'
          end>
        NumPrefixes = <
          item
            LeftDelimiter = '0x'
          end>
        KeywordSets = <
          item
            FontID = 22
            Name = 'keywords'
            Keywords = 
              'break,case,class,continue,default,do,else,elseif,endfor,endif,en' +
              'dswitch,endwhile,extends,for,function,global,if,int,old_function' +
              ',pval,return,static,string,switch,var,void,while'
          end>
      end
      item
        Name = 'Tags'
        ID = 1
        ParentID = 0
        FIText = 1
        FIIntNum = 41
        FIFloatNum = 46
        FIHexNum = 47
        FIIdentifier = 7
        UseComments = True
        UseMultiLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UseKeywords = True
        BlockDelimiters = <
          item
            LeftDelimiter = '<'
            RightDelimiter = '>'
            DelimitersArePartOfBlock = True
          end>
        MultiLineCommentDelimiters = <
          item
            FontID = 5
            LeftDelimiter = '<!--'
            RightDelimiter = '-->'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 6
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end>
        KeywordSets = <
          item
            FontID = 2
            Name = 'NameSpace'
            Keywords = 'ee,xsl,xwl'
          end
          item
            FontID = 10
            Name = 'Attributes'
            Keywords = 'source,target'
          end>
      end>
    SyntaxScheme.FontTable = <
      item
        FontID = 0
        GlobalAttrID = 'Whitespace'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 1
        GlobalAttrID = 'Html tags'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 5
        GlobalAttrID = 'Comment'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 6
        GlobalAttrID = 'String'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 7
        GlobalAttrID = 'Identifier'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 8
        GlobalAttrID = 'Html tags'
        BlockID = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 2
        GlobalAttrID = 'Reserved words'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clPurple
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 11
        GlobalAttrID = 'Html tags'
        BlockID = 3
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        BackColor = clAqua
      end
      item
        FontID = 10
        GlobalAttrID = 'Emphasis'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clFuchsia
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 3
        GlobalAttrID = 'Script Whitespace'
        BlockID = 4
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 13
        GlobalAttrID = 'Script Number'
        BlockID = 4
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 14
        GlobalAttrID = 'Script Number'
        BlockID = 4
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 15
        GlobalAttrID = 'Script Number'
        BlockID = 4
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 16
        GlobalAttrID = 'Script Comment'
        BlockID = 4
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 17
        GlobalAttrID = 'Script Comment'
        BlockID = 4
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 18
        GlobalAttrID = 'Script Comment'
        BlockID = 4
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 19
        GlobalAttrID = 'Script String'
        BlockID = 4
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 20
        GlobalAttrID = 'Script String'
        BlockID = 4
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 21
        GlobalAttrID = 'Script String'
        BlockID = 4
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 22
        GlobalAttrID = 'Script ResWord'
        BlockID = 4
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 23
        GlobalAttrID = 'Script Whitespace'
        BlockID = 5
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 24
        GlobalAttrID = 'Script Number'
        BlockID = 5
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 25
        GlobalAttrID = 'Script Number'
        BlockID = 5
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 26
        GlobalAttrID = 'Script Number'
        BlockID = 5
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 27
        GlobalAttrID = 'Script Comment'
        BlockID = 5
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 28
        GlobalAttrID = 'Script Comment'
        BlockID = 5
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 29
        GlobalAttrID = 'Script String'
        BlockID = 5
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 30
        GlobalAttrID = 'Script ResWord'
        BlockID = 5
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 31
        GlobalAttrID = 'Script Whitespace'
        BlockID = 6
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 32
        GlobalAttrID = 'Script Number'
        BlockID = 6
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 33
        GlobalAttrID = 'Script Number'
        BlockID = 6
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 34
        GlobalAttrID = 'Script Number'
        BlockID = 6
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 36
        GlobalAttrID = 'Script Comment'
        BlockID = 6
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 37
        GlobalAttrID = 'Script Comment'
        BlockID = 6
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 38
        GlobalAttrID = 'Script String'
        BlockID = 6
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 39
        GlobalAttrID = 'Script String'
        BlockID = 6
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 40
        GlobalAttrID = 'Script ResWord'
        BlockID = 6
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 41
        GlobalAttrID = 'Integer'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 43
        GlobalAttrID = 'Script Delimiters'
        BlockID = 4
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 44
        GlobalAttrID = 'Script Delimiters'
        BlockID = 5
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 45
        GlobalAttrID = 'Script Delimiters'
        BlockID = 6
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 46
        GlobalAttrID = 'Float'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 47
        GlobalAttrID = 'Integer'
        BlockID = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end>
    SyntaxScheme.SyntaxVersion = 3
    DefaultAttr.Font.Charset = DEFAULT_CHARSET
    DefaultAttr.Font.Color = clWindowText
    DefaultAttr.Font.Height = -13
    DefaultAttr.Font.Name = 'Courier New'
    DefaultAttr.Font.Style = []
    DefaultAttr.UseDefFont = True
    DefaultAttr.UseDefBack = True
    Left = 328
    Top = 296
  end
  object JavaScript: TSyntaxParser
    SyntaxScheme.Name = 'JavaScript'
    SyntaxScheme.SyntaxBlocks = <
      item
        Name = 'Default'
        ID = 0
        CaseSensitive = True
        UseMetaSymbol = True
        UseMetaToWrapLines = True
        MetaSymbol = '\'
        FIText = 0
        FIIntNum = 1
        FIFloatNum = 2
        FIHexNum = 3
        FISymbol = 9
        UseSymbols = True
        UseComments = True
        UseSingleLineComments = True
        UseMultiLineComments = True
        UseStrings = True
        UseSingleLineStrings = True
        UseNumbers = True
        UsePrefixedNumbers = True
        UseKeywords = True
        BlockDelimiters = <>
        SingleLineCommentDelimiters = <
          item
            FontID = 4
            LeftDelimiter = '//'
          end>
        MultiLineCommentDelimiters = <
          item
            FontID = 5
            LeftDelimiter = '/*'
            RightDelimiter = '*/'
          end>
        SingleLineStringDelimiters = <
          item
            FontID = 6
            LeftDelimiter = #39
            RightDelimiter = #39
          end
          item
            FontID = 7
            LeftDelimiter = '"'
            RightDelimiter = '"'
          end>
        NumPrefixes = <
          item
            LeftDelimiter = '0x'
          end
          item
            LeftDelimiter = '0X'
          end>
        KeywordSets = <
          item
            FontID = 8
            Name = 'reserved'
            Keywords = 
              'break,case,catch,class,const,continue,debugger,default,delete,do' +
              ',else,enum,export,extends,false,finally,for,function,if,import,i' +
              'n,new,null,return,super,switch,this,throw,true,try,typeof,var,vo' +
              'id,while,with'
          end>
      end>
    SyntaxScheme.FontTable = <
      item
        FontID = 0
        GlobalAttrID = 'Whitespace'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 1
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 2
        GlobalAttrID = 'Float'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 3
        GlobalAttrID = 'Integer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 4
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 5
        GlobalAttrID = 'Comment'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
      end
      item
        FontID = 6
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 7
        GlobalAttrID = 'String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end
      item
        FontID = 8
        GlobalAttrID = 'Reserved words'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
      end
      item
        FontID = 9
        GlobalAttrID = 'Delimiters'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
      end>
    SyntaxScheme.SyntaxVersion = 3
    DefaultAttr.Font.Charset = DEFAULT_CHARSET
    DefaultAttr.Font.Color = clWindowText
    DefaultAttr.Font.Height = -13
    DefaultAttr.Font.Name = 'Courier New'
    DefaultAttr.Font.Style = []
    DefaultAttr.UseDefFont = True
    DefaultAttr.UseDefBack = True
    Left = 416
    Top = 224
  end
end
